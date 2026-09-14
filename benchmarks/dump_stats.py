#!/usr/bin/env python3
"""Compile one dgrad shape both ways and diff the generated code.

Answers, from the assembly rather than from a timer, where the native NN
pipeline's steady state differs from the NT pipeline it forks: register
allocation, scratch/spill, LDS, and the instruction mix in the inner loop.

Run:  HIP_VISIBLE_DEVICES=2 FLYDSL_DEBUG_DUMP_ASM=1 FLYDSL_DUMP_DIR=... python dump_stats.py
"""
from __future__ import annotations

import collections
import glob
import importlib.util
import os
import re
import shutil
import sys

import torch
from pathlib import Path

_REPO = Path(__file__).resolve().parent.parent

KERNEL = str(_REPO / "kernel" / "grouped_gemm_bf16_kernel_mi455.py")
DUMP = str(_REPO / "asm")


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    sys.modules[name] = mod
    spec.loader.exec_module(mod)
    return mod


def stats(asm_text: str) -> dict:
    out = {}
    for k in (
        "vgpr_count", "sgpr_count", "vgpr_spill_count", "sgpr_spill_count",
        "occupancy", "lds_size", "private_seg_size", "agpr_count",
    ):
        m = re.search(rf"{k}:\s*(\d+)", asm_text)
        if m:
            out[k] = int(m.group(1))
    for pat, key in (
        (r"\.vgpr_count:\s*(\d+)", "vgpr_count"),
        (r"\.sgpr_count:\s*(\d+)", "sgpr_count"),
        (r"\.vgpr_spill_count:\s*(\d+)", "vgpr_spill"),
        (r"\.sgpr_spill_count:\s*(\d+)", "sgpr_spill"),
        (r"\.group_segment_fixed_size:\s*(\d+)", "lds_bytes"),
        (r"\.private_segment_fixed_size:\s*(\d+)", "scratch"),
    ):
        m = re.search(pat, asm_text)
        if m:
            out[key] = int(m.group(1))
    mnem = collections.Counter()
    for line in asm_text.splitlines():
        s = line.strip()
        if not s or s.startswith((".", ";", "//", "/*")) or s.endswith(":"):
            continue
        mnem[s.split()[0]] += 1
    groups = collections.Counter()
    for m, c in mnem.items():
        if m.startswith("v_wmma"):
            groups["wmma"] += c
        elif m.startswith("ds_load_tr") or m.startswith("ds_read_tr"):
            groups["ds_transpose_read"] += c
        elif m.startswith(("ds_read", "ds_load")):
            groups["ds_plain_read"] += c
        elif m.startswith("ds_write") or m.startswith("ds_store"):
            groups["ds_write"] += c
        elif m.startswith("v_"):
            groups["valu"] += c
        elif m.startswith("s_"):
            groups["salu_or_wait"] += c
        elif m.startswith(("global_", "buffer_", "flat_", "scratch_")):
            groups["vmem"] += c
        elif m.startswith("tensor_"):
            groups["tdm"] += c
    out["_groups"] = dict(groups)
    out["_total_instr"] = sum(mnem.values())
    return out


def compile_one(K, native, N_fwd, K_fwd, G, avg_m, tag):
    for d in glob.glob(f"{DUMP}/*"):
        shutil.rmtree(d, ignore_errors=True) if os.path.isdir(d) else os.remove(d)
    M = G * avg_m
    dev = "cuda"
    lens = torch.full((G,), avg_m, dtype=torch.int64, device=dev)
    offs = torch.cat([torch.zeros(1, dtype=torch.int64, device=dev), lens.cumsum(0)])
    dout = torch.randn(M, N_fwd, dtype=torch.bfloat16, device=dev)
    w = torch.randn(G, N_fwd, K_fwd, dtype=torch.bfloat16, device=dev)
    if native:
        K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs)
    else:
        K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=K.make_nn_weight_nt(w))
    torch.cuda.synchronize()
    files = sorted(glob.glob(f"{DUMP}/**/*.s", recursive=True), key=os.path.getmtime)
    if not files:
        files = sorted(glob.glob(f"{DUMP}/**/*", recursive=True), key=os.path.getmtime)
        files = [f for f in files if os.path.isfile(f) and open(f, "rb").read(4)[:1] in (b"\t", b".", b"/", b"v", b"s")]
    if not files:
        return None, None
    txt = open(files[-1]).read()
    shutil.copy(files[-1], f"{DUMP}/{tag}.s")
    return stats(txt), files[-1]


def main():
    os.makedirs(DUMP, exist_ok=True)
    os.environ.setdefault("FLYDSL_DEBUG_DUMP_ASM", "1")
    os.environ.setdefault("FLYDSL_DUMP_DIR", DUMP)
    K = load(KERNEL, "gg_nn")
    cases = [
        ("gpt-oss fc1 m1024", 5760, 2880, 4, 1024),
        ("gpt-oss fc2 m2048", 2880, 2880, 4, 2048),
        ("qwen235b fc1 m2048", 8192, 4096, 16, 2048),
    ]
    for name, N_fwd, K_fwd, G, avg_m in cases:
        print(f"===== {name}  (fwd N={N_fwd} K={K_fwd} G={G} avg_m={avg_m}) =====")
        for native, tag in ((0, "nt_hoist"), (1, "nn_native")):
            try:
                st, path = compile_one(K, native, N_fwd, K_fwd, G, avg_m, f"{name.replace(' ', '_')}_{tag}")
            except Exception as e:  # noqa: BLE001
                print(f"  {tag}: FAILED {type(e).__name__}: {str(e)[:300]}")
                continue
            if st is None:
                print(f"  {tag}: no asm dumped (looked in {DUMP})")
                continue
            g = st.pop("_groups")
            tot = st.pop("_total_instr")
            print(f"  {tag:<10s} {st}")
            print(f"             instr={tot}  {g}")
        print()


if __name__ == "__main__":
    main()
