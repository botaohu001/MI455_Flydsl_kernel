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

`01`–`07` 中未加标注的结论都是实测。凡是实测到但**机制未解释**的，都会写明
"机制未确立" —— 这个 kernel 里有两条调优规则属于这一类，必须重测而不能外推。
