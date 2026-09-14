#!/usr/bin/env python3
"""Part 1b -- is ``make_nn_weight_nt`` the transpose, or just *a* transpose?

N* is linear in t_transpose, so anything that makes the transpose cheaper moves
every break-even point by the same factor.  ``make_nn_weight_nt`` is
``b.transpose(1,2).contiguous()``; measured against a straight copy of the same
bytes that runs at a small fraction of achievable bandwidth.  This measures the
headroom (a plain copy) and three candidate replacements.
"""
from __future__ import annotations

import json
import os
import sys

import torch
import triton
import triton.language as tl

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common import MATRIX, Interleaved, load_flydsl_kernel, sclk_mhz  # noqa: E402


@triton.jit
def _tr_kernel(SRC, DST, N, K, BN: tl.constexpr, BK: tl.constexpr):
    """[G,N,K] -> [G,K,N], one program per (g, n-tile, k-tile).

    Reads a BNxBK tile coalesced along K, writes it coalesced along N.  Both
    sides therefore move full cache lines; the torch path only gets one of them.
    """
    g = tl.program_id(2)
    n0 = tl.program_id(0) * BN
    k0 = tl.program_id(1) * BK
    rn = n0 + tl.arange(0, BN)
    rk = k0 + tl.arange(0, BK)
    mn = rn < N
    mk = rk < K
    src = SRC + g * N * K + rn[:, None] * K + rk[None, :]
    tile = tl.load(src, mask=mn[:, None] & mk[None, :], other=0)
    dst = DST + g * N * K + rk[:, None] * N + rn[None, :]
    tl.store(dst, tl.trans(tile), mask=mk[:, None] & mn[None, :])


def triton_transpose(b, out=None, BN=64, BK=64):
    G, N, K = b.shape
    if out is None:
        out = torch.empty((G, K, N), dtype=b.dtype, device=b.device)
    grid = (triton.cdiv(N, BN), triton.cdiv(K, BK), G)
    _tr_kernel[grid](b, out, N, K, BN=BN, BK=BK, num_warps=4)
    return out


def main():
    K = load_flydsl_kernel()
    rows = []
    print(f"sclk at start: {sclk_mhz()}\n")

    seen = set()
    for model, cfg in MATRIX.items():
        for layer in ("fc1", "fc2"):
            N, Kd = cfg[layer]
            G = cfg["G"]
            if (G, N, Kd) in seen:
                continue
            seen.add((G, N, Kd))

            b = torch.randn(G, N, Kd, dtype=torch.bfloat16, device="cuda")
            dst = torch.empty((G, Kd, N), dtype=torch.bfloat16, device="cuda")
            plain = torch.empty_like(b)
            nbytes = b.numel() * 2

            ref = b.transpose(1, 2).contiguous()
            variants = {}
            # the headroom: same bytes in, same bytes out, no index permutation
            variants["copy_same_bytes"] = lambda: plain.copy_(b)
            variants["torch_contiguous"] = lambda: K.make_nn_weight_nt(b)
            variants["torch_copy_into"] = lambda: dst.copy_(b.transpose(1, 2))
            for bn, bk in ((32, 32), (64, 64), (128, 64), (64, 128), (128, 128)):
                variants[f"triton_{bn}x{bk}"] = (
                    lambda bn=bn, bk=bk: triton_transpose(b, dst, BN=bn, BK=bk)
                )

            # correctness of every candidate before it is timed
            ok = {}
            for name, fn in variants.items():
                if name == "copy_same_bytes":
                    ok[name] = True
                    continue
                dst.zero_()
                got = fn()
                torch.cuda.synchronize()
                got = dst if got is None else got
                ok[name] = bool(torch.equal(got, ref))

            it = Interleaved(warmup=5, repeats=7)
            for name, fn in variants.items():
                it.add(name, fn, target_ms=40.0)
            res, clocks = it.run()

            base = res["torch_contiguous"]["ms"]
            print(f"{model:16s} {layer}  G={G:2d} N={N:5d} K={Kd:5d}  {nbytes/2**20:7.1f} MiB")
            for name in variants:
                ms = res[name]["ms"]
                gbs = 2 * nbytes / (ms * 1e-3) / 1e9
                print(f"    {name:18s} {ms:8.4f} ms  {gbs:7.0f} GB/s  "
                      f"x{base/ms:5.2f}  cv {res[name]['cv']*100:4.2f}%  "
                      f"{'ok' if ok[name] else 'MISMATCH'}")
                rows.append(dict(Model=model, Layer=layer, G=G, N=N, K=Kd,
                                 MiB=round(nbytes / 2**20, 2), variant=name,
                                 ms=round(ms, 5), GBps=round(gbs, 1),
                                 speedup_vs_torch=round(base / ms, 4),
                                 cv=round(res[name]["cv"], 5), correct=ok[name],
                                 sclk_min=min(clocks), sclk_max=max(clocks)))
            print(flush=True)
            del b, dst, plain, ref
            torch.cuda.empty_cache()

    import pandas as pd
    out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "results/part1b_transpose")
    pd.DataFrame(rows).to_csv(out + ".csv", index=False)
    with open(out + ".json", "w") as fh:
        json.dump(rows, fh, indent=1)
    print(f"wrote {out}.csv")


if __name__ == "__main__":
    main()
