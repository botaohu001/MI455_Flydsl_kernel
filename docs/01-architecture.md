# 1. gfx1250 vs gfx950: why the ideas port and the code does not

This document is the answer to "we have a working grouped GEMM on MI355X, how
much of it can we reuse on MI455X?"

The short answer: **the grouped control logic, and nothing below it.** Every
primitive the gfx950 tile body is built from has a gfx1250 counterpart that is
differently shaped, not differently named. A line-by-line port is not possible;
a concept-by-concept port took about 2300 lines.

Evidence markers used throughout this repository:

| marker | meaning |
|---|---|
| **[MEASURED]** | run on an MI455X (gfx1250) in this project |
| **[ISA]** | stated in the published CDNA5 ISA reference (see `NOTICE` for the link) |
| **[LLVM]** | `llvm-mc -mcpu=gfx1250` accepts or rejects the encoding |
| **[FLYDSL]** | present in the flydsl Python surface (version given) |
| **[INFERRED]** | reasoning from the above; **not** measured |

---

## 1.1 The item-by-item table

| concern | gfx950 / MI355X | gfx1250 / MI455X | portable? |
|---|---|---|---|
| wave size | 64 | **32** | no — every lane-indexing expression changes |
| matrix engine | MFMA `Mfma16x16x32` | **WMMA** `rocdl.WMMA(16,16,32)` | no — different instruction family |
| accumulator per lane | `m*n // 64` = 4 × f32 | **8 × f32** (`m*n // 32`) | no — follows from wave32 |
| accumulator storage | AGPR (`agpr_alloc`) | **VGPR only** | no — gfx12 has no AGPRs at all |
| global → LDS | `buffer_load` + SRD | **TDM** engine, async whole-tile DMA | no — different engine |
| address generation | hand-computed lane swizzle | **TDM computes its own addresses** | no — the swizzle code becomes dead |
| ragged / OOB clamp | SRD `num_records` | **TDM `tensor_extents`** (two axes, asymmetric) | no — and the asymmetry is a trap, §1.4 |
| LDS → register, plain | `ds_read_b128` | `ds_read_b128` | **yes** |
| LDS → register, transposing | `ds_read_b64_tr_b16` | **`ds_load_tr16_b128`** | no — **different lane semantics**, §1.3 |
| barrier / fence | `s_barrier` + `lgkmcnt` | **`tdm_ops.tensor_wait` + `gpu.barrier`** | no |
| LDS per CU | 160 KB | **320 KB** | changes every tile budget |
| scheduling controls | `make_value_attrs(waves_per_eu, agpr_alloc, …)` | `compile_hints["llvm_options"]` | no — `agpr_alloc` is meaningless |

What survives: the M-tile table, the per-expert rebasing, the
tile → (expert, block_m, block_n) decode, and the XCD remap. These are integer
arithmetic on the program ID and know nothing about the matrix engine. They are
roughly 60 lines and they are the entire shared surface.

**That is why the two implementations are separate files rather than an
`if arch ==` inside one.** An in-file branch would be two disjoint bodies under
one `def`, and it would drag 2200 lines of gfx9 MFMA/DPP/SRD primitives into the
import graph of a gfx1250-only module. See `kernel/grouped_gemm_bf16_dispatch.py`
for the dispatch that results.

---

## 1.2 The one structural thing that mapped for free

The dense gfx1250 GEMM already clamps a ragged `M` with the TDM descriptor's
dim-0 extent. A grouped GEMM's "the last tile of an expert is short" is *exactly*
that problem. So the per-expert row count is fed straight into that extent:
**no masking code and no second tile class.**

This is the same structural trick the gfx950 version plays with SRD
`num_records`. The mechanism is completely different, the idea is identical —
which is the theme of this whole document.

A consequence worth internalising: `_tail_quad_conds`, the gfx950 quadrant
masking helper, has no counterpart here. It exists because of the 4-quadrant
MFMA accumulator layout, and hardware extents make it unnecessary. **Ported code
that keeps a masking helper it no longer needs is a sign the port was
mechanical.**

---

## 1.3 The transpose read: same job, different lane semantics

Both parts have a hardware LDS transpose read, and it is tempting to treat them
as the same instruction under two names. They are not.

| | gfx950 | gfx1250 |
|---|---|---|
| mnemonic | `ds_read_b64_tr_b16` | `ds_load_tr16_b128` |
| accepted by `llvm-mc -mcpu=gfx1250` | **no** | **yes** `[0x00,0x00,0xf0,0xdb,…]` **[LLVM]** |
| accepted by `llvm-mc -mcpu=gfx950` | **yes** `[0x00,0x00,0xc6,0xd9,…]` | no **[LLVM]** |
| how flydsl reaches it | inline asm, packed by `S2RLoaderTr16x32Bf16Wide` | `rocdl.ds_load_tr16_b128`, present in **0.2.4** **[FLYDSL]** |
| immediate offset field | — | 16-bit unsigned; `offset:65535` encodes, `offset:65536` rejected **[LLVM]** |

The gfx1250 semantics, **measured** rather than read off the manual:

> Lanes work in groups of 8. Lane *j* supplies an address `a_j` pointing at 8
> consecutive 16-bit elements. The hardware performs an 8×8 transpose, and lane
> *l* receives `{a_j + l : j = 0..7}`.

The ISA describes both instructions with one sentence — "Load **A or B matrix**
with element-size of 16 bits into VGPRs from LDS and transpose" **[ISA §11.2.4]**
— and that sentence is true of both while telling you nothing about which lane
ends up holding which element. The lane map is the part you have to measure.

**`probes/probe_nn_frag.py` in this repository is that measurement.** It is
worth running before trusting any derivation, because of the failure mode in the
next paragraph.

### The failure mode that makes guessing dangerous

`ds_load_tr16_b128` requires 16-byte-aligned addresses. Given a misaligned one it
does **not** fault — it **silently degrades into a plain, non-transposing 128-bit
load**. You get a plausible-looking tensor of the right shape, full of wrong
numbers.

This is why `nn_native_unsupported_reason()` treats `N % 8 == 0` as a hard gate
rather than a performance hint, and why "we reasoned carefully about the lane
map" is not an acceptable substitute for having run the probe.

`global_load_tr16_b128`, the global-memory sibling, does **not** have this
restriction: **[MEASURED]** per-lane strides of 9 and 12 elements (18 B and 24 B,
both unaligned) transposed correctly. Its addresses are independent VMEM
addresses and are not subject to LDS bank constraints. See
`docs/03-isa-investigation.md` §Route 5.

---

## 1.4 TDM: what it buys and what it costs

The Tensor Data Mover replaces `buffer_load` + SRD. It is an async DMA engine
that takes a descriptor (base, per-dim extents, per-dim strides, LDS padding) and
moves a whole tile.

**What it buys.** Address generation for free. Hardware out-of-bounds clamping on
two axes. Asynchrony that the multi-buffer pipeline is built on. And — this is
not incidental — **LDS padding designed for transposes**: the ISA says the
padding exists "to facilitate matrix transpose operations or avoid LDS bank
conflicts" **[ISA §10.11.2, §10.11.3]**. TDM-to-LDS-to-transpose-read is the
pipeline the chip designers had in mind, not a workaround.

**What it costs**, in the form of three constraints that each took real debugging:

1. **The innermost stride is hardcoded to `dataSize`.** The descriptor's stride
   fields apply to outer dimensions only. TDM therefore *cannot* express a tile
   whose innermost axis is non-contiguous, which kills any idea of expressing a
   transpose in the descriptor. Hardware limitation, confirmed independently by
   flydsl's `make_tdm_atom` ("the innermost stride is assumed 1 and ignored") in
   both 0.2.4 and 0.3.2. **[ISA + FLYDSL]** Full derivation in
   `docs/03-isa-investigation.md` §Route 1.

2. **An extent is measured from the copy's `imm_offset`, not from the descriptor
   base.** Build a descriptor once with the full token count and walk it with
   `imm_offset`, and it clamps *nothing*. **[MEASURED]** every expert whose token
   count was not a multiple of `tile_k` pulled in a whole extra tile of the next
   expert's tokens; the error tracked `m_len % tile_k` exactly, experts dividing
   evenly were correct at the noise floor and the rest ran 26.6–96.8 % wrong.
   The fix: rebuild the descriptor per k-tile with the row offset folded into the
   base, and copy with `imm_offset=0`.

3. **dim-0 and dim-1 extents are not symmetric.** **[MEASURED]**

   | | bounds addressing? | how it was established |
   |---|---|---|
   | dim-0 extent | **yes**, row-granular | declared 256 rows / 128 valid, never over-read |
   | dim-1 on a **store** | **yes** | a 1 MiB sentinel past the output survived a ragged K, element for element |
   | dim-1 on a **load** | **no** — clamps data only | declared 512 B / 256 B valid walked off the allocation → `Memory access fault … Page not present` |

   **Design rule, followed everywhere in this kernel: put the ragged axis on
   dim 0, and never rely on dim-1 to bound a load.** Where that is impossible —
   the NN pipeline's ragged output axis `N` *is* B's dim 1 — back the read window
   off to `[N - tile_n, N)` and shift the fragment column index by `n_back`.

4. **`pad_interval` must be a power of two** (flydsl: `padInterval must be a
   power of two (in elements)`). The NN B-stage row width is `tile_n * 2`, so
   **`tile_n = 192` cannot be built at all** on any transposing stage. This is a
   real cost: it is the entire reason the native NN path gives up one delivery
   point to the hoisted path (`docs/05-optimization-log.md`).

5. **The outstanding-DMA budget is per WAVE, not per workgroup.** A and B are
   issued by *different* waves, so each issuing wave has one outstanding DMA per
   k-tile, not two. Counting both makes `tensor_wait` a no-op and the pipeline
   reads LDS the DMA has not filled. **[MEASURED]** symptom: **71.16 % of output
   elements NaN**, the remainder at infinite relative error — random bits, not a
   precision problem. Discriminator: `num_buffers` 3→2 makes it go away.

---

## 1.5 What this means for the next port

Three transferable lessons, stated as advice rather than as findings:

**Port the contract, then rebuild the body.** The three public entry points here
keep the gfx950 names, the first three positional parameters and the keyword
spellings. Everything below the signature is new. That is what let the
integration layer stay a dispatch decision rather than a rewrite.

**Measure the lane semantics of anything that permutes data.** The single
highest-risk item in this port was assuming `ds_load_tr16_b128` behaved like
`ds_read_b64_tr_b16`. It does not, and the failure mode is silent. One probe
script, one hour, removes the entire class of risk.

**Expect the tuning table not to travel.** Every threshold in `_pick_config` was
re-fitted. `GROUP_M` went 4 → 16, `num_xcd` went 8 → 1, the tile-selection
thresholds are different, and two of the rules have **no established mechanism**
and are explicitly flagged as such in the docstring. A shared `_pick_config`
across arches would be an invitation to extrapolate rules that cannot support it.
