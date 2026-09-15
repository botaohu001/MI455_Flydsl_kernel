# MI455X bf16 grouped GEMM —— gfx1250 的 FlyDSL kernel

面向 **AMD MI455X / gfx1250** 的 bf16/fp16 grouped GEMM（MoE 专家矩阵乘），
覆盖训练的全部三个算子 —— 前向、dgrad、wgrad —— 建立在 FlyDSL 的 WMMA + TDM
接口之上。

**这个仓库的价值在 dgrad 那条路径。** 其余部分是移植，dgrad 需要一个新思路。

> **grouped GEMM 的反向有一个操作数布局问题**：权重的归约轴恰好是它的跨步轴，
> 矩阵引擎读不了。通常的做法是物化一份转置后的权重副本。在 MI455X 上这份副本
> 要花 **最多 2.9 ms，而 GEMM 本身只要 0.3 ms**，还要在 HBM 里多占
> **一整份专家权重**。
>
> **这个 kernel 不做这次拷贝。** 权重按它在显存里原本的样子被 DMA 进 LDS，
> 转置由硬件的 LDS 转置读指令 `ds_load_tr16_b128` 在装配 WMMA fragment
> 的那一级完成 —— 这条指令原本就接在 wgrad 上，这里第一次把它接到了 dgrad。

---

## 结果

**正确性是逐位级的，不是"在容差内"。**

| 检查项 | 结果 |
|---|---|
| dgrad 原生流水线 vs 预先 hoist 的转置权重 | **48/48 逐位相同**（最大绝对差 = 0） |
| fwd vs 改动前的 kernel | **48/48 逐位相同** |
| wgrad vs 改动前的 kernel | **48/48 逐位相同** |
| `rel_fro` vs fp32 参考 | 最大 1.6622e-03 —— **与 bf16 输出量化底噪末位相同**，说明 kernel 自身没有引入任何额外的算术误差 |

48 行 = 24 个 MoE shape × {均衡分组, 不均衡分组}，覆盖空 expert、3 行的极短
expert、`N == K`、ragged 输出轴、以及非 2 的幂的 K。

**吞吐**，dgrad，24 个交付 shape：

| | 均值 | 峰值 | MFU 峰值 |
|---|--:|--:|--:|
| dgrad（原生 NN） | **1415.5 TF/s** | **1972.9 TF/s** | **39.2 %** |
| fwd | 1430.8 TF/s | 1955.4 TF/s | 38.9 % |
| wgrad | 1274.0 TF/s | 1758.0 TF/s | 34.9 % |

**三个比值，一个都不省略：**

| 对比 | 几何均值 | 区间 | 胜负 |
|---|--:|---|---|
| vs **hoist 口径**（同一个 GEMM，权重已被免费预转置） | **0.979** | 0.872 – 1.031 | 2/24 |
| vs **flydsl + 快转置，per-call** | **1.357** | 1.108 – 1.908 | **24/24** |
| vs **Triton** | **1.208** | 0.853 – 2.107 | 20/24 |

这三个数要合起来读，因为它们说的不是同一件事：

- **0.979 是诚实的 like-for-like。** 原生 GEMM 比 NT GEMM **慢 2.1%**，而且
  对照组是白拿一份转置权重的**上界** —— 真实调用方达不到它，除非自己维护一份
  参数大小的副本并正确地让它失效。
- **1.357 才是调用方每次调用真正拿到的**，24 战 24 胜，对手是本项目测到的最好的
  per-call 转置（一个 tiled Triton kernel，15.5–17.1 TB/s，本身已经比
  `.transpose().contiguous()` **快 11–14 倍**）。
- **vs Triton 1.208，24 个点里赢 20 个。** 输掉的 4 个都在小 `avg_m`：
  0.853、0.890、0.926、0.934。**这不是本次工作造成的** —— 同样这几个点在
  hoist 口径下一样输 —— 而且**真实原因未知**。wave quantization 这个猜测
  已经被实测证伪。

那 2.1% 换来的是：**没有转置权重副本**（deepseek-v3 在 EP=8 下每层最多省
**2.62 GiB**）、没有任何需要失效的东西，因此也就不可能踩到
`AdamW(fused=True)` 不 bump `param._version`、缓存静默返回上一步权重那个坑
（已复现出 9.99e-02 的相对误差）。

完整表格见 **[docs/07-performance.md](docs/07-performance.md)**。

---

## 从哪读起

**如果你要把一个 kernel 移植到新的 AMD 芯片** →
[`docs/01-architecture.md`](docs/01-architecture.md)。gfx950 → gfx1250 的逐项
对照，以及为什么思路可搬、代码不可搬。

**如果你遇到同样的 dgrad 转置问题** →
[`docs/02-dgrad-problem.md`](docs/02-dgrad-problem.md)。完整推理链，外加三条
死路 —— 篇幅与正解等长。

**如果你要调优这个 kernel** →
先看 [`docs/05-optimization-log.md`](docs/05-optimization-log.md)，免得重做一遍
已经被实测证明是负收益的事；再看
[`docs/10-disproven-directions.md`](docs/10-disproven-directions.md)，那里有更早
一轮战役的三十几条判负，以及**三条其实不能外推的历史负结论**。

**如果你正要相信某个 benchmark 数字** →
[`docs/06-pitfalls.md`](docs/06-pitfalls.md) §6.4。本项目有两次差点把两个
测量内容不同的东西放在一起比。

**如果你要在一台不锁频的机器上读出一个 +2%** →
[`docs/09-measurement-methodology.md`](docs/09-measurement-methodology.md)。噪声底
怎么量、为什么必须用夹心口径、哪些"收益"其实是仪器。

| 文档 | 内容 |
|---|---|
| [01-architecture](docs/01-architecture.md) | gfx1250 vs gfx950 逐项：MFMA→WMMA、wave64→wave32、SRD→TDM、AGPR→VGPR、**lane 语义不同**的两条转置读，以及五条各自付出过真实调试代价的 TDM 约束 |
| [02-dgrad-problem](docs/02-dgrad-problem.md) | dgrad 为什么需要转置；以及为什么"更快的转置"、"权重缓存"、"代数变换"三条路**都不是**答案 |
| [03-isa-investigation](docs/03-isa-investigation.md) | 五条 ISA 路线及其证据级别。**被否决的四条才是有用的部分** —— 包括实测可用却被刻意不采用的 `global_load_tr16_b128` |
| [04-native-nn-pipeline](docs/04-native-nn-pipeline.md) | 实现：一个 tile body、一个布尔开关、device 侧 125 行；lane 语义的实测；剩下那 2.1% 去哪了 —— 从汇编而不是猜测回答 |
| [05-optimization-log](docs/05-optimization-log.md) | 所有试过的手段**含失败的**，每条都有数据：六个让性能变差的方向，五个被证伪的假设 |
| [06-pitfalls](docs/06-pitfalls.md) | 踩过的坑，其中会产生**看起来对但实际错**的结果的那些标了 ⚠️ |
| [07-performance](docs/07-performance.md) | 三段全矩阵、四口径对比、以及测量条件 |
| [08-tuning-playbook](docs/08-tuning-playbook.md) | 上一轮调优战役里**实测有效**的六条：机理、收益、测量条件、外推边界。最普适的一条是 warp 网格 8 波 → 4 波，259 组成对对照 geomean **1.0367** |
| [09-measurement-methodology](docs/09-measurement-methodology.md) | 怎么让一个 +2% 站得住：噪声底、夹心口径、compile-only 门、归因阶梯。**换芯片换 kernel 都还成立的那部分** |
| [10-disproven-directions](docs/10-disproven-directions.md) | 三十几条判负，按"编译门 / 代数 / 架构性 / 实测为负 / 噪声底内"五类分开 —— 以及三条**不该被当成永久否决**的历史结论 |
| [source-reports/](docs/source-reports/) | 原始工作报告存档 —— 一手证据，包括那些后来被推翻的结论 |

目录结构：

```
kernel/       实现 + 改动前版本（供 diff）
docs/         01-07 为新读者重写；source-reports/ 保持原貌
probes/       在动手之前把事实钉死（lane 映射、ISA 能力）
benchmarks/   正确性 harness 与测量驱动
results/      每个引用数字背后的原始 CSV/JSON
asm/          最终 gfx1250 ISA + LLVM IR，以及被舍弃的 20 个阶段的 digest
```

---

## 怎么用

```python
from grouped_gemm_bf16_kernel_mi455 import (
    grouped_gemm_bf16_nt_flydsl_kernel,          # fwd:   out[rows] = a[rows] @ b[g].T
    grouped_gemm_bf16_nn_flydsl_kernel,          # dgrad: out[rows] = a[rows] @ b[g]
    grouped_gemm_bf16_variable_k_flydsl_kernel,  # wgrad: out[g] = a[rows_g].T @ b[rows_g]
)

# a[M_total, K]，专家的 row-run 沿 M 拼接；group_offs 是 [G+1] int64。
# b 是 [G, K, N]，**原样读取** —— 没有转置副本，也没有什么需要 hoist。
da = grouped_gemm_bf16_nn_flydsl_kernel(dout, b, group_offs)
```

落进 Primus-Turbo：两个文件放到 `primus_turbo/flydsl/grouped_gemm/`，与 gfx950
kernel 同级。**只把 backend 的 arch gate 放宽是不够的** —— 有五处会直接 raise
而不是回退到 Triton。清单见 [`kernel/README.md`](kernel/README.md) 与
[`docs/06-pitfalls.md`](docs/06-pitfalls.md) §6.2。

---

## 复跑

**硬件：** AMD MI455X (gfx1250)。没有 CPU 路径，也没有模拟路径。

**软件**（实测所用）：

| | |
|---|---|
| torch | 2.11.0+rocm7.14 |
| **flydsl** | **0.2.4** |
| ROCm | 7.x 容器；不需要 `/opt/rocm`，工具链以 wheel 形式提供 |
| triton | 3.6.0+rocm7.14（仅用于 baseline 和那个 tiled 转置） |

⚠️ **是 flydsl 0.2.4，不是 0.3.0。** kernel 自己的文件头曾声称版本地板是
0.3.0。那是一个**未经验证的假设，而且是错的** —— 0.2.4 被实测证明能正确跑完
整个矩阵。这一点很要紧，因为 flydsl 0.3.x **删掉了**
`flydsl.expr.buffer_ops`，而 Primus-Turbo 里有 27 个同级模块仍在 import 它。
详见 [`docs/06-pitfalls.md`](docs/06-pitfalls.md) §6.1。

```bash
python probes/probe_flydsl_symbols.py    # ~1 秒，不需要 GPU：flydsl 接口在不在？
python probes/probe_nn_frag.py           # 实测 ds_load_tr16_b128 的 lane 映射
python probes/smoke_nn.py                # 快速正确性门
python benchmarks/check_full.py          # 48 行逐位正确性门
python benchmarks/bench_matrix.py        # 三段矩阵 + 四口径对比
```

脚本的路径都相对仓库根目录解析，clone 到任何位置都能直接跑。

### 测量条件

单张 MI455X，256 CU，432.0 GiB HBM，内部测试机。**时钟未锁频** ——
`sclk` 全程在 **2010–2331 MHz** 之间，每个计时点都采样并记录。

不锁频是有意为之：Triton 和 hipBLASLt 的 baseline 是在未锁频下测的，只给一边
锁频会让那个对比失效。替代它的是：**竞争实现在同一个进程里逐次交错测量**，
所以时钟漂移会同等地落在双方身上。5 个样本取中位数，每个样本是一个填满约
40 ms 的 launch 循环；**全部 72 个交付点的 cv 都 < 2%**。

⚠️ **不要跨三个算子分段比较绝对数值** —— fwd 和 wgrad 是在更早一轮、不同时钟
区间下测的。段内的比值以及四口径表是同 session 的。

### 如果你没有 gfx1250

这个仓库的大部分内容仍然适用：

- **[`docs/01-architecture.md`](docs/01-architecture.md)** —— 移植对照讲的是
  架构差异，与是否持有这颗芯片无关。
- **[`docs/03-isa-investigation.md`](docs/03-isa-investigation.md)** ——
  `probes/isa/*.sh` 里的 `llvm-mc` 探针**不需要 GPU**，只需要一个认识
  `-mcpu=gfx1250` 的 LLVM。"这条指令存不存在"在笔记本上就能回答。
- **[`docs/02-dgrad-problem.md`](docs/02-dgrad-problem.md)** —— 推理链、缓存
  分析、代数论证都与硬件无关。`_version` 那个发现适用于**任何** torch 2.11
  项目里以参数为 key 的缓存。
- **[`docs/05-optimization-log.md`](docs/05-optimization-log.md)** 和
  **[`docs/06-pitfalls.md`](docs/06-pitfalls.md)** —— 可迁移的是方法：
  lane 语义要实测而不是推导；先分辨一个操作是本身慢还是它的*实现*慢；
  每个数字旁边都写清口径。
- **[`docs/09-measurement-methodology.md`](docs/09-measurement-methodology.md)**
  和 **[`docs/10-disproven-directions.md`](docs/10-disproven-directions.md)** ——
  前者整篇与硬件无关（噪声底、对照组、夹心口径、"隔离测量 ≠ 流水里的测量"）；
  后者的五类判负框架同样可以照搬到别的 kernel 上。
- **[`asm/`](asm/)** 和 **[`results/`](results/)** —— 没有硬件也能读。

没有 gfx1250 唯一做不了的事，是重跑测量。

---

## 状态与诚实的边界

这是**研究与 bring-up 阶段的工作**，不是一个已发布的库。它能跑，并在 24 个
shape 的交付矩阵上验证过。它**没有**接进 Primus-Turbo 的 backend registry，
没有 CI，并且有这些已知缺口：

- **24 个 dgrad 点里仍有 4 个输给 Triton**，都在小 `avg_m`，原因未知。
- 两条调优规则（LDS pad 的同余类、`tile_n`/`tile_k` 的组合）**有实测但机制
  未确立**。要重测，不要外推。
- `num_xcd` 钉死为 1，因为 MI455X 的 XCD 数量尚未确认。
- `cap_cu` 未实现；wgrad 上的 `trans_c` 会 raise（改用算子交换即可，零成本）。
- 只支持 bf16/fp16，单卡，每轮测量只有一个 session。

以上每一条都写进了文档，而不是留给你自己去撞。

---

## 许可证

**Apache-2.0** —— 见 [`LICENSE`](LICENSE)，provenance 链（FlyDSL →
Primus-Turbo → 本仓库）见 [`NOTICE`](NOTICE)。每个 kernel 文件头部的版权声明
与 FlyDSL 出处声明**逐字保留，必须保持原样**。文档与代码采用同一许可证，
理由写在 `NOTICE` 里。

CDNA5 ISA 手册在全文中被引用，但**未在此仓库中转载**；它由
[AMD 公开发布](https://www.amd.com/content/dam/amd/en/documents/instinct-tech-docs/instruction-set-architectures/amd-instinct-cdna5-instruction-set-architecture.pdf)。
