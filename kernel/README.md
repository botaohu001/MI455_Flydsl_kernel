# `kernel/` —— 可直接用的实现

| 文件 | 行数 | 内容 |
|---|--:|---|
| `grouped_gemm_bf16_kernel_mi455.py` | 2750 | **kernel 本体。** gfx1250 / MI455X 的全部三个算子，含原生 NN（dgrad）流水线。 |
| `grouped_gemm_bf16_dispatch.py` | 161 | arch 分发（`gfx950` / `gfx1250`），逐 arch 懒加载。 |
| `reference/grouped_gemm_bf16_kernel_gfx1250.py` | 2290 | 原生 NN 流水线**之前**的版本。逐字节保留，供 diff。 |

> 代码与注释保持英文：这些文件是要进 Primus-Turbo 上游 PR 的。

## 三个入口

```python
grouped_gemm_bf16_nt_flydsl_kernel(a, b, group_offs)          # fwd:   out[rows] = a[rows] @ b[g].T
grouped_gemm_bf16_nn_flydsl_kernel(a, b, group_offs)          # dgrad: out[rows] = a[rows] @ b[g]
grouped_gemm_bf16_variable_k_flydsl_kernel(a, b, group_k_offsets, masked_k=None)
                                                              # wgrad: out[g] = a[rows_g].T @ b[rows_g]
```

`a` 是 `[M_total, K]`，专家的 row-run 沿 `M` 拼接；`group_offs` 是 `[G+1]`
int64。NN 入口把 `b` 当作 `[G, K, N]` 并**原样读取** —— 默认路径上任何地方都
没有转置权重副本。

## 从 `reference/` 到交付 kernel 改了什么

在既有的 NT launcher 上加一个开关 `b_lds_transpose`。不是第三个 kernel。

```
$ diff <(git show <first-commit>:kernel/reference/...) kernel/grouped_gemm_bf16_kernel_mi455.py
499 insertions, 52 deletions
```

新增的 321 行非注释代码里，**125 行是 device 侧的 tile body**，全部在
`if const_expr(b_lds_transpose):` 之内。其余 196 行在 host 侧：原生 launch
路径、`_pick_config_nn`、`_nn_b_pad` 和 `nn_native_unsupported_reason`。
A 操作数、WMMA 调用、epilogue 和 grouped 控制逻辑**一行未动**。

`docs/04-native-nn-pipeline.md` 讲这次改动；`docs/02-dgrad-problem.md` 讲它
为什么必要。

## 落进 Primus-Turbo

两个文件都放到 `primus_turbo/flydsl/grouped_gemm/`，与 gfx950 kernel 同级。
`__init__.py` 保持纯 licence header —— 把分发放进去会让同目录任何一个 kernel
的 importer 都被迫付一次 arch 探测的代价。

然后在 `primus_turbo/pytorch/kernels/grouped_gemm/grouped_gemm_impl.py` 里，
**只把 arch gate 从 `is_gfx950()` 放宽是不够的**。有五处会 raise 而不是回退
Triton；`docs/06-pitfalls.md` §6.2 列出了它们，以及每一处需要补的负向
`can_handle` 条件。

## 许可证

Apache-2.0。每个文件头部的声明块（含 FlyDSL 与 Primus-Turbo 的 provenance
行）**逐字保留，必须保持原样**。完整链条见仓库根目录的 `NOTICE`。
