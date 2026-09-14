# `results/` —— 原始测量数据

`docs/` 里引用的每个数字都能追溯到这里的某个文件。保留为 CSV/JSON/纯文本而不是
渲染好的表格，这样可以重新分析。

**下面所有数据的测量条件**：单张 MI455X (gfx1250)，256 CU，时钟**未锁频**
（`sclk` 2010–2331 MHz，逐点采样），torch 2.11.0+rocm7.14，flydsl 0.2.4，
ROCm 7.x 容器。完整细节见 `docs/07-performance.md` §7.0。

> 这些是未发布硬件的绝对吞吐数据。

---

## `nn_pipeline/` —— 交付的 kernel

| 文件 | 内容 |
|---|---|
| `matrix_fwd.csv`、`matrix_dgrad.csv`、`matrix_wgrad.csv` | `docs/07-performance.md` §7.1–7.3 的三张交付表，逐点含 `ms`、`TF/s`、MFU、config、`sclk`、`cv` |
| `quick_nn_vs_hoist.json` | 四口径对比（§7.4）—— native / hoist / per-call 快转置 / Triton，同进程交错 |
| `quick_nn_vs_hoist_pad32.json` | LDS pad 修复之后的同一组；那 6.5% 就在两者之间 |
| `dgrad_calibres.csv`、`.json` | hoist vs per-call 转置，逐点，含隐含转置带宽 |
| `correctness.json` | 48 行门：逐位比对与 `rel_fro`，第 1 次与第 4 次调用分列 |
| `ab_variants.json` | LDS pad sweep，6 shape × 10 pad |
| `probe_nn_frag.out` | 实测到的 lane 映射 —— 让这条流水线可以放心开建的那份输出 |
| `check_full.out`、`smoke_nn.out` | 正确性 harness 的记录 |
| `sweep_narrow.out` | 54 格的 `tile_n`/`tile_k` 组合研究 |
| `bench_matrix.out`、`bench_matrix_final.out` | 完整 benchmark 记录，最后一条 tile 规则前后各一份 |

## `baseline/` —— 这颗芯片上可以拿来对照的东西

| 文件 | 内容 |
|---|---|
| `matrix_TRITON.csv`、`matrix_HIPBLASLT.csv` | 72 点交付矩阵，同一个驱动 |
| `grouped_gemm_bf16_TRITON.csv` | 项目自带的 360 case 全量 sweep —— **360/360 PASS**，唯一完全可用的 backend |
| `grouped_gemm_bf16_CK.csv` | 同一个 sweep 的 CK 结果 —— **312/360 ERROR**。那 48 个 "PASS" 全是 `B=1`，被路由到了 CK 根本没跑的 dense 路径；脚本打印的均值没有意义。见 `docs/06-pitfalls.md` §6.5。 |

hipBLASLt 在这里拿到了单点最好的前向数字，但它的 grouped NN 与 variable-K
路径只有 **~64 TF/s / 1.3% MFU**。它是前向的天花板，不是端到端的对手。

## `flydsl_gfx1250/` —— NN 流水线之前的 reference kernel

96 点矩阵、不均衡分组的重跑、对 Triton 与 hipBLASLt 的逐点加速比，以及正确性
JSON（含 `masked_k` padded-pool 测试和 device-vs-CPU 参考交叉核对）。

`matrix_combined.csv` 是最有用的单个文件：每个点与三个 backend 并排。

## `dgrad_study/` —— 决策研究

| 文件 | 内容 |
|---|---|
| `decision_table.csv` | 42 个 (shape, `avg_m`) cell —— 分发阈值分析 |
| `part1_break_even.csv`、`.json` | `t_gemm` / `t_transpose` / `t_nocache` / Triton 与 N\*，四个独立测量，没有任何一个是相减得来的 |
| `part1b_transpose.csv`、`.json` | **转置对比**：torch 1.07–1.39 TB/s vs tiled Triton 15.5–17.1 TB/s，逐变体记录了是否逐位一致 |
| `part1_fast_tr.*`、`part1_torch_tr.*` | 线性模型对实测 `N ∈ {1,2,4,8,16,32}` 的核对 |
| `part1_extra_avgm.*` | `avg_m ∈ {1536, 3072, 4096}` 的 18 个额外 cell，用来确认那个阈值不是采样网格的假象 |
| `part2_memory.csv` | 缓存的显存代价，对照真实 device 分配核对过 |
| `part3_cache.csv`、`.json` | 缓存原型，含 `AdamW(fused=True)` 失效的那张 `_version` 表 |
| `part4_algebra.csv`、`.json` | 逐组 variable-K 的重排：正确，慢 1.5×–10.5× |
| `wave_quant.txt` | **证伪** —— Spearman −0.55，符号反了 |
| `analysis.txt`、`summary.txt`、`decision.txt` | 渲染好的分析 |

## `isa/` —— 能力探测

`probe_isa.out` 和 `probe_isa2.out` 是 `llvm-mc` 的编码/拒绝结果
（**完全不涉及 GPU**）。`probe_global_tr.out` 是 `global_load_tr16_b128`
lane 语义的硬件实测，含那两个能正确转置的未对齐跨步。

## `smoke_matrix.csv`

三行早期 Triton 数据，作为 gpt-oss fc1 @avg_m=512 那个点的 sanity 锚点。

---

## 怎么读这些 CSV

矩阵类文件的列是稳定的：

```
TestID, Platform, GPU, Backend, Model, Layer, Direction, G, EP, Seq, Batch,
AvgM, TotalM, N, K, Dtype, Check, Time (ms), TFLOPS, MFU (%), cv (%), Config, sclk (MHz)
```

`Config` 的解码方式是
`BM<tile_m>/BN<tile_n>/BK<tile_k>/mw<m_warp>/nw<n_warp>/nb<num_buffers>`。

⚠️ **光看 `Direction` 判断不出口径。** 对 dgrad，要看文件是否区分 `dgrad`
（hoist 的 `b_nt`，只计 GEMM）和 `dgrad_tr`（per-call 转置计入计时）——
两者相差 **2.33×–11.41×**。此前某组数据上的这个歧义花掉了真实时间；
见 `docs/06-pitfalls.md` §6.4。
