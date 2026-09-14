#!/usr/bin/env python3
"""Stage B/C smoke: does the native NN pipeline compute the right thing?

Walks up from the smallest well-behaved shape to the awkward ones, and for every
case reports three numbers:

    rel_fro(native, fp32 ref)   -- the thing that has to be small
    floor                       -- rel_fro(bf16(fp32 ref), fp32 ref), i.e. what
                                   storing the answer in bf16 costs by itself
    vs hoist                    -- max |native - hoist| and the bit-equal fraction

The reference is an **fp32** per-group matmul judged on the host in float64: a
device fp64 matmul is recorded in UPSTREAM_NOTES section 6 as having been wrong
11 times in 12 on this part.

Four calls are made per case and calls 1 and 4 are reported separately, because
UPSTREAM_NOTES section 6.5 records gpt-oss fc2 dgrad returning corrupt results on
the first 1-2 calls of a fresh process.

Run:  HIP_VISIBLE_DEVICES=2 python smoke_nn.py
"""
from __future__ import annotations

import importlib.util
import sys

import torch
from pathlib import Path

_REPO = Path(__file__).resolve().parent.parent

KERNEL = str(_REPO / "kernel" / "grouped_gemm_bf16_kernel_mi455.py")


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    sys.modules[name] = mod
    spec.loader.exec_module(mod)
    return mod


K = load(KERNEL, "gg_nn")


def rel_fro(x, ref):
    return (x.double() - ref.double()).norm().item() / ref.double().norm().item()


def case(G, avg_m, Nout, Kred, lens=None, seed=0, tag=""):
    """out[M, Nout] = a[M, Kred] @ b[g][Kred, Nout].

    In autograd terms a=dout, Kred = the forward N, Nout = the forward K, and b is
    the forward weight [G, N_fwd, K_fwd] read with no copy.
    """
    torch.manual_seed(seed)
    dev = "cuda"
    if lens is None:
        lens = torch.full((G,), avg_m, dtype=torch.int64, device=dev)
    else:
        lens = torch.as_tensor(lens, dtype=torch.int64, device=dev)
    M = int(lens.sum())
    offs = torch.cat([torch.zeros(1, dtype=torch.int64, device=dev), lens.cumsum(0)])
    a = torch.randn(M, Kred, dtype=torch.bfloat16, device=dev)
    b = torch.randn(G, Kred, Nout, dtype=torch.bfloat16, device=dev)

    ref = torch.empty(M, Nout, dtype=torch.float32, device=dev)
    o = offs.tolist()
    for g in range(G):
        if o[g + 1] > o[g]:
            ref[o[g] : o[g + 1]] = a[o[g] : o[g + 1]].float() @ b[g].float()
    ref = ref.cpu()
    floor = rel_fro(ref.to(torch.bfloat16).float(), ref)

    cfg = K._pick_config_nn(Nout, Kred, max(1, M // max(G, 1)), G)
    why = K.nn_native_unsupported_reason(Nout, Kred, cfg[1], cfg[2])

    outs = []
    for _ in range(4):
        outs.append(K.grouped_gemm_bf16_nn_flydsl_kernel(a, b, offs).cpu())
    b_nt = K.make_nn_weight_nt(b)
    hoist = K.grouped_gemm_bf16_nn_flydsl_kernel(a, b, offs, b_nt=b_nt).cpu()

    e1, e4 = rel_fro(outs[0].float(), ref), rel_fro(outs[3].float(), ref)
    eh = rel_fro(hoist.float(), ref)
    same = (outs[3].view(torch.int16) == hoist.view(torch.int16)).double().mean().item()
    mx = (outs[3].float() - hoist.float()).abs().max().item()
    nan = int(torch.isnan(outs[3].float()).sum() + torch.isinf(outs[3].float()).sum())
    cfgs = f"BM{cfg[0]}/BN{cfg[1]}/BK{cfg[2]}/mw{cfg[3]}/nw{cfg[4]}/nb{cfg[5]}"
    status = "NATIVE" if why is None else "fallback"
    ok = e4 < 1e-2 and nan == 0
    print(
        f"  {tag:<34s} G={G:<3d} M={M:<6d} N={Nout:<5d} K={Kred:<5d} {cfgs:<34s} {status:<8s}"
        f" call1={e1:.3e} call4={e4:.3e} floor={floor:.3e} hoist={eh:.3e}"
        f" | vs hoist: max|d|={mx:.3e} bitsame={same * 100:.2f}% nan={nan}  {'OK' if ok else 'FAIL'}"
    )
    if why is not None:
        print(f"      (native declined: {why})")
    return ok


def main():
    p = torch.cuda.get_device_properties(0)
    print(f"device: {p.gcnArchName}  kernel: {KERNEL}\n")
    ok = True
    print("-- stage B: single expert, everything divides --")
    ok &= case(1, 256, 256, 256, tag="G1 tiny")
    ok &= case(1, 512, 1024, 1024, tag="G1 square")
    ok &= case(1, 256, 2048, 4096, tag="G1 wide-K")

    print("\n-- stage C: grouped, ragged N, short experts --")
    ok &= case(4, 512, 2880, 5760, tag="gpt-oss fc1 dgrad")
    ok &= case(4, 512, 2880, 2880, tag="gpt-oss fc2 dgrad (N==K)")
    ok &= case(8, 128, 2048, 7168, tag="deepseek fc2 dgrad small-m")
    ok &= case(4, 256, 7168, 4096, tag="deepseek fc1 dgrad")
    ok &= case(4, 512, 2048, 4096, tag="qwen30b fc1 dgrad")

    print("\n-- stage C: imbalanced experts (incl. empty and tiny) --")
    ok &= case(4, 0, 2880, 2880, lens=[0, 7, 1200, 913], tag="imbalanced +empty")
    ok &= case(6, 0, 2048, 2048, lens=[1, 2047, 0, 33, 4096, 129], tag="imbalanced wide spread")

    print("\nRESULT:", "ALL OK" if ok else "FAILURES PRESENT")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
