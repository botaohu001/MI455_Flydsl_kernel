#!/usr/bin/env python3
"""The delivery matrix: fwd / dgrad / wgrad, 24 rows each, one process.

dgrad uses the **native NN pipeline** -- `b` is the forward weight, read in place,
no transposed copy anywhere. A fourth table compares the four dgrad calibres
(native / hoist / fast per-call transpose / Triton) interleaved in the same
session so a clock excursion lands on all of them.

Timing discipline: >= 6 warmup calls (which also burns past the first-call
corruption UPSTREAM_NOTES section 6.5 records for gpt-oss fc2 dgrad), each
sample is a timed loop of enough launches to fill ~40 ms, and the reported number
is the median of `--repeats` samples with its cv. sclk is sampled next to every
measurement because this box is not clock-pinned.

Run:  HIP_VISIBLE_DEVICES=2 python bench_matrix.py
"""
from __future__ import annotations

import argparse
import csv
import importlib.util
import json
import os
import statistics
import sys

import torch

sys.path.insert(0, str(_REPO / "benchmarks" / "dgrad_study"))
import common as _c  # noqa: E402
from common import Interleaved, fast_nn_weight_nt  # noqa: E402
from pathlib import Path

_REPO = Path(__file__).resolve().parent.parent

PEAK_TFLOPS = 5033.2
CV_FLAG = 0.02

MATRIX = {
    "gpt-oss-20b": dict(G=4, EP=8, seq=4096, fc1=(5760, 2880), fc2=(2880, 2880), avg_m=(512, 1024, 2048)),
    "qwen3-30b-a3b": dict(G=16, EP=8, seq=8192, fc1=(4096, 2048), fc2=(2048, 2048), avg_m=(512, 1024, 2048)),
    "qwen3-235b-a22b": dict(G=16, EP=8, seq=8192, fc1=(8192, 4096), fc2=(4096, 4096), avg_m=(512, 1024, 2048)),
    "deepseek-v3": dict(G=32, EP=8, seq=4096, fc1=(4096, 7168), fc2=(7168, 2048), avg_m=(128, 256, 512)),
}
BATCH = (1, 2, 4)
COLS = ["模型", "proj", "G", "EP", "batch", "seq", "avg_m", "M(总)", "N", "K",
        "dtype", "ms", "TF/s", "MFU", "config", "sclk"]


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    sys.modules[name] = mod
    spec.loader.exec_module(mod)
    return mod


def cfgstr(c):
    return f"BM{c[0]}/BN{c[1]}/BK{c[2]}/mw{c[3]}/nw{c[4]}/nb{c[5]}"


def emit(rows, title, path):
    print(f"\n### {title}\n")
    w = [max(len(c), max((len(str(r[c])) for r in rows), default=0)) for c in COLS]
    print("| " + " | ".join(c.ljust(w[i]) for i, c in enumerate(COLS)) + " |")
    print("|" + "|".join("-" * (x + 2) for x in w) + "|")
    for r in rows:
        print("| " + " | ".join(str(r[c]).ljust(w[i]) for i, c in enumerate(COLS)) + " |")
    with open(path, "w", newline="") as f:
        wr = csv.DictWriter(f, fieldnames=COLS + ["cv", "cv_flag"])
        wr.writeheader()
        wr.writerows(rows)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--kernel", default=str(_REPO / "kernel" / "grouped_gemm_bf16_kernel_mi455.py"))
    ap.add_argument("--repeats", type=int, default=5)
    ap.add_argument("--outdir", default=str(_REPO / "results" / "nn_pipeline"))
    ap.add_argument("--ops", nargs="*", default=["fwd", "dgrad", "wgrad", "cmp"])
    args = ap.parse_args()
    _c._SMI_GPU = int(os.environ.get("HIP_VISIBLE_DEVICES", "2"))
    os.makedirs(args.outdir, exist_ok=True)
    K = load(args.kernel, "gg_nn")
    try:
        gg_impl, _o, BackendType = _c.load_turbo()
    except Exception as e:  # noqa: BLE001
        print(f"!! Triton backend unavailable: {type(e).__name__}: {e}")
        gg_impl = None

    print(f"kernel : {args.kernel}")
    print(f"device : {torch.cuda.get_device_properties(0).gcnArchName}  "
          f"peak {PEAK_TFLOPS} TF/s bf16")
    sec = {k: [] for k in ("fwd", "dgrad", "wgrad")}
    cmp_rows, notes = [], []

    for model, cfg in MATRIX.items():
        G, EP, seq = cfg["G"], cfg["EP"], cfg["seq"]
        for proj in ("fc1", "fc2"):
            N_fwd, K_fwd = cfg[proj]
            for batch, avg_m in zip(BATCH, cfg["avg_m"]):
                M = G * avg_m
                dev = "cuda"
                torch.manual_seed(0)
                lens = torch.full((G,), avg_m, dtype=torch.int64, device=dev)
                offs = torch.cat([torch.zeros(1, dtype=torch.int64, device=dev), lens.cumsum(0)])
                x = torch.randn(M, K_fwd, dtype=torch.bfloat16, device=dev)
                w = torch.randn(G, N_fwd, K_fwd, dtype=torch.bfloat16, device=dev)
                dout = torch.randn(M, N_fwd, dtype=torch.bfloat16, device=dev)
                flops = 2.0 * M * N_fwd * K_fwd
                meta = dict(模型=model, proj=proj, G=G, EP=EP, batch=batch, seq=seq,
                            avg_m=avg_m, **{"M(总)": M}, N=N_fwd, K=K_fwd, dtype="bf16")

                def row(op, ms, cv, conf, sclk):
                    tf = flops / (ms * 1e-3) / 1e12
                    r = dict(meta, ms=round(ms, 4), **{"TF/s": round(tf, 1)},
                             MFU=f"{tf / PEAK_TFLOPS * 100:.1f}%", config=conf,
                             sclk=int(sclk) if sclk == sclk else "n/a",
                             cv=round(cv * 100, 2), cv_flag="HIGH" if cv > CV_FLAG else "")
                    sec[op].append(r)

                jobs = {}
                if "fwd" in args.ops:
                    c_f = K._pick_config(N_fwd, K_fwd, avg_m, G)
                    o_f = torch.empty(M, N_fwd, dtype=torch.bfloat16, device=dev)
                    mt_f = K.build_m_tile_map(offs, c_f[0])
                    jobs["fwd"] = (
                        lambda: K.grouped_gemm_bf16_nt_flydsl_kernel(x, w, offs, out=o_f, m_tiles=mt_f),
                        cfgstr(c_f),
                    )
                if "dgrad" in args.ops or "cmp" in args.ops:
                    c_d = K._pick_config_nn(K_fwd, N_fwd, avg_m, G)  # (N_out, K_red)
                    o_d = torch.empty(M, K_fwd, dtype=torch.bfloat16, device=dev)
                    mt_d = K.build_m_tile_map(offs, c_d[0])
                    jobs["dgrad"] = (
                        lambda: K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, out=o_d, m_tiles=mt_d),
                        cfgstr(c_d),
                    )
                if "wgrad" in args.ops:
                    c_w = K._pick_variable_k_config(N_fwd, K_fwd, avg_m)
                    o_w = torch.empty(G, N_fwd, K_fwd, dtype=torch.bfloat16, device=dev)
                    et = K.build_expert_table(offs)
                    jobs["wgrad"] = (
                        lambda: K.grouped_gemm_bf16_variable_k_flydsl_kernel(
                            dout, x, offs, out=o_w, expert_table=et
                        ),
                        cfgstr(c_w),
                    )

                iv = Interleaved(warmup=6, repeats=args.repeats)
                for k, (fn, _c2) in jobs.items():
                    iv.add(k, fn)
                try:
                    res, clocks = iv.run()
                except Exception as e:  # noqa: BLE001
                    notes.append(f"{model}/{proj}/m{avg_m}: {type(e).__name__}: {str(e)[:200]}")
                    print(f"  !! {model} {proj} m{avg_m} FAILED: {type(e).__name__}: {str(e)[:160]}")
                    continue
                sclk = statistics.median([c for c in clocks if c == c]) if clocks else float("nan")
                for k in ("fwd", "dgrad", "wgrad"):
                    if k in res and k in args.ops:
                        row(k, res[k]["ms"], res[k]["cv"], jobs[k][1], sclk)

                # ---- four-calibre dgrad comparison, same session ----------------
                if "cmp" in args.ops:
                    c_h = K._pick_config(K_fwd, N_fwd, avg_m, G)
                    b_nt = K.make_nn_weight_nt(w)
                    scratch = torch.empty_like(b_nt)
                    mt_h = K.build_m_tile_map(offs, c_h[0])
                    iv2 = Interleaved(warmup=6, repeats=args.repeats)
                    iv2.add("native", jobs["dgrad"][0])
                    iv2.add("hoist", lambda: K.grouped_gemm_bf16_nn_flydsl_kernel(
                        dout, w, offs, b_nt=b_nt, out=o_d, m_tiles=mt_h))

                    def _fastpc():
                        fast_nn_weight_nt(w, out=scratch)
                        K.grouped_gemm_bf16_nn_flydsl_kernel(
                            dout, w, offs, b_nt=scratch, out=o_d, m_tiles=mt_h)

                    iv2.add("fast_percall", _fastpc)
                    if gg_impl is not None:
                        tk = dict(group_lens=lens, group_offs=offs, num_cu=None,
                                  default_backend=BackendType.TRITON.value, schedule="static")
                        iv2.add("triton", lambda: gg_impl(dout, w, trans_a=False, trans_b=False, **tk))
                    r2, ck2 = iv2.run()
                    cmp_rows.append(dict(
                        model=model, proj=proj, batch=batch, avg_m=avg_m, M=M, N=N_fwd, K=K_fwd,
                        sclk=statistics.median([c for c in ck2 if c == c]) if ck2 else float("nan"),
                        **{k: round(v["ms"], 5) for k, v in r2.items()},
                        **{f"cv_{k}": round(v["cv"] * 100, 2) for k, v in r2.items()},
                    ))
                    del b_nt, scratch, mt_h
                print(f"  done {model:<16s} {proj} b{batch} m{avg_m}", flush=True)
                del x, w, dout, offs, lens, jobs
                torch.cuda.empty_cache()

    for op in ("fwd", "dgrad", "wgrad"):
        if sec[op]:
            title = {"fwd": "前向 fwd", "dgrad": "反向 dgrad (native NN)", "wgrad": "反向 wgrad"}[op]
            emit(sec[op], title, f"{args.outdir}/matrix_{op}.csv")
            tfs = [r["TF/s"] for r in sec[op]]
            print(f"\n{op}: mean {statistics.mean(tfs):.1f} TF/s  peak {max(tfs):.1f} TF/s  "
                  f"(MFU mean {statistics.mean(tfs) / PEAK_TFLOPS * 100:.1f}% peak "
                  f"{max(tfs) / PEAK_TFLOPS * 100:.1f}%)   rows with cv>{CV_FLAG * 100:.0f}%: "
                  f"{sum(1 for r in sec[op] if r['cv_flag'])}")

    if cmp_rows:
        with open(f"{args.outdir}/dgrad_calibres.csv", "w", newline="") as f:
            wr = csv.DictWriter(f, fieldnames=list(cmp_rows[0]))
            wr.writeheader()
            wr.writerows(cmp_rows)
        print("\n### dgrad: four calibres, same session, interleaved (ms; ratio = native is N x faster)\n")
        h = (f"| {'model':<16s} | {'proj':<4s} | {'avg_m':>5s} | {'native':>8s} | {'hoist':>8s} | "
             f"{'fast_pc':>8s} | {'triton':>8s} | {'nat/hoist':>9s} | {'nat/fastpc':>10s} | {'nat/triton':>10s} |")
        print(h)
        print("|" + "|".join("-" * (len(s) + 2) for s in h.split("|")[1:-1]) + "|")
        for r in cmp_rows:
            g = lambda k: r.get(k, float("nan"))  # noqa: E731
            print(f"| {r['model']:<16s} | {r['proj']:<4s} | {r['avg_m']:>5d} | {g('native'):>8.4f} | "
                  f"{g('hoist'):>8.4f} | {g('fast_percall'):>8.4f} | {g('triton'):>8.4f} | "
                  f"{g('hoist') / g('native'):>9.3f} | {g('fast_percall') / g('native'):>10.3f} | "
                  f"{g('triton') / g('native'):>10.3f} |")
        for k, lbl in (("hoist", "hoist"), ("fast_percall", "fast per-call"), ("triton", "Triton")):
            rr = [r[k] / r["native"] for r in cmp_rows if k in r]
            if rr:
                print(f"  native vs {lbl:<14s}: geomean {statistics.geometric_mean(rr):.4f}  "
                      f"min {min(rr):.3f}  max {max(rr):.3f}  "
                      f"({sum(1 for v in rr if v >= 1.0)}/{len(rr)} where native is faster)")
        json.dump(cmp_rows, open(f"{args.outdir}/dgrad_calibres.json", "w"), indent=1)

    if notes:
        print("\n!! failures:")
        for n in notes:
            print("   ", n)
    print(f"\nCSVs in {args.outdir}")


if __name__ == "__main__":
    main()
