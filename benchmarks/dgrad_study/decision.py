#!/usr/bin/env python3
"""The dispatch rule, and what it is worth, over all 42 measured cells."""
from __future__ import annotations

import os
import sys

import numpy as np
import pandas as pd

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
pd.set_option("display.width", 260)


def geo(x):
    x = np.asarray([v for v in x if np.isfinite(v) and v > 0])
    return float(np.exp(np.log(x).mean()))


def main():
    f = pd.read_csv(os.path.join(HERE, "results/part1_fast_tr.csv"))
    e = pd.read_csv(os.path.join(HERE, "results/part1_extra_avgm.csv"))
    t = pd.read_csv(os.path.join(HERE, "results/part1_torch_tr.csv"))
    d = pd.concat([f, e], ignore_index=True)

    d["x_nocache"] = (d.t_triton_ms / d.t_nocache_ms).round(3)
    d["x_N4"] = (d.t_triton_ms / d.eff_N4_ms).round(3)
    d["x_N8"] = (d.t_triton_ms / d.eff_N8_ms).round(3)
    d["x_ceiling"] = (d.t_triton_ms / d.t_gemm_ms).round(3)
    d["N*"] = d.N_star.round(2)

    cols = ["Model", "Layer", "G", "avg_m", "M", "t_transpose_ms", "t_gemm_ms", "t_triton_ms",
            "N*", "x_nocache", "x_N4", "x_N8", "x_ceiling"]
    print("=" * 160)
    print("ALL 42 CELLS, tiled-Triton transpose.  x_* = speedup over Triton dgrad (>1 = flydsl faster)")
    print("  x_nocache  transpose materialised on every call, no cache at all")
    print("  x_N4/x_N8  transpose cached across a 4 / 8 micro-batch accumulation window")
    print("  x_ceiling  transpose free (N -> inf); the most a perfect cache can ever buy")
    print("=" * 160)
    print(d.sort_values(["avg_m", "Model", "Layer"])[cols].to_string(index=False))

    print()
    print("=" * 160)
    print("THE RULE:  route dgrad to flydsl iff avg_m >= T, else Triton.  No cache, fast transpose.")
    print("=" * 160)
    print(f"{'T':>6} {'routed to flydsl':>17} {'wrong calls':>12} {'geomean overall':>16} "
          f"{'worst routed cell':>18}")
    for T in (128, 512, 1024, 1536, 2048, 3072):
        use = d.avg_m >= T
        eff = np.where(use, d.x_nocache, 1.0)      # 1.0 = Triton, the fallback
        wrong = int(((d.x_nocache > 1.0) != use).sum())
        worst = d.x_nocache[use].min() if use.any() else float("nan")
        print(f"{T:>6} {int(use.sum()):>10}/{len(d):<6} {wrong:>12} {geo(eff):>16.4f} {worst:>18.3f}")

    print()
    print("  same rule but with a cache over an 8-micro-batch window:")
    print(f"{'T':>6} {'routed to flydsl':>17} {'wrong calls':>12} {'geomean overall':>16} "
          f"{'worst routed cell':>18}")
    for T in (128, 512, 1024, 1536, 2048):
        use = d.avg_m >= T
        eff = np.where(use, d.x_N8, 1.0)
        wrong = int(((d.x_N8 > 1.0) != use).sum())
        worst = d.x_N8[use].min() if use.any() else float("nan")
        print(f"{T:>6} {int(use.sum()):>10}/{len(d):<6} {wrong:>12} {geo(eff):>16.4f} {worst:>18.3f}")

    print()
    print("=" * 160)
    print("WHERE THE CACHE IS AND IS NOT NEEDED")
    print("=" * 160)
    hi = d[d.avg_m >= 1536]
    lo = d[d.avg_m < 1536]
    print(f"  avg_m >= 1536 ({len(hi)} cells): N* ranges {hi['N*'].min():.2f} to {hi['N*'].max():.2f}.  "
          f"N* < 1 in {int((hi['N*'] < 1).sum())}/{len(hi)} -- the transpose pays for itself inside a")
    print("                   single call, so a cache has nothing left to buy.")
    print(f"                   x_nocache geomean {geo(hi.x_nocache):.3f}, x_N8 geomean {geo(hi.x_N8):.3f} "
          f"(cache adds {100*(geo(hi.x_N8)/geo(hi.x_nocache)-1):.1f}%)")
    print(f"  avg_m <  1536 ({len(lo)} cells): x_nocache geomean {geo(lo.x_nocache):.3f}, "
          f"x_N8 geomean {geo(lo.x_N8):.3f} (cache adds {100*(geo(lo.x_N8)/geo(lo.x_nocache)-1):.1f}%)")
    print(f"                   but the ceiling is only {geo(lo.x_ceiling):.3f}: "
          f"{int((lo.x_ceiling <= 1.0).sum())}/{len(lo)} of these cells lose to Triton even with a")
    print("                   free transpose, so no cache can rescue them.")

    print()
    print("=" * 160)
    print("COST OF THE CURRENT PRODUCTION PATH (turbo passes no b_nt -> torch transpose every call)")
    print("=" * 160)
    x = (t.t_triton_ms / t.t_nocache_ms)
    print(f"  geomean {geo(x):.3f}x Triton over 24 cells; range {x.min():.3f} to {x.max():.3f}")
    print(f"  i.e. between {1/x.max():.1f}x and {1/x.min():.1f}x SLOWER than simply calling Triton.")

    d.to_csv(os.path.join(HERE, "results/decision_table.csv"), index=False)
    print(f"\nwrote results/decision_table.csv ({len(d)} cells)")


if __name__ == "__main__":
    main()
