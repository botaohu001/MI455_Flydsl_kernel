#!/usr/bin/env python3
"""Symbol probe for the gfx1250 grouped-GEMM kernel's flydsl surface.

KERNEL_REVIEW.md section B.3 lists 14 flydsl symbols the new kernel uses that have
no precedent anywhere in Primus-Turbo, and section B.2 shows the same flydsl
version already dropped a public submodule (`flydsl.expr.buffer_ops`). So "import
works" cannot be inferred from the version number; this checks it directly.

Run inside a ROCm container with flydsl importable. Both 0.2.4 and 0.3.2 work;
0.2.4 is the measured floor despite the module header once claiming 0.3.0.
"""

from __future__ import annotations

import sys
import traceback

print("=" * 78)
print("STAGE 1 -- module-level imports the kernel performs")
print("=" * 78)

stage1 = [
    ("import flydsl", "import flydsl"),
    ("flydsl.compiler as flyc", "import flydsl.compiler as flyc"),
    ("flydsl.expr as fx", "import flydsl.expr as fx"),
    ("flydsl._mlir.ir", "from flydsl._mlir import ir"),
    ("flydsl._mlir.dialects.llvm", "from flydsl._mlir.dialects import llvm as _llvm"),
    ("flydsl._mlir.dialects.rocdl", "from flydsl._mlir.dialects import rocdl as _rocdl"),
    (
        "flydsl.expr {const_expr,gpu,range_constexpr,rocdl}",
        "from flydsl.expr import const_expr, gpu, range_constexpr, rocdl",
    ),
    ("flydsl.expr.arith._to_raw", "from flydsl.expr.arith import _to_raw as _raw"),
    ("flydsl.expr.rocdl.tdm_ops", "from flydsl.expr.rocdl import tdm_ops"),
    ("flydsl.expr.typing {Constexpr,T,Vector}", "from flydsl.expr.typing import Constexpr, T, Vector"),
    ("flydsl.runtime.device.get_rocm_arch", "from flydsl.runtime.device import get_rocm_arch"),
    (
        "flydsl.utils.smem_allocator.check_smem_capacity",
        "from flydsl.utils.smem_allocator import check_smem_capacity",
    ),
]

ns: dict = {}
fails = 0
for label, stmt in stage1:
    try:
        exec(stmt, ns)
        print(f"  OK    {label}")
    except Exception as exc:  # noqa: BLE001
        fails += 1
        print(f"  FAIL  {label}: {type(exc).__name__}: {exc}")

import flydsl  # noqa: E402

print(f"\nflydsl version: {flydsl.__version__}   ({flydsl.__file__})")

print()
print("=" * 78)
print("STAGE 2 -- attribute existence for the 14 no-precedent symbols")
print("=" * 78)

import flydsl.compiler as flyc  # noqa: E402
import flydsl.expr as fx  # noqa: E402
from flydsl.expr import rocdl  # noqa: E402

checks = [
    ("flyc.from_c_void_p", flyc, "from_c_void_p"),
    ("fx.copy_atom_call", fx, "copy_atom_call"),
    ("fx.UniversalCopy", fx, "UniversalCopy"),
    ("fx.ptr_store", fx, "ptr_store"),
    ("fx.Pointer", fx, "Pointer"),
    ("fx.AddressSpace", fx, "AddressSpace"),
    ("fx.SharedAllocator", fx, "SharedAllocator"),
    ("rocdl.WMMA", rocdl, "WMMA"),
    ("rocdl.make_tdm_atom", rocdl, "make_tdm_atom"),
    ("rocdl.ds_load_tr16_b128", rocdl, "ds_load_tr16_b128"),
    ("rocdl.s_wait_dscnt", rocdl, "s_wait_dscnt"),
    ("rocdl.disable_xdl_arb_stall", rocdl, "disable_xdl_arb_stall"),
    ("rocdl.readfirstlane", rocdl, "readfirstlane"),
    ("rocdl.sched_barrier", rocdl, "sched_barrier"),
]
for label, obj, attr in checks:
    ok = hasattr(obj, attr)
    fails += 0 if ok else 1
    print(f"  {'OK   ' if ok else 'FAIL '} {label}")

try:
    from flydsl.expr.rocdl import tdm_ops

    ok = hasattr(tdm_ops, "tensor_wait")
    fails += 0 if ok else 1
    print(f"  {'OK   ' if ok else 'FAIL '} tdm_ops.tensor_wait")
except Exception as exc:  # noqa: BLE001
    fails += 1
    print(f"  FAIL  tdm_ops.tensor_wait: {exc}")

# SharedAllocator(static=False) is the usage that has no precedent, not the class.
try:
    _sa = fx.SharedAllocator(static=False)
    print(f"  OK    fx.SharedAllocator(static=False)  has base_ptr={hasattr(_sa, 'base_ptr')}")
except Exception as exc:  # noqa: BLE001
    print(f"  WARN  fx.SharedAllocator(static=False): {type(exc).__name__}: {exc}")

print()
print("=" * 78)
print("STAGE 3 -- import the kernel module itself")
print("=" * 78)
try:
    from primus_turbo.flydsl.grouped_gemm import (
        grouped_gemm_bf16_kernel_gfx1250 as mod,
    )

    print(f"  OK    module imported from {mod.__file__}")
    entries = [
        "grouped_gemm_bf16_nt_flydsl_kernel",
        "grouped_gemm_bf16_nn_flydsl_kernel",
        "grouped_gemm_bf16_variable_k_flydsl_kernel",
        "grouped_gemm_bf16_variable_k_supported",
        "make_nn_weight_nt",
        "_pick_config",
        "_pick_variable_k_config",
    ]
    for name in entries:
        ok = hasattr(mod, name)
        fails += 0 if ok else 1
        print(f"  {'OK   ' if ok else 'FAIL '} {name}")
    print("  sys.modules has primus_turbo.pytorch?", "primus_turbo.pytorch" in sys.modules)
except Exception:  # noqa: BLE001
    fails += 1
    print("  FAIL  kernel module import")
    traceback.print_exc()

print()
print("=" * 78)
print("STAGE 4 -- dispatch module")
print("=" * 78)
try:
    from primus_turbo.flydsl.grouped_gemm import grouped_gemm_bf16_dispatch as disp

    print("  OK    dispatch imported;", disp.__all__)
    print("  arch ->", disp.grouped_gemm_bf16_arch.__name__ if hasattr(disp, "grouped_gemm_bf16_arch") else "n/a")
except Exception:  # noqa: BLE001
    fails += 1
    print("  FAIL  dispatch import")
    traceback.print_exc()

print()
print(f"RESULT: {'ALL CHECKS PASSED' if fails == 0 else f'{fails} FAILURE(S)'}")
sys.exit(1 if fails else 0)
