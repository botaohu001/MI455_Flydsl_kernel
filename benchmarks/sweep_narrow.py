#!/usr/bin/env python3
"""Does "tile_n=128 with tile_k=64 is bad for the transposed B read" generalise?

The delivery matrix reaches that tile on exactly one cell, which is too thin a
basis for a routing rule. This sweeps synthetic shapes whose reduction length is
indivisible by 128 (so tile_k=64 is forced) across several output widths, group
counts and avg_m, and compares BN128 against BN256 with the hoist path pinned to
the same tile each time.

Run:  HIP_VISIBLE_DEVICES=2 python sweep_narrow.py
"""
from __future__ import annotations

import importlib.util
import os
import statistics
import sys

import torch

sys.path.insert(0, str(_REPO / "benchmarks" / "dgrad_study"))
import common as _c  # noqa: E402
from common import Interleaved  # noqa: E402
from pathlib import Path

_REPO = Path(__file__).resolve().parent.parent

KERNEL = str(_REPO / "kernel" / "grouped_gemm_bf16_kernel_mi455.py")
N_REDS = (2880, 1472, 4416)  # all % 64 == 0 but % 128 != 0 -> tile_k must be 64
N_OUTS = (2048, 2880, 4096)
CASES = [(G, am) for G in (4, 8) for am in (128, 512, 1024)]


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    sys.modules[name] = mod
    spec.loader.exec_module(mod)
    return mod


def main():
    _c._SMI_GPU = int(os.environ.get("HIP_VISIBLE_DEVICES", "2"))
    K = load(KERNEL, "gg_nn")
    print(f"{'N_red':>6s} {'N_out':>6s} {'G':>3s} {'avg_m':>6s} | "
          f"{'BN128 nat/hoi':>13s} {'BN256 nat/hoi':>13s} | {'BN256/BN128 native':>18s}")
    print("-" * 84)
    r128, r256, gain = [], [], []
    for N_red in N_REDS:
        for N_out in N_OUTS:
            for G, avg_m in CASES:
                assert N_red % 128, N_red
                case = _c.make_case(G, avg_m, N_red, N_out)  # w is [G, N_red, N_out]
                dout, w, offs, M = case["dout"], case["w"], case["offs"], case["M"]
                b_nt = K.make_nn_weight_nt(w)
                out = torch.empty(M, N_out, dtype=torch.bfloat16, device="cuda")
                res = {}
                for tn in (128, 256):
                    tile = dict(BLOCK_M=128, BLOCK_N=tn, BLOCK_K=64, m_warp=2, n_warp=2, num_buffers=3)
                    ref = K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=b_nt, **tile)
                    got = K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, **tile)
                    if not torch.equal(got.view(torch.int16), ref.view(torch.int16)):
                        print(f"  !! BN{tn} not bit-equal at N_red={N_red} N_out={N_out} G={G} m={avg_m}")
                    mt = K.build_m_tile_map(offs, 128)
                    base = dict(out=out, m_tiles=mt, **tile)
                    iv = Interleaved(warmup=5, repeats=3)
                    iv.add("h", lambda: K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=b_nt, **base))
                    iv.add("n", lambda: K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, **base))
                    r, _ = iv.run()
                    res[tn] = (r["h"]["ms"], r["n"]["ms"])
                    del mt
                a = res[128][0] / res[128][1]
                b = res[256][0] / res[256][1]
                g = res[128][1] / res[256][1]
                r128.append(a)
                r256.append(b)
                gain.append(g)
                print(f"{N_red:>6d} {N_out:>6d} {G:>3d} {avg_m:>6d} | {a:>13.3f} {b:>13.3f} | {g:>18.3f}")
                del case, b_nt, out
                torch.cuda.empty_cache()
    print("-" * 84)
    print(f"BN128 native/hoist : geomean {statistics.geometric_mean(r128):.4f}  "
          f"min {min(r128):.3f} max {max(r128):.3f}  ({sum(1 for x in r128 if x >= 1)}/{len(r128)} >= 1)")
    print(f"BN256 native/hoist : geomean {statistics.geometric_mean(r256):.4f}  "
          f"min {min(r256):.3f} max {max(r256):.3f}  ({sum(1 for x in r256 if x >= 1)}/{len(r256)} >= 1)")
    print(f"BN256 vs BN128 for native : geomean {statistics.geometric_mean(gain):.4f}  "
          f"min {min(gain):.3f} max {max(gain):.3f}  ({sum(1 for x in gain if x >= 1)}/{len(gain)} favour BN256)")


if __name__ == "__main__":
    main()
