###############################################################################
# SPDX-License-Identifier: Apache-2.0
#
# Copyright (c) 2026, Advanced Micro Devices, Inc. All rights reserved.
# Copyright (c) 2026 FlyDSL Project Contributors
#
# This file is distributed under the Apache License 2.0 (see LICENSE-APACHE),
# not the MIT license that covers the rest of Primus-Turbo (see LICENSE).
###############################################################################

"""Architecture dispatch for the FlyDSL bf16 grouped GEMM.

Two implementations of the same three operators exist and they share nothing
below the public signature:

  ``grouped_gemm_bf16_kernel.py``           gfx950 / MI355X -- MFMA, wave64, SRD
  ``grouped_gemm_bf16_kernel_gfx1250.py``   gfx1250 / MI455X -- WMMA, wave32, TDM

Why two files rather than ``if arch ==`` inside one
----------------------------------------------------
The split is not stylistic. Three things force it:

1. **Import cost and import safety.** The gfx1250 module builds WMMA/TDM atoms;
   the gfx950 module imports ``primus_turbo.flydsl.utils.gemm_helper``, 2200
   lines of gfx9 MFMA/DPP/SRD primitives resting on ``flydsl.expr.buffer_ops``,
   which flydsl 0.3.x deleted. Neither has any business being in the other's
   import graph, and a flydsl that cannot carry one of them must not break the
   other. Here that is a caught ``ImportError``, not a crash.

2. **Almost nothing is shared.** Wave size, matrix engine, accumulator storage,
   global->LDS path, OOB mechanism and barrier primitive all differ, so an
   in-file branch would be two disjoint bodies under one ``def`` -- strictly
   harder to read and to review than two files, with no shared code recovered.

3. **The tuning tables are per-arch.** ``_pick_config`` on gfx1250 encodes
   thresholds fitted to MI455X measurements. Sharing a function between arches
   would invite exactly the cross-arch extrapolation those thresholds cannot
   support.

What this module is *not*
-------------------------
It is not the production dispatch path. Inside Primus-Turbo, grouped GEMM is
selected through the backend registry in
``primus_turbo/pytorch/kernels/grouped_gemm/grouped_gemm_impl.py``
(``BackendType.FLYDSL``), which additionally checks dtype, layout, ``trans_*``,
``schedule``, ``num_cu`` and the ``K % tile_k`` divisibility rule, and falls back
to Triton when any of them fails. Use that from the torch layer.

This module exists for the cases the registry does not cover: bring-up scripts,
micro-benchmarks and tests that want the flydsl kernel directly but should still
get the right one for the device they happen to be on.
"""

from __future__ import annotations

import functools

import torch

__all__ = [
    "grouped_gemm_bf16_arch",
    "grouped_gemm_bf16_nt",
    "grouped_gemm_bf16_nn",
    "grouped_gemm_bf16_variable_k",
]


@functools.lru_cache(maxsize=16)
def _gcn_arch(device_index: int) -> str:
    props = torch.cuda.get_device_properties(device_index)
    # gcnArchName carries target features too, e.g. "gfx1250:xnack-".
    return str(getattr(props, "gcnArchName", "") or "")


def grouped_gemm_bf16_arch(device: torch.device | int | None = None) -> str:
    """``"gfx1250"`` or ``"gfx950"`` for ``device``, else raise.

    Deliberately an allow-list. A new CDNA/RDNA part would otherwise silently pick
    whichever branch came first and produce wrong results or a fault rather than a
    message naming the arch nobody has ported to yet.
    """
    if isinstance(device, torch.device):
        if device.type != "cuda":
            raise RuntimeError(f"the FlyDSL grouped GEMM needs a ROCm device, got '{device}'")
        index = device.index if device.index is not None else torch.cuda.current_device()
    elif isinstance(device, int):
        index = device
    else:
        index = torch.cuda.current_device()

    arch = _gcn_arch(index)
    for known in ("gfx1250", "gfx950"):
        if known in arch:
            return known
    raise RuntimeError(
        f"no FlyDSL bf16 grouped-GEMM implementation for device {index} (gcnArchName={arch!r}). "
        f"Ported arches: gfx950 (MI355X, MFMA/wave64/SRD) and gfx1250 (MI455X, WMMA/wave32/TDM). "
        f"Use the Triton or CK backend on this part."
    )


@functools.lru_cache(maxsize=4)
def _impl(arch: str):
    """Import the module for ``arch`` -- lazily, so only one ever enters the graph."""
    if arch == "gfx1250":
        from primus_turbo.flydsl.grouped_gemm import grouped_gemm_bf16_kernel_gfx1250 as mod
    else:
        from primus_turbo.flydsl.grouped_gemm import grouped_gemm_bf16_kernel as mod
    return mod


def _pick(a: torch.Tensor):
    return _impl(grouped_gemm_bf16_arch(a.device))


def grouped_gemm_bf16_nt(a: torch.Tensor, b: torch.Tensor, group_offs: torch.Tensor, **kw):
    """``out[rows] = a[rows] @ b[g].T``  --  ``a[M,K]``, ``b[G,N,K]``.

    Identical contract on both arches. Keyword arguments are **not** identical:
    each implementation has its own tuning knobs (``BLOCK_K`` / ``m_warp`` /
    ``epi_fence`` on gfx1250, ``nt_vmcnt`` / ``waves_per_eu`` / ``cap_cu`` on
    gfx950) and are passed straight through, so a script that hardcodes them is
    arch-specific by construction. Pass none of them for portable code.
    """
    return _pick(a).grouped_gemm_bf16_nt_flydsl_kernel(a, b, group_offs, **kw)


def grouped_gemm_bf16_nn(a: torch.Tensor, b: torch.Tensor, group_offs: torch.Tensor, **kw):
    """``out[rows] = a[rows] @ b[g]``  --  ``a[M,K]``, ``b[G,K,N]``.

    Both arches now read ``b`` in place through a hardware LDS transpose read --
    ``ds_read_b64_tr_b16`` on gfx950, ``ds_load_tr16_b128`` on gfx1250 -- so
    neither materialises a transposed weight copy and the two are directly
    comparable. On gfx1250 a shape outside ``nn_native_unsupported_reason``
    (``K % tile_k``, ``N % 8``, ``N >= tile_n``, ``tile_n`` a power of two) still
    falls back to materialising one, with a one-shot warning naming the reason.

    The reference revision in ``kernel/reference/`` predates the native gfx1250 NN
    pipeline and always materialised the copy; see ``docs/02-dgrad-problem.md``.
    """
    return _pick(a).grouped_gemm_bf16_nn_flydsl_kernel(a, b, group_offs, **kw)


def grouped_gemm_bf16_variable_k(
    a: torch.Tensor,
    b: torch.Tensor,
    group_k_offsets: torch.Tensor,
    masked_k: torch.Tensor | None = None,
    **kw,
):
    """``out[g] = a[rows_g].T @ b[rows_g]``  --  ``a[M,OUT_M]``, ``b[M,OUT_N]``.

    The wgrad operator. Both arches read the activations **un-transposed** and do
    the transpose in LDS (``ds_read_b64_tr_b16`` on gfx950,
    ``ds_load_tr16_b128`` on gfx1250), so both are end-to-end and directly
    comparable. gfx1250 additionally requires ``OUT_M >= tile_m`` and
    ``OUT_N >= tile_n``; see ``grouped_gemm_bf16_variable_k_supported``.
    """
    return _pick(a).grouped_gemm_bf16_variable_k_flydsl_kernel(
        a, b, group_k_offsets, masked_k=masked_k, **kw
    )
