# 3. ISA 调研：五条路线，四个否决，一个采用

问题：**gfx1250 上的 dgrad 能否不物化转置权重副本？如果能，怎么做？**

在写任何代码之前调研了五条路线。采用了一条。**四个否决与那一个采用写得一样
详细，这是有意的** —— 只看到赢家的读者会把死路重走一遍。

所有 ISA 章节引用均指 **AMD Instinct CDNA5 Instruction Set Architecture
Reference Guide**，由 AMD 公开发布，链接在 `NOTICE` 里。该文档未在此转载。
证据标注的定义见 `docs/01-architecture.md`。

有一条提醒适用于下文每一个只有 **[ISA]** 的结论：手册覆盖整个 CDNA5 家族，
gfx1250 只是其中一个 target。凡是没有 **[LLVM]** 或 **[实测]** 背书的条目，
都可能与这个具体实现有出入。

---

## 路线 1 —— 在 TDM 描述符里表达转置

**判定：不可能。是硬件层面，不是软件层面。[ISA] + [FLYDSL]**

TDM 的地址生成伪代码：

```
for Z = 0..D#.tile_dim2
  for Y = 0..D#.tile_dim1
    Maddr = D#.global_addr + D#.data_size * (y * tensor_dim0_stride + z * tensor_dim1_stride)
    for X = 0..D#.tile_dim0
        LDS[Laddr] = Memory[Maddr]      // data_size 个连续字节
        Maddr += dataSize               // <<< 最内层增量被硬编码
        Laddr += dataSize
```

最内层增量是写死的 `dataSize`。描述符的 stride 字段 ——
`tensor_dim[0-3]_stride` —— 分别乘在 `y`、`z`、`zz` 上，即**全是外层维度**。
二维地址表达式说得更直白：

```
global_addr[2d] = D#.global_addr + D#.data_size * (x + y * D#.tensor_dim0_stride)
```

`x` 的系数恒为 1。**TDM 在结构上就无法描述一个最内层非连续的 tile**，
自然也无法描述转置视图。

flydsl 与此一致，而且是独立佐证：`make_tdm_atom` 的文档写明 "the innermost
stride is assumed 1 and ignored"，实现里也直接丢弃它 ——

```python
for i in range(rank - 1):  # innermost stride assumed 1, not stored
```

—— **0.2.4 和 0.3.2 完全相同**，所以升级 flydsl 在这里不会带来任何变化。
**[FLYDSL]**

### 两个看着像出路但不是的 TDM 特性

- **Gather mode**（§10.11.3.2）。描述符 group 2/3 被换成一张行索引表，按索引
  抓行。但每一"行"仍然是 `height=1 × width=tile_dim0` 的**连续**一段，只是行的
  *选择*变随机了。要用它做转置就得令 `tile_dim0 = 1`，即一次抓 2 字节，而且
  一条指令最多带 16 个索引。不可行。**[ISA]**
- **Descriptor iteration**（§10.11.3.1）。`iterate_enable` 让同一个描述符每隔
  N 行抽一行、压实进 LDS。那是行抽取，不是转置。**[ISA]**

### 藏在这个否决里的正面发现

ISA 在两处（§10.11.2 和 §10.11.3）说明，TDM 的 LDS padding 存在是为了

> to facilitate matrix transpose operations or avoid LDS bank conflicts.

**"TDM 连续拷贝 → LDS padding → LDS 转置读"本来就是芯片设计者预设的转置
流水线。** 路线 1 走不通不是运气不好；架构是**刻意**把转置放在 LDS 读这一级的。
正是这个观察让路线 2 成为自然答案，而不是一个变通。

---

## 路线 2 —— 用 `ds_load_tr16_b128` 驱动 NN 流水线

**判定：采用。[LLVM] + [FLYDSL] + [实测]**

### 指令本身没有障碍

**[LLVM]** `llvm-mc -mcpu=gfx1250`：

| 指令 | gfx1250 | gfx950 |
|---|---|---|
| `ds_load_tr16_b128` | **OK** `[0x00,0x00,0xf0,0xdb,…]` | 拒绝 |
| `ds_load_tr8_b64` / `tr6_b96` / `tr4_b64` | OK | 拒绝 |
| `ds_read_b64_tr_b16` | 拒绝 | **OK** `[0x00,0x00,0xc6,0xd9,…]` |

两颗芯片，两套编码，能力等价。§11.2.4 把它们描述成同一件事：
"DS_LOAD_TR16_B128 — GLOBAL_LOAD_TR16_B128 — Load **A or B matrix** with
element-size of 16 bits into VGPRs from LDS and transpose."
注意 **"A or B matrix"** —— ISA 明确它同时服务两种操作数角色。

偏移字段：`offset:65535` 可编码，`offset:65536` 报 `expected a 16-bit unsigned
offset`。**[LLVM]**

flydsl 在 **0.2.4 和 0.3.2 两个版本**都导出 `rocdl.ds_load_tr16_b128`，另有
高层包装 `rocdl.lds_transpose_load(...)`。**[FLYDSL]**

### 承重的那个论断：wgrad 的转置与 dgrad 的转置同构

这是整个调研的关键。操作数对照表见 `docs/02-dgrad-problem.md` §2.1 第 2 步；
结论是 **wgrad 的操作数与 dgrad 的 B 操作数形状相同** —— 归约轴当行、输出轴当
连续的列 —— 而语义上的差别（token 还是 reduction index）在生成的代码里从不
出现。

现有的 wgrad 地址表达式字面上就是
`(归约行) * LDS_ROW + (输出列) * 2`。dgrad 的 B **一个字符都不用改**；
变的只是 `LDS_B_ROW` 的含义从"wgrad 输出轴 2 的宽度"变成"`tile_n`"。

### 它被当作实测来验证，而不是留作论证

原始调研把 lane 映射明确标为 **[推断]** 并说明了这一点。**把它变成 [实测] 是
实现的第一步**，就是 `probes/probe_nn_frag.py`。两条独立判据：

1. 每条 lane 的 16 个 fragment 元素对上闭式预测
   `frag[j] = b[ks*32 + kgrp*8 + (j%8) + 16*(j≥8)][wnb + wn*16 + lane16]`；
2. 同一份数据按 NT 方式（`[n,k]` 主序 stage + 普通 `ds_read_b128`）读一遍，
   必须**逐位相同** —— 这一条不依赖推导对不对。

**结果：4 种 tile 几何（32×64 / 64×128 / 128×64 / 64×64）、44 个 fragment ×
32 lane × 16 元素，全部逐位通过。** 实测到的映射：

```
lane  0: n=[0]   k=[0,1,2,3,4,5,6,7, 16,17,18,19,20,21,22,23]
lane  1: n=[1]   k=[0,1,2,3,4,5,6,7, 16,17,18,19,20,21,22,23]
lane 31: n=[15]  k=[8,9,...,15, 24,25,...,31]
```

填充值用的是 **bf16 位模式**（`0x2000 + flat_index`），这样每个元素都是
normal finite 数，不会被 flush 或规格化。用小整数填充的探针可能因为错误的原因
而通过。

### 白捡的两个坑

wgrad 已经在这个 tile 朝向下替它们付过账：

1. **TDM extent 从 `imm_offset` 起算，不是从描述符 base 起算。** B 的 k 循环
   沿*跨步*轴前进，不能像 NT 的 B 那样用 `imm_offset` 走。wgrad 的解法是每个
   k-tile 重建描述符、把行偏移折进 base、用 `imm_offset=0` 拷贝。dgrad 照抄。
2. **dim-1 extent 不约束 load 的寻址**（实测会 page fault）。dgrad 的 ragged 轴
   `N` 正好落在 dim 1。wgrad 的 `blk_n_eff` / `n_back` 退让窗口直接可用。

### 工作量估算，以及它兑现得如何

| 项 | 来源 | 估计 | 实际 |
|---|---|---|---|
| B 的 TDM 描述符换朝向 | wgrad `issue()` | ~15 行 | |
| B 的 LDS stage 几何 + `LDS_B_ROW` | wgrad | ~8 行 | |
| per-lane 转置读基址 | wgrad `b_lane` | ~8 行 | |
| `load_b` 换成 `_frag`/`_tr` | wgrad | ~20 行 | |
| 每 k-tile 重建描述符 + ragged-N 退让 | wgrad | ~20 行 | |
| A 侧、WMMA 调用、epilogue、grouped 控制 | NT | **0** | **0** |
| **device 侧合计** | | **~80** | **125** 行非注释 |
| host 侧（入口、`_pick_config_nn`、shape gate） | 新写 | 未估 | 196 |

对 device 侧 tile body 而言，~80 行的估计基本准确。上游那句"这等于第三个完整
kernel body"**高估了工作量** —— 正确的框架是 gfx950 已经在用的那个：一个
tile body、一个布尔开关。

---

## 路线 3 —— WMMA 有转置变体吗？

**判定：没有。[LLVM] + [ISA]**

在 `v_wmma_f32_16x16x32_bf16` 上试过的每个修饰符都被拒绝：

```
transpose_a:1                      -> error: not a valid operand.
trans_a:1                          -> error: not a valid operand.
matrix_a_fmt:MATRIX_FMT_BF16       -> error: not a valid operand.
matrix_a_scale:MATRIX_SCALE_ROW0   -> error: not a valid operand.
neg_lo:[1,0,0]                     -> error: invalid neg_lo operand
```

§7.12 Table 43 的 bf16 条目只有一种形状，没有转置变体：

```
V_WMMA_F32_16X16X32_BF16   Matrix A 16x32 BF16   Matrix B 32x16 BF16   C/Result 16x16 F32
```

gfx1250 接受的 56 个 WMMA/SWMMAC 助记符里，bf16 的只有
`v_wmma_f32_16x16x32_bf16`、`v_wmma_bf16_16x16x32_bf16`、
`v_wmma_bf16f32_16x16x32_bf16` 和稀疏的 `v_swmmac_*`，没有一个带转置语义。
flydsl 0.3.2 的 WMMA 修饰符表同样只有格式和取负/取绝对值，没有转置。
**[FLYDSL]**

---

## 路线 4 —— 代数出路

**判定：结构性不存在。[推断]，但推理是完整的。**

完整内容见 `docs/02-dgrad-problem.md` §2.4。一句话版本：**fwd 与 dgrad 需要
同一个数组的相反主序**，所以没有单一权重布局能同时服务两者，而
`(AᵀB)ᵀ = BᵀA` 不改变任何操作数沿归约轴的跨步。唯一*可以*表达的重排 ——
把 dgrad 拆成每个 group 一次 `G=1` 的 variable-K 调用、改为转置激活 ——
逐位正确，**慢 1.5×–10.5×**。这是实测的，不是假设的。

这条路线标为 **[推断]** 而不是 **[实测]**，是因为它断言的是"某种东西不可能
存在"。它的*后果*是被实测了的。

---

## 路线 5 —— `global_load_tr16_b128`：能用，但没用

**判定：可行，未采用。[ISA] + [LLVM] + [FLYDSL 0.2.4] + [实测]**

这是本次调研真正新的发现：存在一条转置读，能**直接从显存到 VGPR**，完全绕过
LDS。

§10.9，"WMMA Matrix Load Ops with Transpose"：

> **GLOBAL_LOAD_TR16_B128** — Load a 16x16 matrix of 16-bit data into VGPRs and
> **transpose between row-major and column-major order**. …
> Note these load-transpose instructions are **wave32-only**.

gfx1250 *就是* wave32，正好在适用范围内。`llvm-mc` 能编码
（`[0x7c,0xc0,0x15,0xee,…]`），而且 flydsl **0.2.4** 就已导出
`rocdl.global_load_tr_b128` → `rocdl.global.load.tr.b128`，文档注明
"Available in gfx1250+"。**[LLVM] [FLYDSL]**

### 它在硬件上被实测过

`probes/isa/probe_global_tr.py` 用 `f16[i] = i` 填充显存，给 lane *l* 地址
`l * STEP`，然后报告每条 lane 收到了哪些源下标。单个 wave32 workgroup，
flydsl 0.2.4，6 个 STEP 值全部通过：

```
===== global_load_tr16_b128, per-lane step = 8 elements (16 B) =====
  lane  0: [0, 8, 16, 24, 32, 40, 48, 56]
  lane  1: [1, 9, 17, 25, 33, 41, 49, 57]
  ...
  lane  7: [7, 15, 23, 31, 39, 47, 55, 63]
  --- group boundary ---
  lane  8: [64, 72, 80, 88, 96, 104, 112, 120]
  -> 8-lane-group 8x8 TRANSPOSE (same shape as ds_load_tr16_b128)
```

**lane 语义与 LDS 版完全相同**，印证了 ISA 把两者列为 "Global Equivalent"。

**有一条性质严格优于 LDS 版：** STEP = 9（18 B）和 STEP = 12（24 B）这两个
**非 16 字节对齐**的跨步仍然正确转置。LDS 版在错位时会静默退化成普通 load。
这里每条 lane 提供的是独立的 VMEM 地址，不受 LDS bank 约束 —— 也就是说
**任意 N 都能用，不必是 8 的倍数。** **[实测]**

用在 dgrad 上会长这样：每个 8-lane 组的 lane *j* 取
`b_slab + (k0+j)*N*2 + n0*2`，per-lane 跨步 `N` 个元素；lane *l* 于是持有
`b[g][k0..k0+7][n0+l]` —— 半个 WMMA B fragment，从显存直达寄存器。

### 为什么没有采用

**这是一个关于剩余收益空间的判断，不是一次否定它的实测。** 路线 2 调优后达到
hoist 口径的 0.979，只剩约 2% 的空间，而代价是确定的：

- **丢掉 TDM 异步流水。** 整个 multi-buffer 结构建立在 TDM + `tensor_wait` 上；
  `global_load_tr` 是普通 VMEM load（LOADcnt 追踪），要另起一套预取。
- **丢掉硬件 OOB clamp。** ragged N 和短尾 expert 现在靠 `tensor_extents`
  免费兜住；换成 VMEM load 就得手写 mask。
- **B 的复用从 LDS 降级到 L1/L2。** TDM→LDS 是每个 workgroup 取一次、所有 wave
  共享；per-lane VMEM 是每个 wave 各取各的。
- **VGPR 压力。** 转置读本来就比普通 `b128` 多吃地址寄存器；`frag_pipeline=1`
  时 wgrad 已经顶到 512 上限并 spill 了 3 个。

而当初推动它的那个场景 —— 小 `avg_m`、memory-bound 的 dgrad，LDS staging 可能
不划算 —— **恰恰是原生 NN 流水线已经达到甚至超过 hoist 口径的地方**
（deepseek fc2 @128 = 1.031，fc1 @128 = 0.978）。路线 2 越好，这条动机越弱。

**如果有人接手这项工作，这就是下一个该做的实验。**

### 同族的其它机制，都查了，都不行

| 机制 | 判定 | 级别 |
|---|---|---|
| `global_load_lds_*` / `GLOBAL_LOAD_ASYNC_TO_LDS_B{8,32,64,128}` | 存在；§10.8.1 伪代码是逐字节直拷，**无转置**。`global_load_lds_b128` 在 gfx1250 上根本不存在 | [ISA]+[LLVM] |
| `v_permlane16_swap_b32` | gfx1250 有 | [LLVM] |
| `v_permlane32_swap_b32` | gfx1250 **没有** | [LLVM] |
| `ds_bpermute_b32` / `v_permlane16_b32` / `ds_swizzle` | 有，但都是 32-bit 粒度的 lane 交换；手搓 bf16 转置要多条 VALU 加打包，成本远高于一条 `ds_load_tr16_b128` | [LLVM] |
| buffer load swizzle | gfx1250 走 TDM，这条路径上没有 SRD | [ISA] |

---

## 这一切要回答的那个核心问题

> gfx950 的 `ds_read_b64_tr_b16` NN 流水线到底做了什么，gfx1250 缺的是*指令*
> 本身，还是只是缺这段*代码*？

**只是缺代码。** 逐项对照：

| gfx950 需要的 | gfx1250 有没有？ | 级别 |
|---|---|---|
| 16-bit LDS 转置读指令 | **有** —— `ds_load_tr16_b128`；编码不同，能力等价，ISA 明说它服务 "A or B matrix" | [LLVM]+[ISA] |
| flydsl 能发出它 | **有** —— `rocdl.ds_load_tr16_b128`，0.2.4 就在 | [FLYDSL] |
| 这条指令的 lane 语义已确立 | **已确立** —— 实测过，记在 kernel 的 variable-K 节头部 | [实测] |
| 转置读喂 WMMA 已跑通 | **跑通过** —— 整条 wgrad 流水线在用，两个操作数都走它 | [实测] |
| "归约轴当行"的 LDS tile 朝向 | **有** —— wgrad 的 A/B stage | 源码 |
| 配套的 TDM 描述符写法 | **有** —— wgrad `issue()`，连 extent 陷阱和 ragged 退让都解决了 | 源码 |
| **把它们接起来的 NN 流水线** | **没有** ← 唯一缺的 | — |

原注释给了两个不做的理由：这等于第三个完整 kernel body，以及当时没有硬件可以
对照验证。**第二个理由随着芯片到位而失效。** **第一个高估了工作量** ——
它是一个 tile body 加一个布尔开关，gfx950 本来也是这么做的。

---

## 调研没有收口的地方

明说，好让读者知道底线在哪：

1. `global_load_tr16_b128` 的**吞吐、cache 行为、以及与 TDM 的计数器交互**
   从未测量。只测了 lane 语义。
2. 调研对原生 NN 流水线**没有做任何性能预测**，并且明说了这一点。NN 的 B 侧
   TDM 读是沿跨步轴取 tile，访存形态与 NT 不同；GEMM 本身会不会更慢被明确留作
   必须实测的事项。后来测了 —— 见 `docs/05-optimization-log.md`。慢 2.1%，
   而原因不是任何人猜的那个。
3. 只有 **[ISA]** 而没有 **[LLVM]** 背书的条目（TDM gather/iterate 的细节）
   可能与这个具体 target 有出入。TDM 最内层 stride 这条核心结论不在此列 ——
   它有 flydsl 的独立佐证。
