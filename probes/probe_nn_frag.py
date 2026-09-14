#!/usr/bin/env python3
"""Stage A: measure the ``ds_load_tr16_b128`` lane mapping in the **dgrad NN** geometry.

The wgrad kernel transposes the *token* axis of an activation; dgrad has to
transpose the *reduction* axis of a weight.  ISA-wise those are the same
instruction on the same LDS geometry (rows = reduction, columns = output), but
that is a derivation, and the author of the kernel warned in UPSTREAM_NOTES 4.0
that "guessing at them would have produced a plausible wrong answer".  So this
measures it.

Two independent checks, both bit-exact, on real LDS filled by a real TDM copy:

  1. ANALYTIC -- each lane's 16 fragment elements are compared against the
     closed-form prediction

         frag[j] = b[ks*32 + kgrp*8 + (j % 8) + (16 if j >= 8 else 0)][wnb + wn*16 + lane16]

  2. EQUIVALENCE -- the same fragment is loaded the NT way (plain ``ds_read_b128``
     out of an ``[n, k]``-major stage holding the host-transposed tile) and the
     two must agree bit for bit.  This one does not depend on the derivation
     being right: it says "the transposed read hands WMMA exactly the bits the
     already-validated NT path hands it", which is the property the NN pipeline
     actually needs.

Data is carried as **bf16 bit patterns** (0x2000 + flat_index), not as numbers:
every pattern in that range is a normal finite bf16, so nothing can be flushed
or canonicalised, and all 16 bits of every element are checked.

Run:  HIP_VISIBLE_DEVICES=2 python probe_nn_frag.py
"""
from __future__ import annotations

import sys

import torch

import flydsl.compiler as flyc
import flydsl.expr as fx
from flydsl._mlir import ir
from flydsl._mlir.dialects import llvm as _llvm
from flydsl._mlir.dialects import rocdl as _rocdl
from flydsl.expr import gpu, range_constexpr, rocdl
from flydsl.expr.arith import _to_raw as _raw
from flydsl.expr.rocdl import tdm_ops
from flydsl.expr.typing import Vector as Vec

WAVE = 32
WMMA_N = 16
WMMA_K = 32
EB = 2
LDS_PAD = 16
BIAS = 0x2000  # keeps every bit pattern a normal finite bf16


def _as_ptr(t: torch.Tensor):
    return flyc.from_c_void_p(fx.Int8, t.data_ptr(), assumed_align=16)


def _make_lds_copy_ops(bits: int):
    """Verbatim from the kernel under study."""
    elem_count = bits // fx.Int32.width
    layout = fx.make_layout(elem_count, 1)
    atom = fx.make_copy_atom(fx.UniversalCopy(bits), fx.Int32)
    ptr_ty = fx.PointerType.get(
        elem_ty=fx.Int32.ir_type, address_space=fx.AddressSpace.Shared, alignment=bits // 8
    )

    def _view(lds_base_idx, byte_offset):
        addr_i32 = fx.Int32(lds_base_idx) + fx.Int32(byte_offset)
        return fx.Tensor(fx.make_view(fx.inttoptr(ptr_ty, addr_i32), layout))

    def load(lds_base_idx, byte_offset):
        rmem = fx.make_rmem_tensor(layout, fx.Int32)
        fx.copy_atom_call(atom, _view(lds_base_idx, byte_offset), rmem)
        return rmem.load()

    return load


def build(tile_k: int, tile_n: int):
    """One wave32 workgroup: TDM both layouts into LDS, read both ways, dump both."""
    K_WS = tile_k // WMMA_K
    n_rep = tile_n // WMMA_N
    N_FRAG = K_WS * n_rep

    LDS_B_ROW = tile_n * EB + LDS_PAD  # NN stage: rows = reduction k, cols = output n
    LDS_ROW = tile_k * EB + LDS_PAD  # NT stage: rows = output n, cols = reduction k
    STAGE_TR = ((tile_k * LDS_B_ROW + 15) // 16) * 16
    STAGE_NT = ((tile_n * LDS_ROW + 15) // 16) * 16
    ARENA_B = STAGE_TR + STAGE_NT

    @flyc.jit
    def launch(arg_tr: fx.Pointer, arg_nt: fx.Pointer, arg_b: fx.Pointer, arg_bt: fx.Pointer, stream: fx.Stream):
        @flyc.kernel(known_block_size=[WAVE, 1, 1])
        def kern(arg_tr: fx.Pointer, arg_nt: fx.Pointer, arg_b: fx.Pointer, arg_bt: fx.Pointer):
            lane = fx.Int32(fx.thread_idx.x) % WAVE
            lane16 = lane % 16
            kgrp = lane // 16
            l8 = lane % 8
            hi8 = lane16 // 8

            arena = fx.SharedAllocator(static=False)
            arena.allocate(ARENA_B)
            base_ptr = arena.base_ptr

            def _gv(base, off, shape, stride):
                return fx.Tensor(fx.make_view(fx.add_offset(base, off), fx.make_layout(shape, stride)))

            def _lv(ptr, shape, stride):
                return fx.Tensor(fx.make_view(ptr, fx.make_layout(shape, stride)))

            gB = fx.recast_iter(fx.Int8, arg_b)  # b  [tile_k, tile_n]  (k-major == dgrad's b[g])
            gBt = fx.recast_iter(fx.Int8, arg_bt)  # bt [tile_n, tile_k]  (n-major == NT's b_nt[g])

            # ---- NN stage: plain contiguous TDM of the k-major tile -------------
            gt_tr = _gv(gB, 0, (tile_k, tile_n * EB), (tile_n * EB, 1))
            atom_tr = fx.rocdl.make_tdm_atom(
                gt_tr,
                [tile_k, fx.Int32(tile_n * EB)],
                strides=[tile_n * EB, None],
                num_warps=1,
                pad_interval=tile_n * EB,
                pad_amount=LDS_PAD,
                early_timeout=True,
            )
            fx.copy(atom_tr, gt_tr, _lv(base_ptr, (tile_k, tile_n * EB), (LDS_B_ROW, 1)))

            # ---- NT stage: the same data, host-transposed, laid out NT-style ----
            gt_nt = _gv(gBt, 0, (tile_n, tile_k * EB), (tile_k * EB, 1))
            atom_nt = fx.rocdl.make_tdm_atom(
                gt_nt,
                [tile_n, fx.Int32(tile_k * EB)],
                strides=[tile_k * EB, None],
                num_warps=1,
                pad_interval=tile_k * EB,
                pad_amount=LDS_PAD,
                early_timeout=True,
            )
            fx.copy(atom_nt, gt_nt, _lv(fx.add_offset(base_ptr, STAGE_TR), (tile_n, tile_k * EB), (LDS_ROW, 1)))

            tdm_ops.tensor_wait(0)
            gpu.barrier()

            buf = fx.Int32(fx.Int64(fx.ptrtoint(base_ptr)))

            # ---- transposed read (the thing under test), verbatim from wgrad ----
            vec8 = ir.VectorType.get([8], fx.BFloat16.ir_type)
            _PTR3 = ir.Type.parse("!llvm.ptr<3>")

            def _tr(addr, const_off):
                ptr_val = _llvm.inttoptr(_PTR3, _raw(addr + fx.Int32(const_off)))
                return Vec(_rocdl.ds_load_tr16_b128(vec8, ptr_val))

            def _frag_tr(addr, k_row_off, col_off):
                base = k_row_off * LDS_B_ROW + col_off
                v0 = _tr(addr, base)
                v1 = _tr(addr, base + 16 * LDS_B_ROW)
                return v0.shuffle(v1, list(range(16)))

            b_lane = (l8 + kgrp * fx.Int32(8)) * fx.Int32(LDS_B_ROW) + (hi8 * fx.Int32(8)) * fx.Int32(EB)
            addr_tr = buf + b_lane

            # ---- plain NT read for comparison, verbatim from the NT kernel ------
            lds_load_b128 = _make_lds_copy_ops(128)

            def _frag_nt(b0):
                v0 = Vec(lds_load_b128(buf, b0))
                v1 = Vec(lds_load_b128(buf, b0 + 32))
                return v0.shuffle(v1, list(range(8)))

            gout_tr = fx.recast_iter(fx.Int8, arg_tr)
            gout_nt = fx.recast_iter(fx.Int8, arg_nt)

            for ks in range_constexpr(K_WS):
                for wn in range_constexpr(n_rep):
                    fi = ks * n_rep + wn
                    ftr = _frag_tr(addr_tr, ks * WMMA_K, wn * WMMA_N * EB)
                    col = wn * WMMA_N + lane16
                    fnt = _frag_nt(fx.Int64(STAGE_TR + col * LDS_ROW + ks * WMMA_K * EB + kgrp * 16))
                    off = fx.Int64(fi * WAVE * 16 * EB) + fx.Int64(lane) * fx.Int64(16 * EB)
                    fx.ptr_store(ftr.bitcast(fx.Int8), fx.add_offset(gout_tr, off))
                    fx.ptr_store(fnt.bitcast(fx.Int8), fx.add_offset(gout_nt, off))

        kern(arg_tr, arg_nt, arg_b, arg_bt).launch(grid=(1, 1, 1), block=(WAVE, 1, 1), stream=stream)

    return launch, N_FRAG, K_WS, n_rep


def run(tile_k: int, tile_n: int):
    dev = "cuda"
    assert tile_k * tile_n <= 8192, "bit-pattern encoding needs flat index < 8192"
    launch, N_FRAG, K_WS, n_rep = build(tile_k, tile_n)

    idx = torch.arange(tile_k * tile_n, dtype=torch.int32, device=dev).reshape(tile_k, tile_n)
    b = (idx + BIAS).to(torch.int16).view(torch.bfloat16).contiguous()
    bt = b.t().contiguous()  # [tile_n, tile_k], what make_nn_weight_nt would produce

    out_tr = torch.zeros(N_FRAG * WAVE * 16, dtype=torch.int16, device=dev).view(torch.bfloat16)
    out_nt = torch.zeros_like(out_tr)

    args = (_as_ptr(out_tr), _as_ptr(out_nt), _as_ptr(b), _as_ptr(bt), torch.cuda.current_stream())
    flyc.compile(launch, *args)(*args)
    torch.cuda.synchronize()

    got_tr = (out_tr.view(torch.int16).to(torch.int32) - BIAS).reshape(N_FRAG, WAVE, 16).cpu()
    got_nt = (out_nt.view(torch.int16).to(torch.int32) - BIAS).reshape(N_FRAG, WAVE, 16).cpu()
    return got_tr, got_nt, K_WS, n_rep


def expected(tile_n: int, K_WS: int, n_rep: int):
    """frag[j] = b[ks*32 + kgrp*8 + (j%8) + 16*(j>=8)][wn*16 + lane16], flattened."""
    exp = torch.empty(K_WS * n_rep, WAVE, 16, dtype=torch.int32)
    for ks in range(K_WS):
        for wn in range(n_rep):
            for lane in range(WAVE):
                lane16, kgrp = lane % 16, lane // 16
                col = wn * WMMA_N + lane16
                for j in range(16):
                    k = ks * WMMA_K + kgrp * 8 + (j % 8) + (16 if j >= 8 else 0)
                    exp[ks * n_rep + wn, lane, j] = k * tile_n + col
    return exp


def main():
    p = torch.cuda.get_device_properties(0)
    import flydsl

    print(f"device : {p.gcnArchName}\nflydsl : {flydsl.__version__}\n")
    rc = 0
    for tile_k, tile_n in ((32, 64), (64, 128), (128, 64), (64, 64)):
        print(f"===== NN B-fragment, tile_k(reduction)={tile_k}  tile_n(output)={tile_n} =====")
        try:
            got_tr, got_nt, K_WS, n_rep = run(tile_k, tile_n)
        except Exception as e:  # noqa: BLE001
            print(f"  FAILED to run: {type(e).__name__}: {str(e)[:900]}\n")
            rc = 1
            continue
        exp = expected(tile_n, K_WS, n_rep)

        ok_an = bool((got_tr == exp).all())
        ok_eq = bool((got_tr == got_nt).all())
        ok_nt = bool((got_nt == exp).all())
        print(f"  fragments checked      : {got_tr.shape[0]} x {WAVE} lanes x 16 elems")
        print(f"  [1] analytic match     : {'PASS' if ok_an else 'FAIL'}")
        print(f"  [2] tr == NT bitwise   : {'PASS' if ok_eq else 'FAIL'}")
        print(f"  [-] NT vs analytic     : {'PASS' if ok_nt else 'FAIL'}  (control: the known-good path)")
        if not (ok_an and ok_eq and ok_nt):
            rc = 1
            bad = (got_tr != exp).nonzero()
            print(f"      mismatches (tr vs analytic): {bad.shape[0]} of {exp.numel()}")
            for row in bad[:8].tolist():
                f, l, j = row
                gk, gn = divmod(int(got_tr[f, l, j]), tile_n)
                ek, en = divmod(int(exp[f, l, j]), tile_n)
                print(f"        frag {f} lane {l:2d} elem {j:2d}: got b[{gk},{gn}]  want b[{ek},{en}]")
        # lane->(k,n) map for the first fragment, so the mapping is on the record
        if tile_k == 64 and tile_n == 128:
            print("  measured lane -> (k, n) for fragment ks=0, wn=0 (first 4 and last lane):")
            for l in list(range(4)) + [31]:
                cells = [divmod(int(got_tr[0, l, j]), tile_n) for j in range(16)]
                ks_ = [c[0] for c in cells]
                ns_ = sorted({c[1] for c in cells})
                print(f"        lane {l:2d}: n={ns_}  k={ks_}")
        print()
    print("RESULT:", "ALL PASS" if rc == 0 else "FAILURES PRESENT")
    return rc


if __name__ == "__main__":
    sys.exit(main())
