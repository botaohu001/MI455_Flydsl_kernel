# `probes/` — establishing facts before building on them

Each script here answers one question that was, at the time, an assumption. The
first two are the load-bearing ones.

All scripts resolve paths relative to the repository root, so a clone works
anywhere with no editing. They need **gfx1250 hardware** except where noted.

---

## `probe_nn_frag.py` — the most important script in this repository

**Question:** in the dgrad tile orientation, which source element does each lane
of `ds_load_tr16_b128` actually receive?

This had been marked **[INFERRED]** in the ISA investigation — a short
derivation from wgrad's measured behaviour, never run. It was turned into
**[MEASURED]** before a single line of the NN pipeline was written, because the
failure mode makes guessing unusually dangerous: given a misaligned address the
instruction **silently degrades into a plain non-transposing load**, so a wrong
lane model produces a plausible tensor of the right shape full of wrong numbers.

Design choices that matter if you adapt it:

- LDS is filled by a **real TDM copy**, not by hand. The thing under test is the
  whole path, not the instruction in isolation.
- Fill values are **bf16 bit patterns** `0x2000 + flat_index` — all normal
  finite numbers. Small-integer fills can pass for the wrong reason once
  denormal flushing or rounding is in play.
- **Two independent criteria.** (a) each lane's 16 elements match a closed-form
  prediction; (b) the same data staged the NT way and read with a plain
  `ds_read_b128` must come out **bitwise identical**. Criterion (b) does not
  depend on the derivation being right, which is the whole point of having it.

**Result:** 4 tile geometries (32×64 / 64×128 / 128×64 / 64×64), 44 fragments ×
32 lanes × 16 elements, all bitwise correct.

```
lane  0: n=[0]   k=[0..7, 16..23]
lane  1: n=[1]   k=[0..7, 16..23]
lane 31: n=[15]  k=[8..15, 24..31]
```

```bash
python probes/probe_nn_frag.py
```

Expected output is in `results/nn_pipeline/probe_nn_frag.out`.

---

## `isa/probe_global_tr.py` — `global_load_tr16_b128` on real hardware

**Question:** does the global-memory transposing load exist on gfx1250, and what
are its lane semantics?

It does. Fills memory with `f16[i] = i`, gives lane *l* the address `l * STEP`,
and reports which source indices each lane received. Single wave32 workgroup,
**flydsl 0.2.4**, all 6 STEP values pass.

Two findings:

1. **Lane semantics are identical to the LDS version** — an 8-lane-group 8×8
   transpose — confirming the ISA's "Global Equivalent" pairing.
2. **It tolerates misalignment where the LDS version does not.** STEP = 9 (18 B)
   and STEP = 12 (24 B) still transpose correctly, because each lane supplies an
   independent VMEM address free of LDS bank constraints. **That means any `N`
   works, not only multiples of 8.**

This route was measured, documented, and **not adopted** —
`docs/03-isa-investigation.md` §Route 5 explains the trade, and it is the
clearest next experiment for anyone continuing the work.

---

## `isa/probe_isa.sh`, `isa/probe_isa2.sh` — what the assembler accepts

**No GPU required.** Pure `llvm-mc -mcpu=gfx1250` encode/reject probes. This is
the most reliable answer to "does this instruction exist on this target",
independent of what the family-wide ISA manual says.

Settles, among others: `ds_load_tr16_b128` encodes on gfx1250 and not gfx950;
`ds_read_b64_tr_b16` is the reverse; the offset field is 16-bit unsigned; no
WMMA transpose modifier exists in any spelling; `v_permlane16_swap_b32` exists
but `v_permlane32_swap_b32` does not.

## `isa/pdf_extract.py` — line-addressable ISA text

**No GPU required.** Converts the published CDNA5 ISA PDF to text so sections
can be cited by line. The PDF and its extraction are **not redistributed here**
(see `NOTICE`); download your own copy from AMD and point this at it.

---

## `smoke_nn.py` — the fast correctness gate

Single expert → grouped → ragged → imbalanced, including `G=1`, the minimum
`K == N == 256` shape, and distributions like `lens=[1, 2047, 0, 33, 4096, 129]`
with an **empty expert**. Every case compared bitwise against the hoisted
calibre. Run this before `benchmarks/check_full.py`; it fails in seconds rather
than minutes.

## `probe_flydsl_symbols.py` — is the flydsl surface actually there?

**No GPU required, runs in about a second.** Checks the 14 flydsl symbols this
kernel needs that have **no precedent anywhere in Primus-Turbo**, plus the 12
module-scope imports.

This exists because a version number is not evidence: the same flydsl line
**deleted a public submodule** (`flydsl.expr.buffer_ops`) between 0.2.x and
0.3.x. Running this is what established that **0.2.4 is the real floor**, not
the 0.3.0 the module header claimed. See `docs/06-pitfalls.md` §6.1.

## `probe_backends.py`, `probe_open_questions.py`

`probe_backends.py` reports, per direction, which of the four Primus-Turbo
backends says it `can_handle` a given shape and what happens if you make it
execute. This is how the arch gates were mapped.

`probe_open_questions.py` covers the `G` upper bound and the `num_xcd` sweep —
the two "we do not know" items in the upstream notes. It established that
**`MAX_G = 64` is a gfx950 measurement that does not transfer**: gfx1250 is
correct through **G = 160**, including the G = 80 and G = 96 that gfx950 fails.
