#!/usr/bin/env python3
"""Where does the native NN pipeline's deficit against the NT pipeline come from?

The headline sweep compares each path on *its own* best tile, which conflates two
things: the cost of the transposed B read, and the fact that `_pick_config`'s
fitted tile_n=192 rule is unavailable to the native path. This pins both tiles to
the same value so only the B path differs, then sweeps the two knobs that could
plausibly move it:

  b_pad       LDS row pad for the transposed B stage. At pad=16 the 8 rows one
              transpose read touches land 16 B apart mod 128, i.e. on all 32
              banks -- conflict-free by construction. 32/64/80 test that claim
              against the hardware instead of trusting the arithmetic.
  b_imm_walk  walk B's reduction with imm_offset off one hoisted descriptor,
              instead of rebuilding the descriptor every k-tile.

Run:  HIP_VISIBLE_DEVICES=2 python ab_variants.py
"""
from __future__ import annotations

import argparse
import importlib.util
import json
import os
import statistics
import sys

import torch

sys.path.insert(0, str(_REPO / "benchmarks" / "dgrad_study"))
import common as _c  # noqa: E402
from common import Interleaved  # noqa: E402
from pathlib import Path

_REPO = Path(__file__).resolve().parent.parent

CASES = [
    ("gpt-oss-20b", "fc1", 4, 5760, 2880, 1024),
    ("gpt-oss-20b", "fc2", 4, 2880, 2880, 2048),
    ("qwen3-30b-a3b", "fc1", 16, 4096, 2048, 2048),
    ("qwen3-235b-a22b", "fc1", 16, 8192, 4096, 2048),
    ("deepseek-v3", "fc1", 32, 4096, 7168, 512),
    ("deepseek-v3", "fc2", 32, 7168, 2048, 128),
]


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    sys.modules[name] = mod
    spec.loader.exec_module(mod)
    return mod


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--kernel", default=str(_REPO / "kernel" / "grouped_gemm_bf16_kernel_mi455.py"))
    ap.add_argument("--repeats", type=int, default=5)
    ap.add_argument("-o", default=str(_REPO / "results" / "nn_pipeline" / "ab_variants.json"))
    args = ap.parse_args()
    _c._SMI_GPU = int(os.environ.get("HIP_VISIBLE_DEVICES", "2"))
    K = load(args.kernel, "gg_nn")

    PADS = [16, 32, 48, 64, 80, 96, 112, 128, 144, 160]
    names = ["hoist"] + [f"pad{p}" for p in PADS] + ["immwalk32"]
    hdr = (f"{'case':<26s} {'tile':<20s} {'hoist':>9s} "
           + " ".join(f"{n:>6s}" for n in names[1:]) + f" {'sclk':>6s}")
    print(hdr)
    print("-" * len(hdr))
    rows = []
    for model, proj, G, N_fwd, K_fwd, avg_m in CASES:
        case = _c.make_case(G, avg_m, N_fwd, K_fwd)
        dout, w, offs, M = case["dout"], case["w"], case["offs"], case["M"]
        Kred, Nout = N_fwd, K_fwd
        # One tile for everybody: whatever the native path would pick.
        tm, tn, tk, mw, nw, nb = K._pick_config_nn(Nout, Kred, avg_m, G)
        tile = dict(BLOCK_M=tm, BLOCK_N=tn, BLOCK_K=tk, m_warp=mw, n_warp=nw, num_buffers=nb)
        b_nt = K.make_nn_weight_nt(w)
        out = torch.empty(M, Nout, dtype=torch.bfloat16, device="cuda")
        mt = K.build_m_tile_map(offs, tm)
        base = dict(out=out, m_tiles=mt, **tile)

        ref = K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=b_nt, **tile).clone()
        iv = Interleaved(warmup=6, repeats=args.repeats)
        variants = {"hoist": dict(b_nt=b_nt)}
        variants.update({f"pad{p}": dict(b_pad=p) for p in PADS})
        variants["immwalk32"] = dict(b_pad=32, b_imm_walk=1)
        bad = []
        for n, kw in variants.items():
            try:  # correctness gate before timing: a variant that is wrong is not a data point
                got = K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, **tile, **kw)
                if not torch.equal(got.view(torch.int16), ref.view(torch.int16)):
                    d = (got.float() - ref.float()).abs().max().item()
                    bad.append(f"{n}(max|d|={d:.2e})")
                    continue
            except Exception as e:  # noqa: BLE001
                bad.append(f"{n}({type(e).__name__}: {str(e)[:80]})")
                continue
            iv.add(n, (lambda kw_: lambda: K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, **base, **kw_))(kw))
        res, clocks = iv.run()
        sclk = statistics.median([x for x in clocks if x == x]) if clocks else float("nan")
        ts = f"BM{tm}/BN{tn}/BK{tk}/nb{nb}"
        cells = [f"{res[n]['ms'] and res['hoist']['ms'] / res[n]['ms']:.3f}" if n in res else "--" for n in names]
        print(f"{model + ' ' + proj + ' m' + str(avg_m):<26s} {ts:<20s} "
              f"{res['hoist']['ms']:.4f}ms " + " ".join(f"{c:>6s}" for c in cells[1:]) + f" {sclk:>6.0f}")
        if bad:
            print(f"    !! not bit-equal to hoist / failed: {', '.join(bad)}")
        rows.append(dict(model=model, proj=proj, avg_m=avg_m, tile=ts, sclk=sclk,
                         bad=bad, **{n: res[n]["ms"] for n in res}))
        del case, b_nt, out, mt
        torch.cuda.empty_cache()

    print("\ncell = ms / (hoist_ms / ms)   -- the second number is speed relative to hoist, >1 is faster")
    for n in names[1:]:
        r = [x["hoist"] / x[n] for x in rows if n in x]
        if r:
            print(f"  {n:<12s} geomean vs hoist {statistics.geometric_mean(r):.4f}"
                  f"  min {min(r):.3f}  max {max(r):.3f}")
    os.makedirs(os.path.dirname(args.o), exist_ok=True)
    json.dump(rows, open(args.o, "w"), indent=1)
    print(f"\nwrote {args.o}")


if __name__ == "__main__":
    main()
