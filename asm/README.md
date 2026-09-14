# `asm/` — generated code for the native NN pipeline

Compiled artifacts for one representative shape, kept because two claims in
`docs/` are only checkable against the generated code.

**Kernel:** grouped NN (dgrad), native pipeline, `b_lds_transpose=1`
**Shape:** qwen3-235b-a22b fc1, `avg_m=2048`, tile 256×256×128, mw2/nw2/nb2

| file | size | why it is here |
|---|--:|---|
| `nn_native/21_final_isa.s` | 145 KB | the final gfx1250 ISA. Every instruction-mix claim in `docs/04-native-nn-pipeline.md` §4.5 is counted from this. |
| `nn_native/20_llvm_ir.ll` | 213 KB | the LLVM IR, one step before instruction selection. Useful when the ISA and your expectation disagree and you need to know which side introduced it. |
| `nn_native/pipeline-digest.txt` | 4 KB | per-stage op counts for **all 22 stages**, including the 20 that are not checked in. |

Total **≈ 360 KB**.

---

## What was excluded, and why

The flydsl compiler emits 22 stage dumps per kernel. In full that is **9.5 MB**
for this one kernel — and of the 23 files, **only 13 are distinct**; the rest
are byte-identical to their predecessor because the pass changed nothing at
this level. Eleven of the intermediate MLIR stages are 300–800 KB each.

Weighing it up:

- **They are fully regenerable** with one command (below), on the same hardware
  that produced everything else here.
- **Their unique diagnostic content is small.** What you actually want from a
  stage dump is "did the op I expect survive lowering, and how many are there".
  `pipeline-digest.txt` answers exactly that for every stage, at 4 KB instead of
  9.1 MB.
- **They are for debugging flydsl, not for reading.** Anyone with a reason to
  inspect `08_convert_fly_to_rocdl.mlir` line by line is compiling their own
  variant anyway, and wants their own dump, not this one.
- **The final ISA is different.** It is the artifact that settles performance
  questions, it is small, and it cannot be reproduced by a reader without
  gfx1250 hardware. So it is checked in.

`.gitignore` enforces the split, so a local `FLYDSL_DUMP_IR=1` run will not
accidentally commit 9 MB.

## Regenerating everything

```bash
FLYDSL_DUMP_IR=1 FLYDSL_DEBUG_DUMP_ASM=1 FLYDSL_DUMP_DIR=asm \
  python benchmarks/dump_stats.py
```

`dump_stats.py` compiles three shapes both ways (NT-with-hoisted-weight and
native NN) and prints the register/spill/instruction-mix comparison. The stage
dumps land in `asm/<kernel-name>/`.

---

## What the generated code shows

**The pipeline lowers cleanly.** 128 transpose reads and 512 WMMA instructions
survive every stage from `00_origin.mlir` to the final ISA — nothing folded
away, duplicated, or lost.

**The transposing reads replace plain reads rather than adding to them.** The
final ISA has 128 `ds_read_b128` plus 128 transposing reads: **256 LDS reads,
exactly matching the NT path's 256.**

**This is how register pressure was excluded** as an explanation for the native
pipeline's 2.1 % gap. From `dump_stats.py` on a 256×256×128 gpt-oss fc1 shape:

| | NT (hoist) | native NN |
|---|--:|--:|
| VGPR | 791 | **790** |
| VGPR / SGPR spill | 0 / 0 | **0 / 0** |
| scratch | 0 | **0** |
| WMMA | 512 | **512** |
| LDS reads | 256 | **256** (128 plain + 128 transposing) |
| VALU | 853 | 846 |
| SALU / wait | 672 | **602** |
| total instructions | 2378 | **2301** |

The native path emits **77 fewer instructions** with essentially identical
register usage, so the residual 2.1 % can only be the per-instruction cost of
the transposing read itself — LDS crossbar or bank behaviour. Not code bloat,
not occupancy.

> Only the native NN variant's ISA is checked in. `dump_stats.py` generates the
> NT counterpart in the same run if you want to diff them directly; the table
> above is that diff.
