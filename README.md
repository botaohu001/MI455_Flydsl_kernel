# MI455X bf16 grouped GEMM — a FlyDSL kernel for gfx1250

A bf16/fp16 grouped GEMM (MoE expert matmul) for **AMD MI455X / gfx1250**,
covering all three training operators — forward, dgrad and wgrad — built on
FlyDSL's WMMA + TDM surface.

**The point of this repository is the dgrad path.** Everything else is a port;
dgrad needed a new idea.

> **Backward on a grouped GEMM has an operand-layout problem**: the weight's
> reduction axis is its strided axis, so the matrix engine cannot read it. The
> usual answer is to materialise a transposed copy of the weights. On MI455X
> that copy costs **up to 2.9 ms against a 0.3 ms GEMM** and a **full duplicate
> of the expert weights in HBM**.
>
> **This kernel does not make the copy.** The weight is DMA'd into LDS exactly
> as it is stored and transposed on the way into the WMMA fragments by the
> hardware LDS transpose read `ds_load_tr16_b128` — the instruction that was
> already wired into wgrad, connected to dgrad for the first time.

---

## Results

**Correctness is bitwise, not "within tolerance".**

| check | result |
|---|---|
| dgrad, native pipeline vs a hoisted transposed weight | **48/48 bitwise identical** (max abs Δ = 0) |
| fwd vs the pre-change kernel | **48/48 bitwise identical** |
| wgrad vs the pre-change kernel | **48/48 bitwise identical** |
| `rel_fro` vs an fp32 reference | max 1.6622e-03 — **equal to the bf16 output-quantisation floor to the last digit**, so the kernel adds no arithmetic error of its own |

48 rows = 24 MoE shapes × {balanced, imbalanced groups}, including an empty
expert, a 3-row expert, `N == K`, a ragged output axis, and non-power-of-two K.

**Throughput**, dgrad, 24 delivery shapes:

| | mean | peak | MFU peak |
|---|--:|--:|--:|
| dgrad (native NN) | **1415.5 TF/s** | **1972.9 TF/s** | **39.2 %** |
| fwd | 1430.8 TF/s | 1955.4 TF/s | 38.9 % |
| wgrad | 1274.0 TF/s | 1758.0 TF/s | 34.9 % |

**Three ratios, all of them:**

| comparison | geomean | range | wins |
|---|--:|---|---|
| vs **hoisted transpose** (same GEMM, weight pre-transposed for free) | **0.979** | 0.872 – 1.031 | 2/24 |
| vs **flydsl + a fast transpose, per call** | **1.357** | 1.108 – 1.908 | **24/24** |
| vs **Triton** | **1.208** | 0.853 – 2.107 | 20/24 |

Read them together, because they say different things:

- **0.979 is the honest like-for-like.** The native GEMM is **2.1 % slower**
  than the NT GEMM when the NT path is handed a transposed weight for free.
  That comparison is an upper bound a real caller cannot reach without
  maintaining a parameter-sized copy and invalidating it correctly.
- **1.357 is what a caller actually gets per call**, 24 of 24, against the
  best per-call transpose measured here (a tiled Triton kernel at 15.5–17.1
  TB/s, itself **11–14× faster** than `.transpose().contiguous()`).
- **1.208 vs Triton, winning 20 of 24.** The four losses are at small `avg_m`:
  0.853, 0.890, 0.926, 0.934. **They are not caused by this work** — the same
  cells lose in the hoisted calibre too — and **the cause is unknown**. Wave
  quantisation was tested as an explanation and disproven.

What the 2.1 % buys: **no transposed weight copy** (up to **2.62 GiB per layer**
for deepseek-v3 at EP=8), nothing to invalidate, and therefore no exposure to
the failure mode where `AdamW(fused=True)` does not bump `param._version` and a
cache silently serves last step's weights (reproduced at 9.99e-02 relative
error).

Full tables: **[docs/07-performance.md](docs/07-performance.md)**.

---

## Where to start

**If you are porting a kernel to a new AMD part** →
[`docs/01-architecture.md`](docs/01-architecture.md). The gfx950 → gfx1250
ledger and why the ideas port but the code does not.

**If you have the same dgrad transpose problem** →
[`docs/02-dgrad-problem.md`](docs/02-dgrad-problem.md). The full chain, plus
three dead ends documented at the same length as the solution.

**If you are tuning this kernel** →
[`docs/05-optimization-log.md`](docs/05-optimization-log.md) first, so you do
not repeat something already measured as a loss.

**If you are about to trust a benchmark number** →
[`docs/06-pitfalls.md`](docs/06-pitfalls.md) §6.4. Two comparisons in this
project were nearly made between measurements of different work.

| doc | what it covers |
|---|---|
| [01-architecture](docs/01-architecture.md) | gfx1250 vs gfx950 item by item: MFMA→WMMA, wave64→wave32, SRD→TDM, AGPR→VGPR, the transpose reads with **different lane semantics**, and the five TDM constraints that each cost real debugging |
| [02-dgrad-problem](docs/02-dgrad-problem.md) | why dgrad needs a transpose at all; and why a faster transpose, a weight cache, and an algebraic reformulation are each **not** the answer |
| [03-isa-investigation](docs/03-isa-investigation.md) | five ISA routes with evidence levels. **The four rejections are the useful part** — including `global_load_tr16_b128`, which works and was deliberately not used |
| [04-native-nn-pipeline](docs/04-native-nn-pipeline.md) | the implementation: one tile body, one boolean, 125 device-side lines; the lane-semantics measurement; where the 2.1 % went, answered from the assembly |
| [05-optimization-log](docs/05-optimization-log.md) | everything tried **including the failures**, each with data: six directions that made things worse, five hypotheses that turned out false |
| [06-pitfalls](docs/06-pitfalls.md) | the traps, marked ⚠️ where they produce a **plausible wrong answer** rather than an error |
| [07-performance](docs/07-performance.md) | the full three-section matrix, the four-calibre comparison, and the measurement conditions |
| [source-reports/](docs/source-reports/) | the original working reports, archived — the primary evidence, including the claims later overturned |

Layout:

```
kernel/       the implementation + the pre-change revision, for diffing
docs/         01-07 rewritten for a new reader; source-reports/ as written
probes/       establishing facts before building on them (lane maps, ISA capability)
benchmarks/   correctness harnesses and measurement drivers
results/      raw CSV/JSON behind every quoted number
asm/          final gfx1250 ISA + LLVM IR, and a digest of the 20 dropped stages
```

---

## Using it

```python
from grouped_gemm_bf16_kernel_mi455 import (
    grouped_gemm_bf16_nt_flydsl_kernel,          # fwd:   out[rows] = a[rows] @ b[g].T
    grouped_gemm_bf16_nn_flydsl_kernel,          # dgrad: out[rows] = a[rows] @ b[g]
    grouped_gemm_bf16_variable_k_flydsl_kernel,  # wgrad: out[g] = a[rows_g].T @ b[rows_g]
)

# a[M_total, K], expert row-runs concatenated along M; group_offs is [G+1] int64.
# b is [G, K, N] and is READ IN PLACE -- no transposed copy, nothing to hoist.
da = grouped_gemm_bf16_nn_flydsl_kernel(dout, b, group_offs)
```

Dropping into Primus-Turbo: both files go next to the gfx950 kernel in
`primus_turbo/flydsl/grouped_gemm/`. **Widening the backend's arch gate is not
sufficient on its own** — five things raise instead of falling back to Triton.
[`kernel/README.md`](kernel/README.md) and
[`docs/06-pitfalls.md`](docs/06-pitfalls.md) §6.2 list them.

---

## Reproducing

**Hardware:** AMD MI455X (gfx1250). There is no CPU or emulated path.

**Software**, as measured:

| | |
|---|---|
| torch | 2.11.0+rocm7.14 |
| **flydsl** | **0.2.4** |
| ROCm | 7.x container; no `/opt/rocm` needed, the toolchain ships as a wheel |
| triton | 3.6.0+rocm7.14 (for the baselines and the tiled transpose only) |

⚠️ **flydsl 0.2.4, not 0.3.0.** The kernel's own header used to claim a floor of
0.3.0. That was an assumption and it is **wrong** — 0.2.4 was measured running
the whole matrix correctly. It matters, because flydsl 0.3.x **deleted**
`flydsl.expr.buffer_ops`, which 27 sibling modules in Primus-Turbo still import.
[`docs/06-pitfalls.md`](docs/06-pitfalls.md) §6.1.

```bash
python probes/probe_flydsl_symbols.py    # ~1s, no GPU: is the flydsl surface there?
python probes/probe_nn_frag.py           # measure the ds_load_tr16_b128 lane map
python probes/smoke_nn.py                # fast correctness gate
python benchmarks/check_full.py          # the 48-row bitwise gate
python benchmarks/bench_matrix.py        # the three-section matrix + four calibres
```

Scripts resolve paths relative to the repository root, so a clone works from any
directory.

### Measurement conditions

Single MI455X, 256 CU, 432.0 GiB HBM, on an internal test system. **Clocks were
not pinned** — `sclk` stayed within **2010–2331 MHz** and is sampled and
reported at every timed point.

Not pinning was deliberate: the Triton and hipBLASLt baselines were measured
unpinned, and pinning only one side would invalidate the comparison. What
substitutes for it is that **competing implementations are measured in the same
process, interleaved repeat by repeat**, so a clock excursion lands on both.
Median of 5 samples, each a launch loop filling ~40 ms; **all 72 delivery points
came in at cv < 2 %**.

⚠️ **Do not compare absolute numbers across the three operator sections** — fwd
and wgrad were measured in an earlier round at a different clock range. Ratios
within a section, and the four-calibre table, are same-session.

### If you do not have gfx1250

Most of this repository still applies:

- **[`docs/01-architecture.md`](docs/01-architecture.md)** — the porting ledger
  is about architectural differences, not about having the part.
- **[`docs/03-isa-investigation.md`](docs/03-isa-investigation.md)** — the
  `llvm-mc` probes in `probes/isa/*.sh` need **no GPU**, only an LLVM that knows
  `-mcpu=gfx1250`. "Does this instruction exist" is answerable on a laptop.
- **[`docs/02-dgrad-problem.md`](docs/02-dgrad-problem.md)** — the reasoning
  chain, the cache analysis, and the algebraic argument are hardware-independent.
  The `_version` finding applies to **any** torch 2.11 project caching anything
  keyed on a parameter.
- **[`docs/05-optimization-log.md`](docs/05-optimization-log.md)** and
  **[`docs/06-pitfalls.md`](docs/06-pitfalls.md)** — the transferable content is
  the method: measure lane semantics rather than deriving them, check whether an
  operation is slow or its *implementation* is, state the calibre next to every
  number.
- **[`asm/`](asm/)** and **[`results/`](results/)** — readable without hardware.

The one thing you cannot do without gfx1250 is re-run the measurements.

---

## Status and honest limits

This is **research and bring-up work**, not a shipped library. It runs and is
verified on the 24-shape delivery matrix. It is not integrated into
Primus-Turbo's backend registry, has no CI, and has known gaps:

- **4 of 24 dgrad cells still lose to Triton** at small `avg_m`, cause unknown.
- Two tuning rules (the LDS pad residue, the `tile_n`/`tile_k` combination) are
  **measured with no established mechanism**. Re-measure, do not extrapolate.
- `num_xcd` is pinned at 1 because the MI455X XCD count is unconfirmed.
- `cap_cu` is unimplemented; `trans_c` on wgrad raises (operand swap works
  instead, at zero cost).
- Only bf16/fp16, single GPU, one session per measurement round.

Every one of these is written up rather than left for you to discover.

---

## Licence

**Apache-2.0** — see [`LICENSE`](LICENSE), and [`NOTICE`](NOTICE) for the
provenance chain (FlyDSL → Primus-Turbo → here). The copyright headers and
FlyDSL attribution at the top of each kernel file are preserved verbatim and
must stay. Documentation is under the same licence as the code; the reasoning
is in `NOTICE`.

The CDNA5 ISA reference is cited throughout and **not redistributed here**; it
is [published by AMD](https://www.amd.com/content/dam/amd/en/documents/instinct-tech-docs/instruction-set-architectures/amd-instinct-cdna5-instruction-set-architecture.pdf).
