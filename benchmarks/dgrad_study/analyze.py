#!/usr/bin/env python3
"""Turn the two part-1 runs into the tables the decision needs."""
from __future__ import annotations

import os
import sys

import pandas as pd

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common import N_SWEEP  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
pd.set_option("display.width", 260)
pd.set_option("display.max_columns", 100)


def load(name):
    return pd.read_csv(os.path.join(HERE, "results", name))


def main():
    t = load("part1_torch_tr.csv")
    f = load("part1_fast_tr.csv")

    key = ["Model", "Layer", "avg_m"]
    m = t.merge(f, on=key, suffixes=("_t", "_f"))

    print("=" * 150)
    print("TABLE 1  per-shape terms, upstream make_nn_weight_nt  (all four terms measured, none subtracted)")
    print("=" * 150)
    cols = ["Model", "Layer", "G", "avg_m", "M", "N", "K", "w_MiB", "t_transpose_ms",
            "t_gemm_ms", "t_triton_ms", "t_nocache_ms", "tf_gemm", "tf_triton",
            "speedup_gemm_vs_triton", "N_star"]
    print(t[cols].to_string(index=False))

    print()
    print("=" * 150)
    print("TABLE 2  same cells, transpose replaced by the tiled Triton kernel (bit-exact)")
    print("=" * 150)
    print(f[cols].to_string(index=False))

    print()
    print("=" * 150)
    print("TABLE 3  what the transpose choice does to the break-even point")
    print("=" * 150)
    r = pd.DataFrame({
        "Model": m["Model"], "Layer": m["Layer"], "avg_m": m["avg_m"],
        "w_MiB": m["w_MiB_t"],
        "w_bytes/FLOP": m["w_bytes_per_flop_t"].map(lambda x: f"{x:.2e}"),
        "t_tr_torch": m["t_transpose_ms_t"].round(3),
        "t_tr_fast": m["t_transpose_ms_f"].round(3),
        "tr_speedup": (m["t_transpose_ms_t"] / m["t_transpose_ms_f"]).round(1),
        "t_gemm": m["t_gemm_ms_f"].round(3),
        "t_triton": m["t_triton_ms_f"].round(3),
        "gemm/tri": m["speedup_gemm_vs_triton_f"].round(3),
        "N*_torch": m["N_star_t"].round(2),
        "N*_fast": m["N_star_f"].round(2),
    })
    print(r.to_string(index=False))

    print()
    print("=" * 150)
    print("TABLE 4  linear model  t_eff(N) = t_gemm + t_transpose/N   vs measured, % deviation")
    print("=" * 150)
    for tag, d in (("torch transpose", t), ("fast transpose", f)):
        dev = d[["Model", "Layer", "avg_m"] + [f"dev_N{n}_pct" for n in N_SWEEP]].copy()
        dev.columns = ["Model", "Layer", "avg_m"] + [f"N={n}" for n in N_SWEEP]
        print(f"\n-- {tag} --")
        print(dev.to_string(index=False))
        allv = d[[f"dev_N{n}_pct" for n in N_SWEEP]].values.ravel()
        print(f"   deviation: min {allv.min():+.2f}%  max {allv.max():+.2f}%  "
              f"mean|dev| {abs(allv).mean():.2f}%  "
              f"(worst cell: {d.loc[abs(d[[f'dev_N{n}_pct' for n in N_SWEEP]]).max(axis=1).idxmax(), ['Model','Layer','avg_m']].tolist()})")

    print()
    print("=" * 150)
    print("TABLE 5  effective dgrad speedup over Triton at each N   (>1 means flydsl wins)")
    print("=" * 150)
    for tag, d in (("torch transpose", t), ("fast transpose", f)):
        sp = d[["Model", "Layer", "avg_m"]].copy()
        for n in N_SWEEP:
            sp[f"N={n}"] = (d["t_triton_ms"] / d[f"eff_N{n}_ms"]).round(3)
        sp["N=inf"] = (d["t_triton_ms"] / d["t_gemm_ms"]).round(3)
        print(f"\n-- {tag} --")
        print(sp.to_string(index=False))
        win = {f"N={n}": int(((d["t_triton_ms"] / d[f"eff_N{n}_ms"]) > 1.0).sum()) for n in N_SWEEP}
        print(f"   cells where flydsl wins (of {len(d)}): {win}")

    print()
    print("=" * 150)
    print("TABLE 6  is N* monotone in weight-bytes/FLOP?  (the ratio is identically 1/avg_m)")
    print("=" * 150)
    q = t[["Model", "Layer", "avg_m", "w_bytes_per_flop", "N_star"]].copy()
    q["ratio*avg_m"] = (q["w_bytes_per_flop"] * q["avg_m"]).round(9)
    q["N*_fast"] = f["N_star"].values
    q = q.sort_values("w_bytes_per_flop", ascending=False)
    print(q.to_string(index=False))
    fin = q[q["N_star"] != float("inf")]
    print(f"\n   ratio == 1/avg_m for every cell: {set(q['ratio*avg_m']) == {1.0}}")
    print(f"   Spearman(ratio, N*_torch) over finite cells: "
          f"{fin['w_bytes_per_flop'].corr(fin['N_star'], method='spearman'):.3f}  (n={len(fin)})")
    print(f"   Spearman(avg_m,  N*_torch) over finite cells: "
          f"{fin['avg_m'].corr(fin['N_star'], method='spearman'):.3f}")
    print(f"   Spearman(gemm/triton speedup, N*_torch):      "
          f"{t.loc[fin.index, 'speedup_gemm_vs_triton'].corr(fin['N_star'], method='spearman'):.3f}")

    print()
    print("=" * 150)
    print("TABLE 7  tile geometry the kernel picked, and where flydsl loses to Triton outright")
    print("=" * 150)
    g = f[["Model", "Layer", "G", "avg_m", "M", "N", "K", "tile_cfg", "tf_gemm", "tf_triton",
           "speedup_gemm_vs_triton"]].copy()
    g["verdict"] = g["speedup_gemm_vs_triton"].map(
        lambda x: "flydsl loses" if x < 1.0 else ("tie" if x < 1.05 else "flydsl wins"))
    print(g.to_string(index=False))

    print()
    print("=" * 150)
    print("clocks / stability")
    print("=" * 150)
    for tag, d in (("torch", t), ("fast", f)):
        cvs = d[["cv_transpose", "cv_gemm", "cv_triton", "cv_nocache"]].values.ravel()
        print(f"  {tag}: sclk {d['sclk_min'].min():.0f}-{d['sclk_max'].max():.0f} MHz "
              f"(cell means {d['sclk_mean'].min():.0f}-{d['sclk_mean'].max():.0f});  "
              f"cv max {cvs.max()*100:.2f}%, mean {cvs.mean()*100:.2f}%")
    print(f"  correctness: flydsl==triton bitwise in {int(t['flydsl_eq_triton'].sum())}/{len(t)} "
          f"and {int(f['flydsl_eq_triton'].sum())}/{len(f)} cells; "
          f"rel_fro vs fp32 ref max {max(t['rel_flydsl'].max(), f['rel_flydsl'].max()):.3e}")


if __name__ == "__main__":
    main()
