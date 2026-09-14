#!/usr/bin/env python3
"""Is the native NN GEMM faster or slower than the NT GEMM fed a hoisted transpose?

Four candidates, one process, round-robin interleaved so a clock excursion lands
on all of them:

  native   nn_kernel(dout, w, offs)                  -- no copy exists at all
  hoist    nn_kernel(dout, w, offs, b_nt=prebuilt)   -- NT GEMM only, copy free
  fastpc   tiled-Triton transpose + NT GEMM, both inside the timer
  triton   turbo's Triton grouped GEMM

`hoist` is the honest GEMM-vs-GEMM comparison: same bytes read from HBM, same
output, the only difference is which axis of B is contiguous. `fastpc` is the
honest end-to-end comparison against what a caller could do today.

Run:  HIP_VISIBLE_DEVICES=2 python bench_quick.py
"""
from __future__ import annotations

import argparse
import importlib.util
import json
import os
import statistics
import subprocess
import sys
import time

import torch

sys.path.insert(0, str(_REPO / "benchmarks" / "dgrad_study"))
from common import Interleaved, fast_nn_weight_nt  # noqa: E402
import common as _c  # noqa: E402
from pathlib import Path

_REPO = Path(__file__).resolve().parent.parent

PEAK_TFLOPS = 5033.2
MATRIX = {
    "gpt-oss-20b": dict(G=4, fc1=(5760, 2880), fc2=(2880, 2880), avg_m=(512, 1024, 2048)),
    "qwen3-30b-a3b": dict(G=16, fc1=(4096, 2048), fc2=(2048, 2048), avg_m=(512, 1024, 2048)),
    "qwen3-235b-a22b": dict(G=16, fc1=(8192, 4096), fc2=(4096, 4096), avg_m=(512, 1024, 2048)),
    "deepseek-v3": dict(G=32, fc1=(4096, 7168), fc2=(7168, 2048), avg_m=(128, 256, 512)),
}


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    sys.modules[name] = mod
    spec.loader.exec_module(mod)
    return mod


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--kernel", default=str(_REPO / "kernel" / "grouped_gemm_bf16_kernel_mi455.py"))
    ap.add_argument("--smi-gpu", type=int, default=int(os.environ.get("HIP_VISIBLE_DEVICES", "2")))
    ap.add_argument("--repeats", type=int, default=5)
    ap.add_argument("--models", nargs="*", default=list(MATRIX))
    ap.add_argument("--no-triton", action="store_true")
    ap.add_argument("-o", default=str(_REPO / "results" / "nn_pipeline" / "quick_nn_vs_hoist.json"))
    args = ap.parse_args()
    _c._SMI_GPU = args.smi_gpu  # common.py hardcodes card 1

    K = load(args.kernel, "gg_nn")
    tri = None
    if not args.no_triton:
        try:
            gg_impl, _offs, BackendType = _c.load_turbo()
            tri = (gg_impl, BackendType)
        except Exception as e:  # noqa: BLE001
            print(f"!! Triton backend unavailable: {type(e).__name__}: {e}", flush=True)

    print(f"kernel : {args.kernel}")
    print(f"device : {torch.cuda.get_device_properties(0).gcnArchName}\n")
    hdr = (
        f"{'model':<16s} {'proj':<4s} {'avg_m':>5s} {'M':>6s} {'N':>5s} {'K':>5s} "
        f"{'config':<30s} {'native':>8s} {'hoist':>8s} {'fastpc':>8s} {'triton':>8s} "
        f"{'nat/hoi':>8s} {'nat/fpc':>8s} {'nat/tri':>8s} {'TF/s':>7s} {'cv%':>5s} {'sclk':>6s}"
    )
    print(hdr)
    print("-" * len(hdr))
    rows = []
    for model in args.models:
        cfg = MATRIX[model]
        G = cfg["G"]
        for proj in ("fc1", "fc2"):
            N_fwd, K_fwd = cfg[proj]
            for avg_m in cfg["avg_m"]:
                case = _c.make_case(G, avg_m, N_fwd, K_fwd)
                dout, w, offs, M = case["dout"], case["w"], case["offs"], case["M"]
                # NN convention: reduction = N_fwd, output width = K_fwd
                Kred, Nout = N_fwd, K_fwd
                b_nt = K.make_nn_weight_nt(w)
                scratch = torch.empty_like(b_nt)
                out = torch.empty(M, Nout, dtype=torch.bfloat16, device="cuda")
                # The two paths can land on different tiles (the fitted tile_n=192
                # rule is unavailable to the native path), and the index table is
                # provenance-checked against its own block_m, so each gets its own.
                mt_n = K.build_m_tile_map(offs, K._pick_config_nn(Nout, Kred, avg_m, G)[0])
                mt_h = K.build_m_tile_map(offs, K._pick_config(Nout, Kred, avg_m, G)[0])

                iv = Interleaved(warmup=6, repeats=args.repeats)
                iv.add(
                    "native",
                    lambda: K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, out=out, m_tiles=mt_n),
                )
                iv.add(
                    "hoist",
                    lambda: K.grouped_gemm_bf16_nn_flydsl_kernel(
                        dout, w, offs, b_nt=b_nt, out=out, m_tiles=mt_h
                    ),
                )

                def _fastpc():
                    fast_nn_weight_nt(w, out=scratch)
                    K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=scratch, out=out, m_tiles=mt_h)

                iv.add("fastpc", _fastpc)
                if tri is not None:
                    gg_impl, BackendType = tri
                    tri_kw = dict(
                        group_lens=case["lens"],
                        group_offs=offs,
                        num_cu=None,
                        default_backend=BackendType.TRITON.value,
                        schedule="static",
                    )
                    iv.add("triton", lambda: gg_impl(dout, w, trans_a=False, trans_b=False, **tri_kw))
                try:
                    res, clocks = iv.run()
                except Exception as e:  # noqa: BLE001
                    print(f"{model:<16s} {proj:<4s} {avg_m:>5d}  FAILED: {type(e).__name__}: {str(e)[:200]}")
                    continue

                c = K._pick_config_nn(Nout, Kred, avg_m, G)
                cs = f"BM{c[0]}/BN{c[1]}/BK{c[2]}/mw{c[3]}/nw{c[4]}/nb{c[5]}"
                flops = 2.0 * M * Nout * Kred
                nat = res["native"]["ms"]
                tf = flops / (nat * 1e-3) / 1e12
                sclk = statistics.median([x for x in clocks if x == x]) if clocks else float("nan")
                g = lambda k: res[k]["ms"] if k in res else float("nan")  # noqa: E731
                print(
                    f"{model:<16s} {proj:<4s} {avg_m:>5d} {M:>6d} {Nout:>5d} {Kred:>5d} {cs:<30s} "
                    f"{nat:>8.4f} {g('hoist'):>8.4f} {g('fastpc'):>8.4f} {g('triton'):>8.4f} "
                    f"{g('hoist') / nat:>8.3f} {g('fastpc') / nat:>8.3f} {g('triton') / nat:>8.3f} "
                    f"{tf:>7.1f} {res['native']['cv'] * 100:>5.2f} {sclk:>6.0f}",
                    flush=True,
                )
                rows.append(
                    dict(
                        model=model, proj=proj, G=G, avg_m=avg_m, M=M, N=Nout, K=Kred, config=cs,
                        tflops=tf, sclk=sclk, **{k: v for k, v in res.items()},
                    )
                )
                del case, b_nt, scratch, out, mt_n, mt_h
                torch.cuda.empty_cache()

    os.makedirs(os.path.dirname(args.o), exist_ok=True)
    with open(args.o, "w") as f:
        json.dump(rows, f, indent=1)
    if rows:
        r = [x["hoist"]["ms"] / x["native"]["ms"] for x in rows if "hoist" in x]
        print(f"\nnative vs hoist (GEMM vs GEMM): geomean {statistics.geometric_mean(r):.4f}"
              f"  min {min(r):.3f}  max {max(r):.3f}  ({sum(1 for x in r if x >= 1.0)}/{len(r)} at or above 1.0)")
        f2 = [x["fastpc"]["ms"] / x["native"]["ms"] for x in rows if "fastpc" in x]
        print(f"native vs fast per-call transpose: geomean {statistics.geometric_mean(f2):.4f}"
              f"  min {min(f2):.3f}  max {max(f2):.3f}")
    print(f"\nwrote {args.o}")


if __name__ == "__main__":
    main()
