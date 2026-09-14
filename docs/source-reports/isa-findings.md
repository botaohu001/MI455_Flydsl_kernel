# gfx1250 (MI455X) 转置能力调研：dgrad 能否不物化显存转置副本

调研日期 2026-09-14。对象：`upstream/primus_turbo/grouped_gemm_bf16_kernel_gfx1250.py`
的 NN(dgrad) 路径目前走 `make_nn_weight_nt(b)` 物化 `[G,K,N] -> [G,N,K]` 副本，
deepseek-v3 权重 1.88 GB 下转置 ~2.9 ms 而 GEMM 本身仅 ~0.29 ms。

## 证据级别约定

全文每条结论都标级别，四级严格区分：

| 级别 | 含义 |
|---|---|
| **[DOC]** | CDNA5 ISA 手册写了。手册覆盖整个 CDNA5 家族，不等于 gfx1250 这个具体 target 有 |
| **[LLVM]** | 本机 LLVM 23.0.0git 的 `llvm-mc -mcpu=gfx1250` 能编码 / 拒绝。这是"指令到底存不存在"最可信来源 |
| **[FLYDSL]** | flydsl 能调用到（注明 0.2.4 / 0.3.2） |
| **[MEASURED]** | 我在这台 MI455X 上真跑出来了 |

复现材料都在本目录：`probe_isa.sh` / `probe_isa2.sh`（llvm-mc 探测）、
`probe_global_tr.py` + `probe_global_tr.out`（硬件实测）、
`pdf_extract.py` + `cdna5_isa.txt`（ISA 手册文本化）。

---

## 一句话结论

**有解，而且是两条解，都不需要显存转置副本。**

最有希望的是**路线 2**：`TDM(普通连续拷贝) -> LDS -> ds_load_tr16_b128`。
这条路线所需的每一个零件**都已经写在同一个文件里并且验证过了** —— B 操作数的加载器
就是 wgrad(variable-K) kernel 里那段代码，A 操作数的加载器就是 NT kernel 里那段代码。
dgrad 需要的 LDS 布局与 wgrad 的 B 操作数**完全同构**。

另外实测发现了一条项目里从没人用过的路：**`global_load_tr16_b128` 在 gfx1250 上可用，
可以直接从显存里以 WMMA 需要的朝向取出 `b[G,K,N]`，连 LDS 都不用过**。

对核心问题三的明确回答：**gfx1250 缺的不是指令，只是缺这段代码。**

---

## 路线 1：TDM 描述符能否表达转置视图 —— **不能，硬件层面堵死**

**结论：[DOC] + [FLYDSL]，确定性否定。**

ISA §10.11.2 给出 TDM 的地址生成伪代码（`cdna5_isa.txt:6332`）：

```
for Z = 0..D#.tile_dim2
  for Y = 0..D#.tile_dim1
    Maddr = D#.global_addr + D#.data_size * (y * tensor_dim0_stride + z * tensor_dim1_stride)
    for X = 0..D#.tile_dim0
        LDS[Laddr] = Memory[Maddr]      // data_size 个连续字节
        Maddr += dataSize               // <<< 最内层硬编码 +dataSize
        Laddr += dataSize
```

最内层 X 的地址增量是写死的 `dataSize`。描述符里的 stride 字段是
`tensor_dim[0-3]_stride`（Group 1，bit 207:160 起，`cdna5_isa.txt:6517`），
它们分别乘在 `y / z / zz` 上 —— **全是外层维度，没有任何字段作用在最内层**。
2D 地址式子写得很直白：

```
global_addr[2d] = D#.global_addr + D#.data_size * (x + y * D#.tensor_dim0_stride)
```

`x` 的系数恒为 1。所以 TDM 描述符**在结构上就无法描述一个最内层非连续的 tile**，
转置视图自然也无从表达。这是硬件限制，不是软件没做。

flydsl 的实现与硬件完全一致，`make_tdm_atom` 的 docstring 和代码都明说：

> ``strides`` is an optional list of per-dim strides in elements (same order);
> **the innermost stride is assumed 1 and ignored**, so entries for dims 0..rank-2 are used.

```python
for i in range(rank - 1):  # innermost stride assumed 1, not stored
```

**0.2.4 和 0.3.2 这段完全相同** —— 升级 flydsl 不会带来任何变化。[FLYDSL]

两个看着像但其实不是出路的 TDM 特性，都读了原文：

- **Gather mode**（§10.11.3.2）：描述符 group 2/3 改放一张行索引表，按索引抓行。
  但"每行"仍然是 `height=1 × width=tile_dim0` 的**连续**一段，只是行的选择变随机了。
  要用它做转置就得令 `tile_dim0 = 1`（一次抓 2 字节），而且一条指令最多 16 个 16-bit 索引。
  不可行。[DOC]
- **Descriptor iteration**（§10.11.3.1）：`iterate_enable` 让同一个 D# 隔 N 行抽一行、
  压实到 LDS。是行抽取，不是转置。[DOC]

反过来有一条**正面**信息值得记：ISA 两处明确说 TDM 的 LDS padding 就是为转置服务的
（`cdna5_isa.txt:6269` 和 `:6351`）：

> Tile data can be padded in LDS on a regular basis **to facilitate matrix transpose
> operations** or avoid LDS bank conflicts.

也就是说，**"TDM 连续搬运 + LDS padding + LDS 转置读"本来就是这颗芯片设计者预设的转置流水线**。
现有 wgrad kernel 的 `pad_interval` / `pad_amount=LDS_PAD=16` 正是在用这个机制。
路线 1 走不通不是意外，是架构把转置的职责放在了 LDS 读那一级。

---

## 路线 2：`ds_load_tr16_b128` 服务 NN 流水线 —— **可以，而且代码基本已存在**

**结论：[LLVM] + [FLYDSL] + [MEASURED，间接]。这是推荐路线。**

### 2.1 指令层面没有障碍

`llvm-mc -mcpu=gfx1250` 实测（`probe_isa.out`）：

| 指令 | gfx1250 | gfx950 |
|---|---|---|
| `ds_load_tr16_b128` | **OK** `[0x00,0x00,0xf0,0xdb,...]` | 不支持 |
| `ds_load_tr8_b64` / `tr6_b96` / `tr4_b64` | OK | 不支持 |
| `ds_read_b64_tr_b16` | 不支持 | **OK** `[0x00,0x00,0xc6,0xd9,...]` |

两颗芯片各有一套转置读，**编码不同、能力等价**。ISA §11.2.4 把它们描述成同一类东西
（`cdna5_isa.txt:6888`）：

> DS_LOAD_TR16_B128 — GLOBAL_LOAD_TR16_B128 — Load **A or B matrix** with
> element-size of 16bits into VGPRs from LDS and transpose.

注意 "**A or B matrix**" —— 手册明确它同时服务 A 和 B 两种操作数角色。

立即数字段：`offset:65535` 编码成功，`offset:65536` 报
`expected a 16-bit unsigned offset` —— 16-bit 无符号，和 kernel 里 `_tr()` 的注释一致。[LLVM]

flydsl 两个版本都导出 `rocdl.ds_load_tr16_b128`，另有高层包装
`rocdl.lds_transpose_load(result_type, lds_memref, elem_offset, elem_bytes)`。[FLYDSL 0.2.4 & 0.3.2]

### 2.2 关键问题：wgrad 的转置和 dgrad 的转置是不是同构的？—— **是，完全同构**

这是整个调研最重要的一点。用 NN 入口自己的记号（`grouped_gemm_bf16_nn_flydsl_kernel`
的契约）把三个 pass 的操作数摆平：

```
out[m,n] = Σ_k a[m,k] · b[g][k,n]        a:[M,K]    b:[G,K,N]
```

对每个操作数问同一个问题：**归约轴在内存里是行还是列？**

| pass | 操作数 | 内存形状 | 归约轴位置 | 需要的加载器 |
|---|---|---|---|---|
| fwd (NT) | `a[M,K]` | 行=m, 列=k | 列（连续） | `ds_read_b128` |
| fwd (NT) | `b_nt[G,N,K]` | 行=n, 列=k | 列（连续） | `ds_read_b128` |
| **dgrad (NN)** | `a[M,K]` | 行=m, 列=k | 列（连续） | `ds_read_b128` ← **NT kernel 现成的** |
| **dgrad (NN)** | `b[G,K,N]` | 行=k, 列=n | **行（跨步）** | `ds_load_tr16_b128` ← **wgrad 现成的** |
| wgrad | `A[M,OUT_M]` | 行=m, 列=i | **行（跨步）** | `ds_load_tr16_b128` |
| wgrad | `B[M,OUT_N]` | 行=m, 列=j | **行（跨步）** | `ds_load_tr16_b128` |

wgrad 的两个操作数和 dgrad 的 B 操作数是**同一种形状**：
**归约轴当行、输出轴当连续的列**。区别只是行的语义（wgrad 是 token m，dgrad 是 reduction k），
而 kernel 代码里这个语义根本不出现 —— 只有 `LDS_ROW` 和列偏移。

对照 wgrad 里的实际代码（`grouped_gemm_bf16_kernel_gfx1250.py:710`、`:893`）：

```710:714:<repo>/kernel/reference/grouped_gemm_bf16_kernel_gfx1250.py
    # LDS runs [tile_k rows of m] x [output-index columns]; the transpose read
    # needs every row base 16-byte aligned, so the pad is in bytes.
    LDS_PAD = 16
    LDS_A_ROW = tile_m * EB + LDS_PAD  # A tile: columns are output axis 0
    LDS_B_ROW = tile_n * EB + LDS_PAD  # B tile: columns are output axis 1
```

```893:897:<repo>/kernel/reference/grouped_gemm_bf16_kernel_gfx1250.py
        b_lane = (
            (l8 + kgrp * fx.Int32(8)) * fx.Int32(LDS_B_ROW)
            + (wnb + hi8 * fx.Int32(8) + k_back) * fx.Int32(EB)
            + fx.Int32(STAGE_A)
        )
```

`(归约行) * LDS_ROW + (输出列) * 2`。dgrad 的 B 操作数要的地址，一个字符都不用改，
只需把 `LDS_B_ROW` 的含义从 "wgrad 输出轴 2 的宽度" 换成 "tile_n"。

再验一遍 lane 语义能对上。kernel 头部实测记录的 `ds_load_tr16_b128` 行为
（`:622`–`:648`，empirically determined）：

> 8 条 lane 一组，lane j 供一个地址 a_j 指向 8 个连续 16-bit 元素；硬件做 8×8 转置，
> lane l 拿到 `{a_j + l : j = 0..7}`。

代入 dgrad：令 `a_j = &b[g][k0+j][n0]`（LDS 里就是 `(k0+j)*LDS_B_ROW + n0*2`），
则 lane l 拿到 `b[g][k0+0..7][n0+l]` —— **固定输出列 n0+l，8 个连续归约 k**。
这正是 WMMA B 操作数的半个 fragment。`_frag()` 再取一次偏 16 行的做第二半，
凑成 `0..7, 16..23` 的 fragment 顺序，和 NT kernel 一致。

**所以 wgrad 的 B 路径（TDM 描述符 + lane base + `_frag`/`_tr`）就是 dgrad 的 B 路径。**

### 2.3 顺带解决的两个坑

wgrad 已经替这个 tile 朝向踩过了 UPSTREAM_NOTES §5 里的两个坑，dgrad 直接继承：

1. **TDM extent 从 `imm_offset` 起算，不是从描述符 base 起算**。B 的 k 循环是沿**跨步轴**
   前进的，不能用 `imm_offset` 走（NT kernel 的 B 沿连续轴走才可以）。wgrad 的解法是
   每个 k-tile 重建描述符、把行偏移折进 base、`imm_offset=0`（`:822`–`:843`）。dgrad 必须照抄。
2. **dim-1 extent 在 load 上不约束寻址（实测会 page fault）**。dgrad 的 N 是 ragged 轴，
   正好落在 dim-1。wgrad 的 `blk_n_eff` / `n_back` 退让窗口技巧（`:774`–`:805`）直接可用。

### 2.4 工作量

不是"第三个完整 kernel body"。文件里 `_launch_grouped_gemm_bf16_nt` 是 1349–1748（约 400 行），
`_launch_grouped_bf16_variable_k` 是 653–1110（约 458 行）。NN 需要动的只有 B 侧：

| 要改的东西 | 来源 | 量级 |
|---|---|---|
| B 的 TDM 描述符从 `(B_ROWS, KB)` 行=n 改成 `(tile_k, tile_n*EB)` 行=k | wgrad `issue()` | ~15 行 |
| B 的 LDS stage 几何 `[tile_k][tile_n]` + `LDS_B_ROW` padding | wgrad | ~8 行 |
| B 的 per-lane 转置读基址（`l8`/`hi8`/`kgrp`） | wgrad `b_lane` | ~8 行 |
| `load_b` 换成 `_frag`/`_tr` | wgrad | ~20 行 |
| 每 k-tile 重建 B 描述符 + ragged-N 退让 | wgrad | ~20 行 |
| A 侧、WMMA 调用、epilogue、grouped 控制逻辑 | NT kernel | **0 行**（原样） |

**真正新写的逻辑 ~80 行，全部是从同一文件里搬过来改名。**
gfx950 正是这么组织的 —— 它的 `gemm_bf16_nn_tile` 用一个 `a_transpose` 布尔在两个
loader 之间切换（`Primus-Turbo/primus_turbo/flydsl/gemm/gemm_bf16_kernel.py:575`），
同一个 tile body 服务 NT 和 NN。gfx1250 可以给 NT launcher 加一个
`b_lds_transpose: Constexpr[int]` 开关走同样的路子。

---

## 路线 3：WMMA 有没有转置变体 —— **没有**

**结论：[LLVM] + [DOC]，确定性否定。**

`llvm-mc -mcpu=gfx1250` 对 `v_wmma_f32_16x16x32_bf16` 试了各种修饰符，全部被拒：

```
transpose_a:1                      -> error: not a valid operand.
trans_a:1                          -> error: not a valid operand.
matrix_a_fmt:MATRIX_FMT_BF16       -> error: not a valid operand.
matrix_a_scale:MATRIX_SCALE_ROW0   -> error: not a valid operand.
neg_lo:[1,0,0]                     -> error: invalid neg_lo operand
```

ISA §7.12 Table 43 的 bf16 条目也只有一种形状，没有转置变体：

```
V_WMMA_F32_16X16X32_BF16   Matrix A 16x32 BF16   Matrix B 32x16 BF16   C/Result 16x16 F32
```

全 target 的 WMMA/SWMMAC 助记符共 56 个 gfx1250 可接受（`probe_isa2.out` C 节），
bf16 的只有 `v_wmma_f32_16x16x32_bf16` / `v_wmma_bf16_16x16x32_bf16` /
`v_wmma_bf16f32_16x16x32_bf16` / `v_swmmac_*`（稀疏），没有任何一个带转置语义。

flydsl 0.3.2 新增的 WMMA 修饰符表也只有格式和取负/取绝对值，没有转置：[FLYDSL]

```
_WMMA_FMT_INT_TO_KW  = {0:'fp8_e4m3', 1:'fp8_e5m2', 2:'fp6_e2m3', 3:'fp6_e3m2', 4:'fp4_e2m1'}
_WMMA_MODC_INT_TO_KW = {0:'none', 1:'neg', 2:'abs', 3:'neg_abs'}
```

---

## 路线 4：代数出路 —— **没有，而且可以证明没有**

**结论：结构性否定（推理，非实验）。**

WMMA 对 A 和 B **两个**操作数都要求归约轴连续（就是 NT 形式）。
`trans_c` 在 wgrad 上能零成本绕过，是因为 C 的布局是**输出**，写哪儿是自由选择。
dgrad 的问题在**输入** `b` 的存储朝向上，任何对等式的重排都不会改变 `b` 在显存里怎么躺着。

更强的一条：**不存在任何单一权重存储布局能同时让 fwd 和 dgrad 都归约轴连续。**
用 autograd 记号（`W[g]` 逻辑上是 `[N,K]`）：

| pass | 归约轴 | `W` 存 `[G,N,K]` | `W` 存 `[G,K,N]` |
|---|---|---|---|
| fwd `y = x·Wᵀ` | k | k 连续 ✓ | k 跨步 ✗ |
| dgrad `dx = dy·W` | n | n 跨步 ✗ | n 连续 ✓ |

两个 pass 需要同一个数组的**相反主序**。这就是这颗芯片为什么要有转置读指令。
`daᵀ = bᵀ·doutᵀ` 之类的变换只是把"谁当 A 谁当 B"换了，两个操作数的归约轴连续性要求不变，
换完 `b` 还是跨步。**当前的 `b_nt` hoisting 已经是这条路线的最优解**（把转置摊到
每个 optimizer step 一次），再往下没有代数空间。

---

## 路线 5：其它搬运途中改布局的机制 —— **`global_load_tr16_b128` 真的可以，实测过了**

**结论：[DOC] + [LLVM] + [FLYDSL 0.2.4] + [MEASURED]。这是本次调研的新发现。**

### 5.1 它存在，而且能编码

ISA §10.9（`cdna5_isa.txt:6176`）："WMMA Matrix Load Ops with **Transpose**"：

> **GLOBAL_LOAD_TR16_B128** — Load a 16x16 matrix of 16-bit data into VGPRs and
> **transpose between row-major and column-major order**. This instruction loads
> data into 4 consecutive VGPRs.
>
> All fields of these instructions are identical to GLOBAL_LOAD_B64 and _B128,
> and as loads they are tracked with LOADcnt.
>
> Note these load-transpose instructions are **wave32-only**.

gfx1250 就是 wave32，正好落在适用范围里。`llvm-mc` 编码成功：
`global_load_tr16_b128 v[0:3], v[4:5], off` → `[0x7c,0xc0,0x15,0xee,...]`（`global_load_tr_b128`
是同一编码的别名）。[LLVM]

flydsl 0.2.4 就导出了 `rocdl.global_load_tr_b128`，落到 MLIR op `rocdl.global.load.tr.b128`，
doc 注明 "Available in gfx1250+"。[FLYDSL]

### 5.2 实测：在这台机器上真跑通了，语义和 LDS 版一致

`probe_global_tr.py` 用和当年确定 `ds_load_tr16_b128` 一样的办法：显存填
`f16[i] = i`，lane l 的地址取 `l * STEP` 个元素，看每条 lane 最后拿到哪些源下标。
**单 wave32 workgroup，flydsl 0.2.4，gfx1250，全部 6 组 STEP 都通过**：

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

即 lane l 拿到 `{a_j + (l mod 8) : j = 0..7}`，**与 kernel 里记录的 `ds_load_tr16_b128`
lane 语义完全相同**。这直接印证了 ISA 把两者列为 "Global Equivalent"。

**一个比 LDS 版更好的性质**：STEP = 9（18 B）和 STEP = 12（24 B）这两个**非 16 字节对齐**
的跨步也**正确转置**了。LDS 版在错位时会悄悄退化成普通 128-bit load（kernel 注释里记了这个坑），
global 版没有这个限制 —— 因为每条 lane 的地址是独立的 VMEM 地址，不受 LDS bank 约束。
**这意味着任意 N（不必是 8 的倍数）都能用。**[MEASURED]

### 5.3 直接用在 dgrad 上长什么样

`b[g]` 是 `[K,N]` 行主序。让 8 lane 一组的 lane j 取地址
`b_slab + (k0+j)*N*2 + n0*2`（per-lane 跨步 = N 个元素），
lane l 就拿到 `b[g][k0..k0+7][n0+l]` —— 固定输出列、8 个连续归约 k，
**正是 WMMA B fragment 的一半，从显存直接到 VGPR，不过 LDS，不物化任何副本**。

### 5.4 但它不是首选，原因要讲清楚

- **丢掉 TDM 异步流水**。整个 kernel 的 multi-buffer pipeline 建立在 TDM +
  `tensor_wait` 上；`global_load_tr` 是普通 VMEM load（LOADcnt），要另起一套预取。
- **丢掉硬件 OOB clamp**。ragged N / 短尾 expert 现在靠 TDM 的 `tensor_extents` 免费兜住，
  换成 VMEM load 就得手写 mask。
- **B 的复用从 LDS 降级到 L1/L2**。TDM→LDS 是每个 workgroup 搬一次、所有 wave 共享；
  per-lane VMEM load 是每个 wave 各读各的。
- **VGPR 压力**。wgrad 那节注释已经说了转置读比普通 b128 读多吃地址寄存器，
  `frag_pipeline=1` 时已经顶到 512 上限还 spill 了 3 个。

所以定位：**路线 5 是路线 2 的补充**，在 M 很小、LDS staging 不划算的
memory-bound dgrad 上可能反超，值得作为第二个变体去量；但主推路线还是 2。

### 5.5 同组其它机制，都查了，都不行

| 机制 | 结论 | 级别 |
|---|---|---|
| `global_load_lds_*` / `GLOBAL_LOAD_ASYNC_TO_LDS_B{8,32,64,128}` | 存在，但 ISA §10.8.1 伪代码是逐字节直拷，**无转置**；`global_load_lds_b128` 助记符在 gfx1250 上根本不存在 | [DOC]+[LLVM] |
| `v_permlane16_swap_b32` | gfx1250 有 | [LLVM] |
| `v_permlane32_swap_b32` | gfx1250 **没有**（WRONG-TARGET） | [LLVM] |
| `ds_bpermute_b32` / `v_permlane16_b32` / `ds_swizzle` | 有，但都是 32-bit 粒度的 lane 交换，用它们手搓 bf16 转置要多条 VALU + 打包，成本远高于一条 `ds_load_tr16_b128` | [LLVM] |
| buffer load swizzle | gfx1250 走 TDM，这条路径上没有 SRD | [DOC] |

---

## 核心问题三的明确回答

> **gfx950 的 `ds_read_b64_tr_b16` NN 流水线到底做了什么，gfx1250 缺的是指令本身、还是只是缺这段代码？**

**缺的只是代码。指令本身 gfx1250 有等价物，而且这个文件里已经在用了。**

先把 gfx950 那边核实清楚（源码级，不是听说）。kernel 注释里写的
`S2RLoaderTr16x32Bf16` 这个类名在 `gemm_helper.py` 里**不存在**，实际的类叫
`S2RLoaderTr16x32Bf16Wide`（只是个笔误，不影响结论）。它做的事：

```2080:2084:<repo>/Primus-Turbo/primus_turbo/flydsl/utils/gemm_helper.py
def _packed_ds_read_tr16(base_ptr, byte_offsets):
    n = len(byte_offsets)
    v2i32 = ir.VectorType.get([2], ir.IntegerType.get_signless(32))
    struct_t = _llvm.StructType.get_literal([v2i32] * n)
    asm = "\n".join(f"ds_read_b64_tr_b16 ${k}, ${n} offset:{byte_offsets[k]}" for k in range(n))
```

即一块 inline asm 打包若干条 `ds_read_b64_tr_b16`，共用一个基址 VGPR，各带编译期立即数偏移
（和 gfx1250 wgrad 里 `_tr()` 共用 `addr` + const offset 的动机一模一样）。

gfx950 的 NN tile 怎么用它（`gemm_bf16_kernel.py:575`–`:582`）：

```575:582:<repo>/Primus-Turbo/primus_turbo/flydsl/gemm/gemm_bf16_kernel.py
        a_s2r = S2RLoaderTr16x32Bf16Wide(w_m, n_a16) if a_transpose else S2RLoader16x16Bf16(w_m, n_a16)
        dense_mma_pipeline_bf16(
            lds,
            a_g2s,
            b_g2s,
            a_s2r,
            S2RLoaderTr16x32Bf16Wide(w_n, n_b16),
            Mfma16x16x32(n_a16, n_b16, ab_ty),
```

对照 NT tile（同文件 `:446`）用的是 `S2RLoader16x16Bf16(w_m, n_a16)` /
`S2RLoader16x16Bf16(w_n, n_b16)` 两个**非转置**loader。

**所以 gfx950 的 NN 相对 NT 的全部差别就两处：B 的 S2R loader 换成转置版，
外加配套的 global swizzle 换成 `compute_global_swizzle_nn_bf16_wide`。
不是另写一个 kernel，是同一个 tile body 换一个 loader。**

gfx1250 这边逐项对照：

| gfx950 需要的 | gfx1250 有没有 | 级别 |
|---|---|---|
| 16-bit LDS 转置读指令 | **有**：`ds_load_tr16_b128`（编码不同，能力等价，ISA 明说服务 "A or B matrix"） | [LLVM]+[DOC] |
| flydsl 调得到 | **有**：`rocdl.ds_load_tr16_b128`，0.2.4 就有 | [FLYDSL] |
| 这条指令的 lane 语义摸清了 | **摸清了**，就写在 kernel `:622`–`:648`，是实测的 | [MEASURED，前人] |
| 转置读喂 WMMA 跑通过 | **跑通过**，wgrad 整条流水线在用，两个操作数都是转置读 | [MEASURED，前人] |
| "归约轴当行"的 LDS tile 朝向 | **有**，wgrad 的 A/B stage 就是这个朝向 | 源码 |
| 对应的 TDM 描述符写法 | **有**，wgrad `issue()`；连 extent 陷阱和 ragged 退让都解决了 | 源码 |
| 一条 NN 流水线把它们接起来 | **没有** ← 唯一缺的 | — |

原注释说"那等于第三个完整 kernel body，而且当时没有硬件可以对照验证"。
第二个理由现在不成立了（硬件在手，4 张卡）。第一个理由**高估了工作量**：
B 侧要新写的逻辑约 80 行，全部可从同文件的 wgrad 搬运，A 侧/WMMA/epilogue/grouped
控制逻辑一行不用动。

---

## 最小可验证原型草案（只给方案，不实现）

目标：在不碰 `Primus-Turbo` 仓库的前提下，用最小代价证明"NN 流水线能算对"。
建议放 `isa_study/proto_nn/`，从 kernel 文件 import 或复制，不改原文件。

### 阶段 A —— 先验 fragment，不碰流水线（~1 小时，风险最低）

单 workgroup micro-kernel，只回答一个问题：
*"把 `b[K,N]` 的一个 tile 用普通 TDM 拷进 LDS，再用 wgrad 的 `b_lane` + `_frag` 读出来，
拿到的 16 个元素是不是 WMMA B 操作数期望的那 16 个？"*

- 输入：`b` 为 `[tile_k, tile_n]` 的 bf16，填 `b[k][n] = k*1000 + n`（bf16 精度不够就改填
  可精确表示的小整数，或用 `f16` + `arange`，做法同 `probe_global_tr.py`）。
- TDM：`_gv(gB, 0, (tile_k, tile_n*EB), (tile_n*EB, 1))` + `make_tdm_atom(..., [tile_k, None],
  strides=[tile_n*EB, None], pad_interval=tile_n*EB, pad_amount=16)` —— 与 wgrad `_tdm()` 同形。
- 读：照抄 wgrad 的 `b_lane` 和 `_frag(b_addr, LDS_B_ROW, ks*32, wn*16*EB)`。
- 断言：lane l、fragment 元素 j 应等于 `b[k_base + kmap(j, kgrp)][n_base + l%16]`，
  `kmap` 取 `0..7, 16..23`（见 kernel `:647`）。
- **通过标准**：全 32 lane × 16 元素逐个 bit 相等。

这一步把"同构"从推理变成实测，是整个方案的地基。失败就立刻停，不用往下走。

### 阶段 B —— 单 expert、单 tile 的完整 NN（~半天）

在 `_launch_grouped_gemm_bf16_nt` 的副本上加 `b_lds_transpose: Constexpr[int] = 0`：

```
if const_expr(b_lds_transpose):
    # B tile = [tile_k rows of k] x [tile_n cols of n]
    #   - 描述符每 k-tile 重建，行偏移折进 base，imm_offset=0   (wgrad issue())
    #   - ragged N 用 blk_n_eff / n_back 退让窗口              (wgrad :774-:805)
    #   - lane base = (l8 + kgrp*8)*LDS_B_ROW + (wnb + hi8*8 + n_back)*EB
    #   - load_b = _frag(b_addr, LDS_B_ROW, ks*WMMA_K, wn*WMMA_N*EB)
else:
    ... 现有 NT 的 B 路径原样 ...
```

A 侧、`wmma_atom`、`fx.gemm` 调用顺序（`wt[wn], act[wm]`）、epilogue 全不动。

- 先用 `G=1`、`M/N/K` 都整除 tile、`masked_k=None` 的规整形状。
- 对照：`torch.matmul(a.float(), b[0].float())`，容差按 kernel 里记的 bf16 噪声地板 0.1409%。
- **注意**：`gpt-oss fc2 (N==K==2880)` 那个"头 1–2 次调用结果损坏"的已知问题，
  correctness harness 要烧掉 3 次调用查第 4 次。

### 阶段 C —— 接回 grouped + ragged（~半天）

放开 `G>1`、ragged N、短尾 expert，重点压 `N % tile_n != 0`（验 `n_back` 退让）
和 expert 长度不整除 `tile_m`（验 dim-0 extent）。

### 阶段 D —— 量收益（~半天）

与现有 `make_nn_weight_nt(b) + NT` 在**同一个 timer 内**比。
UPSTREAM_NOTES §4a 记过这个 calibre 陷阱：转置不进 timer 会让对照组虚高 16.3%。
- 基线 1：`make_nn_weight_nt` + NT（转置计时内）← 当前默认行为
- 基线 2：`b_nt` 已 hoist 的 NT（转置不计时）← 真实训练循环里的上限
- 新路径：原生 NN
预期落在两者之间；若能逼近基线 2 就是完胜（省掉 1.88 GB 的副本和 2.9 ms）。

### 可选阶段 E —— `global_load_tr16_b128` 变体

B 完全不过 LDS，per-lane 地址 `b_slab + (k0+j)*N*2 + n0*2`，跨步 = N 元素（实测任意 N 都行）。
需要自己写 ragged N 的 mask 和预取。只在阶段 D 显示 LDS staging 是瓶颈时才值得做。

---

## 需要注意的遗留不确定项

诚实列出没能确认到实测级的东西：

1. **`ds_load_tr16_b128` 喂 dgrad B 的 lane 映射**是我按 kernel 里实测记录的 8×8 组转置
   语义**推导**的，不是跑出来的。推导链很短且 wgrad 的 B 路径形状相同，但**阶段 A 就是为了
   把它变成实测**。在阶段 A 通过之前，这条是推理级，不是实测级。
2. **性能没有任何预测**。我没量过原生 NN 流水线的速度。唯一能说的是它省掉了
   1.88 GB 显存副本和 2.9 ms —— 但 NN 的 B 操作数 TDM 读是沿跨步轴取 tile，
   访存形态与 NT 不同，GEMM 本身可能比 NT 慢。这必须实测，不能推。
3. **`global_load_tr16_b128` 只验了 lane 语义**，没验它在真实 GEMM 里的吞吐、
   cache 行为、与 TDM 混用时的计数器交互。
4. ISA 手册是 **CDNA5 家族**文档，gfx1250 是其中一个具体 target。凡是只有 [DOC] 没有
   [LLVM] 背书的条目（TDM gather/iterate 的细节）都可能与 gfx1250 实现有出入。
   TDM 最内层 stride 这条核心结论有 flydsl 实现独立佐证，可信度高。
