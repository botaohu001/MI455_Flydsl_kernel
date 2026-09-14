#!/usr/bin/env python3
"""Why flydsl's dgrad GEMM loses on exactly five cells, all at M = 8192.

The variable-K docstring says it outright: "these kernels launch one workgroup
per output tile with no persistent loop".  The NT kernel is built the same way.
So the device runs ceil(tiles / CUs) waves, and a shape whose tile count lands
just past a wave boundary pays a full wave for the remainder.  Triton's grouped
GEMM does not degrade the same way.

If that is the mechanism, wave-quantisation efficiency should track the
flydsl/Triton ratio, and no threshold on M, N, K or avg_m should.
"""
from __future__ import annotations

import math
import os
import re
import sys

import pandas as pd

HERE = os.path.dirname(os.path.abspath(__file__))
pd.set_option("display.width", 250)
CUS = 256


def main():
    f = pd.read_csv(os.path.join(HERE, "results/part1_fast_tr.csv"))
    rows = []
    for _, r in f.iterrows():
        m = re.match(r"BM(\d+)/BN(\d+)/BK(\d+)", str(r.tile_cfg))
        if not m:
            continue
        bm, bn = int(m.group(1)), int(m.group(2))
        # dgrad output is [M, K]; groups are contiguous runs of avg_m rows, and a
        # run that does not start on a tile boundary costs a partial tile, which is
        # why the count is per group and not ceil(M/bm).
        tiles_m = r.G * math.ceil(r.avg_m / bm)
        tiles_n = math.ceil(r.K / bn)
        tiles = tiles_m * tiles_n
        waves = tiles / CUS
        eff = tiles / (math.ceil(waves) * CUS)
        rows.append(dict(Model=r.Model, Layer=r.Layer, avg_m=r.avg_m, M=r.M, K=r.K,
                         tile=f"{bm}x{bn}", tiles=tiles, waves=round(waves, 3),
                         wave_eff=round(eff, 3),
                         tf_gemm=r.tf_gemm, tf_triton=r.tf_triton,
                         speedup=round(r.speedup_gemm_vs_triton, 4)))
    d = pd.DataFrame(rows).sort_values("wave_eff")
    print(d.to_string(index=False))
    print()
    print(f"Spearman(wave_eff, speedup) = {d['wave_eff'].corr(d['speedup'], method='spearman'):.3f}")
    print(f"Pearson (wave_eff, speedup) = {d['wave_eff'].corr(d['speedup']):.3f}")
    print()
    lose = d[d.speedup < 1.0]
    winw = d[d.speedup >= 1.0]
    print(f"losing cells ({len(lose)}): wave_eff {lose.wave_eff.min():.3f}-{lose.wave_eff.max():.3f}, "
          f"waves {lose.waves.min():.2f}-{lose.waves.max():.2f}")
    print(f"winning cells ({len(winw)}): wave_eff {winw.wave_eff.min():.3f}-{winw.wave_eff.max():.3f}, "
          f"waves {winw.waves.min():.2f}-{winw.waves.max():.2f}")
    sep = lose.wave_eff.max() < winw.wave_eff.min()
    print(f"separable by a wave_eff threshold alone: {sep}")
    for thr in (0.55, 0.6, 0.65, 0.7):
        pred = d.wave_eff >= thr
        acc = (pred == (d.speedup >= 1.0)).mean()
        print(f"  rule 'use flydsl iff wave_eff >= {thr}': {acc*100:.1f}% of 24 cells correct "
              f"({int((pred & (d.speedup < 1)).sum())} false positives, "
              f"{int((~pred & (d.speedup >= 1)).sum())} false negatives)")


if __name__ == "__main__":
    main()
