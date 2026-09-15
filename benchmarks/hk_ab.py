#!/usr/bin/env python3
# ===========================================================================
# THIS SCRIPT LAUNCHES REAL GPU WORK.  RUN IT ONLY ON AN IDLE GPU.
#
# Before running it, `sudo fuser /dev/kfd` must be clean and `docker ps` must
# show no foreign container.  A co-resident job does not merely add noise: it
# moves the DPM state, and this box has already produced a whole batch depressed
# by 17% from a clock excursion (docs/09-measurement-methodology.md section 9.9).
# A ratio measured next to somebody else's kernel is not a measurement.
#
# `main()` enforces this at startup -- it reads /sys/class/kfd/kfd/proc and
# `fuser /dev/kfd` and refuses to run if any process other than this one holds
# the device, and warns on foreign containers.  `--force` overrides, and is
# there only so the check cannot become the reason a measurement does not happen
# on a box where the probes themselves are broken.
# ===========================================================================
"""A/B campaign for the four opt-in scheduling knobs on the NT/NN kernel.

Knobs under test, all defaulting to the value that reproduces today's code
bit-for-bit, so the control arm is exact:

    frag_ring    2 -> 3   operand register ring depth (K sub-steps of A/B
                          fragments live at once); 3 primes two sub-steps ahead
    sched_style  0 -> 1   one burst per sub-step separated by `sched_barrier(0)`
                          fences, instead of the fine-grained sched_dsrd /
                          sched_mfma group-barrier interleave
    lock_simd    0 -> 1   `s_setreg` on SCHED_MODE **bit 2** -- removes the
                          post-matrix-op SIMD arbitration pause for this wave.
                          NOT the same bit as the existing `wmma_b2b` knob,
                          which writes bit 4
    split_bar    0 -> 1   split the per-K-tile workgroup barrier into
                          `s_barrier_signal` / `s_barrier_wait` and run the
                          K-tile's last WMMA sub-step inside that window.
                          NB the barriers are **already split** today: the kernel
                          calls `gpu.barrier()` and gfx1250 lowers each one to a
                          signal/wait pair (asm/nn_native/21_final_isa.s reads
                          4 signals, 4 waits, zero bare `s_barrier`).  So what
                          this knob adds is the work moved *into* the window, not
                          the split, and `hk_isa_gate.py` cannot see it in the
                          barrier counts -- only in the assembly hash.

Measurement discipline, all of it taken from
`docs/09-measurement-methodology.md` rather than invented here:

  * section 9.1  a control arm of **byte-identical code** measured in the same run
                 on the same data.  Its true ratio is 1.0000x, so whatever it
                 reads is this session's noise floor, and nothing below that
                 floor is called a win.
  * section 9.2  **sandwich**: every pair is measured in both orders
                 (ctl -> exp -> exp -> ctl, four arms in one round-robin) and the
                 two ratios are combined with a geometric mean.  A single
                 direction absorbs 0.1-0.3% of thermal drift, always in favour of
                 whichever arm ran first.
  * section 8.0  one sample = `_time(iters=30, reps=5)`, **10 independent
                 repeats per point, median reported**.
  * section 9.7  points whose repeat-to-repeat range exceeds 5% are reported but
                 kept out of the aggregate.
  * section 9.9  `sclk` recorded next to every point; a DPM regression to the
                 1400 MHz level has previously depressed a whole batch by 17%.
                 Same-session interleaved ratios are the only claim made.
  * section 9.10 correctness gate before any timing: fp32 reference (device fp64
                 matmul is wrong 11 times in 12 on this part), judged host-side
                 in float64, 3 calls burned and the 4th checked.  Each candidate
                 must also match the control's own rel_err to <= 1e-6, which is a
                 statement about the geometry rather than about the shape.

Run (only on an idle GPU):

    HIP_VISIBLE_DEVICES=2 python benchmarks/hk_ab.py --dry-run
    HIP_VISIBLE_DEVICES=2 python benchmarks/hk_ab.py --json-out results/hk/ab.json
"""
from __future__ import annotations

import argparse
import importlib.util
import inspect
import json
import math
import os
import statistics
import subprocess
import sys
from pathlib import Path

_REPO = Path(__file__).resolve().parent.parent
KERNEL = str(_REPO / "kernel" / "grouped_gemm_bf16_kernel_mi455.py")

# Filled in by `_import_runtime()`.  Nothing that touches the GPU is imported at
# module scope, so `--dry-run` (and `hk_isa_gate.py`, which imports the tables
# below) never pulls in torch.
torch = None  # type: ignore[assignment]
_c = None  # type: ignore[assignment]
Interleaved = None  # type: ignore[assignment]
Sandwich = None  # type: ignore[assignment]


# ---------------------------------------------------------------------------
# The variant and shape tables.
#
# THIS IS THE SINGLE SOURCE OF TRUTH.  `hk_isa_gate.py` imports `VARIANTS`,
# `SHAPES`, `CONTROL` and `KNOBS` from here so the compile gate and the timing
# campaign cannot drift apart -- a gate that passed a different candidate from
# the one that got benched is the classic way to ship a wrong conclusion.
# ---------------------------------------------------------------------------
CONTROL: dict[str, int] = dict(frag_ring=2, sched_style=0, lock_simd=0, split_bar=0)
KNOBS: tuple[str, ...] = tuple(CONTROL)

# `control` is the noise-floor arm: its "experimental" kwargs are the control
# kwargs, so all four of its arms are byte-identical code and their ratio must
# read 1.0000x.  Keep it first so it is the first thing measured on every shape.
VARIANTS: dict[str, dict[str, int]] = {
    "control": dict(CONTROL),
    "frag_ring": dict(CONTROL, frag_ring=3),
    "sched_style": dict(CONTROL, sched_style=1),
    "lock_simd": dict(CONTROL, lock_simd=1),
    "split_bar": dict(CONTROL, split_bar=1),
    "all": dict(frag_ring=3, sched_style=1, lock_simd=1, split_bar=1),
}
NOISE_VARIANT = "control"
DEFAULT_VARIANTS = ["control", "frag_ring", "sched_style", "lock_simd", "split_bar"]

# (model, proj, G, N_fwd, K_fwd, avg_m).  N/K are the **forward** weight dims:
# w is [G, N, K] and the forward is a[M,K] @ w[g].T.  These are exactly the six
# cases `benchmarks/ab_variants.py` uses, which are a subset of the 24-row
# delivery matrix in `benchmarks/bench_matrix.py` / `bench_quick.py`, so every
# number here is comparable with the history in docs/07-performance.md.
#
# `M` in the shape tables is avg_m, NOT the total row count (section 9.11): the
# total is G * avg_m and FLOPs are 2 * G * avg_m * N * K.
SHAPES: list[tuple[str, str, int, int, int, int]] = [
    ("gpt-oss-20b", "fc1", 4, 5760, 2880, 1024),  # K=2880 -> tile_k=64 path
    ("gpt-oss-20b", "fc2", 4, 2880, 2880, 2048),  # K=2880, N == K
    ("qwen3-30b-a3b", "fc1", 16, 4096, 2048, 2048),  # K % 128 == 0
    ("qwen3-235b-a22b", "fc1", 16, 8192, 4096, 2048),  # K % 128 == 0
    ("deepseek-v3", "fc1", 32, 4096, 7168, 512),  # K % 128 == 0, long reduction
    ("deepseek-v3", "fc2", 32, 7168, 2048, 128),  # K % 128 == 0, small avg_m
]

# docs/06-pitfalls.md section 6.3: every passing point lands at rel_fro
# 1.655e-3 - 1.663e-3, which is the cost of storing the answer in bf16, not
# kernel error.  `check_full.py` gates at 1e-2, six times above that floor.
ACCEPT_REL = 1e-2
# docs/09 section 9.10: judge the *geometry*, not the shape -- a candidate must
# reproduce the control's own rel_err on the same input to within this.
ACCEPT_DELTA_VS_CONTROL = 1e-6
PEAK_TFLOPS = 5033.2  # section 9.11: this repo divides by 5040-class peak, never 3470
RANGE_GATE = 0.05  # section 9.7: points with repeat range above this do not enter the aggregate
DPM_DEGRADED_MHZ = 1450.0  # section 9.9: the stuck level-1 state reads ~1400 MHz


def shape_tag(sh: tuple[str, str, int, int, int, int]) -> str:
    model, proj, G, n, k, avg_m = sh
    return f"{model}.{proj}.G{G}.N{n}.K{k}.m{avg_m}"


# ---------------------------------------------------------------------------
# GPU occupancy guard
# ---------------------------------------------------------------------------
def kfd_holders() -> tuple[list[int], list[str]]:
    """PIDs holding /dev/kfd, plus a note per probe about what it could see.

    /sys/class/kfd/kfd/proc lists one directory per process with the device open
    and is readable without root, so it sees other users' jobs where a plain
    (non-sudo) `fuser` does not.  Both are tried; the union is returned.
    """
    pids: set[int] = set()
    notes: list[str] = []

    proc_dir = Path("/sys/class/kfd/kfd/proc")
    try:
        entries = [p.name for p in proc_dir.iterdir()]
        found = sorted(int(e) for e in entries if e.isdigit())
        pids.update(found)
        notes.append(f"/sys/class/kfd/kfd/proc: {found if found else 'empty'}")
    except OSError as e:
        notes.append(f"/sys/class/kfd/kfd/proc: unreadable ({e.__class__.__name__}) -- probe blind")

    for cmd in (["sudo", "-n", "fuser", "/dev/kfd"], ["fuser", "/dev/kfd"]):
        try:
            r = subprocess.run(cmd, capture_output=True, text=True, timeout=20)
        except (OSError, subprocess.SubprocessError) as e:
            notes.append(f"{' '.join(cmd)}: {e.__class__.__name__} -- probe blind")
            continue
        found = sorted(int(t) for t in r.stdout.split() if t.isdigit())
        pids.update(found)
        notes.append(f"{' '.join(cmd)}: {found if found else 'clean'}")
        if r.returncode == 0 or found:
            break
    return sorted(pids), notes


def foreign_containers() -> tuple[list[str], str]:
    try:
        r = subprocess.run(
            ["docker", "ps", "--format", "{{.Names}}\t{{.Image}}"],
            capture_output=True, text=True, timeout=20,
        )
    except (OSError, subprocess.SubprocessError) as e:
        return [], f"docker ps: {e.__class__.__name__} -- probe blind"
    if r.returncode != 0:
        return [], f"docker ps: exit {r.returncode} ({r.stderr.strip()[:120]}) -- probe blind"
    names = [ln.strip() for ln in r.stdout.splitlines() if ln.strip()]
    return names, f"docker ps: {names if names else 'no containers'}"


def guard_gpu_idle(force: bool) -> None:
    """Refuse to run if anything other than this process holds /dev/kfd.

    Called **before** torch is imported, which is what makes "other than itself"
    exact: this process has not opened /dev/kfd yet, so it cannot appear in the
    listing at all and there is no PID-namespace question to get wrong when the
    script runs inside a container.  `os.getpid()` is still excluded as a
    safety net in case that ordering is ever changed.
    """
    me = os.getpid()
    mine = {me, os.getppid()}
    pids, notes = kfd_holders()
    containers, dnote = foreign_containers()
    print("GPU occupancy guard (run before torch is imported, so this process holds nothing yet)")
    for n in notes + [dnote]:
        print(f"  {n}")
    strangers = [p for p in pids if p not in mine]
    if containers:
        print(f"  !! docker ps shows {len(containers)} running container(s): {containers}")
        print("  !! if any of them holds the GPU, stop now -- a co-resident job moves the DPM state.")
    if not strangers:
        print(f"  -> /dev/kfd is clean (this process is {me})\n")
        return
    msg = f"  !! /dev/kfd is held by {len(strangers)} foreign PID(s): {strangers}"
    if force:
        print(f"{msg}\n  !! --force given: measuring anyway. Every ratio in this run is suspect.\n")
        return
    sys.exit(
        f"{msg}\n"
        "  REFUSING TO RUN. A co-resident job moves the DPM state; docs/09 section 9.9\n"
        "  records a whole batch depressed 17% by exactly that, and corrupting somebody\n"
        "  else's measurement is the other half of the cost. Wait for the device, or pass\n"
        "  --force if you have established these holders are harmless.\n"
    )


# ---------------------------------------------------------------------------
# loading / signature checks
# ---------------------------------------------------------------------------
def load(path: str, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    sys.modules[name] = mod
    spec.loader.exec_module(mod)
    return mod


def require_knobs(fn, knobs=KNOBS, kernel_path: str = KERNEL) -> None:
    """Hard-fail unless every knob is a **named** parameter of `fn`.

    A `**kw` catch-all does NOT count as acceptance.  The NN entry point in this
    kernel has one, and on the native path it drops the extras on the floor
    instead of forwarding them -- so `frag_ring=3` would be silently ignored and
    the "experimental" arm would be the control measured a second time.  That is
    the exact failure this check exists to prevent.
    """
    sig = inspect.signature(fn)
    named = {
        p.name for p in sig.parameters.values()
        if p.kind in (p.POSITIONAL_OR_KEYWORD, p.KEYWORD_ONLY)
    }
    var_kw = [p.name for p in sig.parameters.values() if p.kind is p.VAR_KEYWORD]
    missing = [k for k in knobs if k not in named]
    if missing:
        extra = (
            f"\n  ({fn.__name__} does have a **{var_kw[0]} catch-all, which would swallow these "
            f"silently -- that is NOT acceptance and is why this check looks at named parameters only.)"
            if var_kw else ""
        )
        sys.exit(
            f"!! {fn.__module__}.{fn.__name__} does not accept {missing} as named keyword "
            f"parameters.{extra}\n"
            f"   The installed kernel is {kernel_path}.\n"
            f"   Refusing to run: without these the 'experimental' arm would be the control "
            f"measured twice and the campaign would report 1.0000x as a real result.\n"
        )


# ---------------------------------------------------------------------------
# the arm plan -- built without torch so `--dry-run` can print it
# ---------------------------------------------------------------------------
def arm_names(variant: str, dup: int = 0) -> list[str]:
    """The four arms of one sandwich, in execution order.

    docs/09 section 9.2: v5's order was `v4 -> v5 -> v5b -> v4b`.  Arms 1-2 run
    control-first, arms 3-4 run experimental-first, so the thermal drift that
    always favours whichever arm ran first lands on both sides once.
    """
    tag = variant if dup == 0 else f"{variant}~{dup}"
    return [f"{tag}|ctl.1", f"{tag}|exp.1", f"{tag}|exp.2", f"{tag}|ctl.2"]


def arm_kwargs(variant: str, arm: str) -> dict[str, int]:
    return dict(CONTROL) if arm.endswith(("ctl.1", "ctl.2")) else dict(VARIANTS[variant])


def pairs_for(variants: list[str], noise_dup: int) -> list[tuple[str, int]]:
    """The A/B pairs to measure, as `(variant, dup_index)`.

    The control pair is replicated `noise_dup` times per shape.  One control pair
    per shape would give a floor built from six numbers, and docs/09 section 9.1
    quantified its floors from 24 and 69 control points -- v4's thin-looking
    +2.46% reading survived one scan and died on the second, so the floor is the
    one number in the run that must not itself be noisy.  Replicas are additional
    independent sandwiches of byte-identical code, so each one is another draw
    from the same true 1.0000x, which is exactly what widens the sample.
    """
    out: list[tuple[str, int]] = []
    for v in variants:
        for i in range(max(1, noise_dup) if v == NOISE_VARIANT else 1):
            out.append((v, i))
    return out


def print_plan(shapes, variants, args) -> None:
    pairs = pairs_for(variants, args.noise_dup)
    n_ctl = sum(1 for v, _ in pairs if v == NOISE_VARIANT) * len(shapes) * len(args.passes)
    print("=" * 100)
    print("DRY RUN -- nothing below is executed and the GPU is not touched.")
    print("=" * 100)
    print(f"kernel      : {args.kernel}")
    print(f"entry point : {', '.join('grouped_gemm_bf16_' + p + '_flydsl_kernel' for p in args.passes)}")
    print(f"timing      : warmup={args.warmup}, one sample = _time(iters={args.iters}, "
          f"reps={args.inner_reps}), {args.repeats} independent repeats per arm, median reported")
    print(f"noise floor : variant {NOISE_VARIANT!r} "
          + (f"included, {args.noise_dup} pair(s) per shape => {n_ctl} control points"
             if NOISE_VARIANT in variants else "ABSENT -- nothing can be called a win"))
    print(f"json out    : {args.json_out or '(none)'}")
    print()

    n_arms = 0
    n_launch = 0
    per_repeat = args.iters * args.inner_reps
    for pas in args.passes:
        entry = f"grouped_gemm_bf16_{pas}_flydsl_kernel"
        for sh in shapes:
            _model, _proj, G, n, k, avg_m = sh
            M = G * avg_m
            flops = 2.0 * G * avg_m * n * k
            print(f"--- pass={pas}  {shape_tag(sh)}   M_total={M}  "
                  f"N={n}  K={k}  K%128={k % 128}  {flops / 1e9:.1f} GFLOP/call ---")
            print(f"    correctness gate: fp32 per-group reference on device, .cpu(), judged in "
                  f"float64; 3 calls burned, 4th checked; "
                  f"{len(variants)} variant(s) against one control reading")
            for v, dup in pairs:
                for arm in arm_names(v, dup):
                    kw = arm_kwargs(v, arm)
                    kwstr = ", ".join(f"{a}={b}" for a, b in sorted(kw.items()))
                    tail = "  <- byte-identical to control" if v == NOISE_VARIANT else ""
                    print(f"      {arm:<22s} {entry}(a, b, offs, out=, m_tiles=, {kwstr}){tail}")
                    n_arms += 1
                    n_launch += args.warmup + args.repeats * per_repeat
            print()
    print(f"total: {n_arms} arms, ~{n_launch} timed kernel launches "
          f"({args.repeats} repeats x {per_repeat} launches/sample + {args.warmup} warmup each; "
          f"the correctness gate's calls are on top of this)")
    print("ratios per point: r_fwd = ctl.1/exp.1 (control first), r_rev = ctl.2/exp.2 "
          "(experimental first), sandwich = sqrt(r_fwd * r_rev); >1 means the knob is faster")
    print("exiting without touching the GPU.")


# ---------------------------------------------------------------------------
# runtime (imported only when we are really going to measure)
# ---------------------------------------------------------------------------
def _make_sandwich(base):
    """Build the timing class on top of the repo's `Interleaved`.

    Built here rather than at module scope because `Interleaved` lives in
    `dgrad_study/common.py`, which imports torch and triton -- and `--dry-run`
    must not import either.

    The base class calibrates `iters` to fill ~40 ms.  docs/08 section 8.0 records
    the delivery-table primitive as `_time(iters=30, reps=5)` with **10
    independent repeats per point, median reported**, so a *sample* here is the
    median of `inner_reps` timings of `iters` back-to-back launches, and there
    are `repeats` samples per arm.  `_once` (wall ms per call over a loop that
    syncs only at its ends, framing the whole Python call) is the base class's,
    unmodified -- this only changes how many of them make one number, and the
    `target_ms` / `max_iters` arguments `add()` still accepts are unused.

    Execution order inside a repeat is dict insertion order, which is what makes
    the sandwich a sandwich; do not reorder `self.fns`.
    """

    class Sandwich(base):
        def __init__(self, warmup: int = 6, repeats: int = 10, iters: int = 30,
                     inner_reps: int = 5):
            super().__init__(warmup=warmup, repeats=repeats)
            self.iters = iters
            self.inner_reps = inner_reps

        def _sample(self, fn) -> float:
            return statistics.median(_c._once(fn, self.iters) for _ in range(self.inner_reps))

        def run(self, verbose: bool = False):  # noqa: FBT002
            # Warm every arm before any of them is timed, so "first arm in the
            # dict" is not also "the only cold arm".  Six calls also burns past
            # the first-call corruption docs/06 section 6.5 records for gpt-oss fc2.
            for name, (fn, _t, _m) in self.fns.items():
                for _ in range(self.warmup):
                    fn()
                if verbose:
                    print(f"        warmed {name}", flush=True)
            torch.cuda.synchronize()

            samples: dict[str, list[float]] = {n: [] for n in self.fns}
            clocks: list[float] = []
            for _ in range(self.repeats):
                for name, (fn, _t, _m) in self.fns.items():
                    samples[name].append(self._sample(fn))
                clocks.append(_c.sclk_mhz())  # section 9.9: next to every measurement
            out = {}
            for name, xs in samples.items():
                med = statistics.median(xs)
                cv = statistics.stdev(xs) / statistics.mean(xs) if len(xs) > 1 else 0.0
                out[name] = dict(
                    ms=med, cv=cv, lo=min(xs), hi=max(xs),
                    rng=(max(xs) - min(xs)) / med if med else float("nan"),
                    n=len(xs), iters=self.iters, inner_reps=self.inner_reps,
                    samples=[round(x, 6) for x in xs],
                )
            return out, clocks

    return Sandwich


def _import_runtime(smi_gpu: int) -> None:
    global torch, _c, Interleaved, Sandwich
    import torch as _torch  # noqa: PLC0415

    torch = _torch
    sys.path.insert(0, str(_REPO / "benchmarks" / "dgrad_study"))
    try:
        import common as _common  # noqa: PLC0415
    except Exception as e:  # noqa: BLE001
        sys.exit(
            f"!! cannot import benchmarks/dgrad_study/common.py ({type(e).__name__}: {e}).\n"
            f"   That module owns this repo's timing primitive (`_once`), its sclk sampler and\n"
            f"   the `Interleaved` round-robin; this script reuses them rather than growing a\n"
            f"   second, differently-calibrated timer.\n"
        )
    _c = _common
    Interleaved = _common.Interleaved
    Sandwich = _make_sandwich(Interleaved)
    # common.py hardcodes card 1; bench_matrix.py and bench_quick.py both retarget it.
    _c._SMI_GPU = smi_gpu


# ---------------------------------------------------------------------------
# case setup / reference
# ---------------------------------------------------------------------------
def make_case(pas: str, G: int, N_fwd: int, K_fwd: int, avg_m: int, seed: int = 0) -> dict:
    """Balanced groups at the real shape.

    Operands are allocated at the true size on purpose: docs/09 section 9.11
    records that shrinking an operand while the grid is still computed from the
    real M emits out-of-range workgroups, and this box reads `gpu_recovery = 0`
    when wedged, which means a device fault is a reboot.
    """
    dev = "cuda"
    torch.manual_seed(seed)
    M = G * avg_m
    lens = torch.full((G,), avg_m, dtype=torch.int64, device=dev)
    offs = torch.cat([torch.zeros(1, dtype=torch.int64, device=dev), lens.cumsum(0)])
    w = torch.randn(G, N_fwd, K_fwd, dtype=torch.bfloat16, device=dev)
    if pas == "nt":
        # fwd: out[M, N_fwd] = a[M, K_fwd] @ w[g].T
        a = torch.randn(M, K_fwd, dtype=torch.bfloat16, device=dev)
        out = torch.empty(M, N_fwd, dtype=torch.bfloat16, device=dev)
        n_out, k_red = N_fwd, K_fwd
    else:
        # dgrad: out[M, K_fwd] = dout[M, N_fwd] @ w[g]; reduction is N_fwd.
        a = torch.randn(M, N_fwd, dtype=torch.bfloat16, device=dev)
        out = torch.empty(M, K_fwd, dtype=torch.bfloat16, device=dev)
        n_out, k_red = K_fwd, N_fwd
    return dict(pas=pas, G=G, avg_m=avg_m, M=M, a=a, w=w, offs=offs, out=out,
                n_out=n_out, k_red=k_red, flops=2.0 * M * n_out * k_red)


def fp32_reference(case: dict):
    """Per-group fp32 matmul, moved to host.

    fp32 and not fp64: docs/06 section 6.3 records a device fp64 matmul giving the
    wrong answer 11 times in 12 on this part.  The comparison itself is done on
    the host in float64, which is a different thing from computing in fp64.
    """
    G, avg_m, a, w = case["G"], case["avg_m"], case["a"], case["w"]
    chunks = []
    for g in range(G):
        rows = a[g * avg_m:(g + 1) * avg_m].float()
        chunks.append(rows @ (w[g].float().t() if case["pas"] == "nt" else w[g].float()))
    return torch.cat(chunks).cpu()


def rel_fro(x, ref) -> float:
    return (x.double() - ref.double()).norm().item() / ref.double().norm().item()


def build_call(K, case: dict, kwargs: dict[str, int]):
    """Bind one arm.

    `out=` and `m_tiles=` are passed for the same reason bench_matrix.py passes
    them: docs/09 section 9.3 -- a dimension hidden under a fixed host cost cannot
    be measured, and building the M-tile table costs ~24 us of tiny device ops
    per call.  The tile table is provenance-checked by the kernel, so a stale one
    raises rather than computing the wrong thing.
    """
    a, w, offs, out = case["a"], case["w"], case["offs"], case["out"]
    if case["pas"] == "nt":
        tile_m = K._pick_config(case["n_out"], case["k_red"], case["avg_m"], case["G"])[0]
        mt = K.build_m_tile_map(offs, tile_m)
        fn = K.grouped_gemm_bf16_nt_flydsl_kernel
    else:
        tile_m = K._pick_config_nn(case["n_out"], case["k_red"], case["avg_m"], case["G"])[0]
        mt = K.build_m_tile_map(offs, tile_m)
        fn = K.grouped_gemm_bf16_nn_flydsl_kernel
    return (lambda: fn(a, w, offs, out=out, m_tiles=mt, **kwargs)), mt, tile_m


# ---------------------------------------------------------------------------
# phase 1: correctness
# ---------------------------------------------------------------------------
def gate_measure(K, case: dict, ref, kwargs: dict[str, int]):
    """One arm's correctness reading: burn 3 calls, judge the 4th on the host.

    docs/06 section 6.5: the reference kernel records gpt-oss fc2 dgrad returning
    corrupt results on the first 1-2 calls of a fresh process. It did not
    reproduce here, but "did not reproduce" is not "fixed" and burning three
    calls is nearly free.
    """
    fn, _mt, _tile_m = build_call(K, case, kwargs)
    for _ in range(3):
        fn()
    got = fn().clone()
    host = got.cpu().float()
    bad = int(torch.isnan(host).sum() + torch.isinf(host).sum())
    return got, rel_fro(host, ref), bad


def correctness_phase(K, shapes, variants, args) -> list[dict]:
    print("=" * 118)
    print("PHASE 1 -- correctness gate (fp32 reference, judged host-side in float64, 3 calls "
          "burned and the 4th checked)")
    print("=" * 118)
    hdr = (f"{'pass':<5s} {'shape':<42s} {'variant':<12s} {'rel_err':>10s} {'bf16 floor':>10s} "
           f"{'d vs ctl':>10s} {'biteq':>7s} {'nan':>4s} {'verdict':>8s}")
    print(hdr)
    print("-" * len(hdr))
    rows, fails = [], []
    for pas in args.passes:
        for sh in shapes:
            _model, _proj, G, n, k, avg_m = sh
            case = make_case(pas, G, n, k, avg_m, seed=args.seed)
            ref = fp32_reference(case)
            floor = rel_fro(ref.to(torch.bfloat16).float(), ref)

            ctl_out, ctl_err, ctl_nan = gate_measure(K, case, ref, dict(CONTROL))
            for v in variants:
                if v == NOISE_VARIANT:
                    # The noise-floor arm IS the control, so it is not measured a
                    # second time; biteq True and delta 0.0 are the true values
                    # for it, not a shortcut that hides anything.
                    got, err, nan = ctl_out, ctl_err, ctl_nan
                else:
                    got, err, nan = gate_measure(K, case, ref, dict(VARIANTS[v]))
                biteq = bool(torch.equal(got.view(torch.int16), ctl_out.view(torch.int16)))
                delta = abs(err - ctl_err)
                ok = err < ACCEPT_REL and nan == 0 and delta <= ACCEPT_DELTA_VS_CONTROL
                print(f"{pas:<5s} {shape_tag(sh):<42s} {v:<12s} {err:>10.3e} {floor:>10.3e} "
                      f"{delta:>10.1e} {str(biteq):>7s} {nan:>4d} {'OK' if ok else 'FAIL':>8s}",
                      flush=True)
                rows.append(dict(pas=pas, shape=shape_tag(sh), variant=v, rel_err=err,
                                 bf16_floor=floor, delta_vs_control=delta, biteq=biteq,
                                 nan=nan, ok=ok))
                if not ok:
                    fails.append(f"{pas}/{shape_tag(sh)}/{v}: rel_err={err:.3e} "
                                 f"(gate {ACCEPT_REL}), delta_vs_control={delta:.1e} "
                                 f"(gate {ACCEPT_DELTA_VS_CONTROL}), nan={nan}")
                if v != NOISE_VARIANT:
                    del got
            del case, ref, ctl_out
            torch.cuda.empty_cache()
    print()
    if fails:
        print("!! CORRECTNESS FAILURES -- aborting before any timing:")
        for f in fails:
            print("   ", f)
        sys.exit(
            "\nA variant that computes the wrong answer is not a data point. "
            "docs/09 section 9.10: 'because it quietly skipped the ragged tail, so it is faster' "
            "looks exactly like a win.\n"
        )
    n_biteq = sum(1 for r in rows if r["biteq"])
    print(f"all {len(rows)} arms pass. bit-equal to control on {n_biteq}/{len(rows)}; "
          f"worst rel_err {max(r['rel_err'] for r in rows):.4e} against gate {ACCEPT_REL}, "
          f"worst bf16 floor {max(r['bf16_floor'] for r in rows):.4e}\n")
    return rows


# ---------------------------------------------------------------------------
# phase 2: timing
# ---------------------------------------------------------------------------
def timing_phase(K, shapes, variants, args) -> list[dict]:
    print("=" * 118)
    print(f"PHASE 2 -- sandwich timing. Each point: ctl.1 -> exp.1 -> exp.2 -> ctl.2 round-robin, "
          f"{args.repeats} repeats, median of samples,")
    print(f"           one sample = _time(iters={args.iters}, reps={args.inner_reps}). "
          f"r_fwd = ctl.1/exp.1, r_rev = ctl.2/exp.2, sandwich = sqrt(r_fwd*r_rev); >1 = knob faster.")
    print("=" * 118)
    hdr = (f"{'pass':<5s} {'shape':<42s} {'variant':<12s} {'ctl ms':>9s} {'exp ms':>9s} "
           f"{'r_fwd':>7s} {'r_rev':>7s} {'sandwich':>9s} {'TF/s':>7s} {'cv%':>5s} "
           f"{'rng%':>5s} {'sclk':>6s}")
    print(hdr)
    print("-" * len(hdr))
    rows = []
    for pas in args.passes:
        for sh in shapes:
            model, proj, G, n, k, avg_m = sh
            case = make_case(pas, G, n, k, avg_m, seed=args.seed)
            iv = Sandwich(warmup=args.warmup, repeats=args.repeats,
                          iters=args.iters, inner_reps=args.inner_reps)
            keep = []
            pairs = pairs_for(variants, args.noise_dup)
            for v, dup in pairs:
                for arm in arm_names(v, dup):
                    fn, mt, tile_m = build_call(K, case, arm_kwargs(v, arm))
                    keep.append(mt)
                    iv.add(arm, fn)
            res, clocks = iv.run(verbose=args.verbose)
            good = [c for c in clocks if c == c]
            sclk = statistics.median(good) if good else float("nan")

            for v, dup in pairs:
                a1, e1, e2, a2 = arm_names(v, dup)
                # Geometric means of the two directions, so the displayed
                # ctl_ms / exp_ms is exactly the sandwich ratio rather than
                # something close to it.
                ctl_ms = math.sqrt(res[a1]["ms"] * res[a2]["ms"])
                exp_ms = math.sqrt(res[e1]["ms"] * res[e2]["ms"])
                r_fwd = res[a1]["ms"] / res[e1]["ms"]
                r_rev = res[a2]["ms"] / res[e2]["ms"]
                sandwich = math.sqrt(r_fwd * r_rev)
                rng = max(res[x]["rng"] for x in (a1, e1, e2, a2))
                cv = max(res[x]["cv"] for x in (a1, e1, e2, a2))
                tf = case["flops"] / (exp_ms * 1e-3) / 1e12
                label = v if dup == 0 else f"{v}~{dup}"
                print(f"{pas:<5s} {shape_tag(sh):<42s} {label:<12s} {ctl_ms:>9.4f} {exp_ms:>9.4f} "
                      f"{r_fwd:>7.4f} {r_rev:>7.4f} {sandwich:>9.4f} {tf:>7.1f} "
                      f"{cv * 100:>5.2f} {rng * 100:>5.2f} {sclk:>6.0f}"
                      + ("  <- DIRTY (range gate)" if rng > args.range_gate else ""), flush=True)
                rows.append(dict(
                    pas=pas, shape=shape_tag(sh), model=model, proj=proj, G=G, N=n, K=k,
                    avg_m=avg_m, M=case["M"], variant=v, dup=dup, kwargs=dict(VARIANTS[v]),
                    ctl_ms=ctl_ms, exp_ms=exp_ms, r_fwd=r_fwd, r_rev=r_rev, sandwich=sandwich,
                    tflops=tf, cv=cv, range=rng, dirty=bool(rng > args.range_gate),
                    sclk_median=sclk, sclk_min=min(good) if good else None,
                    sclk_max=max(good) if good else None, sclk_samples=clocks,
                    arms={x: {kk: vv for kk, vv in res[x].items()} for x in (a1, e1, e2, a2)},
                ))
            del case, iv, keep
            torch.cuda.empty_cache()
            print(flush=True)
    return rows


# ---------------------------------------------------------------------------
# phase 3: analysis
# ---------------------------------------------------------------------------
def analysis_phase(rows, variants, args) -> dict:
    print("=" * 118)
    print("PHASE 3 -- noise floor and verdicts")
    print("=" * 118)

    clean = [r for r in rows if not r["dirty"]]
    dirty = len(rows) - len(clean)
    if dirty:
        print(f"docs/09 section 9.7: {dirty} of {len(rows)} points exceeded the "
              f"{args.range_gate * 100:.0f}% repeat-range gate and are reported but excluded "
              f"from every aggregate below.")

    ctl = [r["sandwich"] for r in clean if r["variant"] == NOISE_VARIANT]
    floor = None
    if ctl:
        g = statistics.geometric_mean(ctl)
        floor = abs(g - 1.0)
        spread = max(abs(min(ctl) - 1.0), abs(max(ctl) - 1.0))
        print(f"\nNOISE FLOOR (variant {NOISE_VARIANT!r}, byte-identical code on both sides, "
              f"true value 1.0000x)")
        print(f"  measured {g:.4f}x over {len(ctl)} points, range {min(ctl):.4f} - {max(ctl):.4f}")
        print(f"  => noise floor {floor * 100:.3f}%  (worst single control point "
              f"{spread * 100:.3f}% off 1.0000x)")
        print(f"  Nothing below {floor * 100:.3f}% is called a win. docs/09 section 9.1: the same "
              f"+2.46% reading was noise in v4 and signal in v5; the only difference was this ruler.")
        if floor < spread / 3:
            print(f"  !! the control's geomean happened to land very close to 1.0000x, so the "
                  f"headline floor ({floor * 100:.3f}%) is much tighter than the worst single")
            print(f"  !! control point ({spread * 100:.3f}%). The '>spread' column below is the "
                  f"conservative count; prefer it when a verdict is close.")
    else:
        spread = None
        print("\n!! NO NOISE FLOOR: the control variant was not measured in this run.")
        print("   Every ratio below is unjudged. docs/09 section 9.1 -- a noise floor from another "
              "session measures something else (cross-session variance on this box is +-8%).")

    print("\nPER-VARIANT AGGREGATE (sandwich ratios; >1 = the knob is faster)")
    hdr = (f"{'variant':<12s} {'n':>4s} {'geomean':>9s} {'min':>8s} {'max':>8s} "
           f"{'>floor':>7s} {'>spread':>8s} {'wins':>5s} {'losses':>7s} {'verdict':>16s}")
    print(hdr)
    print("-" * len(hdr))
    agg = {}
    for v in variants:
        rr = [r["sandwich"] for r in clean if r["variant"] == v]
        if not rr:
            continue
        g = statistics.geometric_mean(rr)
        if floor is None:
            n_above = n_above_spread = wins = losses = None
            verdict = "unjudged"
        else:
            n_above = sum(1 for x in rr if abs(x - 1.0) > floor)
            n_above_spread = sum(1 for x in rr if abs(x - 1.0) > spread)
            wins = sum(1 for x in rr if x - 1.0 > floor)
            losses = sum(1 for x in rr if 1.0 - x > floor)
            if v == NOISE_VARIANT:
                verdict = "= the ruler"
            elif g - 1.0 > floor:
                verdict = f"WIN {(g - 1) * 100:+.2f}%"
            elif 1.0 - g > floor:
                verdict = f"LOSS {(g - 1) * 100:+.2f}%"
            else:
                verdict = "within noise"
        print(f"{v:<12s} {len(rr):>4d} {g:>9.4f} {min(rr):>8.4f} {max(rr):>8.4f} "
              f"{'-' if n_above is None else n_above:>7} "
              f"{'-' if n_above_spread is None else n_above_spread:>8} "
              f"{'-' if wins is None else wins:>5} "
              f"{'-' if losses is None else losses:>7} {verdict:>16s}")
        agg[v] = dict(n=len(rr), geomean=g, min=min(rr), max=max(rr),
                      n_above_floor=n_above, n_above_spread=n_above_spread,
                      wins=wins, losses=losses, verdict=verdict)

    sclks = [r["sclk_median"] for r in rows if r["sclk_median"] == r["sclk_median"]]
    if sclks:
        print(f"\nsclk over the run: median {statistics.median(sclks):.0f} MHz, "
              f"range {min(sclks):.0f} - {max(sclks):.0f} MHz")
        if min(sclks) <= DPM_DEGRADED_MHZ:
            print(f"  !! at or below {DPM_DEGRADED_MHZ:.0f} MHz. docs/09 section 9.9 records a DPM "
                  "regression that pins level 1 at 1400 MHz and is cleared only by a reboot.")
            print("  !! the same-session ratios above are still valid; the absolute TF/s are not "
                  "comparable with any other session.")
    print("\nCalibre: same session, back-to-back, sandwich (both orders, geometric mean), "
          f"{args.repeats} repeats per arm, median of samples, one sample = "
          f"_time(iters={args.iters}, reps={args.inner_reps}); noise floor from "
          f"{len(ctl)} control point(s) at --noise-dup {args.noise_dup}.")
    return dict(noise_floor=floor, noise_floor_spread=spread, control_points=len(ctl),
                noise_dup=args.noise_dup, dirty_points=dirty, aggregate=agg)


# ---------------------------------------------------------------------------
def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--kernel", default=KERNEL)
    ap.add_argument("--variants", nargs="+", default=DEFAULT_VARIANTS,
                    choices=list(VARIANTS), metavar="NAME",
                    help=f"one knob at a time: {' '.join(VARIANTS)}")
    ap.add_argument("--shapes", nargs="*", default=None, metavar="SUBSTR",
                    help="substring filter over the shape tags; default is all six")
    ap.add_argument("--passes", nargs="+", default=["nt"], choices=["nt", "nn"])
    ap.add_argument("--repeats", type=int, default=10, help="independent repeats per arm (docs/08 s8.0)")
    ap.add_argument("--iters", type=int, default=30, help="launches per inner timing (_time iters)")
    ap.add_argument("--inner-reps", type=int, default=5, help="inner timings per sample (_time reps)")
    ap.add_argument("--warmup", type=int, default=6)
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--range-gate", type=float, default=RANGE_GATE)
    ap.add_argument("--smi-gpu", type=int, default=int(os.environ.get("HIP_VISIBLE_DEVICES", "2")))
    ap.add_argument("--json-out", default=None)
    ap.add_argument("--dry-run", action="store_true",
                    help="print every arm that would run and exit without touching the GPU")
    ap.add_argument("--noise-dup", type=int, default=2, metavar="N",
                    help="independent control-vs-control sandwiches per shape (default 2). One "
                         "would build the noise floor out of as many numbers as there are shapes; "
                         "docs/09 s9.1 quantified its floors from 24 and 69 control points")
    ap.add_argument("--no-noise-floor", action="store_true",
                    help="drop the control-vs-control arm (nothing can then be called a win)")
    ap.add_argument("--force", action="store_true",
                    help="run even though /dev/kfd is held by a foreign process")
    ap.add_argument("--verbose", action="store_true")
    args = ap.parse_args()

    variants = list(dict.fromkeys(args.variants))
    if args.no_noise_floor:
        variants = [v for v in variants if v != NOISE_VARIANT]
        print("!! --no-noise-floor: this run has no ruler. docs/09 section 9.1 -- without a\n"
              "!! control-vs-control arm measured in the same run on the same data, nothing\n"
              "!! measured below can be called a win, and the report will say so.\n")
    elif NOISE_VARIANT not in variants:
        variants.insert(0, NOISE_VARIANT)
    else:  # keep it first so it is measured on every shape before anything else
        variants.remove(NOISE_VARIANT)
        variants.insert(0, NOISE_VARIANT)
    if not variants:
        sys.exit("!! nothing to measure: --no-noise-floor removed the only selected variant.")

    shapes = SHAPES
    if args.shapes:
        shapes = [s for s in SHAPES if any(f in shape_tag(s) for f in args.shapes)]
        if not shapes:
            sys.exit(f"!! no shape tag matches {args.shapes}. Known tags:\n  "
                     + "\n  ".join(shape_tag(s) for s in SHAPES))

    if args.dry_run or os.environ.get("HK_AB_DRYRUN") == "1":
        if os.environ.get("HK_AB_DRYRUN") == "1" and not args.dry_run:
            print("HK_AB_DRYRUN=1 in the environment -- treating this as --dry-run.\n")
        print_plan(shapes, variants, args)
        return 0

    guard_gpu_idle(args.force)
    _import_runtime(args.smi_gpu)
    K = load(args.kernel, "gg_hk")
    entries = {"nt": K.grouped_gemm_bf16_nt_flydsl_kernel, "nn": K.grouped_gemm_bf16_nn_flydsl_kernel}
    for pas in args.passes:
        require_knobs(entries[pas], KNOBS, args.kernel)

    print(f"kernel  : {args.kernel}")
    print(f"device  : {torch.cuda.get_device_properties(0).gcnArchName}  "
          f"peak {PEAK_TFLOPS} TF/s bf16")
    print(f"sclk    : {_c.sclk_mhz():.0f} MHz at start (unpinned; sampled next to every point)")
    print(f"variants: {variants}")
    print(f"shapes  : {len(shapes)}  passes: {args.passes}\n")

    corr = correctness_phase(K, shapes, variants, args)
    rows = timing_phase(K, shapes, variants, args)
    summary = analysis_phase(rows, variants, args)

    if args.json_out:
        out = Path(args.json_out)
        out.parent.mkdir(parents=True, exist_ok=True)
        json.dump(dict(
            kernel=args.kernel, variants={v: VARIANTS[v] for v in variants}, control=CONTROL,
            shapes=[shape_tag(s) for s in shapes], passes=args.passes,
            calibre=dict(repeats=args.repeats, iters=args.iters, inner_reps=args.inner_reps,
                         warmup=args.warmup, sandwich=True, same_session=True,
                         range_gate=args.range_gate, noise_dup=args.noise_dup),
            correctness=corr, points=rows, summary=summary,
        ), open(out, "w"), indent=1, default=str)
        print(f"\nwrote {out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
