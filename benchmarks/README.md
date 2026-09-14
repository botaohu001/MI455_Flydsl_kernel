# `benchmarks/` —— 正确性 harness 与测量驱动

`docs/07-performance.md` 和 `docs/05-optimization-log.md` 里每一个数字的来源。
路径相对仓库根目录解析，clone 到任何位置都能跑。

> 脚本本身与其注释保持英文。

**需要 gfx1250 硬件。** 软件栈见仓库根目录的 `README.md`。

---

## 正确性

### `check_full.py` —— 48 行完整门

在一个进程里同时加载交付 kernel 和 `kernel/reference/`，所以"没有回归"是两个
实现之间的比对，而不是各自对着一个可能一起漂移的参考复算。

```bash
python benchmarks/check_full.py
```

48 行 = 24 个 shape × {均衡分组, 不均衡分组}。断言：

- dgrad 原生 vs hoist 口径 —— **逐位相同**，48/48
- fwd 和 wgrad vs 改动前的 kernel —— 各 **逐位相同**，48/48
- `rel_fro` 对 **fp32** 逐组参考，在 host 侧用 float64 判定
  （绝不用 device fp64 —— 在这颗芯片上它 12 次错 11 次）
- 零 NaN/Inf，且 48 行确实都走了原生路径

它会 burn 3 次调用再验第 4 次，遵循 `docs/06-pitfalls.md` 里的首调用损坏约定。
预期输出：`results/nn_pipeline/check_full.out`。

### `check_flydsl_gg_correctness.py` —— 更宽的正确性扫描

96 个数值点、带 padded pool 与毒化死行的 `masked_k`、以及 device-vs-CPU 参考
交叉核对。`--masked-k` 覆盖的是本次工作之前**从未被执行过**的生产路径：
`valid % tile_k != 0` 的 padded pool，死行分别用 finite `1e4` 和 `NaN` 毒化。

---

## 性能

### `bench_matrix.py` —— 三段交付矩阵

产出 `docs/07-performance.md` §7.1–7.4 的表：24 个 shape 上的 fwd、dgrad、
wgrad，外加**四口径**对比（native / hoist / per-call 快转置 / Triton），
在一个进程里逐点交错测量，使时钟漂移对四者一视同仁。

```bash
python benchmarks/bench_matrix.py --outdir results/nn_pipeline
```

5 个样本取中位数，每个样本是一个填满约 40 ms 的 launch 循环，逐点报 `cv`。

### `bench_flydsl_gg_matrix.py` —— 目标矩阵驱动

通用驱动，带 Triton / hipBLASLt / FlyDSL 的 backend 开关。复用 Primus-Turbo
自己的计时路径而不是自造计时轮子，并且**分别**测量三个算子 —— 项目自带的
benchmark 脚本把 dgrad 和 wgrad 合成一个反向数字，这正是本脚本存在的原因。

两种模式：`--registry` 走 Primus-Turbo 的 backend registry；`--standalone`
直接调 arch 分发，不需要 `primus_turbo.pytorch` 可 import。本仓库所有测量都用
`--standalone`。

`gg_matrix_defs.py` 放 shape 表，单独拆出来供正确性 harness 复用。

### `bench_quick.py` —— 快速的 native-vs-hoist 检查

六个 shape，足以看出一次改动有没有移动那个比值。迭代时用它；要引用的数字用
`bench_matrix.py`。

### `dump_stats.py` —— 用汇编回答性能问题

把一个 shape 用两条路径分别编译出来并 diff 生成的代码：VGPR/SGPR 计数、spill、
scratch、LDS 字节数、指令组成。

```bash
FLYDSL_DUMP_IR=1 FLYDSL_DEBUG_DUMP_ASM=1 FLYDSL_DUMP_DIR=asm \
  python benchmarks/dump_stats.py
```

正是它排除了寄存器压力和 occupancy 对原生流水线那 2.1% 的解释：VGPR 790 vs
791、两侧零 spill、原生路径**少发 77 条指令**。`asm/` 也由它填充。

---

## 调优 sweep

### `ab_variants.py` —— LDS pad sweep，值 6.5%

把转置 B stage 的 LDS pad 从 16 扫到 160、步长 16，六个 shape，始终对着同一个
tile 上的 NT。发现了以 `LDS_B_ROW % 64 == 32` 为判别的双峰分布，而这是"原生
NN 流水线贵 7%"与"贵 1%"之间的全部差距。

**机制仍未解释** —— 一个 32 bank 的模型预测正好相反。引入新的 `tile_n` 时要
重跑它，不要外推。

### `sweep_narrow.py` —— `tile_n=128` + `tile_k=64` 规则

54 个合成 cell，其归约长度强制 `tile_k=64`。确立了 `tile_n=128` 几何均值
0.896 对 256 的 1.103，以及 `tile_n=128` 配 `tile_k=128` 没问题 —— 所以坏的是
组合，不是 tile 宽度。

### `probe_outlier.py` —— 原生 vs hoist 最差的那个点

对 gpt-oss fc2 dgrad @ avg_m=2048（比值 0.872）做 tile 扫描。把原因定位到
`tile_n=192` 这个 tile 不可用，而不是转置读。

---

## `dgrad_study/` —— 流水线之前的决策研究

在原生 NN 流水线出现之前进行，回答"既然 dgrad 需要一份转置权重，那么代价最小
的拿法是什么？" 它的结论喂给了 `docs/02-dgrad-problem.md`，其中两条至今独立
成立。

| 脚本 | 它确立了什么 |
|---|---|
| **`bench_transpose.py`** | **关键实验。** `make_nn_weight_nt` 跑 1.07–1.39 TB/s；约 20 行的 tiled Triton 转置在同样的 shape 上跑 **15.5–17.1 TB/s**，逐位一致 —— **快 11.0×–14.9×**，而且比 torch 那个*不*转置的拷贝还快。 |
| `bench_dgrad.py` | 逐 shape 的 `t_gemm` / `t_transpose` / `t_nocache` / Triton，以及 N\* |
| `part2_memory.py` | 缓存在两个大模型上要花 **+141 GiB / +152 GiB** |
| `part3_cache.py` | 缓存原型 —— 38 条断言通过，以及 **`AdamW(fused=True)` 不 bump `param._version`**，导致 9.99e-02 的静默错误 |
| `part4_algebra.py` | 逐组 variable-K 的重排：逐位正确，**慢 1.5×–10.5×** |
| `wave_quant.py` | **证伪**了 wave quantization 作为小 `avg_m` 失分的解释（Spearman −0.55，符号反了） |
| `common.py` | 共享 harness：交错计时、`sclk` 采样、shape 表 |

`analyze.py`、`decision.py`、`summarize.py` 把 `results/dgrad_study/` 里的
原始 JSON 变成文档里引用的那些表。

> 即使你永远不碰这颗芯片，也值得读一下 `bench_transpose.py`。它是一个紧凑的
> 示范：在围绕某个代价做设计之前，先确认是这个操作慢，还是它的*实现*慢。
