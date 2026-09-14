# `kernel/reference/` — the "before" snapshot

`grouped_gemm_bf16_kernel_gfx1250.py` is the gfx1250 kernel **as it stood before
the native NN pipeline existed**, kept byte-identical so the change can be
diffed rather than described.

```bash
diff -u kernel/reference/grouped_gemm_bf16_kernel_gfx1250.py \
        kernel/grouped_gemm_bf16_kernel_mi455.py
```

## Why keep it

Three reasons, in order of usefulness:

1. **The diff is the documentation.** 499 insertions / 52 deletions is small
   enough to read end to end, and it makes concrete the claim in
   `docs/04-native-nn-pipeline.md` that the NN pipeline is a switch on the NT
   launcher rather than a third kernel body.

2. **It is the correctness oracle.** `benchmarks/check_full.py` loads *both*
   modules into one process and asserts the shipped kernel's fwd and wgrad are
   **bitwise identical** to this one, 48/48 rows. "No regression" is therefore a
   comparison between two implementations, not each one re-checked against a
   reference it might drift from together with.

3. **It is what the original analysis was written against.** `docs/06-pitfalls.md`
   and the source reports quote line numbers and docstrings from this file.

## What is deliberately wrong in it

Read as a standalone artifact this file contains three claims that later
measurement overturned. They are left in place because sanitising a reference
snapshot destroys its value as a reference:

| claim in this file | what was measured later |
|---|---|
| "Requires flydsl >= 0.3.0" | **0.2.4 runs it**, whole matrix correct. The floor was an assumption. |
| dgrad must consume a transposed weight copy | A native NN pipeline exists; see the shipped kernel. |
| gpt-oss fc2 (`N == K == 2880`) first 1–2 calls corrupt | **Not reproduced** here across three `avg_m` values in fresh processes. Not "fixed" — not reproduced. The burn-3 convention was kept anyway; it costs nothing. |

`docs/06-pitfalls.md` covers all three.
