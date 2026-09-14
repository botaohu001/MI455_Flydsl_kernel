# gfx1250 (MI455X) bf16 grouped GEMM — upstream submission notes

Companion to `primus_turbo/flydsl/grouped_gemm/grouped_gemm_bf16_kernel_gfx1250.py`.
Reference for the target format: `grouped_gemm_bf16_kernel.py` on branch
the gfx950 development branch (946 lines, gfx950 / MI355X).

> **Verification status of this submission.** The code was reorganised without GPU
> access: nothing here has been compiled, launched or re-benchmarked in this pass.
> Every performance number quoted comes from earlier measured runs of the *same
> kernel bodies* in their pre-consolidation form. Checks actually performed are
> listed in [§7](#7-what-was-verified-in-this-pass). Items that change behaviour
> and therefore need a re-run are flagged **[RE-RUN]** in [§8](#8-pre-submit-checklist).

---

## 1. Deliverables

```
upstream/
├── UPSTREAM_NOTES.md                                     ← this file
└── primus_turbo/flydsl/grouped_gemm/
    ├── grouped_gemm_bf16_kernel_gfx1250.py               ← all three kernels, 2290 lines
    └── grouped_gemm_bf16_dispatch.py                     ← arch dispatch for direct callers
```

Three source files were merged into one:

| was | became |
|---|---|
| `grouped_gemm_bf16_kernel.py` (NT forward) | the NT section |
| `grouped_gemm_bf16_backward.py` (dgrad + NT wgrad) | dgrad → the NN section; **NT wgrad dropped**, see §4 |
| `grouped_gemm_bf16_wgrad_tn.py` (TN wgrad) | the variable-K section |

---

## 2. Structure map against the MI355 file

The section order mirrors the reference exactly.

| MI355 (gfx950 dev branch) | gfx1250 file | relationship |
|---|---|---|
| AMD `###` copyright header | same | same form, 2026 + the FlyDSL gfx1250 provenance lines |
| module docstring | same | rewritten: adds the arch-difference table, the dispatch note and the wgrad-calibre warning |
| `_load_i32`, `_load_i64_as_i32` | `_i32_table` | **replaced.** `ptrtoint`/`llvm.load` do not hold on a memref here; `recast_iter` + subscript does |
| `_tail_quad_conds` | — | **gone.** Quadrant masking is a consequence of the gfx950 4-quadrant MFMA accumulator layout; TDM extents clamp in hardware instead |
| `_ab_ty` | `is_f16: Constexpr[int]` | **equivalent.** An int rather than a type object, because the constexpr tail doubles as the compile-cache key |
| `_grid_x` | — | **gone with `cap_cu`**, see §5 |
| — | `_gcn_arch`, `_require_gfx1250` | **new.** Runtime arch assertion, §3 |
| — | `_make_lds_copy_ops`, `_as_ptr`, `_workgroup_barrier`, `_pipeline_fence` | **new.** gfx1250 primitives, §4 |
| — | `_group_m_tile_decode`, `_xcd_band_remap` | **local copies** of `gemm_helper` functions, §4 |
| `@ASTRewriter.transform grouped_gemm_bf16_variable_k_tile` | `@flyc.jit _launch_grouped_bf16_variable_k` | **rewritten.** Not an `ASTRewriter` body — see `ASTRewriter.transform` in §4 |
| `@lru_cache _compile_grouped_bf16_wgrad` | `_vk_launch` + `_VK_COMPILED` | **equivalent role, different mechanism.** Keys on the constexpr tail and caches the pre-bound `CallState`, which is what removed 47.2 µs of per-call CPU |
| `m_tile_upper_bound` | same | **identical**, signature and body |
| `build_m_tile_table` | same | **signature-identical**, kept for cross-checking; superseded on the fast path by `build_m_tile_map` (the host table cost a constant ~92 µs/call, 50.3 % of wall at avg_m=2048) |
| `_row_starts` | — | unused here |
| `_ptr_only_view` | `_as_ptr` | **replaced**, see §4 |
| — | `build_m_tile_map`, `build_m_tile_map_offs_only`, `_decode_m_tile`, `_decode_m_tile_scan`, `build_expert_table`, `_prov_key`/`_tag_prov`/`check_prebuilt` | **new**, gfx1250-only |
| `grouped_gemm_bf16_variable_k_flydsl_kernel` | same name | **semantically equivalent**, §4a |
| `_compile_grouped_bf16_nt` + `grouped_gemm_bf16_nt_flydsl_kernel` | `_launch_grouped_gemm_bf16_nt` + same name | **same operator**, different body |
| `_compile_grouped_bf16_nn` + `grouped_gemm_bf16_nn_flydsl_kernel` | `grouped_gemm_bf16_nn_flydsl_kernel` (no kernel of its own) | ⚠️ **same name, extra cost.** See §4b — the single largest review risk |
| — | `_pick_config`, `_pick_variable_k_config` | **new.** gfx950 takes tiles as caller arguments; gfx1250 picks them from the shape |

### Ours that the reference has no counterpart for

`build_m_tile_map` / `_decode_m_tile` (in-kernel expert search replacing the host
per-tile table), the provenance system (`_prov_key` / `check_prebuilt`) that lets a
caller reuse an index table across the four calls of one MoE layer, `_pick_config`
/ `_pick_variable_k_config`, and the pre-bound `CallState` launch path
(`_nt_launch` / `_vk_launch`).

---

## 3. Architecture dispatch

**Chosen: separate file per arch, lazy import, runtime assertion.** (The option the
task suggested, and it holds up.)

Three reasons, in order of weight:

1. **Import safety.** The gfx1250 module builds WMMA/TDM atoms against
   `flydsl >= 0.3.0`; the gfx950 module imports `primus_turbo.flydsl.utils.gemm_helper`,
   2200 lines of gfx9 MFMA/DPP/SRD primitives. Neither belongs in the other's
   import graph, and a flydsl too old for the gfx1250 surface must not break an
   otherwise working gfx950 install. With a lazy import that is a caught
   `ImportError` degrading to Triton; with one shared module it is an import-time
   crash for everybody.
2. **Nothing is shared below the signature.** Wave size, matrix engine,
   accumulator storage, global→LDS path, OOB mechanism and barrier primitive all
   differ. An `if arch ==` would be two disjoint bodies under one `def`.
3. **The tuning tables are per-arch and partly fitted** (§6). A shared
   `_pick_config` would invite exactly the cross-arch extrapolation those
   thresholds cannot support.

**Cost of the split:** the two files duplicate `m_tile_upper_bound`,
`build_m_tile_table` and the tile-index math (~60 lines). Accepted — deduplicating
would mean a third shared module that both arches import, which re-creates problem
(1) unless it is kept strictly torch-only, and the shared surface is too small to
be worth the indirection.

### Three layers, in the order a caller should prefer them

1. **`BackendType.FLYDSL` in `primus_turbo/pytorch/kernels/grouped_gemm/grouped_gemm_impl.py`**
   — the production path. Already prototyped on branch the local integration branch.
   Checks `is_gfx1250()`, dtype, layout, `trans_*`, `schedule`, `num_cu` and the
   `K % tile_k` divisibility rule, and falls back to Triton on any miss.
   *This is where dispatch belongs*; §8 has the diff notes.
2. **`grouped_gemm_bf16_dispatch.py`** — for bring-up scripts, micro-benchmarks and
   tests that want the flydsl kernel directly. Allow-lists `gfx950`/`gfx1250` and
   raises by name on anything else, rather than silently picking a branch.
3. **`_require_gfx1250()` inside the kernel module** — the backstop. Every public
   entry calls it; it reads `gcnArchName` (substring match, since it carries target
   features like `gfx1250:xnack-`), caches per device index, and raises a message
   naming both the wrong arch and the right module. A mis-dispatched call fails
   loudly instead of miscompiling or faulting.

`grouped_gemm/__init__.py` was **not** touched — upstream's is a bare licence header,
and putting dispatch there would make every importer of any sibling kernel pay for
the arch probe.

---

## 4. Dependency ledger — reused vs kept local

Legend: **reuse** = imported from upstream · **local** = kept in this file · **n/a** = no counterpart.

### 4.0 What the reference imports, item by item

| upstream symbol | verdict | reason |
|---|---|---|
| `gemm_bf16_kernel._make_shared_storage` | **local** (`ARENA_B` + `SharedAllocator(static=False)`) | gfx950's LDS is `[M+N] × (2·BLOCK_K + pad)` shaped for MFMA and `ds_read_b64_tr_b16`. Ours is a flat TDM arena whose `pad_interval`/`pad_amount` are baked into the TDM atom, and the variable-K kernel's arena is transposed relative to the NT one (`[tile_k, out_cols]`). Not a parameter change. |
| `gemm_bf16_kernel.gemm_bf16_nt_tile` / `gemm_bf16_nn_tile` | **local** | The entire tile body: MFMA→WMMA, wave64→wave32, SRD→TDM, AGPR→VGPR. |
| `gemm_helper.Mfma16x16x32` | **local** (`fx.rocdl.WMMA(16,16,32)`) | gfx12 has no MFMA. |
| `gemm_helper.S2RLoaderTr16x32Bf16Wide` | **local** | `ds_read_b64_tr_b16` is gfx950. gfx12's `ds_load_tr16_b128` has **different lane semantics** — measured empirically and documented in the variable-K section header; guessing at them would have produced a plausible wrong answer. |
| `gemm_helper.G2SLoader` | **local** (TDM `fx.copy`) | `buffer_load` + SRD vs. the TDM DMA engine. |
| `gemm_helper.StoreCBf16` | **local** | SRD `num_records` vs. TDM `tensor_extents` (two axes). |
| `gemm_helper.make_bf16_buffer_tensor_rebased`, `make_bf16_fp16_tile_tensor` | **local** (`fx.make_view` + `fx.add_offset`) | Both build a 128-bit buffer SRD. There is no SRD on this path. |
| `gemm_helper.wait_barrier` | **local** (`_pipeline_fence`) | `s_barrier` + lgkmcnt vs. `tdm_ops.tensor_wait` + `gpu.barrier`. |
| `gemm_helper.make_value_attrs(waves_per_eu, agpr_alloc, …)` | **n/a** | gfx12 has no AGPRs, so `agpr_alloc` is meaningless. Scheduling is set through `compile_hints["llvm_options"]` instead. |
| `gemm_helper.compute_global_swizzle_nn_bf16_wide` | **n/a** | A lane→address swizzle for `buffer_load`. TDM computes its own addresses. |
| `gemm_helper.emit_for` / `emit_if_then` | **n/a** | They exist to emit device control flow inside `ASTRewriter.transform` bodies. Ours are plain Python closures over `const_expr`, so Python control flow *is* compile-time control flow. |
| `gemm_helper.wave_lane_with_rank`, `wave_rank_desc_stable` | **n/a** | gfx950 ranks experts by token count in a wave64 lane register to reorder dispatch. Not ported (wave32 changes the primitive) and not measured as needed. |
| `gemm_helper.xcd_band_remap_pid` | **local**, ⚠️ see below | |
| `gemm_helper.group_m_tile_decode` | **local**, ⚠️ see below | |
| `gemm_helper._readfirstlane_i32` | **local** (`rocdl.readfirstlane(T.i32, v)`) | Same intrinsic; upstream's wraps the result in `ArithValue`. Blind-swapping changes the value's Python type through every downstream expression. See below. |
| `gemm_helper.BLOCK_K` (=64) | **n/a** | Our K depth is per-shape (`_pick_config`), not a module constant. |
| `utils.prims._i64` | **n/a** | Not used; the gfx1250 path widens with `fx.Int64(...)`. |
| `ASTRewriter.transform` | **n/a** | The rewriter collects loaders built inside a body as `scf.for` iter-args — the reason the gfx950 file wraps its tile work in free functions. Our TDM issue/fence sequencing needs explicit placement of `sched_barrier` and `tensor_wait`, which the rewriter would reorder. |
| `_ptr_only_view` (`t.contiguous().view(torch.int32)`) | **local** (`_as_ptr`) | A torch tensor resolves to `!fly.memref`, which `recast_iter` rejects: `'fly.recast_iter' op operand #0 must be , but got '!fly.memref<…>'`. `flyc.from_c_void_p` yields a real `!fly.ptr`. |
| `pytorch.core.utils.is_gfx1250` | **reuse — at the dispatch layer only** | The kernel module must stay importable without the torch-extension layer (bring-up scripts run it standalone), so it does its own `gcnArchName` check. `grouped_gemm_impl.py` uses `is_gfx1250()`. |

### ⚠️ The two "could reuse, deliberately did not (yet)"

`xcd_band_remap_pid` and `_readfirstlane_i32` are the only genuine reuse candidates —
both are arch-neutral. `xcd_band_remap_pid` and our `_xcd_band_remap` were modelled
in pure Python and compared exhaustively: **0 disagreements over 140 016
`(pid, total_tiles, num_xcd, band)` points** (`num_xcd ∈ {1,2,4,8}`,
`band ∈ {1,2,3,8,24,32}`, 11 tile counts from 1 to 4096). The same sweep confirms
the property the code comment depends on — ours is a **permutation** of
`0..total-1` in every configuration, so no tile is dropped or duplicated. They are
still local, for three reasons:

1. Importing either drags all 2200 lines of `gemm_helper` into a gfx1250-only
   module, which defeats the import-safety property in §3 for two functions.
2. **Neither swap can be validated without compiling**, which this pass could not
   do. They emit device IR; upstream's versions return `ArithValue` where ours
   return `fx.Int32`, and `arith.select` vs. `.select()` is a typing difference
   that shows up at MLIR build time, not at `ast.parse` time.
3. `_xcd_band_remap` is **compile-time dead in the shipped configuration**
   (`num_xcd=1` short-circuits at `const_expr`), so reusing it buys no
   deduplication in the emitted code at all.

**Recommendation:** revisit after the kernels are re-validated on hardware. Each is
a one-line change and would cut ~45 lines. Not worth doing blind.

### 4a. `variable_k` vs `wgrad_tn` — the naming question, resolved

**They are the same operator.** Not "similar" — the same.

| | MI355 `variable_k` | ours (was `wgrad_tn`) |
|---|---|---|
| computes | `out[g] = a[rows_g].T @ b[rows_g]` | same |
| `a` | `[M_total, OUT_M]`, token-major, **not** pre-transposed | `[M_total, N]` (`dout`), same |
| `b` | `[M_total, OUT_N]`, token-major, **not** pre-transposed | `[M_total, K]` (`x`), same |
| output | `[G, OUT_M, OUT_N]` | `[G, N, K]` — same, `OUT_M≡N`, `OUT_N≡K` |
| reduction | M (tokens), per group | same |
| transpose | in LDS, `ds_read_b64_tr_b16` | in LDS, `ds_load_tr16_b128` |
| calibre | end to end | **end to end** |

So the file uses the upstream name `grouped_gemm_bf16_variable_k_flydsl_kernel`,
with upstream's positional signature `(a, b, group_k_offsets, masked_k=None,
out_dtype=…)`. The docstring states the TN/in-LDS-transpose implementation and the
end-to-end calibre explicitly.

Independent confirmation: branch the local integration branch already routes
this kernel to upstream's `grouped_gemm_variable_k_impl` op
(`GroupedGEMMVariableKFlyDSLBackend`), i.e. the mapping was arrived at twice
independently.

**`masked_k` is now supported** (it was not before). It needed no kernel change:
`build_expert_table` writes `m_len = masked_k[g]` instead of
`offs[g+1] - offs[g]`, and the TDM dim-0 extent (`rem = m_len - kt·tile_k`) already
bounds the reduction to exactly `[m_start, m_start + m_len)`, so a padded tail is
never addressed. **[RE-RUN]** — correct by construction, never executed.

#### The calibre trap this avoids — read this before comparing any wgrad number

There were **two** wgrad implementations during bring-up:

| | pre-transposed ("NT wgrad") | in-LDS-transpose (shipped, = `variable_k`) |
|---|---|---|
| inputs | `dout_t[N, M]`, `a_t[K, M]` | `dout[M, N]`, `a[M, K]` |
| needs `.t().contiguous()` first | **yes, two of them** | no |
| GEMM-only speed | **faster** (this kernel is 0.79–0.81× of it) | slower |
| end-to-end speed | slower | **1.98–3.45× faster** (6 MoE shapes) |

The two transposes measured **57–75 % of end-to-end wgrad time** — the design notes
had assumed 5–15 %, a 4–5× underestimate. They run at **1.06–1.09 TB/s** against
**6.98–7.24 TB/s** for a plain copy of the same bytes (6.7× slower). Quoting the
pre-transposed kernel's GEMM number while the transposes sit outside the timer
inflates it by **16.3 %** (median over a 524-point matrix).

**The pre-transposed kernel is therefore not in this submission at all.** Only one
calibre is exposed upstream, so the two cannot be mixed. It was the fallback for
`OUT_M < tile_m or OUT_N < tile_n`, which after the descriptor back-off fix means
`OUT_M < 64 or OUT_N < 64` — no MoE shape. `grouped_gemm_bf16_variable_k_supported()`
is the gate; a dispatcher should leave those shapes on Triton.

*If a reviewer wants the pre-transposed kernel back as a documented fast path for
callers that already hold transposed activations, it is ~300 lines in
`grouped_gemm_bf16_backward.py` and can be re-added under an unambiguous name. That
is a product decision, not a technical blocker.*

### 4b. ⚠️ `grouped_gemm_bf16_nn_flydsl_kernel` — same name, different cost

**This is the biggest review risk in the submission.**

The WMMA fragment loader wants both operands reduction-contiguous. For dgrad
(`da[m,k] = Σ_n dout[m,n]·b[g][n,k]`) the weight's reduction axis `n` is its
*strided* axis. gfx950 handles that with its hardware LDS transpose read, so its NN
kernel consumes `b[G, K, N]` natively. gfx1250's transpose read is wired up for the
variable-K kernel but **not** for an NN pipeline — that would be a third full kernel
body written with no hardware to check it against, so it was deliberately not
attempted.

Our dgrad is therefore the NT kernel fed a transposed weight: pure algebra, zero new
kernel code, but somebody has to pay for the transpose.

**Resolution chosen: keep upstream's signature and semantics, materialise the
transpose when the caller does not hoist it.**

```python
b_nt = make_nn_weight_nt(b)        # once per optimizer step
da   = grouped_gemm_bf16_nn_flydsl_kernel(dout, b, offs, b_nt=b_nt)
```

* `b` keeps upstream's `[G, K, N]` meaning, so an upstream caller is **correct**
  without changes.
* Without `b_nt` the transpose is built per call — a parameter-sized copy at
  ~1.07 TB/s — and a one-shot `RuntimeWarning` says so.
* Passing `b` as `b_nt` is caught by a shape assert, except when `N == K`, which is
  a real MoE shape (gpt-oss fc2, 2880). The assert message calls that case out.

Alternatives rejected: *(a)* redefining `b` to mean `[G, N, K]` under the upstream
name — silently wrong at `N == K`; *(b)* raising unless `b_nt` is given — breaks
signature compatibility for the sake of a perf hint.

Prior measurement, worth surfacing: the integration branch gates this path behind
`PRIMUS_TURBO_GFX1250_FLYDSL_GG_TRANSPOSE_B` (default **off**) because
transpose-per-call "is usually a net loss against Triton". If upstream wants a
default-on NN backend, a real NN tile on `ds_load_tr16_b128` is the fix — the
obvious follow-up.

---

## 5. gfx950 parameters that are not implemented

All three raise rather than being silently ignored.

| parameter | behaviour | why |
|---|---|---|
| `cap_cu` (all three entries) | `NotImplementedError` if non-zero | Our kernels launch one workgroup per output tile with no persistent loop for a CU budget to bound. Silently ignoring it would leave a caller trying to reserve CUs for a co-running kernel with neither the reservation nor an error. |
| `trans_c` (variable-K) | `NotImplementedError` if `True` | The epilogue stores through a TDM copy whose layout is fixed at `[OUT_M, OUT_N]`. |
| `BLOCK_M` / `BLOCK_N` | default **0 = pick from shape**, not 256 | Passing 256 explicitly reproduces the gfx950 tile. Leaving 0 also lets `_pick_config` choose `tile_k`/warps/buffers, which is where most of the measured win is. ⚠️ *A behaviour change for a caller relying on the default.* |
| `GROUP_M` | default **16**, not 4 | Measured: +0.8–2.0 % over 4, and 4 was the *worst* of {1,4,8,16} on deepseek fc1. |
| `num_xcd` | default **1**, not 8 | The MI455X XCD count is **unconfirmed**. Correctness does not depend on the value; only performance does. |
| `K % tile_k == 0` | asserted | The gfx950 kernel chunks K at runtime; here the K loop is a compile-time tile count. A dispatcher must pre-check (the integration branch does). |
| `OUT_M ≥ tile_m`, `OUT_N ≥ tile_n` (variable-K) | asserted | Required by the descriptor back-off (§6). gfx950 bounds reads with SRD `num_records` and has no such constraint. |

---

## 6. Correctness constraints preserved in the code

Each of these cost real debugging time; all are commented at the site that depends
on them.

1. **TDM outstanding budget is per WAVE, not per workgroup** (`TDM_PW = 1`).
   A and B are issued by *different* waves, so each issuing wave has one
   outstanding DMA per k-tile, not two. Counting both (`2·(num_buffers−2)` = 2 at
   `num_buffers=3`, against an actual in-flight count of 2) makes `tensor_wait` a
   **no-op** and the pipeline reads LDS the DMA has not filled.
   *Symptom:* **71.16 % of output elements NaN**, remainder at `inf` relative error
   — random bits, not precision. *Discriminator:* `num_buffers` 3→2 fixes it.
   The NT kernel derives the same quantity (`max(1, 2·tdm_parts // num_waves)`)
   rather than hardcoding it, which is why it never hit this.

2. **A TDM extent is measured from the copy's `imm_offset`, not the descriptor
   base.** A descriptor built once with the full token count and walked with
   `imm_offset` clamps *nothing*: every expert whose token count was not a multiple
   of `tile_k` pulled in a whole extra tile of the next expert's tokens. The error
   tracked `m_len % tile_k` exactly — experts dividing evenly were correct at the
   0.1409 % bf16 noise floor, the rest ran 26.6–96.8 % wrong.
   The variable-K kernel sidesteps this entirely by folding the k-tile row offset
   into the descriptor base and copying with `imm_offset=0`.
   *(Behaviourally established over many shapes; **not** confirmed against the
   flydsl TDM source.)*

3. **dim-0 vs dim-1 extent asymmetry** — the measured table, in the code:

   | | bounds addressing? | evidence |
   |---|---|---|
   | dim-0 extent | **yes** (row-granular) | declared 256 rows / 128 valid, never over-read |
   | dim-1 on a **store** | **yes** | 1 MiB sentinel past the output survived a ragged K, element for element |
   | dim-1 on a **load** | **no** — clamps data only | declared 512 B / 256 B valid walked off the allocation → `Memory access fault … Page not present` |

   Design rule, followed throughout: **put the ragged axis on dim 0, never rely on
   dim-1 to bound a load.**

4. **TN over-read fix: back the read base off to `OUT_M − tile_m` / `OUT_N − tile_n`.**
   Puts the claimed window inside the row arithmetically for any remainder, at the
   cost of re-reading `n_back` columns (measured −2.2 % ragged, 0 non-ragged). The
   fragments then index LDS column `r + n_back`. This is what the `OUT_M ≥ tile_m`
   requirement is for.

5. **gpt-oss fc2 (`N == K == 2880`) dgrad: first 1–2 calls corrupt.** Once 7 NaNs,
   once amax 3.47e36; 3rd call onward bit-stable over 8 repeats at 0.1409 %. Host
   fp64 confirms the corruption is real. "Output buffer partially unwritten" was
   **excluded** by a poison-fill experiment. **Root cause not found.** A correctness
   harness must burn 3 calls and check the 4th. Timing is unaffected (~1800 calls).
   Documented on the NN entry point.

### Tuning thresholds — status of each

`_pick_config`'s docstring opens with this table so nobody has to infer it:

| rule | status | extrapolation risk |
|---|---|---|
| 2×2 warp grid (4 waves) | derived | low — mechanism + 259 paired points, geomean 1.0367 |
| `avg_m ≤ 128` → 128×128 | derived | low |
| `tile_k = 128` when `K % 128 == 0` | derived | low — ISA-counted, +6.0–10.4 % |
| `n_groups·⌈avg_m/256⌉ ≤ 8` → 128×128 | **fitted** | **high** — fires on 4 of 48 delivery points, all gpt-oss G=4 |
| `avg_m ≥ 1536 ∧ N % 192 == 0` → 128×192 | **fitted** | **high** — mechanism **not established** |

On the 1536 threshold specifically, the notes record what was *ruled out*, which is
more useful than the threshold itself:

* **Occupancy is excluded.** Over 26 `avg_m` points the wide tile is *always*
  `wg_per_cu = 1` and the narrow tile *always* 2, VGPR constant. Neither is a
  function of `avg_m`, so neither can produce a reversal at one point. A confirmed
  negative, not an untested guess.
* M-tile quantisation waste is excluded (avg_m=1280 has none and still loses;
  avg_m=1152 has 10 % and is the best point in the table at 1.192).
* An HBM-bytes model predicts 0.71 at avg_m=1152 against a measured 1.192 — off by 68 %.

What remains unexplained is a **reproducible sawtooth** in the wide tile's
throughput (980 / 737 / 802 / 868 / 924 TF/s at avg_m 1024 / 1152 / 1280 / 1408 /
1536 on fc2) peaking exactly where the narrow tile loses. The rule is gated to the
region where the ordering was measured stable rather than extrapolated through the
reversal. Widening it changes no delivery point anyway.

### Directions already disproven — do not re-suggest

| | verdict |
|---|---|
| host-side index-table build | cheaper in isolation (56 vs 92 µs), **−31 % end to end** — the D2H sync kills inter-call overlap |
| `inkernel_scan` (per-WG prefix scan) | correct, **−15.2 % fwd / −53.8 % dgrad** |
| `half_n_skip` (skip dead columns) | **−1.3 to −1.7 %** on all four gpt-oss points — TDM never fetched them anyway |
| more waves / higher occupancy | 16 waves×1 WG vs 8×2 WG, same tile: **0.763×** |
| 2 WG/CU co-residency | **−7.0 %** |
| eliminating raggedness by padding | 3 exactly-dividing wide tiles all lost to ragged 256×256 (0.921 / 0.958 / 0.944) |
| device fp64 matmul as a reference | **wrong 11 times in 12** — references must be fp32, judged host-side |

`amdgpu-expert-scheduling-mode` is **on** for both kernels. All nine correctness
gates pass with it, so it does not miscompile *these* kernels on *this* part — but
the analogous Triton pass was found to **silently miscompile** bf16 grouped GEMM
here, so it is validated by our gates, not by construction. Re-check numerics if it
is ever changed. The code comment says exactly this.

---

## 7. What was verified in this pass

GPU was off-limits (another user's Tensile tuning run held `/dev/kfd`), so:

| check | result |
|---|---|
| `ast.parse` + `compile(..., 'exec')` on both files | pass — no imports executed |
| `pyflakes` (pure AST: undefined names, unused imports, redefinitions) | **clean**, both files |
| no duplicated top-level definitions | 59 top-level nodes, 0 duplicates |
| section order matches the MI355 reference | pass (see §2) |
| jit signature ↔ launch-tuple arity | variable-K 23 = 23, NT 29 = 29 |
| constexpr-tail cache index ↔ first `Constexpr` parameter | `_VK_CONSTEXPR0` = 7 = index 7; `_NT_CONSTEXPR0` = 10 = index 10 |
| upstream symbols exist in the local checkout | `xcd_band_remap_pid`, `make_value_attrs`, `BLOCK_K`, `Mfma16x16x32`, `StoreCBf16`, `G2SLoader`, `emit_for/emit_if_then`, `prims._i64`, `prims._readfirstlane_i32`, `is_gfx1250`, `BackendType.FLYDSL` — all present |
| `xcd_band_remap_pid` ≡ our `_xcd_band_remap` | **0 disagreements over 140 016 points**; ours is a permutation in all of them (pure-Python model, no torch) |

**Not verified — no compile, no launch, no benchmark.** In particular: nothing
confirms the merged file compiles, and the changes in §8 marked **[RE-RUN]** alter
behaviour.

---

## 8. Pre-submit checklist

### Must do before opening the PR

1. **[RE-RUN] Compile all three entry points.** Never compiled in merged form.
   `flyc.compile()` launches by default — use `COMPILE_ONLY`.
2. **[RE-RUN] Full correctness regression** (T1 compute / T2 tile-table+rebase /
   T3 TDM two-axis clamp), acceptance `rel_err < 0.01` and no NaN, bf16 noise floor
   0.1407–0.1410 %. **Burn 3 calls, check the 4th** (§6.5).
3. **[RE-RUN] `masked_k` on the variable-K entry — never executed.** New in this
   pass. Test a padded pool where `masked_k[g] < offs[g+1] − offs[g]`, including
   `masked_k[g] % tile_k != 0`, and assert the padded rows contribute nothing.
4. **[RE-RUN] The `b_nt` / NN path** (§4b): correctness with and without `b_nt`,
   the warning fires once, and the shape assert catches `b` passed as `b_nt` when
   `N ≠ K`.
5. **[RE-RUN] Provenance identity fix.** `build_m_tile_map` now widens to int64
   internally and keys provenance on the *caller's* tensor. Previously, a non-int64
   `group_offs` made a cached `m_tiles` fail its own check on the next call.
   Test the reuse path with `group_offs` as both int32 and int64.
6. **Re-benchmark** the 24 delivery rows × {fwd, dgrad, wgrad} and confirm the
   consolidation changed nothing. Same-session interleaved, sclk pinned — the tile
   deltas here are 1–10 % and cross-session noise swamps them.
7. **Confirm the flydsl version floor.** Requires ≥ 0.3.0 for `rocdl.WMMA`,
   `rocdl.make_tdm_atom`, `flydsl.expr.tdm_ops`, `rocdl.ds_load_tr16_b128`. The
   5-item probe in `REPRO_GUIDE.md` §4.1 is the check. State the floor in
   `pyproject.toml` / CI, and confirm the wheel's compiled backend actually has
   gfx1250 codegen (0.2.4 does not).
8. **Verify the `gemm_helper` symbols on the target branch.** This checkout is
   derived from `main`; the gfx950 development branch adds
   `group_m_tile_decode` / `wave_lane_with_rank` / `S2RLoaderTr16x32Bf16Wide`.
   *Our file imports none of them*, so this only matters if a reviewer asks for the
   §4 reuse candidates.

### Integration

9. **Land the `grouped_gemm_impl.py` backend registration** from
   the local integration branch (`GroupedGEMMFlyDSLBackend`,
   `GroupedGEMMVariableKFlyDSLBackend`, `_prefer_flydsl_gfx1250`), updating the
   import path to the merged module. Two renames to apply:
   `wgrad_tn` → `grouped_gemm_bf16_variable_k_flydsl_kernel`,
   `wgrad_tn_ok` → `grouped_gemm_bf16_variable_k_supported` (the old name is kept
   as an alias, so this can be deferred).
10. **CI.** The kernels need a gfx1250 runner; if none exists, gate the tests on
    `is_gfx1250()` and add a **CPU-side** test of the host helpers
    (`m_tile_upper_bound`, `build_m_tile_map`, `build_m_tile_table`,
    `build_expert_table`, `check_prebuilt`) — all pure torch, all runnable on CPU,
    and currently untested. `build_m_tile_map` vs `build_m_tile_table` equivalence
    is a good property test.
11. **Licence header.** Apache-2.0 `###` block matching the gfx950 file; confirm
    the 2026 date and the FlyDSL provenance lines are what upstream wants.

### Nice to have

12. Sweep `GROUP_M` on the NN path — the gfx950 weight-slab heuristic (8 vs 4) was
    **not** re-measured, so it is pinned at 16 (see the code comment).
13. Confirm the **MI455X XCD count** and re-measure `num_xcd` / `xcd_band`. Off
    today purely from not knowing.
14. Reuse `xcd_band_remap_pid` / `_readfirstlane_i32` once compilation is green (§4).
15. Build a real NN tile on `ds_load_tr16_b128` and remove the dgrad weight
    transpose entirely (§4b) — the single largest remaining structural win.
16. Root-cause the gpt-oss fc2 first-call corruption (§6.5). It is currently papered
    over by a warm-up convention, which is not a fix.

---

## 9. Open questions for the reviewer

1. **Should the pre-transposed wgrad be re-added** under an unambiguous name for
   callers that already hold transposed activations? Dropped here to keep one
   calibre upstream (§4a).
2. **Is a per-call weight transpose acceptable as the NN default**, or should the
   NN entry raise without `b_nt`? Correctness-first was chosen; the integration
   branch's measured view is that transpose-per-call usually loses to Triton (§4b).
3. **Do the two fitted `_pick_config` thresholds belong upstream at all**, given
   they were fitted on 4 and 10 measured points respectively and one has no
   mechanism? They are worth 9–42 % where they fire. The alternative is shipping
   only the derived rules and losing that.
4. **Where should dispatch live long-term** — the backend registry alone, or also
   the flydsl-level factory in `grouped_gemm_bf16_dispatch.py` (§3)?
