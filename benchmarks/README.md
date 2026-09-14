# `benchmarks/` — correctness harnesses and measurement drivers

Everything that produced a number in `docs/07-performance.md` or
`docs/05-optimization-log.md`. Paths resolve relative to the repository root, so
a clone works anywhere.

**Requires gfx1250 hardware.** See the repository `README.md` for the software
stack.

---

## Correctness

### `check_full.py` — the full 48-row gate

Loads **both** the shipped kernel and `kernel/reference/` into one process, so
"no regression" is a comparison between two implementations rather than each
being re-checked against a reference they could drift from together.

```bash
python benchmarks/check_full.py
```

48 rows = 24 shapes × {balanced, imbalanced groups}. Asserts:

- dgrad native vs hoisted calibre — **bitwise identical**, 48/48
- fwd and wgrad vs the pre-change kernel — **bitwise identical**, 48/48 each
- `rel_fro` against an **fp32** per-group reference judged host-side in float64
  (never device fp64 — it was wrong 11 times in 12 on this part)
- zero NaN/Inf, and that all 48 rows actually took the native path

It burns 3 calls and checks the 4th, per the first-call-corruption convention in
`docs/06-pitfalls.md`. Expected output: `results/nn_pipeline/check_full.out`.

### `check_flydsl_gg_correctness.py` — the wider correctness sweep

96 numerical points, `masked_k` with padded pools and poisoned dead rows, and a
device-vs-CPU reference cross-check. `--masked-k` covers the production path
that had **never been executed** before this work: padded pools where
`valid % tile_k != 0`, dead rows poisoned with both finite `1e4` and `NaN`.

---

## Performance

### `bench_matrix.py` — the three-section delivery matrix

Produces the tables in `docs/07-performance.md` §7.1–7.4: fwd, dgrad and wgrad
across 24 shapes, plus the **four-calibre** comparison (native / hoist /
per-call fast transpose / Triton) measured in one process, interleaved point by
point so clock drift lands on all four equally.

```bash
python benchmarks/bench_matrix.py --outdir results/nn_pipeline
```

Median of 5 samples, each a launch loop filling ~40 ms, `cv` reported per point.

### `bench_flydsl_gg_matrix.py` — the target-matrix driver

The general driver, with a Triton / hipBLASLt / FlyDSL backend switch. Reuses
Primus-Turbo's own timing path rather than a home-made timer, and measures the
three operators **separately** — the project's own benchmark script lumps
dgrad and wgrad into one backward number, which is why this exists.

Two modes: `--registry` goes through the Primus-Turbo backend registry;
`--standalone` calls the arch dispatch directly and needs no importable
`primus_turbo.pytorch`. All measurements in this repository used `--standalone`.

`gg_matrix_defs.py` holds the shape table, split out so the correctness harness
shares it.

### `bench_quick.py` — a fast native-vs-hoist check

Six shapes, enough to see whether a change moved the ratio. Use during
iteration; use `bench_matrix.py` for anything you intend to quote.

### `dump_stats.py` — answer perf questions from the assembly

Compiles one shape both ways and diffs the generated code: VGPR/SGPR counts,
spills, scratch, LDS bytes, and the instruction mix.

```bash
FLYDSL_DUMP_IR=1 FLYDSL_DEBUG_DUMP_ASM=1 FLYDSL_DUMP_DIR=asm \
  python benchmarks/dump_stats.py
```

This is what excluded register pressure and occupancy as explanations for the
native pipeline's 2.1 %: VGPR 790 vs 791, zero spill on both, **77 fewer
instructions** on the native path. Also what populates `asm/`.

---

## Tuning sweeps

### `ab_variants.py` — the LDS pad sweep, worth 6.5 %

Sweeps the transposed B stage's LDS pad from 16 to 160 in steps of 16, on six
shapes, always against NT on an identical tile. Found the bimodal split on
`LDS_B_ROW % 64 == 32`, which is the entire difference between "the native NN
pipeline costs 7 %" and "it costs 1 %".

**Mechanism still unexplained** — a 32-bank model predicts the exact opposite.
Re-run this rather than extrapolating if you introduce a new `tile_n`.

### `sweep_narrow.py` — the `tile_n=128` + `tile_k=64` rule

54 synthetic cells whose reduction length forces `tile_k=64`. Established
geomean 0.896 at `tile_n=128` against 1.103 at 256, and that `tile_n=128` with
`tile_k=128` is fine — so it is the combination that is bad, not the tile width.

### `probe_outlier.py` — the worst native-vs-hoist point

Tile scan for gpt-oss fc2 dgrad @ avg_m=2048 (ratio 0.872). Identified the cause
as the unavailable `tile_n=192` tile rather than the transpose read.

---

## `dgrad_study/` — the decision study that preceded the pipeline

Ran before the native NN pipeline existed, to answer "given that dgrad needs a
transposed weight, what is the least bad way to get one?" Its conclusions fed
`docs/02-dgrad-problem.md`, and two of them still stand on their own.

| script | what it established |
|---|---|
| **`bench_transpose.py`** | **The key experiment.** `make_nn_weight_nt` runs at 1.07–1.39 TB/s; a ~20-line tiled Triton transpose does the same shapes at **15.5–17.1 TB/s**, bit-exact — **11.0×–14.9× faster**, and faster than torch's *non*-transposing copy. |
| `bench_dgrad.py` | per-shape `t_gemm` / `t_transpose` / `t_nocache` / Triton, and N\* |
| `part2_memory.py` | the cache costs **+141 GiB / +152 GiB** on the two large models |
| `part3_cache.py` | the cache prototype — 38 assertions pass, and **`AdamW(fused=True)` does not bump `param._version`**, giving 9.99e-02 silent error |
| `part4_algebra.py` | the per-group variable-K reformulation: bitwise correct, **1.5×–10.5× slower** |
| `wave_quant.py` | **disproved** wave quantisation as the small-`avg_m` explanation (Spearman −0.55, wrong sign) |
| `common.py` | shared harness: interleaved timing, `sclk` sampling, the shape table |

`analyze.py`, `decision.py`, `summarize.py` turn the raw JSON in
`results/dgrad_study/` into the tables quoted in the docs.

> Read `bench_transpose.py` even if you never touch this part. It is a compact
> demonstration of checking whether an operation is slow or its *implementation*
> is, before designing around the cost.
