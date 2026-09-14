#!/usr/bin/env python3
"""Why is gpt-oss fc2 the one shape where native NN gives up more than 2%?

Both of its bad cells are tile_k=64 (K_red = 2880 is not a multiple of 128, so the
reduction depth cannot be raised). Every cell that keeps up with NT is tile_k=128.
This scans tiles and knobs on the two bad cells with the hoist path pinned to the
*same* tile, so nothing but the B path differs.

Run:  HIP_VISIBLE_DEVICES=2 python probe_outlier.py
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
# (label, G, N_fwd, K_fwd, avg_m); N_red = N_fwd, N_out = K_fwd
CASES = [
    ("gpt-oss fc2 m512", 4, 2880, 2880, 512),
    ("gpt-oss fc2 m2048", 4, 2880, 2880, 2048),
    ("control: gpt-oss fc1 m1024 (tile_k=128)", 4, 5760, 2880, 1024),
]
# (BLOCK_M, BLOCK_N, BLOCK_K, mw, nw, nb)
TILES = [
    (128, 128, 64, 2, 2, 3),
    (128, 128, 64, 2, 2, 2),
    (256, 256, 64, 2, 2, 3),
    (128, 256, 64, 2, 2, 3),
    (256, 128, 64, 2, 2, 3),
    (128, 128, 32, 2, 2, 3),
    (256, 256, 128, 2, 2, 2),
]


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    sys.modules[name] = mod
    spec.loader.exec_module(mod)
    return mod


def main():
    _c._SMI_GPU = int(os.environ.get("HIP_VISIBLE_DEVICES", "2"))
    K = load(KERNEL, "gg_nn")
    for label, G, N_fwd, K_fwd, avg_m in CASES:
        Kred, Nout = N_fwd, K_fwd
        print(f"\n===== {label}   N_red={Kred} N_out={Nout} G={G} avg_m={avg_m} =====")
        print(f"{'tile':<28s} {'hoist ms':>9s} {'native ms':>10s} {'nat/hoist':>9s} "
              f"{'pad':>4s} {'immwalk':>8s} {'note':<30s}")
        case = _c.make_case(G, avg_m, N_fwd, K_fwd)
        dout, w, offs, M = case["dout"], case["w"], case["offs"], case["M"]
        b_nt = K.make_nn_weight_nt(w)
        best = None
        for tm, tn, tk, mw, nw, nb in TILES:
            if Kred % tk:
                print(f"BM{tm}/BN{tn}/BK{tk}/nb{nb}".ljust(28) + f"  (skipped: {Kred} % {tk} != 0)")
                continue
            tile = dict(BLOCK_M=tm, BLOCK_N=tn, BLOCK_K=tk, m_warp=mw, n_warp=nw, num_buffers=nb)
            pad = K._nn_b_pad(tn)
            try:
                ref = K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=b_nt, **tile)
                got = K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, **tile)
                eq = torch.equal(got.view(torch.int16), ref.view(torch.int16))
                gi = K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_imm_walk=1, **tile)
                eqi = torch.equal(gi.view(torch.int16), ref.view(torch.int16))
            except Exception as e:  # noqa: BLE001
                print(f"BM{tm}/BN{tn}/BK{tk}/nb{nb}".ljust(28) + f"  FAILED {type(e).__name__}: {str(e)[:90]}")
                continue
            o = torch.empty(M, Nout, dtype=torch.bfloat16, device="cuda")
            mt = K.build_m_tile_map(offs, tm)
            base = dict(out=o, m_tiles=mt, **tile)
            iv = Interleaved(warmup=6, repeats=4)
            iv.add("hoist", lambda: K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=b_nt, **base))
            iv.add("native", lambda: K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, **base))
            iv.add("immwalk", lambda: K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_imm_walk=1, **base))
            r, _ck = iv.run()
            ratio = r["hoist"]["ms"] / r["native"]["ms"]
            note = "" if (eq and eqi) else f"NOT BIT-EQUAL native={eq} immwalk={eqi}"
            print(f"BM{tm}/BN{tn}/BK{tk}/nb{nb}".ljust(28)
                  + f" {r['hoist']['ms']:>9.4f} {r['native']['ms']:>10.4f} {ratio:>9.3f} "
                    f"{pad:>4d} {r['hoist']['ms'] / r['immwalk']['ms']:>8.3f} {note:<30s}")
            if best is None or r["native"]["ms"] < best[1]:
                best = (f"BM{tm}/BN{tn}/BK{tk}/nb{nb}", r["native"]["ms"], r["hoist"]["ms"])
            del o, mt
            torch.cuda.empty_cache()
        if best:
            print(f"  -> fastest native tile here: {best[0]} at {best[1]:.4f} ms "
                  f"(hoist on the same tile {best[2]:.4f} ms)")
        del case, b_nt
        torch.cuda.empty_cache()


if __name__ == "__main__":
    main()
