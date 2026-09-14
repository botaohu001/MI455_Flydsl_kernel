# fix(flydsl): defer the FlyDSL kernel imports off the `import primus_turbo.pytorch` path

## Description

Twelve modules under `primus_turbo/pytorch/kernels/` import `primus_turbo.flydsl.*`
at module scope, and every one of them is reached from `import primus_turbo.pytorch`.
A flydsl release that cannot provide any one of those kernels therefore does not
degrade to "that kernel is unavailable" — it makes the entire package unimportable.

This PR moves those imports to the call that needs them, so a missing kernel stays a
missing kernel. It changes no kernel behaviour: the deferred lookup binds the same
object the module-scope import bound (verified below), and the pinned flydsl `0.2.4`
keeps every kernel working exactly as before.

### Why now

The gfx1250 / MI455X bf16 grouped-GEMM kernel requires **flydsl >= 0.3.0**, while
`setup.py` pins **`flydsl==0.2.4`**. flydsl 0.3.x removed `flydsl.expr.buffer_ops` —
the SRD buffer-resource idiom was retired in favour of TDM, so `buffer_store`,
`create_buffer_resource` and `extract_base_index` are gone rather than renamed.
0.3.0, 0.3.1 and 0.3.2 were all checked; none ships a compatibility shim.

27 files under `primus_turbo/flydsl/` import `buffer_ops`, so on flydsl 0.3.x every
FlyDSL kernel module in the tree is unimportable. Before this PR that took the whole
library down:

```
primus_turbo.pytorch
  -> modules.attention -> ops.attention.flash_attn_interface:27
  -> kernels.attention.attention_flydsl_impl:20
  -> primus_turbo.flydsl.attention.flash_attn_bwd:27
ImportError: cannot import name 'buffer_ops' from 'flydsl.expr'
```

After this PR, `import primus_turbo.pytorch` succeeds on flydsl 0.3.2 and the
buffer_ops-dependent kernels raise a `RuntimeError` naming the cause when called.

**This PR does not change the `setup.py` pin.** Moving the pin is an upstream
decision about which flydsl release the project targets, and it is deliberately out
of scope here. This PR only removes the reason a pin change is all-or-nothing.

## Type of change

- [x] Bug fix (non-breaking change which fixes an issue)

## Changes

- **`primus_turbo/pytorch/kernels/flydsl_loader.py` (new, 77 lines)** —
  `load_flydsl_kernel_module(module_name, feature)` imports a `primus_turbo.flydsl`
  kernel module on first use and converts a *capability* `ImportError` into a
  `RuntimeError` naming the installed flydsl version and the module that needs it.
  Any other `ImportError` propagates unchanged, so a genuine fault inside a kernel
  module is not disguised as a missing dependency. Nothing is swallowed.

  This follows the existing precedent in the tree,
  `attention_gluon_impl._load_flash_attn_gluon_raw` (`attention_gluon_impl.py:51`),
  which does the same for the Gluon/Triton capability split.

- **Twelve kernel modules** now resolve their FlyDSL symbols inside the function that
  calls them. The call sites are untouched: each binding shadows the former
  module-level name, so kernel bodies are byte-identical and the diff is confined to
  the import block plus one binding line per using function.

  | module | FlyDSL target |
  |---|---|
  | `kernels/attention/attention_flydsl_impl.py` | `flydsl.attention.flash_attn_{fwd,bwd}` |
  | `kernels/attention/sparse_mla_impl.py` | `flydsl.attention.sparse_mla_{fwd,bwd}` |
  | `kernels/quantization/quantization_impl.py` | `flydsl.quantization.mxfp8_quant_flydsl` |
  | `kernels/gemm/gemm_fp8_impl.py` | `flydsl.gemm.gemm_{fp8,mxfp8}_kernel` |
  | `kernels/gemm/gemm_fp4_impl.py` | `flydsl.gemm.gemm_mxfp4_kernel` |
  | `kernels/fused_mega_moe/fused_mega_moe_forward_impl.py` | `flydsl.mega`, `flydsl.utils.swiglu_kernel` |
  | `kernels/fused_mega_moe/fused_mega_moe_backward_impl.py` | `flydsl.mega`, `flydsl.utils.swiglu_kernel`, `flydsl.grouped_gemm.grouped_gemm_bf16_kernel` |
  | `kernels/fused_mega_moe/fused_mega_moe_stage1_impl.py` | `flydsl.mega` |
  | `kernels/fused_mega_moe/fused_mega_moe_stage2_impl.py` | `flydsl.mega`, `flydsl.utils.swiglu_kernel`, `flydsl.grouped_gemm.grouped_gemm_bf16_kernel` |
  | `kernels/fused_mega_moe/fused_mega_moe_stage1_fp8_impl.py` | `flydsl.mega.fp8` |
  | `kernels/fused_mega_moe/fused_mega_moe_stage2_fp8_impl.py` | `flydsl.mega.fp8` |
  | `kernels/fused_mega_moe/mega_moe_fp8_weights.py` | `flydsl.mega.fp8` |

- **`primus_turbo/flydsl/grouped_gemm/grouped_gemm_bf16_dispatch.py`** — cosmetic
  only, in its own commit. `pre-commit run --all-files` does not pass on the base
  branch: this file is missing the FlyDSL provenance lines `tools/check_license.py`
  expects, and one call is wrapped where `ruff-format` joins it. Kept separate so it
  can be folded into the branch that introduced the file instead.

### Scope note: twelve modules, not two

The `import primus_turbo.pytorch` traceback only ever names the *first* eager
importer, because import aborts there. Measured rather than read off the traceback —
importing `primus_turbo.pytorch` under flydsl 0.2.4 and then inspecting `sys.modules` —
**all twelve** are on the critical path. Fixing only the two the traceback names moves
the failure to the next one. Twelve is the minimal set, not a broadened one.

## Verification

### A. flydsl 0.2.4 (the current `setup.py` pin) — no regression

| check | result |
|---|---|
| `import primus_turbo` / `import primus_turbo.pytorch` | OK |
| Deferred lookup binds the same object as the eager import | **36/36 identical** (`is` comparison over every deferred symbol) |
| No use-before-binding introduced by the local bindings | **124/124 safe** (AST check; 0 on the pristine base tree) |
| Test suite over all touched paths | 223,828 collected, **identical outcome on the base tree and this branch** |

The identity check is the substantive one. Deferring an import preserves behaviour
only if the deferred lookup yields the object the module-scope `from X import y`
bound; every one of the 36 deferred `(module, symbol)` pairs was confirmed identical
under `is`. Since the bound object is the same and the call sites are unchanged, the
executed code is the same code.

The use-before-binding check exists because binding a deferred symbol as a function
local makes that name local to the *whole* function — a use before the binding would
be an `UnboundLocalError` at run time, and `ruff` does not catch that.

### B. flydsl 0.3.2 — the library imports, the grouped-GEMM registry is live

```
$ PYTHONPATH=<staged-flydsl-0.3.2> python -c "import primus_turbo.pytorch; print('OK')"
OK
```

```
BackendType.FLYDSL in grouped-GEMM registry            True
BackendType.FLYDSL in grouped-GEMM variable-K registry True
torch.ops.primus_turbo grouped_gemm ops registered     13
primus_turbo.flydsl.grouped_gemm.grouped_gemm_bf16_dispatch imported, arch -> gfx1250
```

buffer_ops-dependent kernels now fail at the call, not at import:

```
RuntimeError: FlyDSL flash attention backward is unavailable: the installed flydsl
0.3.2 does not provide what primus_turbo.flydsl.attention.flash_attn_bwd requires
(cannot import name 'buffer_ops' from 'flydsl.expr'). Install the flydsl version
pinned in setup.py, or select a different backend.
```

Confirmed for the attention, sparse-MLA, MXFP8-quant, FP8/MXFP4 GEMM and mega-MoE
FP8 loaders, and through a real call path (`prepare_w2_fp8`). No bare `ImportError`
leaks.

### Honest limits of this verification

**The repo's pytest suite gives this change zero execution coverage on the machine it
was developed on.** `tests/conftest.py:64-68` blanket-skips every test when the device
is gfx1250, so all 223,828 collected tests skip — identically on the base tree and on
this branch. That is a clean "no regression introduced" signal and nothing more; it is
not evidence that the kernels still run.

Nor could it be, on this hardware: `setup.py` itself notes that flydsl 0.2.4 does not
support gfx1250, and the FlyDSL backends gate on `is_gfx950()`. No FlyDSL kernel can
execute here at all.

**The runtime check that matters is upstream CI on gfx950 with flydsl 0.2.4.** The
static evidence above (36/36 identical bindings, 124/124 safe binding order, unchanged
call sites) is why that is expected to be green, but it has not been observed.

## Impact on upstream

**On the pinned flydsl 0.2.4: none.** Every kernel resolves to the same object it did
before; the only difference is *when* the import happens. The cost is one dict lookup
in `sys.modules` per call, against kernels that launch GPU work.

**On flydsl 0.3.x** (not the pin, but now survivable): `import primus_turbo.pytorch`
works, and everything that does not go through FlyDSL — Triton, hipBLASLt, CK, the
C++ ops — is unaffected. Unavailable until the 27 `buffer_ops` users are ported, each
raising a named `RuntimeError` when called:

- FlyDSL flash attention (forward and backward) and sparse MLA
- FlyDSL MXFP8 quantization
- FlyDSL tensorwise-FP8, MXFP8 and MXFP4 GEMM
- FlyDSL fused mega-MoE, bf16 and MXFP8
- The **gfx950** bf16 grouped GEMM

Note the last one: on flydsl 0.3.x the gfx950 grouped-GEMM kernel is unavailable too,
so a gfx950-vs-gfx1250 comparison needs two environments regardless of this PR.

## Relationship to the gfx1250 grouped-GEMM work

This is a **prerequisite** for the gfx1250 bf16 grouped-GEMM PR. That kernel needs
flydsl >= 0.3.0, and without this change installing such a flydsl makes
`primus_turbo.pytorch` unimportable — so the kernel cannot be reached through the
backend registry at all. It is deliberately standalone: it fixes a real fragility on
the current pin and is reviewable on its own terms, independent of whether the gfx1250
kernel lands.

**Base branch.** This branch is based on the local env-compat branch, not `main`, for one
reason: on torch 2.11 `main` cannot be imported at all
(`low_precision.py:274`'s `register_opaque_type` now requires its argument to carry
`OpaqueBaseMeta`), which makes the import behaviour this PR is about impossible to
test. Commit a local commit on that branch fixes it. If that commit lands first, this PR
rebases onto `main` cleanly; if not, it should be reviewed as the two commits together.

# Checklist

- [x] The functionality is complete
- [x] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation — none needed; no public API changes
- [x] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective — see below
- [x] New and existing unit tests pass locally with my changes (identical outcome to the base tree)

**On tests:** the regression this fixes is an *import-time* failure that only
reproduces under a flydsl the project does not pin, so a test for it would have to
install a second flydsl. If reviewers want it covered, the natural form is a CI job
that installs flydsl >= 0.3.0 and asserts only `import primus_turbo.pytorch` — happy
to add that if there is appetite for a second flydsl in CI.
