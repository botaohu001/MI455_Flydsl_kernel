# `asm/` —— 原生 NN 流水线的生成代码

一个代表性 shape 的编译产物。保留它们是因为 `docs/` 里有两个论断只能对着生成的
代码核对。

**Kernel：** grouped NN（dgrad），原生流水线，`b_lds_transpose=1`
**Shape：** qwen3-235b-a22b fc1，`avg_m=2048`，tile 256×256×128，mw2/nw2/nb2

| 文件 | 大小 | 为什么在这 |
|---|--:|---|
| `nn_native/21_final_isa.s` | 145 KB | 最终的 gfx1250 ISA。`docs/04-native-nn-pipeline.md` §4.5 里每一条指令组成的论断都是从它数出来的。 |
| `nn_native/20_llvm_ir.ll` | 213 KB | LLVM IR，指令选择前一步。当 ISA 与你的预期不符、需要判断是哪一侧引入的差异时有用。 |
| `nn_native/pipeline-digest.txt` | 4 KB | **全部 22 个阶段**的逐阶段算子计数，包括没有入库的那 20 个。 |

合计 **约 360 KB**。

---

## 排除了什么，为什么

flydsl 编译器每个 kernel 会 dump 22 个阶段。全量是这一个 kernel 的
**9.5 MB** —— 而且 23 个文件里**只有 13 个是不同的**，其余与前一个阶段逐字节
相同，因为那一趟 pass 在这个层面上什么都没改。中间的 MLIR 阶段有 11 个各
300–800 KB。

权衡下来：

- **它们完全可再生**，一条命令即可，在产出这里其它一切的同一套硬件上。
- **它们独有的诊断信息很少。** 你真正想从阶段 dump 里得到的，是"我期望的算子
  有没有活过 lowering、有几条"。`pipeline-digest.txt` 恰好对每个阶段回答了这个
  问题，用 4 KB 而不是 9.1 MB。
- **它们是用来 debug flydsl 的，不是用来读的。** 任何有理由逐行看
  `08_convert_fly_to_rocdl.mlir` 的人，本来就在编译自己的变体，要的是自己的
  dump 而不是这一份。
- **最终 ISA 不一样。** 它是能拍板性能问题的那个产物，体积小，而且**没有
  gfx1250 硬件的读者无法自行再生**。所以它入库。

`.gitignore` 强制了这个划分，本地跑一次 `FLYDSL_DUMP_IR=1` 不会误提交 9 MB。

## 全量再生

```bash
FLYDSL_DUMP_IR=1 FLYDSL_DEBUG_DUMP_ASM=1 FLYDSL_DUMP_DIR=asm \
  python benchmarks/dump_stats.py
```

`dump_stats.py` 会把三个 shape 各用两条路径（NT 吃 hoist 权重、原生 NN）编译
一遍，并打印寄存器/spill/指令组成的对比。阶段 dump 落在 `asm/<kernel-name>/`。

---

## 生成的代码说明了什么

**流水线 lowering 得很干净。** 128 条转置读和 512 条 WMMA 指令从
`00_origin.mlir` 到最终 ISA 活过了每一个阶段 —— 没有被折叠、复制或丢失。

**转置读是替换普通读，而不是叠加在它之上。** 最终 ISA 有 128 条
`ds_read_b128` 加 128 条转置读：**共 256 次 LDS 读，与 NT 路径的 256 次完全
相同。**

**寄存器压力就是这样被排除**在原生流水线那 2.1% 的解释之外的。来自
`dump_stats.py` 在一个 256×256×128 的 gpt-oss fc1 shape 上的结果：

| | NT (hoist) | 原生 NN |
|---|--:|--:|
| VGPR | 791 | **790** |
| VGPR / SGPR spill | 0 / 0 | **0 / 0** |
| scratch | 0 | **0** |
| WMMA | 512 | **512** |
| LDS 读 | 256 | **256**（128 普通 + 128 转置） |
| VALU | 853 | 846 |
| SALU / wait | 672 | **602** |
| 总指令 | 2378 | **2301** |

原生路径在寄存器使用基本相同的情况下**少发 77 条指令**，所以剩下的 2.1% 只能
是转置读本身的单指令代价 —— LDS 交叉开关或 bank 行为。不是代码膨胀，也不是
occupancy。

> 只有原生 NN 变体的 ISA 入了库。同一次运行里 `dump_stats.py` 也会生成 NT 的
> 那一份，如果你想直接 diff；上面这张表就是那个 diff 的结果。
