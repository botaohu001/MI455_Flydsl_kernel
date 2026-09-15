# 2026-09-15 GPU 不可用事件 —— 证据存档

> **这份文件的用途是保存证据并如实标注它有多硬，不是给事件定性。**
> 归因**未确立**。下面把"实测到的"和"推断的"分开放。

---

## 1. 硬事实（直接观察，不依赖日志）

- `/dev/kfd`、`/sys/class/drm/card1/device/*`、`/dev/dri/card1`、`renderD128`
  **全部消失过**。
- GPU 当时**不可用**；`modprobe -r amdgpu` **卡在内核态，杀不掉**。
- 最终**重启整机**才恢复。重启后 GPU 干净：page fault 0 / reset 0 / ring timeout 0。

这几条是操作者当场实测的，**成立**。

---

## 2. 唯一幸存的内核消息副本

**证据等级：低。** 来自事件当时 agent 工具输出的**转录**，不是日志导出。
持久化日志里**没有**对应记录（见 §3）。原样保留：

```
[Tue Sep 15 10:31:52 2026] amdgpu 0001:01:00.0: amdgpu: GPU reset begin!
[Tue Sep 15 10:31:52 2026] amdgpu 0001:01:00.0: amdgpu: MODE2 reset
[Tue Sep 15 10:31:54 2026] amdgpu 0001:01:00.0: amdgpu: GPU reset succeeded, trying to resume
[Tue Sep 15 10:31:54 2026] amdgpu 0001:01:00.0: amdgpu: [gfxhub] page fault (src_id:0 ring:24 vmid:8 pasid:32771)
[Tue Sep 15 10:31:55 2026] amdgpu 0001:01:00.0: amdgpu: VM_L2_PROTECTION_FAULT_STATUS:0x00801234
[Tue Sep 15 10:31:55 2026] amdgpu 0001:01:00.0: amdgpu: GPU reset(1) succeeded!
[Tue Sep 15 10:32:10 2026] amdgpu 0001:01:00.0: amdgpu: GPU reset begin!
[Tue Sep 15 10:33:29 2026] amdgpu 0001:01:00.0: amdgpu: [gfxhub] page fault (src_id:0 ring:24 vmid:8 pasid:32771)
[Tue Sep 15 10:36:18 2026] amdgpu 0001:01:00.0: amdgpu: GPU reset begin!
[Tue Sep 15 10:40:02 2026] amdgpu 0001:01:00.0: amdgpu: MODE2 reset
[Tue Sep 15 10:45:11 2026] amdgpu 0001:01:00.0: amdgpu: GPU reset begin!
[Tue Sep 15 10:48:33 2026] amdgpu 0001:01:00.0: amdgpu: ring gfx_0.0.0 timeout
[Tue Sep 15 10:50:37 2026] amdgpu 0001:01:00.0: amdgpu: GPU reset begin!
[Tue Sep 15 10:52:03 2026] amdgpu 0001:01:00.0: amdgpu: GPU reset begin!
```

### 这份副本内部的两点观察

1. **序列的第一条是 `GPU reset begin!`，不是 page fault。** page fault 出现在
   `GPU reset succeeded, trying to resume` **之后**。按这个顺序读，**page fault
   更像是 reset/resume 的后果，而不是触发 reset 的原因** —— 至少不能从这份副本
   读出"先越界、后挂卡"。
2. 副本里 reset **成功**（`GPU reset(1) succeeded!`），说明当时
   `gpu_recovery` **不是 0**。而现在读到的是 `gpu_recovery=0`（10:56:27 由操作者
   手动 `modprobe amdgpu gpu_recovery=0 halt_if_hws_hang=1 mtype_local=0 noretry=1`
   设定）。**事件前后机器的驱动参数被改过**，跨时间比较要注意这一点。

---

## 3. 为什么这份副本不能当硬证据

| 问题 | 具体情况 |
|---|---|
| **持久化日志零记录** | `journalctl`（6 个 boot 可查）、`/var/log/syslog`、`/var/log/kern.log` 里 **9-15 全天 0 条 page fault**。 |
| **`kern.log` 在事发前就断了** | 该 boot 写进 `kern.log` 的**最后一行是 09:10:01**，比叠加实验开始（约 10:20）早一个多小时。整个窗口**根本没有落盘**，所以"日志里没有"**不等于**"没发生"，只等于"无法核实"。 |
| **时间戳自相矛盾** | 副本标注 10:31:52，但 boot 记录显示该 boot 结束于 **10:26:17**、下一个 boot 始于 **10:37:30** —— 10:31 那一刻机器**处于关机状态**。`dmesg -T` 由单调时钟推算，时钟调整过就会偏。**这批时间戳不可采信。** |
| **当天重启 7 次** | 06:37 / 06:57 / 08:57 / 10:37 / 11:10 / 12:49 / 13:22。**反复重启不是这一次实验造成的**，是强混杂因素。 |
| **本机 page fault 并非我们独有** | 全库唯一的 page fault 是 **9-13 的 20 行**（`pasid:34160`、`GCVM_L2_PROTECTION_FAULT_STATUS_LO32:0x00C04061`），**不是我们的负载**。 |

---

## 4. 时间相关性（这是目前能说的全部）

| 时刻（文件 mtime，UTC） | 事件 |
|---|---|
| 10:24:01 | `isa_gate_stack.json` 落盘（编译门，`COMPILE_ONLY`） |
| 10:26:17 | `ab_nn_stack.json` + `.log` 落盘 |
| ~10:31（**时间戳不可信**） | 副本中的第一条 `GPU reset begin!` |

⚠️ **叠加实验那次 A/B 是正常跑完的，不是跑挂的**：`ab_nn_stack.log` 完整打印了
PHASE 1/2/3 与结尾的 `wrote results/hk/ab_nn_stack.json`，JSON 里 5 个 shape ×
6 个点 = **30 个计时点齐全**，正确性闸 **20/20 全过、biteq 20/20、nan 0**。
进程写完 JSON 后正常退出。

**所以时间关系是"叠加实验结束之后，GPU 进入不可用状态"，而不是"叠加实验跑到一半
把卡打挂"。** 两者对归因的含义完全不同。

---

## 5. 静态分析结论：**未发现越界证据**

对 `asm/hk_gate/{control,sched_style,split_bar,split_sched}/` 的 `21_final_isa.s`
做了逐项比对（NN 路径，`deepseek-v3.fc1` 与 `qwen3-235b-a22b.fc1` 两个 shape）：

| 比较项 | 结果 |
|---|---|
| 访存指令总数 | **四臂全部 325**，且 `ds_load_b128` 128 / `ds_load_tr16_b128` 128 / `ds_store_b128` 64 / `tensor_load_to_lds` 4 / `tensor_store_from_lds` 1 **逐项相同** |
| 访存立即数偏移多重集 | **逐字节相同**（136 个不同偏移、共 310 处），`split_sched` vs `split_bar` vs `control` 三两相比全部 IDENTICAL |
| 最大 LDS 偏移 | 四臂均 **61152 B**，对着该 shape 重算的 arena **278528 B**，余量充足 |
| 编译门 | 四臂 **spill = 0**、vgpr 790/790/824/824、LDS 与 WMMA 条数与 control 一致 |

`split_sched` 相对 `split_bar` 的**全部**指令差异（同一 shape）：

| 指令 | `split_bar` | `split_sched` |
|---|---|---|
| `s_wait_alu` | 119 | 97 |
| `s_wait_dscnt` | 16 | 21 |
| `s_set_vgpr_msb` | 273 | 254 |
| `s_delay_alu` | 41 | 42 |
| `v_add_nc_u32_e32` | 21 | 23 |
| `v_dual_add_nc_u32` | 3 | 2 |
| `v_nop` | 8 | 7 |

**全部落在调度、等待与标量/地址记账上，没有一条访存指令发生变化。** 地址运算虽被
重新结合（`v_add` 计数变了），但**算出来的偏移多重集完全相同**。

### 源码层面同样没有找到

`sched_style` 只在 `_compute_body` 里插 `rocdl.sched_barrier(0)`（编译器调度栅栏，
**不发射任何指令**）。环索引 `ring[ks % R]`、预热数 `n_prime`、等待量
`inflight = min(K_WS - 1 - ks, R - 1)`、以及 `defer_last` 返回的
`ring[(K_WS - 1) % R]` —— **全部只由 `R`、`K_WS`、`defer_last` 决定，没有一个依赖
`sched_style`**。逐档手算 `K_WS=4, R=2, defer_last=True` 的四次迭代，槽位与
sub-step 的对应关系正确，末次 `s_wait_dscnt(0)` 完整抽干，`_split_fence` 里那条
`_mma_ks(tail)` 只读寄存器。

⚠️ **这条结论的边界**：静态比对能排除"多了一次访存 / 偏移变了"，
**排除不了时序竞态**。`lock_simd` 那次就是访存指令完全没变、只是丢了寄存器互锁，
结果非确定性算错（§10.5.1）。所以正确表述是
**"未发现越界证据"，不是"证明不会越界"**。

---

## 6. 结论

**归因未确立。**

- 叠加臂运行**结束之后不久**，GPU 进入不可用状态并最终需要重启：**存在时间相关性**。
- 但：缺少可核实的一手证据（持久化日志零记录、副本时间戳与 boot 记录矛盾）、
  当天机器重启 7 次构成混杂因素、本机 page fault 并非我们独有、
  那次 A/B **正常跑完且正确性闸全过**、静态分析**未发现越界证据**。
- 副本内部的顺序还显示 **reset 先于 page fault**。

**在证据不足时保守**：`split_bar` + `sched_style` 同时打开的配置**暂时禁用**，
理由是"未排除"，**不是**"已证实有害"。要解禁需要的证据写在
[`../../docs/10-disproven-directions.md`](../../docs/10-disproven-directions.md)
的对应条目里。
