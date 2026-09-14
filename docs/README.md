# `docs/`

`01`–`07` are written for someone arriving with no context. They reorganise the
working reports in [`source-reports/`](source-reports/) rather than summarising
them; the archive is the primary evidence and stays as written.

| | |
|---|---|
| [01-architecture](01-architecture.md) | gfx1250 vs gfx950, item by item. Why the ideas port and the code does not. |
| [02-dgrad-problem](02-dgrad-problem.md) | The transpose problem end to end, including three dead ends. |
| [03-isa-investigation](03-isa-investigation.md) | Five ISA routes, four rejections, one adoption. |
| [04-native-nn-pipeline](04-native-nn-pipeline.md) | What was built and how it was verified. |
| [05-optimization-log](05-optimization-log.md) | Everything tried, including the failures. |
| [06-pitfalls](06-pitfalls.md) | The traps, with ⚠️ on the silent ones. |
| [07-performance](07-performance.md) | The full matrix and the measurement conditions. |

## Evidence markers

Used consistently across all seven documents. The distinction is load-bearing:
this project overturned three claims that were asserted rather than measured.

| marker | meaning |
|---|---|
| **[MEASURED]** | run on an MI455X (gfx1250) in this project |
| **[ISA]** | stated in the published CDNA5 ISA reference. The manual covers the whole CDNA5 family; gfx1250 is one target in it, so this alone does not establish behaviour on this part. |
| **[LLVM]** | `llvm-mc -mcpu=gfx1250` accepts or rejects the encoding. The most reliable answer to "does this instruction exist here". |
| **[FLYDSL]** | present in the flydsl Python surface, version given |
| **[INFERRED]** | reasoning from the above; **not** measured |

An unmarked claim in `01`–`07` is measured. Where something is measured but
**unexplained**, it says "mechanism not established" — two of the tuning rules
in this kernel are in that category and must be re-measured rather than
extrapolated.
