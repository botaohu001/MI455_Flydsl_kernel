#!/usr/bin/env python3
###############################################################################
# Analysis of the gfx1250 FlyDSL bf16 grouped-GEMM matrix: reference comparison,
# baseline comparison, and the three falsifiable predictions from KERNEL_REVIEW.md.
###############################################################################

from __future__ import annotations

import os
import sys

import pandas as pd

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
OUT = os.path.join(RES, "flydsl_gfx1250")

MODEL_ORDER = ["gpt-oss-20b", "qwen3-30b-a3b", "qwen3-235b-a22b", "deepseek-v3"]
PEAK = 5033.2

# The three worked reference points quoted from the other machine's run of this
# same kernel, plus the band it reported. Only fwd points were given.
REFERENCE_POINTS = [
    # model, layer, batch, direction, ms, tflops, mfu
    ("gpt-oss-20b", "fc1", 1, "fwd", 0.0818, 830.9, 16.49),
    ("qwen3-235b-a22b", "fc1", 4, "fwd", 1.231, 1786.3, 35.44),
    ("deepseek-v3", "fc1", 1, "fwd", 0.3157, 761.7, 15.11),
]
REFERENCE_BAND_TF = (500.0, 1800.0)
REFERENCE_BAND_MFU = (10.0, 35.0)


def load(path, required=True):
    if not os.path.exists(path):
        if required:
            raise SystemExit(f"missing {path}")
        return None
    d = pd.read_csv(path)
    d["Model"] = pd.Categorical(d["Model"], MODEL_ORDER, ordered=True)
    return d


def hdr(t):
    print()
    print("=" * 100)
    print(t)
    print("=" * 100)


def pick(d, **kw):
    m = pd.Series(True, index=d.index)
    for k, v in kw.items():
        m &= d[k] == v
    r = d[m]
    return r.iloc[0] if len(r) == 1 else None


###############################################################################

fly = load(os.path.join(OUT, "matrix_FLYDSL.csv"))
tri = load(os.path.join(OUT, "matrix_TRITON_samedriver.csv"), required=False)
hbl = load(os.path.join(OUT, "matrix_HIPBLASLT_samedriver.csv"), required=False)
tri_prep = load(os.path.join(RES, "baseline", "matrix_TRITON.csv"), required=False)
hbl_prep = load(os.path.join(RES, "baseline", "matrix_HIPBLASLT.csv"), required=False)

hdr("0. RUN INTEGRITY")
print(f"FLYDSL rows        : {len(fly)}   checks: {fly.Check.value_counts().to_dict()}")
print(f"errors             : {(fly.Check == 'ERROR').sum()}")
print(f"cv                 : max {fly['cv (%)'].max():.3f}%  mean {fly['cv (%)'].mean():.3f}%  "
      f"points above 3%: {(fly['cv (%)'] > 3).sum()}")
print(f"sclk               : {fly['sclk (MHz)'].min():.0f} - {fly['sclk (MHz)'].max():.0f} MHz "
      f"(mean {fly['sclk (MHz)'].mean():.0f}), clocks not pinned")
if tri is not None:
    print(f"TRITON same-driver : {len(tri)} rows, checks {tri.Check.value_counts().to_dict()}, "
          f"max cv {tri['cv (%)'].max():.3f}%")
if hbl is not None:
    print(f"HIPBLASLT same-drv : {len(hbl)} rows, checks {hbl.Check.value_counts().to_dict()}, "
          f"max cv {hbl['cv (%)'].max():.3f}%")

###############################################################################
hdr("1. FULL MATRIX -- TFLOP/s (MFU %) by direction, both dgrad calibres")

for layer in ("fc1", "fc2"):
    print(f"\n  --- {layer} ---")
    rows = []
    for model in MODEL_ORDER:
        for batch in (1, 2, 4):
            sub = fly[(fly.Model == model) & (fly.Layer == layer) & (fly.Batch == batch)]
            if sub.empty:
                continue
            r = dict(model=model, batch=batch, avg_m=int(sub.AvgM.iloc[0]),
                     M=int(sub.TotalM.iloc[0]), N=int(sub.N.iloc[0]), K=int(sub.K.iloc[0]))
            for d in ("fwd", "dgrad", "dgrad_tr", "wgrad"):
                x = sub[sub.Direction == d]
                if x.empty:
                    r[d] = ""
                    continue
                r[d] = f"{x.TFLOPS.iloc[0]:7.1f} ({x['MFU (%)'].iloc[0]:5.2f}%)"
            rows.append(r)
    print(pd.DataFrame(rows).to_string(index=False))

hdr("1b. FULL MATRIX -- ms, cv, effective tile config, sclk")
show = ["Model", "Layer", "Batch", "AvgM", "TotalM", "N", "K", "Direction",
        "Time (ms)", "TFLOPS", "MFU (%)", "cv (%)", "Config", "sclk (MHz)", "Check"]
print(fly.sort_values(["Model", "Layer", "Batch", "Direction"])[show].to_string(index=False))

hdr("1c. SUMMARY BY DIRECTION")
agg = fly.groupby("Direction")[["TFLOPS", "MFU (%)"]].agg(["count", "mean", "min", "max"]).round(2)
print(agg.to_string())
print("\nbest / worst point per direction:")
for d in ("fwd", "dgrad", "dgrad_tr", "wgrad"):
    s = fly[fly.Direction == d]
    if s.empty:
        continue
    b, w = s.loc[s.TFLOPS.idxmax()], s.loc[s.TFLOPS.idxmin()]
    print(f"  {d:9s} best  {b.TFLOPS:7.1f} TF/s  {b.Model} {b.Layer} b={b.Batch} avg_m={b.AvgM} ({b.Config})")
    print(f"  {d:9s} worst {w.TFLOPS:7.1f} TF/s  {w.Model} {w.Layer} b={w.Batch} avg_m={w.AvgM} ({w.Config})")

###############################################################################
hdr("2. THE TWO dgrad CALIBRES")

j = fly[fly.Direction == "dgrad"].merge(
    fly[fly.Direction == "dgrad_tr"], on=["Model", "Layer", "Batch"], suffixes=("_h", "_t")
)
j["ratio"] = j["Time (ms)_t"] / j["Time (ms)_h"]
j["transpose_ms"] = j["Time (ms)_t"] - j["Time (ms)_h"]
j["weight_GB"] = 2.0 * j.G_h * j.N_h * j.K_h / 1e9
j["transpose_TBps"] = 2 * j.weight_GB / (j.transpose_ms * 1e-3) / 1e3
print(j[["Model", "Layer", "Batch", "AvgM_h", "N_h", "K_h", "weight_GB",
         "Time (ms)_h", "Time (ms)_t", "transpose_ms", "ratio", "TFLOPS_h", "TFLOPS_t",
         "transpose_TBps"]]
      .rename(columns={"AvgM_h": "AvgM", "N_h": "N", "K_h": "K", "Time (ms)_h": "hoisted_ms",
                       "Time (ms)_t": "percall_ms", "TFLOPS_h": "hoisted_TF",
                       "TFLOPS_t": "percall_TF"})
      .round(4).to_string(index=False))
print(f"\nper-call / hoisted time ratio: min {j.ratio.min():.2f}x  median {j.ratio.median():.2f}x  "
      f"max {j.ratio.max():.2f}x")
print(f"implied transpose bandwidth (r+w): {j.transpose_TBps.min():.2f} - {j.transpose_TBps.max():.2f} TB/s "
      f"(notes quote ~1.07 TB/s for the copy)")
print(f"\nhoisted dgrad TF/s range : {fly[fly.Direction=='dgrad'].TFLOPS.min():.0f} - "
      f"{fly[fly.Direction=='dgrad'].TFLOPS.max():.0f}")
print(f"per-call dgrad TF/s range: {fly[fly.Direction=='dgrad_tr'].TFLOPS.min():.0f} - "
      f"{fly[fly.Direction=='dgrad_tr'].TFLOPS.max():.0f}")
print(f"reference band quoted    : {REFERENCE_BAND_TF[0]:.0f} - {REFERENCE_BAND_TF[1]:.0f}")

###############################################################################
hdr("3. VERIFICATION POINT 1 -- every wgrad row must be mw4, not mw2")

wg = fly[fly.Direction == "wgrad"]
print(wg.Config.value_counts().to_string())
bad = wg[~wg.Config.str.contains("mw4")]
print(f"\nwgrad rows: {len(wg)};  rows with mw4: {len(wg) - len(bad)};  rows without: {len(bad)}")
print("VERDICT: " + ("CONFIRMED -- all wgrad rows are mw4" if bad.empty
                     else f"FALSIFIED -- {len(bad)} rows are not mw4"))
if not bad.empty:
    print(bad[["Model", "Layer", "Batch", "Config"]].to_string(index=False))

###############################################################################
hdr("4. VERIFICATION POINT 2 -- the fitted narrow tile must fire on exactly 4 of 48, all gpt-oss G=4")

# The 48 NT/NN delivery points are 24 rows x {fwd, dgrad}. dgrad_tr shares dgrad's
# shape and therefore its config, so counting it would double-count.
nt = fly[fly.Direction.isin(["fwd", "dgrad"])].copy()
print(f"NT/NN delivery points: {len(nt)}  (expected 48)")


def branch(row):
    """Which branch of _pick_config fired, reconstructed from the shape."""
    avg_m, K, N, G = int(row.AvgM), int(row.K), int(row.N), int(row.G)
    if row.Direction == "dgrad":   # the NN entry swaps the kernel's N and K
        N, K = K, N
    if avg_m <= 64:
        return "tiny (avg_m<=64, unmeasured)"
    if avg_m <= 128:
        return "narrow DERIVED (avg_m<=128)"
    if G and G * ((avg_m + 255) // 256) <= 8:
        return "narrow FITTED (n_groups rule)"
    if K % 128 == 0:
        return "wide 256x256x128"
    if avg_m >= 1536 and N % 192 == 0:
        return "192-wide FITTED (avg_m>=1536, N%192==0)"
    return "wide 256x256x64"


nt["branch"] = nt.apply(branch, axis=1)
print()
print(nt.groupby(["branch", "Config"]).size().to_string())

fitted = nt[nt.branch == "narrow FITTED (n_groups rule)"]
print(f"\nfitted narrow-tile hits: {len(fitted)}  (docstring claims exactly 4)")
print(fitted[["Model", "Layer", "Batch", "AvgM", "G", "Direction", "Config", "TFLOPS"]].to_string(index=False))
all_gptoss = bool((fitted.Model == "gpt-oss-20b").all()) and bool((fitted.G == 4).all())
print("VERDICT: " + ("CONFIRMED -- exactly 4 hits, all gpt-oss at G=4"
                     if len(fitted) == 4 and all_gptoss
                     else f"MISMATCH -- {len(fitted)} hits, all gpt-oss G=4: {all_gptoss}"))

# Cross-check the other config strings KERNEL_REVIEW predicted.
print("\nKERNEL_REVIEW section D.6 also predicted these config strings would appear:")
for want, why in (
    ("BM256/BN256/BK64/mw2/nw2/nb3", "gpt-oss @1024, K=2880 not div by 128"),
    ("BM128/BN192/BK64/mw2/nw2/nb3", "gpt-oss @2048, the 192-wide fitted rule"),
    ("BM128/BN128/BK128/mw2/nw2/nb2", "deepseek @128 and gpt-oss fc1 dgrad @512"),
    ("BM128/BN128/BK64/mw2/nw2/nb3", "the narrow tile where K%128 != 0"),
    ("BM256/BN256/BK128/mw2/nw2/nb2", "the main-line wide tile"),
):
    n = int((nt.Config == want).sum())
    print(f"  {'FOUND' if n else 'ABSENT':7s} {n:2d}x  {want:32s} {why}")

###############################################################################
hdr("5. VERIFICATION POINT 3 -- no shape may be gated out (KERNEL_REVIEW section D.5)")

err = fly[fly.Check == "ERROR"]
print(f"errors / gated points: {len(err)} of {len(fly)}")
if len(err):
    print(err[["Model", "Layer", "Direction", "Batch", "Error"]].to_string(index=False))
print("VERDICT: " + ("CONFIRMED -- 96/96 points ran, none gated"
                     if err.empty else f"FALSIFIED -- {len(err)} gated"))

###############################################################################
hdr("6. VS THE REFERENCE MACHINE'S NUMBERS")

print(f"{'point':40s} {'ref ms':>9s} {'our ms':>9s} {'ref TF':>8s} {'our TF':>8s} {'delta':>8s}  config")
outside = []
for model, layer, batch, direction, ms, tf, mfu in REFERENCE_POINTS:
    r = pick(fly, Model=model, Layer=layer, Batch=batch, Direction=direction)
    if r is None:
        print(f"{model} {layer} b{batch} {direction}: not in our matrix")
        continue
    delta = 100.0 * (r.TFLOPS - tf) / tf
    flag = "  <-- >15%" if abs(delta) > 15 else ""
    if abs(delta) > 15:
        outside.append((model, layer, batch, direction, tf, r.TFLOPS, delta))
    print(f"{model+' '+layer+' b'+str(batch)+' '+direction:40s} {ms:9.4f} {r['Time (ms)']:9.4f} "
          f"{tf:8.1f} {r.TFLOPS:8.1f} {delta:+7.1f}%  {r.Config}{flag}")

print("\nband check (reference quoted 500-1800 TF/s, MFU 10-35%):")
for d in ("fwd", "dgrad", "dgrad_tr", "wgrad"):
    s = fly[fly.Direction == d]
    if s.empty:
        continue
    lo, hi = s.TFLOPS.min(), s.TFLOPS.max()
    inb = ((s.TFLOPS >= REFERENCE_BAND_TF[0]) & (s.TFLOPS <= REFERENCE_BAND_TF[1])).sum()
    print(f"  {d:9s} {lo:7.1f} - {hi:7.1f} TF/s   MFU {s['MFU (%)'].min():5.2f} - "
          f"{s['MFU (%)'].max():5.2f}%   {inb}/{len(s)} inside the TF/s band")

###############################################################################
hdr("7. VS THE LOCAL BASELINES")


def compare(other, label, direction_map=None):
    if other is None:
        print(f"\n{label}: not available")
        return
    direction_map = direction_map or {}
    rows = []
    for _, r in fly.iterrows():
        d = direction_map.get(r.Direction, r.Direction)
        o = pick(other, Model=r.Model, Layer=r.Layer, Batch=r.Batch, Direction=d)
        if o is None or o.Check == "ERROR":
            continue
        rows.append(dict(Model=r.Model, Layer=r.Layer, Batch=r.Batch, AvgM=r.AvgM,
                         Direction=r.Direction, fly_TF=r.TFLOPS, other_TF=o.TFLOPS,
                         speedup=r.TFLOPS / o.TFLOPS if o.TFLOPS else float("nan")))
    c = pd.DataFrame(rows)
    if c.empty:
        print(f"\n{label}: no overlapping points")
        return
    print(f"\n{label} -- FLYDSL speedup (>1 = FlyDSL faster), {len(c)} paired points")
    print(c.groupby("Direction")["speedup"].agg(["count", "mean", "min", "max"]).round(3).to_string())
    print("\nper-point:")
    print(c.round(3).to_string(index=False))
    return c


cmp_tri = compare(tri, "vs TRITON (same driver, same session)",
                  direction_map={"dgrad_tr": "dgrad"})
cmp_hbl = compare(hbl, "vs HIPBLASLT (same driver, same session)",
                  direction_map={"dgrad_tr": "dgrad"})
cmp_prep = compare(tri_prep, "vs TRITON (prep-phase baseline, mean-of-timeit statistics)",
                   direction_map={"dgrad_tr": "dgrad"})

hdr("8. DRIVER CROSS-CHECK -- does the new median-of-repeats statistic move TRITON?")
if tri is not None and tri_prep is not None:
    rows = []
    for _, r in tri.iterrows():
        o = pick(tri_prep, Model=r.Model, Layer=r.Layer, Batch=r.Batch, Direction=r.Direction)
        if o is None:
            continue
        rows.append(dict(Model=r.Model, Layer=r.Layer, Batch=r.Batch, Direction=r.Direction,
                         new_TF=r.TFLOPS, prep_TF=o.TFLOPS, ratio=r.TFLOPS / o.TFLOPS))
    c = pd.DataFrame(rows)
    print(f"{len(c)} paired TRITON points, new/prep TFLOPS ratio:")
    print(c.groupby("Direction")["ratio"].agg(["count", "mean", "min", "max"]).round(4).to_string())
    print(f"overall: mean {c.ratio.mean():.4f}, min {c.ratio.min():.4f}, max {c.ratio.max():.4f}")

###############################################################################
if len(sys.argv) > 1 and sys.argv[1] == "--write":
    for name, obj in (("dgrad_calibres.csv", j),
                      ("vs_triton_samedriver.csv", cmp_tri),
                      ("vs_hipblaslt_samedriver.csv", cmp_hbl),
                      ("vs_triton_prep.csv", cmp_prep)):
        if obj is not None:
            obj.to_csv(os.path.join(OUT, name), index=False)
            print(f"wrote {os.path.join(OUT, name)}")
