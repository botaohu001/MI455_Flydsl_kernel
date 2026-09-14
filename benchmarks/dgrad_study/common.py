#!/usr/bin/env python3
"""Shared plumbing for the dgrad transposed-weight-cache study.

One process holds both turbo's Triton grouped GEMM and the gfx1250 flydsl kernel
(loaded by path), so every number in a run shares one clock regime.  The box is
not clock-pinned, so sclk is sampled next to every measurement.
"""
from __future__ import annotations

import importlib.util
import re
import statistics
import subprocess
import sys
import time

import torch
import triton
import triton.language as tl
from pathlib import Path

_REPO = Path(__file__).resolve().parent.parent.parent

KERNEL_PATH = str(_REPO / "kernel" / "reference" / "grouped_gemm_bf16_kernel_gfx1250.py")

# G, (N, K) per layer, and the avg_m values the study asks for.  N/K are the
# *forward* weight dims: w is [G, N, K], fwd out = a[M,K] @ w[g].T.
MATRIX = {
    "gpt-oss-20b":     dict(G=4,  fc1=(5760, 2880), fc2=(2880, 2880), avg_m=(512, 1024, 2048)),
    "qwen3-30b-a3b":   dict(G=16, fc1=(4096, 2048), fc2=(2048, 2048), avg_m=(512, 1024, 2048)),
    "qwen3-235b-a22b": dict(G=16, fc1=(8192, 4096), fc2=(4096, 4096), avg_m=(512, 1024, 2048)),
    "deepseek-v3":     dict(G=32, fc1=(4096, 7168), fc2=(7168, 2048), avg_m=(128, 256, 512)),
}

N_SWEEP = (1, 2, 4, 8, 16, 32)


# --------------------------------------------------------------------------- #
# loading
# --------------------------------------------------------------------------- #
def load_flydsl_kernel(path: str = KERNEL_PATH):
    spec = importlib.util.spec_from_file_location("gg_gfx1250", path)
    mod = importlib.util.module_from_spec(spec)
    sys.modules["gg_gfx1250"] = mod
    spec.loader.exec_module(mod)
    return mod


def load_turbo():
    import primus_turbo.pytorch  # noqa: F401  (registers the custom ops)
    from primus_turbo.pytorch.core.backend import BackendType
    from primus_turbo.pytorch.kernels.grouped_gemm.grouped_gemm_impl import grouped_gemm_impl
    from primus_turbo.pytorch.kernels.grouped_gemm.grouped_gemm_utils import group_offs_from_lens

    return grouped_gemm_impl, group_offs_from_lens, BackendType


# --------------------------------------------------------------------------- #
# sclk
# --------------------------------------------------------------------------- #
_SMI_GPU = 1


def sclk_mhz() -> float:
    """Mean GFX-die clock in MHz.  Clocks are NOT pinned on this box."""
    try:
        out = subprocess.run(
            ["amd-smi", "metric", "-g", str(_SMI_GPU), "-c", "--csv"],
            capture_output=True, text=True, timeout=20, check=True,
        ).stdout.strip().splitlines()
        hdr, row = out[0].split(","), out[1].split(",")
        vals = [float(v) for h, v in zip(hdr, row)
                if re.fullmatch(r"gfx_\d+_clk", h.strip()) and v.strip().replace(".", "").isdigit()]
        return round(sum(vals) / len(vals), 1) if vals else float("nan")
    except Exception:  # noqa: BLE001
        return float("nan")


# --------------------------------------------------------------------------- #
# timing
# --------------------------------------------------------------------------- #
def _once(fn, iters: int) -> float:
    """Wall ms per call over ``iters`` back-to-back launches, syncing only at the ends."""
    torch.cuda.synchronize()
    t0 = time.perf_counter()
    for _ in range(iters):
        fn()
    torch.cuda.synchronize()
    return (time.perf_counter() - t0) * 1e3 / iters


def calibrate(fn, target_ms: float = 40.0, lo: int = 3, hi: int = 300) -> int:
    """Pick an iteration count so one repeat is roughly ``target_ms`` of work."""
    fn()
    est = _once(fn, 3)
    if est <= 0:
        return hi
    return max(lo, min(hi, int(round(target_ms / est))))


class Interleaved:
    """Round-robin several candidates so clock drift hits them all the same way.

    Measuring A's five repeats then B's five would let a 15% sclk excursion land
    entirely on one of them; the whole point of this study is a ratio between A
    and B, so the excursion has to be shared.
    """

    def __init__(self, warmup: int = 5, repeats: int = 5):
        self.warmup, self.repeats = warmup, repeats
        self.fns: dict[str, tuple] = {}

    def add(self, name: str, fn, target_ms: float = 40.0, max_iters: int = 300):
        self.fns[name] = (fn, target_ms, max_iters)

    def run(self, verbose=False):
        iters, samples = {}, {name: [] for name in self.fns}
        for name, (fn, target_ms, max_iters) in self.fns.items():
            for _ in range(self.warmup):
                fn()
            iters[name] = calibrate(fn, target_ms, hi=max_iters)
            if verbose:
                print(f"        calib {name}: iters={iters[name]}", flush=True)
        clocks = []
        for _ in range(self.repeats):
            for name, (fn, _t, _m) in self.fns.items():
                samples[name].append(_once(fn, iters[name]))
            clocks.append(sclk_mhz())
        out = {}
        for name, xs in samples.items():
            med = statistics.median(xs)
            cv = statistics.stdev(xs) / statistics.mean(xs) if len(xs) > 1 else 0.0
            out[name] = dict(ms=med, cv=cv, iters=iters[name], samples=[round(x, 5) for x in xs])
        return out, clocks


# --------------------------------------------------------------------------- #
# case setup
# --------------------------------------------------------------------------- #
def make_case(G: int, avg_m: int, N: int, K: int, dev="cuda", dtype=torch.bfloat16, seed=0):
    """Balanced groups.  ``w`` is the forward weight [G,N,K]; dgrad is dout[M,N] @ w[g]."""
    torch.manual_seed(seed)
    M = G * avg_m
    lens = torch.full((G,), avg_m, dtype=torch.int64, device=dev)
    zero = torch.zeros(1, dtype=torch.int64, device=dev)
    offs = torch.cat([zero, lens.cumsum(0)]).to(torch.int64)
    w = torch.randn(G, N, K, dtype=dtype, device=dev)
    dout = torch.randn(M, N, dtype=dtype, device=dev)
    return dict(G=G, avg_m=avg_m, M=M, N=N, K=K, lens=lens, offs=offs, w=w, dout=dout)


def fp32_ref_dgrad(case):
    """da[rows] = dout[rows] @ w[g], per group, in fp32.

    fp32 and not fp64: UPSTREAM_NOTES section 6 records a device fp64 matmul giving
    the wrong answer 11 times in 12 on this part.
    """
    G, avg_m, w, dout = case["G"], case["avg_m"], case["w"], case["dout"]
    return torch.cat([dout[g * avg_m:(g + 1) * avg_m].float() @ w[g].float() for g in range(G)])


def rel_fro(x, ref) -> float:
    return (x.float() - ref).norm().item() / ref.norm().item()


# --------------------------------------------------------------------------- #
# a transpose that is not ashamed of itself
# --------------------------------------------------------------------------- #
@triton.jit
def _tr_kernel(SRC, DST, N, K, BN: tl.constexpr, BK: tl.constexpr):
    """[G,N,K] -> [G,K,N].  One program per (n-tile, k-tile, g).

    ``b.transpose(1,2).contiguous()`` moves these bytes at roughly 1.1-1.4 TB/s
    on this part because one of its two sides is strided by an element.  Staging
    a BN x BK tile makes both sides move whole lines.
    """
    g = tl.program_id(2)
    n0 = tl.program_id(0) * BN
    k0 = tl.program_id(1) * BK
    rn = n0 + tl.arange(0, BN)
    rk = k0 + tl.arange(0, BK)
    mn, mk = rn < N, rk < K
    tile = tl.load(SRC + g * N * K + rn[:, None] * K + rk[None, :],
                   mask=mn[:, None] & mk[None, :], other=0)
    tl.store(DST + g * N * K + rk[:, None] * N + rn[None, :], tl.trans(tile),
             mask=mk[:, None] & mn[None, :])


def fast_nn_weight_nt(b: torch.Tensor, out: torch.Tensor | None = None,
                      BN: int = 128, BK: int = 128) -> torch.Tensor:
    """Drop-in replacement for ``make_nn_weight_nt``.  Bit-exact, ~12x faster."""
    assert b.dim() == 3, f"expected [G,K,N], got {tuple(b.shape)}"
    G, N, K = b.shape
    if out is None:
        out = torch.empty((G, K, N), dtype=b.dtype, device=b.device)
    _tr_kernel[(triton.cdiv(N, BN), triton.cdiv(K, BK), G)](b, out, N, K, BN=BN, BK=BK, num_warps=4)
    return out
