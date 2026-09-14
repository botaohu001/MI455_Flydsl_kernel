#!/usr/bin/env python3
"""Part 1 -- per-shape break-even N* for caching the transposed dgrad weight.

For every (model, layer, avg_m) cell this measures, in one process and
interleaved so they share a clock regime:

  t_transpose   make_nn_weight_nt(w)                     alone, nothing else
  t_gemm        flydsl NN with b_nt hoisted              the GEMM by itself
  t_nocache     flydsl NN with b_nt=None                 what turbo does today
  t_triton      turbo's Triton dgrad                     the baseline to beat

and then, separately, the end-to-end cost of one transpose followed by N GEMMs
for N in {1,2,4,8,16,32}, to check whether

      t_eff(N) = t_gemm + t_transpose / N

actually describes the machine or is just arithmetic.

Nothing here is derived by subtraction: every term above is its own measurement.
"""
from __future__ import annotations

import argparse
import json
import os
import sys
import warnings

import torch

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common import (  # noqa: E402
    MATRIX,
    N_SWEEP,
    Interleaved,
    fast_nn_weight_nt,
    fp32_ref_dgrad,
    load_flydsl_kernel,
    load_turbo,
    make_case,
    rel_fro,
    sclk_mhz,
)

# Which transpose the "t_transpose" column and the N sweep are built on.  The
# upstream helper and a tiled Triton kernel differ by more than 10x, and N* is
# linear in this term, so it is a first-class variable of the experiment.
_PICKED: dict = {}


def install_config_probe(K):
    """Record the tile geometry the kernel's own chooser returned, not a re-derivation."""
    orig = K._pick_config

    def probe(N, Kd, avg_m, n_groups=0):
        cfg = orig(N, Kd, avg_m, n_groups)
        _PICKED["nt"] = cfg
        return cfg

    K._pick_config = probe


def run_cell(K, grouped_gemm_impl, BackendType, model, layer, G, N, Kd, avg_m, args, transpose):
    case = make_case(G, avg_m, N, Kd)
    dout, w, offs, lens, M = case["dout"], case["w"], case["offs"], case["lens"], case["M"]

    w_nt = transpose(w)
    assert torch.equal(w_nt, K.make_nn_weight_nt(w)), "transpose impl disagrees with upstream"

    tri_kw = dict(group_lens=lens, group_offs=offs, num_cu=None,
                  default_backend=BackendType.TRITON.value, schedule="static")

    def f_transpose():
        transpose(w)

    def f_gemm():
        K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=w_nt)

    def f_nocache():
        # what turbo's registry does today: transpose inside every dgrad call
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=transpose(w))

    def f_triton():
        grouped_gemm_impl(dout, w, trans_a=False, trans_b=False, **tri_kw)

    # ---- correctness, once, before any timing ----------------------------- #
    check = {}
    if args.check:
        # Notes section 6.5: the first 1-2 calls in a fresh process have returned
        # corrupt results on one shape (N == K == 2880).  Burn to the 4th.
        for _ in range(4):
            fly = K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=w_nt)
        tri = grouped_gemm_impl(dout, w, trans_a=False, trans_b=False, **tri_kw)
        torch.cuda.synchronize()
        ref = fp32_ref_dgrad(case)
        check = dict(
            rel_flydsl=rel_fro(fly, ref),
            rel_triton=rel_fro(tri, ref),
            flydsl_eq_triton=bool(torch.equal(fly, tri)),
        )
        del ref, fly, tri
        torch.cuda.empty_cache()

    # ---- the four base terms, interleaved --------------------------------- #
    base = Interleaved(warmup=args.warmup, repeats=args.repeats)
    base.add("transpose", f_transpose, target_ms=args.target_ms)
    base.add("gemm", f_gemm, target_ms=args.target_ms)
    base.add("nocache", f_nocache, target_ms=args.target_ms)
    base.add("triton", f_triton, target_ms=args.target_ms)
    res, clocks = base.run(verbose=args.verbose)

    # ---- the N sweep, measured end to end --------------------------------- #
    def make_step(n):
        def step():
            bnt = transpose(w)
            for _ in range(n):
                K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=bnt)
        return step

    sweep = Interleaved(warmup=args.sweep_warmup, repeats=args.sweep_repeats)
    for n in N_SWEEP:
        sweep.add(f"N{n}", make_step(n), target_ms=args.sweep_target_ms, max_iters=60)
    sres, sclocks = sweep.run(verbose=args.verbose)

    t_gemm = res["gemm"]["ms"]
    t_tr = res["transpose"]["ms"]
    t_tri = res["triton"]["ms"]

    gap = t_tri - t_gemm
    n_star = (t_tr / gap) if gap > 0 else float("inf")

    flop = 2.0 * M * N * Kd
    w_bytes = G * N * Kd * 2

    cfg = _PICKED.get("nt")
    row = dict(
        Model=model, Layer=layer, G=G, avg_m=avg_m, M=M, N=N, K=Kd,
        transpose_impl=args.transpose,
        tile_cfg=("BM{}/BN{}/BK{}/mw{}/nw{}/nb{}".format(*cfg) if cfg else ""),
        w_MiB=round(w_bytes / 2**20, 2),
        w_bytes_per_flop=w_bytes / flop,
        t_transpose_ms=round(t_tr, 5), cv_transpose=round(res["transpose"]["cv"], 5),
        t_gemm_ms=round(t_gemm, 5), cv_gemm=round(res["gemm"]["cv"], 5),
        t_nocache_ms=round(res["nocache"]["ms"], 5), cv_nocache=round(res["nocache"]["cv"], 5),
        t_triton_ms=round(t_tri, 5), cv_triton=round(res["triton"]["cv"], 5),
        tf_gemm=round(flop / (t_gemm * 1e-3) / 1e12, 2),
        tf_triton=round(flop / (t_tri * 1e-3) / 1e12, 2),
        transpose_GBps=round(2 * w_bytes / (t_tr * 1e-3) / 1e9, 1),
        speedup_gemm_vs_triton=round(t_tri / t_gemm, 4),
        N_star=round(n_star, 3) if n_star != float("inf") else float("inf"),
        sclk_min=min(clocks + sclocks), sclk_max=max(clocks + sclocks),
        sclk_mean=round(sum(clocks + sclocks) / len(clocks + sclocks), 1),
        **check,
    )
    for n in N_SWEEP:
        eff = sres[f"N{n}"]["ms"] / n
        row[f"eff_N{n}_ms"] = round(eff, 5)
        row[f"model_N{n}_ms"] = round(t_gemm + t_tr / n, 5)
        row[f"dev_N{n}_pct"] = round(100.0 * (eff - (t_gemm + t_tr / n)) / (t_gemm + t_tr / n), 2)
        row[f"cv_N{n}"] = round(sres[f"N{n}"]["cv"], 5)

    raw = dict(base={k: v for k, v in res.items()}, sweep={k: v for k, v in sres.items()},
               clocks=clocks + sclocks)

    del case, dout, w, offs, lens, w_nt
    torch.cuda.empty_cache()
    return row, raw


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--models", nargs="+", default=list(MATRIX), choices=list(MATRIX))
    p.add_argument("--layers", nargs="+", default=["fc1", "fc2"])
    p.add_argument("--avg-m", nargs="+", type=int, default=None)
    p.add_argument("--warmup", type=int, default=5)
    p.add_argument("--repeats", type=int, default=7)
    p.add_argument("--target-ms", type=float, default=40.0)
    p.add_argument("--sweep-warmup", type=int, default=2)
    p.add_argument("--sweep-repeats", type=int, default=3)
    p.add_argument("--sweep-target-ms", type=float, default=60.0)
    p.add_argument("--check", action="store_true", default=True)
    p.add_argument("--no-check", dest="check", action="store_false")
    p.add_argument("--verbose", action="store_true")
    p.add_argument("--transpose", default="torch", choices=["torch", "fast"],
                   help="torch = upstream make_nn_weight_nt; fast = tiled Triton kernel")
    p.add_argument("-o", "--output", default="results/part1_break_even")
    args = p.parse_args()

    grouped_gemm_impl, _offs_fn, BackendType = load_turbo()
    K = load_flydsl_kernel()
    install_config_probe(K)
    transpose = K.make_nn_weight_nt if args.transpose == "torch" else fast_nn_weight_nt
    import flydsl

    props = torch.cuda.get_device_properties(0)
    hdr = dict(
        gcnArchName=props.gcnArchName, CUs=props.multi_processor_count,
        HBM_bytes=props.total_memory, torch=torch.__version__, flydsl=flydsl.__version__,
        HIP_VISIBLE_DEVICES=os.environ.get("HIP_VISIBLE_DEVICES"),
        transpose_impl=args.transpose,
        sclk_at_start=sclk_mhz(),
    )
    print(json.dumps(hdr, indent=2), flush=True)
    print()

    rows, raws = [], {}
    for model in args.models:
        cfg = MATRIX[model]
        avg_ms = args.avg_m or cfg["avg_m"]
        for avg_m in avg_ms:
            for layer in args.layers:
                N, Kd = cfg[layer]
                G = cfg["G"]
                tag = f"{model:16s} {layer} G={G:2d} avg_m={avg_m:5d} M={G*avg_m:6d} N={N:5d} K={Kd:5d}"
                print(tag, flush=True)
                try:
                    row, raw = run_cell(K, grouped_gemm_impl, BackendType,
                                        model, layer, G, N, Kd, avg_m, args, transpose)
                except Exception as exc:  # noqa: BLE001
                    print(f"    FAILED {type(exc).__name__}: {str(exc)[:400]}", flush=True)
                    rows.append(dict(Model=model, Layer=layer, G=G, avg_m=avg_m, N=N, K=Kd,
                                     Error=f"{type(exc).__name__}: {str(exc)[:400]}"))
                    torch.cuda.empty_cache()
                    continue
                rows.append(row)
                raws[f"{model}/{layer}/{avg_m}"] = raw
                ns = row["N_star"]
                print(f"    transpose {row['t_transpose_ms']:8.3f} ms ({row['transpose_GBps']:6.0f} GB/s)"
                      f"  gemm {row['t_gemm_ms']:8.3f} ms ({row['tf_gemm']:7.1f} TF/s)"
                      f"  triton {row['t_triton_ms']:8.3f} ms ({row['tf_triton']:7.1f} TF/s)")
                print(f"    nocache {row['t_nocache_ms']:8.3f} ms"
                      f"   gemm/triton speedup {row['speedup_gemm_vs_triton']:.3f}x"
                      f"   N* = {ns}"
                      f"   sclk {row['sclk_min']:.0f}-{row['sclk_max']:.0f}")
                dev = "  ".join(f"N{n}:{row[f'eff_N{n}_ms']:.3f}({row[f'dev_N{n}_pct']:+.1f}%)"
                                for n in N_SWEEP)
                print(f"    sweep   {dev}")
                if args.check:
                    print(f"    check   rel_flydsl={row.get('rel_flydsl'):.3e}"
                          f"  rel_triton={row.get('rel_triton'):.3e}"
                          f"  bitwise_eq={row.get('flydsl_eq_triton')}")
                print(flush=True)

    import pandas as pd
    df = pd.DataFrame(rows)
    out = os.path.join(os.path.dirname(os.path.abspath(__file__)), args.output)
    os.makedirs(os.path.dirname(out), exist_ok=True)
    df.to_csv(out + ".csv", index=False)
    with open(out + ".json", "w") as fh:
        json.dump(dict(header=hdr, rows=rows, raw=raws), fh, indent=1)
    print(f"\nwrote {out}.csv / .json")


if __name__ == "__main__":
    main()
