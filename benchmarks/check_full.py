#!/usr/bin/env python3
"""Full-matrix correctness for the native NN pipeline, plus a fwd/wgrad no-regression proof.

Loads **two** kernel modules in one process -- the pristine upstream file and the
modified one -- so "nothing else broke" is a bit-for-bit comparison of the two
implementations on identical inputs, not a re-derivation against a reference.

Per row:
  dgrad_native   rel_fro against an fp32 per-group reference judged host-side in
                 float64 (a device fp64 matmul is recorded as wrong 11 times in 12
                 on this part, so fp32 it is)
  floor          rel_fro(bf16(ref), ref) -- what storing the answer in bf16 costs
                 by itself, so the margin is visible rather than asserted
  vs hoist       bit-equal fraction against the same kernel fed a materialised
                 transpose
  fwd / wgrad    bit-equal against the pristine upstream kernel

Acceptance is the notes' own gate: rel_fro < 1e-2 and no NaN/Inf. Calls 1 and 4
are reported separately because UPSTREAM_NOTES section 6.5 records gpt-oss fc2
dgrad returning corrupt results on the first 1-2 calls of a fresh process.

Run:  HIP_VISIBLE_DEVICES=2 python check_full.py
"""
from __future__ import annotations

import argparse
import importlib.util
import json
import os
import sys

import torch
from pathlib import Path

_REPO = Path(__file__).resolve().parent.parent

UPSTREAM = str(_REPO / "kernel" / "reference" / "grouped_gemm_bf16_kernel_gfx1250.py")
MODIFIED = str(_REPO / "kernel" / "grouped_gemm_bf16_kernel_mi455.py")
ACCEPT = 1e-2

MATRIX = {
    "gpt-oss-20b": dict(G=4, fc1=(5760, 2880), fc2=(2880, 2880), avg_m=(512, 1024, 2048)),
    "qwen3-30b-a3b": dict(G=16, fc1=(4096, 2048), fc2=(2048, 2048), avg_m=(512, 1024, 2048)),
    "qwen3-235b-a22b": dict(G=16, fc1=(8192, 4096), fc2=(4096, 4096), avg_m=(512, 1024, 2048)),
    "deepseek-v3": dict(G=32, fc1=(4096, 7168), fc2=(7168, 2048), avg_m=(128, 256, 512)),
}


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    sys.modules[name] = mod
    spec.loader.exec_module(mod)
    return mod


def rel_fro(x, ref):
    return (x.double() - ref.double()).norm().item() / ref.double().norm().item()


def biteq(a, b):
    return (a.view(torch.int16) == b.view(torch.int16)).double().mean().item()


def make_lens(G, avg_m, mode, dev):
    if mode == "balanced":
        return torch.full((G,), avg_m, dtype=torch.int64, device=dev)
    # deterministic, unequal, includes an empty expert and a very short one
    g = torch.Generator(device="cpu").manual_seed(1234 + G * 31 + avg_m)
    r = torch.rand(G, generator=g).double() + 0.15
    lens = (r / r.sum() * (G * avg_m)).floor().to(torch.int64)
    lens[0] = 0
    lens[min(1, G - 1)] = 3
    lens[-1] += G * avg_m - int(lens.sum())
    return lens.clamp_(min=0).to(dev)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--modes", nargs="*", default=["balanced", "imbalanced"])
    ap.add_argument("-o", default=str(_REPO / "results" / "nn_pipeline" / "correctness.json"))
    args = ap.parse_args()
    U = load(UPSTREAM, "gg_up")
    K = load(MODIFIED, "gg_nn")
    dev = "cuda"
    print(f"device: {torch.cuda.get_device_properties(0).gcnArchName}")
    print(f"upstream: {UPSTREAM}\nmodified: {MODIFIED}\n")
    rows, fails = [], []

    for mode in args.modes:
        print(f"===== {mode} groups =====")
        hdr = (f"{'model':<16s} {'proj':<4s} {'avg_m':>5s} {'M':>6s} {'N':>5s} {'K':>5s} {'path':<8s} "
               f"{'dg.call1':>9s} {'dg.call4':>9s} {'floor':>9s} {'dg~hoist':>9s} "
               f"{'fwd~up':>7s} {'wg~up':>7s} {'nan':>4s} {'ok':>4s}")
        print(hdr)
        print("-" * len(hdr))
        for model, cfg in MATRIX.items():
            G = cfg["G"]
            for proj in ("fc1", "fc2"):
                N_fwd, K_fwd = cfg[proj]
                for avg_m in cfg["avg_m"]:
                    torch.manual_seed(7)
                    lens = make_lens(G, avg_m, mode, dev)
                    M = int(lens.sum())
                    offs = torch.cat([torch.zeros(1, dtype=torch.int64, device=dev), lens.cumsum(0)])
                    x = torch.randn(M, K_fwd, dtype=torch.bfloat16, device=dev)
                    w = torch.randn(G, N_fwd, K_fwd, dtype=torch.bfloat16, device=dev)
                    dout = torch.randn(M, N_fwd, dtype=torch.bfloat16, device=dev)
                    o = offs.tolist()

                    ref = torch.empty(M, K_fwd, dtype=torch.float32, device=dev)
                    for g in range(G):
                        if o[g + 1] > o[g]:
                            ref[o[g]:o[g + 1]] = dout[o[g]:o[g + 1]].float() @ w[g].float()
                    ref = ref.cpu()
                    floor = rel_fro(ref.to(torch.bfloat16).float(), ref)

                    cn = K._pick_config_nn(K_fwd, N_fwd, max(1, M // G), G)
                    why = K.nn_native_unsupported_reason(K_fwd, N_fwd, cn[1], cn[2])
                    outs = [K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs).cpu() for _ in range(4)]
                    b_nt = K.make_nn_weight_nt(w)
                    hoist = K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=b_nt).cpu()
                    del b_nt

                    e1, e4 = rel_fro(outs[0].float(), ref), rel_fro(outs[3].float(), ref)
                    eq_h = biteq(outs[3], hoist)
                    nan = int(torch.isnan(outs[3].float()).sum() + torch.isinf(outs[3].float()).sum())
                    del ref, hoist, outs

                    # fwd + wgrad: bit-compare the two kernel modules directly
                    f_new = K.grouped_gemm_bf16_nt_flydsl_kernel(x, w, offs)
                    f_up = U.grouped_gemm_bf16_nt_flydsl_kernel(x, w, offs)
                    eq_f = biteq(f_new, f_up)
                    del f_new, f_up
                    w_new = K.grouped_gemm_bf16_variable_k_flydsl_kernel(dout, x, offs)
                    w_up = U.grouped_gemm_bf16_variable_k_flydsl_kernel(dout, x, offs)
                    eq_w = biteq(w_new, w_up)
                    del w_new, w_up

                    ok = e4 < ACCEPT and nan == 0 and eq_h == 1.0 and eq_f == 1.0 and eq_w == 1.0
                    path = "NATIVE" if why is None else "fallback"
                    print(f"{model:<16s} {proj:<4s} {avg_m:>5d} {M:>6d} {K_fwd:>5d} {N_fwd:>5d} {path:<8s} "
                          f"{e1:>9.3e} {e4:>9.3e} {floor:>9.3e} {eq_h * 100:>8.2f}% "
                          f"{eq_f * 100:>6.2f}% {eq_w * 100:>6.2f}% {nan:>4d} {'OK' if ok else 'FAIL':>4s}",
                          flush=True)
                    if not ok:
                        fails.append(f"{mode}/{model}/{proj}/m{avg_m}: e4={e4:.3e} nan={nan} "
                                     f"dg~hoist={eq_h:.6f} fwd~up={eq_f:.6f} wg~up={eq_w:.6f}")
                    if why is not None:
                        print(f"      (native declined: {why})")
                    rows.append(dict(mode=mode, model=model, proj=proj, avg_m=avg_m, M=M,
                                     N_out=K_fwd, K_red=N_fwd, path=path, call1=e1, call4=e4,
                                     floor=floor, dgrad_vs_hoist_biteq=eq_h, fwd_vs_upstream_biteq=eq_f,
                                     wgrad_vs_upstream_biteq=eq_w, nan=nan, ok=ok))
                    del x, w, dout, offs, lens
                    torch.cuda.empty_cache()
        print()

    n = len(rows)
    print(f"rows: {n}   passed: {sum(1 for r in rows if r['ok'])}   failed: {len(fails)}")
    print(f"dgrad max rel_fro (call 4): {max(r['call4'] for r in rows):.4e}   "
          f"max bf16 floor: {max(r['floor'] for r in rows):.4e}   acceptance gate: {ACCEPT}")
    print(f"dgrad native == hoist bitwise on {sum(1 for r in rows if r['dgrad_vs_hoist_biteq'] == 1.0)}/{n} rows")
    print(f"fwd  == upstream bitwise on {sum(1 for r in rows if r['fwd_vs_upstream_biteq'] == 1.0)}/{n} rows")
    print(f"wgrad== upstream bitwise on {sum(1 for r in rows if r['wgrad_vs_upstream_biteq'] == 1.0)}/{n} rows")
    print(f"native path taken on {sum(1 for r in rows if r['path'] == 'NATIVE')}/{n} rows")
    worst1 = max(rows, key=lambda r: r["call1"])
    print(f"worst first-call rel_fro: {worst1['call1']:.4e} "
          f"({worst1['model']}/{worst1['proj']}/m{worst1['avg_m']}) -- no first-call corruption seen"
          if worst1["call1"] < ACCEPT else f"FIRST-CALL CORRUPTION: {worst1}")
    if fails:
        print("\nFAILURES:")
        for f in fails:
            print("  ", f)
    os.makedirs(os.path.dirname(args.o), exist_ok=True)
    json.dump(rows, open(args.o, "w"), indent=1)
    print(f"\nwrote {args.o}")
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
