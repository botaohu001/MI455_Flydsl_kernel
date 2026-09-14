# `probes/` —— 在动手之前把事实钉死

这里每个脚本回答一个当时还只是假设的问题。前两个是承重的。

> 脚本本身与其注释保持英文。

所有脚本的路径都相对仓库根目录解析，clone 到任何位置都能跑。除注明外都需要
**gfx1250 硬件**。

---

## `probe_nn_frag.py` —— 本仓库最重要的脚本

**问题：** 在 dgrad 的 tile 朝向下，`ds_load_tr16_b128` 的每条 lane 实际拿到
的是哪个源元素？

这件事在 ISA 调研里被标为 **[推断]** —— 从 wgrad 的实测行为出发的一小段推导，
从未跑过。在写下 NN 流水线的第一行代码之前，它被变成了 **[实测]**，因为这里的
失败模式让"猜"格外危险：给一个未对齐的地址，这条指令会**静默退化成不转置的
普通 load**，于是错误的 lane 模型会产出一个形状完全正确、数值全错、看上去很
合理的张量。

如果你要改写它，这些设计取舍很关键：

- LDS 由**真正的 TDM 拷贝**填充，不是手工填。被测的是整条路径，不是孤立的
  指令。
- 填充值是 **bf16 位模式** `0x2000 + flat_index` —— 全部是 normal finite 数。
  一旦涉及 denormal flush 或舍入，小整数填充可能因为错误的原因而通过。
- **两条独立判据。**（a）每条 lane 的 16 个元素对上闭式预测；（b）同一份数据
  按 NT 方式 stage 后用普通 `ds_read_b128` 读出，必须**逐位相同**。判据（b）
  不依赖推导是否正确，这正是设置它的全部意义。

**结果：** 4 种 tile 几何（32×64 / 64×128 / 128×64 / 64×64）、44 个 fragment ×
32 lane × 16 元素，全部逐位通过。

```
lane  0: n=[0]   k=[0..7, 16..23]
lane  1: n=[1]   k=[0..7, 16..23]
lane 31: n=[15]  k=[8..15, 24..31]
```

```bash
python probes/probe_nn_frag.py
```

预期输出见 `results/nn_pipeline/probe_nn_frag.out`。

---

## `isa/probe_global_tr.py` —— 硬件上的 `global_load_tr16_b128`

**问题：** gfx1250 上有没有 global 显存的转置读？它的 lane 语义是什么？

有。脚本用 `f16[i] = i` 填充显存，给 lane *l* 地址 `l * STEP`，然后报告每条
lane 收到了哪些源下标。单个 wave32 workgroup，**flydsl 0.2.4**，6 个 STEP 值
全部通过。

两个发现：

1. **lane 语义与 LDS 版完全相同** —— 8 条 lane 一组的 8×8 转置 —— 印证了 ISA
   把两者列为 "Global Equivalent"。
2. **它能容忍 LDS 版容忍不了的错位。** STEP = 9（18 B）和 STEP = 12（24 B）
   仍能正确转置，因为每条 lane 提供的是独立的 VMEM 地址，不受 LDS bank 约束。
   **这意味着任意 `N` 都能用，不必是 8 的倍数。**

这条路线被实测、被记录，然后**刻意不采用** ——
`docs/03-isa-investigation.md` §路线 5 讲了这笔账，而且它是接手这项工作的人
最该做的下一个实验。

---

## `isa/probe_isa.sh`、`isa/probe_isa2.sh` —— 汇编器接受什么

**不需要 GPU。** 纯粹的 `llvm-mc -mcpu=gfx1250` 编码/拒绝探测。对"这条指令在
这个 target 上存不存在"，这是最可信的答案，与家族级 ISA 手册怎么写无关。

它们确立的结论包括：`ds_load_tr16_b128` 在 gfx1250 上能编码、gfx950 上不能；
`ds_read_b64_tr_b16` 反之；偏移字段是 16-bit 无符号；任何拼法的 WMMA 转置
修饰符都不存在；`v_permlane16_swap_b32` 有而 `v_permlane32_swap_b32` 没有。

## `isa/pdf_extract.py` —— 可按行引用的 ISA 文本

**不需要 GPU。** 把公开发布的 CDNA5 ISA PDF 转成文本，这样章节可以按行号引用。
该 PDF 及其文本提取物**未在此转载**（见 `NOTICE`）；自行从 AMD 下载一份，
再把脚本指向它。

---

## `smoke_nn.py` —— 快速正确性门

单 expert → grouped → ragged → 不均衡，含 `G=1`、最小的 `K == N == 256`
shape，以及带**空 expert** 的 `lens=[1, 2047, 0, 33, 4096, 129]` 这类分布。
每个 case 都与 hoist 口径逐位比对。先跑它再跑 `benchmarks/check_full.py`；
它失败在秒级而不是分钟级。

## `probe_flydsl_symbols.py` —— flydsl 接口到底在不在？

**不需要 GPU，约一秒。** 检查这个 kernel 需要的、在 Primus-Turbo 里**一个先例
都没有**的 14 个 flydsl 符号，外加 12 条模块作用域 import。

它存在是因为版本号不是证据：同一条 flydsl 产品线在 0.2.x 到 0.3.x 之间
**删掉过一个公开子模块**（`flydsl.expr.buffer_ops`）。跑它正是确立
**0.2.4 才是真实地板**（而不是模块头声称的 0.3.0）的方式。见
`docs/06-pitfalls.md` §6.1。

## `probe_backends.py`、`probe_open_questions.py`

`probe_backends.py` 逐方向报告 Primus-Turbo 四个 backend 里哪些对给定 shape
声称 `can_handle`，以及强制它执行会发生什么。arch gate 就是这么摸清的。

`probe_open_questions.py` 覆盖 `G` 的上界与 `num_xcd` sweep —— 上游 notes 里
那两个"我们不知道"的条目。它确立了 **`MAX_G = 64` 是一个不能搬过来的 gfx950
实测值**：gfx1250 一直到 **G = 160** 都正确，包括 gfx950 明确失败的 G = 80 和
G = 96。
