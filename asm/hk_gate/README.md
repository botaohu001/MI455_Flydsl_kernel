# `asm/hk_gate` —— HipKittens 四旋钮编译门的 ISA 证据

`benchmarks/hk_isa_gate.py` 的产物。每个 `<变体>/<pass>.<shape 标签>/kernel_grouped_nt_0/`
下是一次 `COMPILE_ONLY` 编译的完整 dump。

**只有 `21_final_isa.s` 入库**（32 个，3.7 MB）。同目录下 flydsl 还会写 21 个
`.mlir` 中间阶段和 `20_llvm_ir.ll`，合计 268 MB，被仓库根的 `.gitignore`
（`asm/**/*.mlir`、`asm/**/[0-9][0-9]_*.ll`）挡在外面。要拿中间阶段就重跑一次，
一分半钟。

## 重新生成

```
python benchmarks/hk_isa_gate.py \
    --variants control frag_ring sched_style lock_simd split_bar all \
    --json-out results/hk/isa_gate_all.json
```

汇总表（vgpr / spill / LDS / WMMA 条数 / 每 K-tile 抽干次数 / 判定）在
`results/hk/isa_gate_all.json`，该脚本也会把同样的内容打到 stdout。

## 这批 dump 说明了什么

36 次编译（6 变体 × 6 shape）：**32 PASS / 0 WATCH / 0 FAIL / 0 INERT / 4 ERROR**。

- **spill 全场为 0**，所以 spill 门这一轮**一个候选都没判掉**。
  判据是"大 spill"而不是"spill ≠ 0"，见
  [`../../docs/09-measurement-methodology.md`](../../docs/09-measurement-methodology.md) §9.4。
- 4 个 ERROR 全是 `frag_ring=3`（以及包含它的 `all`）撞在
  `tile_k = 64` 的两个 shape 上：`K_WS = tile_k/32 = 2`，第三个环槽**不存在**。
  这是靶子不存在，不是判负。
- **0 个 INERT**：每个实验臂的 `.s` 都与同 shape 的 control 不同，
  所以四个旋钮都真的接到了 launcher 上。

⚠️ **`split_bar` 看不出来在 barrier 计数里。** `gpu.barrier()` 在 gfx1250 上本来
就降成 `s_barrier_signal` / `s_barrier_wait` 一对，所以那两列**不变**、bare
`s_barrier` 恒为 0。能证明它生效的是汇编 sha256 变了。

⚠️ **`lock_simd` 过了门，但它算错。** spill 0、vgpr 与 control 一模一样、WMMA
条数一样，只多一条 `s_setreg` —— 门完全看不出来，是 `hk_ab.py` 的正确性闸拦下的。
机理见 [`../../docs/10-disproven-directions.md`](../../docs/10-disproven-directions.md) §10.5.1。
**过门只是允许花 bench 时间，不代表任何别的东西。**

## `_baseline/`

`--baseline-kernel` 的产物：提交版 kernel 在**完全不传旋钮关键字**下的编译结果，
用来证明工作区的 control 臂与出厂代码逐字节相同（6/6 相同）。
理由见 [`../../docs/09-measurement-methodology.md`](../../docs/09-measurement-methodology.md) §9.1.1。
