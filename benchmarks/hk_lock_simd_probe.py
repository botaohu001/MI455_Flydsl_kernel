#!/usr/bin/env python3
# ===========================================================================
# THIS SCRIPT LAUNCHES REAL GPU WORK.  RUN IT ONLY ON AN IDLE GPU.
# ===========================================================================
"""Forensics for the one knob that failed the correctness gate: `lock_simd`.

`benchmarks/hk_ab.py` phase 1 rejected `lock_simd=1` on qwen3-30b-a3b fc1 with
rel_err 1.183e-02 against the control's 1.656e-03 -- seven times the bf16 storage
floor, no NaN, no fault, no hang.  It never reached the timing phase, so there is
no A/B number for it and there should not be one: docs/09 section 9.10, a variant
that computes the wrong answer is not a data point.

This script answers the three questions that decide how it gets written up, and
it is a separate file from `hk_ab.py` because it deliberately runs a candidate
that is already known to be wrong.

  Q1 IS IT DETERMINISTIC?  Re-run the same arm on the same input N times and
     compare the outputs bit-for-bit against each other.
       - identical every time  => a systematic miscompute (wrong maths, or a
         hazard the scheduler resolves the same way on every wave).
       - varies                => a genuine race: the write lands or does not
         depending on timing, which is what a lost register interlock looks
         like.  A race is the more serious verdict and the one that cannot be
         fixed by "insert one more wait here".
  Q2 IS IT SHAPE-DEPENDENT?  Every shape, so the writeup can say whether this is
     one tile geometry or the knob as such.
  Q3 WHERE IS THE ERROR?  Fraction of output elements that differ from the
     control, and the worst single element.  A few scattered elements point at a
     boundary; a whole K-tile's worth points at the accumulator path.

Why this is expected to be a hazard rather than an illegal instruction: the
kernel compiles with `amdgpu-expert-scheduling-mode` (see the `compile_hints` on
`_launch_grouped_gemm_bf16_nt`), and the emitted ISA opens **every** wave with

    s_setreg_imm32_b32 hwreg(HW_REG_WAVE_SCHED_MODE, 0, 2), 2

i.e. the compiler is already writing bits [1:0] of that register itself.  In that
mode the compiler, not the hardware, owns the inter-instruction dependency waits,
and it emits them against an assumed issue behaviour.  `lock_simd=1` adds

    s_setreg_imm32_b32 hwreg(HW_REG_WAVE_SCHED_MODE, 2, 1), 1

which changes that behaviour at run time, after the schedule was already fixed at
compile time.  The compiler's `s_delay_alu` / `s_wait_alu depctr_*` then no longer
cover the real hazards.  That predicts wrong values with no fault -- which is what
the gate saw.

Run (only on an idle GPU):

    python benchmarks/hk_lock_simd_probe.py --json-out results/hk/lock_simd_probe.json
"""
from __future__ import annotations

import argparse
import json
import statistics
import sys
from pathlib import Path

_REPO = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(_REPO / "benchmarks"))

import hk_ab  # noqa: E402
from hk_ab import CONTROL, SHAPES, VARIANTS, shape_tag  # noqa: E402


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--kernel", default=hk_ab.KERNEL)
    ap.add_argument("--variant", default="lock_simd", choices=list(VARIANTS))
    ap.add_argument("--repeats", type=int, default=5,
                    help="independent re-runs of the same arm on the same input (Q1)")
    ap.add_argument("--shapes", nargs="*", default=None, metavar="SUBSTR")
    ap.add_argument("--smi-gpu", type=int, default=0)
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--json-out", default=None)
    ap.add_argument("--force", action="store_true")
    args = ap.parse_args()

    hk_ab.guard_gpu_idle(args.force)
    hk_ab._import_runtime(args.smi_gpu)
    torch = hk_ab.torch
    K = hk_ab.load(args.kernel, "gg_probe")

    shapes = SHAPES
    if args.shapes:
        shapes = [s for s in SHAPES if any(f in shape_tag(s) for f in args.shapes)]

    print(f"kernel : {args.kernel}")
    print(f"device : {torch.cuda.get_device_properties(0).gcnArchName}")
    print(f"variant: {args.variant} = {VARIANTS[args.variant]}   vs control {CONTROL}")
    print(f"repeats: {args.repeats} independent re-runs per shape, same input\n")

    hdr = (f"{'shape':<42s} {'ctl rel_err':>11s} {'exp rel_err':>11s} {'bf16 floor':>10s} "
           f"{'det?':>6s} {'distinct':>8s} {'bad elem %':>10s} {'worst abs':>10s} {'nan':>4s}")
    print(hdr)
    print("-" * len(hdr))

    rows = []
    for sh in shapes:
        _model, _proj, G, n, k, avg_m = sh
        case = hk_ab.make_case("nt", G, n, k, avg_m, seed=args.seed)
        ref = hk_ab.fp32_reference(case)
        floor = hk_ab.rel_fro(ref.to(torch.bfloat16).float(), ref)

        ctl, ctl_err, _ = hk_ab.gate_measure(K, case, ref, dict(CONTROL))
        ctl = ctl.clone()

        # Q1: the same arm, re-run from scratch, compared bit-for-bit to itself.
        outs, errs = [], []
        for _ in range(args.repeats):
            got, err, _nan = hk_ab.gate_measure(K, case, ref, dict(VARIANTS[args.variant]))
            outs.append(got.clone())
            errs.append(err)
        distinct = len({o.view(torch.int16).cpu().numpy().tobytes() for o in outs})
        deterministic = distinct == 1

        exp = outs[0]
        host_e, host_c = exp.cpu().float(), ctl.cpu().float()
        diff = (host_e - host_c).abs()
        bad = int((exp.view(torch.int16) != ctl.view(torch.int16)).sum())
        bad_pct = 100.0 * bad / exp.numel()
        nan = int(torch.isnan(host_e).sum() + torch.isinf(host_e).sum())

        print(f"{shape_tag(sh):<42s} {ctl_err:>11.3e} {statistics.median(errs):>11.3e} "
              f"{floor:>10.3e} {str(deterministic):>6s} {distinct:>8d} {bad_pct:>10.4f} "
              f"{diff.max().item():>10.4e} {nan:>4d}", flush=True)

        rows.append(dict(shape=shape_tag(sh), variant=args.variant,
                         ctl_rel_err=ctl_err, exp_rel_err=errs, bf16_floor=floor,
                         deterministic=deterministic, distinct_outputs=distinct,
                         repeats=args.repeats, bad_elements=bad, bad_pct=bad_pct,
                         worst_abs_diff=diff.max().item(), nan=nan,
                         wrong=bool(statistics.median(errs) > floor * 1.5)))
        del case, ref, ctl, outs, exp
        torch.cuda.empty_cache()

    print()
    wrong = [r for r in rows if r["wrong"]]
    nondet = [r for r in rows if not r["deterministic"]]
    print(f"{len(wrong)}/{len(rows)} shape(s) compute a wrong answer with {args.variant}=1.")
    print(f"{len(nondet)}/{len(rows)} shape(s) are NON-DETERMINISTIC across {args.repeats} "
          f"identical re-runs.")
    if nondet:
        print("  => a race, not a systematic miscompute: the same code on the same input")
        print("     returns different bits run to run. That is a lost register interlock,")
        print("     and it cannot be patched by moving the setreg.")
    elif wrong:
        print("  => deterministic but wrong: every wave resolves the hazard the same way.")
    if wrong and not nondet:
        print("  NB deterministic here means 'over these repeats on an idle card'. It is not")
        print("  a promise the schedule is stable under a co-resident job.")

    if args.json_out:
        out = Path(args.json_out)
        out.parent.mkdir(parents=True, exist_ok=True)
        json.dump(dict(kernel=args.kernel, variant=args.variant,
                       kwargs=VARIANTS[args.variant], control=CONTROL,
                       repeats=args.repeats, rows=rows), open(out, "w"), indent=1, default=str)
        print(f"\nwrote {out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
