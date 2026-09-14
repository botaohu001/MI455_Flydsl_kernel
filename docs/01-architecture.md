# 1. gfx1250 vs gfx950：为什么思路可搬、代码不可搬

这篇回答的是："我们在 MI355X 上有一个能跑的 grouped GEMM，多少能在 MI455X 上
复用？"

简短答案：**grouped 控制逻辑，以及仅此而已。** gfx950 的 tile body 所依赖的每
一个 primitive，在 gfx1250 上都有一个**形状不同**（而不是名字不同）的对应物。
逐行移植不可能；逐概念移植花了约 2300 行。

本仓库全文使用的证据标注：

| 标注 | 含义 |
|---|---|
| **[实测]** | 在本项目中于 MI455X (gfx1250) 上真跑出来的 |
| **[ISA]** | 公开发布的 CDNA5 ISA 手册里写了（链接见 `NOTICE`） |
| **[LLVM]** | `llvm-mc -mcpu=gfx1250` 能编码或拒绝 |
| **[FLYDSL]** | 存在于 flydsl 的 Python 接口中，注明版本 |
| **[推断]** | 由以上推理得出；**没有**实测 |

---

## 1.1 逐项对照表

| 关注点 | gfx950 / MI355X | gfx1250 / MI455X | 可搬？ |
|---|---|---|---|
| wave 宽度 | 64 | **32** | 否 —— 每一处 lane 索引表达式都要改 |
| 矩阵引擎 | MFMA `Mfma16x16x32` | **WMMA** `rocdl.WMMA(16,16,32)` | 否 —— 不同指令族 |
| 每 lane 累加器 | `m*n // 64` = 4 × f32 | **8 × f32**（`m*n // 32`） | 否 —— 由 wave32 决定 |
| 累加器存放 | AGPR（`agpr_alloc`） | **只有 VGPR** | 否 —— gfx12 根本没有 AGPR |
| global → LDS | `buffer_load` + SRD | **TDM** 引擎，整 tile 异步 DMA | 否 —— 不同引擎 |
| 地址生成 | 手算 lane swizzle | **TDM 自己算地址** | 否 —— swizzle 代码直接变成死代码 |
| ragged / OOB clamp | SRD `num_records` | **TDM `tensor_extents`**（两个轴，不对称） | 否 —— 而且那个不对称是个陷阱，见 §1.4 |
| LDS → 寄存器，普通读 | `ds_read_b128` | `ds_read_b128` | **是** |
| LDS → 寄存器，转置读 | `ds_read_b64_tr_b16` | **`ds_load_tr16_b128`** | 否 —— **lane 语义不同**，见 §1.3 |
| barrier / fence | `s_barrier` + `lgkmcnt` | **`tdm_ops.tensor_wait` + `gpu.barrier`** | 否 |
| 每 CU 的 LDS | 160 KB | **320 KB** | 所有 tile 预算都要重算 |
| 调度控制 | `make_value_attrs(waves_per_eu, agpr_alloc, …)` | `compile_hints["llvm_options"]` | 否 —— `agpr_alloc` 已无意义 |

活下来的部分：M-tile 表、per-expert rebasing、tile → (expert, block_m, block_n)
解码、XCD remap。这些都是对 program ID 做整数运算，与矩阵引擎无关。大约 60 行，
也就是共享面的全部。

**这就是为什么两个实现是两个文件而不是一个 `if arch ==`。** 文件内分支会变成
同一个 `def` 下两段毫无交集的函数体，而且会把 2200 行 gfx9 的 MFMA/DPP/SRD
primitive 拖进一个只服务 gfx1250 的模块的 import 图。由此产生的分发逻辑见
`kernel/grouped_gemm_bf16_dispatch.py`。

---

## 1.2 唯一一处免费映射过来的结构

gfx1250 的 dense GEMM 本来就用 TDM 描述符的 dim-0 extent 来 clamp ragged 的
`M`。而 grouped GEMM 的"某个 expert 的最后一个 tile 是短的"**恰好就是**同一个
问题。于是每个 expert 的行数被直接喂进那个 extent：**不需要任何 masking 代码，
也不需要第二类 tile。**

gfx950 版用 SRD `num_records` 玩的是同一个结构性技巧。机制完全不同，思路完全
相同 —— 这正是本文的主题。

有一个推论值得记住：gfx950 的象限 masking 辅助函数 `_tail_quad_conds` 在这里
没有对应物。它的存在是因为 MFMA 累加器的 4 象限布局，而硬件 extent 让它变得
不必要。**如果移植过来的代码还保留着一个不再需要的 masking 辅助函数，那就是
移植做得太机械的信号。**

---

## 1.3 转置读：同样的活，不同的 lane 语义

两颗芯片都有硬件 LDS 转置读，很容易把它们当成同一条指令的两个名字。**不是。**

| | gfx950 | gfx1250 |
|---|---|---|
| 助记符 | `ds_read_b64_tr_b16` | `ds_load_tr16_b128` |
| `llvm-mc -mcpu=gfx1250` 接受？ | **否** | **是** `[0x00,0x00,0xf0,0xdb,…]` **[LLVM]** |
| `llvm-mc -mcpu=gfx950` 接受？ | **是** `[0x00,0x00,0xc6,0xd9,…]` | 否 **[LLVM]** |
| flydsl 怎么调到 | inline asm，由 `S2RLoaderTr16x32Bf16Wide` 打包 | `rocdl.ds_load_tr16_b128`，**0.2.4** 就有 **[FLYDSL]** |
| 立即数偏移字段 | — | 16-bit 无符号；`offset:65535` 可编码，`offset:65536` 被拒 **[LLVM]** |

gfx1250 的语义，**实测**得来而非从手册读来：

> lane 以 8 条为一组。lane *j* 提供一个地址 `a_j`，指向 8 个连续的 16-bit
> 元素。硬件做 8×8 转置，lane *l* 拿到 `{a_j + l : j = 0..7}`。

ISA 用一句话描述这两条指令 —— "Load **A or B matrix** with element-size of
16 bits into VGPRs from LDS and transpose" **[ISA §11.2.4]** —— 这句话对两者
都成立，但它完全没告诉你哪条 lane 最后拿到哪个元素。**lane 映射是必须实测的
那部分。**

**本仓库的 `probes/probe_nn_frag.py` 就是这次实测。** 在相信任何推导之前都值得
先跑一遍，原因见下一段。

### 让"猜"变得危险的失败模式

`ds_load_tr16_b128` 要求 16 字节对齐的地址。给它一个未对齐的地址，它**不会
fault** —— 它会**静默退化成一次普通的、不转置的 128-bit load**。你会得到一个
形状完全正确、数值全错、看上去很合理的张量。

这就是为什么 `nn_native_unsupported_reason()` 把 `N % 8 == 0` 当成硬门槛而不是
性能提示，也是为什么"我们仔细推导过 lane 映射"不能替代"跑过那个探针"。

`global_load_tr16_b128`，即它在 global 显存上的兄弟，**没有**这个限制：
**[实测]** per-lane 跨步为 9 和 12 个元素（18 B 和 24 B，都未对齐）时仍能正确
转置。它的地址是独立的 VMEM 地址，不受 LDS bank 约束。见
`docs/03-isa-investigation.md` §路线 5。

---

## 1.4 TDM：买到了什么，代价是什么

Tensor Data Mover 取代了 `buffer_load` + SRD。它是一个异步 DMA 引擎，接受一个
描述符（base、逐维 extent、逐维 stride、LDS padding），搬运一整个 tile。

**买到了什么。** 免费的地址生成。两个轴上的硬件越界 clamp。整条 multi-buffer
流水线赖以建立的异步性。还有 —— 这一条不是附带的 —— **为转置而设计的 LDS
padding**：ISA 明说这个 padding 的存在是为了 "to facilitate matrix transpose
operations or avoid LDS bank conflicts" **[ISA §10.11.2, §10.11.3]**。
TDM → LDS → 转置读**本来就是芯片设计者预设的流水线**，不是绕路。

**代价是什么**，具体化为五条各自付出过真实调试成本的约束：

1. **最内层 stride 被硬编码为 `dataSize`。** 描述符的 stride 字段只作用于外层
   维度。因此 TDM *无法*表达一个最内层非连续的 tile，这直接堵死了"在描述符里
   表达转置"的想法。这是硬件限制，并由 flydsl 的 `make_tdm_atom`（"the
   innermost stride is assumed 1 and ignored"）在 0.2.4 与 0.3.2 中独立佐证。
   **[ISA + FLYDSL]** 完整推导见 `docs/03-isa-investigation.md` §路线 1。

2. **extent 是从拷贝的 `imm_offset` 起算的，不是从描述符 base 起算的。**
   用完整 token 数建一次描述符再用 `imm_offset` 往前走，它 clamp 的是**零**。
   **[实测]** 每个 token 数不是 `tile_k` 整数倍的 expert 都会多拉进下一个
   expert 的一整个 tile；误差精确地跟随 `m_len % tile_k`，整除的 expert 正确
   到噪声底，其余的错 26.6–96.8%。修法：每个 k-tile 重建描述符，把行偏移折进
   base，用 `imm_offset=0` 拷贝。

3. **dim-0 和 dim-1 的 extent 不对称。** **[实测]**

   | | 约束寻址？ | 怎么确立的 |
   |---|---|---|
   | dim-0 extent | **是**，行粒度 | 声明 256 行 / 128 行有效，从未越读 |
   | dim-1 用于 **store** | **是** | 输出之后 1 MiB 的哨兵在 ragged K 下逐元素完好 |
   | dim-1 用于 **load** | **否** —— 只 clamp 数据 | 声明 512 B / 256 B 有效，走出了分配区 → `Memory access fault … Page not present` |

   **全 kernel 遵循的设计规则：把 ragged 轴放在 dim 0，永远不要指望 dim-1 去
   约束一次 load。** 做不到的地方 —— NN 流水线的 ragged 输出轴 `N` *就是* B 的
   dim 1 —— 就把读窗口退让到 `[N - tile_n, N)`，fragment 的列索引偏移
   `n_back`。

4. **`pad_interval` 必须是 2 的幂**（flydsl：`padInterval must be a power of
   two (in elements)`）。NN 的 B stage 行宽是 `tile_n * 2`，所以
   **`tile_n = 192` 在任何转置 stage 上都建不出来**。这是实打实的代价：原生
   NN 路径输给 hoist 路径的那一个交付点，全部原因就是它
   （`docs/05-optimization-log.md`）。

5. **未完成 DMA 的配额是按 WAVE 算的，不是按 workgroup 算的。** A 和 B 由
   *不同的* wave 发起，所以每个发起 wave 每个 k-tile 只有一个未完成 DMA，
   不是两个。算成两个会让 `tensor_wait` 变成空操作，流水线读到 DMA 还没填的
   LDS。**[实测]** 症状：**71.16% 的输出元素是 NaN**，其余是无穷大的相对误差
   —— 是随机比特，不是精度问题。判别方法：`num_buffers` 从 3 改成 2 就好了。

---

## 1.5 这对下一次移植意味着什么

三条可迁移的经验，作为建议而非结论陈述：

**先搬契约，再重建函数体。** 这里的三个公开入口保留了 gfx950 的名字、前三个
位置参数和关键字拼写。签名以下全是新的。正因如此，集成层只需要做一个分发决策
而不是一次重写。

**任何会置换数据的东西，它的 lane 语义必须实测。** 本次移植风险最高的单项，就是
假设 `ds_load_tr16_b128` 的行为和 `ds_read_b64_tr_b16` 一样。它不一样，而且
失败是静默的。一个探针脚本、一小时，消除整整一类风险。

**别指望调优表能跟着搬过来。** `_pick_config` 里每一个阈值都重新拟合过。
`GROUP_M` 从 4 变 16，`num_xcd` 从 8 变 1，tile 选择阈值全都不同，其中两条规则
**机制未确立**并在 docstring 里被明确标出。跨 arch 共享一个 `_pick_config`，
等于邀请别人去外推那些根本撑不住的规则。
