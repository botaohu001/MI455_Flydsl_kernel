# 3. The ISA investigation: five routes, four verdicts, one adopted

The question: **can dgrad avoid materialising a transposed weight copy on
gfx1250, and if so how?**

Five routes were investigated before any code was written. One was adopted. The
four rejections are documented at the same length as the adoption, deliberately
— a later reader who only sees the winner will re-walk the dead ends.

All ISA section references are to the **AMD Instinct CDNA5 Instruction Set
Architecture Reference Guide**, published by AMD; the link is in `NOTICE`. The
document is not redistributed here. Evidence markers are defined in
`docs/01-architecture.md`.

One caveat that applies to every **[ISA]**-only claim below: the manual covers
the whole CDNA5 family, and gfx1250 is one target within it. Anything not
also backed by **[LLVM]** or **[MEASURED]** may differ in this implementation.

---

## Route 1 — express the transpose in the TDM descriptor

**Verdict: impossible. Hardware, not software. [ISA] + [FLYDSL]**

The TDM address-generation pseudocode:

```
for Z = 0..D#.tile_dim2
  for Y = 0..D#.tile_dim1
    Maddr = D#.global_addr + D#.data_size * (y * tensor_dim0_stride + z * tensor_dim1_stride)
    for X = 0..D#.tile_dim0
        LDS[Laddr] = Memory[Maddr]      // data_size contiguous bytes
        Maddr += dataSize               // <<< innermost increment is hardcoded
        Laddr += dataSize
```

The innermost increment is a hardcoded `dataSize`. The descriptor's stride
fields — `tensor_dim[0-3]_stride` — multiply `y`, `z` and `zz`, i.e. **outer
dimensions only**. The 2-D address expression states it plainly:

```
global_addr[2d] = D#.global_addr + D#.data_size * (x + y * D#.tensor_dim0_stride)
```

The coefficient of `x` is identically 1. **TDM structurally cannot describe a
tile whose innermost axis is non-contiguous**, so it cannot describe a transposed
view.

flydsl agrees, and independently: `make_tdm_atom` documents that "the innermost
stride is assumed 1 and ignored", and the implementation drops it —

```python
for i in range(rank - 1):  # innermost stride assumed 1, not stored
```

— **identically in 0.2.4 and 0.3.2**, so upgrading flydsl changes nothing here.
**[FLYDSL]**

### Two TDM features that look like escapes but are not

- **Gather mode** (§10.11.3.2). Descriptor groups 2/3 are replaced by a row
  index table and rows are fetched by index. But each "row" is still a
  `height=1 × width=tile_dim0` **contiguous** run — only the row *selection*
  becomes random. Using it for a transpose means `tile_dim0 = 1`, i.e. fetching
  2 bytes at a time, and one instruction carries at most 16 indices. Not
  viable. **[ISA]**
- **Descriptor iteration** (§10.11.3.1). `iterate_enable` makes one descriptor
  take every N-th row and compact them into LDS. That is row extraction, not
  transposition. **[ISA]**

### The positive finding hidden in this rejection

The ISA says, in two places (§10.11.2 and §10.11.3), that TDM's LDS padding
exists

> to facilitate matrix transpose operations or avoid LDS bank conflicts.

**"TDM contiguous copy → LDS padding → LDS transpose read" is the transpose
pipeline the chip designers intended.** Route 1 failing is not bad luck; the
architecture deliberately places the transpose at the LDS-read stage. That
observation is what makes Route 2 the natural answer rather than a workaround.

---

## Route 2 — drive the NN pipeline with `ds_load_tr16_b128`

**Verdict: adopted. [LLVM] + [FLYDSL] + [MEASURED]**

### The instruction is there

**[LLVM]** `llvm-mc -mcpu=gfx1250`:

| instruction | gfx1250 | gfx950 |
|---|---|---|
| `ds_load_tr16_b128` | **OK** `[0x00,0x00,0xf0,0xdb,…]` | rejected |
| `ds_load_tr8_b64` / `tr6_b96` / `tr4_b64` | OK | rejected |
| `ds_read_b64_tr_b16` | rejected | **OK** `[0x00,0x00,0xc6,0xd9,…]` |

Two parts, two encodings, equivalent capability. §11.2.4 describes them as one
thing: "DS_LOAD_TR16_B128 — GLOBAL_LOAD_TR16_B128 — Load **A or B matrix** with
element-size of 16 bits into VGPRs from LDS and transpose." Note **"A or B
matrix"** — the ISA is explicit that it serves both operand roles.

Offset field: `offset:65535` encodes, `offset:65536` gives `expected a 16-bit
unsigned offset`. **[LLVM]**

flydsl exports `rocdl.ds_load_tr16_b128` in **both 0.2.4 and 0.3.2**, plus a
higher-level `rocdl.lds_transpose_load(...)` wrapper. **[FLYDSL]**

### The load-bearing claim: wgrad's transpose and dgrad's transpose are isomorphic

This is the crux of the entire investigation. See `docs/02-dgrad-problem.md`
§2.1 step 2 for the operand table; the conclusion is that **wgrad's operands and
dgrad's B operand have the same shape** — reduction axis on the rows, output
axis contiguous on the columns — and the semantic difference (a token vs a
reduction index) never appears in the generated code.

The existing wgrad address expression is literally
`(reduction row) * LDS_ROW + (output column) * 2`. dgrad's B needs that
expression **unchanged**; only the meaning of `LDS_B_ROW` shifts from "wgrad
output axis 2 width" to "`tile_n`".

### It was verified as a measurement, not left as an argument

The original investigation marked the lane mapping **[INFERRED]** and said so
explicitly. **Turning it into [MEASURED] was step one of implementation**, and
it is `probes/probe_nn_frag.py`. Two independent criteria:

1. each lane's 16 fragment elements match the closed-form prediction
   `frag[j] = b[ks*32 + kgrp*8 + (j%8) + 16*(j≥8)][wnb + wn*16 + lane16]`;
2. the same data staged the NT way (`[n,k]`-major + plain `ds_read_b128`) must
   come out **bitwise identical** — a criterion that does not depend on the
   derivation being right.

**Result: 4 tile geometries (32×64 / 64×128 / 128×64 / 64×64), 44 fragments ×
32 lanes × 16 elements, all bitwise correct.** The measured map:

```
lane  0: n=[0]   k=[0,1,2,3,4,5,6,7, 16,17,18,19,20,21,22,23]
lane  1: n=[1]   k=[0,1,2,3,4,5,6,7, 16,17,18,19,20,21,22,23]
lane 31: n=[15]  k=[8,9,...,15, 24,25,...,31]
```

Fill values were **bf16 bit patterns** (`0x2000 + flat_index`), chosen so every
element is a normal finite number that cannot be flushed or renormalised. A
probe that fills with small integers can pass for the wrong reason.

### Two traps inherited for free

wgrad had already paid for both, in this tile orientation:

1. **TDM extents are measured from `imm_offset`, not the descriptor base.** B's
   k-loop advances along the *strided* axis and cannot be walked with
   `imm_offset` the way NT's B can. wgrad rebuilds the descriptor per k-tile
   with the row offset folded into the base and copies with `imm_offset=0`.
   dgrad copies that exactly.
2. **A dim-1 extent does not bound a load's addressing** (measured: page fault).
   dgrad's ragged axis `N` lands on dim 1. wgrad's `blk_n_eff` / `n_back`
   back-off window applies directly.

### Effort estimate, and how it held up

| item | source | estimate | actual |
|---|---|---|---|
| B TDM descriptor re-orientation | wgrad `issue()` | ~15 lines | |
| B LDS stage geometry + `LDS_B_ROW` | wgrad | ~8 lines | |
| per-lane transpose read base | wgrad `b_lane` | ~8 lines | |
| `load_b` → `_frag`/`_tr` | wgrad | ~20 lines | |
| per-k-tile descriptor rebuild + ragged-N back-off | wgrad | ~20 lines | |
| A side, WMMA calls, epilogue, grouped control | NT | **0** | **0** |
| **device-side total** | | **~80** | **125** non-comment |
| host side (entry, `_pick_config_nn`, shape gate) | new | not estimated | 196 |

The ~80-line estimate for the device-side tile body was about right. The upstream
note that this meant "a third full kernel body" **overestimated the work** — the
correct framing is the one gfx950 already uses: one tile body, one boolean.

---

## Route 3 — is there a WMMA transpose variant?

**Verdict: no. [LLVM] + [ISA]**

Every modifier tried on `v_wmma_f32_16x16x32_bf16` was rejected:

```
transpose_a:1                      -> error: not a valid operand.
trans_a:1                          -> error: not a valid operand.
matrix_a_fmt:MATRIX_FMT_BF16       -> error: not a valid operand.
matrix_a_scale:MATRIX_SCALE_ROW0   -> error: not a valid operand.
neg_lo:[1,0,0]                     -> error: invalid neg_lo operand
```

§7.12 Table 43's bf16 entry has one shape and no transposing variant:

```
V_WMMA_F32_16X16X32_BF16   Matrix A 16x32 BF16   Matrix B 32x16 BF16   C/Result 16x16 F32
```

Of the 56 WMMA/SWMMAC mnemonics gfx1250 accepts, the bf16 ones are
`v_wmma_f32_16x16x32_bf16`, `v_wmma_bf16_16x16x32_bf16`,
`v_wmma_bf16f32_16x16x32_bf16` and the sparse `v_swmmac_*`. None carries
transpose semantics. flydsl 0.3.2's WMMA modifier tables likewise expose only
format and negate/abs, no transpose. **[FLYDSL]**

---

## Route 4 — an algebraic way out

**Verdict: structurally impossible. [INFERRED], but the reasoning is complete.**

Covered in full in `docs/02-dgrad-problem.md` §2.4. The one-line version: **fwd
and dgrad require opposite major orders of the same array**, so no single weight
layout serves both, and `(AᵀB)ᵀ = BᵀA` does not change the stride of either
operand along the reduction. The one reformulation that *is* expressible — run
dgrad as a `G=1` variable-K call per group, transposing the activations instead
— is bitwise correct and **1.5×–10.5× slower**. Measured, not assumed.

This route is marked **[INFERRED]** rather than **[MEASURED]** because it is a
statement about what cannot exist. The *consequence* was measured.

---

## Route 5 — `global_load_tr16_b128`: works, not used

**Verdict: viable, not adopted. [ISA] + [LLVM] + [FLYDSL 0.2.4] + [MEASURED]**

This was the investigation's genuinely new finding: there is a transposing load
that goes **straight from global memory to VGPRs**, skipping LDS entirely.

§10.9, "WMMA Matrix Load Ops with Transpose":

> **GLOBAL_LOAD_TR16_B128** — Load a 16x16 matrix of 16-bit data into VGPRs and
> **transpose between row-major and column-major order**. …
> Note these load-transpose instructions are **wave32-only**.

gfx1250 *is* wave32, so it is in scope. `llvm-mc` encodes it
(`[0x7c,0xc0,0x15,0xee,…]`), and flydsl **0.2.4** already exports
`rocdl.global_load_tr_b128` → `rocdl.global.load.tr.b128`, documented
"Available in gfx1250+". **[LLVM] [FLYDSL]**

### It was measured on hardware

`probes/isa/probe_global_tr.py` fills memory with `f16[i] = i`, gives lane *l*
the address `l * STEP`, and reports which source indices each lane received.
Single wave32 workgroup, flydsl 0.2.4, all 6 STEP values pass:

```
===== global_load_tr16_b128, per-lane step = 8 elements (16 B) =====
  lane  0: [0, 8, 16, 24, 32, 40, 48, 56]
  lane  1: [1, 9, 17, 25, 33, 41, 49, 57]
  ...
  lane  7: [7, 15, 23, 31, 39, 47, 55, 63]
  --- group boundary ---
  lane  8: [64, 72, 80, 88, 96, 104, 112, 120]
  -> 8-lane-group 8x8 TRANSPOSE (same shape as ds_load_tr16_b128)
```

**Lane semantics are identical to the LDS version**, confirming the ISA's
"Global Equivalent" pairing.

**One property that is strictly better than the LDS version:** STEP = 9 (18 B)
and STEP = 12 (24 B), both **not 16-byte aligned**, still transposed correctly.
The LDS version silently degrades to a plain load when misaligned. Each lane
here supplies an independent VMEM address, free of LDS bank constraints — which
means **any N works, not just multiples of 8.** **[MEASURED]**

Applied to dgrad it would look like: lane *j* of each 8-lane group takes
`b_slab + (k0+j)*N*2 + n0*2`, per-lane stride `N` elements; lane *l* then holds
`b[g][k0..k0+7][n0+l]` — half a WMMA B fragment, from global straight to
registers.

### Why it was not adopted

**This is a judgement about remaining headroom, not a measurement that rejected
it.** Route 2 reached 0.979 of the hoisted NT calibre after tuning, leaving ~2 %
on the table, against costs that are certain:

- **loses the TDM async pipeline.** The whole multi-buffer structure is built on
  TDM + `tensor_wait`; `global_load_tr` is an ordinary VMEM load tracked by
  LOADcnt and would need a separate prefetch scheme.
- **loses hardware OOB clamp.** Ragged N and short-tail experts are currently
  free via `tensor_extents`; VMEM loads need hand-written masks.
- **demotes B reuse from LDS to L1/L2.** TDM→LDS is one fetch per workgroup
  shared by all waves; per-lane VMEM is every wave fetching its own.
- **VGPR pressure.** The transpose read already costs more address registers
  than a plain `b128`; at `frag_pipeline=1` wgrad hit the 512 limit and spilled 3.

And the scenario that motivated it — small `avg_m`, memory-bound dgrad, where
LDS staging might not pay — is **exactly where the native NN pipeline is already
at or above the hoisted calibre** (deepseek fc2 @128 = 1.031, fc1 @128 = 0.978).
The motivation weakened as Route 2 improved.

**If someone picks this work up, this is the next experiment.**

### Same family, all checked, all negative

| mechanism | verdict | level |
|---|---|---|
| `global_load_lds_*` / `GLOBAL_LOAD_ASYNC_TO_LDS_B{8,32,64,128}` | exists; §10.8.1 pseudocode is a byte-for-byte copy, **no transpose**. `global_load_lds_b128` does not exist on gfx1250 at all | [ISA]+[LLVM] |
| `v_permlane16_swap_b32` | gfx1250 has it | [LLVM] |
| `v_permlane32_swap_b32` | gfx1250 does **not** have it | [LLVM] |
| `ds_bpermute_b32` / `v_permlane16_b32` / `ds_swizzle` | present, but 32-bit-granular lane exchange; hand-rolling a bf16 transpose costs several VALU plus packing, far more than one `ds_load_tr16_b128` | [LLVM] |
| buffer-load swizzle | gfx1250 goes through TDM; there is no SRD on this path | [ISA] |

---

## The question this was all asked to answer

> gfx950's `ds_read_b64_tr_b16` NN pipeline — what does it actually do, and is
> gfx1250 missing the *instruction* or just the *code*?

**Just the code.** Item by item:

| what gfx950 needs | does gfx1250 have it? | level |
|---|---|---|
| a 16-bit LDS transpose read | **yes** — `ds_load_tr16_b128`; different encoding, equivalent capability, ISA says it serves "A or B matrix" | [LLVM]+[ISA] |
| flydsl able to emit it | **yes** — `rocdl.ds_load_tr16_b128`, present in 0.2.4 | [FLYDSL] |
| its lane semantics established | **yes** — measured, recorded in the kernel's variable-K section header | [MEASURED] |
| the transpose read feeding WMMA, proven | **yes** — the whole wgrad pipeline does it, on both operands | [MEASURED] |
| a "reduction axis on rows" LDS tile orientation | **yes** — wgrad's A and B stages | source |
| the matching TDM descriptor idiom | **yes** — wgrad `issue()`, extent trap and ragged back-off already solved | source |
| **an NN pipeline connecting them** | **no** ← the only thing missing | — |

The original note gave two reasons for not building it: it would be a third full
kernel body, and there was no hardware to validate against. **The second reason
expired** when the parts arrived. **The first overestimated the work** — it is
one tile body and one boolean, which is how gfx950 does it too.

---

## Loose ends the investigation did not close

Stated plainly, because a reader should know where the floor is:

1. `global_load_tr16_b128`'s **throughput, cache behaviour, and counter
   interaction with TDM** were never measured. Only its lane semantics were.
2. The investigation made **no performance prediction** for the native NN
   pipeline, and said so. NN's B-side TDM read walks tiles along a strided axis,
   a different access pattern from NT; whether the GEMM itself would be slower
   was explicitly left as something that had to be measured. It was — see
   `docs/05-optimization-log.md`. It is 2.1 % slower, and the reason is not what
   anyone guessed.
3. Claims carrying only **[ISA]** and no **[LLVM]** backing (TDM gather/iterate
   details) may differ on this specific target. The core TDM
   innermost-stride result is not in this category — it has independent flydsl
   corroboration.
