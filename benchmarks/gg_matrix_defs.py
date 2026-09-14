#!/usr/bin/env python3
###############################################################################
# Shared case table for the gfx1250 FlyDSL bf16 grouped-GEMM target matrix.
#
# Split out of bench_flydsl_gg_matrix.py so the correctness harness can reuse it
# without paying that module's import side effects (it decides whether to import
# primus_turbo.pytorch at module scope, which cannot be done under flydsl 0.3.x).
###############################################################################

from __future__ import annotations

# G is the per-rank local expert count (n_routed_experts / EP), i.e. what turbo's
# grouped-GEMM benchmark calls "B". fc1 is the gate+up projection (N = 2 *
# moe_intermediate_size), fc2 the down projection. Shapes verified against turbo's
# own MoEModelConfigs at EP=8 (PREP_NOTES.md section 4.1).
#
# num_topk / n_routed are carried so avg_m can be derived from the routing rather
# than hardcoded; see avg_m_list.
TARGET_MATRIX = {
    "gpt-oss-20b": dict(
        G=4, EP=8, seq=4096, n_routed=32, topk=4,
        fc1=(5760, 2880), fc2=(2880, 2880),
    ),
    "qwen3-30b-a3b": dict(
        G=16, EP=8, seq=8192, n_routed=128, topk=8,
        fc1=(4096, 2048), fc2=(2048, 2048),
    ),
    "qwen3-235b-a22b": dict(
        G=16, EP=8, seq=8192, n_routed=128, topk=8,
        fc1=(8192, 4096), fc2=(4096, 4096),
    ),
    "deepseek-v3": dict(
        G=32, EP=8, seq=4096, n_routed=256, topk=8,
        fc1=(4096, 7168), fc2=(7168, 2048),
    ),
}

LAYERS = ("fc1", "fc2")

# MI455X (gfx1250) peak dense BF16 matrix throughput, from AMD's MI455X spec sheet
# (5.03 PFLOP/s). Only used as the MFU denominator; override for a different part.
DEFAULT_PEAK_TFLOPS = 5033.2


def avg_m_list(cfg: dict, batches: list[int], mode: str = "topk") -> list[tuple[int, int]]:
    """Return [(batch, avg_m)] for one model.

    ``topk``       avg_m = seq * batch * topk / n_routed -- tokens actually routed to
                   one expert. Reproduces the worked example in the target matrix
                   (gpt-oss-20b, batch=1 -> avg_m=512, total M=2048).
    ``seq-over-g`` avg_m = seq * batch / G. Matches the matrix's prose formula, but
                   disagrees with its own gpt-oss-20b example by 2x.
    """
    out = []
    for b in batches:
        if mode == "topk":
            avg_m = cfg["seq"] * b * cfg["topk"] // cfg["n_routed"]
        elif mode == "seq-over-g":
            avg_m = cfg["seq"] * b // cfg["G"]
        else:
            raise ValueError(f"unknown avg-m mode {mode!r}")
        out.append((b, avg_m))
    return out
