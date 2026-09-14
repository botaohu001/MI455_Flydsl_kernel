# gfx1250 FlyDSL bf16 grouped GEMM — 正确性与性能报告

机器：AMD MI455X (gfx1250) 内部测试机，256 CU，单卡测量。
被测对象是 `upstream/primus_turbo/grouped_gemm_bf16_kernel_gfx1250.py`（2290 行，
合并后**从未被编译或运行过** —— 见 `UPSTREAM_NOTES.md` §7）。

**TL;DR**

| 项 | 结论 |
|---|---|
| 编译 / import | **通过**。KERNEL_REVIEW §B.3 列的 14 个「仓库内无先例」flydsl 符号在 0.3.2 里**一个不缺** |
| 正确性 | **三个 op 全过**，96/96 数值点 + 16/16 `masked_k` padding 点 + 96/96 不均衡分组点 |
| `masked_k`（此前从未执行过的生产路径） | **过**。带 padding、非 `tile_k` 整数倍、死行毒化，误差纹丝不动 |
| 性能（72 个交付点） | fwd 均值 1342 TF/s、dgrad 1355、wgrad 1233 TF/s。零个点被 shape gate 掉 |
| vs 参考机 | 给出的 3 个点全部落在 **+5.8% ~ +8.4%**，无一超出 ±15% |
| vs Triton（同驱动同 session） | fwd **1.20x**、dgrad **1.17x**、wgrad **2.00x** |
| dgrad 口径差距 | **2.33x ~ 11.41x（中位 3.87x）**，比评审预估的 2-3x 更严重 |
| 三个可证伪检查点 | **全部 CONFIRMED** |

两处与既有文档不一致的地方，都在下面单列：`UPSTREAM_NOTES.md §6.5` 的
gpt-oss fc2 首调用损坏**没有复现**（§1.4），`MAX_G = 64` 在 gfx1250 上**不是边界**（§6.1）。

---

## 0. 环境与方法

### 0.1 落盘与分支

```
branch the local integration branch   (从 the local env-compat branch 分出，main 未动)
  a local commit  feat(flydsl): add the gfx1250 bf16 grouped-GEMM kernel     ← 本次新增
  a local commit  feat(flydsl): add the bf16 grouped-GEMM arch dispatch module
  a local commit  compat: attach OpaqueBaseMeta to quant configs for torch>=2.11
```

两个文件按 `KERNEL_REVIEW.md §E.1` 的建议落到
`primus_turbo/flydsl/grouped_gemm/`，`__init__.py` **未改动**（保持 bare licence
header，避免同目录另外 5 个 kernel 在 import 时被迫构建 WMMA/TDM atom）。
落盘的 dispatch 与 upstream 交付物逐字节相同。

**没有改 `grouped_gemm_impl.py` 的 backend 注册**，也没有碰
`primus_turbo/pytorch/` 下那 11 个 eager import —— 走的是 `--standalone` 路径
（`PREP_NOTES.md §4.1`），原因是 flydsl 0.2.4 / 0.3.x 的硬冲突（`PREP_NOTES.md §1.5`）
未解决，按任务要求不去动它。

### 0.2 运行配置

| 项 | 值 |
|---|---|
| 容器 | the ROCm container，镜像 a ROCm 7.x container image with torch 2.11 + flydsl 0.2.4 |
| flydsl | **0.3.2**，`PYTHONPATH=<staged-flydsl-0.3.2>` |
| torch | 2.11.0+rocm7.14.0a20260625 |
| GPU | `HIP_VISIBLE_DEVICES=0`，其余三卡空闲；开测前清掉了 prep 阶段遗留在卡 0 上的 HIPBLASLT 全表扫 |
| sclk | **未锁定**，实测 2009–2329 MHz（均值 2209） |
| `primus_turbo.pytorch` | 全程未被 import（探测脚本显式断言过） |

**为什么不锁 sclk**：`results/baseline/` 里的 Triton / hipBLASLt 基线是在未锁频下
测的。只给本次锁频会让它存在的那个对比失效。代价是要自己证明数字够稳 —— 见 §0.4。

### 0.3 三个 op 的调用口径

```
fwd    NT          out[rows] = x[rows] @ w[g].T        w = [G, N, K]
dgrad  NN          dA[rows]  = dOut[rows] @ w[g]       同一个 w，[G, K_nn=N, N_nn=K]
wgrad  variable-K  dW[g]     = dOut[rows_g].T @ x[rows_g]   ->  [G, N, K]
```

三点需要说明，都是实测逼出来的，不是选择：

1. **wgrad 用了算子交换而不是 `trans_c=True`。** 生产 autograd 传
   `trans_c=ctx.trans_b=True`，而 gfx1250 对此**直接 raise**
   （已实测确认，见 §1.5）。但 `(AᵀB)ᵀ = BᵀA`，所以调
   `kernel(dOut, x, offs)` 得到的正是 `trans_c=True` 想要的
   `[G, N_fwd, K_fwd]` 前向权重布局，且**零额外开销**——
   这和 turbo 的 CK / Triton variable-K backend 现有做法同构。
   于是 `(OUT_M, OUT_N) = (N_fwd, K_fwd)`，与 `KERNEL_REVIEW §D.3` 的 wgrad 表一致。
2. **wgrad 是 end-to-end 口径。** 两个操作数按 token-major 原样读，转置在 LDS 里做
   （`ds_load_tr16_b128`），计时器里**没有任何** `.t().contiguous()`。
   与 CK / Triton 的 variable-K 后端天然可比，不需要口径校正（`UPSTREAM_NOTES §4a`）。
3. **dgrad 分成两列。** 见 §3。

### 0.4 计时与数字稳定性

复用了 turbo 自己的 `torch.utils.benchmark.Timer`（没有自造计时轮子），
在它外面加了 repeat 层：**10 次 warmup，然后 5 × `timeit(50)`，报中位数**，
并报跨 repeat 的 cv。

| | FLYDSL | TRITON | HIPBLASLT |
|---|---|---|---|
| 点数 | 96 | 72 | 72 |
| cv 最大 | **1.697%** | 2.276% | 4.687% |
| cv 均值 | 0.401% | — | — |
| cv > 3% 的点 | **0** | 0 | 少数（iters=20，见下） |

**没有一个 FLYDSL 点的 cv 超过 3%**，所以下面的表里没有需要标注为不稳定的点。
最高 cv（1.697%）出现在 deepseek-v3 fc2 fwd @avg_m=128 —— 0.16 ms 的最短点，符合预期。
HIPBLASLT 用了 `--repeats 3 --iters 20`（它的 dgrad/wgrad 每次调用 ~9 ms，全量太慢），
所以它的 cv 更大；这只影响 §5 里 hipBLASLt 那一列的精度，不影响结论量级（20x 级差距）。

**统计口径变更没有引入偏差** —— 用新驱动重测 Triton，对 prep 阶段
`mean-of-timeit` 基线的比值是：72 点均值 **1.0000**，范围 0.966–1.047。
所以 §5 里 FLYDSL/Triton 的加速比不是统计方法的产物。

### 0.5 数值判定口径（以及容差为什么定在这里）

* **参考实现**：逐 group 的 **fp32** matmul，操作数从 bf16 精确上采样。
  用 fp32 而不是 fp64 是因为 `UPSTREAM_NOTES §6` 记录了 device fp64 参考在这块卡上
  **12 次错 11 次**。
* **判定在 host 侧**，float64 算指标：`rel_fro = ‖out − ref‖_F / ‖ref‖_F`。
* **验收门槛**：`rel_fro < 1e-2` 且零 NaN / Inf（就是 notes §8.2 自己的门槛）。
* **参考实现本身也验了**：device-fp32 参考 vs CPU-fp32 参考，16 个点的相对差
  **1.6e-7 – 7.7e-7**。所以参考是可信的，误差不是参考的假象。

实测 96 个点的 `rel_fro` 全部落在 **1.655e-3 – 1.662e-3**，比门槛低 6 倍。
这个数是**输出存成 bf16 的代价本身**，不是 kernel 的算术误差 —— 在
gpt-oss fc1 b1 那个点上把三件事放一起算：

| 比较对象 | rel_fro |
|---|---|
| kernel 的 bf16 输出 vs fp32 参考 | **1.6561e-03** |
| 把 fp32 参考**直接量化到 bf16** vs fp32 参考 | **1.6561e-03** |
| torch 自己的 bf16 grouped matmul vs fp32 参考 | **1.6561e-03** |
| kernel vs torch 的 bf16 matmul | **3.3606e-05** |

前三行五位有效数字**完全相同**：1.656e-3 就是 bf16 输出格式的量化噪声，
kernel 的算术误差是第四行的 3.4e-05，比它小 49 倍。
（notes 引的 0.1409% 是另一个稍有差别的指标定义；量级一致，都是「一次 bf16 舍入」。）

---

## 1. 正确性结论

### 1.1 三个 op 的数值正确性 —— 全过

4 模型 × 3 batch × 2 层 × 4 op（fwd / dgrad 两种口径 / wgrad）= **96 点，96 PASS，0 FAIL，0 ERROR**。

| op | 点数 | 结果 | rel_fro 范围 |
|---|---|---|---|
| fwd (NT) | 24 | **24 PASS** | 1.656e-3 – 1.662e-3 |
| dgrad (NN，hoist `b_nt`) | 24 | **24 PASS** | 1.656e-3 – 1.662e-3 |
| dgrad (NN，per-call 转置) | 24 | **24 PASS** | 同上，与 hoist 版**逐位相同** |
| wgrad (variable-K) | 24 | **24 PASS** | 1.656e-3 – 1.660e-3 |

原始数据 `results/flydsl_gfx1250/correctness_numeric.json`，日志 `logs/correctness_numeric.log`。

有 / 无 `b_nt` 两条路径给出**逐位相同**的结果 —— 这正是 notes §8.4 要求验的
「`b_nt` 路径正确性」。而且 `b_nt` 的 shape assert 与 one-shot `RuntimeWarning`
都按文档工作（warning 在整个 96 点跑里只出现 **1 次**）。

### 1.2 `masked_k` + padding —— 全过（这是本次最有价值的新结果）

`UPSTREAM_NOTES §8.3` 把 `masked_k` 记为「correct by construction, never executed」，
而 `KERNEL_REVIEW` 指出它恰恰是 turbo variable-K FlyDSL backend **唯一**会走的路径
—— 「从未执行过的代码」和「生产路径」在这里是同一条。专门测了：

构造：每个 group 在 pool 里分到 `slot = 1.25 × avg_m` 行，实际有效行数
`masked_k[g] < slot`，且**刻意让多个 group 的有效行数不是 `tile_k`（=128）的整数倍**
（实测 `valid % 128` = 48 / 42 / 91 / 85 / 5 / 0），死行全部**毒化**。

| 毒化值 | 点数 | 结果 | rel_fro |
|---|---|---|---|
| finite `1e4` | 8 | **8 PASS** | 1.658e-3 – 1.660e-3 |
| `NaN` | 8 | **8 PASS** | 1.658e-3 – 1.660e-3 |

这两种毒化是互补的：`1e4` 对着 `N(0,1)` 的正常值，任何一行泄漏都会让误差爆掉；
`NaN` 则让泄漏变成二值判定。两种都没动静，且误差就停在噪声底
—— **padding 行确实一个字节都没被 address 到**。
（`results/flydsl_gfx1250/correctness_masked_k.json`）

### 1.3 不均衡分组 —— 全过

交付矩阵是均衡分组，但真实 MoE 路由不是。用 `--imbalance`（turbo 自己的
ragged `group_lens` 生成器）重跑 96 点：**96 PASS**。
性能在最短的点上会掉（fwd 最低 301 TF/s vs 均衡时 747），这是形状使然，不是正确性问题。
（`results/flydsl_gfx1250/matrix_FLYDSL_imbalanced.csv`）

### 1.4 ⚠️ gpt-oss fc2 首调用损坏 —— **没有复现**

`UPSTREAM_NOTES §6.5` 记录 gpt-oss fc2（`N == K == 2880`）dgrad 的**前 1–2 次调用**
返回损坏结果（一次 7 个 NaN，一次 amax 3.47e36），root cause 未找到，
并要求「harness 必须 burn 3 次调用、验第 4 次」。

**照做了**，而且额外把 call 1 和 call 4 分别记录、对比。结论是它**在本机不复现**：

| 场景 | avg_m | call 1 rel_fro | call 4/8 rel_fro | NaN |
|---|---|---|---|---|
| 96 点全扫里（进程已热） | 512 / 1024 / 2048 | 1.6576e-3 / 1.6564e-3 / 1.6568e-3 | **逐位相同** | 0 |
| **全新进程**，该点是第一个被 launch 的 kernel，连测 8 次 | 512 | 1.6576e-3 | 1.6576e-3 | 0 |
| 同上 | 1024 | 1.6564e-3 | 1.6564e-3 | 0 |
| 同上 | 2048 | 1.6568e-3 | 1.6568e-3 | 0 |

三个 avg_m、全新进程、8 次连续调用，全部逐位稳定，零 NaN。
（`logs/correctness_firstcall_gptoss_fc2.log`）

**怎么读这个结果**：这是**未能复现**，不是「已修复」。可能的原因包括本机
flydsl / ROCm 版本与对方不同、或原始观测依赖某个未识别的前置状态。
如实报告：**建议 burn-3 的约定继续保留**（成本几乎为零），
`UPSTREAM_NOTES §8.16`（root-cause 这个 bug）也不应因为本次没复现就关掉。

### 1.5 文档声明的 raise 行为 —— 符合

| 参数 | 预期 | 实测 |
|---|---|---|
| `trans_c=True` | `NotImplementedError` | ✅ `trans_c=True is not implemented on gfx1250: the epilogue stores the tile through a TDM cop...` |
| `cap_cu=32` | `NotImplementedError` | ✅ `cap_cu=32 is not implemented on gfx1250: the kernel launches one workgroup per output tile...` |

两者都**响亮地失败**而不是静默算错。这确认了 `KERNEL_REVIEW §E.3` 列的
5 个集成阻塞点里 #1/#4/#5 是真的 —— 直接把 `is_gfx950()` 改成
`is_gfx950() or is_gfx1250()` 会立刻炸，`can_handle` 必须同步加负向条件。

### 1.6 依赖红灯全部解除

`KERNEL_REVIEW §B.3` 列了 14 个在 Primus-Turbo 里「一个先例都没有」的 flydsl 符号，
并判断「import 能过这个前提必须先验证再谈别的」。实测（`logs/probe_symbols.log`）：

**14/14 全部存在**于 flydsl 0.3.2 —— `flyc.from_c_void_p`、`fx.copy_atom_call`、
`fx.UniversalCopy`、`fx.ptr_store`、`fx.Pointer`、`fx.AddressSpace`、
`rocdl.WMMA`、`rocdl.make_tdm_atom`、`rocdl.ds_load_tr16_b128`、
`rocdl.s_wait_dscnt`、`rocdl.disable_xdl_arb_stall`、`tdm_ops.tensor_wait`，
以及 module-scope 的 12 条 import 全部成功。
`fx.SharedAllocator(static=False)` 在 `@kernel` 外构造会 raise，这是 flydsl 的
设计（kernel 内部才用），不是缺失。

---

## 2. 完整性能矩阵

72 个交付点（24 行 × 3 方向）+ 24 个第二 dgrad 口径 = 96 点。单位 TFLOP/s，
括号内是 MFU（分母 5033.2 TF/s = MI455X spec 峰值 bf16）。
`dgrad` = hoist `b_nt`（只计 GEMM），`dgrad_tr` = 含 per-call 权重转置。
完整逐点数据（含 ms / cv / config / sclk）在
`results/flydsl_gfx1250/matrix_FLYDSL.csv` 和 `matrix_combined.csv`。

### fc1（gate+up）

| 模型 | batch | avg_m | M | N | K | fwd | dgrad | dgrad_tr | wgrad |
|---|---|---|---|---|---|---|---|---|---|
| gpt-oss-20b | 1 | 512 | 2048 | 5760 | 2880 | 878.8 (17.46%) | 933.0 (18.54%) | 221.4 (4.40%) | 994.7 (19.76%) |
| gpt-oss-20b | 2 | 1024 | 4096 | 5760 | 2880 | 1309.0 (26.01%) | 1425.7 (28.33%) | 411.8 (8.18%) | 1260.8 (25.05%) |
| gpt-oss-20b | 4 | 2048 | 8192 | 5760 | 2880 | 1560.8 (31.01%) | 1598.8 (31.77%) | 669.7 (13.31%) | 1410.3 (28.02%) |
| qwen3-30b-a3b | 1 | 512 | 8192 | 4096 | 2048 | 1231.8 (24.47%) | 1109.5 (22.04%) | 253.4 (5.03%) | 1242.8 (24.69%) |
| qwen3-30b-a3b | 2 | 1024 | 16384 | 4096 | 2048 | 1552.8 (30.85%) | 1482.7 (29.46%) | 455.9 (9.06%) | 1464.3 (29.09%) |
| qwen3-30b-a3b | 4 | 2048 | 32768 | 4096 | 2048 | 1758.3 (34.93%) | 1767.0 (35.11%) | 756.6 (15.03%) | 1669.4 (33.17%) |
| qwen3-235b-a22b | 1 | 512 | 8192 | 8192 | 4096 | 1428.0 (28.37%) | 1462.8 (29.06%) | 290.4 (5.77%) | 1242.1 (24.68%) |
| qwen3-235b-a22b | 2 | 1024 | 16384 | 8192 | 4096 | 1701.6 (33.81%) | 1755.0 (34.87%) | 514.9 (10.23%) | 1519.8 (30.19%) |
| qwen3-235b-a22b | 4 | 2048 | 32768 | 8192 | 4096 | **1921.0 (38.17%)** | **1972.9 (39.20%)** | 833.8 (16.57%) | **1714.9 (34.07%)** |
| deepseek-v3 | 1 | 128 | 4096 | 4096 | 7168 | 825.7 (16.40%) | 822.7 (16.35%) | 74.8 (1.49%) | **580.7 (11.54%)** |
| deepseek-v3 | 2 | 256 | 8192 | 4096 | 7168 | 1130.0 (22.45%) | 1109.8 (22.05%) | 142.8 (2.84%) | 888.6 (17.65%) |
| deepseek-v3 | 4 | 512 | 16384 | 4096 | 7168 | 1474.4 (29.29%) | 1403.7 (27.89%) | 264.9 (5.26%) | 1219.2 (24.22%) |

### fc2（down）

| 模型 | batch | avg_m | M | N | K | fwd | dgrad | dgrad_tr | wgrad |
|---|---|---|---|---|---|---|---|---|---|
| gpt-oss-20b | 1 | 512 | 2048 | 2880 | 2880 | 838.2 (16.65%) | 846.8 (16.82%) | 198.7 (3.95%) | 736.1 (14.62%) |
| gpt-oss-20b | 2 | 1024 | 4096 | 2880 | 2880 | 1208.2 (24.01%) | 1195.8 (23.76%) | 369.7 (7.34%) | 986.5 (19.60%) |
| gpt-oss-20b | 4 | 2048 | 8192 | 2880 | 2880 | 1505.7 (29.92%) | 1504.9 (29.90%) | 627.2 (12.46%) | 1177.2 (23.39%) |
| qwen3-30b-a3b | 1 | 512 | 8192 | 2048 | 2048 | 947.1 (18.82%) | 952.0 (18.91%) | 229.2 (4.55%) | 1208.3 (24.01%) |
| qwen3-30b-a3b | 2 | 1024 | 16384 | 2048 | 2048 | 1305.0 (25.93%) | 1308.3 (25.99%) | 414.2 (8.23%) | 1450.4 (28.82%) |
| qwen3-30b-a3b | 4 | 2048 | 32768 | 2048 | 2048 | 1601.8 (31.82%) | 1607.5 (31.94%) | 691.2 (13.73%) | 1623.9 (32.26%) |
| qwen3-235b-a22b | 1 | 512 | 8192 | 4096 | 4096 | 1393.5 (27.69%) | 1389.4 (27.61%) | 263.1 (5.23%) | 1223.6 (24.31%) |
| qwen3-235b-a22b | 2 | 1024 | 16384 | 4096 | 4096 | 1674.9 (33.28%) | 1679.6 (33.37%) | 468.0 (9.30%) | 1490.0 (29.60%) |
| qwen3-235b-a22b | 4 | 2048 | 32768 | 4096 | 4096 | 1897.3 (37.70%) | 1897.0 (37.69%) | 776.0 (15.42%) | 1690.9 (33.59%) |
| deepseek-v3 | 1 | 128 | 4096 | 7168 | 2048 | **746.7 (14.84%)** | **759.4 (15.09%)** | **66.5 (1.32%)** | 638.1 (12.68%) |
| deepseek-v3 | 2 | 256 | 8192 | 7168 | 2048 | 1021.6 (20.30%) | 1101.6 (21.89%) | 129.0 (2.56%) | 909.9 (18.08%) |
| deepseek-v3 | 4 | 512 | 16384 | 7168 | 2048 | 1306.0 (25.95%) | 1441.2 (28.63%) | 242.1 (4.81%) | 1241.7 (24.67%) |

### 汇总

| 方向 | 点数 | 均值 | 最小 | 最大 | MFU 范围 |
|---|---|---|---|---|---|
| fwd | 24 | 1342.4 | 746.7 | 1921.0 | 14.84% – 38.17% |
| dgrad（hoist） | 24 | 1355.3 | 759.4 | 1972.9 | 15.09% – 39.20% |
| dgrad（per-call 转置） | 24 | 390.2 | 66.5 | 833.8 | 1.32% – 16.57% |
| wgrad | 24 | 1232.7 | 580.7 | 1714.9 | 11.54% – 34.07% |

**最好的点**：qwen3-235b-a22b fc1 batch=4 —— dgrad 1972.9 TF/s / **39.20% MFU**，
fwd 1921.0 / 38.17%，wgrad 1714.9 / 34.07%。三个方向都是这一行最快。

**最差的点**：deepseek-v3 @ avg_m=128（batch=1）—— fc2 fwd 746.7 TF/s / 14.84%，
fc1 wgrad 580.7 / 11.54%。这是形状本身的问题，不是 tile 选择的问题：
`_pick_variable_k_config` 的 docstring 自己算过 —— deepseek 在 avg_m=128 时
为 240 GFLOP 写出 1.88 GB 输出，**受限于输出带宽，换 tile 救不了**。
实测印证了这个说法：该点 wgrad 用的是 `BM256/BN256/BK128/mw4/nw2/nb2`（和其他 23 行同一个 tile），
即 `avg_m` 不参与 wgrad 的 tile 选择，符合 §D.2。

### tile config 分布（72 个交付点实际生效的）

| 方向 | config | 点数 |
|---|---|---|
| fwd / dgrad | `BM256/BN256/BK128/mw2/nw2/nb2` | 34 |
| fwd / dgrad | `BM128/BN128/BK128/mw2/nw2/nb2` | 5 |
| fwd / dgrad | `BM256/BN256/BK64/mw2/nw2/nb3` | 3 |
| fwd / dgrad | `BM128/BN192/BK64/mw2/nw2/nb3` | 3 |
| fwd / dgrad | `BM128/BN128/BK64/mw2/nw2/nb3` | 3 |
| wgrad | `BM256/BN256/BK128/**mw4**/nw2/nb2` | **24（全部）** |

---

## 3. 两种 dgrad 口径的差距

`UPSTREAM_NOTES` 从未说明它报的 dgrad 数字含不含权重转置 —— 这是 `KERNEL_REVIEW §C.2`
标出的信息缺口。gfx1250 没有原生 NN pipeline，dgrad 是 NT kernel 吃转置后的权重
（`UPSTREAM_NOTES §4b`），不传 `b_nt` 就每次调用 materialise 一份参数级拷贝。
两种都测了：

| 模型 | 层 | batch | 权重 GB | hoist (ms) | per-call (ms) | 转置 (ms) | 倍数 | hoist TF/s | per-call TF/s | 转置带宽 (TB/s) |
|---|---|---|---|---|---|---|---|---|---|---|
| gpt-oss-20b | fc1 | 1 | 0.13 | 0.0728 | 0.3069 | 0.234 | 4.22x | 933 | 221 | 1.13 |
| gpt-oss-20b | fc2 | 1 | 0.07 | 0.0401 | 0.1709 | 0.131 | 4.26x | 847 | 199 | 1.01 |
| gpt-oss-20b | fc1 | 4 | 0.13 | 0.1700 | 0.4058 | 0.236 | 2.39x | 1599 | 670 | 1.13 |
| qwen3-30b-a3b | fc1 | 1 | 0.27 | 0.1239 | 0.5424 | 0.419 | 4.38x | 1110 | 253 | 1.28 |
| qwen3-30b-a3b | fc1 | 4 | 0.27 | 0.3111 | 0.7266 | 0.416 | 2.34x | 1767 | 757 | 1.29 |
| qwen3-235b-a22b | fc1 | 1 | **1.07** | 0.3758 | 1.8929 | **1.517** | 5.04x | 1463 | 290 | 1.42 |
| qwen3-235b-a22b | fc1 | 4 | **1.07** | 1.1146 | 2.6373 | 1.523 | 2.37x | 1973 | 834 | 1.41 |
| deepseek-v3 | fc1 | 1 | **1.88** | 0.2923 | 3.2135 | **2.921** | **10.99x** | 823 | 75 | 1.29 |
| deepseek-v3 | fc2 | 1 | 0.94 | 0.1584 | 1.8078 | 1.649 | **11.41x** | 759 | 67 | 1.14 |
| deepseek-v3 | fc1 | 4 | 1.88 | 0.6854 | 3.6326 | 2.947 | 5.30x | 1404 | 265 | 1.28 |

（完整 24 行在 `results/flydsl_gfx1250/dgrad_calibres.csv`）

**倍数：最小 2.33x，中位 3.87x，最大 11.41x。**
`KERNEL_REVIEW §C.2` 估的是 2–3x —— **实测更严重**，因为它算的是 qwen3-235b
（1.07 GB 权重 vs 0.55 ms GEMM，实测 5.04x），而 deepseek 更极端：
1.88 GB 权重配 avg_m=128 的小 GEMM，per-call 转置把 dgrad 打到 **75 TF/s / 1.49% MFU**。

**转置的隐含带宽（读+写）实测 1.01–1.42 TB/s**，与 notes 引的「~1.07 TB/s」吻合
—— 所以这个成本模型是对的，而且 `.transpose().contiguous()` 在这块卡上确实只有
plain copy（~7.2 TB/s）的 1/6。

**转置时间只取决于权重大小，与 avg_m 无关**（gpt-oss fc1 三个 batch 的转置时间是
0.234 / 0.235 / 0.236 ms，几乎常数）。所以 batch 越小、倍数越难看。

### 参考数据用的是哪种口径？—— 判断：**(a) hoist，只计 GEMM**

三条独立证据都指向同一个答案：

1. **TF/s 区间。** 参考给的是 500–1800 TF/s。hoist 口径实测 759–1973（24 点里 22 点在区间内）；
   per-call 口径实测 **67–834**，24 点里有 **17 点低于 500 下限**。
   如果参考报的是 per-call，它的下限不可能是 500。
2. **MFU 区间。** 参考给 10%–35%。hoist 实测 15.09%–39.20%；per-call 实测
   **1.32%–16.57%**，24 点里 13 点低于 10%。同样不相容。
3. **`UPSTREAM_NOTES §4b` 自己写的示例代码就是 hoist 的**
   （`b_nt = make_nn_weight_nt(b)  # once per optimizer step`），
   并且它说集成分支把 per-call 那条路径 gate 在
   `PRIMUS_TURBO_GFX1250_FLYDSL_GG_TRANSPOSE_B`（默认**关**）后面，
   理由是「transpose-per-call 通常打不过 Triton」—— 而我们实测的
   per-call/Triton = **0.32x**，正好印证。

**推论对集成的意义**：参考数据里那个漂亮的 dgrad 数字，
turbo 当前的注册表路径**拿不到** —— `GroupedGEMMFlyDSLBackend.execute` 不传 `b_nt`
（`KERNEL_REVIEW §E.3`），所以它会落在 per-call 口径上，比 Triton 慢 3 倍。
要么按 §E.3 建议默认 decline NN（让位 Triton），要么先实现权重转置缓存，
要么做 `UPSTREAM_NOTES §8.15` 说的真正 NN tile。

---

## 4. 与参考机数据的对比

### 4.1 逐点对比（参考数据只给了 3 个具体点）

| 点 | 参考 ms | 本机 ms | 参考 TF/s | 本机 TF/s | 偏差 | 生效 config |
|---|---|---|---|---|---|---|
| gpt-oss-20b fc1 b1 fwd | 0.0818 | 0.0773 | 830.9 | 878.8 | **+5.8%** | `BM128/BN128/BK64/mw2/nw2/nb3` |
| qwen3-235b-a22b fc1 b4 fwd | 1.2310 | 1.1447 | 1786.3 | 1921.0 | **+7.5%** | `BM256/BN256/BK128/mw2/nw2/nb2` |
| deepseek-v3 fc1 b1 fwd | 0.3157 | 0.2913 | 761.7 | 825.7 | **+8.4%** | `BM128/BN128/BK128/mw2/nw2/nb2` |

**三个点全部在 +5.8% ~ +8.4%，没有一个超出 ±15%**，所以没有需要单独归因的异常行。
方向一致（本机全部略快）、幅度一致（跨度只有 2.6 个百分点）—— 这是**系统性偏移**的形态，
不是随机差异。

最可能的原因是**时钟**：本次 sclk 均值 2209 MHz、峰值 2329 MHz，而 notes 里
引用自己 sweep 时的 sclk 是「1394–1400 MHz」（variable-K tile sweep）和
「1785–2212 MHz」（192-tile sweep）。若参考的 3 个交付点跑在 ~2190 MHz，
2314/2190 = 1.057 就正好解释 gpt-oss 那个 +5.8%。
**但参考数据没给 sclk，所以这只是最合理的解释，不是已证实的归因。**

另外两个点值得注意：
* **config 串对得上。** 参考说典型 config 是 `BM128/BN128/BK64/mw2/nw2/nb3`（窄 tile）
  和 `BM256/BN256/BK128/mw2/nw2/nb2`（主干）。本机在同一个 gpt-oss fc1 b1 fwd 点上
  生效的正是前者，在 qwen3-235b fc1 b4 上正是后者。**跑的是同一份代码、同一套 tile 决策。**
* 但 deepseek-v3 fc1 b1 的 config 是 `BM128/BN128/BK128`，不在参考举的两个串里
  —— 这不矛盾，参考说的是「典型」，而 `KERNEL_REVIEW §D.6` 预测过这第三个串会出现，实测也出现了。

### 4.2 区间对比（覆盖全部 72 点）

| 方向 | 本机范围 | 参考区间 500–1800 内的点 | 本机 MFU 范围 | 参考 MFU 区间 10–35% |
|---|---|---|---|---|
| fwd | 746.7 – 1921.0 | 22/24 | 14.84 – 38.17% | 略微超出上限 |
| dgrad（hoist） | 759.4 – 1972.9 | 22/24 | 15.09 – 39.20% | 略微超出上限 |
| wgrad | 580.7 – 1714.9 | **24/24** | 11.54 – 34.07% | **完全落在区间内** |
| dgrad（per-call） | 66.5 – 833.8 | 7/24 | 1.32 – 16.57% | 大幅低于 |

**整体吻合度：好。** 72 个点里 68 个落在参考的 TF/s 区间内，
**没有一个点低于参考下限 500**。4 个越界点全部是**越出上限 1800**，
而且全部是同一行的 batch=4：qwen3-235b-a22b fc1 fwd 1921.0、fc2 fwd 1897.3、
fc1 dgrad 1972.9、fc2 dgrad 1897.0 —— 与 §4.1 那个 +6~8% 的系统性偏移一致
（按 1800 上限换算，只需 ~7% 的偏移就能解释全部 4 个越界点）。
wgrad 24/24 完全落在区间内，是三个方向里吻合最好的。

---

## 5. 与本机 baseline 的对比

Triton 和 hipBLASLt 都用**同一个驱动、同一个 session、同样的中位数统计**重测，
所以下面的加速比不掺统计口径差异（§0.4 已验证）。
逐点数据 `results/flydsl_gfx1250/matrix_combined.csv`。

### 5.1 三个 backend 的总体水平

| 方向 | FLYDSL 均值 | TRITON 均值 | HIPBLASLT 均值 | FLYDSL/TRITON | FLYDSL/HIPBLASLT |
|---|---|---|---|---|---|
| fwd | **1342.4** | 1134.0 | 813.6 | **1.202x** (0.793–1.657) | **1.912x** (0.965–3.395) |
| dgrad（hoist） | **1355.3** | 1197.0 | 64.3 | **1.165x** (0.771–1.643) | **21.34x** (12.9–33.4) |
| wgrad | **1232.7** | 624.1 | 64.6 | **1.998x** (1.776–2.295) | **18.89x** (10.2–24.9) |
| dgrad（per-call 转置） | 390.2 | 1197.0 | 64.3 | **0.324x** (0.095–0.630) | 5.85x |

### 5.2 结论

**wgrad 是最干净、也最大的胜利：全部 24 个点都快 1.78x – 2.30x，无一例外。**
这正是 baseline 显示的 Triton 最弱的算子（prep 阶段测得 wgrad 均值 625 TF/s、
MFU 12.4%，是三个方向里唯一的短板）。FlyDSL 把它抬到 1233 TF/s / 24.5% MFU，
和它自己的 fwd/dgrad 拉到同一水平线。且两边**口径天然可比** ——
都吃 un-transposed 的 token-major 操作数，计时器里都没有外部转置。

**fwd / dgrad 是温和的胜利，但不是全胜。**48 个 fwd/dgrad 点里，
FlyDSL 在 **38 个点上更快、8 个点上明确更慢、2 个点基本打平**（0.994 / 1.000）：

| 模型 | 层 | batch | avg_m | 方向 | FlyDSL | Triton | 比值 |
|---|---|---|---|---|---|---|---|
| qwen3-30b-a3b | fc2 | 1 | 512 | dgrad | 952.0 | 1235.3 | **0.771** |
| qwen3-30b-a3b | fc2 | 1 | 512 | fwd | 947.1 | 1194.5 | 0.793 |
| qwen3-30b-a3b | fc1 | 1 | 512 | dgrad | 1109.5 | 1370.7 | 0.809 |
| deepseek-v3 | fc2 | 2 | 256 | dgrad | 1101.6 | 1344.4 | 0.819 |
| deepseek-v3 | fc1 | 2 | 256 | fwd | 1130.0 | 1299.5 | 0.870 |
| deepseek-v3 | fc1 | 2 | 256 | dgrad | 1109.8 | 1209.2 | 0.918 |
| gpt-oss-20b | fc1 | 1 | 512 | fwd | 878.8 | 913.1 | 0.962 |
| （另 3 点 0.976 / 0.994 / 1.000） | | | | | | | |

规律很清楚：**失分集中在 batch=1**（fwd/dgrad 在 batch=1 的均值 1.15x，
batch=4 是 1.27x/1.31x），且集中在中小 N·K 的形状。也就是说
FlyDSL 的优势随 tile 填充度上升，在 grid 不足时反而落后 —— 与
`_pick_config` docstring 里那段「wave quantisation」的自述一致。

**hipBLASLt 只在 fwd 上有意义。**它在 qwen3-235b fc1 b4 上拿到全场 fwd 最快
（1991.6 TF/s / 39.6% MFU，比 FlyDSL 快 3.5%），但它的 grouped NN / variable-K
路径只有 ~64 TF/s / 1.3% MFU（与 prep 阶段的观测一致），所以在 dgrad/wgrad 上
落后 19–21 倍。**它是 fwd-only 的天花板，不是端到端的对手。**

**per-call 转置口径下 FlyDSL 的 dgrad 是 Triton 的 0.32x** ——
即比 Triton 慢约 3 倍。这从数据上确认了集成分支把该路径默认关掉的判断。

---

## 6. 三个可证伪检查点

| # | 预测（来自 `KERNEL_REVIEW.md`） | 实测 | 结论 |
|---|---|---|---|
| 1 | **所有 wgrad 行的 config 应是 `mw4` 而不是 `mw2`** | 24/24 行都是 `BM256/BN256/BK128/**mw4**/nw2/nb2`，0 行是 mw2 | **CONFIRMED** |
| 2 | **fitted 窄 tile 只命中 4 of 48，全是 G=4 的 gpt-oss** | 命中 **恰好 4** 点，全部 gpt-oss、全部 G=4 | **CONFIRMED** |
| 3 | **72 个点没有一个被 shape gate 掉** | 96/96 点全部运行，0 ERROR，0 assert | **CONFIRMED** |

### 6.0 检查点 2 的细节 —— 连「哪 4 个点」都对上了

`_pick_config` 有三个会给出非主干 tile 的分支，需要分开数才有意义
（把 derived 的 `avg_m<=128` 和 fitted 的 `n_groups` 规则混在一起会数出 8 个而不是 4 个）。
按分支归类 48 个 NT/NN 交付点：

| `_pick_config` 分支 | 生效 config | 点数 |
|---|---|---|
| wide `256x256x128`（`K%128==0`） | `BM256/BN256/BK128/mw2/nw2/nb2` | 34 |
| **narrow FITTED**（`n_groups·⌈avg_m/256⌉ ≤ 8`） | `BM128/BN128/BK64/...nb3` ×3 + `BM128/BN128/BK128/...nb2` ×1 | **4** |
| narrow DERIVED（`avg_m ≤ 128`） | `BM128/BN128/BK128/mw2/nw2/nb2` | 4 |
| 192-wide FITTED（`avg_m≥1536 ∧ N%192==0`） | `BM128/BN192/BK64/mw2/nw2/nb3` | 3 |
| wide `256x256x64` | `BM256/BN256/BK64/mw2/nw2/nb3` | 3 |

fitted 窄 tile 命中的 4 个点：

| 模型 | 层 | batch | avg_m | G | 方向 | config |
|---|---|---|---|---|---|---|
| gpt-oss-20b | fc1 | 1 | 512 | 4 | fwd | `BM128/BN128/BK64/mw2/nw2/nb3` |
| gpt-oss-20b | fc1 | 1 | 512 | 4 | dgrad | `BM128/BN128/**BK128**/mw2/nw2/nb2` |
| gpt-oss-20b | fc2 | 1 | 512 | 4 | fwd | `BM128/BN128/BK64/mw2/nw2/nb3` |
| gpt-oss-20b | fc2 | 1 | 512 | 4 | dgrad | `BM128/BN128/BK64/mw2/nw2/nb3` |

这与 `KERNEL_REVIEW §D.6` 枚举的 4 个点**逐点相同**，包括它特别指出的那个细节
—— gpt-oss fc1 dgrad @512 应该是 `BK128` 而不是 `BK64`（因为 dgrad 方向的
K 变成 5760 = 45×128，反而整除 128）。实测就是 `BK128`。

而且 §D.6 预测「矩阵里应该还会出现另外三个 config 串」，实测全部出现且计数吻合：

| 预测的串 | 预测理由 | 实测点数 |
|---|---|---|
| `BM256/BN256/BK64/mw2/nw2/nb3` | gpt-oss @1024，K=2880 不整除 128 | **3** ✅ |
| `BM128/BN192/BK64/mw2/nw2/nb3` | gpt-oss @2048，192-wide fitted 规则 | **3** ✅ |
| `BM128/BN128/BK128/mw2/nw2/nb2` | deepseek @128 + gpt-oss fc1 dgrad @512 | **5** ✅ |

**这三个检查点加起来的意义**：`KERNEL_REVIEW.md` 是纯静态源码分析（没编译、没跑 GPU），
它对 `_pick_config` / `_pick_variable_k_config` 的逐行判定，在 72 个交付点上
**逐点被实测证实**。两份独立分析在同一处收敛，所以这套 tile 决策逻辑的理解是对的。

### 6.1 ⚠️ 额外发现：`MAX_G = 64` 在 gfx1250 上不是边界

`GroupedGEMMVariableKFlyDSLBackend.MAX_G = 64` 是 **gfx950 MFMA kernel 的实测边界**
（代码注释：「clean through G=65, wrong past it (G=80 and G=96 both fail)」），
`KERNEL_REVIEW §E.3` 提醒不要假设它能搬过来，而交付矩阵只到 G=32、测不到边界。
补测了（`avg_m=256, N=K=2048`，三个 op，burn-3 验第 4 次）：

| G | 32 | 48 | 64 | 65 | 80 | 96 | 128 | 160 |
|---|---|---|---|---|---|---|---|---|
| fwd | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS |
| dgrad | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS |
| wgrad | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS |

全部 `rel_fro = 1.7e-3`，即噪声底。**gfx1250 在 G=160 上仍然正确**，
包括 gfx950 明确失败的 G=80 和 G=96。这与 `KERNEL_REVIEW` 的结构性判断一致
（`_decode_m_tile` 的二分 `steps = max(1,(max(2,G)-1).bit_length()+1)` 对任意 G 都够，
没有结构性上界）。对交付矩阵（G ≤ 32）无影响，但集成时 `MAX_G` 可以放宽 —— **有数据支撑了**。

### 6.2 额外发现：MI455X 的 XCD 数看起来是 8，但 `num_xcd=8` 不是免费的赢

`UPSTREAM_NOTES §8.13` 把 `num_xcd=1` 的理由写成「purely from not knowing」
MI455X 的 XCD 数。本机 `amd-smi metric -c` 报告 **8 个 gfx clock domain**
（`gfx_0_clk` … `gfx_7_clk`，均 500–2400 MHz），配 256 CU 即每 XCD 32 CU。
这是**证据而非证明**（时钟域数不必然等于 XCD 数），但与 MI355X 的 8 XCD 同构。

实测 `num_xcd=8, xcd_band=32` 对默认 `num_xcd=1`（交错测量、每侧两轮取平均）：

| 行 | op | xcd1 ms | xcd8 ms | 比值 | 判定 |
|---|---|---|---|---|---|
| gpt-oss-20b fc1 | fwd | 0.0782 | 0.0718 | **0.918** | 快 8.2% |
| gpt-oss-20b fc1 | wgrad | 0.0689 | 0.0698 | 1.013 | 慢 |
| qwen3-30b fc1 | fwd | 0.1110 | 0.1096 | 0.988 | 快 1.2% |
| qwen3-30b fc1 | wgrad | 0.1068 | 0.1120 | **1.049** | 慢 4.9% |
| qwen3-235b fc1 | fwd | 1.1380 | 1.1248 | 0.989 | 快 1.2% |
| qwen3-235b fc1 | wgrad | 1.2697 | 1.2735 | 1.003 | 平 |
| deepseek-v3 fc1 | fwd | 0.2902 | 0.2906 | 1.001 | 平 |
| deepseek-v3 fc1 | wgrad | 0.4115 | 0.3974 | 0.966 | 快 3.4% |

**结论：混合，不构成默认改动的理由。** fwd 一致小幅受益（最多 8.2%，在最短的点上），
wgrad 多数受损。**保留 `num_xcd=1` 是站得住的。**
注意 gpt-oss fc1 那个 +8.2% 落在 0.078 ms 的最短点上，而本探测每侧只测两轮
—— **属于「值得后续用完整 sweep 确认」的线索，不是结论**。

---

## 7. 所有异常与真实报错

按诚实优先，把本次遇到的每一件不顺、每一处与文档不符都列出来：

| # | 事项 | 性质 | 处置 |
|---|---|---|---|
| 1 | `trans_c=True` → `NotImplementedError` | **真实报错，符合文档** | 用算子交换 `(AᵀB)ᵀ=BᵀA` 绕过（§0.3），零成本、与 CK/Triton 做法同构 |
| 2 | `cap_cu != 0` → `NotImplementedError` | **真实报错，符合文档** | 不传 `cap_cu`；集成时 `can_handle` 必须加负向条件，否则 raise 而不是回退 Triton |
| 3 | prep 阶段写好的 `bench_flydsl_gg_matrix.py` 在 standalone 的 wgrad 分支传 `trans_c=True` | **脚本 bug**，跑不通 | 已改为算子交换 |
| 4 | `UPSTREAM_NOTES §6.5` 的 gpt-oss fc2 首调用损坏 | **未能复现**（§1.4） | 保留 burn-3 约定；§8.16 的 root-cause 任务不应关闭 |
| 5 | `MAX_G = 64` | **与 gfx1250 实测不符**，实际到 G=160 仍正确（§6.1） | 集成时可放宽，有数据 |
| 6 | `PREP_NOTES.md §6` 文件映射列了 `results/baseline/grouped_gemm_bf16_HIPBLASLT.csv` | **该文件从未生成** —— turbo 的 `bench_grouped_gemm_turbo.py` 只在全部跑完后才写 CSV，而那次运行 25 分钟只到 TestID 46 就被留在后台 | 只有日志 `logs/baseline_HIPBLASLT.log` 存在；本次开测前清掉了该进程（它占着卡 0 100% GPU）。§5 的 hipBLASLt 数据来自本次同驱动重测，不依赖它 |
| 7 | `fx.SharedAllocator(static=False)` 在 `@kernel` 外 raise | **不是问题** | flydsl 的设计约束（只能在 kernel 内构造）；kernel 内部用法正常 |
| 8 | FlyDSL 在 10 个 fwd/dgrad 点上慢于 Triton（最差 0.771x） | **真实结果，非错误** | 已在 §5.2 分析（集中在 batch=1 / 小 N·K） |

**没有出现的问题**（都专门查过）：编译失败、NaN、shape gate、assert、
flydsl 符号缺失、`primus_turbo.pytorch` 被意外 import、cv 失控。

### 7.1 本次的适用边界（不要过度外推）

* **单卡、单 session、未锁频。** 跨 session 复现性没验。notes §8.6 要求
  「同 session 交错 + sclk 锁定」才能分辨 1–10% 的 tile 差异 —— 本次的
  tile 差异分析（§6.2）没达到那个严格度，已标注。
* **参考数据只有 3 个点 + 两个区间。** 用户要求的「逐行对比」受限于可得的参考数据，
  §4.1 是能做到的全部；§4.2 用区间覆盖了其余 69 点。
* **走的是 standalone 路径，不是 turbo 注册表。** flydsl 版本冲突未解，
  所以「`BackendType.FLYDSL` 在生产路径上的表现」本次**没有**测到。
  §3 的推论指出这件事非常重要：注册表路径会落在 per-call 转置口径上。
* **没测 fp8 / fp16、没测 `inplace_add_to_out`（Megatron 融合 wgrad）**，
  后者两个 FlyDSL backend 都主动 decline。

---

## 8. 产物清单

| 路径 | 内容 |
|---|---|
| `results/flydsl_gfx1250/matrix_FLYDSL.csv` | 96 点主矩阵：ms / TF/s / MFU / cv / config / sclk |
| `results/flydsl_gfx1250/matrix_combined.csv` | 主矩阵 + Triton + hipBLASLt 逐点加速比 |
| `results/flydsl_gfx1250/matrix_TRITON_samedriver.csv` | Triton，同驱动同 session |
| `results/flydsl_gfx1250/matrix_HIPBLASLT_samedriver.csv` | hipBLASLt，同驱动同 session |
| `results/flydsl_gfx1250/matrix_FLYDSL_imbalanced.csv` | 不均衡分组 96 点 |
| `results/flydsl_gfx1250/dgrad_calibres.csv` | 两种 dgrad 口径逐点对比 + 隐含转置带宽 |
| `results/flydsl_gfx1250/vs_{triton_samedriver,hipblaslt_samedriver,triton_prep}.csv` | 三组加速比 |
| `results/flydsl_gfx1250/correctness_numeric.json` | 96 点正确性，call 1 与 call 4 分列 |
| `results/flydsl_gfx1250/correctness_masked_k.json` | 16 点 padded-pool `masked_k` |
| `results/flydsl_gfx1250/correctness_hostref.json` | device-fp32 参考 vs CPU-fp32 参考 |
| `logs/probe_symbols.log` | 14 个无先例 flydsl 符号的实测探测 |
| `logs/correctness_*.log` | 正确性原始日志（含 fresh-process 首调用测试） |
| `logs/matrix_*.log`, `logs/analysis.log` | 性能原始日志与分析输出 |
| `logs/probe_open_questions.log` | G 上界 / `num_xcd` 探测 |
| `logs/tolerance_justification.log` | 1.656e-3 = bf16 输出量化的证明 |

新增脚本（都在 `<repo>/`，**不在 Primus-Turbo 仓库里**）：
`check_flydsl_gg_correctness.py`、`probe_flydsl_symbols.py`、
`probe_open_questions.py`、`analyze_flydsl_gg.py`、`gg_matrix_defs.py`，
以及对 `bench_flydsl_gg_matrix.py` 的扩展（config / sclk / cv / 两种 dgrad 口径 / wgrad 算子交换）。

---

## 9. 给集成的建议（按优先级）

1. **wgrad 可以直接上。**2x Triton、24/24 点正确、`masked_k` 生产路径已验证、
   口径与现有 backend 天然可比。`can_handle` 需要加的负向条件只有
   `cap_cu == 0`（`trans_c` 用算子交换解决，见 §0.3）。
2. **dgrad 必须先决定口径。** 按 §3，注册表当前不传 `b_nt` → 比 Triton 慢 3 倍。
   三个选项：默认 decline NN（`KERNEL_REVIEW §E.3` 的建议，最保守）、
   加权重转置缓存、或做 `UPSTREAM_NOTES §8.15` 的真 NN tile（结构性最优）。
3. **fwd 可以上，但要知道它在 batch=1 上会输给 Triton**（最差 0.79x）。
   若走 AUTOTUNE 路径，选择器会自己避开；若 pin FLYDSL，小 batch 有回退风险。
4. **不要动 `amdgpu-expert-scheduling-mode`**。本次所有数值门都在它开着的情况下过的，
   notes 明说它是「validated by our gates, not by construction」。
5. `MAX_G` 可以从 64 放宽（§6.1 有数据到 160）；`num_xcd` 保持 1（§6.2）。
6. 仍然阻塞生产集成的是 **flydsl 0.2.4 / 0.3.x 冲突**（`PREP_NOTES §1.5`），
   本次按要求未动。它不影响本报告的任何结论，但意味着
   「`PRIMUS_TURBO_GROUPED_GEMM_BACKEND=FLYDSL` 端到端」仍未被测过。
