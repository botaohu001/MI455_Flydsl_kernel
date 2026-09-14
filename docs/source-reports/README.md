# `docs/source-reports/` — the original reports, archived

These are the working reports written during development, kept **as written**
(apart from the redactions below). They are the primary evidence behind every
`[MEASURED]` claim in `docs/01`–`docs/07`.

`docs/01`–`07` are a **reorganisation** of this material for someone arriving
fresh, not a summary of it. Where the two disagree, these files are the record
of what was actually observed and the rewritten docs are where to file a bug.

**Language note:** four of these are in Chinese and four in English, as
originally written. The rewritten `docs/01`–`07` are in English throughout.

---

## What each one is

| file | written when | what it settles |
|---|---|---|
| `prep-notes.md` | before the kernel existed | environment, integration points, Triton/CK/hipBLASLt baselines, and the flydsl 0.2.x vs 0.3.x conflict |
| `upstream-notes.md` | with the kernel, no GPU access | the original author's structure-vs-gfx950 ledger, the reuse decisions, the calibre traps, and the open questions. **This is the document the whole project responds to.** |
| `kernel-review.md` | static analysis, no GPU | API contract three-way comparison, dependency red flags, shape-gate verdicts for all 72 points, integration plan. Its `_pick_config` predictions were later confirmed point by point. |
| `bench-report.md` | first hardware run | correctness across three operators, the 72-point matrix, the two dgrad calibres, and three falsifiable checkpoints — all confirmed |
| `isa-findings.md` | the ISA survey | the five routes with evidence levels. Source for `docs/03`. |
| `dgrad-study-report.md` | the decision study | the transpose, the cache, the memory cost, the algebraic dead end, the dispatch threshold. Source for `docs/02`. |
| `nn-pipeline-report.md` | the implementation | the native NN pipeline: design, bitwise correctness, three-section matrix, four-calibre comparison. Source for `docs/04` and `docs/07`. |
| `lazy-import-pr.md` | alongside | the proposed fix for flydsl 0.3.x making `primus_turbo.pytorch` unimportable. Not needed for this kernel once 0.2.4 was shown to work, but it documents the 27-file / 12-eager-import blast radius. |

Read in that order and you get the project chronologically, including the parts
that turned out wrong.

---

## Claims in here that later measurement overturned

Kept deliberately — a sanitised archive is not an archive. All three are
covered in `docs/06-pitfalls.md`.

| claim | where | what was measured later |
|---|---|---|
| "Requires flydsl >= 0.3.0" | `upstream-notes.md`, `prep-notes.md` | **0.2.4 runs the kernel**, whole matrix correct. The floor was an assumption that propagated into three documents. |
| dgrad needs a materialised transposed weight; a native NN pipeline would be "a third full kernel body" | `upstream-notes.md` §4b | One tile body, one boolean, 125 device-side lines. |
| gpt-oss fc2 (`N == K == 2880`) first 1–2 calls corrupt | `upstream-notes.md` §6.5 | **Not reproduced** across three `avg_m` values in fresh processes. Not "fixed" — not reproduced. The burn-3 convention was kept. |
| `MAX_G = 64` | `kernel-review.md`, `prep-notes.md` | A gfx950 measurement. gfx1250 is correct through **G = 160**. |

Two more where the reports were right and worth crediting:

- `kernel-review.md` predicted, from source alone, exactly which 4 of 48 points
  would hit the fitted narrow-tile rule and which three extra tile configs would
  appear. **Confirmed point for point** on hardware.
- `dgrad-study-report.md` called the per-call transpose "a bug, not a tuning
  question" at 0.276× Triton. The later hardware run measured 0.324×.

---

## Redactions

The repository is public; these reports were not written for publication. A
mechanical pass replaced the following. **No technical content, measurement or
conclusion was changed or removed.**

| what | replaced with | count |
|---|---|--:|
| internal cluster hostnames | "an MI455X internal test node" | 2 |
| internal container registry image | "a ROCm 7.x container image with torch 2.11 + flydsl 0.2.4" | 2 |
| local container name | `<container>` | 5 |
| local branch names | descriptive phrases | 12 |
| a branch name containing a developer handle | "the gfx950 development branch" | 2 |
| non-public commit hashes | "a local commit" | 16 |
| absolute host paths | `<repo>` / `<home>` | 15 |
| username | `<user>` / "the developer account" | 1 |
| local flydsl staging path | `<staged-flydsl-0.3.2>` | 5 |

Two substitutions were then repaired by hand where the mechanical result read
badly: the machine description at the top of `bench-report.md` and
`prep-notes.md`, and the `docker run` block in `prep-notes.md` §1.1 (which had
become a non-runnable command; it now takes `$IMAGE`).

**Cross-references inside these reports point at their original locations**
(`nn_pipeline/`, `dgrad_study/`, `results/nn_pipeline/`, …), which mostly do not
exist in this repository's layout. The mapping:

| in the reports | here |
|---|---|
| `nn_pipeline/gg_gfx1250_nn.py` | `kernel/grouped_gemm_bf16_kernel_mi455.py` |
| `upstream/primus_turbo/grouped_gemm_bf16_kernel_gfx1250.py` | `kernel/reference/` |
| `nn_pipeline/probe_nn_frag.py`, `smoke_nn.py` | `probes/` |
| `nn_pipeline/*.py` (benchmarks), `dgrad_study/*.py` | `benchmarks/`, `benchmarks/dgrad_study/` |
| `isa_study/` | `probes/isa/` and `results/isa/` |
| `results/nn_pipeline/`, `dgrad_study/results/` | `results/nn_pipeline/`, `results/dgrad_study/` |
| `nn_pipeline/asm/kernel_grouped_nt_0/` | `asm/nn_native/` (final ISA + LLVM IR only — see `asm/README.md`) |
| `Primus-Turbo/`, `Primus/` | not included; public upstream repositories |
