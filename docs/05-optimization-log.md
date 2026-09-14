# 5. Optimization log — everything tried, including what failed

Every entry carries measured data. Entries with **no established mechanism** say
so; those should be re-measured rather than extrapolated to a new shape, tile or
part.

Four categories:

- [§5.1 Adopted](#51-adopted) — in the shipped kernel
- [§5.2 Rejected after measurement](#52-rejected-after-measurement) — worked, not worth it
- [§5.3 Disproven](#53-disproven-directions-do-not-re-suggest) — tried, made things worse
- [§5.4 Disproven hypotheses](#54-disproven-hypotheses-about-why) — explanations that turned out false

---

## 5.1 Adopted

### `tile_k = 128` when `K % 128 == 0` — the largest single lever

**+6.0 – 10.4 %**, ISA-counted, mechanism understood. Derived, low
extrapolation risk. Applies to fwd, dgrad and wgrad.

Worth knowing for shape planning: the rule is structured
`if K % 128 == 0: tile_k = 128 else: tile_k = 64`, which guarantees the gate
passes for any `K % 64 == 0`. gpt-oss's `K = 2880` is not divisible by 128 and
falls back to the 64-deep tile. **In the dgrad direction that same layer has
`K = 5760 = 45 × 128`, which *is* divisible** — so one layer can legitimately
run `tile_k=64` forward and `tile_k=128` backward. Not a bug.

### 2×2 warp grid (4 waves)

**geomean 1.0367 over 259 paired points.** Derived, mechanism understood, low
risk. Note this does **not** carry over to wgrad — see below.

### `GROUP_M = 16`, not gfx950's 4

**+0.8 – 2.0 % over 4**, and **4 was the worst of {1, 4, 8, 16}** on deepseek
fc1. gfx950 picks between 8 and 4 on a weight-slab size heuristic; that
heuristic was **not re-measured here**, so rather than invent a scaled-up
threshold the value is pinned at 16 unconditionally. Sweeping it on the NN path
is an open item.

### `avg_m <= 128` → 128×128 tile

**1.09× – 1.36×** over the 256 tile, on all four DeepSeek-V3 `avg_m=128` points.
Derived: a 256-row tile is half empty at `avg_m=128`.

### `m_warp = 4` for wgrad (not the NT kernel's 2)

**The 4-wave 2×2 grid does not carry over to variable-K.** Flipping to `m_warp=2`
measured **0.976 – 0.991** on all six rows tried, so `m_warp=4, n_warp=2` stays.
All 24 wgrad delivery points run `BM256/BN256/BK128/mw4/nw2/nb2`.

### `avg_m` deliberately excluded from wgrad tile selection

In wgrad, `avg_m` is the **reduction** dimension, not an output dimension, so
shrinking the tile only multiplies output traffic — by 16×. **[MEASURED]** over
the 12 delivery rows with `avg_m ≤ 512`, the `256×256×128` tile **wins 11 and
ties 1**.

### Pre-bound `CallState` launch path

Caching the pre-bound launch state, keyed on the constexpr tail, **removed
47.2 µs of per-call CPU**.

### In-kernel expert search instead of a host tile table

`build_m_tile_map` replaces a host-built per-tile table that cost a constant
**~92 µs/call — 50.3 % of wall time at avg_m=2048.**

### LDS row-stride residue for the transposed B stage — worth 6.5 %

**[MEASURED], mechanism NOT established.** Sweeping the pad 16→160 in steps of
16, on six shapes, always against NT on an identical tile:

| `LDS_B_ROW % 64` | ratio vs NT |
|---|---|
| **== 32** (pads 32, 96, 160) | **0.986 – 0.990** |
| anything else (16, 48, 64, 80, 112) | 0.928 – 0.933 |

**6.5 %, reproducible on every shape.** This is the entire difference between
"the native NN pipeline costs 7 % over NT" and "it costs 1 %". The upstream
wgrad default `LDS_PAD = 16` happens to land on the **wrong** side in this
orientation, so `_nn_b_pad()` picks the smallest pad in the winning residue
class (32, for `tile_n ∈ {128, 256}`).

**What is not established is why 32 mod 64.** A 16-byte-granular, 32-bank model
predicts pad=16 conflict-free and pad=32 four-way conflicted — **exactly
backwards**, so that model is wrong for this instruction. The rule is therefore
stated as what it is, a measured residue, and is recomputed rather than
extrapolated for a new `tile_n`. (Pads large enough to halve LDS occupancy —
128/144/160 at `tile_n=128` — fall off again; *that* part is explicable, which is
why the function returns the smallest member of the class.)

### Widen `tile_n` 128 → 256 when `tile_k == 64` and `avg_m > 128`

**[MEASURED], mechanism NOT established.** 54 synthetic cells whose reduction
length forces `tile_k=64`, always against NT on an identical tile:

| `tile_n` | native/NT geomean | cells at or above parity |
|---|--:|---|
| 128 | 0.896 | 10/54 |
| **256** | **1.103** | **44/54** |

`tile_n=128` with `tile_k=128` is fine (0.96–1.05), so **the combination is bad,
not the tile width**. The `avg_m > 128` guard is measured too: at `avg_m=128` the
narrow tile is already at parity (0.945–1.135) and widening costs 0.67–0.85×.

Fires on **one** delivery row (gpt-oss fc2 dgrad @ avg_m=512, worth 1.26×),
because it needs a reduction length indivisible by 128 and 2880 is the only such
width in the matrix.

### The tiled Triton transpose — kept as a benchmark baseline

Not in the kernel any more (the native NN pipeline made it unnecessary), but it
stands on its own: **11.0× – 14.9× faster than `make_nn_weight_nt`**, bit-exact,
~20 lines.

| implementation | bandwidth |
|---|--:|
| `b.transpose(1,2).contiguous()` | 1.07 – 1.39 TB/s |
| a plain `torch` copy of the same bytes | 7.05 – 11.1 TB/s |
| **tiled Triton transpose** | **15.5 – 17.1 TB/s** |

HBM4 peak is ~19.6 TB/s: the helper sits at 6–7 % of peak, the replacement at
~82 %. **If you are stuck on a part with no transposing load, this is still the
right fix.** `benchmarks/bench_transpose.py`.

---

## 5.2 Rejected after measurement

### A transposed-weight cache — **do not build this**

The prototype works: 38 assertions, 0 failures. It should still not ship.

| | |
|---|---|
| memory | **+141 GiB (32.6 % of HBM) for qwen3-235b, +152 GiB (35.2 %) for deepseek-v3** at EP=8 |
| shrinkable? | **no.** Backward touches each layer once per micro-batch, so a bounded cache has ~0 hit rate. All-or-nothing by construction. |
| benefit once the transpose is fast | **+7 %** geomean on dgrad only (1.099 → 1.171 over 42 cells) |
| benefit at `avg_m ≥ 1536` | **none** — all 24 such cells have N\* < 1, the transpose already pays for itself in one call |
| **correctness** | **`AdamW(fused=True).step()` does not bump `param._version`.** A `_version`-keyed cache then serves the previous step's transpose: **9.99e-02 relative error**, no exception, no NaN, plausible-looking gradients. Reproduced end to end. |

`p.data.copy_()` and `p.data.add_()` are equally silent. Full table in
`docs/02-dgrad-problem.md` §2.3. A hook-based invalidation can be made safe, but
it is a framework contract a kernel cannot enforce, and it fails open.

### `global_load_tr16_b128` — measured working, not adopted

**[MEASURED]** available on gfx1250, lane semantics identical to the LDS
version, and it transposes correctly even at **non-16-byte-aligned** strides
(9 and 12 elements), which the LDS version does not. It could feed B straight
from global memory to VGPRs, no LDS at all, any `N`.

Not adopted because the remaining headroom was ~2 % once the native NN pipeline
reached 0.979 of the hoisted calibre, against certain costs: loses the TDM async
pipeline, loses hardware OOB clamp (ragged N needs hand-written masks), demotes
B reuse from LDS to L1/L2, and adds VGPR pressure that already caused spills in
wgrad at `frag_pipeline=1`.

**This is a headroom judgement, not a measurement against it.** The scenario
that motivated it — small `avg_m` memory-bound dgrad — is exactly where the
native pipeline already reaches or beats the hoisted calibre (deepseek fc2 @128
= **1.031**, fc1 @128 = 0.978). If anyone picks this up, it is the next
experiment. Details in `docs/03-isa-investigation.md` §Route 5.

### `num_xcd = 8` — kept at 1

`amd-smi metric -c` reports **8 gfx clock domains** (`gfx_0_clk` … `gfx_7_clk`),
which with 256 CU is 32 CU per XCD and matches MI355X's 8. That is **evidence,
not proof** — a clock-domain count need not equal the XCD count.

Measured `num_xcd=8, xcd_band=32` against the default, interleaved, two rounds
per side:

| row | op | xcd=1 | xcd=8 | ratio | |
|---|---|--:|--:|--:|---|
| gpt-oss fc1 | fwd | 0.0782 | 0.0718 | **0.918** | 8.2 % faster |
| gpt-oss fc1 | wgrad | 0.0689 | 0.0698 | 1.013 | slower |
| qwen3-30b fc1 | fwd | 0.1110 | 0.1096 | 0.988 | 1.2 % faster |
| qwen3-30b fc1 | wgrad | 0.1068 | 0.1120 | **1.049** | 4.9 % slower |
| qwen3-235b fc1 | fwd | 1.1380 | 1.1248 | 0.989 | 1.2 % faster |
| qwen3-235b fc1 | wgrad | 1.2697 | 1.2735 | 1.003 | flat |
| deepseek-v3 fc1 | fwd | 0.2902 | 0.2906 | 1.001 | flat |
| deepseek-v3 fc1 | wgrad | 0.4115 | 0.3974 | 0.966 | 3.4 % faster |

**Mixed: fwd gains a little, wgrad mostly loses. Not a reason to change the
default.** The +8.2 % outlier is on the shortest point (0.078 ms) with only two
rounds per side — **a lead worth a full sweep, not a conclusion.**

### `b_imm_walk` — no effect, so the safer form was kept

Building B's descriptor once and walking the reduction axis with `imm_offset`
instead of rebuilding per k-tile: **0.985 vs 0.990 — noise.** The validated
per-k-tile rebuild was kept rather than trading it for a form that is easier to
get wrong around extents, for zero measured gain.

### `tile_n = 192` — unavailable, and that costs one delivery point

Not a choice. The B stage row width `tile_n*2` is the TDM `pad_interval`, which
hardware requires to be a power of two; flydsl raises
`padInterval must be a power of two (in elements), got 384`. So the native NN
path cannot use the 192 tile at all and drops back to 256×256×64.

This is the whole of the worst native-vs-hoist point (**gpt-oss fc2 dgrad @
avg_m=2048, 0.872**). Worth noting what is being given up: the 192 rule is one
that `_pick_config`'s own docstring flags as **fitted, mechanism NOT established,
"the highest extrapolation risk in this function."** The tile being lost was
itself a guess.

---

## 5.3 Disproven directions — do not re-suggest

Each of these was implemented and measured. All made things worse.

| direction | measured |
|---|---|
| host-side index-table build | cheaper in isolation (56 vs 92 µs) but **−31 % end to end** — the D2H sync kills inter-call overlap |
| `inkernel_scan` (per-workgroup prefix scan) | correct, **−15.2 % fwd / −53.8 % dgrad** |
| `half_n_skip` (skip dead columns) | **−1.3 to −1.7 %** on all four gpt-oss points — TDM never fetched them anyway |
| more waves / higher occupancy | 16 waves × 1 WG vs 8 × 2 WG, same tile: **0.763×** |
| 2 workgroups per CU co-residency | **−7.0 %** |
| pad away the raggedness | 3 exactly-dividing wide tiles all lost to a ragged 256×256 (**0.921 / 0.958 / 0.944**) |
| device fp64 matmul as a numerical reference | **wrong 11 times in 12.** References must be fp32, judged host-side. |
| dgrad as a per-group `G=1` variable-K call (transpose the activations instead) | bitwise correct, **1.5× – 10.5× slower** |

On `amdgpu-expert-scheduling-mode`: it is **on** for all kernels here and all
correctness gates pass with it. But the analogous Triton pass was found to
**silently miscompile** bf16 grouped GEMM on this part, so it is validated by
those gates and **not by construction**. Re-check numerics if you touch it.

---

## 5.4 Disproven hypotheses (about *why*)

Explanations that sounded right and are not. These are worth as much as the
optimizations — they stop the next person spending a day on the same story.

### Wave quantisation does **not** explain the small-`avg_m` losses

The kernel "launches one workgroup per output tile with no persistent loop", so
a tile count just past a wave boundary should cost a full wave. Tested against
the cells where flydsl's GEMM loses to Triton:

**Spearman(wave efficiency, speedup) = −0.55 — the wrong sign** — and **four of
the five losing cells sit at wave efficiency 1.00**. Not the mechanism.
`results/dgrad_study/wave_quant.txt`.

**The real cause of the small-`avg_m` losses is still unknown.** It predates the
NN work, it is unchanged by it, and it is the single most useful open question
in this repository.

### `N*` is **not** predictable from weight-bytes / GEMM-FLOP

The proposed criterion dies to algebra:

```
weight bytes / GEMM FLOP = (G·N·K·2) / (2·G·avg_m·N·K) = 1 / avg_m
```

identically — no dependence on G, N or K. Verified numerically: `ratio × avg_m
== 1.0` for all 24 cells. deepseek-v3 only *looks* worse because the study gives
it `avg_m ∈ {128,256,512}` while gpt-oss gets `{512,1024,2048}`; at equal
`avg_m` the ratios are identical.

And it does not order `N*`: Spearman = 0.744, but at the single value
`ratio = 1.95e-03` (`avg_m = 512`) `N*` spans 5.27 to ∞. Because

```
N* = 2 / ( BW_transpose · avg_m · (1/T_triton − 1/T_flydsl) )
```

— the `1/avg_m` part is the ratio, the throughput-gap part is not, and the
throughput gap is what decides. Spearman(flydsl/Triton speedup, N\*) = **−0.827**,
stronger than the ratio.

What the ratio *does* give cleanly: the **value of caching**,
`t_transpose / t_gemm`, is proportional to `1/avg_m` — 0.73–0.80 at `avg_m=128`,
0.21–0.35 at 512, 0.09–0.12 at 2048.

### Occupancy does **not** explain the 1536 threshold in `_pick_config`

A confirmed negative, not an untested guess. Over 26 `avg_m` points the wide
tile is **always** `wg_per_cu = 1` and the narrow tile **always** 2, with VGPR
constant. Neither is a function of `avg_m`, so neither can produce a reversal at
one point. M-tile quantisation waste is excluded too (`avg_m=1280` has none and
still loses; `avg_m=1152` has 10 % and is the best point in the table at 1.192).
An HBM-bytes model predicts 0.71 at `avg_m=1152` against a measured 1.192 — off
by 68 %.

What remains unexplained is a **reproducible sawtooth** in the wide tile's
throughput (980 / 737 / 802 / 868 / 924 TF/s at `avg_m` 1024 / 1152 / 1280 /
1408 / 1536 on fc2) peaking exactly where the narrow tile loses.

### The linear transpose-amortisation model breaks exactly where you need it

`t_eff(N) = t_gemm + t_transpose/N` holds to within a median 0.92 % **with the
slow transpose**, and breaks at **N = 1 by up to +35 % with the fast one** —
a fixed ~5 µs launch boundary, invisible at N ≥ 4. N = 1 is the per-call case,
i.e. precisely the decision the model was being used to make. Details in
`docs/02-dgrad-problem.md` §2.5.

### Register pressure does **not** explain the native NN pipeline's 2.1 %

Answered from the generated assembly, not from a hypothesis: VGPR 790 vs 791,
zero spill on both, zero scratch on both, identical WMMA and LDS-read counts,
and the native path emits **77 fewer instructions**. The residue can only be the
per-instruction cost of the transposing read. Table in
`docs/04-native-nn-pipeline.md` §4.5.

---

## 5.5 Open leads, in the order worth trying

1. **Why does flydsl's GEMM lose to Triton at small `avg_m`?** 4 of 24 dgrad
   cells, unexplained, wave quantisation excluded. Biggest open question here.
2. **`global_load_tr16_b128` as a second NN variant** — ~2 % of headroom, real
   costs, never measured in a GEMM.
3. **A full `num_xcd` sweep** once the MI455X XCD count is confirmed. The
   current evidence is 8 clock domains and one 8.2 % outlier on the shortest
   point.
4. **Mechanism for the `b_pad` mod-64 rule.** It is worth 6.5 % and the obvious
   bank model predicts the opposite, so something about the LDS crossbar is not
   understood.
5. **Sweep `GROUP_M` on the NN path.** Pinned at 16 from a forward-pass
   measurement; never re-measured for dgrad.
6. **Root-cause the gpt-oss fc2 first-call corruption.** Not reproduced here, but
   "not reproduced" is not "fixed". Currently papered over by a warm-up
   convention.
