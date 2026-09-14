#!/usr/bin/env python3
###############################################################################
# Numerical correctness harness for the gfx1250 FlyDSL bf16 grouped GEMM.
#
# See LICENSE of Primus-Turbo for the license of the reused benchmark helpers.
###############################################################################

"""Verify the three gfx1250 grouped-GEMM operators against a torch reference.

Design constraints taken from the kernel's own notes, not invented here:

* ``UPSTREAM_NOTES.md`` section 6 "directions already disproven" records that a
  **device fp64** matmul used as a reference was *wrong 11 times in 12* on this
  part -- "references must be fp32, judged host-side". So the reference is an
  fp32 matmul over exactly-upcast bf16 operands, and every error metric is
  computed on the CPU in float64.
* ``UPSTREAM_NOTES.md`` section 6.5: gpt-oss fc2 (N == K == 2880) dgrad has
  returned corrupt results on the first 1-2 calls of a fresh process, root cause
  unknown. "A correctness harness must burn 3 calls and check the 4th." This
  harness runs 4 calls and reports call 1 *and* call 4 separately, so the
  first-call corruption is measured rather than hidden.
* ``UPSTREAM_NOTES.md`` section 8.3: ``masked_k`` is "correct by construction,
  never executed", and it is the only thing turbo's variable-K FlyDSL backend
  ever passes. ``--masked-k`` builds a padded pool with poisoned dead rows and
  asserts they contribute nothing.

Acceptance, per notes section 8.2: relative error < 1e-2 and no NaN/Inf. The
bf16 noise floor quoted there is 0.1407-0.1410 %, which is what one rounding of
an fp32 accumulator to bf16 costs, so anything near 0.141 % is a pass at the
floor and anything near 1 % would already be suspicious.

Usage (inside a ROCm container; flydsl 0.2.4 or 0.3.2, both measured working):

    python check_flydsl_gg_correctness.py --ops fwd dgrad wgrad
    python check_flydsl_gg_correctness.py --masked-k
    python check_flydsl_gg_correctness.py --host-ref --models gpt-oss-20b
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import traceback
import warnings

import torch

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from gg_matrix_defs import TARGET_MATRIX, avg_m_list as _avg_m_list  # noqa: E402

from primus_turbo.flydsl.grouped_gemm import (  # noqa: E402
    grouped_gemm_bf16_kernel_gfx1250 as K,
)

ACCEPT_REL = 1e-2
NOISE_FLOOR = 1.41e-3  # 0.141 %, one bf16 rounding


###############################################################################
# Effective tile config, observed rather than re-derived
###############################################################################

_PICKED: dict[str, tuple] = {}


def _install_config_probes():
    """Record what the kernel's own tile chooser returned for the last call.

    Wrapping the module globals is the only way to *observe* the config instead of
    recomputing it from the shape and hoping the two agree. Every call below
    leaves BLOCK_M/BLOCK_N/BLOCK_K/m_warp/n_warp/num_buffers at 0, so the tuple
    recorded here is exactly the geometry the kernel ran.
    """
    nt_orig, vk_orig = K._pick_config, K._pick_variable_k_config

    def nt(N, Kd, avg_m, n_groups=0):
        cfg = nt_orig(N, Kd, avg_m, n_groups)
        _PICKED["nt"] = cfg
        return cfg

    def vk(OUT_M, OUT_N, avg_m):
        cfg = vk_orig(OUT_M, OUT_N, avg_m)
        _PICKED["vk"] = cfg
        return cfg

    K._pick_config, K._pick_variable_k_config = nt, vk


def cfg_str(kind: str) -> str:
    cfg = _PICKED.get(kind)
    if cfg is None:
        return "?"
    tm, tn, tk, mw, nw, nb = cfg
    return f"BM{tm}/BN{tn}/BK{tk}/mw{mw}/nw{nw}/nb{nb}"


###############################################################################
# Error metrics -- all computed on the host in float64
###############################################################################


def metrics(out: torch.Tensor, ref: torch.Tensor) -> dict:
    o = out.detach().to("cpu", torch.float64)
    r = ref.detach().to("cpu", torch.float64)
    nan = int(torch.isnan(o).sum())
    inf = int(torch.isinf(o).sum())
    if nan or inf:
        # A norm over NaN is NaN; report the counts and stop.
        return dict(rel_fro=float("nan"), amax=float("nan"), nan=nan, inf=inf, allclose=False)
    d = o - r
    rn = float(r.norm())
    return dict(
        rel_fro=float(d.norm()) / rn if rn else float("nan"),
        amax=float(d.abs().max()) / max(float(r.abs().max()), 1e-30),
        nan=0,
        inf=0,
        # turbo's own bf16 verdict, kept for continuity with the baseline CSVs.
        allclose=bool(torch.allclose(o.to(torch.float32), r.to(torch.float32), rtol=1e-2, atol=1e-2)),
    )


def verdict(m: dict) -> str:
    if m["nan"] or m["inf"]:
        return "FAIL"
    if not (m["rel_fro"] == m["rel_fro"]):  # NaN
        return "FAIL"
    return "PASS" if m["rel_fro"] < ACCEPT_REL else "FAIL"


###############################################################################
# References
###############################################################################


def ref_fwd(a, b_nt, lens, dev):
    outs, s = [], 0
    for g, n in enumerate(lens):
        outs.append(a[s : s + n].float() @ b_nt[g].float().t())
        s += n
    return torch.cat(outs)


def ref_dgrad(dout, b_nt, lens, dev):
    """dA[rows] = dOut[rows] @ b_nt[g], with b_nt the forward weight [G, N_fwd, K_fwd]."""
    outs, s = [], 0
    for g, n in enumerate(lens):
        outs.append(dout[s : s + n].float() @ b_nt[g].float())
        s += n
    return torch.cat(outs)


def ref_wgrad(dout, x, lens, dev, offs=None):
    """dB[g] = dOut[rows_g].T @ x[rows_g] -> [G, N_fwd, K_fwd].

    ``offs`` lets the padded-pool test point at the valid slice of each group
    while the pool itself is longer than ``lens``.
    """
    outs = []
    for g, n in enumerate(lens):
        s = int(offs[g]) if offs is not None else sum(lens[:g])
        outs.append(dout[s : s + n].float().t() @ x[s : s + n].float())
    return torch.stack(outs)


###############################################################################
# One case
###############################################################################


def run_case(op, G, avg_m, N, K_fwd, calls, host_ref, seed=0):
    """Run one (op, shape) point. Returns a dict of results for call 1 and call `calls`."""
    dev = "cuda"
    torch.manual_seed(seed)
    total_m = G * avg_m
    lens = [avg_m] * G
    group_lens = torch.tensor(lens, dtype=torch.int64, device=dev)
    offs = torch.cat([torch.zeros(1, dtype=torch.int64, device=dev), group_lens.cumsum(0)])

    x = torch.randn(total_m, K_fwd, dtype=torch.bfloat16, device=dev)
    w = torch.randn(G, N, K_fwd, dtype=torch.bfloat16, device=dev)  # forward weight [G, N, K]
    dout = torch.randn(total_m, N, dtype=torch.bfloat16, device=dev)

    if op == "fwd":
        # NT: out[rows] = x[rows] @ w[g].T
        fn = lambda: K.grouped_gemm_bf16_nt_flydsl_kernel(x, w, offs)  # noqa: E731
        ref = ref_fwd(x, w, lens, dev)
        kind = "nt"
    elif op == "dgrad":
        # NN contract: b is [G, K_nn, N_nn]. Here a=dout [M, N_fwd] so K_nn=N_fwd
        # and b=w [G, N_fwd, K_fwd] -> out [M, K_fwd]. No b_nt: the kernel
        # materialises the transpose itself (calibre (b)).
        fn = lambda: K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs)  # noqa: E731
        ref = ref_dgrad(dout, w, lens, dev)
        kind = "nt"
    elif op == "dgrad_hoisted":
        w_nt = K.make_nn_weight_nt(w)  # [G, K_fwd, N_fwd]
        fn = lambda: K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=w_nt)  # noqa: E731
        ref = ref_dgrad(dout, w, lens, dev)
        kind = "nt"
    elif op == "wgrad":
        # variable-K: out[g] = a[rows_g].T @ b[rows_g]. Operands swapped so the
        # output lands in the forward weight's [G, N_fwd, K_fwd] layout, which is
        # what turbo's autograd asks for with trans_c=True. (A^T B)^T = B^T A, so
        # the swap is free -- trans_c itself raises NotImplementedError here.
        fn = lambda: K.grouped_gemm_bf16_variable_k_flydsl_kernel(  # noqa: E731
            dout, x, offs, masked_k=group_lens
        )
        ref = ref_wgrad(dout, x, lens, dev)
        kind = "vk"
    else:
        raise ValueError(op)

    res = {}
    out1 = None
    for i in range(1, calls + 1):
        out = fn()
        torch.cuda.synchronize()
        if i == 1:
            out1 = out.clone()
        if i == calls:
            res["call1"] = metrics(out1, ref)
            res[f"call{calls}"] = metrics(out, ref)
    res["cfg"] = cfg_str(kind)

    if host_ref:
        # Validate the device-fp32 reference itself against a CPU one. Only run on
        # request: the CPU matmul is the slow part of this harness.
        if op == "fwd":
            hr = ref_fwd(x.cpu(), w.cpu(), lens, "cpu")
        elif op in ("dgrad", "dgrad_hoisted"):
            hr = ref_dgrad(dout.cpu(), w.cpu(), lens, "cpu")
        else:
            hr = ref_wgrad(dout.cpu(), x.cpu(), lens, "cpu")
        res["host_vs_dev_ref"] = metrics(ref.cpu(), hr)

    del x, w, dout, ref, out1
    torch.cuda.empty_cache()
    return res


###############################################################################
# masked_k with a padded pool -- the path that has never been executed
###############################################################################


def run_masked_k(G, avg_m, N, K_fwd, pad_frac, poison, seed=0, calls=4):
    """variable-K over a pool where each group's allocation exceeds its valid rows.

    ``group_k_offsets`` describes the *pool*; ``masked_k`` the valid prefix of each
    group. Dead rows are poisoned, so if the reduction ever addresses them the
    error explodes. At least one group is given a valid count that is not a
    multiple of tile_k (128 here), which is the case notes section 8.3 asks for.
    """
    dev = "cuda"
    torch.manual_seed(seed)
    # Pool slot per group, and the valid prefix inside it.
    slot = int(avg_m * (1.0 + pad_frac))
    valid = []
    for g in range(G):
        v = int(avg_m * (1.0 - pad_frac * ((g % 3) + 1) / 3.0))
        # Force non-multiples of tile_k=128 and of 64 on some groups.
        v = max(1, v - (37 if g % 2 == 0 else 0))
        valid.append(min(v, slot))
    total_pool = slot * G
    offs = torch.tensor([slot * g for g in range(G + 1)], dtype=torch.int64, device=dev)
    masked_k = torch.tensor(valid, dtype=torch.int64, device=dev)

    x = torch.randn(total_pool, K_fwd, dtype=torch.bfloat16, device=dev)
    dout = torch.randn(total_pool, N, dtype=torch.bfloat16, device=dev)
    # Poison every dead row.
    for g in range(G):
        lo, hi = slot * g + valid[g], slot * (g + 1)
        if hi > lo:
            x[lo:hi] = poison
            dout[lo:hi] = poison

    ref = ref_wgrad(dout, x, valid, dev, offs=offs)

    out = None
    for _ in range(calls):
        out = K.grouped_gemm_bf16_variable_k_flydsl_kernel(dout, x, offs, masked_k=masked_k)
        torch.cuda.synchronize()
    m = metrics(out, ref)
    m["cfg"] = cfg_str("vk")
    m["valid"] = valid
    m["slot"] = slot
    m["tile_k"] = _PICKED.get("vk", (0, 0, 0))[2]
    m["valid_mod_tilek"] = [v % max(m["tile_k"], 1) for v in valid]
    del x, dout, ref, out
    torch.cuda.empty_cache()
    return m


###############################################################################
# Driver
###############################################################################


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--models", nargs="+", default=list(TARGET_MATRIX), choices=list(TARGET_MATRIX))
    p.add_argument("--layers", nargs="+", default=["fc1", "fc2"])
    p.add_argument("--batches", nargs="+", type=int, default=[1, 2, 4])
    p.add_argument(
        "--ops",
        nargs="+",
        default=["fwd", "dgrad", "dgrad_hoisted", "wgrad"],
        choices=["fwd", "dgrad", "dgrad_hoisted", "wgrad"],
    )
    p.add_argument("--calls", type=int, default=4, help="burn calls-1 and check the last (notes 6.5)")
    p.add_argument("--host-ref", action="store_true", help="also cross-check the device fp32 reference on CPU")
    p.add_argument("--masked-k", action="store_true", help="run the padded-pool masked_k tests only")
    p.add_argument("--trans-c-probe", action="store_true", help="confirm trans_c=True raises as documented")
    p.add_argument("-o", "--output", default=None, help="write results as JSON")
    args = p.parse_args()

    props = torch.cuda.get_device_properties(0)
    import flydsl

    print(f"device   : {props.gcnArchName}  CUs={props.multi_processor_count}")
    print(f"flydsl   : {flydsl.__version__}")
    print(f"accept   : rel_fro < {ACCEPT_REL:.0e}, no NaN/Inf   (bf16 floor ~{NOISE_FLOOR:.3e})")
    print(f"reference: per-group fp32 matmul, metrics in float64 on the host")
    print()

    _install_config_probes()
    results = []
    n_fail = 0

    if args.trans_c_probe:
        print("=" * 100)
        print("PROBE -- trans_c=True and cap_cu!=0 must raise, not silently mis-compute")
        print("=" * 100)
        dev = "cuda"
        G, m, N, Kf = 4, 256, 2048, 2048
        offs = torch.tensor([0, 256, 512, 768, 1024], dtype=torch.int64, device=dev)
        lens = torch.full((G,), m, dtype=torch.int64, device=dev)
        aa = torch.randn(G * m, N, dtype=torch.bfloat16, device=dev)
        bb = torch.randn(G * m, Kf, dtype=torch.bfloat16, device=dev)
        for label, kw in (("trans_c=True", dict(trans_c=True)), ("cap_cu=32", dict(cap_cu=32))):
            try:
                K.grouped_gemm_bf16_variable_k_flydsl_kernel(aa, bb, offs, masked_k=lens, **kw)
                print(f"  UNEXPECTED  {label} did not raise")
                n_fail += 1
            except NotImplementedError as exc:
                print(f"  OK          {label} -> NotImplementedError: {str(exc)[:90]}")
            except Exception as exc:  # noqa: BLE001
                print(f"  UNEXPECTED  {label} -> {type(exc).__name__}: {str(exc)[:120]}")
                n_fail += 1
        print()
        del aa, bb
        torch.cuda.empty_cache()

    if args.masked_k:
        print("=" * 100)
        print("masked_k -- padded pool, poisoned dead rows (notes 8.3: never executed before)")
        print("=" * 100)
        cases = []
        for model in args.models:
            cfg = TARGET_MATRIX[model]
            b0, avg_m0 = _avg_m_list(cfg, [args.batches[0]], "topk")[0]
            for layer in args.layers:
                N, Kf = cfg[layer]
                cases.append((model, layer, cfg["G"], avg_m0, N, Kf))
        for poison_label, poison in (("finite 1e4", 1e4), ("NaN", float("nan"))):
            for model, layer, G, avg_m, N, Kf in cases:
                for pad_frac in (0.25,):
                    tag = f"{model:16s} {layer} G={G:2d} avg_m={avg_m:4d} N={N:5d} K={Kf:5d} pad={pad_frac} poison={poison_label}"
                    try:
                        with warnings.catch_warnings():
                            warnings.simplefilter("ignore")
                            m = run_masked_k(G, avg_m, N, Kf, pad_frac, poison)
                        v = verdict(m)
                        n_fail += v == "FAIL"
                        print(
                            f"  {v}  {tag}\n"
                            f"        cfg={m['cfg']}  rel_fro={m['rel_fro']:.3e}  amax_rel={m['amax']:.3e}  "
                            f"nan={m['nan']} inf={m['inf']}  valid%tile_k={m['valid_mod_tilek'][:6]}",
                            flush=True,
                        )
                        results.append(
                            dict(test="masked_k", model=model, layer=layer, G=G, avg_m=avg_m, N=N, K=Kf,
                                 pad_frac=pad_frac, poison=poison_label, verdict=v,
                                 **{k: v2 for k, v2 in m.items() if k != "valid"})
                        )
                    except Exception as exc:  # noqa: BLE001
                        n_fail += 1
                        print(f"  ERROR {tag}\n        {type(exc).__name__}: {str(exc)[:300]}", flush=True)
                        traceback.print_exc()
                        results.append(dict(test="masked_k", model=model, layer=layer, verdict="ERROR",
                                            error=f"{type(exc).__name__}: {exc}"))
    else:
        print("=" * 100)
        print(f"correctness -- {args.calls} calls per point, call 1 and call {args.calls} both reported")
        print("=" * 100)
        for model in args.models:
            cfg = TARGET_MATRIX[model]
            for batch, avg_m in _avg_m_list(cfg, args.batches, "topk"):
                for layer in args.layers:
                    N, Kf = cfg[layer]
                    for op in args.ops:
                        tag = f"{model:16s} {layer} {op:14s} G={cfg['G']:2d} b={batch} avg_m={avg_m:4d} N={N:5d} K={Kf:5d}"
                        try:
                            with warnings.catch_warnings():
                                warnings.simplefilter("ignore")
                                r = run_case(op, cfg["G"], avg_m, N, Kf, args.calls, args.host_ref)
                            m1, mL = r["call1"], r[f"call{args.calls}"]
                            v1, vL = verdict(m1), verdict(mL)
                            n_fail += vL == "FAIL"
                            extra = ""
                            if args.host_ref and "host_vs_dev_ref" in r:
                                extra = f"  hostref_delta={r['host_vs_dev_ref']['rel_fro']:.2e}"
                            flag = "" if v1 == vL else f"   <-- call1 {v1}, call{args.calls} {vL}"
                            print(
                                f"  {vL}  {tag}  cfg={r['cfg']}\n"
                                f"        call1  rel={m1['rel_fro']:.4e} amax={m1['amax']:.2e} nan={m1['nan']} inf={m1['inf']}\n"
                                f"        call{args.calls}  rel={mL['rel_fro']:.4e} amax={mL['amax']:.2e} nan={mL['nan']} inf={mL['inf']}"
                                f"  allclose={mL['allclose']}{extra}{flag}",
                                flush=True,
                            )
                            results.append(
                                dict(test="numeric", model=model, layer=layer, op=op, G=cfg["G"], batch=batch,
                                     avg_m=avg_m, N=N, K=Kf, cfg=r["cfg"], verdict=vL, verdict_call1=v1,
                                     call1=m1, last=mL,
                                     host_vs_dev_ref=r.get("host_vs_dev_ref"))
                            )
                        except Exception as exc:  # noqa: BLE001
                            n_fail += 1
                            print(f"  ERROR {tag}\n        {type(exc).__name__}: {str(exc)[:400]}", flush=True)
                            traceback.print_exc()
                            results.append(dict(test="numeric", model=model, layer=layer, op=op, verdict="ERROR",
                                                error=f"{type(exc).__name__}: {exc}"))

    print()
    print(f"SUMMARY: {len(results)} points, {n_fail} failure(s)")
    if args.output:
        os.makedirs(os.path.dirname(os.path.abspath(args.output)), exist_ok=True)
        with open(args.output, "w") as fh:
            json.dump(results, fh, indent=1, default=str)
        print(f"JSON -> {args.output}")
    return 1 if n_fail else 0


if __name__ == "__main__":
    sys.exit(main())
