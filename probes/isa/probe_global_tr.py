#!/usr/bin/env python3
"""Measure the lane semantics of ``global_load_tr16_b128`` on gfx1250.

The CDNA5 ISA calls this the global-memory twin of ``ds_load_tr16_b128``:
"Load a 16x16 matrix of 16-bit data into VGPRs and transpose between row-major
and column-major order", wave32 only. Nothing in this project has ever issued it,
so this reduces it from "the doc says so" to "measured on the part".

Method is the one that pinned down ``ds_load_tr16_b128``: fill memory with
``f16[i] = i`` (exact for i < 2048), give lane ``l`` the address ``l * STEP``
elements in, and print which source index each lane ends up holding.

If it matches the LDS instruction, lanes act in groups of 8 and lane ``l`` of a
group receives ``{a_j + (l % 8) : j = 0..7}``.

Run:  HIP_VISIBLE_DEVICES=2 python probe_global_tr.py
"""
from __future__ import annotations

import sys

import torch

import flydsl.compiler as flyc
import flydsl.expr as fx
from flydsl._mlir import ir
from flydsl._mlir.dialects import llvm as _llvm
from flydsl._mlir.dialects import rocdl as _rocdl
from flydsl.expr import rocdl  # noqa: F401  (registers the dialect)
from flydsl.expr.arith import _to_raw as _raw
from flydsl.expr.typing import Vector as Vec

N_LANES = 32
ELEMS = 8  # b128 at 16-bit granularity
_PTR1 = "!llvm.ptr<1>"


def _as_ptr(t: torch.Tensor):
    return flyc.from_c_void_p(fx.Int8, t.data_ptr(), assumed_align=16)


def build(step_elems: int):
    """One wave32 workgroup; lane l transpose-loads at element offset l*step_elems."""

    @flyc.jit
    def launch(arg_out: fx.Pointer, arg_in: fx.Pointer, stream: fx.Stream):
        @flyc.kernel(known_block_size=[N_LANES, 1, 1])
        def kern(arg_out: fx.Pointer, arg_in: fx.Pointer):
            lane = fx.Int32(fx.thread_idx.x)
            gin = fx.recast_iter(fx.Int8, arg_in)
            gout = fx.recast_iter(fx.Int8, arg_out)
            vec8 = ir.VectorType.get([ELEMS], fx.Float16.ir_type)

            addr = fx.Int64(fx.ptrtoint(gin)) + fx.Int64(lane) * fx.Int64(step_elems * 2)
            ptr = _llvm.inttoptr(ir.Type.parse(_PTR1), _raw(addr))
            res = Vec(_rocdl.global_load_tr_b128(vec8, ptr))

            fx.ptr_store(res.bitcast(fx.Int8), fx.add_offset(gout, fx.Int64(lane) * fx.Int64(ELEMS * 2)))

        kern(arg_out, arg_in).launch(grid=(1, 1, 1), block=(N_LANES, 1, 1), stream=stream)

    return launch


def run(step_elems: int):
    dev = "cuda"
    n_in = N_LANES * max(step_elems, ELEMS) + ELEMS
    src = torch.arange(n_in, dtype=torch.float16, device=dev)
    out = torch.full((N_LANES * ELEMS,), -1.0, dtype=torch.float16, device=dev)
    args = (_as_ptr(out), _as_ptr(src), torch.cuda.current_stream())
    flyc.compile(build(step_elems), *args)(*args)
    torch.cuda.synchronize()
    return out.view(N_LANES, ELEMS).to(torch.int32).cpu()


def classify(mat: torch.Tensor, step: int) -> str:
    """Group-of-8 transpose? plain b128 load? or something else?"""
    grp, plain = True, True
    for l in range(N_LANES):
        g, c = l // 8, l % 8
        if mat[l].tolist() != [(g * 8 + j) * step + c for j in range(ELEMS)]:
            grp = False
        if mat[l].tolist() != [l * step + j for j in range(ELEMS)]:
            plain = False
    if grp:
        return "8-lane-group 8x8 TRANSPOSE (same shape as ds_load_tr16_b128)"
    if plain:
        return "NO transpose -- degraded to a plain 128-bit per-lane load"
    return "neither: see the table above"


def main():
    p = torch.cuda.get_device_properties(0)
    import flydsl

    print(f"device : {p.gcnArchName}\nflydsl : {flydsl.__version__}\n")
    # 8/16/32/64 are 16-byte-aligned per-lane steps; 9 and 12 are not, and the
    # LDS twin is documented to silently degrade to a plain load when misaligned.
    for step in (8, 16, 32, 64, 9, 12):
        print(f"===== global_load_tr16_b128, per-lane step = {step} elements ({step*2} B) =====")
        try:
            mat = run(step)
        except Exception as e:  # noqa: BLE001
            print(f"  FAILED: {type(e).__name__}: {str(e)[:600]}\n")
            sys.stdout.flush()
            continue
        for k in range(N_LANES):
            sep = "  --- group boundary ---\n" if k and k % 8 == 0 else ""
            print(f"{sep}  lane {k:2d}: {mat[k].tolist()}")
        print(f"  -> {classify(mat, step)}\n")
        sys.stdout.flush()


if __name__ == "__main__":
    main()
