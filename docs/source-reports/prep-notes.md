# gfx1250 FlyDSL bf16 grouped-GEMM — integration prep notes

Machine: an internal test node with 4x AMD MI455X (gfx1250), SPX/NPS1.
Written while preparing the environment so the missing
`grouped_gemm_bf16_kernel_gfx1250.py` can be dropped in and measured immediately.

**TL;DR** — the environment is built and the baselines are measured. One real
blocker remains: **the repo's flydsl code is 0.2.x-only, the gfx1250 kernel needs
0.3.x, and the two cannot coexist in one importable `primus_turbo.pytorch`** (§1.5).
There is a working way around it for bring-up: `grouped_gemm_bf16_dispatch.py` runs
standalone under flydsl 0.3.x, and `bench_flydsl_gg_matrix.py --standalone` uses
that path (§4.1). Full turbo-registry comparison needs the conflict resolved.

---

## 1. Container environment

### 1.1 Container

```bash
# $IMAGE must be a ROCm 7.x image carrying torch 2.11 + flydsl 0.2.4.
# The original used an internal AMD registry image, redacted here.
docker run -d --name gg \
  --device=/dev/kfd --device=/dev/dri \
  --group-add video --group-add 105 \
  --ipc=host --shm-size 64G --network host \
  --security-opt seccomp=unconfined --cap-add=SYS_PTRACE \
  -v "$PWD":/workspace/gg \
  -w /workspace/gg \
  "$IMAGE" sleep infinity
```

Host docker is a normal rootful daemon (Server 29.5.2), the developer account is in the
`docker` group — no rootless quirks. `--group-add render` **fails**: the image has
no `render` group, so the host gid `105` has to be passed numerically. A
pre-existing `dev_wenx` container on the same image was left alone.

### 1.2 Verified inside the container

| item | value |
|---|---|
| OS / python | Ubuntu 24.04.4, Python 3.12.3, venv at `/opt/venv` |
| GPUs | `rocm-smi` and `amd-smi` both show all 4 cards, idle |
| torch | `2.11.0+rocm7.14.0a20260625` (HIP 7.14.60850) |
| `torch.cuda.device_count()` | 4 |
| `gcnArchName` | `gfx1250` |
| CUs / HBM | 256 CUs, 463.9 GB |
| triton | `3.6.0+rocm7.14.0a20260625` |
| flydsl | **0.2.4** (see §1.5 — this is the blocker) |
| ROCm | no `/opt/rocm`; toolchain ships as the `_rocm_sdk_devel` wheel, `hipcc` on PATH |
| host cores | 255 |

### 1.3 primus_turbo: image copy vs. our checkout

The image ships its **own** checkout at `/workspace/Primus-Turbo`, pip-installed
editable as `primus-turbo 0.4.1.dev12`. It is **not** the same tree as ours:

| | image `/workspace/Primus-Turbo` | ours `<repo>/Primus-Turbo` |
|---|---|---|
| commit | a local commit | a local commit (39 commits newer; a local commit is an ancestor) |
| working tree | heavily dirty (~150 modified files) | clean before our branch |
| gfx1250 bf16 grouped kernel | absent | absent |
| `BUILD_CK_BACKEND` | `False` | `False` (rebuilt) |

Same lineage, ours strictly newer; the image's dirty tree is a pre-upstream
snapshot of roughly the same work.

**We rebuilt from our checkout and installed it editable**, replacing the image's
install (now `primus-turbo 0.0.0.dev396` from `<repo>/Primus-Turbo`).
The C++ build is cheap: **1m27s** with `MAX_JOBS=64` (23 + 22 translation units).
Reproduce with:

```bash
docker exec <container> bash <repo>/build_turbo.sh
```

Two things that build needs:

* `3rdparty/` submodules are not checked out in our clone. Rather than cloning over
  the network, `build_turbo.sh` copies them from the image's tree. For gfx1250 this
  is semantically free: `setup.py:ck_backend_enabled()` force-disables CK on
  gfx1250 and `-DBUILD_HIPKITTENS_BACKEND` is only added when gfx950 is in the arch
  list, so neither submodule's *content* is compiled — only their include paths are
  referenced. (Their `.git` pointer files were deleted afterwards so `git status`
  in our repo works.)
* `GPU_ARCHS=gfx1250`. Mixing gfx1250 with gfx942/gfx950 in one build disables
  turbo/CK for the whole build — `setup.py:get_offload_archs()` warns about this.

The build writes root-owned files into the mounted repo (`build/`,
`primus_turbo/lib/*.so`, `primus_turbo/pytorch/_C*.so`, `_version.py`,
`_build_info.py`). Chown them back if host-side tooling complains.

Also missing from the image and installed by hand: `tabulate`, `pandas` — both are
hard imports of `bench_grouped_gemm_turbo.py`.

### 1.4 Blocker FIXED: `import primus_turbo.pytorch` was dead on our checkout

Our a local commit could not be imported at all under this image's torch:

```
File ".../primus_turbo/pytorch/core/low_precision.py", line 274, in <module>
    register_opaque_type(_opaque_cls, typ="value")
TypeError: Opaque type <class '...Float8QuantConfig'> must subclass
torch._opaque_base.OpaqueBase or 'metaclass=torch._opaque_base.OpaqueBaseMeta'.
```

A torch-vs-repo incompatibility, independent of flydsl: torch 2.11 now requires
every `register_opaque_type()` argument to carry `OpaqueBaseMeta`. The image's
dirty working tree already carries the fix — it was simply never upstreamed, while
the rest of that tree's changes were. Ported verbatim onto a new branch; **main is
untouched**:

* branch the local env-compat branch, commit a local commit
* `primus_turbo/pytorch/core/low_precision.py`, +18/−3: guarded
  `from torch._opaque_base import OpaqueBaseMeta as _OpaqueMeta` (falls back to
  `type` on older torch); `Float8QuantConfig` and `Float4QuantConfig` get
  `metaclass=_OpaqueMeta`; `ScalingRecipe` is split into
  `_ScalingRecipeFields(NamedTuple)` plus
  `class ScalingRecipe(_ScalingRecipeFields, metaclass=_OpaqueMeta)`, because
  `class X(NamedTuple, metaclass=...)` is a metaclass conflict.

After this, `import primus_turbo.pytorch` succeeds. This commit looks upstreamable
as-is.

### 1.5 Blocker OPEN: flydsl 0.2.x vs 0.3.x is a hard conflict

**This is the one thing still standing between us and a turbo-integrated gfx1250 run.**

| | version | has `flydsl.expr.buffer_ops` | has `rocdl/cdna5.py`+`rdna4.py` (gfx1250) |
|---|---|---|---|
| installed in image | **0.2.4** (2026-07-12) | **yes** | **no** |
| required by the gfx1250 kernel | **>= 0.3.0** | no | yes |
| 0.3.0 / 0.3.1 / 0.3.2 | 08-01 / 08-09 / 08-25 | **no** (all three checked) | yes |

PyPI is reachable from the container. `setup.py:529` pins `flydsl==0.2.4` and
explicitly *skips* installing it for gfx1250 builds, with the comment "Triton 3.7.0
and flydsl 0.2.4 does not support gfx1250".

The conflict: **flydsl 0.3.x deleted `flydsl/expr/buffer_ops.py`**, and **27 files
under `primus_turbo/flydsl/` import it**, including the gfx950
`grouped_gemm_bf16_kernel.py` we are meant to compare against. `buffer_load` moved
into `flydsl/expr/rocdl/__init__.py`, but `buffer_store`,
`create_buffer_resource` and `extract_base_index` are simply **gone** — the whole
SRD buffer-resource idiom was retired in favour of the TDM path. So this is not a
mechanical rename.

Why it breaks everything rather than just the flydsl kernels: **11 files under
`primus_turbo/pytorch/` import `primus_turbo.flydsl.*` eagerly at module scope**,
and 7 of the 8 distinct targets need `buffer_ops`. Two of those are on the
`import primus_turbo.pytorch` critical path:

```
primus_turbo.pytorch -> modules.attention -> ops.attention.flash_attn_interface
  -> kernels.attention.attention_flydsl_impl:20 -> flydsl.attention.flash_attn_bwd:27
primus_turbo.pytorch -> ... -> ops.attention.sparse_mla_interface
  -> kernels.attention.sparse_mla_impl:25   -> flydsl.attention.sparse_mla_bwd:26
ImportError: cannot import name 'buffer_ops' from 'flydsl.expr'
```

The full eager set, for whoever fixes this:

| importer under `primus_turbo/pytorch/` | flydsl target | needs `buffer_ops` |
|---|---|---|
| `kernels/attention/attention_flydsl_impl.py:20,23` | `flydsl.attention.flash_attn_{bwd,fwd}` | yes (bwd) |
| `kernels/attention/sparse_mla_impl.py:25,26` | `flydsl.attention.sparse_mla_{bwd,fwd}` | yes |
| `kernels/quantization/quantization_impl.py:12` | `flydsl.quantization.mxfp8_quant_flydsl` | yes |
| `kernels/gemm/gemm_fp8_impl.py:13,14` | `flydsl.gemm.gemm_{fp8,mxfp8}_kernel` | yes (fp8) |
| `kernels/gemm/gemm_fp4_impl.py:14` | `flydsl.gemm.gemm_mxfp4_kernel` | yes |
| `kernels/fused_mega_moe/*.py` (6 files) | `flydsl.grouped_gemm.grouped_gemm_bf16_kernel`, `flydsl.mega`, `flydsl.mega.fp8`, `flydsl.utils.swiglu_kernel` | yes |

Current state: **reverted to flydsl 0.2.4** so the environment is usable for
baselines. A 0.3.2 copy is staged at `<staged-flydsl-0.3.2>` inside the container for
`PYTHONPATH`-based experiments without disturbing the venv.

Resolution options:

1. ~~Hope 0.3.0/0.3.1 kept a `buffer_ops` shim~~ — **checked, they did not.** Dead.
2. **Make the 11 eager imports lazy** so a 0.3.x install degrades to "flydsl
   kernels unavailable" instead of "library unimportable". There is a precedent in
   the tree to copy: `attention_gluon_impl.py:51` `_load_flash_attn_gluon_raw()`
   defers the import and converts a capability `ImportError` into a `RuntimeError`
   that names the cause. A prototype of this on `attention_flydsl_impl.py` worked
   and moved the failure to the next eager site, confirming the approach — it was
   reverted rather than left half-done, since it touches quantization, gemm fp8/fp4,
   fused_mega_moe and sparse_mla, none of which we can test here.
   Note this still leaves the **gfx950** flydsl kernels unavailable under 0.3.x, so
   gfx950-vs-gfx1250 A/B needs two environments either way.
3. Port the 27 `buffer_ops` users to the 0.3.x surface. Large; SRD→TDM is a
   rewrite, not a rename.
4. **Bring-up right now, no code change:** use the standalone dispatch path (§4.1).
   `grouped_gemm_bf16_dispatch.py` needs only `torch` and imports the per-arch
   kernel lazily, so it is importable under 0.3.x. Verified:

   ```
   flydsl 0.3.2
   dispatch module imported OK
   primus_turbo.pytorch imported? False
   arch -> gfx1250
   _impl(gfx1250) -> ImportError: cannot import name 'grouped_gemm_bf16_kernel_gfx1250'
   _impl(gfx950)  -> ModuleNotFoundError: No module named 'flydsl.expr.buffer_ops'
   ```

   i.e. on gfx1250 the **only** thing missing is the kernel file itself.

---

## 2. Integration points and patch plan

Line numbers are against a local commit /
`primus_turbo/pytorch/kernels/grouped_gemm/grouped_gemm_impl.py` (805 lines).

### 2.1 How `BackendType.FLYDSL` is registered and selected

Registration is two plain dict entries:

* `_GROUPED_GEMM_BACKENDS` lines 443-448 — `BackendType.FLYDSL: BackendEntry(GroupedGEMMFlyDSLBackend)`
* `_GROUPED_GEMM_VARIABLE_K_BACKENDS` lines 576-581 — `BackendType.FLYDSL: BackendEntry(GroupedGEMMVariableKFlyDSLBackend)`

Selection is `AutoKernelDispatcher.dispatch()` in `primus_turbo/pytorch/core/backend.py`,
priority **user (env or code) > autotune > default > try-all fallback**. Two
precisions worth stating:

* A user-pinned backend that fails `can_handle` **raises `ValueError`** — it does
  *not* fall back. The "falls back to Triton" wording in
  `grouped_gemm_bf16_dispatch.py`'s docstring describes only the *code-default*
  path (`default_backend=BackendType.TRITON`), not the env-pinned path.
* So `PRIMUS_TURBO_GROUPED_GEMM_BACKEND=FLYDSL` is the right way to test the
  kernel: it fails loudly rather than quietly measuring Triton.

### 2.2 Current arch gate — yes, gfx950 only

| line | backend | gate |
|---|---|---|
| 411 | `GroupedGEMMFlyDSLBackend.can_handle` | `supported &= is_gfx950()` |
| 533 | `GroupedGEMMVariableKFlyDSLBackend.can_handle` | `supported &= is_gfx950()` |

Verified empirically (`probe_backends.py`):

```
device: gfx1250  CUs=256    is_gfx950: False   is_gfx1250: True   build_ck: False
fwd  NT    CK can_handle=False | HIPBLASLT OK | TRITON OK | FLYDSL can_handle=False
wgrad vk   CK can_handle=False | HIPBLASLT OK | TRITON OK | FLYDSL can_handle=False
```

CK is gated off **twice** on gfx1250: `build_ck()` is `False` in this build *and*
lines 92 / 172 carry `supported &= not is_gfx1250()`.

### 2.3 Patch plan (do NOT apply until the kernel file exists)

**P0 — drop the kernel in.** `primus_turbo/flydsl/grouped_gemm/grouped_gemm_bf16_kernel_gfx1250.py`
(expected ~2290 lines). No other wiring: `primus_turbo/flydsl/grouped_gemm/__init__.py`
is a 12-line licence header with no re-exports, so submodules are imported by full
path everywhere.

*Already done:* `grouped_gemm_bf16_dispatch.py` has been placed at its expected
path (branch commit a local commit). Its `_impl()` (lines 105-106) imports the gfx1250
module by exactly the name above.

**P1 — add the arch to the two `can_handle`s.**

`grouped_gemm_impl.py:411`, in `GroupedGEMMFlyDSLBackend.can_handle`:

```python
# was:  supported &= is_gfx950()
supported &= is_gfx950() or is_gfx1250()
```

`grouped_gemm_impl.py:533`, in `GroupedGEMMVariableKFlyDSLBackend.can_handle`, the
same change **plus** the two gfx1250-only shape constraints the dispatch docstring
calls out (`OUT_M >= tile_m`, `OUT_N >= tile_n`):

```python
supported &= is_gfx950() or is_gfx1250()
...
if is_gfx1250():
    from primus_turbo.flydsl.grouped_gemm.grouped_gemm_bf16_kernel_gfx1250 import (
        grouped_gemm_bf16_variable_k_supported,
    )
    # OUT_M = a.shape[1], OUT_N = b.shape[1] for trans_a=True / trans_b=False
    supported &= grouped_gemm_bf16_variable_k_supported(a.shape[1], b.shape[1])
```

The signature of `grouped_gemm_bf16_variable_k_supported` is **unknown** until the
file arrives — confirm before wiring. Also: the existing `MAX_G = 64` cap (line
515, checked at 542) is documented as a *gfx950* measurement ("clean through G=65,
wrong past it"). gfx1250 needs its own bound; do not assume 64 carries over. Note
the target matrix goes to G=32, comfortably inside it either way.

**P2 — route the import to the per-arch module.** `grouped_gemm_impl.py:434-440`
(`GroupedGEMMFlyDSLBackend.execute`) hardcodes the gfx950 module:

```python
from primus_turbo.flydsl.grouped_gemm.grouped_gemm_bf16_kernel import (
    grouped_gemm_bf16_nn_flydsl_kernel,
    grouped_gemm_bf16_nt_flydsl_kernel,
)
kernel = grouped_gemm_bf16_nt_flydsl_kernel if trans_b else grouped_gemm_bf16_nn_flydsl_kernel
return kernel(a, b, group_offs, out_dtype=a.dtype, cap_cu=_cap_cu(num_cu, a.device))
```

Replace with the arch dispatch that now exists — this is precisely what it is for:

```python
from primus_turbo.flydsl.grouped_gemm.grouped_gemm_bf16_dispatch import (
    grouped_gemm_bf16_nn,
    grouped_gemm_bf16_nt,
)
kernel = grouped_gemm_bf16_nt if trans_b else grouped_gemm_bf16_nn
return kernel(a, b, group_offs, out_dtype=a.dtype, cap_cu=_cap_cu(num_cu, a.device))
```

**Caveat, and it matters:** `cap_cu` is a *gfx950* knob. dispatch.py says the
gfx1250 knobs are `BLOCK_K` / `m_warp` / `epi_fence` and that kwargs pass straight
through, so `cap_cu=` will be a `TypeError` on the gfx1250 kernel unless it happens
to accept it. Either the kernel accepts `cap_cu`, or `execute()` branches on arch
for the kwargs. Same at lines 565-573 for `variable_k`, which passes `trans_c=`
and `cap_cu=`. **`trans_c` is load-bearing**, not a tuning knob — turbo's wgrad
always calls with `trans_c=ctx.trans_b` (`ops/grouped_gemm.py:174`), so the gfx1250
kernel must support it.

`grouped_gemm_impl.py:558-573` (`GroupedGEMMVariableKFlyDSLBackend.execute`): same
substitution to `grouped_gemm_bf16_dispatch.grouped_gemm_bf16_variable_k`, keeping
`masked_k=group_lens`.

**P3 — the NN cost trap.** On gfx1250 there is no native NN pipeline: the kernel
transposes `b` and runs NT, materialising the copy **per call** unless the caller
hoists it via `b_nt=make_nn_weight_nt(b)`. turbo's dgrad
(`ops/grouped_gemm.py:157-166`) hits the NN path on every backward. Options:
(a) accept the per-call transpose and label the number, (b) cache the transposed
weight keyed on `b`'s storage, (c) benchmark dgrad as NT. For the first comparison
(a) is honest and simplest — but it must be labelled, because the gfx950 dgrad has
no such copy and the comparison is otherwise unfair.

**P4 — nothing to change** in `grouped_gemm_utils.py` (151 lines) or in
`primus_turbo/pytorch/ops/grouped_gemm.py`. Both are backend-agnostic.

### 2.4 The three operators through turbo's autograd

`GroupedGemmFunc` in `primus_turbo/pytorch/ops/grouped_gemm.py`:

| pass | line | call | operator |
|---|---|---|---|
| forward | 92-103 | `grouped_gemm_impl(a, b, trans_a=False, trans_b=trans_b)` | **NT** when `trans_b=True` |
| dgrad | 157-166 | `grouped_gemm_impl(grad_out, b, trans_a=False, trans_b=not ctx.trans_b)` | **NN** (same `b`, flag flipped) |
| wgrad | 167-180 | `_bgrad_grouped_gemm_impl_wrapper(a, grad_out, trans_a=True, trans_b=False, trans_c=ctx.trans_b)` | **variable-K** |

Details that matter:

* dgrad reuses the **forward's** `b` buffer and only flips `trans_b`; it does not
  transpose host-side. With `trans_b=True` forward (the MoE default) dgrad is NN.
* wgrad has two entry points: `grouped_gemm_variable_k_impl` normally, and
  `grouped_gemm_variable_k_accum_impl` (beta=1 into `out`) when
  `fuse_bgrad_accum_pattern="megatron"`. **Both FlyDSL backends decline
  `inplace_add_to_out`** (line 535: `supported &= not inplace_add_to_out`), so
  Megatron-fused wgrad goes elsewhere. Fine for benchmarking; relevant for training.
* `len(group_lens) == 1` short-circuits to the **dense** `gemm_impl` with
  `default_backend=HIPBLASLT` (lines 85-90, 119-154), bypassing the grouped backend
  entirely. This is why the CK baseline shows 48 spurious PASSes (§3.2).

### 2.5 Signature check: dispatch.py vs. the gfx950 kernel

The gfx950 kernel's three public entry points (`grouped_gemm_bf16_kernel.py`):

```python
def grouped_gemm_bf16_nt_flydsl_kernel(              # line 720
    a, b, group_offs, out_dtype=torch.bfloat16,
    BLOCK_M=256, BLOCK_N=256, GROUP_M=4, num_xcd=8, xcd_band=32, cap_cu=0)

def grouped_gemm_bf16_nn_flydsl_kernel(              # line 888
    a, b, group_offs, out_dtype=torch.bfloat16,
    BLOCK_M=256, BLOCK_N=256, GROUP_M=0, num_xcd=8, xcd_band=32, cap_cu=0)

def grouped_gemm_bf16_variable_k_flydsl_kernel(      # line 533
    a, b, group_k_offsets, masked_k=None, out_dtype=torch.bfloat16,
    BLOCK_M=256, BLOCK_N=256, num_xcd=8, group_m=4, xcd_band=32,
    cap_cu=0, trans_c=False)
```

**Verdict: the positional contract matches dispatch.py exactly.** dispatch.py calls

```python
_pick(a).grouped_gemm_bf16_nt_flydsl_kernel(a, b, group_offs, **kw)
_pick(a).grouped_gemm_bf16_nn_flydsl_kernel(a, b, group_offs, **kw)
_pick(a).grouped_gemm_bf16_variable_k_flydsl_kernel(a, b, group_k_offsets, masked_k=masked_k, **kw)
```

so the gfx1250 module only has to keep those three names and the first three
positional parameters (plus the `masked_k` keyword). Everything else is `**kw`
pass-through.

Three mismatches to be aware of, none fatal:

1. dispatch.py's docstring names the gfx950 knobs as `nt_vmcnt` / `waves_per_eu` /
   `cap_cu`. **`nt_vmcnt` and `waves_per_eu` do not exist** in the 943-line gfx950
   kernel — its knobs are `BLOCK_M/BLOCK_N/GROUP_M/num_xcd/xcd_band/cap_cu`. Stale
   docstring, written against a different revision; do not use it as a signature
   reference.
2. `grouped_gemm_bf16_variable_k_supported` and `make_nn_weight_nt` are **only
   referenced in dispatch.py docstrings**, never imported — `__all__` is just the
   four dispatch functions. They are gfx1250-module-level helpers callers reach
   directly, so dispatch.py constrains neither signature.
3. The gfx950 `variable_k` takes `group_m` (lowercase) while NT/NN take `GROUP_M`.
   Keep the same per-operator casing in the gfx1250 module if kwargs are to stay
   portable.

---

## 3. Benchmark: how it works, and the baseline

### 3.1 `bench_grouped_gemm_turbo.py`

```bash
cd Primus-Turbo/benchmark/ops/training
PRIMUS_TURBO_GROUPED_GEMM_BACKEND=TRITON HIP_VISIBLE_DEVICES=0 PYTHONUNBUFFERED=1 \
  python bench_grouped_gemm_turbo.py --dtype bf16 -o out.csv
```

Flags: `--dtype {bf16,fp8}`, `--granularity {tensorwise,rowwise,blockwise}` (fp8
only), `-o/--output`, `--num-shards N --shard-id i`. **There is no shape flag** —
the case table is generated, not configurable.

Case table (`config.py:gen_grouped_gemm_test_cases`, line 520): every model in
`MoEModelConfigs` × `EP ∈ {32,16,8}` (skipping non-divisors) ×
`M ∈ {512,1024,2048,4096,8192,16384}` × `{GateUP, Down}` = **360 cases**.
`B = n_routed_experts // EP` is the local expert count (our `G`), `M` is per-group
rows, total rows `= B*M`; `GateUP` is `N=2*moe_intermediate_size, K=hidden`,
`Down` is `N=hidden, K=moe_intermediate_size`.

Per case: a correctness check against a per-group torch matmul, 20 warmup fwd+bwd,
then `torch.utils.benchmark.Timer(...).timeit(100)` for fwd and for bwd separately.

CSV columns: `TestID, Platform, GPU, Case, B, M, N, K, Dtype, Check,
Forward Time (ms), Forward TFLOPS, Backward Time (ms), Backward TFLOPS`.
`fwd_flops = 2*B*M*N*K`, `bwd_flops = 2*fwd_flops`.

**Limits relative to what we need:** no MFU, no custom shapes, and **backward is
one lumped number** — dgrad and wgrad are never separated. Hence §4.

Backend selection is by env var, parsed by `GlobalBackendManager`
(`core/backend.py:87`): `PRIMUS_TURBO_GROUPED_GEMM_BACKEND=CK|HIPBLASLT|TRITON|FLYDSL|AUTOTUNE`
or `PRIMUS_TURBO_AUTO_TUNE=1`; per-precision syntax (`bf16:TRITON,other:HIPBLASLT`)
also works. `benchmark_suite.yaml` lines 198-235 wire exactly these as suite tasks;
`run_suite.py -d out/ -g grouped_gemm_bf16 -n 4` schedules them across GPUs
(it sets `HIP_VISIBLE_DEVICES` per task and can shard with `-s N`).

`bench_grouped_gemm_turbo.py` block-buffers stdout — pass `PYTHONUNBUFFERED=1`
when redirecting, or you see nothing for many minutes.

### 3.2 Baseline results (`results/baseline/`, raw logs in `logs/`)

| backend | file | result |
|---|---|---|
| TRITON | `grouped_gemm_bf16_TRITON.csv` | **360/360 PASS** |
| CK | `grouped_gemm_bf16_CK.csv` | **312/360 ERROR**, 48 spurious PASS |
| HIPBLASLT | `grouped_gemm_bf16_HIPBLASLT.csv` | **partial** — impractically slow, see below |

**TRITON is the working backend on gfx1250.** 360/360 correctness PASS.

| | mean | min | max |
|---|---|---|---|
| Forward TF/s | 1279 | 87 | 2406 |
| Backward TF/s (dgrad+wgrad lumped) | 770 | 55 | 1178 |

**CK does not work on gfx1250, as expected.** Every genuinely grouped case fails:

```
ValueError: User specified backend CK cannot handle the given inputs:
a=Tensor(shape=torch.Size([16384, 2048]), dtype=torch.bfloat16),
b=Tensor(shape=torch.Size([8, 2816, 2048]), ...), trans_a=False, trans_b=True, ...
```

The 48 PASS rows are **all `B=1`** (Grok-2, Mixtral at EP=8), which
`GroupedGemmFunc.forward` routes to the dense hipBLASLt path — CK never runs. The
script's printed "Average Forward TFLOPS: 243.55" is an artifact: 48 dense
hipBLASLt numbers diluted by 312 zeros. Ignore it.

**HIPBLASLT is functional but pathologically slow to benchmark on gfx1250.** It
computes correct results, but the 360-case sweep reached only TestID 46 in ~25
minutes, sitting at 100% GPU with 322 threads — consistent with hipBLASLt having no
tuned gfx1250 solutions and doing a wide per-shape solution search. Not hung, just
impractical for the full table; the 72-case matrix run (§4.3) is the usable
hipBLASLt measurement. Left running; partial CSV will land at the path above.

One more real finding: in the `B=1` dense fallback, **backward is ~70 TF/s** against
1600-2400 TF/s forward. Unrelated to this task but worth someone's attention.

---

## 4. Target test matrix

### 4.1 The driver: `bench_flydsl_gg_matrix.py`

Turbo's own script **cannot** express the matrix: no shape flag, and backward is
lumped. So `<repo>/bench_flydsl_gg_matrix.py` reuses turbo's
timing (`torch.utils.benchmark.Timer`, same `timeit` path) and its `config.py`
helpers (`gen_grouped_gemm_group_lens`, `get_platform_info`, `check_allclose`) and
only replaces the case table and the reporting. `config.py` imports nothing from
primus_turbo, so it is safe in standalone mode too.

It measures the three operators **separately**, invoked as `GroupedGemmFunc` does:

| direction | registry mode | standalone mode |
|---|---|---|
| `fwd` | `grouped_gemm_impl(a, b_nt, trans_a=False, trans_b=True)` | `grouped_gemm_bf16_nt(a, b_nt, offs)` |
| `dgrad` | `grouped_gemm_impl(grad_out, b_nt, trans_a=False, trans_b=False)` | `grouped_gemm_bf16_nn(grad_out, b_nt, offs)` |
| `wgrad` | `grouped_gemm_variable_k_impl(a, grad_out, trans_a=True, trans_b=False, trans_c=True)` | `grouped_gemm_bf16_variable_k(a, grad_out, offs, masked_k=lens, trans_c=True)` |

Two modes, because §1.5 forces it:

* **`--registry`** (default) — through turbo's registry, pinned with
  `PRIMUS_TURBO_GROUPED_GEMM_BACKEND` (set before importing turbo). Needs flydsl
  0.2.4, so it cannot reach the gfx1250 kernel.
* **`--standalone`** — calls `grouped_gemm_bf16_dispatch` directly. Works under
  flydsl 0.3.x where `primus_turbo.pytorch` does not import. **This is the path
  that can measure the gfx1250 kernel the moment the file lands.**

```bash
# baselines today (flydsl 0.2.4)
python bench_flydsl_gg_matrix.py --backend TRITON    --check -o results/baseline/matrix_TRITON.csv
python bench_flydsl_gg_matrix.py --backend HIPBLASLT --check -o results/baseline/matrix_HIPBLASLT.csv

# the gfx1250 kernel the moment it lands, under a flydsl>=0.3.0 install
PYTHONPATH=<staged-flydsl-0.3.2> python bench_flydsl_gg_matrix.py --standalone --check \
    -o results/matrix_FLYDSL.csv

# once §1.5 is resolved and P1/P2 are applied
python bench_flydsl_gg_matrix.py --backend FLYDSL --check
```

Flags: `--backend --standalone --models --directions --layers --batches --avg-m
--avg-m-mode --warmup --iters --peak-tflops --check --imbalance -o`.
Output CSV: `TestID, Platform, GPU, Backend, Model, Layer, Direction, G, EP, Seq,
Batch, AvgM, TotalM, N, K, Dtype, Check, Time (ms), TFLOPS, MFU (%)` (+ `Error`).
MFU denominator defaults to **5033.2 TF/s** (MI455X peak dense BF16 per AMD's spec
sheet, 5.03 PFLOP/s); override with `--peak-tflops`.

Verified in standalone mode under flydsl 0.3.2 — the only failure is the absent
kernel, i.e. everything else is ready:

```
mode : standalone via grouped_gemm_bf16_dispatch (flydsl 0.3.2)
[1] gpt-oss-20b fc1 fwd G=4 batch=1 avg_m=512 M=2048 N=5760 K=2880
      FAILED ImportError: cannot import name 'grouped_gemm_bf16_kernel_gfx1250'
```

Shapes confirmed to match turbo's own `MoEModelConfigs` at EP=8 — the matrix is a
subset of turbo's table, not a new set:

| model | G | fc1 (N,K) | fc2 (N,K) | from config.py |
|---|---|---|---|---|
| gpt-oss-20b | 4 | 5760, 2880 | 2880, 2880 | `GPT-OSS-20B` n_routed=32, inter=2880, hidden=2880 |
| qwen3-30b-a3b | 16 | 4096, 2048 | 2048, 2048 | `Qwen3-30B-A3B` n_routed=128, inter=2048, hidden=2048 |
| qwen3-235b-a22b | 16 | 8192, 4096 | 4096, 4096 | `Qwen3-235B-A22B` n_routed=128, inter=4096, hidden=4096 |
| deepseek-v3 | 32 | 4096, 7168 | 7168, 2048 | `DeepSeek-V3` n_routed=256, inter=2048, hidden=7168 |

### 4.2 `avg_m` — an ambiguity in the spec, flagged not guessed

The matrix says "avg_m 为 seq*batch/G 量级" but its own worked example contradicts
that formula:

* stated: gpt-oss-20b batch=1 → `avg_m=512`, total M=2048
* `seq*batch/G` = 4096/4 = **1024**, not 512
* `seq*batch*topk/n_routed` = 4096·1·4/32 = **512** ✓

So the driver defaults to `--avg-m-mode topk` (tokens actually routed to one
expert), which reproduces the one concrete example given; `--avg-m-mode seq-over-g`
implements the prose formula. They agree for the three 8-way-topk models and differ
only for gpt-oss-20b. **But both give deepseek-v3 `avg_m ∈ {128,256,512}`**, well
below the other models' `{512,1024,2048}`, and 128 is where the measured numbers
fall off a cliff (252 TF/s wgrad). **Please confirm the intended deepseek-v3
`avg_m`**; if it should also be 512/1024/2048, pass `--avg-m 512 1024 2048`.

### 4.3 Matrix baseline — 72 cases × 2 backends, all PASS

bf16, balanced groups, iters=50, single GPU.
`results/baseline/matrix_TRITON.csv`, `results/baseline/matrix_HIPBLASLT.csv`.

| direction | TRITON mean | min | max | TRITON MFU | HIPBLASLT mean | min | max | HIPBLASLT MFU |
|---|---|---|---|---|---|---|---|---|
| fwd | 1131 | 509 | 1408 | 22.5% | **821** | 253 | **1975** | 16.3% |
| dgrad | **1203** | 530 | **1536** | 23.9% | 64 | 23 | 74 | 1.3% |
| wgrad | **625** | 252 | **939** | 12.4% | 64 | 43 | 71 | 1.3% |

**Read this carefully:** hipBLASLt has the single best forward number (1975 TF/s,
MFU 39%) but its grouped **NN and variable-K paths are ~64 TF/s — roughly 20x
slower than Triton** and MFU 1.3%. So Triton is the only sane end-to-end baseline
on gfx1250, while hipBLASLt sets the forward-only bar.

TRITON per model/batch, fc1 then fc2 (TF/s):

| model | batch | avg_m | fwd fc1/fc2 | dgrad fc1/fc2 | wgrad fc1/fc2 |
|---|---|---|---|---|---|
| gpt-oss-20b | 1 | 512 | 904 / 509 | 565 / 530 | 481 / 412 |
| gpt-oss-20b | 2 | 1024 | 950 / 950 | 1076 / 991 | 612 / 535 |
| gpt-oss-20b | 4 | 2048 | 1238 / 955 | 1106 / 996 | 704 / 588 |
| qwen3-30b-a3b | 1 | 512 | 1171 / 1180 | 1389 / 1237 | 601 / 606 |
| qwen3-30b-a3b | 2 | 1024 | 1234 / 1243 | 1449 / 1302 | 752 / 739 |
| qwen3-30b-a3b | 4 | 2048 | 1265 / 1266 | 1449 / 1291 | 863 / 851 |
| qwen3-235b-a22b | 1 | 512 | 1367 / 1299 | 1483 / 1389 | 650 / 612 |
| qwen3-235b-a22b | 2 | 1024 | 1407 / 1372 | 1535 / 1442 | 817 / 761 |
| qwen3-235b-a22b | 4 | 2048 | 1408 / 1396 | 1536 / 1450 | 939 / 871 |
| deepseek-v3 | 1 | 128 | 664 / 520 | 623 / 688 | 252 / 286 |
| deepseek-v3 | 2 | 256 | 1294 / 1007 | 1199 / 1351 | 402 / 451 |
| deepseek-v3 | 4 | 512 | 1372 / 1166 | 1376 / 1429 | 575 / 634 |

This sits inside the band quoted for the other machine (500-1800 TF/s, MFU
10-35%), with **wgrad the consistent weak spot** — which is the operator the
gfx1250 FlyDSL kernel should be judged on hardest.

FLYDSL through the registry, pre-integration, fails loudly as designed:

```
[1] gpt-oss-20b fc1 fwd G=4 batch=1 avg_m=512 M=2048 N=5760 K=2880
      FAILED ValueError: User specified backend FLYDSL cannot handle the given inputs: ...
```

---

## 5. Open items

1. **flydsl 0.2.x vs 0.3.x (blocks turbo-integrated FLYDSL).** §1.5. 0.3.0/0.3.1
   checked — no `buffer_ops` shim, so option 2 (11 lazy imports) or option 3 (port
   27 files) is required. **Workaround available now:** `--standalone` (§4.1).
2. **`cap_cu` / `trans_c` kwargs** on the gfx1250 kernel — §2.3 P2. `trans_c` is
   mandatory; `cap_cu` may need an arch branch. Confirm against the real file.
3. **`MAX_G = 64`** is a gfx950 measurement; gfx1250 needs its own bound. §2.3 P1.
4. **`grouped_gemm_bf16_variable_k_supported` signature** unknown until the file
   lands. §2.3 P1.
5. **NN dgrad transposes `b` per call** on gfx1250 — makes dgrad comparisons unfair
   unless hoisted or labelled. §2.3 P3.
6. **deepseek-v3 `avg_m`** — spec ambiguity, needs your decision. §4.2.
7. **HIPBLASLT full 360-case sweep** impractically slow on gfx1250; only partial.
   Its dgrad/wgrad being ~64 TF/s is itself a finding. §3.2, §4.3.
8. Megatron-fused wgrad (`inplace_add_to_out`) is declined by both FlyDSL
   backends. §2.4.

## 6. File map

| path | what |
|---|---|
| `PREP_NOTES.md` | this file |
| `build_turbo.sh` | rebuild + editable-install our checkout in the container |
| `probe_backends.py` | per-direction `can_handle`/`execute` probe of all 4 backends |
| `bench_flydsl_gg_matrix.py` | target-matrix driver: 3 directions, MFU, registry **and** standalone modes |
| `results/baseline/matrix_TRITON.csv` | matrix baseline, Triton, 72/72 PASS |
| `results/baseline/matrix_HIPBLASLT.csv` | matrix baseline, hipBLASLt, 72/72 PASS |
| `results/baseline/grouped_gemm_bf16_TRITON.csv` | turbo 360-case sweep, 360/360 PASS |
| `results/baseline/grouped_gemm_bf16_CK.csv` | turbo sweep, CK (312 ERROR) |
| `results/baseline/grouped_gemm_bf16_HIPBLASLT.csv` | turbo sweep, partial |
| `logs/build_turbo.log` | full build log |
| `logs/baseline_*.log`, `logs/matrix_*.log` | raw benchmark output |
| `<staged-flydsl-0.3.2>` (in container) | staged flydsl 0.3.2 for `PYTHONPATH` use |

Branch the local env-compat branch (main untouched):

| commit | change |
|---|---|
| a local commit | `low_precision.py` — torch 2.11 `OpaqueBaseMeta` compat (+18/−3) |
| a local commit | add `primus_turbo/flydsl/grouped_gemm/grouped_gemm_bf16_dispatch.py` (158 lines) |
