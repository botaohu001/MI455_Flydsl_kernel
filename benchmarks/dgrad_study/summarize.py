#!/usr/bin/env python3
"""The decision table: what each option is worth, per cell and in aggregate."""
from __future__ import annotations

import os
import sys

import numpy as np
import pandas as pd

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common import N_SWEEP  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
pd.set_option("display.width", 300)
pd.set_option("display.max_columns", 120)


def geo(x):
    x = np.asarray([v for v in x if np.isfinite(v) and v > 0])
    return float(np.exp(np.log(x).mean()))


def main():
    t = pd.read_csv(os.path.join(HERE, "results/part1_torch_tr.csv"))
    f = pd.read_csv(os.path.join(HERE, "results/part1_fast_tr.csv"))

    print("=" * 140)
    print("A.  the fixed cost the linear model does not contain")
    print("=" * 140)
    print("t_eff(N) = t_gemm + t_transpose/N assumes the transpose and the GEMM cost the")
    print("same back to back as they do measured alone.  They do not: the GEMM waits on")
    print("the transpose, so each window pays one extra dependent-launch boundary.")
    print()
    for tag, d in (("torch", t), ("fast", f)):
        ov = []
        for n in N_SWEEP:
            # absolute miss of the model, in ms per window (not per dgrad)
            ov.append(((d[f"eff_N{n}_ms"] - d[f"model_N{n}_ms"]) * n).values)
        ov = np.array(ov)
        print(f"  -- {tag} transpose --  model miss per *window*, us "
              f"(should be ~constant in N if it is a launch boundary)")
        rowfmt = "     " + "".join(f"N={n:<8d}" for n in N_SWEEP)
        print(rowfmt)
        print("     " + "".join(f"{v*1e3:<10.1f}" for v in np.median(ov, axis=1)) + "  <- median over 24 cells")
        print(f"     spread over cells: {np.percentile(ov, 10)*1e3:.1f} to "
              f"{np.percentile(ov, 90)*1e3:.1f} us\n")

    print("=" * 140)
    print("B.  per-cell verdict:  effective dgrad time vs Triton, for each option")
    print("=" * 140)
    rows = []
    for i in range(len(t)):
        tr, fa = t.iloc[i], f.iloc[i]
        r = dict(Model=tr.Model, Layer=tr.Layer, avg_m=tr.avg_m,
                 triton=round(tr.t_triton_ms, 4),
                 turbo_today=round(tr.t_nocache_ms, 4),
                 fastTr_nocache=round(fa.t_nocache_ms, 4),
                 fastTr_N4=round(fa.eff_N4_ms, 4),
                 fastTr_N8=round(fa.eff_N8_ms, 4),
                 torchTr_N8=round(tr.eff_N8_ms, 4),
                 perfect=round(fa.t_gemm_ms, 4))
        for k in ("turbo_today", "fastTr_nocache", "fastTr_N4", "fastTr_N8",
                  "torchTr_N8", "perfect"):
            r["x_" + k] = round(tr.t_triton_ms / r[k], 3)
        rows.append(r)
    d = pd.DataFrame(rows)
    show = ["Model", "Layer", "avg_m", "x_turbo_today", "x_torchTr_N8", "x_fastTr_nocache",
            "x_fastTr_N4", "x_fastTr_N8", "x_perfect"]
    print("(numbers are speedup over Triton; >1 = flydsl faster)")
    print(d[show].to_string(index=False))

    print("\n  geometric mean over all 24 cells, and cells where flydsl wins:")
    for c in show[3:]:
        v = d[c]
        print(f"    {c:20s} geomean {geo(v):.3f}   wins {int((v > 1.0).sum())}/24   "
              f"min {v.min():.3f}  max {v.max():.3f}")

    print()
    print("=" * 140)
    print("C.  what caching is worth once the transpose is fast")
    print("=" * 140)
    print("relative benefit of a cache = t_transpose / t_gemm, which is")
    print("  2*(W/F)*T_flydsl/BW_transpose  =  2*T_flydsl/(avg_m*BW_transpose)   -- proportional to 1/avg_m")
    q = f[["Model", "Layer", "avg_m"]].copy()
    q["t_tr/t_gemm"] = (f["t_transpose_ms"] / f["t_gemm_ms"]).round(3)
    q["max_saving_%"] = (100 * f["t_transpose_ms"] / (f["t_gemm_ms"] + f["t_transpose_ms"])).round(1)
    q["saving_at_N4_%"] = (100 * (f["eff_N1_ms"] - f["eff_N4_ms"]) / f["eff_N1_ms"]).round(1)
    q["saving_at_N8_%"] = (100 * (f["eff_N1_ms"] - f["eff_N8_ms"]) / f["eff_N1_ms"]).round(1)
    print(q.sort_values("avg_m").to_string(index=False))
    print()
    for a in sorted(q["avg_m"].unique()):
        s = q[q["avg_m"] == a]
        print(f"    avg_m={a:5d}: t_tr/t_gemm {s['t_tr/t_gemm'].min():.3f}-{s['t_tr/t_gemm'].max():.3f}, "
              f"saving at N=8 {s['saving_at_N8_%'].min():.1f}-{s['saving_at_N8_%'].max():.1f}%")

    print()
    print("=" * 140)
    print("D.  can a single shape rule predict where flydsl's GEMM beats Triton?")
    print("=" * 140)
    c = f[["Model", "Layer", "G", "avg_m", "M", "N", "K", "tf_gemm", "tf_triton",
           "speedup_gemm_vs_triton"]].copy()
    c["win"] = c["speedup_gemm_vs_triton"] > 1.0
    print(c.sort_values("M").to_string(index=False))
    print()
    for col in ("M", "avg_m", "N", "K"):
        w, l = c[c.win][col], c[~c.win][col]
        print(f"    {col:6s}: wins span {w.min()}-{w.max()}, losses span {l.min()}-{l.max()}  "
              f"-> {'separable' if w.min() > l.max() or l.min() > w.max() else 'OVERLAP, no threshold works'}")
    print(f"\n    Spearman(M, speedup)     = {c['M'].corr(c['speedup_gemm_vs_triton'], method='spearman'):.3f}")
    print(f"    Spearman(avg_m, speedup) = {c['avg_m'].corr(c['speedup_gemm_vs_triton'], method='spearman'):.3f}")
    print("    per-model trend of speedup vs avg_m (is it even monotone within a model?):")
    for mdl in c.Model.unique():
        for lay in ("fc1", "fc2"):
            s = c[(c.Model == mdl) & (c.Layer == lay)].sort_values("avg_m")
            vals = s["speedup_gemm_vs_triton"].tolist()
            mono = all(b >= a for a, b in zip(vals, vals[1:]))
            print(f"      {mdl:16s} {lay}  " + "  ".join(f"{v:.2f}" for v in vals) +
                  f"   {'monotone' if mono else 'NOT monotone'}")


if __name__ == "__main__":
    main()
