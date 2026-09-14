#!/usr/bin/env python3
###############################################################################
# Driver for the FlyDSL bf16 grouped-GEMM target test matrix on gfx1250.
#
# See LICENSE of Primus-Turbo for the license of the reused benchmark helpers.
###############################################################################

"""Benchmark the MoE grouped-GEMM target matrix, one row per (shape, direction).

``bench_grouped_gemm_turbo.py`` sweeps ``MoEModelConfigs`` x EP x M and reports a
single lumped "Backward TFLOPS" for dgrad+wgrad together. The matrix we have to
reproduce needs the two backward operators separated, needs MFU, and needs the
shapes pinned to EP=8 with specific avg_m values. So this driver keeps turbo's
timing and reference helpers and only replaces the case table and the reporting.

The three measured operators are exactly the three that
``primus_turbo/flydsl/grouped_gemm/grouped_gemm_bf16_dispatch.py`` dispatches, and
they are invoked the same way ``GroupedGemmFunc`` invokes them:

  fwd      NT          out  = a[M,K] @ b[g][N,K]^T        trans_b=True
  dgrad    NN          dA   = dOut[M,N] @ b[g][N,K]       same b, trans_b=False
  dgrad_tr NN          as dgrad, but with the gfx1250 weight transpose per call
  wgrad    variable-K  dB[g]= a[rows_g]^T @ dOut[rows_g]  trans_a=True, trans_c=True

**The two dgrad columns are two calibres of one operator, not two operators.**
gfx1250 has no native NN pipeline: the kernel is the NT pipeline fed a transposed
weight, and UPSTREAM_NOTES.md section 4b leaves it to the caller whether that
transpose is hoisted. It is a parameter-sized copy at ~1.07 TB/s, so for
qwen3-235b fc1 (b is 1.07 GB) it costs about as much as the GEMM. Which calibre a
reported number used therefore changes it by 2-3x, and the notes never say which
one theirs is -- so this driver measures both:

  ``dgrad``      b_nt = make_nn_weight_nt(b) hoisted out of the timer; GEMM only.
                 This is the column comparable to Triton/CK, which read the
                 strided axis natively and pay no transpose.
  ``dgrad_tr``   no b_nt; the kernel materialises the transpose inside the timer.
                 This is what turbo's registry currently does on every backward.

Two ways in, because the environment forces it (see PREP_NOTES.md section 1.5):

``--registry`` (default)
    Go through turbo's backend registry, pinned with
    ``PRIMUS_TURBO_GROUPED_GEMM_BACKEND`` -- the highest-priority choice in
    ``GlobalBackendManager``, and one that raises rather than silently falling back,
    which is what a benchmark wants. Needs ``import primus_turbo.pytorch``, hence
    needs flydsl 0.2.4, hence cannot reach the gfx1250 kernel.

``--standalone``
    Call ``grouped_gemm_bf16_dispatch`` directly. That module only needs ``torch``
    and imports the per-arch kernel lazily, so it works under flydsl 0.3.x where
    ``primus_turbo.pytorch`` does not import at all. This is the path that can
    measure the gfx1250 kernel the moment the file lands.

Usage:
    # baselines today (flydsl 0.2.4)
    python bench_flydsl_gg_matrix.py --backend TRITON -o results/matrix_triton.csv
    python bench_flydsl_gg_matrix.py --backend HIPBLASLT --models gpt-oss-20b --check

    # the gfx1250 kernel the moment it lands, under a flydsl>=0.3.0 install
    python bench_flydsl_gg_matrix.py --standalone --check -o results/matrix_flydsl.csv

    # once the flydsl conflict is resolved and the backend is registered
    python bench_flydsl_gg_matrix.py --backend FLYDSL --check
"""

from __future__ import annotations

import argparse
import os
import re
import statistics
import subprocess
import sys

# Both of these are read before the imports below: the env var because turbo latches
# it when it first builds the backend tables, and --standalone because it decides
# whether primus_turbo.pytorch may be imported at all.
_PARSED_BACKEND = None
for _i, _arg in enumerate(sys.argv):
    if _arg == "--backend" and _i + 1 < len(sys.argv):
        _PARSED_BACKEND = sys.argv[_i + 1].strip().upper()
    elif _arg.startswith("--backend="):
        _PARSED_BACKEND = _arg.split("=", 1)[1].strip().upper()
STANDALONE = "--standalone" in sys.argv
if _PARSED_BACKEND and _PARSED_BACKEND != "DEFAULT" and not STANDALONE:
    os.environ["PRIMUS_TURBO_GROUPED_GEMM_BACKEND"] = _PARSED_BACKEND

# Reuse turbo's own benchmark helpers rather than reimplementing them. config.py imports
# nothing from primus_turbo, so it is safe in standalone mode too.
_TURBO_BENCH_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "Primus-Turbo",
    "benchmark",
    "ops",
    "training",
)
sys.path.insert(0, _TURBO_BENCH_DIR)

import pandas as pd  # noqa: E402
import torch  # noqa: E402
import torch.utils.benchmark as benchmark  # noqa: E402
from config import (  # noqa: E402
    check_allclose,
    gen_grouped_gemm_group_lens,
    get_platform_info,
)
from tabulate import tabulate  # noqa: E402

if STANDALONE:
    from primus_turbo.flydsl.grouped_gemm.grouped_gemm_bf16_dispatch import (  # noqa: E402
        grouped_gemm_bf16_nn,
        grouped_gemm_bf16_nt,
        grouped_gemm_bf16_variable_k,
    )

    # The arch module as well as the dispatcher: the effective tile config and the
    # hoisted weight transpose are gfx1250 concepts with no dispatch-level surface.
    from primus_turbo.flydsl.grouped_gemm import (  # noqa: E402
        grouped_gemm_bf16_kernel_gfx1250 as _K,
    )

    def group_offs_from_lens(group_lens):
        """Exclusive prefix sum, in torch -- the C++ op lives behind primus_turbo.pytorch."""
        zero = torch.zeros(1, dtype=torch.int64, device=group_lens.device)
        return torch.cat([zero, group_lens.cumsum(0)]).to(torch.int64)

else:
    _K = None
    import primus_turbo.pytorch as turbo  # noqa: E402,F401  (registers the custom ops)
    from primus_turbo.pytorch.core.backend import BackendType  # noqa: E402
    from primus_turbo.pytorch.kernels.grouped_gemm.grouped_gemm_impl import (  # noqa: E402
        grouped_gemm_impl,
        grouped_gemm_variable_k_impl,
    )
    from primus_turbo.pytorch.kernels.grouped_gemm.grouped_gemm_utils import (  # noqa: E402
        group_offs_from_lens,
    )

###############################################################################
# Target matrix
###############################################################################

from gg_matrix_defs import (  # noqa: E402
    DEFAULT_PEAK_TFLOPS,
    LAYERS,
    TARGET_MATRIX,
    avg_m_list as _avg_m_list,
)

DIRECTIONS = ("fwd", "dgrad", "dgrad_tr", "wgrad")


###############################################################################
# Effective tile config -- observed, not re-derived
###############################################################################

_PICKED: dict[str, tuple] = {}


def _install_config_probes():
    """Record what the kernel's own tile chooser returned, for the config column.

    Recomputing ``_pick_config`` from the shape would only report what this script
    believes; wrapping the module global reports what the kernel actually ran. Every
    call below leaves BLOCK_M/BLOCK_N/BLOCK_K/m_warp/n_warp/num_buffers at 0, so the
    recorded tuple *is* the geometry used.
    """
    if _K is None:
        return
    nt_orig, vk_orig = _K._pick_config, _K._pick_variable_k_config

    def nt(N, Kd, avg_m, n_groups=0):
        cfg = nt_orig(N, Kd, avg_m, n_groups)
        _PICKED["nt"] = cfg
        return cfg

    def vk(OUT_M, OUT_N, avg_m):
        cfg = vk_orig(OUT_M, OUT_N, avg_m)
        _PICKED["vk"] = cfg
        return cfg

    _K._pick_config, _K._pick_variable_k_config = nt, vk


def _cfg_str(direction: str) -> str:
    cfg = _PICKED.get("vk" if direction == "wgrad" else "nt")
    if cfg is None:
        return ""
    tm, tn, tk, mw, nw, nb = cfg
    return f"BM{tm}/BN{tn}/BK{tk}/mw{mw}/nw{nw}/nb{nb}"


###############################################################################
# sclk
###############################################################################

_SMI_GPU = 0


def _sclk_mhz() -> float:
    """Mean GFX-die clock in MHz, sampled straight after a measurement.

    amd-smi exposes eight gfx_N_clk domains on this part; the mean over them is
    what the delivery table's "sclk" column means. Clocks are deliberately *not*
    pinned -- the Triton/hipBLASLt baselines in results/baseline/ were taken
    unpinned, and pinning only this run would break the comparison it exists for.
    """
    try:
        out = subprocess.run(
            ["amd-smi", "metric", "-g", str(_SMI_GPU), "-c", "--csv"],
            capture_output=True, text=True, timeout=20, check=True,
        ).stdout.strip().splitlines()
        hdr, row = out[0].split(","), out[1].split(",")
        vals = [
            float(v)
            for h, v in zip(hdr, row)
            if re.fullmatch(r"gfx_\d+_clk", h.strip()) and v.strip().replace(".", "").isdigit()
        ]
        return round(sum(vals) / len(vals), 1) if vals else float("nan")
    except Exception:  # noqa: BLE001
        return float("nan")


###############################################################################
# One measurement
###############################################################################


def _timed_ms(fn, warmup: int, iters: int, repeats: int) -> tuple[float, float, list[float]]:
    """Median-of-repeats wall time in ms, plus the coefficient of variation.

    Each repeat is one ``torch.utils.benchmark.Timer.timeit(iters)`` -- the same
    timing path turbo's own benchmark uses -- so a repeat is already a mean over
    ``iters`` launches. The median across repeats is reported because a single
    ``timeit`` is vulnerable to one clock excursion, and the cv across repeats is
    reported so a point whose spread makes it unusable is visible rather than
    averaged away.
    """
    for _ in range(warmup):
        fn()
    torch.cuda.synchronize()
    timer = benchmark.Timer(stmt="fn()", globals={"fn": fn})
    means = [timer.timeit(iters).mean * 1e3 for _ in range(repeats)]
    med = statistics.median(means)
    cv = (statistics.stdev(means) / statistics.mean(means)) if len(means) > 1 else 0.0
    return med, cv, means


def _reference(direction, a, b_nt, grad_out, group_lens):
    """Per-group fp32 matmul reference for one direction.

    fp32, not fp64: UPSTREAM_NOTES.md section 6 records that a device fp64 matmul
    used as a reference on this part was wrong 11 times in 12.
    """
    lens = group_lens.cpu().tolist()
    outs = []
    start = 0
    for g, n in enumerate(lens):
        if direction == "fwd":
            outs.append(a[start : start + n].float() @ b_nt[g].float().t())
        elif direction in ("dgrad", "dgrad_tr"):
            outs.append(grad_out[start : start + n].float() @ b_nt[g].float())
        else:  # wgrad -> dB[g] = dOut_rows^T @ a_rows, i.e. [G, N, K]
            outs.append(grad_out[start : start + n].float().t() @ a[start : start + n].float())
        start += n
    return torch.stack(outs) if direction == "wgrad" else torch.cat(outs)


def run_case(
    direction: str,
    G: int,
    avg_m: int,
    N: int,
    K: int,
    dtype: torch.dtype,
    backend_enum: int,
    warmup: int,
    iters: int,
    repeats: int,
    do_check: bool,
    balance: bool,
):
    """Measure one (direction, shape) cell.

    Returns (time_ms, cv, tflops, check_str, cfg_str, sclk).
    """
    dev = "cuda"
    total_m = G * avg_m
    group_lens = gen_grouped_gemm_group_lens(G, avg_m, balance=balance).to(dev)
    group_offs = group_offs_from_lens(group_lens)

    a = torch.randn(total_m, K, dtype=dtype, device=dev)
    b_nt = torch.randn(G, N, K, dtype=dtype, device=dev)
    grad_out = torch.randn(total_m, N, dtype=dtype, device=dev)

    if STANDALONE:
        # dispatch.py picks the per-arch module itself; no registry, no backend enum.
        if direction == "fwd":
            fn = lambda: grouped_gemm_bf16_nt(a, b_nt, group_offs)  # noqa: E731
        elif direction in ("dgrad", "dgrad_tr"):
            # The NN entry's `b` keeps upstream's [G, K_nn, N_nn] meaning. With
            # a = grad_out [M, N_fwd] that makes K_nn = N_fwd, so the forward
            # weight b_nt [G, N_fwd, K_fwd] is already the right operand and the
            # output is [M, K_fwd] = dA.
            if direction == "dgrad":
                # Calibre (a): hoist the transpose out of the timer, as a training
                # loop would do once per optimizer step.
                w_nt = _K.make_nn_weight_nt(b_nt)
                fn = lambda: grouped_gemm_bf16_nn(grad_out, b_nt, group_offs, b_nt=w_nt)  # noqa: E731
            else:
                # Calibre (b): no b_nt, so the kernel materialises a
                # parameter-sized copy on every call, inside the timer.
                fn = lambda: grouped_gemm_bf16_nn(grad_out, b_nt, group_offs)  # noqa: E731
        elif direction == "wgrad":
            # trans_c=True raises NotImplementedError on gfx1250 (no transposed-store
            # epilogue). Swapping the operands is exactly equivalent -- (A^T B)^T =
            # B^T A -- and free, which is how turbo's CK and Triton variable-K
            # backends already implement trans_c. So this call produces the
            # [G, N_fwd, K_fwd] forward-weight layout that turbo's wgrad asks for.
            fn = lambda: grouped_gemm_bf16_variable_k(  # noqa: E731
                grad_out, a, group_offs, masked_k=group_lens
            )
        else:
            raise ValueError(direction)
    else:
        common = dict(
            group_lens=group_lens,
            group_offs=group_offs,
            num_cu=None,
            default_backend=backend_enum,
            schedule="static",
        )
        if direction == "fwd":
            fn = lambda: grouped_gemm_impl(a, b_nt, trans_a=False, trans_b=True, **common)  # noqa: E731
        elif direction == "dgrad":
            # turbo's backward reuses the forward's b and flips trans_b. CK/Triton
            # read the strided axis natively, so there is no transpose to hoist and
            # no dgrad_tr counterpart -- this column is comparable to the FlyDSL
            # `dgrad` (hoisted) column, not to `dgrad_tr`.
            fn = lambda: grouped_gemm_impl(grad_out, b_nt, trans_a=False, trans_b=False, **common)  # noqa: E731
        elif direction == "dgrad_tr":
            raise ValueError("dgrad_tr is a gfx1250-only calibre; use --standalone")
        elif direction == "wgrad":
            fn = lambda: grouped_gemm_variable_k_impl(  # noqa: E731
                a, grad_out, trans_a=True, trans_b=False, trans_c=True, **common
            )
        else:
            raise ValueError(direction)

    out = fn()
    torch.cuda.synchronize()

    check = "SKIP"
    if do_check:
        # Notes section 6.5: the first 1-2 calls of a fresh process have been seen
        # to return corrupt results on one shape. Burn to the 4th call, as the
        # notes instruct, so this check measures the steady state the timing loop
        # also measures. check_flydsl_gg_correctness.py reports call 1 separately.
        for _ in range(3):
            out = fn()
        torch.cuda.synchronize()
        ref = _reference(direction, a, b_nt, grad_out, group_lens)
        check = "PASS" if check_allclose(out.float(), ref.float(), dtype) else "FAIL"
        del ref

    time_ms, cv, _ = _timed_ms(fn, warmup, iters, repeats)
    sclk = _sclk_mhz()
    # Every one of the three operators contracts the same M*N*K volume.
    tflops = (2.0 * total_m * N * K) / (time_ms * 1e-3) / 1e12
    return time_ms, cv, tflops, check, _cfg_str(direction), sclk


###############################################################################
# Sweep
###############################################################################


def main():
    p = argparse.ArgumentParser(
        description="Benchmark the FlyDSL bf16 grouped-GEMM target matrix",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    p.add_argument(
        "--backend",
        default="TRITON",
        help="Grouped-GEMM backend to pin: CK/HIPBLASLT/TRITON/FLYDSL/AUTOTUNE, "
        "or DEFAULT to leave selection to turbo. Ignored with --standalone",
    )
    p.add_argument(
        "--standalone",
        action="store_true",
        help="bypass turbo's registry and call grouped_gemm_bf16_dispatch directly; "
        "works under flydsl>=0.3.0 where primus_turbo.pytorch does not import",
    )
    p.add_argument("--models", nargs="+", default=list(TARGET_MATRIX), choices=list(TARGET_MATRIX))
    # dgrad_tr is the gfx1250 per-call-transpose calibre and has no registry
    # counterpart, so it is only in the default set for --standalone.
    p.add_argument(
        "--directions",
        nargs="+",
        default=list(DIRECTIONS) if STANDALONE else [d for d in DIRECTIONS if d != "dgrad_tr"],
        choices=list(DIRECTIONS),
    )
    p.add_argument("--layers", nargs="+", default=list(LAYERS), choices=list(LAYERS))
    p.add_argument("--batches", nargs="+", type=int, default=[1, 2, 4])
    p.add_argument(
        "--avg-m-mode",
        default="topk",
        choices=["topk", "seq-over-g"],
        help="how avg_m is derived from seq/batch (ignored when --avg-m is given)",
    )
    p.add_argument(
        "--avg-m",
        nargs="+",
        type=int,
        default=None,
        help="explicit avg_m values, used for every model instead of deriving them",
    )
    p.add_argument("--warmup", type=int, default=10)
    p.add_argument("--iters", type=int, default=50, help="launches per repeat (one timeit call)")
    p.add_argument("--repeats", type=int, default=5, help="repeats; the reported time is their median")
    p.add_argument("--cv-warn", type=float, default=0.03, help="flag points whose cv exceeds this")
    p.add_argument("--smi-gpu", type=int, default=None, help="amd-smi GPU index for the sclk column")
    p.add_argument("--peak-tflops", type=float, default=DEFAULT_PEAK_TFLOPS)
    p.add_argument("--check", action="store_true", help="verify against a torch reference")
    p.add_argument(
        "--imbalance",
        action="store_true",
        help="draw ragged group_lens instead of G equal groups",
    )
    p.add_argument("-o", "--output", default=None, help="output CSV path")
    args = p.parse_args()

    global _SMI_GPU
    _SMI_GPU = args.smi_gpu if args.smi_gpu is not None else int(
        (os.environ.get("HIP_VISIBLE_DEVICES") or os.environ.get("CUDA_VISIBLE_DEVICES") or "0").split(",")[0]
    )
    _install_config_probes()

    if args.standalone:
        backend_name, backend_enum = "FLYDSL-STANDALONE", None
    else:
        backend_name = args.backend.strip().upper()
        if backend_name in ("DEFAULT", "AUTOTUNE"):
            # AUTOTUNE is expressed through the env var; the op still needs some enum.
            backend_enum = BackendType.TRITON.value
        else:
            backend_enum = BackendType[backend_name].value

    platform, gpu_name = get_platform_info()
    props = torch.cuda.get_device_properties(0)
    print(f"platform      : {platform} / {gpu_name} / {props.gcnArchName}")
    print(f"CUs           : {props.multi_processor_count}")
    if args.standalone:
        import flydsl

        print(f"mode          : standalone via grouped_gemm_bf16_dispatch (flydsl {flydsl.__version__})")
    else:
        print(f"backend       : {backend_name}  (env PRIMUS_TURBO_GROUPED_GEMM_BACKEND="
              f"{os.environ.get('PRIMUS_TURBO_GROUPED_GEMM_BACKEND', '<unset>')})")
    print(f"peak bf16     : {args.peak_tflops:.1f} TFLOP/s  (MFU denominator)")
    print(f"avg_m mode    : {'explicit ' + str(args.avg_m) if args.avg_m else args.avg_m_mode}")
    print(f"timing        : {args.warmup} warmup, median of {args.repeats} x timeit({args.iters}); "
          f"cv flagged above {args.cv_warn:.1%}")
    print(f"sclk          : amd-smi gpu {_SMI_GPU}, mean over gfx dies, clocks NOT pinned "
          f"(matches the baseline runs)")
    print()

    rows = []
    test_id = 0
    for model in args.models:
        cfg = TARGET_MATRIX[model]
        if args.avg_m:
            batch_avg_m = [(0, m) for m in args.avg_m]
        else:
            batch_avg_m = _avg_m_list(cfg, args.batches, args.avg_m_mode)

        for batch, avg_m in batch_avg_m:
            for layer in args.layers:
                N, K = cfg[layer]
                for direction in args.directions:
                    test_id += 1
                    G = cfg["G"]
                    tag = (
                        f"[{test_id}] {model} {layer} {direction} "
                        f"G={G} batch={batch} avg_m={avg_m} M={G * avg_m} N={N} K={K}"
                    )
                    print(tag, flush=True)
                    try:
                        time_ms, cv, tflops, check, cfg_used, sclk = run_case(
                            direction=direction,
                            G=G,
                            avg_m=avg_m,
                            N=N,
                            K=K,
                            dtype=torch.bfloat16,
                            backend_enum=backend_enum,
                            warmup=args.warmup,
                            iters=args.iters,
                            repeats=args.repeats,
                            do_check=args.check,
                            balance=not args.imbalance,
                        )
                        mfu = 100.0 * tflops / args.peak_tflops
                        noisy = " NOISY" if cv > args.cv_warn else ""
                        print(
                            f"      {time_ms:8.4f} ms  {tflops:8.2f} TF/s  MFU {mfu:5.2f}%  "
                            f"cv {cv * 100:5.2f}%{noisy}  sclk {sclk:.0f}  {cfg_used}  {check}",
                            flush=True,
                        )
                        rows.append(
                            dict(
                                TestID=test_id, Platform=platform, GPU=gpu_name,
                                Backend=backend_name, Model=model, Layer=layer,
                                Direction=direction, G=G, EP=cfg["EP"], Seq=cfg["seq"],
                                Batch=batch, AvgM=avg_m, TotalM=G * avg_m, N=N, K=K,
                                Dtype="bf16", Check=check,
                                **{
                                    "Time (ms)": round(time_ms, 4),
                                    "TFLOPS": round(tflops, 2),
                                    "MFU (%)": round(mfu, 2),
                                    "cv (%)": round(cv * 100, 3),
                                    "Config": cfg_used,
                                    "sclk (MHz)": sclk,
                                },
                            )
                        )
                    except Exception as exc:  # noqa: BLE001
                        msg = str(exc).replace("\n", " ")
                        print(f"      FAILED {type(exc).__name__}: {msg[:300]}", flush=True)
                        rows.append(
                            dict(
                                TestID=test_id, Platform=platform, GPU=gpu_name,
                                Backend=backend_name, Model=model, Layer=layer,
                                Direction=direction, G=G, EP=cfg["EP"], Seq=cfg["seq"],
                                Batch=batch, AvgM=avg_m, TotalM=G * avg_m, N=N, K=K,
                                Dtype="bf16", Check="ERROR",
                                **{
                                    "Time (ms)": "ERROR",
                                    "TFLOPS": 0.0,
                                    "MFU (%)": 0.0,
                                    "cv (%)": 0.0,
                                    "Config": "",
                                    "sclk (MHz)": float("nan"),
                                    "Error": f"{type(exc).__name__}: {msg[:300]}",
                                },
                            )
                        )
                    finally:
                        torch.cuda.empty_cache()

    df = pd.DataFrame(rows)
    show = [c for c in df.columns if c not in ("Platform", "GPU", "Seq", "EP", "Error", "Dtype")]
    print("\nFinal Results:")
    print(tabulate(df[show], headers="keys", tablefmt="grid", showindex=False))

    ok = df[df["Check"] != "ERROR"]
    if not ok.empty:
        print("\nTFLOPS by direction:")
        print(ok.groupby("Direction")["TFLOPS"].agg(["count", "mean", "min", "max"]).round(2))
        print("\nEffective tile configs:")
        print(ok.groupby(["Direction", "Config"]).size().to_string())
        noisy = ok[ok["cv (%)"] > args.cv_warn * 100]
        if not noisy.empty:
            print(f"\n{len(noisy)} point(s) with cv above {args.cv_warn:.1%} -- treat as unstable:")
            print(noisy[["TestID", "Model", "Layer", "Direction", "AvgM", "TFLOPS", "cv (%)"]].to_string(index=False))
        else:
            print(f"\nNo point exceeded cv {args.cv_warn:.1%}; max cv {ok['cv (%)'].max():.3f}%")
        print(f"\nsclk over the run: {ok['sclk (MHz)'].min():.0f} - {ok['sclk (MHz)'].max():.0f} MHz "
              f"(mean {ok['sclk (MHz)'].mean():.0f})")

    out_path = args.output or f"grouped_gemm_matrix_{backend_name.lower()}_{gpu_name}.csv"
    os.makedirs(os.path.dirname(os.path.abspath(out_path)), exist_ok=True)
    df.to_csv(out_path, index=False)
    print(f"\nResults saved to {out_path}")


if __name__ == "__main__":
    main()
