# 6. 踩过的坑

花掉真实时间的那些事，按它们出现的位置分组。其中有几个会产生**看起来对但实际
错**的结果而不是报错，这类标了 ⚠️。

---

## 6.1 环境与版本

### flydsl 的版本地板是 0.2.4，不是文件头声称的 0.3.0

kernel 的模块 docstring 曾经写着 "Requires flydsl >= 0.3.0"。那是**一个假设，
从未验证过**，而且是错的。

**[实测]** flydsl **0.2.4** 能在 gfx1250 上编译并运行这个 kernel。它需要的四个
接口 —— `rocdl.WMMA`、`rocdl.make_tdm_atom`、`flydsl.expr.tdm_ops`、
`rocdl.ds_load_tr16_b128` —— 全都在，整个交付矩阵正确到 bf16 噪声底。
0.3.2 也能用。

这件事的价值超过"改一个版本字符串"，有两个原因：

1. **一条打包注释说了相反的话。** Primus-Turbo 的 `setup.py` 把
   `flydsl==0.2.4` 钉死，并在 gfx1250 构建时跳过安装它，注释是 "Triton 3.7.0
   and flydsl 0.2.4 does not support gfx1250"。那句话说的是 *Triton* 那一侧；
   对这个 kernel 来说 0.2.4 没问题。一个未经验证的说法，从一条注释传播进了
   模块头，再传播进三份规划文档。
2. **要求 0.3.x 会实实在在地弄坏周边项目**，见下一条。

**教训：版本地板是一个测量结果，不是一个声明。** 定它的探针只要一分钟、不需要
GPU —— `probes/probe_flydsl_symbols.py`。

### flydsl 0.3.x 删掉了 `flydsl.expr.buffer_ops`，而且这不是改名

`buffer_load` 挪进了 `flydsl/expr/rocdl/__init__.py`，但 `buffer_store`、
`create_buffer_resource` 和 `extract_base_index` 是**没了** —— 整套 SRD
buffer-resource 写法被 TDM 取代而退役。0.3.0、0.3.1、0.3.2 都查过，
**没有一个提供兼容 shim**。

在 Primus-Turbo 树里的后果：

- **`primus_turbo/flydsl/` 下有 27 个文件 import 它**，包括 **gfx950** 的
  grouped-GEMM kernel。所以在 0.3.x 上 gfx950 的 kernel 也不可用，
  gfx950-vs-gfx1250 的对比无论如何都需要两套环境。
- **`primus_turbo/pytorch/kernels/` 下有 12 个模块在模块作用域 eager import
  `primus_turbo.flydsl.*`**，而且每一个都能从 `import primus_turbo.pytorch`
  到达。所以装一个 0.3.x 的 flydsl 并不会降级成"那个 kernel 不可用" ——
  它会让**整个包无法 import**：

  ```
  primus_turbo.pytorch
    -> modules.attention -> ops.attention.flash_attn_interface
    -> kernels.attention.attention_flydsl_impl -> flydsl.attention.flash_attn_bwd
  ImportError: cannot import name 'buffer_ops' from 'flydsl.expr'
  ```

修法是把这 12 个 import 推迟到真正需要它们的调用处，把一个"能力缺失"的
`ImportError` 变成一个点名的 `RuntimeError`。既然 **0.2.4 能跑这个 kernel**，
这件事对*本* kernel 已不再是阻塞项 —— 但它仍然是正确的改动，也是 standalone
分发路径存在的原因。

**这个 kernel 完全不 import 任何 `primus_turbo.*` 模块**（它自己读
`gcnArchName` 而不用 `is_gfx1250()`），也从不碰 `buffer_ops`。这是有意的，
任何移植都值得保留这一点。

### ⚠️ 仓库测试套件对 gfx1250 给不了任何覆盖

`tests/conftest.py` 在设备是 gfx1250 时**无条件 skip 每一个测试**。全部
**223,828 个收集到的用例都 skip**。改动前后完全一样。

这是一个干净的"没有引入回归"信号，**仅此而已**。它不能证明任何东西跑起来过。
这里跑绿了，意思是套件根本没有执行。

**本仓库里每一条正确性结论都来自专门写的 harness**
（`benchmarks/check_full.py`、`probes/`），而不是项目自带的测试套件。如果你要
加一个 gfx1250 runner：host 侧的那些辅助函数（`m_tile_upper_bound`、
`build_m_tile_map`、`build_m_tile_table`、`build_expert_table`、
`check_prebuilt`）全是纯 torch、CPU 可跑，而且目前覆盖率为**零**；
`build_m_tile_map` 与 `build_m_tile_table` 的等价性是一个很好的 property test。

### 容器与构建

- 构建必须**单独**使用 `GPU_ARCHS=gfx1250`。把 gfx1250 与 gfx942/gfx950 混在
  一次构建里会让整个构建禁用 turbo/CK。
- `docker run --group-add render` 在这里用的 ROCm 镜像上**会失败** —— 镜像里
  没有 `render` 组。要用数字形式传宿主的 GID。
- 构建会往挂载的 repo 里写 **root 属主**的文件（`build/`、`*.so`、
  `_version.py`、`_build_info.py`）。记得 `chown` 回来，否则宿主侧工具会开始
  抱怨。
- `bench_grouped_gemm_turbo.py` 的 stdout 是**块缓冲**的。重定向时要加
  `PYTHONUNBUFFERED=1`，否则你会有很多分钟什么都看不到。

---

## 6.2 API 与集成门槛

### ⚠️ 位置参数与 gfx950 错位，关键字不会

gfx950 的每一个关键字在 gfx1250 上都同名存在，所以只用关键字的调用方是无缝的。
**位置调用方不是：**

| 入口 | 位置对齐到 | 首个错位 |
|---|---|---|
| `..._nn_flydsl_kernel`（dgrad） | **一路对齐到 `cap_cu`** ✓ | — |
| `..._nt_flydsl_kernel`（fwd） | index 5 | index **6**：gfx950 是 `GROUP_M`，gfx1250 是 `BLOCK_K` |
| `..._variable_k_flydsl_kernel`（wgrad） | index 6 | index **7**：gfx950 是 `num_xcd`，gfx1250 是 `BLOCK_K` |

一个写 `nt_kernel(a, b, offs, torch.bfloat16, 256, 256, 4)` 的 bring-up 脚本，
在 gfx950 上意思是 `GROUP_M=4`，在 gfx1250 上会变成 `BLOCK_K=4` →
`ValueError: tile_k=4 needs at least 2 WMMA K-steps`。**会炸，而且炸得很响** ——
但注意这个不对称：同一个文件里，NN 保持了 gfx950 的顺序而 NT 没有。值得在上游
修掉，把 NT 的新 knob 挪到 `cap_cu` 之后。

### ⚠️ `trans_c=True` 和 `cap_cu != 0` 会 raise，不会回退

两者都是 `NotImplementedError`，**[实测]** 确认。这件事要紧，是因为把某个
backend 的 arch gate 从 `is_gfx950()` 放宽**本身是不够的**。五处会立刻出问题：

| # | 什么 | 触发条件 | 结果 |
|---|---|---|---|
| 1 | `execute` 无条件传 `cap_cu=` | `num_cu` 有值 —— 现有测试 parametrize 了 `[0, 16, 32]` | raise，**不会**回退 Triton |
| 2 | import 路径写死 gfx950 模块 | 任何调用 | flydsl 0.3.x 下 `ImportError` |
| 3 | `can_handle` 没有 `K % tile_k` 检查 | `K % 64 != 0` | `AssertionError` |
| 4 | variable-K 无条件传 `trans_c=` | 前向 `trans_b=True` → autograd 设 `trans_c=True` | raise |
| 5 | 没有 `grouped_gemm_bf16_variable_k_supported` 检查 | `OUT_M` 或 `OUT_N` 小于 tile | `AssertionError` |

**dispatcher 的职责是拒绝，不是发现。** 把这些负向条件加进 `can_handle`，
让不支持的组合回退；被显式 pin 的 backend 在 `can_handle` 里拒绝会按设计
raise `ValueError`，所以 pin 了 backend 的测试需要相应加 skip。

`trans_c` 尤其**不需要动 kernel**：`(AᵀB)ᵀ = BᵀA`，所以交换操作数就得到
`trans_c=True` 想要的布局，**零成本** —— CK 和 Triton 的 variable-K backend
本来就是这么做的。

### ⚠️ `N == K` 会让 `b_nt` 的形状断言失效

NN 入口用 `b_nt.shape == (G, N, K)` 来抓住调用方误传 `b` 本身。
**当 `N == K` 时这个断言分辨不了两者**，于是算出一堆形状完全正确的垃圾。

这不是假设：**gpt-oss fc2 就是 `N = K = 2880`**，一个真实的生产 MoE shape，
占交付矩阵三行。断言的报错信息点名了这种情况。原生 NN 路径根本不需要 `b_nt`，
从而消除了这个暴露面。

### `MAX_G = 64` 是 gfx950 的实测结果，不能搬过来

这个上限来自 gfx950 的 MFMA kernel（"clean through G=65, wrong past it;
G=80 and G=96 both fail"）。**[实测] 在 gfx1250 上，G = 32 / 48 / 64 / 65 /
80 / 96 / 128 / 160 在三个算子上全部 PASS**，`rel_fro` 全程 1.7e-3 ——
包括 gfx950 明确失败的那两个值。这与结构判断一致：`_decode_m_tile` 的二分
搜索会按 G 自适应。这个上限可以放宽，而且有数据支撑。

### 任何转置 stage 上都造不出 `tile_n = 192`

TDM 的 `pad_interval` 必须是 2 的幂，而转置 B stage 的行宽是 `tile_n * 2`。
flydsl 报 `padInterval must be a power of two (in elements), got 384`。
这对 wgrad 同样适用，所以 `_pick_variable_k_config` 里没有 192 分支 ——
而且在那边它是**在 MLIR 内部 abort，而不是干净地 raise**。

---

## 6.3 数值

### ⚠️ `torch.optim.AdamW(fused=True)` 不 bump `param._version`

**[实测]** torch 2.11.0+rocm7.14。`p.data.copy_()` 和 `p.data.add_()` 同样不
bump。任何以 `_version` 为 key 的缓存在一次 fused optimizer step 之后都是
**静默过期**的：端到端复现出 dgrad **9.99e-02 的相对误差**，无异常、无 NaN、
梯度看起来合理。

哪些写入路径会/不会 bump 的完整表格见 `docs/02-dgrad-problem.md` §2.3。

### ⚠️ `ds_load_tr16_b128` 在错位时静默退化

给它一个非 16 字节对齐的地址，它不 fault —— 它变成一次普通的、不转置的
128-bit load。形状对，数值错。

这就是为什么 `nn_native_unsupported_reason()` 把 `N % 8 == 0` 当成**硬门槛**
而不是性能提示，也是为什么 lane 语义是实测而不是推导出来的。
**猜会得到一个看起来正确的答案。**

### device fp64 在这颗芯片上不能当参考

**[实测]** 用 device fp64 matmul 作为数值参考时**12 次错 11 次**。参考必须是
**fp32，在 host 侧用 float64 判定**。本仓库每一个正确性数字都遵循这条规则。

### 定容差之前先搞清你的噪声底

每个通过的点 `rel_fro` 都落在 **1.655e-3 – 1.663e-3**，比 1e-2 的门槛低六倍。
这个数是**把结果存成 bf16 的代价，不是 kernel 的算术误差**。在某一个点上，
三种测法五位有效数字完全一致：

| 比较对象 | `rel_fro` |
|---|---|
| kernel 的 bf16 输出 vs fp32 参考 | 1.6561e-03 |
| 把 fp32 参考**直接量化到 bf16** vs 它自己 | 1.6561e-03 |
| torch 自己的 bf16 grouped matmul vs fp32 参考 | 1.6561e-03 |
| kernel vs torch 的 bf16 matmul | **3.3606e-05** |

kernel 自身的算术误差是最后一行 —— 比噪声底**小 49 倍**。没有这个分解，
1.66e-3 看起来就像是 kernel 误差，会诱使人去调容差而不是去理解它。

### gpt-oss fc2 首调用损坏：没复现，但也没关闭

reference kernel 记录了 `N == K == 2880` 的 dgrad 在一个全新进程的**头 1–2 次
调用**返回损坏结果（一次 7 个 NaN，一次 amax 3.47e36），从第 3 次起稳定，
root cause 未找到。

**[实测] 这里没有复现。** 三个 `avg_m` 值、全新进程、该点是第一个被 launch 的
kernel、各连测 8 次 —— 全部逐位稳定，零 NaN。

**这是"没复现"，不是"已修复"。** burn 3 次验第 4 次的约定保留了下来；
它几乎不花钱，而 root cause 仍然未知。

### TDM 那几个坑，重述一遍

三条都在 `docs/01-architecture.md` §1.4 里带证据。简版：extent 从拷贝的
`imm_offset` 起算而不是描述符 base；**dim-1 extent 约束 load 的数据但不约束
它的寻址**（是 page fault，不是 clamp）；未完成 DMA 的配额是**按 wave 而不是
按 workgroup** 算的（算错会让 `tensor_wait` 变成空操作，产生 71% 的 NaN 输出）。

---

## 6.4 测量方法

### ⚠️ 口径陷阱 —— 本项目里错误结论的最大来源

这个项目里有两次，差点把两个测量内容不同的东西放在一起比。

**wgrad。** 早期有一个吃预转置激活的 wgrad，它的 GEMM 确实更快 —— 交付的
kernel 只有它的 0.79–0.81× —— 但它消费的是预转置过的激活。那两次转置实测占
**端到端 wgrad 时间的 57–75%**（设计文档当初假设 5–15%，低估了 4–5 倍）。
把它们算进去，交付的 kernel **赢 1.98–3.45×**。把转置放在计时器外面来引用
预转置版的 GEMM 数字，会让它虚高 **16.3%**（524 个点的中位数）。于是那个
预转置 kernel 被整个去掉了：**上游只暴露一种口径，这样两者就混不了。**

**dgrad。** 有一组参考数字从未说明权重转置在不在计时器里。它的影响是
**2.33× 到 11.41×（中位 3.87×）** —— 不是 wgrad 那个 ~16% 的量级。最后用三条
独立证据判定它是 hoist 口径；如果当初写下一句话，就不需要第四条了。

**规则：每个数字旁边都写清口径。** 本仓库的表格在列头里写明了自己的口径。

### 要交错测量，否则时钟漂移就成了你的结果

时钟**未锁频**（baseline 早于这个决定，而只给一边锁频会让对比失效）。
让这些比值可信的是别的东西：

- 竞争实现在**同一个进程里逐次交错测量**，所以时钟漂移会同等落在双方身上；
- 每个计时点都采样 `sclk` 并与结果一起报告；
- 5 次以上重复取中位数，每次是一个填满约 40–50 ms 的计时循环，并报告 `cv`。
  **全部 72 个交付点的 cv < 2%**（最大 0.85%）。

**不要跨性能表的三个分段比较绝对数值** —— fwd/wgrad 与 dgrad 是在不同轮次、
不同时钟区间下测的。段内以及四口径对比内都是同 session 的。

### 跨 session 的数字和同 session 的比值是两种主张

原生 NN 流水线的成绩可以有两种说法，两种都是真的：

- 均值吞吐 **1415.5 TF/s**，对比一个跨 session 的历史数字 1355 —— **+4.5%**；
- like-for-like、同 session、交错测量：**0.979** —— **慢 2.1%**。

对"原生 GEMM 是不是比 NT GEMM 快"这个问题，第二个才是真的答案。第一个是跨越
一次时钟漂移的比较。只报第一个会误导；两个都写在 `docs/07-performance.md` 里。

### 改统计方法后要验证数字没被搬动

从 `mean-of-timeit` 换成 `median-of-repeats` 有可能凭空制造出一个加速比。
这一点验证过：用新统计方法重测同一条 Triton baseline，72 个点上比值是
**1.0000**（区间 0.966–1.047）。所以报告的加速比不是统计方法的产物。

---

## 6.5 这颗芯片上 baseline 的意外

如果你要挑一个对照，这些有用。

- **Triton 是唯一靠谱的端到端 baseline。** 全量 sweep 360/360 正确性 PASS。
- **CK 在 gfx1250 上完全不工作**：312/360 ERROR。那 48 个 "PASS" 全是 `B=1`，
  被 autograd 层路由到了 dense 的 hipBLASLt 路径 —— CK 根本没跑。脚本打印的
  "Average Forward TFLOPS: 243.55" 是 48 个 dense 数字被 312 个零稀释的结果。
  **忽略它。**
- **hipBLASLt 只在前向上有意义。** 它拿到了本研究里单点最好的前向数字，但它的
  grouped **NN 和 variable-K 路径只有 ~64 TF/s / 1.3% MFU** —— 落后 19–21 倍。
  它是前向的天花板，不是端到端的对手。
- **hipBLASLt 也慢到没法做 benchmark**：360 个 case 的 sweep 在约 25 分钟里只
  跑到第 46 个，全程 100% GPU、322 个线程，符合"没有为 gfx1250 调优过的 solution、
  正在做大范围逐 shape 搜索"的形态。不是挂了，只是做不了全表。
- 在 `B=1` 的 dense fallback 里，**反向只有约 70 TF/s，而前向是 1600–2400
  TF/s。** 与 grouped GEMM 无关，但应该有人去看一下。
