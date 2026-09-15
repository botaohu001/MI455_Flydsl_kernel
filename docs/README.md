# `docs/`

`01`–`07`是为毫无背景的读者重写的。它们是对
[`source-reports/`](source-reports/) 里那些工作报告的**重新组织**，不是摘要；
存档才是一手证据，保持原貌。

| | |
|---|---|
| [01-architecture](01-architecture.md) | gfx1250 vs gfx950 逐项对照。为什么思路可搬、代码不可搬。 |
| [02-dgrad-problem](02-dgrad-problem.md) | 转置问题的完整来龙去脉，含三条死路。 |
| [03-isa-investigation](03-isa-investigation.md) | 五条 ISA 路线，四条否决，一条采用。 |
| [04-native-nn-pipeline](04-native-nn-pipeline.md) | 做了什么，以及怎么验证的。 |
| [05-optimization-log](05-optimization-log.md) | 所有试过的手段，含失败的。 |
| [06-pitfalls](06-pitfalls.md) | 踩过的坑，静默失败的那些标了 ⚠️。 |
| [07-performance](07-performance.md) | 全矩阵与测量条件。 |

`08`–`10` 是**另一批素材**：本 kernel 之前那一轮调优战役（内部报告
`perf_opt_v3/v4/v5.md` + 27 轮迭代史 `RESULTS.md` / `REPRO_GUIDE.md`）。
[`05-optimization-log`](05-optimization-log.md) 里每条一行的调优规则，在这三篇里
有完整的机理、测量条件和边界。

> ⚠️ **证据链在这里断了一环**：那批原始报告与 jsonl **不在本仓库内**，数字是
> 逐条核对后抄过来的，标了出处小节但无法像 `01`–`07` 那样回到
> [`source-reports/`](source-reports/) 自查。

| | |
|---|---|
| [08-tuning-playbook](08-tuning-playbook.md) | 六条**实测有效**的手段：做了什么、机理、收益（含测量条件）、外推边界。含两个"把候选挡在 bench 之外"的模型。 |
| [09-measurement-methodology](09-measurement-methodology.md) | 怎么让一个 +2% 站得住：噪声底、夹心口径、compile-only 门、归因阶梯、时钟核对。**可复用性高于任何单条优化。** |
| [10-disproven-directions](10-disproven-directions.md) | 三十几条判负，按五种判负类型分开。含**三条其实不能外推的历史负结论**。 |

## 证据级别标注

七篇文档统一使用。这个区分是**承重的**：本项目推翻了三条"声称"而非"实测"的
结论。

| 标注 | 含义 |
|---|---|
| **[实测]** | 在本项目中于 MI455X (gfx1250) 上真跑出来的 |
| **[ISA]** | 公开发布的 CDNA5 ISA 手册里写了。手册覆盖整个 CDNA5 家族，gfx1250 只是其中一个 target，所以单凭这一条**不能**确立本芯片上的行为。 |
| **[LLVM]** | `llvm-mc -mcpu=gfx1250` 能编码或拒绝。这是"这条指令在这颗芯片上到底存不存在"最可信的来源。 |
| **[FLYDSL]** | 存在于 flydsl 的 Python 接口中，注明版本 |
| **[推断]** | 由以上推理得出；**没有**实测 |

`01`–`10` 中未加标注的结论都是实测。凡是实测到但**机制未解释**的，都会写明
"机制未确立" —— 这个 kernel 里有两条调优规则属于这一类，必须重测而不能外推。
这两条的完整证据、以及被逐条排除掉的候选机理，在
[`08-tuning-playbook`](08-tuning-playbook.md) §8.4 与 §8.7。
