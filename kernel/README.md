# `kernel/` — the shippable implementation

| file | lines | what |
|---|--:|---|
| `grouped_gemm_bf16_kernel_mi455.py` | 2750 | **The kernel.** All three operators for gfx1250 / MI455X, including the native NN (dgrad) pipeline. |
| `grouped_gemm_bf16_dispatch.py` | 161 | Arch dispatch (`gfx950` / `gfx1250`) with lazy per-arch import. |
| `reference/grouped_gemm_bf16_kernel_gfx1250.py` | 2290 | The revision **before** the native NN pipeline. Kept byte-identical for diffing. |

## The three entry points

```python
grouped_gemm_bf16_nt_flydsl_kernel(a, b, group_offs)          # fwd:   out[rows] = a[rows] @ b[g].T
grouped_gemm_bf16_nn_flydsl_kernel(a, b, group_offs)          # dgrad: out[rows] = a[rows] @ b[g]
grouped_gemm_bf16_variable_k_flydsl_kernel(a, b, group_k_offsets, masked_k=None)
                                                              # wgrad: out[g] = a[rows_g].T @ b[rows_g]
```

`a` is `[M_total, K]` with expert row-runs concatenated along `M`; `group_offs` is
`[G+1]` int64. The NN entry takes `b` as `[G, K, N]` and **reads it in place** —
there is no transposed weight copy anywhere in the default path.

## What changed from `reference/` to the shipped kernel

One switch, `b_lds_transpose`, on the existing NT launcher. Not a third kernel.

```
$ diff <(git show <first-commit>:kernel/reference/...) kernel/grouped_gemm_bf16_kernel_mi455.py
499 insertions, 52 deletions
```

Of the 321 non-comment lines added, **125 are the device-side tile body**, all of
them inside `if const_expr(b_lds_transpose):`. The remaining 196 are host side:
the native launch path, `_pick_config_nn`, `_nn_b_pad` and
`nn_native_unsupported_reason`. The A operand, the WMMA calls, the epilogue and
the grouped control logic are **unchanged, zero lines**.

`docs/04-native-nn-pipeline.md` walks the change; `docs/02-dgrad-problem.md`
explains why it was needed at all.

## Dropping this into Primus-Turbo

Both files go to `primus_turbo/flydsl/grouped_gemm/`, next to the gfx950 kernel.
`__init__.py` stays a bare licence header — putting dispatch there would make
every importer of a sibling kernel pay for the arch probe.

Then in `primus_turbo/pytorch/kernels/grouped_gemm/grouped_gemm_impl.py`, widening
the arch gate from `is_gfx950()` is **not sufficient on its own**. Five things
raise instead of falling back to Triton; `docs/06-pitfalls.md` §"Integration
gates" lists them with the negative `can_handle` conditions each one needs.

## Licence

Apache-2.0. The header block at the top of each file, including the FlyDSL and
Primus-Turbo provenance lines, is preserved verbatim and must stay. See `NOTICE`
at the repository root for the full chain.
