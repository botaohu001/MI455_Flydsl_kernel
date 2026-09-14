# `results/` — raw measurement data

Every number quoted in `docs/` traces to a file here. Kept as CSV/JSON/plain
text rather than as rendered tables so it can be re-analysed.

**Measurement conditions apply to everything below**: single MI455X (gfx1250),
256 CU, clocks **not pinned** (`sclk` 2010–2331 MHz, sampled per point),
torch 2.11.0+rocm7.14, flydsl 0.2.4, ROCm 7.x container. Full detail in
`docs/07-performance.md` §7.0.

> These are absolute throughput figures for pre-release hardware.

---

## `nn_pipeline/` — the shipped kernel

| file | what |
|---|---|
| `matrix_fwd.csv`, `matrix_dgrad.csv`, `matrix_wgrad.csv` | the three delivery tables in `docs/07-performance.md` §7.1–7.3, with `ms`, `TF/s`, MFU, config, `sclk`, `cv` per point |
| `quick_nn_vs_hoist.json` | the four-calibre comparison (§7.4) — native / hoist / per-call fast transpose / Triton, interleaved in one process |
| `quick_nn_vs_hoist_pad32.json` | the same after the LDS pad fix; the 6.5 % is visible between the two |
| `dgrad_calibres.csv`, `.json` | hoist vs per-call transpose, per point, with implied transpose bandwidth |
| `correctness.json` | the 48-row gate: bitwise comparisons and `rel_fro`, call 1 and call 4 recorded separately |
| `ab_variants.json` | the LDS pad sweep, 6 shapes × 10 pads |
| `probe_nn_frag.out` | the measured lane map — the output that made the pipeline safe to build |
| `check_full.out`, `smoke_nn.out` | correctness harness transcripts |
| `sweep_narrow.out` | the 54-cell `tile_n`/`tile_k` combination study |
| `bench_matrix.out`, `bench_matrix_final.out` | full benchmark transcripts, before and after the final tile rule |

## `baseline/` — what to compare against on this part

| file | what |
|---|---|
| `matrix_TRITON.csv`, `matrix_HIPBLASLT.csv` | the 72-point delivery matrix, same driver |
| `grouped_gemm_bf16_TRITON.csv` | the project's own 360-case sweep — **360/360 PASS**, the only fully working backend |
| `grouped_gemm_bf16_CK.csv` | the same sweep for CK — **312/360 ERROR**. The 48 "PASS" rows are all `B=1`, routed to a dense path where CK never ran; the script's printed average is meaningless. See `docs/06-pitfalls.md` §6.5. |

hipBLASLt has the best single forward number here but its grouped NN and
variable-K paths run at **~64 TF/s / 1.3 % MFU**. It is a forward-pass ceiling,
not an end-to-end competitor.

## `flydsl_gfx1250/` — the reference kernel, before the NN pipeline

The 96-point matrix, the imbalanced-group rerun, per-point speedups against
Triton and hipBLASLt, and the correctness JSON including the `masked_k`
padded-pool tests and the device-vs-CPU reference cross-check.

`matrix_combined.csv` is the most useful single file: every point with all three
backends side by side.

## `dgrad_study/` — the decision study

| file | what |
|---|---|
| `decision_table.csv` | 42 (shape, `avg_m`) cells — the dispatch-threshold analysis |
| `part1_break_even.csv`, `.json` | `t_gemm` / `t_transpose` / `t_nocache` / Triton and N\*, four separate measurements each, none derived by subtraction |
| `part1b_transpose.csv`, `.json` | **the transpose comparison**: torch 1.07–1.39 TB/s vs tiled Triton 15.5–17.1 TB/s, bit-exactness recorded per variant |
| `part1_fast_tr.*`, `part1_torch_tr.*` | the linear-model check against measured `N ∈ {1,2,4,8,16,32}` |
| `part1_extra_avgm.*` | 18 extra cells at `avg_m ∈ {1536, 3072, 4096}`, added to check the threshold was not a grid artifact |
| `part2_memory.csv` | the cache's memory cost, checked against a real device allocation |
| `part3_cache.csv`, `.json` | the cache prototype, including the `_version` table where `AdamW(fused=True)` fails |
| `part4_algebra.csv`, `.json` | the per-group variable-K reformulation: correct, 1.5×–10.5× slower |
| `wave_quant.txt` | the **disproof** — Spearman −0.55, wrong sign |
| `analysis.txt`, `summary.txt`, `decision.txt` | rendered analyses |

## `isa/` — capability probes

`probe_isa.out` and `probe_isa2.out` are `llvm-mc` encode/reject results
(**no GPU involved**). `probe_global_tr.out` is the hardware measurement of
`global_load_tr16_b128`'s lane semantics, including the two misaligned strides
that transpose correctly.

## `smoke_matrix.csv`

Three early Triton rows kept as a sanity anchor for the gpt-oss fc1 @avg_m=512
point.

---

## Reading the CSVs

Columns are stable across the matrix files:

```
TestID, Platform, GPU, Backend, Model, Layer, Direction, G, EP, Seq, Batch,
AvgM, TotalM, N, K, Dtype, Check, Time (ms), TFLOPS, MFU (%), cv (%), Config, sclk (MHz)
```

`Config` decodes as `BM<tile_m>/BN<tile_n>/BK<tile_k>/mw<m_warp>/nw<n_warp>/nb<num_buffers>`.

⚠️ **`Direction` alone does not tell you the calibre.** For dgrad, check whether
the file distinguishes `dgrad` (hoisted `b_nt`, GEMM only) from `dgrad_tr`
(per-call transpose inside the timer) — they differ by **2.33×–11.41×**. This
ambiguity in a previous data set cost real time; see `docs/06-pitfalls.md` §6.4.
