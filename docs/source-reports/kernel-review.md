# FlyDSL gfx1250 grouped GEMM — 集成前源码评审

**性质**：纯只读源码分析。没有编译、没有导入、没有跑 GPU、没有动 `Primus-Turbo/` 里任何文件。

**被审对象**（`<repo>/kernel/reference/`）

| 文件 | 行数 | 内容 |
|---|---|---|
| `grouped_gemm_bf16_kernel_gfx1250.py` | 2290 | WMMA + wave32 + TDM，三个 op 合并 |
| `grouped_gemm_bf16_dispatch.py` | 158 | 按 arch 分发（非生产路径） |
| `UPSTREAM_NOTES.md` | 489 | 结构对照 / 依赖取舍 / 口径 / 待决问题 |

**对照物**（`<repo>/Primus-Turbo/`）

- 工作树当前在 the local env-compat branch，HEAD at the checkout used here；`main`=a local commit。
  已核对 `git diff --stat main HEAD -- primus_turbo/flydsl primus_turbo/pytorch/kernels/grouped_gemm` **为空**，
  所以本报告引用的所有对照文件内容与 `main@a local commit` 一致。
- `UPSTREAM_NOTES.md` 反复引用的分支 the local integration branch **在本 checkout 里不存在**
  （本地与 `origin` 的分支列表都没有）。因此 §9 的「参考实现的 backend 注册 diff」无法在本机核对，
  只能按 notes 的文字描述重建。

---

## A. API 契约三方对照

### A.1 `grouped_gemm_bf16_nt_flydsl_kernel`（fwd）

| 位置 | gfx950（仓库内，参考版） | gfx1250（新 kernel） | 是否一致 |
|---|---|---|---|
| 0 | `a` | `a` | ✓ |
| 1 | `b` | `b` | ✓ |
| 2 | `group_offs` | `group_offs` | ✓ |
| 3 | `out_dtype=torch.bfloat16` | `out_dtype=torch.bfloat16` | ✓ |
| 4 | `BLOCK_M=256` | `BLOCK_M=0` | ⚠️ 默认值不同 |
| 5 | `BLOCK_N=256` | `BLOCK_N=0` | ⚠️ 默认值不同 |
| **6** | **`GROUP_M=4`** | **`BLOCK_K=0`** | 🔴 **位置错位** |
| 7 | `num_xcd=8` | `m_warp=0` | 🔴 位置错位 |
| 8 | `xcd_band=32` | `n_warp=0` | 🔴 位置错位 |
| 9 | `cap_cu=0` | `num_buffers=0` | 🔴 位置错位 |
| 10.. | — | `GROUP_M=16`, `num_xcd=1`, `xcd_band=32`, `tdm_balance=0`, `wmma_b2b=0`, `epi_fence=2`, `half_n_skip=0`, `inkernel_scan=0`, `m_tiles=None`, `out=None`, `cap_cu=0` | 新增（超集） |

返回值两边都是 `-> torch.Tensor`（`[M_total, N]`）。

**关键字名字层面：gfx950 的全部 6 个关键字（`out_dtype/BLOCK_M/BLOCK_N/GROUP_M/num_xcd/xcd_band/cap_cu`）在 gfx1250 上都存在且同名。**
所以只要调用方全用关键字，就是无缝的。

🔴 **但位置参数从第 7 个（index 6）起完全错位。** 一个写 `nt_kernel(a, b, offs, torch.bfloat16, 256, 256, 4)`
的 bring-up 脚本，在 gfx950 上是 `GROUP_M=4`，在 gfx1250 上会变成 `BLOCK_K=4` →
`_launch_grouped_gemm_bf16_nt` 里 `K_WS = 4 // 32 = 0 < 2` → `ValueError: tile_k=4 needs at least 2 WMMA K-steps`。
这是「会炸但炸得很响」的类型，不会静默算错。

### A.2 `grouped_gemm_bf16_nn_flydsl_kernel`（dgrad）

| 位置 | gfx950 | gfx1250 | 一致性 |
|---|---|---|---|
| 0–3 | `a, b, group_offs, out_dtype=bf16` | 同 | ✓ |
| 4 | `BLOCK_M=256` | `BLOCK_M=0` | ⚠️ 默认值 |
| 5 | `BLOCK_N=256` | `BLOCK_N=0` | ⚠️ 默认值 |
| 6 | `GROUP_M=0` | `GROUP_M=0` | ✓ |
| 7 | `num_xcd=8` | `num_xcd=1` | ⚠️ 默认值 |
| 8 | `xcd_band=32` | `xcd_band=32` | ✓ |
| 9 | `cap_cu=0` | `cap_cu=0` | ✓ |
| 10 | — | `b_nt=None` | 新增 |
| — | — | `**kw`（转发给 NT） | 新增 |

✅ **NN 的位置参数完全兼容 gfx950，一路到 `cap_cu` 都对齐。**

⚠️ 值得向上游指出的不一致：**同一个文件里，NN 保持了 gfx950 的位置顺序，NT 却没有。**
这不是 bug，但对 review 是个明显的不对称点 —— 如果 NT 把 `BLOCK_K/m_warp/n_warp/num_buffers`
挪到 `cap_cu` 之后（跟 NN 一样的做法），NT 也能做到位置兼容。**建议作为 upstream review comment 提出。**

`GROUP_M=0` 的语义两边不同（都是「自己挑」，但挑的值不同）：
- gfx950：`GROUP_M = 8 if K*N*elemsize > 24<<20 else 4`
- gfx1250：`GROUP_M = 16` 无条件（notes §12 说 slab 启发式没在 gfx1250 上重测过）

### A.3 `grouped_gemm_bf16_variable_k_flydsl_kernel`（wgrad）

| 位置 | gfx950 | gfx1250 | 一致性 |
|---|---|---|---|
| 0 | `a` | `a` | ✓ |
| 1 | `b` | `b` | ✓ |
| 2 | `group_k_offsets` | `group_k_offsets` | ✓ |
| 3 | `masked_k=None` | `masked_k=None` | ✓ |
| 4 | `out_dtype=bf16` | `out_dtype=bf16` | ✓ |
| 5 | `BLOCK_M=256` | `BLOCK_M=0` | ⚠️ 默认值 |
| 6 | `BLOCK_N=256` | `BLOCK_N=0` | ⚠️ 默认值 |
| **7** | **`num_xcd=8`** | **`BLOCK_K=0`** | 🔴 **位置错位** |
| 8 | `group_m=4` | `m_warp=0` | 🔴 位置错位 |
| 9 | `xcd_band=32` | `n_warp=0` | 🔴 位置错位 |
| 10 | `cap_cu=0` | `num_buffers=0` | 🔴 位置错位 |
| 11 | `trans_c=False` | `group_m=16` | 🔴 位置错位 |
| 12.. | — | `num_xcd=1`, `xcd_band=32`, `wmma_b2b=0`, `frag_pipeline=1`, `expert_table=None`, `out=None`, `trans_c=False`, `cap_cu=0` | 新增 |

同样：**关键字全同名、全存在**（`masked_k/out_dtype/BLOCK_M/BLOCK_N/num_xcd/group_m/xcd_band/cap_cu/trans_c` 九个一个不缺）；
**位置参数从 index 7 起错位**。注意 gfx1250 还把 `num_xcd`/`group_m` 的相对顺序和 `trans_c`/`cap_cu` 的相对顺序
都跟 gfx950 反过来了 —— 只影响位置调用。

### A.4 `dispatch.py` 实际传参 —— 全部安全

```python
# grouped_gemm_bf16_dispatch.py
return _pick(a).grouped_gemm_bf16_nt_flydsl_kernel(a, b, group_offs, **kw)
return _pick(a).grouped_gemm_bf16_nn_flydsl_kernel(a, b, group_offs, **kw)
return _pick(a).grouped_gemm_bf16_variable_k_flydsl_kernel(
    a, b, group_k_offsets, masked_k=masked_k, **kw
)
```

三个入口都只用 3 个位置参数 + 纯关键字，**没有落进任何位置错位坑**。
`masked_k=` 这个关键字在 gfx950 和 gfx1250 上都存在且语义相同（`None` = 整段 run 都有效），✓ 对得上。

`dispatch.py` 自己的 docstring 也明确写了「Keyword arguments are **not** identical ... a script that
hardcodes them is arch-specific by construction. Pass none of them for portable code.」—— 作者是知道这个问题的。

### A.5 dispatch.py 的两个小缺口（非阻塞）

1. `__all__` 只导出 4 个函数，**没有把 shape gate 透出来**。一个想「先问能不能跑再决定 backend」的
   dispatcher，用 `grouped_gemm_bf16_dispatch` 拿不到 `grouped_gemm_bf16_variable_k_supported`，
   只能自己 `_impl("gfx1250")` 或直接 import arch 模块 —— 那就绕过了 lazy-import 的保护意义。
   建议加一个 `grouped_gemm_bf16_variable_k_supported(a, b)` 的 arch 分发包装。
2. `grouped_gemm_bf16_arch()` 的 allow-list 是 `("gfx1250", "gfx950")` 的子串匹配，
   顺序上 gfx1250 在前 —— 正确（避免 `gfx950` 误匹配），但没有注释说明顺序重要性。

### A.6 结论（A 部分）

**能无缝挂上，条件是「只用关键字调用」。** 生产路径（`grouped_gemm_impl.py`）本来就只用关键字
（`out_dtype=`, `cap_cu=`, `masked_k=`, `trans_c=`），`dispatch.py` 也只用关键字 → 这两条路都安全。

真正会炸的调用路径只有一条：**手写的 bring-up / benchmark 脚本用位置参数传 tile 尺寸**。
NT 从第 7 个位置起、variable_k 从第 8 个位置起会被解释成完全不同的参数。

---

## B. 依赖检查

### B.1 新 kernel 的完整 import 列表

```python
from __future__ import annotations
import functools, warnings, weakref
import torch

import flydsl.compiler as flyc
import flydsl.expr as fx
from flydsl._mlir import ir
from flydsl._mlir.dialects import llvm as _llvm
from flydsl._mlir.dialects import rocdl as _rocdl
from flydsl.expr import const_expr, gpu, range_constexpr, rocdl
from flydsl.expr.arith import _to_raw as _raw
from flydsl.expr.rocdl import tdm_ops
from flydsl.expr.typing import Constexpr, T
from flydsl.expr.typing import Vector as Vec

try:   # 可选，仅用于更友好的 LDS 溢出信息
    from flydsl.runtime.device import get_rocm_arch as _get_arch
    from flydsl.utils.smem_allocator import check_smem_capacity as _check_smem
except Exception:
    ...  # 有 fallback，不会因此 import 失败
```

✅ **`primus_turbo.flydsl.utils.gemm_helper` 完全没有被 import。** 也没有 import 任何
`primus_turbo.*` 模块（连 `pytorch.core.utils.is_gfx1250` 都没有 —— 它自己读 `gcnArchName`）。
这条设计目标（§3「Import safety」）是真的做到了，grep 验证过。

### B.2 🔴 最大的红灯：容器里的 flydsl 是 0.3.2，而 `flydsl.expr.buffer_ops` 已经被移除

从 `logs/build_turbo.log` 里读到的**实测证据**（不是我的推测）：

```
flydsl 0.3.2
...
File ".../primus_turbo/flydsl/attention/flash_attn_bwd.py", line 27, in <module>
    from flydsl.expr import arith, buffer_ops, const_expr, gpu, range_constexpr, rocdl
ImportError: cannot import name 'buffer_ops' from 'flydsl.expr'
    (/opt/venv/lib/python3.12/site-packages/flydsl/expr/__init__.py)
```

两个直接推论：

1. **`flydsl >= 0.3.0` 的版本地板满足（0.3.2），但 0.3.2 的 `flydsl.expr` 命名空间跟 Primus-Turbo main
   预期的不一样 —— `buffer_ops` 整个不见了。**
2. 因此 **gfx950 版 `grouped_gemm_bf16_kernel.py` 在这个容器里本来就 import 不了**：
   它 import `gemm_helper`，而 `gemm_helper.py` 第 26/28 行有
   `from flydsl.expr import buffer_ops as _buffer_ops` 和
   `from flydsl.expr.buffer_ops import buffer_store, create_buffer_resource`。
   → `grouped_gemm_bf16_dispatch.py` 的 `_impl("gfx950")` 分支在本容器里会 `ImportError`。
   在 gfx1250 机器上走不到那条分支，所以**不阻塞**，但要知道「gfx950 fallback 在这台机器上是死的」。
3. 反过来说：**新 kernel 恰好不碰 `buffer_ops`，是三个 flydsl grouped-GEMM 里唯一有机会在 0.3.2 上
   import 成功的。**

同一个 `flydsl.expr` 里消失了一个公开子模块，说明 0.2.x→0.3.2 之间做过命名空间重排。
**这意味着「新 kernel 用的符号在 0.3.2 里是否存在」不能靠版本号推断，必须实测。**

### B.3 符号存在性逐个核对

我**不能**在本机验证 flydsl 符号 —— flydsl 只装在容器里（`/opt/venv/lib/python3.12/site-packages/flydsl`），
主机上 `find / -name 'flydsl*'` 只找到 Primus-Turbo 自己的 `primus_turbo/flydsl` 目录。
所以我做的是**次优但可操作的验证**：把新 kernel 用到的每个 flydsl 点号符号，去 Primus-Turbo main
里找「有没有现成先例」。有先例 = 仓库里已有代码在用同一个 API（在这套 flydsl 上大概率可用）；
无先例 = **这个 API 是新 kernel 首次引入 Primus-Turbo，仓库里没有任何东西能替它作证**。

| 符号 | 仓库内有先例？ | 备注 |
|---|---|---|
| `flyc.jit` / `flyc.kernel` / `flyc.compile` | ✓ | 到处在用 |
| **`flyc.from_c_void_p`** | 🔴 **无** | `_as_ptr()` 的核心。仓库里所有 kernel 都走 `flyc.from_torch_tensor` / `_ptr_only_view` |
| `fx.Int32/Int64/Int8/Float32/Float16/BFloat16` | ✓ | |
| `fx.Tensor` / `fx.make_view` / `fx.make_layout` / `fx.add_offset` | ✓ | |
| `fx.make_rmem_tensor` / `fx.make_copy_atom` / `fx.copy` | ✓ | |
| **`fx.copy_atom_call`** | 🔴 **无** | `_make_lds_copy_ops` 的 load/store |
| **`fx.UniversalCopy`** | 🔴 **无** | 同上 |
| **`fx.ptr_store`** | 🔴 **无** | |
| **`fx.Pointer`**（类型标注） | 🔴 **无** | jit 签名里 16 处；仓库里只见 `fx.PointerType` |
| **`fx.AddressSpace`**（`fx.` 前缀形式） | 🔴 **无** | 仓库是 `from flydsl.expr.typing import AddressSpace` |
| `fx.PointerType` / `fx.inttoptr` / `fx.ptrtoint` / `fx.recast_iter` | ✓ | `gemm_helper` 在用 |
| `fx.SharedAllocator` | ✓（但**只见 `SharedAllocator()`，没见 `static=False`**） | 新 kernel 用 `fx.SharedAllocator(static=False)` + `.base_ptr`，仓库先例全是 `SharedAllocator().allocate(Struct).peek()` |
| `fx.make_mma_atom` / `fx.gemm` / `fx.rocdl` | ✓ | 但 `fx.rocdl` 后面接的是 `cdna4.MFMA*`，不是 `WMMA` |
| `fx.thread_idx` / `fx.block_idx` / `fx.Stream` | ✓ | |
| `rocdl.readfirstlane` / `sched_barrier` / `sched_dsrd` / `sched_mfma` | ✓ | |
| **`rocdl.WMMA`** | 🔴 **无** | 全仓库唯一一处 "WMMA" 出现在 `sparse_mla_bwd.py:1576` 的**注释**里 |
| **`rocdl.make_tdm_atom`** / **`fx.rocdl.make_tdm_atom`** | 🔴 **无** | |
| **`rocdl.ds_load_tr16_b128`** / `_rocdl.ds_load_tr16_b128` | 🔴 **无** | |
| **`rocdl.s_wait_dscnt`** | 🔴 **无** | |
| **`rocdl.disable_xdl_arb_stall`** | 🔴 **无** | |
| **`tdm_ops.tensor_wait`**（`from flydsl.expr.rocdl import tdm_ops`） | 🔴 **无** | 整个 `tdm_ops` 子模块在 Primus-Turbo 里零使用 |
| `from flydsl.expr.arith import _to_raw as _raw` | ✓（3 处）| 但仓库另有 4 处用 `flydsl.expr.utils.arith` 版本 —— 两个路径都存在于 main，**0.3.2 里哪个还在不确定** |
| `from flydsl.expr.typing import Constexpr` | ✓（1 处） | |
| `from flydsl.expr.typing import Vector as Vec` / `import T` | ✓ | |
| `from flydsl._mlir import ir` / `dialects.llvm` | ✓ | |
| **`from flydsl._mlir.dialects import rocdl as _rocdl`** | 🔴 **无** | 仓库只有 `from flydsl._mlir.dialects.rocdl import cvt_pk_bf8_f32` 这种具名 import |
| `from flydsl.runtime.device import get_rocm_arch` | ✓ | 且有 try/except 兜底 |
| `from flydsl.utils.smem_allocator import check_smem_capacity` | ⚠️ 仓库用的是同模块的 `SmemAllocator, SmemPtr`，**`check_smem_capacity` 无先例** | 有 try/except 兜底，不阻塞 |
| `JitFunction.compile_hints["llvm_options"] = {...}`（属性赋值） | 🔴 **无** | 仓库全部用 `with CompilationContext.compile_hints(hints):` 上下文管理器，**没有一处直接给 jit 对象的 `compile_hints` 赋值** |

**红灯汇总（14 个无先例符号 + 2 个用法差异）**，按风险排序：

| 风险 | 符号 | 失败形态 |
|---|---|---|
| **import 时炸** | `tdm_ops`（`from flydsl.expr.rocdl import tdm_ops`）、`_rocdl`（`from flydsl._mlir.dialects import rocdl`）、`Constexpr`、`_to_raw` | 模块级 import → `ImportError`，整个 kernel 文件不可用。**这类是「最容易翻车」的那一档**，而且和 §B.2 的 `buffer_ops` 消失是同一类故障 |
| **首次调用时炸** | `rocdl.WMMA` / `make_tdm_atom` / `ds_load_tr16_b128` / `s_wait_dscnt` / `disable_xdl_arb_stall` / `flyc.from_c_void_p` / `fx.copy_atom_call` / `fx.UniversalCopy` / `fx.ptr_store` / `fx.Pointer` / `fx.AddressSpace` / `SharedAllocator(static=False)` | `AttributeError` / `TypeError` / MLIR 构建期报错 |
| **静默失效** | `compile_hints["llvm_options"]` 直接赋值 | 如果 0.3.2 的 `JitFunction` 没有 `compile_hints` 属性 → `AttributeError`（响）；如果有但 key 名变了 → **`amdgpu-expert-scheduling-mode` 静默不生效**，性能掉但不报错。notes §6 明确说这个 flag 是「validated by our gates, not by construction」，所以它静默失效还可能改变数值行为 |

**结论（B）**：我**无法确认任何一个「指向不存在符号」的红灯**，因为主机上没有 flydsl 可查。
但我能确认的是：**上面 14 个符号在 Primus-Turbo 里一个先例都没有，而同一个 flydsl 版本已经被实测证明
删掉过一个公开子模块（`buffer_ops`）。** 这两件事合起来意味着「import 能过」这个前提**必须先验证再谈别的**。

**最小验证动作**（在容器里，1 分钟，不需要 GPU）：
```python
import flydsl, flydsl.compiler as flyc, flydsl.expr as fx
from flydsl.expr import const_expr, gpu, range_constexpr, rocdl
from flydsl.expr.arith import _to_raw
from flydsl.expr.rocdl import tdm_ops
from flydsl.expr.typing import Constexpr, T, Vector
from flydsl._mlir.dialects import rocdl as _rocdl
print(flydsl.__version__)
for n in ("WMMA","make_tdm_atom","ds_load_tr16_b128","s_wait_dscnt","disable_xdl_arb_stall"):
    print(n, hasattr(rocdl, n))
for n in ("from_c_void_p",): print(n, hasattr(flyc, n))
for n in ("copy_atom_call","UniversalCopy","ptr_store","Pointer","AddressSpace"): print(n, hasattr(fx, n))
print("tensor_wait", hasattr(tdm_ops, "tensor_wait"))
```
这正是 notes §8.7 说的「REPRO_GUIDE.md §4.1 的 5-item probe」—— 但 **`REPRO_GUIDE.md` 不在这批交付物里**
（`upstream/` 下只有 3 个文件），所以那个 probe 脚本拿不到，得自己写。

### B.4 其它依赖事实

- 新 kernel 自带 `_gcn_arch` / `_require_gfx1250`，**不依赖 `primus_turbo.pytorch.core.utils.is_gfx1250`**。
  仓库里 `is_gfx1250()` 确实存在（`core/utils.py:32`，判定 `compute_capability == (12,5)`），
  生产层可以放心用。
- 本地 `__init__.py`（`primus_turbo/flydsl/grouped_gemm/__init__.py`）确认是**纯 licence header，没有任何导出**，
  跟 notes §3 的描述一致。
- 新 kernel 里 `_group_m_tile_decode` / `_xcd_band_remap` 是 `gemm_helper` 同名函数的本地副本。
  notes 声称用纯 Python 模型跑了 140016 点零分歧 —— 这个验证**在本机无法复现**（需要 `gemm_helper` 的
  device IR 语义），只能采信。

---

## C. `UPSTREAM_NOTES.md` 精读

### C.1 wgrad 口径 —— 写得非常明确（原文引用）

wgrad 是**唯一**把口径写清楚的方向。§4a 的对照表：

> | | MI355 `variable_k` | ours (was `wgrad_tn`) |
> |---|---|---|
> | computes | `out[g] = a[rows_g].T @ b[rows_g]` | same |
> | `a` | `[M_total, OUT_M]`, token-major, **not** pre-transposed | `[M_total, N]` (`dout`), same |
> | `b` | `[M_total, OUT_N]`, token-major, **not** pre-transposed | `[M_total, K]` (`x`), same |
> | transpose | in LDS, `ds_read_b64_tr_b16` | in LDS, `ds_load_tr16_b128` |
> | **calibre** | **end to end** | **end to end** |

以及 §4a「The calibre trap this avoids」：

> There were **two** wgrad implementations during bring-up:
>
> | | pre-transposed ("NT wgrad") | in-LDS-transpose (shipped, = `variable_k`) |
> |---|---|---|
> | inputs | `dout_t[N, M]`, `a_t[K, M]` | `dout[M, N]`, `a[M, K]` |
> | needs `.t().contiguous()` first | **yes, two of them** | no |
> | GEMM-only speed | **faster** (this kernel is 0.79–0.81× of it) | slower |
> | end-to-end speed | slower | **1.98–3.45× faster** (6 MoE shapes) |
>
> The two transposes measured **57–75 % of end-to-end wgrad time** — the design notes
> had assumed 5–15 %, a 4–5× underestimate. They run at **1.06–1.09 TB/s** against
> **6.98–7.24 TB/s** for a plain copy of the same bytes (6.7× slower). Quoting the
> pre-transposed kernel's GEMM number while the transposes sit outside the timer
> inflates it by **16.3 %** (median over a 524-point matrix).
>
> **The pre-transposed kernel is therefore not in this submission at all.**

kernel 文件头也复述了一遍，并加了一句给 benchmark 作者的直接指令（`grouped_gemm_bf16_variable_k_flydsl_kernel`
的 docstring）：

> Do **not** compare this against a wgrad that consumes pre-transposed
> activations unless the transposes are inside the same timer: on this part they
> measured 57-75% of end-to-end wgrad time, and excluding them inflates the
> pre-transposed number by 16.3% (median over a 524-point matrix).

**→ benchmark 口径结论（wgrad）**：交付的只有一种实现、一种口径 = **end-to-end，输入 token-major 不预转置**。
计时器里**不包含**任何 `.t().contiguous()`（因为根本不需要）。
和 Triton / CK 的 variable-K 后端（同样吃 un-transposed 的 `a[M,K]`/`b[M,N]`）**天然可比**，
不需要任何口径校正。

### C.2 dgrad 口径 —— ⚠️ notes 里**没有**说清楚

这是我在 489 行里找不到答案的地方，如实报告：

**已经写明的**（§4b，"the single largest review risk"）：

> The WMMA fragment loader wants both operands reduction-contiguous. For dgrad
> (`da[m,k] = Σ_n dout[m,n]·b[g][n,k]`) the weight's reduction axis `n` is its
> *strided* axis. gfx950 handles that with its hardware LDS transpose read, so its NN
> kernel consumes `b[G, K, N]` natively. gfx1250's transpose read is wired up for the
> variable-K kernel but **not** for an NN pipeline ... Our dgrad is therefore the NT
> kernel fed a transposed weight: pure algebra, zero new kernel code, but somebody
> has to pay for the transpose.
>
> ```python
> b_nt = make_nn_weight_nt(b)        # once per optimizer step
> da   = grouped_gemm_bf16_nn_flydsl_kernel(dout, b, offs, b_nt=b_nt)
> ```
>
> * Without `b_nt` the transpose is built per call — a parameter-sized copy at
>   ~1.07 TB/s — and a one-shot `RuntimeWarning` says so.

以及：

> Prior measurement, worth surfacing: the integration branch gates this path behind
> `PRIMUS_TURBO_GFX1250_FLYDSL_GG_TRANSPOSE_B` (default **off**) because
> transpose-per-call "is usually a net loss against Triton".

**没有写明的**：
- 对方那台机器上报的 dgrad TF/s，**是否把 `make_nn_weight_nt` 的那次 copy 算进计时器**。
- 是否传了 `b_nt=`（即每次调用只算 GEMM），还是让它 per-call materialise。
- 我 grep 了全文 `dgrad` 的 7 处出现（§2 结构表、§4b、§6.5 首调用损坏、§6 已否决方向表的
  `inkernel_scan −53.8% dgrad`、§8.6 重测清单、§9 follow-up），**没有一处说 dgrad 的计时边界**。

**这是 benchmark 可比性的最大不确定点。** 量级上不容忽视：

- 转置是「parameter-sized copy at ~1.07 TB/s」。以 qwen3-235b fc1 为例，`b` 是
  `[16, 8192, 4096]` bf16 = 1.07 GB → 一次转置约 1.07 GB / 1.07 TB/s ≈ **1.0 ms**，
  而同一行的 dgrad GEMM（avg_m=512，M_total=8192）FLOPs ≈ 2·8192·4096·8192 = 0.55 TFLOP，
  按 1000 TF/s 算 ≈ **0.55 ms**。**转置比 GEMM 本身还贵。**
- 也就是说：含转置 vs 不含转置的 dgrad 数字可能差 **2–3×**，而不是 16% 那个量级。

**→ benchmark 口径建议（dgrad）**：**必须向对方确认一句话**：dgrad 的 TF/s 是
(a) 传了 `b_nt=` 只测 GEMM，(b) 不传 `b_nt` 含 per-call 转置，还是 (c) 走 `b[G,N,K]` 直接进 NT 入口。
拿不到答复的话，**两种都测并分别列出**，否则 500–1800 TF/s 这个区间没法对齐。

补充一个 Primus-Turbo 侧的结构性事实（notes 里没提，是我从 autograd 层读出来的）：
`primus_turbo/pytorch/ops/grouped_gemm.py` 的 `GroupedGemmFunc.backward` 里
`grad_a = grouped_gemm_impl(grad_out, b, ..., trans_b=not ctx.trans_b)`。所以：

| 前向 `trans_b` | fwd 走 | dgrad 走 | wgrad `trans_c` |
|---|---|---|---|
| `True`（`b=[G,N,K]`） | **NT（原生）** | **NN（要转置）** | `True` → 🔴 gfx1250 `NotImplementedError` |
| `False`（`b=[G,K,N]`，默认） | **NN（要转置）** | **NT（原生）** | `False` → ✓ |

**不管哪种约定，fwd 和 dgrad 里恰好有一个要吃转置代价。** 这一点在做 fwd/dgrad 对比时必须讲清楚，
否则会得到「同一个 kernel 在 fwd 上 1800 TF/s、在 dgrad 上 600 TF/s」这种看起来像 kernel 问题、
实际是口径问题的结果。

（本机 `probe_backends.py` 用的是 `trans_b=True` + `trans_c=True` 那一行，即**最坏组合**。）

### C.3 依赖取舍（§4）说了什么权衡

核心是「**reuse vs local**」的一张逐符号账本（§4.0，17 行）。取舍逻辑分三类：

1. **技术上不可能复用**（多数）：`Mfma16x16x32` → `WMMA`（"gfx12 has no MFMA"）、
   `S2RLoaderTr16x32Bf16Wide` → `ds_load_tr16_b128`（"**different lane semantics** — measured
   empirically ... guessing at them would have produced a plausible wrong answer"）、
   `G2SLoader`/`StoreCBf16`/`make_bf16_buffer_tensor_rebased` → TDM（"There is no SRD on this path"）、
   `make_value_attrs(agpr_alloc)` → n/a（"gfx12 has no AGPRs"）。
2. **架构中立、能复用但故意没复用**（§4「The two "could reuse, deliberately did not (yet)"」）：
   `xcd_band_remap_pid` 和 `_readfirstlane_i32`。三条理由原文：
   > 1. Importing either drags all 2200 lines of `gemm_helper` into a gfx1250-only
   >    module, which defeats the import-safety property in §3 for two functions.
   > 2. **Neither swap can be validated without compiling**, which this pass could not
   >    do. They emit device IR; upstream's versions return `ArithValue` where ours
   >    return `fx.Int32`, and `arith.select` vs. `.select()` is a typing difference
   >    that shows up at MLIR build time, not at `ast.parse` time.
   > 3. `_xcd_band_remap` is **compile-time dead in the shipped configuration**
   >    (`num_xcd=1` short-circuits at `const_expr`), so reusing it buys no
   >    deduplication in the emitted code at all.

   这里有个很实际的细节值得注意：**`ArithValue` vs `fx.Int32` 的返回类型差异**。
   我在仓库里核对过，`gemm_helper` 确实 `from flydsl.expr.utils.arith import ArithValue`，
   而新 kernel 一处都没用 `ArithValue`。所以这个「blind-swap 会改变整条下游表达式的 Python 类型」
   的担心是有依据的。
3. **`ASTRewriter.transform` 整个不用**（§4.0 最后几行）：
   > The rewriter collects loaders built inside a body as `scf.for` iter-args — the reason
   > the gfx950 file wraps its tile work in free functions. Our TDM issue/fence sequencing
   > needs explicit placement of `sched_barrier` and `tensor_wait`, which the rewriter
   > would reorder.

   这是一个**架构性决定**，不是风格选择 —— 也解释了为什么新文件比参考版长 2.4×。

拆分成两个文件的代价，notes 也算清了（§3 "Cost of the split"）：
> the two files duplicate `m_tile_upper_bound`, `build_m_tile_table` and the tile-index
> math (~60 lines). Accepted

### C.4 已知的正确性问题 / 数值问题 / 不支持的 shape

#### C.4.1 🔴 已知正确性 bug（root cause 未找到）

§6.5，原文：

> 5. **gpt-oss fc2 (`N == K == 2880`) dgrad: first 1–2 calls corrupt.** Once 7 NaNs,
>    once amax 3.47e36; 3rd call onward bit-stable over 8 repeats at 0.1409 %. Host
>    fp64 confirms the corruption is real. "Output buffer partially unwritten" was
>    **excluded** by a poison-fill experiment. **Root cause not found.** A correctness
>    harness must burn 3 calls and check the 4th. Timing is unaffected (~1800 calls).

**直接影响我们的测试矩阵**：`gpt-oss-20b fc2` 就是 `N=K=2880`，三个 batch 全中。
正确性 harness 必须 **burn 3 次、验第 4 次**，否则会看到假 FAIL。性能测量不受影响。

#### C.4.2 数值精度基线

- bf16 noise floor：**0.1407–0.1410 %**（多处引用 0.1409%）。验收门槛 `rel_err < 0.01` 且无 NaN。
- warp grid 变化是 **bit-identical** 的：
  > Verified over 176 checks × 11 geometries, every one matching the 4x2 tile to 0.00e+00 relative error.
- ⚠️ **参考值必须用 fp32 + host 侧判定**（§6 已否决方向表）：
  > | device fp64 matmul as a reference | **wrong 11 times in 12** — references must be fp32, judged host-side |
- ⚠️ `amdgpu-expert-scheduling-mode` 开着，且 notes 明说它不是「by construction 安全」：
  > the analogous Triton pass was found to **silently miscompile** bf16 grouped GEMM
  > here, so it is validated by our gates, not by construction. Re-check numerics if it
  > is ever changed.

#### C.4.3 不支持 / 会 raise 的情况（§5 全表）

| 参数 / 条件 | gfx1250 行为 |
|---|---|
| `cap_cu != 0`（三个入口） | `NotImplementedError` |
| `trans_c=True`（variable-K） | `NotImplementedError` |
| `K % tile_k != 0`（NT/NN） | `assert` 失败 |
| `OUT_M < tile_m` 或 `OUT_N < tile_n`（variable-K） | `assert` 失败 |
| `BLOCK_M/BLOCK_N` 默认 | 0 = 按 shape 挑，**不是 256** —— notes 标注「⚠️ *A behaviour change for a caller relying on the default.*」 |
| `GROUP_M` 默认 | 16，不是 4 |
| `num_xcd` 默认 | 1，不是 8（MI455X XCD 数 **未确认**） |

另外 kernel 内部的硬约束（读代码得到，notes 未单列）：
`tile_k % 32 == 0`、`tile_k/32 >= 2`、`(tile_m/m_warp) % 16 == 0`、`(tile_n/n_warp) % 16 == 0`、
`m_warp*n_warp >= 2`、`num_buffers >= 2`、LDS arena `<= 320 KB`。
`_pick_config` / `_pick_variable_k_config` 返回的所有候选都满足（我逐个算过，见 §D.1）。

### C.5 §9「待决问题」+ §8「pre-submit checklist」逐条分级

notes 里「待决」分散在两处：§8 checklist（16 条）和 §9 open questions（4 条）。合并分级：

#### 🔴 会阻塞集成（必须在 merge 前解决）

| # | 内容 | 为什么阻塞 |
|---|---|---|
| §8.1 | **[RE-RUN] 编译三个入口。合并后从未编译过。** | 连 import/compile 都没验证过（§7：`ast.parse` + `pyflakes` 通过，仅此而已）。配合 §B.2 的 `buffer_ops` 前例，这是第一顺位 |
| §8.7 | **确认 flydsl 版本地板**（`rocdl.WMMA` / `make_tdm_atom` / `tdm_ops` / `ds_load_tr16_b128`），并确认 wheel 的编译后端真有 gfx1250 codegen（"0.2.4 does not"） | 同上。容器里是 0.3.2，满足 ≥0.3.0，但 §B.3 的 14 个符号一个先例都没有 |
| §8.2 | **[RE-RUN] 完整正确性回归**（T1/T2/T3），且必须 burn 3 call 验第 4 call | 合并后没跑过任何数值验证 |
| §9.2 | **per-call weight transpose 能否作为 NN 默认？** | 这是 dgrad 的**行为**决定，不只是性能：不传 `b_nt` 会 per-call 复制参数并发 `RuntimeWarning`。生产注册表当前不传 `b_nt`（见 §E.3） |
| §9.4 | **dispatch 长期放哪** | 影响落点。我的建议见 §E |
| （代码里，notes 未列）| **`trans_c=True` 与 `cap_cu!=0` 在生产注册表里会被无条件传下去** | 见 §E.3，这是我发现的、notes 没提的两个硬阻塞 |

#### 🟡 只影响性能 / 可比性（可以先 merge，但影响 benchmark 数字）

| # | 内容 |
|---|---|
| §8.6 | 重测 24 delivery rows × {fwd,dgrad,wgrad}，同 session 交错、sclk 锁定（tile delta 只有 1–10%，跨 session 噪声会吃掉） |
| §8.12 | NN 路径上 sweep `GROUP_M`（gfx950 的 slab 启发式没重测，现在钉死 16） |
| §8.13 | 确认 MI455X 的 XCD 数，重测 `num_xcd` / `xcd_band`（现在 `num_xcd=1` 纯粹因为不知道） |
| §9.3 | 两条 **fitted** `_pick_config` 阈值该不该进上游（一条只在 4 个点上 fit、另一条 **mechanism 未确立**）。「They are worth 9–42 % where they fire」 |
| §8.15 | 用 `ds_load_tr16_b128` 写真正的 NN tile，彻底去掉 dgrad 转置 —— notes 自己说这是 "the single largest remaining structural win" |
| §8.14 | 编译通了以后复用 `xcd_band_remap_pid` / `_readfirstlane_i32`（省 ~45 行） |

#### 🟢 可以先忽略

| # | 内容 |
|---|---|
| §8.3 | **[RE-RUN] `masked_k` 从未执行过**。"correct by construction, never executed"。⚠️ 但注意：生产注册表 `GroupedGEMMVariableKFlyDSLBackend.execute` **就是传 `masked_k=group_lens`** 的，所以在我们的场景下它**不是 🟢 而是 🟡/🔴** —— 只要走 `BackendType.FLYDSL` 的 wgrad 就必然走这条从未跑过的路径 |
| §8.4 | **[RE-RUN] `b_nt` / NN 路径**（有/无 `b_nt` 的正确性、warning 只发一次、shape assert 能抓住把 `b` 当 `b_nt` 传） |
| §8.5 | **[RE-RUN] provenance identity fix**（`group_offs` 用 int32 和 int64 各测一次 reuse 路径）。我们的 `group_offs` 是 int64，风险低 |
| §8.8 | 核对 `gemm_helper` 在目标分支上的符号 —— "*Our file imports none of them*"，我 grep 验证过，确实零依赖 → **真的可以忽略** |
| §8.10 | CI：加 gfx1250 runner，或者给 host helper 加 CPU 侧测试（`m_tile_upper_bound` / `build_m_tile_map` / `build_m_tile_table` / `build_expert_table` / `check_prebuilt` 全是纯 torch，CPU 可跑，**目前完全没测试**） |
| §8.11 | Licence header（Apache-2.0 `###` block）。仓库里 `grouped_gemm/__init__.py` 已经是 Apache 头，格式一致 ✓ |
| §8.16 | root-cause gpt-oss fc2 首调用损坏。现在靠 warm-up 约定盖过去，"which is not a fix" |
| §9.1 | 是否把 pre-transposed wgrad 加回来。notes 自己说 "That is a product decision, not a technical blocker" |

⚠️ 对 §8.3 的重新定级，是我这份评审跟 notes 的一个**实质分歧**：notes 把 `masked_k` 当「correct by
construction」的低风险项，但 Primus-Turbo 的 variable-K FlyDSL backend 是**唯一**一个把
`group_lens` 当 `masked_k` 传进去的 caller（CK/Triton 走 `group_lens` 但语义不同），
所以「从未执行过的代码路径」和「生产路径」在这里是同一条。**必须先测。**

---

## D. Shape 支持范围 vs 目标测试矩阵

### D.1 `_pick_config`（NT / NN 用）逐条读出

```python
@functools.lru_cache(maxsize=64)
def _pick_config(N, K, avg_m, n_groups=0):
    if avg_m <= 64:
        return (64, 128, 64, 2, 2, 3)                      # 未测，无 delivery shape 能到
    if avg_m <= 128 or (n_groups and n_groups * ((avg_m + 255) // 256) <= 8):
        return (128,128,128,2,2,2) if K % 128 == 0 else (128,128,64,2,2,3)
    if K % 128 == 0:
        return (256,256,128,2,2,2)
    if avg_m >= 1536 and N % 192 == 0:
        return (128,192,64,2,2,3)
    return (256,256,64,2,2,3)
```

调用点：`cfg = _pick_config(N, K, max(1, TOTAL_M // max(G,1)), G)`，随后 `assert K % tile_k == 0`。

六个候选 tile 的合法性我逐个验算过（`LDS_ROW = 2·tile_k + 16`，
`ARENA = max(num_buffers · roundup1k(tile_m·LDS_ROW + tile_n·LDS_ROW), roundup128(2·tile_m·tile_n))`）：

| tile | `tile_k/32 ≥ 2` | warp 对齐 | LDS arena | ≤ 320 KB |
|---|---|---|---|---|
| `(64,128,64,2,2,3)` | 2 ✓ | 32/64 ✓ | 82 944 B | ✓ |
| `(128,128,64,2,2,3)` | 2 ✓ | 64/64 ✓ | 110 592 B | ✓ |
| `(128,128,128,2,2,2)` | 4 ✓ | 64/64 ✓ | 139 264 B | ✓（2 WG/CU 可行） |
| `(128,192,64,2,2,3)` | 2 ✓ | 64/96 ✓ | **138 240 B** | ✓ |
| `(256,256,64,2,2,3)` | 2 ✓ | 128/128 ✓ | **221 184 B** | ✓ |
| `(256,256,128,2,2,2)` | 4 ✓ | 128/128 ✓ | **278 528 B** | ✓ |

后三个数字和 docstring 里自报的 `138240` / `3*73728 = 221184` / `278528` **逐字节吻合** →
我对 LDS 公式的理解是对的。

### D.2 `_pick_variable_k_config`（wgrad 用）

```python
@functools.lru_cache(maxsize=64)
def _pick_variable_k_config(OUT_M, OUT_N, avg_m):
    if OUT_M < 256 or OUT_N < 256:
        return (64, 64, 64, 2, 2, 2)
    return (256, 256, 128, 4, 2, 2)
```
```python
def grouped_gemm_bf16_variable_k_supported(OUT_M, OUT_N, avg_m=0) -> bool:
    tile_m, tile_n = _pick_variable_k_config(OUT_M, OUT_N, avg_m)[:2]
    return OUT_M >= tile_m and OUT_N >= tile_n
```

三个要点：

1. **`avg_m` 不参与 tile 选择**（跟 NT 不同）。docstring 解释得很清楚：wgrad 的 `avg_m` 是
   **reduction** 维不是 output 维，缩小 tile 只会把 output traffic 放大 16×。
   实测：12 个 `avg_m ≤ 512` 的 delivery row 里，`256×256×128` 赢 11 平 1。
2. **`m_warp=4`**（不是 NT 的 2）。docstring：
   > **The 4-wave (2x2) warp grid the NT kernel uses does NOT carry over here.**
   > ... the same flip measured 0.976-0.991 on all six rows tried, so `m_warp=4, n_warp=2` stays.
3. **variable-K 完全没有 `K % tile_k` 约束** —— reduction 是 token 轴，靠 TDM dim-0 extent
   逐 tile 截断。这跟 NT/NN 是本质区别。
   `avg_m` 再小（哪怕 1）也不会被 gate 掉。
4. **没有 `tile_n = 192` 分支**（跟 `_pick_config` 不同），原因是 LDS 行宽喂给 TDM atom 的
   `pad_interval`，flydsl 要求它是 2 的幂：
   > A 192-wide output tile aborts inside MLIR rather than raising.

### D.3 目标矩阵逐行判定

记号：fwd 的 kernel 参数 = `(N=N_fwd, K=K_fwd)`；
**dgrad 的 kernel 参数是交换过的** `(N=K_fwd, K=N_fwd)`（因为 dgrad 的 reduction 维是 `N_fwd`）；
wgrad 的 `(OUT_M, OUT_N) = (N_fwd, K_fwd)`。

#### fwd（NT）

| 模型 | 层 | G | N | K | avg_m | `K%128` | 选中 tile | `K % tile_k` | 判定 |
|---|---|---|---|---|---|---|---|---|---|
| gpt-oss-20b | fc1 | 4 | 5760 | **2880** | 512 | 64 ≠0 | `128/128/64/2/2/3` | 2880%64=0 | ✅ |
| gpt-oss-20b | fc1 | 4 | 5760 | 2880 | 1024 | ≠0 | `256/256/64/2/2/3` | 0 | ✅ |
| gpt-oss-20b | fc1 | 4 | 5760 | 2880 | 2048 | ≠0 | `128/192/64/2/2/3`（5760=30·192） | 0 | ✅ |
| gpt-oss-20b | fc2 | 4 | 2880 | **2880** | 512 | ≠0 | `128/128/64/2/2/3` | 0 | ✅ |
| gpt-oss-20b | fc2 | 4 | 2880 | 2880 | 1024 | ≠0 | `256/256/64/2/2/3` | 0 | ✅ |
| gpt-oss-20b | fc2 | 4 | 2880 | 2880 | 2048 | ≠0 | `128/192/64/2/2/3`（2880=15·192） | 0 | ✅ |
| qwen3-30b-a3b | fc1 | 16 | 4096 | 2048 | 512/1024/2048 | =0 | `256/256/128/2/2/2` | 2048%128=0 | ✅×3 |
| qwen3-30b-a3b | fc2 | 16 | 2048 | 2048 | 512/1024/2048 | =0 | `256/256/128/2/2/2` | 0 | ✅×3 |
| qwen3-235b-a22b | fc1 | 16 | 8192 | 4096 | 512/1024/2048 | =0 | `256/256/128/2/2/2` | 0 | ✅×3 |
| qwen3-235b-a22b | fc2 | 16 | 4096 | 4096 | 512/1024/2048 | =0 | `256/256/128/2/2/2` | 0 | ✅×3 |
| deepseek-v3 | fc1 | 32 | 4096 | **7168** | **128** | 7168=56·128 | `128/128/128/2/2/2` | 0 | ✅ |
| deepseek-v3 | fc1 | 32 | 4096 | 7168 | 256/512 | =0 | `256/256/128/2/2/2` | 0 | ✅×2 |
| deepseek-v3 | fc2 | 32 | 7168 | 2048 | **128** | =0 | `128/128/128/2/2/2` | 0 | ✅ |
| deepseek-v3 | fc2 | 32 | 7168 | 2048 | 256/512 | =0 | `256/256/128/2/2/2` | 0 | ✅×2 |

#### dgrad（NN，注意 N/K 互换）

| 模型 | 层 | G | N=K_fwd | K=N_fwd | avg_m | 选中 tile | `K % tile_k` | 判定 |
|---|---|---|---|---|---|---|---|---|
| gpt-oss-20b | fc1 | 4 | 2880 | **5760** | 512 | `128/128/128/2/2/2`（5760=45·128） | 0 | ✅ |
| gpt-oss-20b | fc1 | 4 | 2880 | 5760 | 1024/2048 | `256/256/128/2/2/2` | 0 | ✅×2 |
| gpt-oss-20b | fc2 | 4 | 2880 | **2880** | 512 | `128/128/64/2/2/3` | 2880%64=0 | ✅ |
| gpt-oss-20b | fc2 | 4 | 2880 | 2880 | 1024 | `256/256/64/2/2/3` | 0 | ✅ |
| gpt-oss-20b | fc2 | 4 | 2880 | 2880 | 2048 | `128/192/64/2/2/3` | 0 | ✅ |
| qwen3-30b-a3b | fc1 | 16 | 2048 | 4096 | 全部 | `256/256/128/2/2/2` | 0 | ✅×3 |
| qwen3-30b-a3b | fc2 | 16 | 2048 | 2048 | 全部 | `256/256/128/2/2/2` | 0 | ✅×3 |
| qwen3-235b-a22b | fc1 | 16 | 4096 | 8192 | 全部 | `256/256/128/2/2/2` | 0 | ✅×3 |
| qwen3-235b-a22b | fc2 | 16 | 4096 | 4096 | 全部 | `256/256/128/2/2/2` | 0 | ✅×3 |
| deepseek-v3 | fc1 | 32 | **7168** | 4096 | 128 | `128/128/128/2/2/2` | 0 | ✅ |
| deepseek-v3 | fc1 | 32 | 7168 | 4096 | 256/512 | `256/256/128/2/2/2` | 0 | ✅×2 |
| deepseek-v3 | fc2 | 32 | 2048 | **7168** | 128 | `128/128/128/2/2/2` | 7168%128=0 | ✅ |
| deepseek-v3 | fc2 | 32 | 2048 | 7168 | 256/512 | `256/256/128/2/2/2` | 0 | ✅×2 |

#### wgrad（variable-K）

| 模型 | 层 | OUT_M=N_fwd | OUT_N=K_fwd | tile | `supported()` | 判定 |
|---|---|---|---|---|---|---|
| 全部 24 行 | — | ≥2048 | ≥2048 | `256/256/128/**4**/2/2` | `OUT_M≥256 且 OUT_N≥256` → True | ✅×24 |

### D.4 用户特别关心的三个点

**K=2880（gpt-oss-20b）能过吗？→ 能。**
`2880 % 128 = 64 ≠ 0`，所以 `_pick_config` 走不到 `tile_k=128` 的分支，**自动退到 `tile_k=64`**，
而 `2880 = 45 × 64` 整除。这不是巧合而是设计：`if K % 128 == 0: ... tile_k=128 else tile_k=64`
这个结构保证了只要 `K % 64 == 0` 就一定过 gate。docstring 也点名了：
> K not divisible by 128 (gpt-oss's K=2880) keeps the 64-deep tile.

并且 gpt-oss 的 dgrad 方向 K 变成 5760，而 `5760 = 45 × 128` **反而整除 128**，
所以 gpt-oss fc1 的 fwd 用 `tile_k=64`、dgrad 用 `tile_k=128` —— 同一层两个方向 tile 不同，
benchmark 时别把这当异常。

**K=7168（deepseek-v3）能过吗？→ 能，而且走的是最好的分支。**
`7168 = 56 × 128`，整除 128 → `tile_k=128`（notes 说这是「the largest single lever found, worth
+6.0–10.4%」）。7168 不是 2 的幂，但 `7168 = 2^10 × 7`，128 | 7168。

**avg_m=128 会低于 tile_m 下界吗？→ 不会，NT/NN 根本没有 tile_m 下界。**
- NT/NN 入口的断言只有一条：`assert K % tile_k == 0`。**没有任何 M 方向的下界。**
  M 的零碎（每个 expert 最后一个 tile 短）靠 TDM descriptor 的 dim-0 extent 在硬件里 clamp，
  这是整个设计的起点（文件头：*"the dense gfx1250 kernel already clamps a ragged M with the TDM
  descriptor's dim-0 extent ... no masking code and no second tile class"*）。
- 而且 `avg_m <= 128` 会主动把 tile_m 降到 128（`(128,128,128,2,2,2)`），docstring 里有实测：
  > Measured on all four DeepSeek-V3 avg_m=128 points: 1.09x-1.36x over the 256 tile
- `OUT_M >= tile_m` / `OUT_N >= tile_n` 这条下界**只存在于 variable-K**，约束的是**输出的 N/K 维**
  （分别 ≥ 2048），跟 avg_m 无关。notes §4a 原文：
  > It was the fallback for `OUT_M < tile_m or OUT_N < tile_n`, which after the descriptor
  > back-off fix means `OUT_M < 64 or OUT_N < 64` — **no MoE shape.**

### D.5 结论：**目标矩阵 72 个点（24 行 × 3 方向）里，零个被 shape gate 掉。**

会被挡住的不是 shape，而是**参数与策略**（详见 §E.3）：
`trans_c=True`（wgrad 直接 raise）、`num_cu != None`（cap_cu raise）、
NN 不传 `b_nt`（能跑但吃一次参数级 copy）。

### D.6 反推验证：用对方报的 config 串校验我对 `_pick_config` 的理解

用户给的两个样本串：

| 报告的 config | 我的反推 | 在矩阵里唯一对应的点 |
|---|---|---|
| `BM128/BN128/BK64/mw2/nw2/nb3` | `(128,128,64,2,2,3)` = 窄 tile 分支 **且** `K%128≠0` | 矩阵里唯一 `K%128≠0` 的 K 是 2880，窄 tile 分支要 `G·ceil(avg_m/256) ≤ 8`（G=4, avg_m=512）→ **只能是 gpt-oss @ avg_m=512**：fc1 fwd、fc2 fwd、fc2 dgrad |
| `BM256/BN256/BK128/mw2/nw2/nb2` | `(256,256,128,2,2,2)` = `K%128==0` 主干分支 | qwen3 全部 12 行、deepseek avg_m≥256 的 8 行、gpt-oss fc1 dgrad @1024/2048 |

**独立交叉验证 —— 和 notes 自己的计数对上了。**
`_pick_config` docstring 说窄 tile 的 fitted 那一半：
> **Fires on exactly 4 of 48 delivery points, all of them gpt-oss at G=4.**

48 = 24 行 × {fwd, dgrad}。我按上面规则枚举窄 tile 命中点：

1. gpt-oss fc1 fwd @512 → `(128,128,64,2,2,3)`
2. gpt-oss fc2 fwd @512 → `(128,128,64,2,2,3)`
3. gpt-oss fc1 dgrad @512 → `(128,128,**128**,2,2,2)`（dgrad 的 K=5760，%128=0）
4. gpt-oss fc2 dgrad @512 → `(128,128,64,2,2,3)`

**恰好 4 个，且全是 G=4 的 gpt-oss。** 与 notes 的数字完全一致 → 我对 `_pick_config` 的读法正确。
（注意第 3 个是 `BK128` 而不是 `BK64` —— 如果对方的 48 行里 gpt-oss fc1 dgrad @512 报的是
`BM128/BN128/BK128/mw2/nw2/nb2`，那就是又一处印证。）

**一个可以反过来验对方数据的预测**：矩阵里应该还会出现另外三个 NT/NN config 串
`BM256/BN256/BK64/mw2/nw2/nb3`（gpt-oss @1024）、
`BM128/BN192/BK64/mw2/nw2/nb3`（gpt-oss @2048）、
`BM128/BN128/BK128/mw2/nw2/nb2`（deepseek @128 + gpt-oss fc1 dgrad @512）。

**以及一个强预测**：**所有 wgrad 行的 config 串应该是 `BM256/BN256/BK128/mw4/nw2/nb2`（`mw4`，不是 `mw2`）。**
如果对方的 wgrad 行报的是 `mw2`，那要么他们跑的不是这份代码，要么我对
`_pick_variable_k_config` 的读法有问题 —— **这是一个干净的 falsifiable 检查点，建议拿去核对。**

---

## E. 集成落点建议（**只写计划，本次未改任何文件**）

### E.1 文件落点

| 源文件 | 目标路径 | 说明 |
|---|---|---|
| `grouped_gemm_bf16_kernel_gfx1250.py` | `primus_turbo/flydsl/grouped_gemm/grouped_gemm_bf16_kernel_gfx1250.py` | 与 gfx950 版同目录同级，`dispatch.py` 里的 import 路径 `from primus_turbo.flydsl.grouped_gemm import grouped_gemm_bf16_kernel_gfx1250 as mod` 直接成立，**无需改动** |
| `grouped_gemm_bf16_dispatch.py` | `primus_turbo/flydsl/grouped_gemm/grouped_gemm_bf16_dispatch.py` | 同上 |
| `UPSTREAM_NOTES.md` | **不要放进 `primus_turbo/` 包里** | 建议 `docs/flydsl/gfx1250-grouped-gemm.md`，或者只作为 PR description。它引用了 `REPRO_GUIDE.md`（不在交付物里）和分支 the local integration branch（本 checkout 没有）—— 落库前应把这两个悬空引用改掉或补上 |

Licence：两个 `.py` 都带 Apache-2.0 `###` 头 + FlyDSL provenance，和同目录 `__init__.py` 的现有头格式一致 ✓。

### E.2 `__init__.py` —— 建议**不改**

`primus_turbo/flydsl/grouped_gemm/__init__.py` 当前是**纯 licence header、零导出**（已核对）。
notes §3 的理由成立：

> `grouped_gemm/__init__.py` was **not** touched — upstream's is a bare licence header,
> and putting dispatch there would make every importer of any sibling kernel pay for
> the arch probe.

同目录还有 5 个 kernel（fp8 / fp8_glu / mxfp4 / mxfp4_glu / mxfp8），
在 `__init__.py` 里 eager-import gfx1250 模块会让它们全部在 import 时构建 WMMA/TDM atom。
**保持 bare。** 所有 import 都走完整模块路径（`grouped_gemm_impl.py` 现在就是这么做的，
在 `execute()` 里函数内 import）。

如果 review 坚持要导出，唯一安全的写法是把导出放在 `grouped_gemm_bf16_dispatch.py`，
并补上 §A.5 提到的那个 `variable_k_supported` 分发包装。

### E.3 `grouped_gemm_impl.py` 的 arch gate 改法

这是改动量最大、也最容易出错的地方。当前代码（`BackendType.FLYDSL`）：

```python
class GroupedGEMMFlyDSLBackend(KernelBackend):
    @staticmethod
    def can_handle(a, b, group_lens, group_offs, trans_a, trans_b, num_cu, schedule="static", **kw):
        supported = True
        supported &= is_gfx950()                                  # ← 硬 gate 在这里
        supported &= schedule in _NON_WS_SUPPORTED_SCHEDULES
        supported &= a.dim() == 2 and b.dim() == 3
        supported &= a.dtype in (torch.bfloat16, torch.float16) and b.dtype == a.dtype
        supported &= not trans_a
        return supported

    @staticmethod
    def execute(...):
        from primus_turbo.flydsl.grouped_gemm.grouped_gemm_bf16_kernel import (
            grouped_gemm_bf16_nn_flydsl_kernel, grouped_gemm_bf16_nt_flydsl_kernel)
        kernel = grouped_gemm_bf16_nt_flydsl_kernel if trans_b else grouped_gemm_bf16_nn_flydsl_kernel
        return kernel(a, b, group_offs, out_dtype=a.dtype, cap_cu=_cap_cu(num_cu, a.device))
```

#### 🔴 光把 `is_gfx950()` 改成 `is_gfx950() or is_gfx1250()` 会立刻炸三处

| # | 问题 | 触发条件 | 后果 |
|---|---|---|---|
| 1 | `execute` **无条件传 `cap_cu=_cap_cu(num_cu, a.device)`** | `num_cu` 是 int 且 `< device_cu_count` | gfx1250 `NotImplementedError`，**不是** 回退 Triton。现有测试 `test_grouped_gemm.py` 的 `reduce_num_cu` 参数就是 `[0, 16, 32]` → 直接命中 |
| 2 | `execute` 的 import 路径写死 gfx950 模块 | 任何调用 | 在本容器里因 `gemm_helper` → `flydsl.expr.buffer_ops` 缺失而 `ImportError`（§B.2） |
| 3 | `can_handle` **没有 `K % tile_k` 检查** | `K % 64 != 0`（如 K=1536+…，或任何非 64 倍数的 K） | gfx1250 `AssertionError`。目标矩阵不会触发，但通用 shape 会 |

variable-K 侧还有两处：

```python
class GroupedGEMMVariableKFlyDSLBackend(KernelBackend):
    MAX_G = 64
    can_handle: supported &= is_gfx950(); ...; supported &= not inplace_add_to_out
    execute:  return grouped_gemm_bf16_variable_k_flydsl_kernel(
                  a, b, group_offs, masked_k=group_lens, out_dtype=a.dtype,
                  trans_c=trans_c,                        # ← 🔴
                  cap_cu=_cap_cu(num_cu, a.device))       # ← 🔴
```

| # | 问题 | 触发条件 | 后果 |
|---|---|---|---|
| 4 | **无条件传 `trans_c=trans_c`** | 前向 `trans_b=True` → autograd 的 `trans_c=ctx.trans_b=True` | gfx1250 `NotImplementedError`。本机 `probe_backends.py` 和 `test_grouped_gemm.py`（`trans_c=[False,True]`）都会命中 |
| 5 | 同上 `cap_cu` | 同 #1 | 同 #1 |
| 6 | 没有 `grouped_gemm_bf16_variable_k_supported(OUT_M, OUT_N)` 检查 | `OUT_M < 256` 或 `OUT_N < 256`（gate 实际下界是 64，但 tile 选择在 256 处切换） | `AssertionError`。目标矩阵不触发 |

#### 建议的改法（草案，**未落盘**）

```python
# --- 新增：gfx1250 的 tile_k 预检，和 kernel 里的 _pick_config 保持同一份逻辑 ---
def _gfx1250_nt_tile_k(N: int, K: int, avg_m: int, n_groups: int) -> int:
    """必须与 grouped_gemm_bf16_kernel_gfx1250._pick_config 的第 3 个返回值一致。

    这里刻意不 import kernel 模块 —— can_handle 在每次 dispatch 都跑，
    而 import 那个模块会构建 WMMA/TDM atom。复制 5 行判定 + 一个
    CPU 侧 property test 断言两者一致（见 §8.10 的 CI 建议）。
    """
    if avg_m <= 64:
        return 64
    if avg_m <= 128 or (n_groups and n_groups * ((avg_m + 255) // 256) <= 8):
        return 128 if K % 128 == 0 else 64
    if K % 128 == 0:
        return 128
    return 64


class GroupedGEMMFlyDSLBackend(KernelBackend):
    @staticmethod
    def can_handle(a, b, group_lens, group_offs, trans_a, trans_b, num_cu,
                   schedule="static", **kwargs) -> bool:
        gfx950, gfx1250 = is_gfx950(), is_gfx1250()
        supported = gfx950 or gfx1250
        supported &= schedule in _NON_WS_SUPPORTED_SCHEDULES
        supported &= a.dim() == 2 and b.dim() == 3
        supported &= a.dtype in (torch.bfloat16, torch.float16) and b.dtype == a.dtype
        supported &= not trans_a
        if supported and gfx1250:
            # (1) cap_cu 未实现 —— 与其接下来 raise，不如在这里让位给 Triton
            supported &= _cap_cu(num_cu, a.device) == 0
            # (3) K 必须整除选中的 tile_k
            G, N = b.shape[0], (b.shape[1] if trans_b else b.shape[2])
            K = a.shape[1]
            avg_m = max(1, a.shape[0] // max(G, 1))
            supported &= K % _gfx1250_nt_tile_k(N, K, avg_m, G) == 0
            # (NN) 每次调用都要 materialise 权重转置 —— 默认不接
            #      语义对，但按参考实现的实测「通常打不过 Triton」
            if not trans_b:
                supported &= _GFX1250_ALLOW_NN_TRANSPOSE   # env，默认 False
        return supported

    @staticmethod
    def execute(a, b, group_lens, group_offs, trans_a, trans_b, num_cu,
                schedule="static", **kwargs) -> torch.Tensor:
        if is_gfx1250():
            from primus_turbo.flydsl.grouped_gemm.grouped_gemm_bf16_kernel_gfx1250 import (
                grouped_gemm_bf16_nn_flydsl_kernel, grouped_gemm_bf16_nt_flydsl_kernel)
            kernel = grouped_gemm_bf16_nt_flydsl_kernel if trans_b else grouped_gemm_bf16_nn_flydsl_kernel
            # cap_cu 不传：can_handle 已经保证它会是 0
            return kernel(a, b, group_offs, out_dtype=a.dtype)
        from primus_turbo.flydsl.grouped_gemm.grouped_gemm_bf16_kernel import (
            grouped_gemm_bf16_nn_flydsl_kernel, grouped_gemm_bf16_nt_flydsl_kernel)
        kernel = grouped_gemm_bf16_nt_flydsl_kernel if trans_b else grouped_gemm_bf16_nn_flydsl_kernel
        return kernel(a, b, group_offs, out_dtype=a.dtype, cap_cu=_cap_cu(num_cu, a.device))
```

variable-K 侧，**`trans_c` 不用等新 kernel，用 CK/Triton 已有的算子交换就能解决**：

```python
class GroupedGEMMVariableKFlyDSLBackend(KernelBackend):
    @staticmethod
    def can_handle(a, b, group_lens, group_offs, trans_a, trans_b, trans_c, num_cu,
                   schedule="static", inplace_add_to_out=False, **kwargs) -> bool:
        gfx950, gfx1250 = is_gfx950(), is_gfx1250()
        supported = gfx950 or gfx1250
        supported &= not inplace_add_to_out          # 两边都没有 beta=1 epilogue
        supported &= schedule in _NON_WS_SUPPORTED_SCHEDULES
        supported &= a.dim() == 2 and b.dim() == 2 and a.shape[0] == b.shape[0]
        supported &= a.dtype in (torch.bfloat16, torch.float16) and b.dtype == a.dtype
        supported &= trans_a and not trans_b
        supported &= group_lens.numel() <= GroupedGEMMVariableKFlyDSLBackend.MAX_G
        if supported and gfx1250:
            supported &= _cap_cu(num_cu, a.device) == 0
            from primus_turbo.flydsl.grouped_gemm.grouped_gemm_bf16_kernel_gfx1250 import (
                grouped_gemm_bf16_variable_k_supported)
            # trans_c 用算子交换实现（见 execute），所以这里按交换后的形状判定
            lhs, rhs = (b, a) if trans_c else (a, b)
            supported &= grouped_gemm_bf16_variable_k_supported(lhs.shape[1], rhs.shape[1])
        return supported

    @staticmethod
    def execute(a, b, group_lens, group_offs, trans_a, trans_b, trans_c, num_cu,
                schedule="static", **kwargs) -> torch.Tensor:
        if is_gfx1250():
            from primus_turbo.flydsl.grouped_gemm.grouped_gemm_bf16_kernel_gfx1250 import (
                grouped_gemm_bf16_variable_k_flydsl_kernel)
            # gfx1250 没有 transposed-store epilogue。但 (Aᵀ B)ᵀ = Bᵀ A，
            # 所以交换算子就等价 —— 这正是 CK / Triton 两个 backend 的做法。
            lhs, rhs = (b, a) if trans_c else (a, b)
            return grouped_gemm_bf16_variable_k_flydsl_kernel(
                lhs, rhs, group_offs, masked_k=group_lens, out_dtype=a.dtype)
        from primus_turbo.flydsl.grouped_gemm.grouped_gemm_bf16_kernel import (
            grouped_gemm_bf16_variable_k_flydsl_kernel)
        return grouped_gemm_bf16_variable_k_flydsl_kernel(
            a, b, group_offs, masked_k=group_lens, out_dtype=a.dtype,
            trans_c=trans_c, cap_cu=_cap_cu(num_cu, a.device))
```

> **算子交换的代数验证**：autograd 层传进来的是 `a = x[M, K_fwd]`、`b = grad_out[M, N_fwd]`。
> `trans_c=False` 时要 `out = xᵀ·grad_out = [G, K_fwd, N_fwd]`（对应 `b=[G,K,N]`）；
> `trans_c=True` 时要 `[G, N_fwd, K_fwd]`（对应 `b=[G,N,K]`）。
> 交换后调用 `kernel(grad_out, x, ...)` 算的是 `grad_outᵀ·x = [G, N_fwd, K_fwd]` ✓。
> 这跟 `GroupedGEMMVariableKCKBackend.execute` 里 `if trans_c: lhs, rhs = b, a` 的写法同构。
>
> ⚠️ 这条路径**从未在 gfx1250 上跑过**（notes 里连 `trans_c` 的替代方案都没讨论），
> 必须先验数值再采信。

#### 还需要注意的两点

- **`MAX_G = 64`** 是 gfx950 MFMA kernel 的**实测**边界（注释：*"clean through G=65, wrong past
  it (G=80 and G=96 both fail)"*）。**gfx1250 的 G 上界 notes 里没给**。
  `_decode_m_tile` 的二分 `steps = max(1, (max(2,G)-1).bit_length() + 1)` 对任意 G 都够，
  所以没有结构性上界，但也没有实测数据。目标矩阵 G ≤ 32，保守沿用 64 即可 —— **别放大**。
- **测试文件的 arch gate 也要改**：`tests/pytorch/ops/test_grouped_gemm.py:54` 和 `:635` 现在都是
  `get_device_compute_capability() != (9, 5) → skip`。要让 gfx1250 进来，得放行 `(12, 5)`，
  并且注意该测试 parametrize 了 `reduce_num_cu=[0,16,32]` 和 `trans_c=[False,True]` ——
  按上面的 `can_handle` 改法，这些组合会变成「`can_handle=False`」，
  而测试对「显式 pin 的 backend 却 decline」是当**错误**而不是 fallback 处理的
  （注释原文：*"An explicitly pinned backend that can_handle declines is an error, not a fallback."*），
  所以测试侧要相应加 skip 条件。

### E.4 落地顺序建议

1. **先只做 import + compile 验证**（容器里，`COMPILE_ONLY`，不动 GPU）：跑 §B.3 的符号 probe，
   再 `flyc.compile()` 三个入口。**在这一步之前做任何集成工作都是空中楼阁** —— 合并后的文件
   从未被编译过（notes §7 自己承认），而同一个 flydsl 版本已经被证明删过公开子模块。
2. 两个 `.py` 原样落到 `primus_turbo/flydsl/grouped_gemm/`，`__init__.py` 不动。
3. 正确性回归：T1/T2/T3，参考值用 **fp32 + host 判定**（不要用 device fp64），
   **gpt-oss fc2 burn 3 call 验第 4 call**。单独测 `masked_k`（生产路径必经，且从未执行过）。
4. 改 `grouped_gemm_impl.py` 的两个 backend（按 §E.3），**arch gate 之外优先补 `can_handle` 的
   负向条件** —— 让不支持的组合回退 Triton，而不是 raise。
5. 改测试的 arch gate；同时补 §8.10 说的 host-helper CPU 测试
   （`build_m_tile_map` vs `build_m_tile_table` 的等价性是个很好的 property test，且目前零覆盖）。
6. benchmark：**先和对方对齐 dgrad 口径**（§C.2），然后同 session 交错、sclk 锁定重测。

---

## 附录：本次核对过、但 notes 未提及的事实

1. Primus-Turbo 的 `group_offs` 是 `[G+1] int64`、`group_lens` 是 `[G] int64`
   （`pytorch/ops/grouped_gemm.py` docstring）。gfx1250 的
   `assert group_offs.numel() == G + 1` 和 `assert masked_k.numel() == G` 都对得上 ✓。
2. `_nt_launch` 的 launch tuple 是 **29 项**，`_launch_grouped_gemm_bf16_nt` 的 jit 签名也是 **29 项**，
   逐项顺序我核对过一致（`..., epi_fence, inkernel_scan, half_n_skip`）；
   `_NT_CONSTEXPR0 = 10` 正好是 `M_TILES` 的下标 ✓。
   `_vk_launch` 是 **23 项**，`_VK_CONSTEXPR0 = 7` 正好是 `G` 的下标 ✓。
   （与 notes §7 的自查表吻合。）
3. 注意 NT 的**关键字声明顺序**（`... epi_fence, half_n_skip, inkernel_scan, m_tiles, out, cap_cu`）
   和 **launch tuple 顺序**（`... epi_fence, inkernel_scan, half_n_skip`）不同 ——
   这是对的（tuple 必须按 jit 签名排），但读代码时容易误判成 bug，这里记录一笔。
4. 主机上**没有 flydsl**，只在容器 `/opt/venv/lib/python3.12/site-packages/flydsl`。
   本报告所有「符号是否存在」的判断都是「Primus-Turbo 里有无先例」的代理指标，**不是**对 flydsl 的直接验证。
5. `results/smoke_matrix.csv` 目前只有 3 行 TRITON 基线（gpt-oss-20b fc1, batch=1,
   fwd/dgrad/wgrad，892 / 556 / 474 TF/s）。可以作为 gpt-oss fc1 @avg_m=512 那一行的对照。
