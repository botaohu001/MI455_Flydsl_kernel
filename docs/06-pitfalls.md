# 6. Pitfalls

Things that cost real time, grouped by where they bite. Several are the kind
that produce a **plausible wrong answer** rather than an error, and those are
marked ⚠️.

---

## 6.1 Environment and versions

### The flydsl version floor is 0.2.4, not the 0.3.0 the header claims

The kernel's module docstring used to say "Requires flydsl >= 0.3.0". That was
**an assumption, never verified**, and it is wrong.

**[MEASURED]** flydsl **0.2.4** compiles and runs this kernel on gfx1250. All
four surfaces it needs — `rocdl.WMMA`, `rocdl.make_tdm_atom`,
`flydsl.expr.tdm_ops`, `rocdl.ds_load_tr16_b128` — are present, and the whole
delivery matrix is correct to the bf16 noise floor. 0.3.2 also works.

Two reasons this is worth more than a version-string correction:

1. **A packaging note said the opposite.** The Primus-Turbo `setup.py` pins
   `flydsl==0.2.4` and skips installing it for gfx1250 builds, commenting that
   "Triton 3.7.0 and flydsl 0.2.4 does not support gfx1250". That comment is
   about the *Triton* side; for this kernel 0.2.4 is fine. An unverified claim
   in a comment propagated into a module header and then into three planning
   documents.
2. **Requiring 0.3.x actively breaks the surrounding project**, next item.

**Lesson: a version floor is a measurement, not a declaration.** The probe that
settles it takes one minute and no GPU — `probes/probe_flydsl_symbols.py`.

### flydsl 0.3.x deletes `flydsl.expr.buffer_ops`, and that is not a rename

`buffer_load` moved into `flydsl/expr/rocdl/__init__.py`, but `buffer_store`,
`create_buffer_resource` and `extract_base_index` are **gone** — the whole SRD
buffer-resource idiom was retired in favour of TDM. 0.3.0, 0.3.1 and 0.3.2 were
all checked; **none ships a compatibility shim**.

Consequences in a Primus-Turbo tree:

- **27 files under `primus_turbo/flydsl/` import it**, including the **gfx950**
  grouped-GEMM kernel. So on 0.3.x the gfx950 kernel is unavailable too, and a
  gfx950-vs-gfx1250 comparison needs two environments regardless.
- **12 modules under `primus_turbo/pytorch/kernels/` import
  `primus_turbo.flydsl.*` eagerly at module scope**, and every one is reachable
  from `import primus_turbo.pytorch`. So installing a 0.3.x flydsl did not
  degrade to "that kernel is unavailable" — it made **the entire package
  unimportable**:

  ```
  primus_turbo.pytorch
    -> modules.attention -> ops.attention.flash_attn_interface
    -> kernels.attention.attention_flydsl_impl -> flydsl.attention.flash_attn_bwd
  ImportError: cannot import name 'buffer_ops' from 'flydsl.expr'
  ```

The fix is to defer those 12 imports to the call that needs them, turning a
capability `ImportError` into a named `RuntimeError`. Since **0.2.4 runs this
kernel**, that work is no longer a blocker for *this* kernel — but it is still
the right change, and it is why the standalone dispatch path exists.

**This kernel imports no `primus_turbo.*` module at all** (it reads
`gcnArchName` itself rather than using `is_gfx1250()`), and it never touches
`buffer_ops`. That is deliberate and worth preserving in any port.

### ⚠️ The repository test suite gives gfx1250 zero coverage

`tests/conftest.py` blanket-skips **every** test when the device is gfx1250. All
**223,828 collected tests skip.** Identically before and after a change.

That is a clean "no regression introduced" signal and **nothing more**. It is not
evidence that anything runs. A green run here means the suite did not execute.

**Every correctness claim in this repository comes from purpose-built harnesses**
(`benchmarks/check_full.py`, `probes/`), not from the project's test suite. If
you add a gfx1250 runner, the host-side helpers (`m_tile_upper_bound`,
`build_m_tile_map`, `build_m_tile_table`, `build_expert_table`,
`check_prebuilt`) are pure torch, CPU-runnable, and currently have **zero**
coverage; `build_m_tile_map` vs `build_m_tile_table` equivalence is a good
property test.

### Container and build notes

- The build must use `GPU_ARCHS=gfx1250` **alone**. Mixing gfx1250 with
  gfx942/gfx950 in one build disables turbo/CK for the whole build.
- `docker run --group-add render` **fails** on the ROCm images used here — they
  have no `render` group. Pass the host GID numerically.
- The build writes **root-owned** files into a mounted repo (`build/`,
  `*.so`, `_version.py`, `_build_info.py`). `chown` them back or host-side
  tooling starts complaining.
- `bench_grouped_gemm_turbo.py` **block-buffers stdout**. Pass
  `PYTHONUNBUFFERED=1` when redirecting or you see nothing for many minutes.

---

## 6.2 API and integration gates

### ⚠️ Positional arguments diverge from gfx950 — keywords do not

Every gfx950 keyword exists with the same spelling on gfx1250, so a
keyword-only caller is seamless. **Positional callers are not:**

| entry | positions aligned through | first divergence |
|---|---|---|
| `..._nn_flydsl_kernel` (dgrad) | **all the way to `cap_cu`** ✓ | — |
| `..._nt_flydsl_kernel` (fwd) | index 5 | index **6**: gfx950 `GROUP_M` vs gfx1250 `BLOCK_K` |
| `..._variable_k_flydsl_kernel` (wgrad) | index 6 | index **7**: gfx950 `num_xcd` vs gfx1250 `BLOCK_K` |

A bring-up script calling `nt_kernel(a, b, offs, torch.bfloat16, 256, 256, 4)`
means `GROUP_M=4` on gfx950 and `BLOCK_K=4` on gfx1250 → `ValueError: tile_k=4
needs at least 2 WMMA K-steps`. **Loud, not silent** — but note the asymmetry:
NN preserved the gfx950 order and NT did not, in the same file. Worth fixing
upstream by moving NT's new knobs after `cap_cu`.

### ⚠️ `trans_c=True` and `cap_cu != 0` raise — they do not fall back

Both are `NotImplementedError`, confirmed **[MEASURED]**. This matters because
widening a backend's arch gate from `is_gfx950()` is **not sufficient on its
own**. Five things break immediately:

| # | what | trigger | result |
|---|---|---|---|
| 1 | `execute` passes `cap_cu=` unconditionally | `num_cu` set — the existing test parametrises `[0, 16, 32]` | raises, **does not** fall back to Triton |
| 2 | the import path is hardcoded to the gfx950 module | any call | `ImportError` under flydsl 0.3.x |
| 3 | `can_handle` has no `K % tile_k` check | `K % 64 != 0` | `AssertionError` |
| 4 | variable-K passes `trans_c=` unconditionally | forward `trans_b=True` → autograd sets `trans_c=True` | raises |
| 5 | no `grouped_gemm_bf16_variable_k_supported` check | `OUT_M` or `OUT_N` below the tile | `AssertionError` |

**The dispatcher's job is to decline, not to discover.** Add the negative
conditions to `can_handle` so unsupported combinations fall back; a pinned
backend that declines in `can_handle` raises `ValueError` by design, so tests
that pin a backend need matching skips.

`trans_c` specifically does **not** need kernel work: `(AᵀB)ᵀ = BᵀA`, so
swapping the operands gives the layout `trans_c=True` wants at **zero cost** —
which is what the CK and Triton variable-K backends already do.

### ⚠️ `N == K` defeats the `b_nt` shape assertion

The NN entry asserts `b_nt.shape == (G, N, K)` to catch a caller passing `b`
itself. **When `N == K` that assertion cannot distinguish them**, and it
computes garbage of exactly the right shape.

This is not hypothetical: **gpt-oss fc2 is `N = K = 2880`**, a real production
MoE shape, three rows of the delivery matrix. The assertion message calls the
case out. The native NN path removes the exposure by not needing `b_nt` at all.

### `MAX_G = 64` is a gfx950 measurement and does not transfer

The cap comes from the gfx950 MFMA kernel ("clean through G=65, wrong past it;
G=80 and G=96 both fail"). **[MEASURED] on gfx1250, G = 32 / 48 / 64 / 65 / 80 /
96 / 128 / 160 all PASS on all three operators**, `rel_fro` 1.7e-3 throughout —
including the two values gfx950 fails at. Consistent with the structure:
`_decode_m_tile`'s binary search sizes itself from G. The cap can be relaxed,
with data.

### `tile_n = 192` is unbuildable on any transposing stage

TDM's `pad_interval` must be a power of two, and the transposed B stage's row
width is `tile_n * 2`. flydsl reports `padInterval must be a power of two (in
elements), got 384`. Applies to wgrad as well, which is why
`_pick_variable_k_config` has no 192 branch — and there it **aborts inside MLIR
rather than raising cleanly**.

---

## 6.3 Numerics

### ⚠️ `torch.optim.AdamW(fused=True)` does not bump `param._version`

**[MEASURED]** on torch 2.11.0+rocm7.14. Neither do `p.data.copy_()` or
`p.data.add_()`. Any cache keyed on `_version` is therefore **silently stale**
after a fused optimizer step: reproduced end to end at **9.99e-02 relative
error** in dgrad, no exception, no NaN, plausible-looking gradients.

Full table of which write paths do and do not bump it:
`docs/02-dgrad-problem.md` §2.3.

### ⚠️ `ds_load_tr16_b128` degrades silently when misaligned

Given a non-16-byte-aligned address it does not fault — it becomes an ordinary
non-transposing 128-bit load. Right shape, wrong numbers.

This is why `N % 8 == 0` is a **hard gate** in
`nn_native_unsupported_reason()`, not a performance hint, and why the lane
semantics were measured rather than derived. **Guessing produces an answer that
looks correct.**

### Device fp64 is not a usable reference on this part

**[MEASURED]** a device fp64 matmul used as the numerical reference was **wrong
11 times out of 12**. References must be **fp32, judged host-side in float64**.
Every correctness number in this repository follows that rule.

### Know your noise floor before you pick a tolerance

`rel_fro` lands at **1.655e-3 – 1.663e-3** on every passing point, six times
below the 1e-2 threshold. That number is **the cost of storing the result as
bf16, not the kernel's arithmetic error.** On one point, three ways of measuring
it agree to five significant figures:

| comparison | `rel_fro` |
|---|---|
| kernel's bf16 output vs fp32 reference | 1.6561e-03 |
| the fp32 reference **quantised to bf16** vs itself | 1.6561e-03 |
| torch's own bf16 grouped matmul vs fp32 reference | 1.6561e-03 |
| kernel vs torch's bf16 matmul | **3.3606e-05** |

The kernel's own arithmetic error is the last row — **49× smaller** than the
floor. Without that decomposition, 1.66e-3 looks like kernel error and invites
tuning a tolerance instead of understanding it.

### gpt-oss fc2 first-call corruption: not reproduced, not closed

The reference kernel documents that `N == K == 2880` dgrad returns corrupt
results on the **first 1–2 calls** of a fresh process (once 7 NaNs, once amax
3.47e36), stable from the 3rd call on, root cause not found.

**[MEASURED] here: not reproduced.** Three `avg_m` values, fresh processes, that
point the first kernel launched, 8 consecutive calls each — all bitwise stable,
zero NaN.

**That is "not reproduced", not "fixed".** The burn-3-calls-check-the-4th
convention was kept; it costs nothing and the root cause is still unknown.

### The TDM traps, restated

All three are in `docs/01-architecture.md` §1.4 with evidence. In short:
extents are measured from the copy's `imm_offset` and not the descriptor base;
a **dim-1 extent bounds a load's data but not its addressing** (page fault, not
a clamp); and the outstanding-DMA budget is **per wave, not per workgroup**
(counting it wrong makes `tensor_wait` a no-op and produced 71 % NaN output).

---

## 6.4 Measurement methodology

### ⚠️ The calibre trap — the biggest source of wrong conclusions here

Twice in this project, a comparison was nearly made between two things measuring
different work.

**wgrad.** An earlier pre-transposed wgrad had a genuinely faster GEMM — the
shipped kernel is 0.79–0.81× of it — but it consumes pre-transposed activations.
Those two transposes measured **57–75 % of end-to-end wgrad time** (the design
notes had assumed 5–15 %, a 4–5× underestimate). Counting them, the shipped
kernel wins **1.98–3.45×**. Quoting the pre-transposed GEMM number with the
transposes outside the timer inflates it by **16.3 %** (median over 524 points).
The pre-transposed kernel was therefore dropped entirely: **one calibre
upstream, so the two cannot be mixed.**

**dgrad.** A set of reference numbers never stated whether the weight transpose
was inside the timer. It matters by **2.33× to 11.41× (median 3.87×)** — not by
the ~16 % the wgrad case cost. Three independent lines of evidence settled it as
the hoisted calibre; a fourth would not have been needed had one sentence been
written down.

**The rule: state the calibre next to every number.** This repository's tables
name theirs in the column header.

### Interleave, or clock drift becomes your result

Clocks were **not pinned** (the baselines predate the decision, and pinning only
one side invalidates the comparison). What makes the ratios trustworthy instead:

- competing implementations measured **in the same process, interleaved repeat
  by repeat**, so a clock excursion lands on both;
- `sclk` sampled at every timed point and reported alongside it;
- median of 5+ repeats, each a timed loop sized to ~40–50 ms, with `cv`
  reported. **All 72 delivery points came in at cv < 2 %** (max 0.85 %).

**Do not compare absolute numbers across the three sections of the performance
tables** — fwd/wgrad and dgrad were measured in different rounds at different
clock ranges. Within a section, and within the four-calibre comparison,
everything is same-session.

### A cross-session number and a same-session ratio are different claims

The native NN pipeline's headline can be stated two ways, both true:

- mean throughput **1415.5 TF/s** vs a historical cross-session figure of 1355 —
  **+4.5 %**;
- like-for-like, same session, interleaved: **0.979** — **2.1 % slower**.

The second is the real one for "is the native GEMM faster than the NT GEMM". The
first is a comparison across a clock drift. Reporting only the first would be
misleading; both appear in `docs/07-performance.md`.

### Verify a statistics change does not move the numbers

Switching from `mean-of-timeit` to `median-of-repeats` could have manufactured
a speedup. It was checked: re-measuring the same Triton baseline under the new
statistics gives a ratio of **1.0000 over 72 points** (range 0.966–1.047). So
the reported speedups are not an artifact of the statistics.

---

## 6.5 Baseline surprises on this part

Useful if you are choosing something to compare against.

- **Triton is the only sane end-to-end baseline.** 360/360 correctness PASS on
  the full sweep.
- **CK does not work at all** on gfx1250: 312/360 ERROR. The 48 "PASS" rows are
  all `B=1`, which the autograd layer routes to a dense hipBLASLt path — CK never
  ran. The script's printed "Average Forward TFLOPS: 243.55" is 48 dense numbers
  diluted by 312 zeros. **Ignore it.**
- **hipBLASLt is forward-only.** It holds the single best forward number in this
  study, but its grouped **NN and variable-K paths run at ~64 TF/s / 1.3 % MFU**
  — 19–21× behind. It is a forward-pass ceiling, not an end-to-end competitor.
- **hipBLASLt is also impractically slow to benchmark**: a 360-case sweep reached
  case 46 in ~25 minutes at 100 % GPU with 322 threads, consistent with no tuned
  gfx1250 solutions and a wide per-shape solution search. Not hung — just not
  usable for a full table.
- In the `B=1` dense fallback, **backward runs at ~70 TF/s against 1600–2400
  TF/s forward.** Unrelated to grouped GEMM, but somebody should look at it.
