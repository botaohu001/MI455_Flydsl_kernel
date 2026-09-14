# dgrad on gfx1250: is a transposed-weight cache worth it?

All numbers measured on this box (MI455X / gfx1250, 256 CU, 432.0 GiB HBM),
card 1 only, flydsl 0.2.4, torch 2.11.0+rocm7.14. Clocks not pinned; sclk
stayed in **1967–2307 MHz** across every timed point. Triton and flydsl are
always measured **in the same process, interleaved repeat by repeat**, so a
clock excursion lands on both.

Nothing here is taken from `BENCH_REPORT.md`, `KERNEL_REVIEW.md` or
`UPSTREAM_NOTES.md`. Where a conclusion contradicts them, the measurement wins.

Scripts and raw results: this directory. 42 (shape, avg_m) cells in
`results/decision_table.csv`.

---

## The short version

1. **The transpose helper is the problem, not the absence of a cache.**
   `make_nn_weight_nt` = `b.transpose(1,2).contiguous()` runs at **1.07–1.39
   TB/s**. A 20-line tiled Triton transpose runs the same shapes at **15.5–17.1
   TB/s**, bit-exact — **11.0× to 14.9× faster**. MI455X HBM4 peak is ~19.6
   TB/s, so the upstream helper is at 6–7% of peak and the replacement is at
   ~82%.

2. **Once the transpose is fast, the cache is only needed where flydsl loses
   anyway.** For every one of the 24 cells with `avg_m ≥ 1536`, **N\* < 1** —
   the transpose pays for itself inside a single call. For `avg_m < 1536`, a
   cache does help (+34% geomean) but the *ceiling* there is 1.076× Triton, and
   5 of those 18 cells lose to Triton even with a completely free transpose.

3. **The cache costs a full duplicate of the local expert weights**: +141 GiB
   (32.6% of HBM) for qwen3-235b-a22b, +152 GiB (35.2%) for deepseek-v3, at
   EP=8. And it is all-or-nothing: backward touches each layer once per
   micro-batch, so a bounded-size cache has ~0 hit rate.

4. **`_version` does not catch a fused optimizer.** `torch.optim.AdamW(fused=True)`
   writes the parameter without bumping `param._version`. A `_version`-keyed
   cache then serves last step's transpose and dgrad comes out **9.99e-2
   relative error** — no fault, no NaN. Reproduced end to end.

**Recommendation: fix the transpose, do not add the cache, and dispatch dgrad
on `avg_m`.**

---

## Part 1 — per-shape terms and N\*

`t_gemm`, `t_transpose`, `t_nocache` and the Triton baseline are four separate
measurements; none is obtained by subtracting another. Median of 9 repeats,
each repeat a timed loop of 3–300 launches sized to ~50 ms. **cv ≤ 1.9%
everywhere** except the fast transpose on the two smallest cells (11 µs per
call, cv up to 12.8% — ±1.4 µs absolute, does not move anything).

Every cell was checked against an fp32 per-group reference: `rel_fro` 1.655e-03
to 1.663e-03, i.e. the bf16 floor, and **flydsl dgrad is bitwise equal to Triton
dgrad in all 24 cells**.

### With the upstream `make_nn_weight_nt`

| Model | Layer | avg_m | w (MiB) | t_transpose | t_gemm | t_triton | gemm/triton | **N\*** |
|---|---|--:|--:|--:|--:|--:|--:|--:|
| gpt-oss-20b | fc1 | 512 | 126.6 | 0.238 | 0.074 | 0.119 | 1.61× | **5.27** |
| gpt-oss-20b | fc2 | 512 | 63.3 | 0.124 | 0.043 | 0.064 | 1.47× | **6.05** |
| gpt-oss-20b | fc1 | 1024 | 126.6 | 0.238 | 0.096 | 0.126 | 1.31× | **7.90** |
| gpt-oss-20b | fc2 | 1024 | 63.3 | 0.124 | 0.059 | 0.069 | 1.17× | 12.69 |
| gpt-oss-20b | fc1 | 2048 | 126.6 | 0.239 | 0.172 | 0.247 | 1.43× | **3.22** |
| gpt-oss-20b | fc2 | 2048 | 63.3 | 0.124 | 0.093 | 0.137 | 1.47× | **2.82** |
| qwen3-30b-a3b | fc1 | 512 | 256.0 | 0.423 | 0.125 | 0.103 | 0.82× | ∞ |
| qwen3-30b-a3b | fc2 | 512 | 128.0 | 0.230 | 0.076 | 0.058 | 0.76× | ∞ |
| qwen3-30b-a3b | fc1 | 1024 | 256.0 | 0.423 | 0.188 | 0.195 | 1.04× | 57.1 |
| qwen3-30b-a3b | fc2 | 1024 | 128.0 | 0.230 | 0.108 | 0.110 | 1.02× | 99.2 |
| qwen3-30b-a3b | fc1 | 2048 | 256.0 | 0.423 | 0.314 | 0.385 | 1.23× | **5.95** |
| qwen3-30b-a3b | fc2 | 2048 | 128.0 | 0.230 | 0.173 | 0.217 | 1.25× | **5.24** |
| qwen3-235b-a22b | fc1 | 512 | 1024.0 | 1.545 | 0.379 | 0.376 | 0.99× | ∞ |
| qwen3-235b-a22b | fc2 | 512 | 512.0 | 0.850 | 0.201 | 0.200 | 1.00× | ∞ |
| qwen3-235b-a22b | fc1 | 1024 | 1024.0 | 1.545 | 0.631 | 0.732 | 1.16× | 15.3 |
| qwen3-235b-a22b | fc2 | 1024 | 512.0 | 0.849 | 0.330 | 0.389 | 1.18× | 14.4 |
| qwen3-235b-a22b | fc1 | 2048 | 1024.0 | 1.545 | 1.113 | 1.454 | 1.31× | **4.53** |
| qwen3-235b-a22b | fc2 | 2048 | 512.0 | 0.851 | 0.581 | 0.771 | 1.33× | **4.47** |
| deepseek-v3 | fc1 | 128 | 1792.0 | 2.947 | 0.296 | 0.391 | 1.32× | 31.0 |
| deepseek-v3 | fc2 | 128 | 896.0 | 1.656 | 0.161 | 0.175 | 1.09× | 118 |
| deepseek-v3 | fc1 | 256 | 1792.0 | 2.955 | 0.436 | 0.403 | 0.93× | ∞ |
| deepseek-v3 | fc2 | 256 | 896.0 | 1.657 | 0.220 | 0.180 | 0.82× | ∞ |
| deepseek-v3 | fc1 | 512 | 1792.0 | 2.947 | 0.688 | 0.704 | 1.02× | 178 |
| deepseek-v3 | fc2 | 512 | 896.0 | 1.656 | 0.337 | 0.341 | 1.01× | 455 |

All times in ms. `N* = t_transpose / (t_triton − t_gemm)`, ∞ where flydsl's GEMM
is slower than Triton even with the transpose free. 9 of 24 cells reach
N\* ≤ 8.

### With the tiled Triton transpose (bit-exact replacement)

`t_gemm` and `t_triton` are unchanged (same kernels); only `t_transpose` moves,
and N\* moves with it by the same factor.

| avg_m | t_transpose torch → fast | speedup | N\* torch → fast |
|--:|--|--:|--|
| 128 (ds) | 2.947 → 0.236 / 1.656 → 0.117 | 12.5× / 14.2× | 31.0 → **2.43** / 118 → **7.93** |
| 512 (gpt-oss fc1) | 0.238 → 0.017 | 13.9× | 5.27 → **0.37** |
| 1024 (qwen235b fc1) | 1.545 → 0.133 | 11.7× | 15.3 → **1.31** |
| 2048 (qwen235b fc1) | 1.545 → 0.132 | 11.7× | 4.53 → **0.39** |

Full table in `results/part1b_transpose.csv`. A plain `torch` copy of the same
bytes runs at 7.05–11.1 TB/s, so even torch's *non*-transposing copy is only at
36–57% of peak; the tiled kernel beats it too.

---

## Part 1b — does the linear model hold?

`t_eff(N) = t_gemm + t_transpose/N`, checked against directly measured
end-to-end N ∈ {1,2,4,8,16,32}.

**With the upstream transpose: yes.** Median |deviation| 0.92%, range −1.23% to
+4.69% over 144 points. The worst cell is deepseek-v3 fc1 avg_m=128 (+4.7% at
N=8).

**With the fast transpose: yes for N ≥ 2, no at N = 1.** Median |deviation|
2.61%, but the miss is concentrated at N=1, up to **+35%** (gpt-oss fc2
avg_m=512). Expressed as absolute error per *window* it is a **fixed ~5 µs**
that does not scale with N — a dependent-launch boundary. It only shows up as a
large *percentage* because the fast transpose is itself 11–236 µs. At N ≥ 4 it
is below 1%.

The two regimes differ in a second way worth stating. With the upstream
transpose the model miss per window *grows* with N (3.3 µs at N=1 to 39.4 µs at
N=32, median), i.e. ~1.2 µs per GEMM — the GEMMs inside a window are
consistently a little slower than the same GEMM measured alone. The most likely
cause is cache state: the transpose writes a parameter-sized buffer immediately
before, evicting what the GEMM wants. I did not isolate it further; the effect
is ≤ 5% and does not change any conclusion. With the fast transpose this term is
absent (−0.16 µs per GEMM, i.e. slightly *faster* than the model).

**Conclusion: use the model for planning, but it under-predicts the N=1 cost by
a fixed launch boundary, which matters exactly when you are deciding whether to
skip the cache.**

---

## Part 1c — is N\* predictable from weight-bytes / GEMM-FLOP?

**The premise does not survive contact with the algebra.** The ratio is

```
weight bytes / GEMM FLOP = (G·N·K·2) / (2·G·avg_m·N·K) = 1 / avg_m
```

identically — it does not depend on G, N or K at all. Verified numerically:
`ratio × avg_m == 1.0` for all 24 cells. deepseek-v3 looks worse only because
the study gives it avg_m ∈ {128,256,512} while gpt-oss gets {512,1024,2048}. At
equal avg_m the two have identical ratios.

And the ratio does **not** order N\*: Spearman(ratio, N\*) = 0.744, but at the
single value ratio = 1.95e-03 (avg_m = 512) N\* spans 5.27 to ∞. The reason is
visible in the formula:

```
N* = 2 / ( BW_transpose · avg_m · (1/T_triton − 1/T_flydsl) )
```

The `1/avg_m` part is exactly the ratio; the throughput-gap part is not, and it
is what actually decides. Spearman(flydsl/Triton speedup, N\*) = **−0.827**,
stronger than the ratio.

**So: no, the ratio is not a usable judgement criterion. What it does give,
cleanly, is that the *value of caching* — `t_transpose / t_gemm` — is
proportional to `1/avg_m`:** 0.73–0.80 at avg_m=128, 0.21–0.35 at 512,
0.09–0.12 at 2048. That is the real result behind the hypothesis.

---

## Part 2 — memory cost

HBM on this box: **463 856 467 968 B = 432.0 GiB = 463.9 GB**. (The brief says
442 GB; percentages below use the measured value.) Per-layer arithmetic checked
against a real device allocation.

Layer counts (verified against published configs, not assumed):

| Model | decoder layers | MoE layers | source |
|---|--:|--:|---|
| gpt-oss-20b | 24 | 24 | model card: 24 layers, every layer MoE |
| qwen3-30b-a3b | 48 | 48 | `num_hidden_layers=48`, `decoder_sparse_step=1` |
| qwen3-235b-a22b | 94 | 94 | `num_hidden_layers=94`, `decoder_sparse_step=1` |
| deepseek-v3 | 61 | **58** | `num_hidden_layers=61`, `first_k_dense_replace=3` |

| Model | fc1 | fc2 | per MoE layer | all MoE layers | **transposed copy** | **% of HBM** |
|---|--:|--:|--:|--:|--:|--:|
| gpt-oss-20b | 126.6 MiB | 63.3 MiB | 189.8 MiB | 4.45 GiB | **+4.45 GiB** | **1.03%** |
| qwen3-30b-a3b | 256.0 MiB | 128.0 MiB | 384.0 MiB | 18.00 GiB | **+18.00 GiB** | **4.17%** |
| qwen3-235b-a22b | 1024.0 MiB | 512.0 MiB | 1536.0 MiB | 141.00 GiB | **+141.00 GiB** | **32.64%** |
| deepseek-v3 | 1792.0 MiB | 896.0 MiB | 2688.0 MiB | 152.25 GiB | **+152.25 GiB** | **35.24%** |

These are per-GPU numbers at EP=8 (G = local experts). For the two large models
the cache takes expert weights from 33–35% of HBM to 65–70%, before optimizer
state and activations.

**The cache cannot be made smaller.** Backward visits each layer once per
micro-batch, so an entry filled at layer L in micro-batch *i* is only hit at
layer L in micro-batch *i+1* — after every other layer has been through.
Bounding the cache to k < n_layers entries drives the hit rate to zero.

---

## Part 3 — the prototype, and why it should not ship

Built anyway (N\* ≤ 8 is reachable): `weakref` + `data_ptr` + `_version`, the
same provenance idiom as `_prov_key`/`check_prebuilt` in the kernel, keyed on
`id(b)` with a `weakref.finalize` to evict. `part3_cache.py`.

**38 assertions, 0 failures**, on both transpose implementations:

- cache hit returns the same object the miss filled
- cached transpose bitwise equal to a fresh hoist, and to `make_nn_weight_nt`
- dgrad through the cache bitwise equal to dgrad through a hoist
- in-place `add_` bumps `_version`; the entry refreshes; the refreshed result
  is bitwise correct — and the stale buffer really does differ, so the test has
  teeth
- three live weights get three entries, pairwise different
- the entry is evicted when the weight is freed (no pinned parameter-sized leak)
- `set_()` to new storage changes `data_ptr` and invalidates

### The finding that decides it

| how the parameter is written | `_version` bumped? | verdict |
|---|---|---|
| `SGD.step()` | 0→1 | safe |
| `AdamW.step()` (default / `foreach=True` / `foreach=False`) | 0→2 | safe |
| `Adam(capturable=True).step()` | 0→1 | safe |
| **`AdamW(fused=True).step()`** | **0→0** | **UNSAFE** |
| **`p.data.copy_(...)`** | **0→0** | **UNSAFE** |
| **`p.data.add_(...)`** | **0→0** | **UNSAFE** |
| `with no_grad: p.copy_/add_` | 0→1 | safe |
| `p.detach().copy_(...)` | 0→1 | safe |

Demonstrated end to end: after a real `AdamW(fused=True).step()`, the cache
serves the stale transpose and dgrad has **relative error 9.99e-02** against the
correct answer. No exception, no NaN, plausible-looking gradients.

A cache can be made safe — invalidate from an `optimizer.register_step_post_hook`
rather than from `_version` — but that is a framework-level contract, not
something the kernel can enforce, and it fails open.

### End-to-end timing (ms per dgrad, one invalidation then N hits)

| shape | N | turbo today | cache+torch tr | **fast tr, no cache** | cache+fast tr | Triton |
|---|--:|--:|--:|--:|--:|--:|
| gpt-oss fc1 avg_m=512 | 1 | 0.315 | 0.315 | **0.114** | 0.104 | 0.125 |
| gpt-oss fc1 avg_m=512 | 8 | 0.312 | 0.104 | **0.110** | 0.077 | 0.121 |
| qwen235b fc1 avg_m=2048 | 1 | 2.652 | 2.651 | **1.244** | 1.244 | 1.459 |
| qwen235b fc1 avg_m=2048 | 8 | 2.654 | 1.315 | **1.246** | 1.135 | 1.461 |
| deepseek fc1 avg_m=128 | 1 | 3.257 | 3.243 | **0.534** | 0.534 | 0.396 |
| deepseek fc1 avg_m=128 | 8 | 3.249 | 0.691 | **0.532** | 0.326 | 0.393 |
| deepseek fc2 avg_m=512 | 1 | 1.980 | 1.972 | **0.455** | 0.454 | 0.345 |
| deepseek fc2 avg_m=512 | 8 | 1.978 | 0.547 | **0.453** | 0.352 | 0.342 |

The optimizer step is excluded from the timed window (a one-element view bump
stands in for it) because it is a cost every backend pays and putting a
parameter-sized read-modify-write in all four columns drags every ratio toward 1.

---

## Part 4 — is there an algebraic way out?

**No.** Checked against the kernel source, not the notes.

dgrad is `da[m,k] = Σ_n dout[m,n]·w[g][n,k]`, reduction index `n`. In memory
`dout[M,N]` has `n` as its fast axis, `w[G,N,K]` has `n` as its slow axis. The
two pipelines available are:

- **NT** — both operands contiguous along the reduction
- **variable-K** — both operands *strided* along the reduction (LDS-transposed
  via `ds_load_tr16_b128`), **and the groups partition the reduction axis**

dgrad's operand pair is mixed, so neither fits. `(AᵀB)ᵀ = BᵀA` does not rescue
it: that identity renames which operand is which and transposes the *output*,
and neither changes the stride of either operand along `n`. It works for wgrad
only because there the constraint being dodged is `trans_c` (an epilogue
property), not an operand layout.

What *is* expressible, and I measured it rather than arguing: for one group,
`da[rows_g] = (dout[rows_g]ᵀ)ᵀ @ w[g]` is exactly one variable-K call with G=1,
`a = dout[rows_g]ᵀ` of shape `[N, len_g]`, `b = w[g]`, writing straight into a
slice of `da` through the kernel's `out=`. This transposes the **activations**
instead of the weight, and `dout` is smaller than `w` whenever `avg_m < K` —
by up to 56× for deepseek fc1 at avg_m=128.

It is **numerically correct — bitwise identical to the NT route in all 8 cells
tested** — and **1.5× to 10.5× slower than everything else**:

| shape | variable-K route | NT + hoisted | NT + per-call fast tr | Triton |
|---|--:|--:|--:|--:|
| gpt-oss fc1 avg_m=512 | 0.359 | 0.077 | 0.109 | 0.122 |
| qwen3-30b fc1 avg_m=512 | 1.009 | 0.125 | 0.168 | 0.103 |
| qwen235b fc1 avg_m=2048 | 2.035 | 1.114 | 1.242 | 1.453 |
| deepseek fc1 avg_m=128 | 2.034 | 0.295 | 0.529 | 0.392 |
| deepseek fc2 avg_m=512 | 3.205 | 0.338 | 0.451 | 0.341 |

It pays G serialised launches (4–32), each with only `N` rows of reduction
depth, and drops to the 64×64 fallback tile when `avg_m < 256`. The activation
transpose being cheap does not come close to covering that. Dead.

A rejected hypothesis worth recording: I tested whether the five cells where
flydsl's GEMM loses to Triton are explained by wave quantisation (the kernel
"launches one workgroup per output tile with no persistent loop", so a tile
count just past a wave boundary should cost a full wave). **It is not the
mechanism** — Spearman(wave efficiency, speedup) = **−0.55**, the wrong sign,
and four of the five losing cells sit at wave efficiency 1.00.
`results/wave_quant.txt`.

---

## The dispatch rule

No threshold on M, N, K or avg_m separates "flydsl's GEMM beats Triton" cleanly
— the wins and losses overlap on every axis, and the trend is not even monotone
within a model (gpt-oss fc1: 1.62×, 1.31×, 1.42× at avg_m 512/1024/2048).

But that is the wrong question. The question is whether the *end-to-end dgrad*,
transpose included, beats Triton, and there a threshold does appear. Extending
the grid to avg_m ∈ {1536, 3072, 4096} to check it is not an artifact of the
sampled points (18 extra cells, `results/part1_extra_avgm.csv`):

| rule: flydsl iff avg_m ≥ T, **no cache**, fast transpose | routed to flydsl | mis-routed | geomean over 42 cells | worst routed cell |
|--:|--:|--:|--:|--:|
| always flydsl | 42/42 | 19 | 0.979 | 0.526 |
| T = 1024 | 30/42 | 9 | 1.081 | 0.781 |
| **T = 1536** | **24/42** | **3** | **1.099** | **0.942** |
| T = 2048 | 18/42 | 5 | 1.086 | 1.057 |
| T = 3072 | 12/42 | 11 | 1.065 | 1.123 |

**T = 1536 is the optimum** and the boundary is real, not a grid artifact: all
24 cells at avg_m ≥ 1536 have **N\* < 1** (range 0.14–0.92), across all four
models including deepseek-v3, which at avg_m ≥ 1536 becomes the *best* case
(1.10–1.38× Triton) despite being the worst at avg_m ≤ 512.

Adding a cache on top lifts the geomean from 1.099 to 1.171 (T=1536) or 1.190
(T=512). **That is +7–8%, on dgrad only, for a full duplicate of the expert
weights and a silent-wrong-gradient failure mode.**

---

## Verdict

| | do it? | why |
|---|---|---|
| **Ship the current path** (turbo passes no `b_nt`) | **no** | geomean **0.276×** Triton; between **1.6× and 10.5× slower** than just calling Triton. This is a bug, not a tuning question. |
| **Replace `make_nn_weight_nt` with a tiled transpose** | **yes, unconditionally** | 11–14×, bit-exact, ~20 lines, zero memory cost, zero new failure mode. Lifts the no-cache path from 0.276× to 0.842× geomean on the original 24 cells. |
| **Add a transposed-weight cache** | **no** | +7–8% geomean on dgrad only, in exchange for +141/+152 GiB (33–35% of HBM) on the two large models, all-or-nothing by construction, and a `_version` invalidation that fused optimizers defeat silently. |
| **Fall back to Triton for dgrad** | **conditionally** | Yes for `avg_m < 1536`. No for `avg_m ≥ 1536`, where flydsl wins 24/24 with no cache at all. |

Concretely, in `GroupedGEMMFlyDSLBackend.execute`:

- for the NN (dgrad) direction, gate on `avg_m = M_total / G ≥ 1536`; below
  that, decline and let the registry fall back to Triton
- above it, pass `b_nt=<tiled transpose>(b)` **per call** — no cache, no
  lifetime question, no invalidation contract
- fwd and wgrad are untouched by any of this

Caveat on the threshold: it is fitted on 42 cells from four models on one part,
and 1536 is interior to the sampled range 128–4096, which is why I extended the
grid rather than reading it off the original 24. It should be re-measured, not
extrapolated, for a new arch or a new tuning table.

## Anomalies and real errors

1. **`AdamW(fused=True)` does not bump `param._version`** (torch 2.11.0+rocm7.14).
   Nor do `p.data.copy_()` / `p.data.add_()`. Reproduced; 9.99e-02 relative
   error in dgrad through a `_version`-keyed cache.
2. **HBM is 463.9 GB / 432.0 GiB**, not the 442 GB in the brief.
3. `make_nn_weight_nt`'s docstring says `.transpose().contiguous()` runs at
   "~1.07 TB/s against ~7.2 TB/s for a plain copy". Both halves reproduce
   (1.07–1.39 and 7.05–11.1 TB/s), but neither is the ceiling: a tiled kernel
   does the *transpose* at 15.5–17.1 TB/s, faster than torch's non-transposing
   copy.
4. flydsl **0.2.4** runs this kernel on gfx1250 fine, despite the module header
   requiring ">= 0.3.0". All 24 cells correct to the bf16 floor.
5. The docstring warns that gpt-oss fc2 (N == K == 2880) can return corrupt
   results on the first 1–2 calls of a fresh process. I burned 4 calls before
   every check as instructed and **never saw corruption**, so this run neither
   confirms nor refutes it — call 1 was not tested.
6. My own first cut of the cache hit/miss assertion expected 3 hits where the
   test makes 2. Test bug, fixed; the cache was correct.
7. One high-variance measurement: the fast transpose on gpt-oss fc2
   (11 µs/call) has cv up to 12.8%, i.e. ±1.4 µs. Everything else is cv ≤ 1.9%.
8. `trans_c=True` and `cap_cu != 0` raise `NotImplementedError` on the
   variable-K kernel, as documented — hit while building the Part 4 route, and
   worked around by the operand swap.
