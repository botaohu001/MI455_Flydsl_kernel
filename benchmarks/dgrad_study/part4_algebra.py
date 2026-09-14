#!/usr/bin/env python3
"""Part 4 -- is there a way out that does not transpose the weight?

dgrad is  da[m,k] = sum_n dout[m,n] * w[g][n,k].  The reduction index is n.
In memory, dout[M,N] has n as its fast axis (contiguous) and w[G,N,K] has n as
its slow axis (strided).  The two pipelines this kernel owns are:

  NT          both operands contiguous along the reduction
  variable-K  both operands strided along the reduction (LDS-transposed), and
              the groups partition the reduction axis

dgrad's pair is mixed, so neither fits as written.  ``(A^T B)^T = B^T A`` does
not help: it renames which operand is which and transposes the *output*, and
neither of those changes the stride of either operand along n.

What is left is a choice of *which* operand to transpose.  Transposing dout
instead of w is expressible: for one group,

    da[rows_g] = dout[rows_g] @ w[g] = (dout[rows_g]^T)^T @ w[g]

which is exactly one variable-K call with G=1, a = dout[rows_g]^T of shape
[N, len_g], b = w[g] of shape [N, K], writing [len_g, K] straight into da
through ``out=``.  dout is smaller than w whenever avg_m < K, and the kernel
has an ``out=`` parameter, so this is worth measuring rather than arguing about.

The catch it trades for: G launches instead of 1, the small 64x64 fallback tile
when avg_m < 256, and a transpose that is per-micro-batch and therefore cannot
be amortised at all.
"""
from __future__ import annotations

import json
import os
import sys

import torch

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common import (  # noqa: E402
    Interleaved,
    fast_nn_weight_nt,
    fp32_ref_dgrad,
    load_flydsl_kernel,
    load_turbo,
    make_case,
    rel_fro,
    sclk_mhz,
)

CASES = [
    ("gpt-oss-20b", "fc1", 4, 512, 5760, 2880),
    ("gpt-oss-20b", "fc1", 4, 2048, 5760, 2880),
    ("qwen3-30b-a3b", "fc1", 16, 512, 4096, 2048),
    ("qwen3-235b-a22b", "fc1", 16, 512, 8192, 4096),
    ("qwen3-235b-a22b", "fc1", 16, 2048, 8192, 4096),
    ("deepseek-v3", "fc1", 32, 128, 4096, 7168),
    ("deepseek-v3", "fc1", 32, 512, 4096, 7168),
    ("deepseek-v3", "fc2", 32, 512, 7168, 2048),
]


def main():
    grouped_gemm_impl, _o, BackendType = load_turbo()
    K = load_flydsl_kernel()
    print(f"sclk at start: {sclk_mhz()}\n")

    rows = []
    for model, layer, G, avg_m, N, Kd in CASES:
        case = make_case(G, avg_m, N, Kd, seed=5)
        w, dout, offs, lens, M = case["w"], case["dout"], case["offs"], case["lens"], case["M"]
        tri_kw = dict(group_lens=lens, group_offs=offs, num_cu=None,
                      default_backend=BackendType.TRITON.value, schedule="static")

        # reduction offsets for the G=1 variable-K calls: the whole n axis
        vk_offs = torch.tensor([0, N], dtype=torch.int64, device="cuda")
        supported = K.grouped_gemm_bf16_variable_k_supported(avg_m, Kd, N)
        tile = K._pick_variable_k_config(avg_m, Kd, N)

        print(f"{model:16s} {layer} G={G:2d} avg_m={avg_m:5d} N={N:5d} K={Kd:5d}  "
              f"dout {M*N*2/2**20:8.1f} MiB vs w {G*N*Kd*2/2**20:8.1f} MiB  "
              f"(avg_m/K = {avg_m/Kd:.3f})")
        print(f"    variable_k supported for OUT_M={avg_m}, OUT_N={Kd}: {supported}  tile={tile}")
        if not supported:
            print("    -> skipped\n")
            rows.append(dict(Model=model, Layer=layer, G=G, avg_m=avg_m, N=N, K=Kd,
                             supported=False))
            continue

        doutT_buf = torch.empty((G, N, avg_m), dtype=torch.bfloat16, device="cuda")
        da_buf = torch.empty((M, Kd), dtype=torch.bfloat16, device="cuda")

        def route_vk():
            # one transpose of the activations, then G single-group wgrad calls
            fast_nn_weight_nt(dout.view(G, avg_m, N), out=doutT_buf)
            for g in range(G):
                K.grouped_gemm_bf16_variable_k_flydsl_kernel(
                    doutT_buf[g], w[g], vk_offs,
                    out=da_buf[g * avg_m:(g + 1) * avg_m].unsqueeze(0))
            return da_buf

        w_nt = fast_nn_weight_nt(w)

        def route_nt_hoisted():
            return K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=w_nt)

        def route_nt_pertcall():
            return K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=fast_nn_weight_nt(w))

        def route_triton():
            return grouped_gemm_impl(dout, w, trans_a=False, trans_b=False, **tri_kw)

        # correctness first
        try:
            got = route_vk()
            torch.cuda.synchronize()
        except Exception as exc:  # noqa: BLE001
            print(f"    variable-K route FAILED: {type(exc).__name__}: {str(exc)[:300]}\n")
            rows.append(dict(Model=model, Layer=layer, G=G, avg_m=avg_m, N=N, K=Kd,
                             supported=True,
                             error=f"{type(exc).__name__}: {str(exc)[:300]}"))
            del case, w, dout, offs, lens, doutT_buf, da_buf
            torch.cuda.empty_cache()
            continue

        ref = fp32_ref_dgrad(case)
        for _ in range(4):
            nt = route_nt_hoisted()
        torch.cuda.synchronize()
        r_vk, r_nt = rel_fro(got, ref), rel_fro(nt, ref)
        print(f"    rel_fro  variable-K route {r_vk:.3e}   NT route {r_nt:.3e}   "
              f"bitwise equal: {torch.equal(got, nt)}")
        del ref
        torch.cuda.empty_cache()

        it = Interleaved(warmup=4, repeats=7)
        it.add("vk_route", route_vk, target_ms=50, max_iters=120)
        it.add("nt_hoisted", route_nt_hoisted, target_ms=50, max_iters=120)
        it.add("nt_per_call", route_nt_pertcall, target_ms=50, max_iters=120)
        it.add("triton", route_triton, target_ms=50, max_iters=120)
        res, clocks = it.run()
        t = {k: v["ms"] for k, v in res.items()}
        print(f"    vk_route {t['vk_route']:8.3f}   nt_hoisted {t['nt_hoisted']:8.3f}   "
              f"nt_per_call {t['nt_per_call']:8.3f}   triton {t['triton']:8.3f} ms")
        print(f"    vk/triton {t['triton']/t['vk_route']:.3f}x   "
              f"vk/nt_hoisted {t['nt_hoisted']/t['vk_route']:.3f}x   "
              f"vk/nt_per_call {t['nt_per_call']/t['vk_route']:.3f}x")
        print(flush=True)

        rows.append(dict(Model=model, Layer=layer, G=G, avg_m=avg_m, N=N, K=Kd, supported=True,
                         tile=str(tile),
                         dout_MiB=round(M * N * 2 / 2**20, 2),
                         w_MiB=round(G * N * Kd * 2 / 2**20, 2),
                         avg_m_over_K=round(avg_m / Kd, 4),
                         rel_vk=r_vk, rel_nt=r_nt,
                         bitwise_equal=bool(torch.equal(got, nt)),
                         **{f"t_{k}_ms": round(v, 5) for k, v in t.items()},
                         **{f"cv_{k}": round(res[k]["cv"], 5) for k in res},
                         sclk_min=min(clocks), sclk_max=max(clocks)))
        del case, w, dout, offs, lens, doutT_buf, da_buf, w_nt, got, nt
        torch.cuda.empty_cache()

    import pandas as pd
    out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "results/part4_algebra")
    pd.DataFrame(rows).to_csv(out + ".csv", index=False)
    with open(out + ".json", "w") as fh:
        json.dump(rows, fh, indent=1)
    print(f"wrote {out}.csv")


if __name__ == "__main__":
    main()
