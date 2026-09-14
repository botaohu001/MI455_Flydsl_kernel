#!/usr/bin/env python3
###############################################################################
# Two cheap probes of documented open questions about the gfx1250 kernel.
###############################################################################

"""Answer two questions the kernel's notes leave open, since both are cheap here.

1. **The group-count bound.** ``GroupedGEMMVariableKFlyDSLBackend.MAX_G = 64`` is a
   *gfx950 MFMA* measurement ("clean through G=65, wrong past it"), and
   KERNEL_REVIEW.md warns not to assume it carries over. The delivery matrix only
   reaches G=32, so nothing in it tests the bound. This sweeps G past it and checks
   numerics, so the dispatcher's cap can be set from data instead of inherited.

2. **The MI455X XCD count.** UPSTREAM_NOTES.md section 8.13 pins ``num_xcd=1``
   "purely from not knowing", and amd-smi on this part reports eight gfx_N_clk
   domains. This measures ``num_xcd=8`` against the shipped default on a few rows,
   which is the only thing that decides whether the knob is worth anything.
"""

from __future__ import annotations

import os
import statistics
import sys
import warnings

import torch
import torch.utils.benchmark as benchmark

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from primus_turbo.flydsl.grouped_gemm import (  # noqa: E402
    grouped_gemm_bf16_kernel_gfx1250 as K,
)

warnings.simplefilter("ignore")
ACCEPT = 1e-2


def err(out, ref):
    o = out.detach().to("cpu", torch.float64)
    r = ref.detach().to("cpu", torch.float64)
    if torch.isnan(o).any() or torch.isinf(o).any():
        return float("nan")
    return float((o - r).norm()) / float(r.norm())


def timed(fn, warmup=5, iters=20, repeats=3):
    for _ in range(warmup):
        fn()
    torch.cuda.synchronize()
    t = benchmark.Timer(stmt="fn()", globals={"fn": fn})
    return statistics.median(t.timeit(iters).mean * 1e3 for _ in range(repeats))


###############################################################################
print("=" * 96)
print("PROBE 1 -- group-count bound.  MAX_G=64 in the registry is a gfx950 number.")
print("=" * 96)
dev = "cuda"
avg_m, N, Kf = 256, 2048, 2048
print(f"shape per group: avg_m={avg_m} N={N} K={Kf};  acceptance rel_fro < {ACCEPT:.0e}\n")
print(f"{'G':>5s}  {'fwd':>12s}  {'dgrad':>12s}  {'wgrad':>12s}")
for G in (32, 48, 64, 65, 80, 96, 128, 160):
    torch.manual_seed(0)
    total_m = G * avg_m
    lens = torch.full((G,), avg_m, dtype=torch.int64, device=dev)
    offs = torch.cat([torch.zeros(1, dtype=torch.int64, device=dev), lens.cumsum(0)])
    x = torch.randn(total_m, Kf, dtype=torch.bfloat16, device=dev)
    w = torch.randn(G, N, Kf, dtype=torch.bfloat16, device=dev)
    dout = torch.randn(total_m, N, dtype=torch.bfloat16, device=dev)

    cells = []
    for op in ("fwd", "dgrad", "wgrad"):
        try:
            if op == "fwd":
                out = None
                for _ in range(4):
                    out = K.grouped_gemm_bf16_nt_flydsl_kernel(x, w, offs)
                ref = torch.cat([x[i * avg_m : (i + 1) * avg_m].float() @ w[i].float().t() for i in range(G)])
            elif op == "dgrad":
                w_nt = K.make_nn_weight_nt(w)
                out = None
                for _ in range(4):
                    out = K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=w_nt)
                ref = torch.cat([dout[i * avg_m : (i + 1) * avg_m].float() @ w[i].float() for i in range(G)])
                del w_nt
            else:
                out = None
                for _ in range(4):
                    out = K.grouped_gemm_bf16_variable_k_flydsl_kernel(dout, x, offs, masked_k=lens)
                ref = torch.stack([
                    dout[i * avg_m : (i + 1) * avg_m].float().t() @ x[i * avg_m : (i + 1) * avg_m].float()
                    for i in range(G)
                ])
            torch.cuda.synchronize()
            e = err(out, ref)
            cells.append(f"{'PASS' if e < ACCEPT else 'FAIL'} {e:.1e}")
            del out, ref
        except Exception as exc:  # noqa: BLE001
            cells.append(f"{type(exc).__name__[:11]}")
        torch.cuda.empty_cache()
    print(f"{G:5d}  " + "  ".join(f"{c:>12s}" for c in cells), flush=True)
    del x, w, dout
    torch.cuda.empty_cache()

###############################################################################
print()
print("=" * 96)
print("PROBE 2 -- num_xcd.  Shipped default is 1 because the XCD count was unknown;")
print("           amd-smi reports 8 gfx clock domains on this part.")
print("=" * 96)
cases = [
    ("gpt-oss-20b fc1", 4, 512, 5760, 2880),
    ("qwen3-30b fc1", 16, 512, 4096, 2048),
    ("qwen3-235b fc1", 16, 2048, 8192, 4096),
    ("deepseek-v3 fc1", 32, 128, 4096, 7168),
]
print(f"\n{'row':18s} {'op':6s} {'xcd1 ms':>9s} {'xcd8 ms':>9s} {'xcd8/xcd1':>10s}  {'verdict':>9s}")
for label, G, avg_m, N, Kf in cases:
    torch.manual_seed(0)
    total_m = G * avg_m
    lens = torch.full((G,), avg_m, dtype=torch.int64, device=dev)
    offs = torch.cat([torch.zeros(1, dtype=torch.int64, device=dev), lens.cumsum(0)])
    x = torch.randn(total_m, Kf, dtype=torch.bfloat16, device=dev)
    w = torch.randn(G, N, Kf, dtype=torch.bfloat16, device=dev)
    dout = torch.randn(total_m, N, dtype=torch.bfloat16, device=dev)
    for op in ("fwd", "wgrad"):
        try:
            if op == "fwd":
                f1 = lambda: K.grouped_gemm_bf16_nt_flydsl_kernel(x, w, offs)  # noqa: E731
                f8 = lambda: K.grouped_gemm_bf16_nt_flydsl_kernel(x, w, offs, num_xcd=8, xcd_band=32)  # noqa: E731
            else:
                f1 = lambda: K.grouped_gemm_bf16_variable_k_flydsl_kernel(dout, x, offs, masked_k=lens)  # noqa: E731
                f8 = lambda: K.grouped_gemm_bf16_variable_k_flydsl_kernel(  # noqa: E731
                    dout, x, offs, masked_k=lens, num_xcd=8, xcd_band=32
                )
            # Interleave so a clock excursion cannot favour one side.
            t1a, t8a = timed(f1), timed(f8)
            t8b, t1b = timed(f8), timed(f1)
            t1, t8 = (t1a + t1b) / 2, (t8a + t8b) / 2
            e = err(f8(), f1().float())
            v = "faster" if t8 < t1 * 0.99 else ("slower" if t8 > t1 * 1.01 else "flat")
            if not (e < ACCEPT):
                v = f"NUMERIC {e:.0e}"
            print(f"{label:18s} {op:6s} {t1:9.4f} {t8:9.4f} {t8 / t1:10.4f}  {v:>9s}", flush=True)
        except Exception as exc:  # noqa: BLE001
            print(f"{label:18s} {op:6s} {type(exc).__name__}: {str(exc)[:60]}", flush=True)
    del x, w, dout
    torch.cuda.empty_cache()
