# `kernel/reference/` —— 改动前的快照

`grouped_gemm_bf16_kernel_gfx1250.py` 是**原生 NN 流水线出现之前**的 gfx1250
kernel，逐字节保留，这样改动可以被 diff 出来而不是靠描述。

```bash
diff -u kernel/reference/grouped_gemm_bf16_kernel_gfx1250.py \
        kernel/grouped_gemm_bf16_kernel_mi455.py
```

## 为什么保留它

三个理由，按有用程度排列：

1. **diff 本身就是文档。** 499 增 / 52 删，小到可以从头读完，而且它把
   `docs/04-native-nn-pipeline.md` 里"NN 流水线是 NT launcher 上的一个开关、
   不是第三个 kernel body"这个论断变成了具体的东西。

2. **它是正确性的 oracle。** `benchmarks/check_full.py` 在一个进程里同时加载
   *两个*模块，断言交付 kernel 的 fwd 和 wgrad 与它**逐位相同**，48/48。
   于是"没有回归"是两个实现之间的比对，而不是各自对着一个可能一起漂移的参考
   复算。

3. **当初的分析就是针对它写的。** `docs/06-pitfalls.md` 和那些原始报告引用的
   行号与 docstring 都来自这个文件。

## 它里面有哪些是故意留着的错

作为独立文件读，它包含三条后来被实测推翻的说法。之所以原样留着，是因为把一份
参考快照"洗干净"就毁掉了它作为参考的价值：

| 文件里的说法 | 后来的实测 |
|---|---|
| "Requires flydsl >= 0.3.0" | **0.2.4 能跑**，整个矩阵正确。那个地板是个假设。 |
| dgrad 必须消费一份转置权重副本 | 原生 NN 流水线存在；见交付的 kernel。 |
| gpt-oss fc2（`N == K == 2880`）头 1–2 次调用损坏 | 这里**没有复现**，三个 `avg_m` 值、全新进程都试过。不是"已修复"，是"没复现"。burn-3 的约定仍然保留了下来；它几乎不花钱。 |

三条都在 `docs/06-pitfalls.md` 里有交代。
