#!/usr/bin/env python3
"""Part 2 -- what a resident transposed weight costs in HBM.

The per-layer numbers are arithmetic, but they are checked against a real
allocation on the device so the arithmetic cannot quietly be wrong.  The
whole-model numbers are estimates: they assume every decoder layer is an MoE
layer with the fc1/fc2 shapes in the study matrix, at EP=8 (G = local experts).
"""
from __future__ import annotations

import json
import os
import sys

import torch

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common import MATRIX  # noqa: E402

# num_hidden_layers, and how many of them are MoE.  Checked against the
# published configs; see the report.  deepseek-v3 has first_k_dense_replace=3,
# so 3 of its 61 decoder layers are dense and carry no grouped GEMM.
LAYERS = {
    "gpt-oss-20b":     dict(total=24, moe=24, src="model card: 24 layers, every layer MoE"),
    "qwen3-30b-a3b":   dict(total=48, moe=48, src="config.json num_hidden_layers=48, decoder_sparse_step=1"),
    "qwen3-235b-a22b": dict(total=94, moe=94, src="config.json num_hidden_layers=94, decoder_sparse_step=1"),
    "deepseek-v3":     dict(total=61, moe=58, src="config num_hidden_layers=61, first_k_dense_replace=3"),
}


def main():
    props = torch.cuda.get_device_properties(0)
    hbm = props.total_memory
    print(f"device      : {props.gcnArchName}")
    print(f"HBM (torch) : {hbm} B = {hbm/2**30:.1f} GiB = {hbm/1e9:.1f} GB")
    free, total = torch.cuda.mem_get_info()
    print(f"mem_get_info: free {free/2**30:.1f} GiB of total {total/2**30:.1f} GiB")
    print(f"NOTE        : the study brief says 442 GB; this box reports {hbm/1e9:.1f} GB "
          f"({hbm/2**30:.1f} GiB).  Percentages below use the measured value.")
    print()

    rows = []
    for model, cfg in MATRIX.items():
        G = cfg["G"]
        lay = LAYERS[model]
        per_layer = 0
        detail = []
        for layer in ("fc1", "fc2"):
            N, K = cfg[layer]
            b = G * N * K * 2  # bf16
            per_layer += b
            detail.append((layer, N, K, b))

        # verify the arithmetic against a real allocation of one layer's pair
        before = torch.cuda.mem_get_info()[0]
        held = [torch.empty(G, N_, K_, dtype=torch.bfloat16, device="cuda")
                for _l, N_, K_, _b in detail]
        torch.cuda.synchronize()
        after = torch.cuda.mem_get_info()[0]
        measured = before - after
        del held
        torch.cuda.empty_cache()

        extra_total = per_layer * lay["moe"]
        for layer, N, K, b in detail:
            rows.append(dict(Model=model, Layer=layer, G=G, N=N, K=K,
                             weight_bytes=b, weight_MiB=round(b / 2**20, 2)))
        rows.append(dict(Model=model, Layer="BOTH", G=G, N=0, K=0,
                         weight_bytes=per_layer, weight_MiB=round(per_layer / 2**20, 2),
                         moe_layers=lay["moe"], total_layers=lay["total"],
                         model_weight_GiB=round(per_layer * lay["moe"] / 2**30, 2),
                         transposed_copy_GiB=round(extra_total / 2**30, 2),
                         pct_of_HBM=round(100.0 * extra_total / hbm, 2),
                         alloc_check_MiB=round(measured / 2**20, 2)))

        print(f"{model}  (G={G} local experts at EP=8, {lay['moe']}/{lay['total']} MoE layers)")
        print(f"    source for layer count: {lay['src']}")
        for layer, N, K, b in detail:
            print(f"    {layer}  [G={G}, N={N}, K={K}] bf16 = {b/2**20:8.1f} MiB")
        print(f"    per MoE layer, both projections          {per_layer/2**20:8.1f} MiB"
              f"   (device alloc check: {measured/2**20:.1f} MiB)")
        print(f"    all {lay['moe']:2d} MoE layers, expert weights    {per_layer*lay['moe']/2**30:8.2f} GiB"
              f"   ({100.0*per_layer*lay['moe']/hbm:5.2f}% of HBM)")
        print(f"    transposed copies (same size again)      {extra_total/2**30:8.2f} GiB"
              f"   ({100.0*extra_total/hbm:5.2f}% of HBM)  <-- the cost of the cache")
        print()

    import pandas as pd
    out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "results/part2_memory")
    pd.DataFrame(rows).to_csv(out + ".csv", index=False)
    with open(out + ".json", "w") as fh:
        json.dump(dict(hbm_bytes=hbm, layers=LAYERS, rows=rows), fh, indent=1)
    print(f"wrote {out}.csv")


if __name__ == "__main__":
    main()
