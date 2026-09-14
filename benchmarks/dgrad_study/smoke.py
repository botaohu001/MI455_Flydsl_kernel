#!/usr/bin/env python3
"""Smoke test: can one process hold both turbo's Triton grouped GEMM and the
gfx1250 flydsl kernel (loaded by path) under flydsl 0.2.4?

Everything in this study depends on the answer being yes: the Triton baseline and
the flydsl timings have to share a process so they share a clock regime.
"""
from __future__ import annotations

import importlib.util
import os
import sys

import torch
from pathlib import Path

_REPO = Path(__file__).resolve().parent.parent.parent

KERNEL = str(_REPO / "kernel" / "reference" / "grouped_gemm_bf16_kernel_gfx1250.py")


def load_kernel(path=KERNEL):
    spec = importlib.util.spec_from_file_location("gg_gfx1250", path)
    mod = importlib.util.module_from_spec(spec)
    sys.modules["gg_gfx1250"] = mod
    spec.loader.exec_module(mod)
    return mod


def main():
    import flydsl

    print(f"flydsl        : {flydsl.__version__}")
    print(f"torch         : {torch.__version__}")
    p = torch.cuda.get_device_properties(0)
    print(f"device        : {p.gcnArchName}  CUs={p.multi_processor_count}  "
          f"HBM={p.total_memory / 2**30:.1f} GiB ({p.total_memory / 1e9:.1f} GB)")
    print(f"visible       : HIP_VISIBLE_DEVICES={os.environ.get('HIP_VISIBLE_DEVICES')}  "
          f"count={torch.cuda.device_count()}")

    print("\n[1] import primus_turbo.pytorch ...", flush=True)
    import primus_turbo.pytorch as turbo  # noqa: F401
    from primus_turbo.pytorch.core.backend import BackendType
    from primus_turbo.pytorch.kernels.grouped_gemm.grouped_gemm_impl import grouped_gemm_impl
    from primus_turbo.pytorch.kernels.grouped_gemm.grouped_gemm_utils import group_offs_from_lens
    print("    ok, TRITON =", BackendType.TRITON.value)

    print("\n[2] load gfx1250 kernel by path ...", flush=True)
    K = load_kernel()
    print("    ok:", [n for n in ("make_nn_weight_nt", "grouped_gemm_bf16_nn_flydsl_kernel",
                                  "grouped_gemm_bf16_nt_flydsl_kernel") if hasattr(K, n)])

    print("\n[3] tiny dgrad both ways ...", flush=True)
    G, avg_m, N, Kd = 4, 128, 512, 256
    dev = "cuda"
    M = G * avg_m
    lens = torch.full((G,), avg_m, dtype=torch.int64, device=dev)
    offs = group_offs_from_lens(lens)
    w = torch.randn(G, N, Kd, dtype=torch.bfloat16, device=dev)   # forward weight [G,N,K]
    dout = torch.randn(M, N, dtype=torch.bfloat16, device=dev)

    tri = grouped_gemm_impl(dout, w, trans_a=False, trans_b=False, group_lens=lens,
                            group_offs=offs, num_cu=None,
                            default_backend=BackendType.TRITON.value, schedule="static")
    torch.cuda.synchronize()
    print("    triton out", tuple(tri.shape), tri.dtype)

    w_nt = K.make_nn_weight_nt(w)
    for _ in range(4):  # notes: burn the first calls
        fly = K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=w_nt)
    torch.cuda.synchronize()
    print("    flydsl out", tuple(fly.shape), fly.dtype)

    ref = torch.cat([dout[g * avg_m:(g + 1) * avg_m].float() @ w[g].float() for g in range(G)])

    def rel(x):
        return (x.float() - ref).norm().item() / ref.norm().item()

    print(f"    rel_fro  triton={rel(tri):.3e}   flydsl={rel(fly):.3e}")
    print(f"    flydsl vs triton bitwise-equal: {torch.equal(fly, tri)}")
    print("\nSMOKE OK")


if __name__ == "__main__":
    main()
