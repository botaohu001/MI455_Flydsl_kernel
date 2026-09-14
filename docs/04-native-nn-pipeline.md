# 4. The native NN pipeline

What was built, how it was verified, and where the remaining 2.1 % went.

**Result:** dgrad reads `b[G,K,N]` in place. No transposed weight copy anywhere.
Correctness is **bitwise identical** to the hoisted-transpose calibre on all 48
rows, and fwd/wgrad are **bitwise identical** to the pre-change kernel.

---

## 4.1 The shape of the change

One tile body, one boolean — the same organisation gfx950 uses (`a_transpose`),
here called `b_lds_transpose`. **Not a third kernel.**

```
                     NT (fwd)              NN native (dgrad)        wgrad (variable-K)
  A operand      ds_read_b128           ds_read_b128  ← same      ds_load_tr16_b128
  B operand      ds_read_b128           ds_load_tr16_b128         ds_load_tr16_b128
  B LDS stage    [tile_n][tile_k]       [tile_k][tile_n]          [tile_k][out_cols]
```

The NN pipeline is the first one to **mix** the two loaders in a single tile
body: wgrad transposes both operands, NT transposes neither, NN transposes only
B. That mixing is the one genuinely new thing; everything else is transplanted.

### Line accounting

Whole file: **+499 / −52**, of which **321 non-comment lines added**.

| | lines | where it came from |
|---|--:|---|
| device-side tile body | **125** | all inside `if const_expr(b_lds_transpose):` |
| host side | 196 | new entry path, `_pick_config_nn`, `_nn_b_pad`, `nn_native_unsupported_reason` |
| A operand, `fx.gemm` calls, epilogue, grouped control | **0** | untouched |

Transplanted from wgrad, essentially verbatim:

| piece | wgrad source |
|---|---|
| B LDS stage geometry `[tile_k][tile_n]` + `LDS_B_ROW` | stage setup |
| B descriptor rebuilt per k-tile, row offset folded into base, `imm_offset=0` | `issue()` |
| per-lane transpose-read base (`l8` / `hi8` / `kgrp`) and `_frag` / `_tr` | `b_lane` |
| ragged-N `blk_n_eff` / `n_back` back-off window | the TN over-read fix |

The two hazards those last two rows address are the TDM traps in
`docs/01-architecture.md` §1.4. wgrad had already paid for both **in this tile
orientation**, which is the single biggest reason this was a week and not a
month.

---

## 4.2 Lane semantics: measured first, built second

The ISA investigation flagged the dgrad lane mapping as **[INFERRED]** and said
the derivation chain was short but unverified. Step one of implementation was
`probes/probe_nn_frag.py`, which makes it **[MEASURED]**.

Design of the probe, since the details matter:

- LDS is filled by a **real TDM copy**, not by hand — the thing under test is
  the whole path, not the instruction in isolation.
- Fill values are **bf16 bit patterns** `0x2000 + flat_index`, all normal finite
  numbers. Small-integer fills can pass for the wrong reason once denormal
  flushing or rounding is involved.
- **Two independent criteria.** (a) each lane's 16 elements match the closed-form
  prediction; (b) the same data staged the NT way and read with plain
  `ds_read_b128` must come out **bitwise identical**. Criterion (b) does not
  depend on the derivation being correct, which is the point.

**Result: 4 tile geometries (32×64 / 64×128 / 128×64 / 64×64), 44 fragments ×
32 lanes × 16 elements, all bitwise correct.**

```
lane  0: n=[0]   k=[0..7, 16..23]
lane  1: n=[1]   k=[0..7, 16..23]
lane 31: n=[15]  k=[8..15, 24..31]
```

### wgrad's transpose vs dgrad's transpose — the same instruction, measured

**Bit for bit identical behaviour.** `ds_load_tr16_b128` is pure data movement:
it sees 8 lanes each supplying an address to 8 consecutive 16-bit elements, and
it **does not know or care** whether those elements are tokens or reduction
indices.

| | wgrad | dgrad (NN) |
|---|---|---|
| LDS row = | token m (reduction) | reduction k |
| LDS column = | output axis | output axis n |
| row stride | `tile_m*2+pad` / `tile_n*2+pad` | `tile_n*2+pad` |
| what gets transposed | the activation's token axis | the weight's reduction axis |
| **lane mapping** | **identical** | **identical** |
| both operands transposed? | yes | **no** — B only; A stays on plain `ds_read_b128` |

So "wgrad transposes activations, NN transposes weights" is **not a distinction
at the ISA level**. It is a distinction in what the caller means by the two axes,
and that meaning is absent from the generated code.

---

## 4.3 Correctness

`benchmarks/check_full.py` loads **both** the shipped kernel and the pre-change
reference into one process, so "no regression" is a comparison between two
implementations rather than each being re-checked against a reference they could
drift from together.

The numerical reference is an **fp32 per-group matmul, judged host-side in
float64**. Not device fp64: **[MEASURED]** device fp64 matmul on this part was
**wrong 11 times out of 12** as a reference.

**48 rows = 24 shapes × {balanced, imbalanced groups}, all passing:**

| check | result |
|---|---|
| dgrad `rel_fro` vs fp32 reference (4th call) | max **1.6622e-03**, threshold 1e-2 |
| bf16 quantisation floor, same row (`rel_fro(bf16(ref), ref)`) | max **1.6622e-03** |
| dgrad native vs hoisted calibre | **48/48 bitwise identical** (max\|Δ\| = 0) |
| fwd vs the pre-change kernel | **48/48 bitwise identical** |
| wgrad vs the pre-change kernel | **48/48 bitwise identical** |
| NaN / Inf | 0 |
| rows taking the native path | 48/48 |
| call 1 vs call 4 | identical |

Read the first two rows together: they agree to the **last digit**, which means
the entire error is the cost of storing the result as bf16 and **the kernel
contributes no arithmetic error of its own**. That is a stronger statement than
"within tolerance".

Coverage worth calling out explicitly:

- **`N == K`** (gpt-oss fc2, 2880×2880) — the case where a shape assertion cannot
  distinguish `b` from `b_nt`. 6 rows, all pass.
- **imbalanced groups** including an **empty expert (0 rows)** and a 3-row expert.
- **ragged output axis** (`N_out = 2880` against `tile_n = 256`, exercising the
  `n_back` back-off).
- **small M** (`avg_m = 128`) and **non-power-of-two K** (2880).

`probes/smoke_nn.py` additionally covers `G=1`, the minimum `K == N == 256`
shape, and distributions like `lens=[1, 2047, 0, 33, 4096, 129]` — all bitwise
identical.

---

## 4.4 The shape gate

`nn_native_unsupported_reason(N, K, tile_n, tile_k)` returns `None` or a
sentence. A shape that misses **falls back** to materialising the transpose with
a one-shot warning; it does **not** raise, so the API contract is unbroken.

| condition | why |
|---|---|
| `K % tile_k == 0` | same constraint the NT path has: the K loop is a compile-time tile count |
| `tile_n` a power of two | the B stage row width `tile_n*2` is the TDM `pad_interval`, which hardware requires to be a power of two |
| **`N % 8 == 0`** | **not a performance guard.** Below this the transpose-read column base is misaligned and the instruction **silently degrades to a plain non-transposing load** — wrong answers that look right. Hard gate. |
| `N >= tile_n` | the ragged back-off window needs a whole tile to retreat into |

All 24 delivery shapes satisfy all four; 48/48 rows took the native path.

---

## 4.5 Where the remaining 2.1 % went

Like-for-like against the hoisted calibre, same process, interleaved point by
point, the native pipeline is **0.979** — 2.1 % slower on the GEMM itself. This
is the number most worth being sceptical about, so it was answered from the
**generated assembly** rather than from a hypothesis.

`benchmarks/dump_stats.py` compiles both paths for one shape (256×256×128,
gpt-oss fc1) and diffs them:

| | NT (hoist) | native NN |
|---|--:|--:|
| VGPR | 791 | **790** |
| VGPR / SGPR spill | 0 / 0 | **0 / 0** |
| scratch | 0 | **0** |
| WMMA instructions | 512 | **512** |
| LDS read instructions | 256 (all `ds_read_b128`) | **256** (128 plain + 128 transposing) |
| VALU | 853 | 846 |
| SALU / wait | 672 | **602** |
| total instructions | 2378 | **2301** |

**Register pressure, spilling and occupancy are all excluded** — the native path
emits *fewer* instructions. What remains can only be the per-instruction cost of
the transposing read itself (LDS crossbar / bank behaviour). Not code bloat, not
occupancy.

Two findings came out of chasing it, and both are in
`docs/05-optimization-log.md` because they are tuning results rather than
pipeline structure:

- **LDS row stride residue is worth 6.5 %** — `LDS_B_ROW % 64 == 32` wins, and
  the upstream default `LDS_PAD = 16` lands on the *wrong* side. Mechanism not
  established; a bank-conflict model predicts the exact opposite.
- **`tile_n=128` with `tile_k=64` is a bad combination** for the transposing
  read (geomean 0.896 over 54 cells), while `tile_n=128` with `tile_k=128` is
  fine. It is the combination, not the tile width.

And one non-finding, recorded so nobody re-tries it: **`b_imm_walk`** (build B's
descriptor once and walk the reduction axis with `imm_offset` instead of
rebuilding per k-tile) made **no measurable difference** — 0.985 vs 0.990, noise.
The validated per-k-tile rebuild was kept rather than trading it for a form that
is easier to get wrong around extents.

---

## 4.6 What is not done

Honest list of the gaps.

1. **`avg_m < 1536` still sometimes loses to Triton**, on 4 of 24 dgrad cells.
   Unrelated to the transpose and unchanged by this work — the same cells lose in
   the hoisted calibre too. Wave quantisation has been **disproven** as the
   mechanism. **The real cause is still unknown.**
2. **The `b_pad` mod-64 rule has no mechanism.** Measurement only.
3. **The `tile_n=128 + tile_k=64` rule has no mechanism.** Measurement only
   (54 cells).
4. **XCD remap is still off** (`num_xcd=1`); the MI455X XCD count remains
   unconfirmed. See `docs/05-optimization-log.md` for the mixed measurement.
5. **`masked_k` was not tested on the NN path** — the NN entry has no such
   parameter.
6. **No transpose caching, and none planned.** The native path structurally
   cannot read a stale weight.
7. **The fwd/wgrad tables predate the final tile-rule change.** Those code paths
   are bitwise unchanged (verified 48/48) and `_pick_config_nn` is only called
   from the NN entry, but the two rounds ran at different clock ranges — so
   **do not compare absolute numbers across the three sections**. Within a
   section, and within the four-calibre table, everything is same-session.
8. **`cap_cu` is still unimplemented** (non-zero raises), matching the
   pre-change kernel.

---

## 4.7 Consequences for a caller

`grouped_gemm_bf16_nn_flydsl_kernel(dout, b, offs)` now needs **no `b_nt` and
materialises nothing**. `b` keeps its `[G, K, N]` meaning and the signature is
unchanged, so an existing caller moves from the bad side to the good side
**without editing a line** — and the
`PRIMUS_TURBO_GFX1250_FLYDSL_GG_TRANSPOSE_B` gate that existed to keep the
per-call transpose switched off can be deleted.

`b_nt` is still accepted, now as a **fast path** rather than a requirement: a
caller already holding an NT-layout copy short-circuits to the NT kernel.

Memory saved, per layer, being a copy the size of the local expert weights:

| model (EP=8) | fc1 | fc2 | saved per layer |
|---|--:|--:|--:|
| gpt-oss-20b | 126.6 MiB | 63.3 MiB | 189.8 MiB |
| qwen3-30b-a3b | 256.0 MiB | 128.0 MiB | 384.0 MiB |
| qwen3-235b-a22b | 1024.0 MiB | 512.0 MiB | 1.50 GiB |
| deepseek-v3 | 1792.0 MiB | 896.0 MiB | **2.62 GiB** |
