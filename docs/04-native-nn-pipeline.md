# 4. 原生 NN 流水线

做了什么、怎么验证的、剩下那 2.1% 去哪了。

**结果：** dgrad 原样读取 `b[G,K,N]`。任何地方都没有转置权重副本。正确性在全部
48 行上与 hoist 口径**逐位相同**，fwd/wgrad 与改动前的 kernel **逐位相同**。

---

## 4.1 改动的形状

一个 tile body、一个布尔开关 —— 与 gfx950 的组织方式相同（它叫
`a_transpose`，这里叫 `b_lds_transpose`）。**不是第三个 kernel。**

```
                     NT (fwd)              NN 原生 (dgrad)          wgrad (variable-K)
  A 操作数        ds_read_b128           ds_read_b128  ← 相同      ds_load_tr16_b128
  B 操作数        ds_read_b128           ds_load_tr16_b128         ds_load_tr16_b128
  B LDS stage    [tile_n][tile_k]       [tile_k][tile_n]          [tile_k][out_cols]
```

NN 流水线是第一个在单个 tile body 里**混用**两种加载器的：wgrad 两个操作数都
转置，NT 两个都不转置，NN 只转置 B。这个混用是唯一真正新的东西；其余都是
移植过来的。

### 代码行数账

整个文件：**+499 / −52**，其中**新增 321 行非注释代码**。

| | 行数 | 来源 |
|---|--:|---|
| device 侧 tile body | **125** | 全部在 `if const_expr(b_lds_transpose):` 分支内 |
| host 侧 | 196 | 新入口路径、`_pick_config_nn`、`_nn_b_pad`、`nn_native_unsupported_reason` |
| A 操作数、`fx.gemm` 调用、epilogue、grouped 控制逻辑 | **0** | 未动 |

从 wgrad 基本原样搬过来的部分：

| 部件 | wgrad 来源 |
|---|---|
| B 的 LDS stage 几何 `[tile_k][tile_n]` + `LDS_B_ROW` | stage 初始化 |
| B 描述符每 k-tile 重建、行偏移折进 base、`imm_offset=0` | `issue()` |
| per-lane 转置读基址（`l8` / `hi8` / `kgrp`）与 `_frag` / `_tr` | `b_lane` |
| ragged-N 的 `blk_n_eff` / `n_back` 退让窗口 | TN 越读修复 |

最后两行对应的那两个坑，就是 `docs/01-architecture.md` §1.4 里的 TDM 陷阱。
wgrad 已经**在这个 tile 朝向下**为两者付过账，这是整件事花了一周而不是一个月
的最大原因。

---

## 4.2 lane 语义：先实测，后动手

ISA 调研把 dgrad 的 lane 映射标为 **[推断]**，并说明推导链虽短但未经验证。
实现的第一步就是 `probes/probe_nn_frag.py`，把它变成 **[实测]**。

探针的设计，细节很重要：

- LDS 由**真正的 TDM 拷贝**填充，不是手工填。被测的是整条路径，不是孤立的
  指令。
- 填充值是 **bf16 位模式** `0x2000 + flat_index`，全部是 normal finite 数。
  一旦涉及 denormal flush 或舍入，小整数填充可能因为错误的原因而通过。
- **两条独立判据。**（a）每条 lane 的 16 个元素对上闭式预测；（b）同一份数据
  按 NT 方式 stage 后用普通 `ds_read_b128` 读出，必须**逐位相同**。判据（b）
  不依赖推导是否正确 —— 这正是设置它的意义。

**结果：4 种 tile 几何（32×64 / 64×128 / 128×64 / 64×64）、44 个 fragment ×
32 lane × 16 元素，全部逐位通过。**

```
lane  0: n=[0]   k=[0..7, 16..23]
lane  1: n=[1]   k=[0..7, 16..23]
lane 31: n=[15]  k=[8..15, 24..31]
```

### wgrad 的转置 vs dgrad 的转置 —— 同一条指令，实测确认

**行为逐位相同。** `ds_load_tr16_b128` 是纯数据搬运：它看到的只是 8 条 lane
各给一个地址、各指向 8 个连续的 16-bit 元素，它**不知道也不关心**那些元素代表
token 还是 reduction index。

| | wgrad | dgrad (NN) |
|---|---|---|
| LDS 行 = | token m（归约） | reduction k |
| LDS 列 = | 输出轴 | 输出轴 n |
| 行距 | `tile_m*2+pad` / `tile_n*2+pad` | `tile_n*2+pad` |
| 转置的是 | 激活的 token 轴 | 权重的归约轴 |
| **lane 映射** | **相同** | **相同** |
| 两个操作数都转置吗 | 是 | **否** —— 只有 B；A 仍走普通 `ds_read_b128` |

所以"wgrad 转激活、NN 转权重"**在 ISA 层面不是一个区别**。它是调用方赋予两个轴
的含义上的区别，而这个含义在生成的代码里并不存在。

---

## 4.3 正确性

`benchmarks/check_full.py` 在一个进程里同时加载**改动后的 kernel 和改动前的
reference**，所以"没有回归"是两个实现之间的比对，而不是各自对着一个可能一起
漂移的参考复算。

数值参考是 **fp32 逐组 matmul，在 host 侧用 float64 判定**。不用 device fp64：
**[实测]** 这颗芯片上 device fp64 matmul 作为参考**12 次错 11 次**。

**48 行 = 24 个 shape × {均衡分组, 不均衡分组}，全部通过：**

| 检查 | 结果 |
|---|---|
| dgrad `rel_fro` vs fp32 参考（第 4 次调用） | 最大 **1.6622e-03**，门槛 1e-2 |
| 同一行的 bf16 量化底噪（`rel_fro(bf16(ref), ref)`） | 最大 **1.6622e-03** |
| dgrad 原生 vs hoist 口径 | **48/48 逐位相同**（最大绝对差 = 0） |
| fwd vs 改动前的 kernel | **48/48 逐位相同** |
| wgrad vs 改动前的 kernel | **48/48 逐位相同** |
| NaN / Inf | 0 |
| 走到原生路径的行数 | 48/48 |
| 第 1 次调用 vs 第 4 次调用 | 相同 |

前两行要合起来读：它们**末位相同**，意味着全部误差都来自把结果存成 bf16，
**kernel 本身没有引入任何算术误差**。这比"在容差内"是强得多的陈述。

值得点名的覆盖：

- **`N == K`**（gpt-oss fc2，2880×2880）—— 形状断言无法区分 `b` 和 `b_nt` 的
  那种情形。6 行全过。
- **不均衡分组**，含**空 expert（0 行）**和 3 行的极短 expert。
- **ragged 输出轴**（`N_out = 2880` 对 `tile_n = 256` 不整除，走 `n_back`
  退让）。
- **小 M**（`avg_m = 128`）与**非 2 的幂的 K**（2880）。

`probes/smoke_nn.py` 另外覆盖 `G=1`、最小的 `K == N == 256` shape、以及
`lens=[1, 2047, 0, 33, 4096, 129]` 这类分布 —— 同样全部逐位相同。

---

## 4.4 shape 门槛

`nn_native_unsupported_reason(N, K, tile_n, tile_k)` 返回 `None` 或一句说明。
不满足的 shape 会**回退**到物化转置并给一次性警告；它**不 raise**，所以 API
契约不破。

| 条件 | 原因 |
|---|---|
| `K % tile_k == 0` | 与 NT 路径同样的约束：K 循环是编译期的 tile 计数 |
| `tile_n` 是 2 的幂 | B stage 行宽 `tile_n*2` 就是 TDM 的 `pad_interval`，硬件要求它是 2 的幂 |
| **`N % 8 == 0`** | **不是性能门槛。** 低于这个，转置读的列基址会错位，而该指令会**静默退化成不转置的普通 load** —— 得到看起来对、实际错的结果。硬门槛。 |
| `N >= tile_n` | ragged 退让窗口需要有一整个 tile 可退 |

24 个交付 shape 全部满足这四条；48/48 行都走了原生路径。

---

## 4.5 剩下那 2.1% 去哪了

同进程、逐点交错、like-for-like 对 hoist 口径，原生流水线是 **0.979** ——
GEMM 本身慢 2.1%。这是最该被质疑的数字，所以用**生成的汇编**而不是假设来回答。

`benchmarks/dump_stats.py` 把两条路径在同一个 shape 上编译出来对比
（256×256×128，gpt-oss fc1）：

| | NT (hoist) | 原生 NN |
|---|--:|--:|
| VGPR | 791 | **790** |
| VGPR / SGPR spill | 0 / 0 | **0 / 0** |
| scratch | 0 | **0** |
| WMMA 指令 | 512 | **512** |
| LDS 读指令 | 256（全部 `ds_read_b128`） | **256**（128 普通 + 128 转置） |
| VALU | 853 | 846 |
| SALU / wait | 672 | **602** |
| 总指令 | 2378 | **2301** |

**寄存器压力、spill、占用率全部被排除** —— 原生路径发出的指令反而*更少*。
剩下的只能是转置读本身的单指令代价（LDS 交叉开关 / bank 行为）。不是代码膨胀，
也不是 occupancy。

追查过程中得到两个发现，它们被放在 `docs/05-optimization-log.md`，因为属于
调优结果而不是流水线结构：

- **LDS 行距的残数值 6.5%** —— `LDS_B_ROW % 64 == 32` 才对，而上游默认的
  `LDS_PAD = 16` 恰好落在**错的**一侧。机制未确立；一个 bank 冲突模型给出的
  预测正好相反。
- **`tile_n=128` 配 `tile_k=64` 是转置读的坏组合**（54 格上几何均值 0.896），
  而 `tile_n=128` 配 `tile_k=128` 没问题。坏的是**组合**，不是 tile 宽度。

还有一个非发现，记下来免得有人再试：**`b_imm_walk`**（B 描述符只建一次、
用 `imm_offset` 走归约轴，而不是每 k-tile 重建）**没有可测量的差异** ——
0.985 vs 0.990，噪声量级。于是保留了已验证的每 k-tile 重建，没有为了一个
更容易在 extent 上出错的写法去换它。

---

## 4.6 没做的事

诚实的缺口清单。

1. **`avg_m < 1536` 时仍有时输给 Triton**，24 个 dgrad 格子里输 4 个。与转置
   无关，也未被本次工作改变 —— 同样这几格在 hoist 口径下一样输。wave
   quantization 作为机制已被**证伪**。**真实原因仍然未知。**
2. **`b_pad` 的 mod-64 规则没有机制解释。** 只有实测。
3. **`tile_n=128 + tile_k=64` 规则没有机制解释。** 只有实测（54 格）。
4. **XCD remap 仍然关着**（`num_xcd=1`）；MI455X 的 XCD 数量仍未确认。混合的
   实测结果见 `docs/05-optimization-log.md`。
5. **`masked_k` 没有在 NN 路径上测过** —— NN 入口本来就没有这个参数。
6. **没有做任何转置缓存，也不打算做。** 原生路径结构上不可能读到过期权重。
7. **fwd/wgrad 的表早于最后一次 tile 规则改动。** 这两条代码路径逐位未变
   （48/48 验证过），`_pick_config_nn` 也只被 NN 入口调用，但两轮跑在不同的
   时钟区间 —— 所以**不要跨三段比较绝对数值**。段内以及四口径表内都是同
   session 的。
8. **`cap_cu` 仍未实现**（非零即 raise），与改动前的 kernel 一致。

---

## 4.7 对调用方意味着什么

`grouped_gemm_bf16_nn_flydsl_kernel(dout, b, offs)` 现在**不需要 `b_nt`，
也不物化任何东西**。`b` 保持 `[G, K, N]` 的含义，签名未变，所以既有调用方
**不改一行**就从坏的一侧换到了好的一侧 —— 而且当初为了关掉 per-call 转置
而存在的 `PRIMUS_TURBO_GFX1250_FLYDSL_GG_TRANSPOSE_B` gate 可以删掉。

`b_nt` 仍然接受，但现在是**快路径**而不是必需品：调用方如果已经握着一份 NT
布局的副本，会短路到 NT kernel。

省下的显存（每层一份与本地专家权重等大的副本）：

| 模型（EP=8） | fc1 | fc2 | 每层省下 |
|---|--:|--:|--:|
| gpt-oss-20b | 126.6 MiB | 63.3 MiB | 189.8 MiB |
| qwen3-30b-a3b | 256.0 MiB | 128.0 MiB | 384.0 MiB |
| qwen3-235b-a22b | 1024.0 MiB | 512.0 MiB | 1.50 GiB |
| deepseek-v3 | 1792.0 MiB | 896.0 MiB | **2.62 GiB** |
