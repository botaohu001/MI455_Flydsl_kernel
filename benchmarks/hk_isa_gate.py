#!/usr/bin/env python3
"""Compile-only ISA gate for the four opt-in scheduling knobs. NEVER LAUNCHES.

`flyc.compile()` **launches by default** (docs/09-measurement-methodology.md
section 9.4, trap 1).  On this box a device-side fault is not recoverable --
`gpu_recovery` was read as `0` while wedged, which means no ring timeout, no
queue reset, reboot only (section 9.11).  So this script sets `COMPILE_ONLY=1`
itself, at the top of the file, before torch or flydsl can be imported, refuses
to start if that did not stick, and re-checks after every compile that the
kernel's `_NT_COMPILED` cache is still empty -- that cache is populated only when
`flyc.compile` returns a callable, i.e. only when something was actually
launched.  Three independent locks on the same door.

⚠️ AND THE FIRST TWO DO NOT HOLD.  `COMPILE_ONLY=1` is necessary but **not
sufficient** on this flydsl build: `flyc.compile()` returns a live callable
regardless of the flag, so the kernel's launcher dispatches for real.  The third
lock is what caught it.  See `enforce_compile_only` below -- it is installed
before any compile and is the thing that actually makes this script safe.

What it is for (section 9.4): twenty seconds of compiling per candidate to keep
a big-spill candidate out of the timing harness entirely.  The v5 round ran 75
PASS / 6 SPILL / 2 illegal through a gate like this, and a whole four-candidate
arm was rejected without a single benchmark because it spilled 59 / 250 / 288 /
435 registers -- not "tried it, no good", but "algebraically does not exist".

    *** The gate judges NEGATIVE, never positive. ***

Passing here means nothing about speed.  Section 9.8 has three cases where the
compile gate and the microbenchmark were both clean and the end-to-end number
was negative (one of them by 53.8%).

Run:

    COMPILE_ONLY=1 python benchmarks/hk_isa_gate.py --json-out results/hk/isa_gate.json

It never enqueues the kernel under test. It is not a no-op on a shared device
either: it initialises HIP and allocates the operands at their true shape
(section 9.11 forbids shrinking them), so it still takes VRAM from whoever else
is on the card.
"""
from __future__ import annotations

# ---------------------------------------------------------------------------
# Environment, BEFORE torch / flydsl are imported.  Everything above the
# `import torch` line below is load-bearing; do not move it.
# ---------------------------------------------------------------------------
import os
import sys
from pathlib import Path

_REPO = Path(__file__).resolve().parent.parent


def _early_arg(flag: str, default: str) -> str:
    """Read one argument out of sys.argv before argparse exists.

    `FLYDSL_DUMP_DIR` has to be in the environment before flydsl is imported (it
    may latch the value at import time), and argparse cannot run that early.
    """
    argv = sys.argv[1:]
    for i, tok in enumerate(argv):
        if tok == flag and i + 1 < len(argv):
            return argv[i + 1]
        if tok.startswith(flag + "="):
            return tok.split("=", 1)[1]
    return default


DUMP_ROOT = os.path.abspath(_early_arg("--dump-dir", str(_REPO / "asm" / "hk_gate")))
os.makedirs(DUMP_ROOT, exist_ok=True)

os.environ["COMPILE_ONLY"] = "1"
os.environ["FLYDSL_DUMP_IR"] = "1"
os.environ["FLYDSL_DEBUG_DUMP_ASM"] = "1"
# Re-pointed at a per-(variant, shape) subdirectory before every compile; this is
# only the value flydsl sees at import time.
os.environ["FLYDSL_DUMP_DIR"] = DUMP_ROOT

if os.environ.get("COMPILE_ONLY") != "1":
    sys.exit(
        "!! COMPILE_ONLY is not '1' after this script set it "
        f"(got {os.environ.get('COMPILE_ONLY')!r}).\n"
        "   Refusing to start. Without it `flyc.compile()` really launches, and on this box\n"
        "   a device fault is a reboot (docs/09 sections 9.4 and 9.11).\n"
    )

import argparse  # noqa: E402
import collections  # noqa: E402
import glob  # noqa: E402
import hashlib  # noqa: E402
import importlib.util  # noqa: E402
import json  # noqa: E402
import re  # noqa: E402
import shutil  # noqa: E402
import time  # noqa: E402

import torch  # noqa: E402

# The variant and shape tables live in hk_ab.py so the gate and the timing
# campaign cannot select different candidates.  hk_ab imports nothing heavy at
# module scope, so this is safe here.
sys.path.insert(0, str(_REPO / "benchmarks"))
import hk_ab  # noqa: E402
from hk_ab import CONTROL, KNOBS, SHAPES, VARIANTS, shape_tag  # noqa: E402

KERNEL = str(_REPO / "kernel" / "grouped_gemm_bf16_kernel_mi455.py")
DEFAULT_VARIANTS = ["control", "frag_ring", "sched_style", "lock_simd", "split_bar", "all"]

# gfx1250 hardware constants, from docs/01-architecture.md and docs/08 section 8.6.1.
VGPR_FILE = 131072  # per-SIMD VGPRs; the cliff is min(VGPR_FILE / flat_wg_size, 1024)
VGPR_PER_LANE_CAP = 1024
LDS_PER_CU = 320 * 1024  # 327680 B; WG/CU = LDS_PER_CU // arena
WAVE = 32  # gfx1250 is wave32
WMMA_K = 32

# ---------------------------------------------------------------------------
# THE GATE RULE.
#
# Taken from docs/09-measurement-methodology.md section 9.4, and it differs from
# the naive "any spill fails" in one specific way that the doc argues from a
# measurement:
#
#   "'spill > 0 fails' is wrong -- there is a measured counterexample. On TN
#    wgrad the version WITH 3 spills was 5.3% faster than the version with zero
#    (1606.1 vs 1520.8 TF/s): frag_pipeline=1 keeps two fragment sets live, tops
#    out the 512-VGPR ceiling and spills 3, and the latency hiding it buys is
#    worth more than 3 spills. The gate's value is 'reject a BIG spill in twenty
#    seconds' (the hundreds -- 420, 804), not 'spill != 0 fails'. A few spills
#    are a thing to look into, not a verdict."
#
# So the implemented rule is three-state:
#
#   FAIL   vgpr_count > min(131072 // flat_workgroup_size, 1024)        [hard cliff]
#   FAIL   vgpr_spill + sgpr_spill > --spill-fail   (default 32)        [big spill]
#   WATCH  0 < vgpr_spill + sgpr_spill <= --spill-fail, or scratch > 0  [look into it]
#   PASS   otherwise
#
# The smallest spill the doc records as a real cliff event is 44 and the largest
# it records as benign is 3, so 32 sits inside that gap rather than on a guess.
# `--strict-spill` restores the literal "any spill or any scratch fails" rule for
# anyone who wants it; it is not the default because the doc says it is wrong.
#
# Also from section 9.4, trap 2: `.group_segment_fixed_size` reads 0 when LDS is
# allocated dynamically (`fx.SharedAllocator(static=False)`), which is what this
# kernel does -- the checked-in dump reads 0 while the real arena is 278528 B.
# The WG/CU judgement therefore uses the arena recomputed from the tile config,
# and BOTH numbers are printed so the discrepancy stays visible.
# ---------------------------------------------------------------------------
SPILL_FAIL_DEFAULT = 32


# ---------------------------------------------------------------------------
# ISA parsing
# ---------------------------------------------------------------------------
# docs/09 section 9.11: gfx11+/gfx12+ renamed the LDS and wait instructions.
# Grepping for the gfx9 names returns zero and reads as "this kernel does not use
# LDS", which is a mistake this project actually made. Both spellings are matched
# and folded together.
_MNEMONICS: tuple[tuple[str, str], ...] = (
    ("v_wmma", r"v_wmma\w*"),
    ("ds_load_b128", r"ds_(?:load|read)_b128"),            # gfx9 name was ds_read_b128
    ("ds_load_tr16_b128", r"ds_(?:load|read)_tr16_b128"),
    ("ds_store_b128", r"ds_(?:store|write)_b128"),
    ("s_wait_dscnt", r"s_wait_dscnt"),
    ("s_wait_tensorcnt", r"s_wait_tensorcnt"),
    ("s_wait_loadcnt", r"s_wait_loadcnt"),
    ("s_wait_kmcnt", r"s_wait_kmcnt"),
    ("s_wait_alu", r"s_wait_alu"),
    ("s_delay_alu", r"s_delay_alu"),
    ("s_wait_xcnt", r"s_wait_xcnt"),
    ("s_barrier", r"s_barrier"),                            # bare only -- see below
    ("s_barrier_signal", r"s_barrier_signal\w*"),
    ("s_barrier_wait", r"s_barrier_wait\w*"),
    # ^ READ THE split_bar NOTE BELOW BEFORE INTERPRETING THESE TWO COLUMNS.
    ("s_setreg", r"s_setreg\w*"),                           # lock_simd / wmma_b2b evidence
    ("scratch_store", r"scratch_store\w*"),
    ("scratch_load", r"scratch_load\w*"),
    ("tensor_load_to_lds", r"tensor_load_to_lds"),
    ("tensor_store_from_lds", r"tensor_store_from_lds"),
)
# fullmatch, not startswith: `s_barrier` must not absorb `s_barrier_signal` and
# `s_barrier_wait`. A plain `grep -c s_barrier` on the checked-in dump returns 8,
# which is 4 signals plus 4 waits and zero bare barriers.
#
# ⚠️ `split_bar` CANNOT BE DETECTED FROM THESE COUNTS.  The knob is described as
# "split the per-K-tile barrier into s_barrier_signal / s_barrier_wait", but the
# baseline is **already split**: the kernel calls `gpu.barrier()`
# (`_workgroup_barrier` / the fused READY+REUSE `_pipeline_fence`) and the gfx1250
# backend lowers each one to a signal/wait pair.  asm/nn_native/21_final_isa.s
# reads `s_barrier_signal 4`, `s_barrier_wait 4`, **bare `s_barrier` 0** -- so
# `split_bar=1` does not add barrier instructions, it moves the K-tile's last WMMA
# sub-step *between* an existing signal and its wait.  Expect these two columns to
# be UNCHANGED at 4/4 and the bare column to stay 0.  What proves the knob did
# something is `same_asm_as_control` going False (the instruction *order* changed),
# which is what the INERT check below actually tests.
_MNEMONIC_RE = tuple((name, re.compile(pat + r"\Z")) for name, pat in _MNEMONICS)

_META_FIELDS = (
    (r"\.vgpr_count:\s*(\d+)", "vgpr_count"),
    (r"\.sgpr_count:\s*(\d+)", "sgpr_count"),
    (r"\.vgpr_spill_count:\s*(\d+)", "vgpr_spill_count"),
    (r"\.sgpr_spill_count:\s*(\d+)", "sgpr_spill_count"),
    (r"\.agpr_count:\s*(\d+)", "agpr_count"),
    (r"\.group_segment_fixed_size:\s*(\d+)", "group_segment_fixed_size"),
    (r"\.private_segment_fixed_size:\s*(\d+)", "private_segment_fixed_size"),
    (r"\.max_flat_workgroup_size:\s*(\d+)", "max_flat_workgroup_size"),
    (r"\.kernarg_segment_size:\s*(\d+)", "kernarg_segment_size"),
)


def mnemonics(asm_text: str) -> collections.Counter:
    """Per-mnemonic instruction counts.

    The line filter is the one `benchmarks/dump_stats.py` uses, plus one guard: a
    leading `-`.  The trailing `.amdgpu_metadata` block is YAML, and its list items
    (`      - 128` under `.reqd_workgroup_size`) start with neither `.` nor `;` and
    do not end in `:`, so dump_stats.py counts 14 of them as an instruction called
    `-`.  Per-mnemonic counts are unaffected either way -- nothing matches `-` --
    so the numbers quoted in docs/04-native-nn-pipeline.md and asm/README.md stay
    comparable; only `_total_instr` here is 14 lower than dump_stats.py's, and
    correct.
    """
    raw: collections.Counter = collections.Counter()
    for line in asm_text.splitlines():
        s = line.strip()
        if not s or s.startswith((".", ";", "//", "/*", "-")) or s.endswith(":"):
            continue
        raw[s.split()[0]] += 1
    out: collections.Counter = collections.Counter()
    for name, rx in _MNEMONIC_RE:
        out[name] = sum(c for m, c in raw.items() if rx.match(m))
    out["_total_instr"] = sum(raw.values())
    return out


def metadata(asm_text: str) -> dict:
    out: dict = {}
    for pat, key in _META_FIELDS:
        m = re.search(pat, asm_text)
        if m:
            out[key] = int(m.group(1))
    m = re.search(r"\.reqd_workgroup_size:\s*\n((?:\s*-\s*\d+\s*\n){1,3})", asm_text)
    if m:
        out["reqd_workgroup_size"] = [int(x) for x in re.findall(r"-\s*(\d+)", m.group(1))]
    m = re.search(r"amdhsa\.target:\s*(\S+)", asm_text)
    if m:
        out["target"] = m.group(1)
    return out


# ---------------------------------------------------------------------------
# Derived quantities the metadata does not give you
# ---------------------------------------------------------------------------
def _ceil(x: int, n: int) -> int:
    return ((x + n - 1) // n) * n


def lds_arena_bytes(K, tile: tuple[int, ...], b_lds_transpose: int) -> int | None:
    """Recompute the LDS arena the way the launcher does.

    Needed because `.group_segment_fixed_size` reads 0 under a dynamic
    `SharedAllocator` (docs/09 section 9.4 trap 2); the checked-in dump reads 0
    against a real 278528 B. Mirrors `_launch_grouped_gemm_bf16_nt`.
    """
    try:
        tile_m, tile_n, tile_k, _mw, _nw, num_buffers = tile
        eb = 2
        lds_row = tile_k * eb + 16  # LDS_PAD = 16
        stage_a = _ceil(tile_m * lds_row, 16)
        if b_lds_transpose:
            b_pad = K._nn_b_pad(tile_n, eb)
            lds_b_row, b_rows = tile_n * eb + b_pad, tile_k
        else:
            lds_b_row, b_rows = lds_row, tile_n
        stage_b = _ceil(b_rows * lds_b_row, 16)
        pitch = _ceil(stage_a + stage_b, 1024)
        c_store = _ceil(tile_m * tile_n * eb, 128)
        return max(num_buffers * pitch, c_store)
    except Exception:  # noqa: BLE001
        return None


def per_ktile(tile: tuple[int, ...], mn: collections.Counter) -> dict:
    """`s_wait_dscnt` (and friends) per K-tile, derived from the WMMA count.

    One K-tile issues `n_acc * K_WS` matrix ops per compute body, so the number
    of compute bodies the compiler emitted is `wmma_total / (n_acc * K_WS)` --
    two, in the production 256x256x128 config, which is how docs/09 section 9.11
    reconciles 192 `ds_load_b128` with "24 per K-tile x K_WS=4 x 2 bodies".
    Dividing the wait counts by the same body count gives a per-K-tile figure
    that is comparable across variants.

    `sched_style=1` is on test precisely here: the hypothesis is that replacing
    the fine-grained group-barrier interleave with one `sched_barrier(0)`-fenced
    burst per sub-step lowers the number of operand-pipeline drains per K-tile.
    """
    tile_m, tile_n, tile_k, mw, nw, _nb = tile
    k_ws = tile_k // WMMA_K
    n_acc = (tile_m // mw // 16) * (tile_n // nw // 16)
    per_body = n_acc * k_ws
    wmma = mn["v_wmma"]
    if not per_body or not wmma or wmma % per_body:
        return dict(k_ws=k_ws, n_acc=n_acc, bodies=None, dscnt_per_ktile=None,
                    dscnt_per_substep=None)
    bodies = wmma // per_body
    dsc = mn["s_wait_dscnt"] / bodies
    return dict(k_ws=k_ws, n_acc=n_acc, bodies=bodies,
                dscnt_per_ktile=dsc, dscnt_per_substep=dsc / k_ws)


def sync_ratios(mn: collections.Counter) -> dict:
    """Both calibres of the sync-to-work ratio.

    docs/09 section 9.11: leaving `s_wait_alu` / `s_delay_alu` out of the count
    produced 0.098 where the two defensible answers are 0.117 (the literal
    document calibre) and 0.523 (including the ALU waits). Whichever a reference
    number used is usually not written down, so both are reported.
    """
    work = mn["v_wmma"] or 1
    narrow = sum(mn[k] for k in ("s_wait_dscnt", "s_wait_tensorcnt", "s_wait_loadcnt",
                                 "s_wait_kmcnt", "s_barrier", "s_barrier_signal",
                                 "s_barrier_wait"))
    wide = narrow + sum(mn[k] for k in ("s_wait_alu", "s_delay_alu", "s_wait_xcnt"))
    return dict(sync_narrow=narrow, sync_wide=wide,
                ratio_narrow=narrow / work, ratio_wide=wide / work)


# ---------------------------------------------------------------------------
# compiling one (variant, shape)
# ---------------------------------------------------------------------------
def load(path: str, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    sys.modules[name] = mod
    spec.loader.exec_module(mod)
    return mod


def enforce_compile_only(K) -> str:
    """Make `COMPILE_ONLY=1` actually mean compile-only.  IT DOES NOT ON ITS OWN.

    ⚠️ Measured on this box against flydsl at
    `venv_flydsl/lib/python3.12/site-packages/flydsl`, and it contradicts what
    both this file and the kernel assumed:

        `flyc.compile()` RETURNS A LIVE CALLABLE UNDER COMPILE_ONLY=1.

    `JitFunction.__call__` does honour the flag -- it compiles, writes the dumps,
    prints "COMPILE_ONLY=1, compilation succeeded" and returns None *before*
    engine init and dispatch.  But `flyc.compile` is not `__call__`; it is
    `_compile_impl`, which calls `jf(*args)` for the compile, **ignores that it
    returned None**, then builds a `CallState` and returns a `CompiledFunction`
    wrapping it.  There is no COMPILE_ONLY branch anywhere in `_compile_impl`.

    So the kernel's `_nt_launch` reaches this line:

        fn = flyc.compile(_launch_grouped_gemm_bf16_nt, *args)
        if fn is None:  # COMPILE_ONLY: nothing was executed, nothing to cache
            return None
        _NT_COMPILED[key] = fn
        return fn(*args)          # <-- a REAL dispatch, under COMPILE_ONLY=1

    ...takes the non-None path, and launches.  The comment on that branch states
    an invariant this flydsl build does not provide.

    This was not reasoned out in advance, it was caught: the first gate run
    tripped `assert_nothing_launched` below, which is the third of the three
    locks the module docstring describes and the only one that held.  The launch
    that got through was harmless only because `make_operands` allocates at the
    true shape, so the grid matched the operands (docs/09 s9.11 -- the shrunken-
    operand version of this is the one that wedges the card).

    The fix is here in the gate rather than in the kernel on purpose: the kernel
    is the thing under test and must stay byte-identical to what ships.  The
    wrapper performs the compile through the path that *does* honour the flag,
    discards nothing (the dumps are written by `jf(*args)`), never constructs a
    `CallState`, and returns None so `_nt_launch` takes its early-out.
    """
    real = K.flyc.compile

    def compile_only(func, *args):
        func(*args)  # JitFunction.__call__: compiles + dumps, returns None, no dispatch
        return None

    compile_only._real = real  # noqa: SLF001
    K.flyc.compile = compile_only
    return (f"patched {real!r} -> compile-only wrapper; `flyc.compile` returns a live "
            f"callable under COMPILE_ONLY on this flydsl build")


def assert_nothing_launched(K, where: str) -> None:
    """`_NT_COMPILED` non-empty means `flyc.compile` returned a callable.

    With `enforce_compile_only` installed it returns None and the launcher caches
    nothing, so a non-empty cache is proof that a launch happened and the patch
    did not take. Abort immediately rather than keep going.

    This check is what caught the COMPILE_ONLY hole documented above. Do not
    relax it.
    """
    for attr in ("_NT_COMPILED", "_VK_COMPILED"):
        cache = getattr(K, attr, None)
        if cache:
            sys.exit(
                f"\n!! {attr} has {len(cache)} entries after {where}.\n"
                "   That cache is only written when flyc.compile() returns a callable, which it\n"
                "   does only when it LAUNCHED. COMPILE_ONLY did not take. Stop and investigate\n"
                "   before running anything else -- docs/09 section 9.11.\n"
            )


def make_operands(pas: str, G: int, N_fwd: int, K_fwd: int, avg_m: int) -> dict:
    """Operands at the TRUE shape.

    docs/09 section 9.11: never shrink an operand for a compile-only dump. The
    grid is still computed from the real M, so a shrunken operand emits
    out-of-range workgroups, and `gpu_recovery` read 0 on this box means a device
    fault is a reboot. Compiling is cheap; the shortcut is not.
    """
    dev = "cuda"
    torch.manual_seed(0)
    M = G * avg_m
    lens = torch.full((G,), avg_m, dtype=torch.int64, device=dev)
    offs = torch.cat([torch.zeros(1, dtype=torch.int64, device=dev), lens.cumsum(0)])
    w = torch.randn(G, N_fwd, K_fwd, dtype=torch.bfloat16, device=dev)
    if pas == "nt":
        a = torch.randn(M, K_fwd, dtype=torch.bfloat16, device=dev)
        out = torch.empty(M, N_fwd, dtype=torch.bfloat16, device=dev)
        n_out, k_red = N_fwd, K_fwd
    else:
        a = torch.randn(M, N_fwd, dtype=torch.bfloat16, device=dev)
        out = torch.empty(M, K_fwd, dtype=torch.bfloat16, device=dev)
        n_out, k_red = K_fwd, N_fwd
    return dict(pas=pas, a=a, w=w, offs=offs, out=out, G=G, avg_m=avg_m, M=M,
                n_out=n_out, k_red=k_red)


def compile_one(K, op: dict, kwargs: dict, dump_dir: Path) -> tuple[str, str]:
    """Compile one variant into its own dump directory; return (asm_text, path).

    Each (variant, shape) gets its own directory because flydsl names the dump
    after the *kernel*, which is the same string for every variant -- one shared
    directory and the last compile silently overwrites the evidence for all the
    others.
    """
    if dump_dir.exists():
        shutil.rmtree(dump_dir, ignore_errors=True)
    dump_dir.mkdir(parents=True, exist_ok=True)
    os.environ["FLYDSL_DUMP_DIR"] = str(dump_dir)

    t0 = time.time() - 1.0
    if op["pas"] == "nt":
        tile_m = K._pick_config(op["n_out"], op["k_red"], op["avg_m"], op["G"])[0]
        fn = K.grouped_gemm_bf16_nt_flydsl_kernel
    else:
        tile_m = K._pick_config_nn(op["n_out"], op["k_red"], op["avg_m"], op["G"])[0]
        fn = K.grouped_gemm_bf16_nn_flydsl_kernel
    mt = K.build_m_tile_map(op["offs"], tile_m)
    fn(op["a"], op["w"], op["offs"], out=op["out"], m_tiles=mt, **kwargs)
    assert_nothing_launched(K, f"compiling {dump_dir.name}")

    files = sorted(glob.glob(str(dump_dir / "**" / "*.s"), recursive=True), key=os.path.getmtime)
    if not files:
        # flydsl may have latched FLYDSL_DUMP_DIR at import time. Anything the
        # compile just dropped in the root belongs to this variant; move it in so
        # the next variant cannot overwrite it.
        stray = [f for f in glob.glob(os.path.join(DUMP_ROOT, "**", "*.s"), recursive=True)
                 if os.path.getmtime(f) >= t0 and not f.startswith(str(dump_dir))]
        for f in stray:
            dest = dump_dir / Path(f).parent.name
            dest.mkdir(parents=True, exist_ok=True)
            shutil.move(f, dest / Path(f).name)
        files = sorted(glob.glob(str(dump_dir / "**" / "*.s"), recursive=True),
                       key=os.path.getmtime)
    if not files:
        raise FileNotFoundError(
            f"no .s under {dump_dir} (nor newly written under {DUMP_ROOT}). "
            f"FLYDSL_DEBUG_DUMP_ASM / FLYDSL_DUMP_DIR did not produce a dump."
        )
    return open(files[-1]).read(), files[-1]


def require_knobs(fn, kernel_path: str) -> None:
    """Same named-parameter check as hk_ab.require_knobs; see its docstring."""
    hk_ab.require_knobs(fn, KNOBS, kernel_path)


# ---------------------------------------------------------------------------
def judge(meta: dict, mn: collections.Counter, budget: int, spill_fail: int,
          strict: bool) -> tuple[str, list[str]]:
    if "vgpr_count" not in meta:
        return "ERROR", ["`.vgpr_count` not found in the dump -- the .s was parsed but has no "
                         "amdhsa.kernels metadata block; nothing can be judged from it"]
    vs = meta.get("vgpr_spill_count", 0)
    ss = meta.get("sgpr_spill_count", 0)
    scratch = meta.get("private_segment_fixed_size", 0)
    vgpr = meta["vgpr_count"]
    spill = vs + ss
    reasons: list[str] = []
    fail = False
    watch = False

    if vgpr > budget:
        fail = True
        reasons.append(f"vgpr {vgpr} > budget {budget}")
    if strict:
        if spill or scratch or mn["scratch_store"] or mn["scratch_load"]:
            fail = True
            reasons.append(f"--strict-spill: spill {vs}/{ss}, scratch {scratch} B, "
                           f"{mn['scratch_store']} st / {mn['scratch_load']} ld")
    elif spill > spill_fail:
        fail = True
        reasons.append(f"big spill {vs}v+{ss}s = {spill} > {spill_fail}")
    elif spill or scratch or mn["scratch_store"] or mn["scratch_load"]:
        watch = True
        reasons.append(f"spill {vs}v+{ss}s, scratch {scratch} B "
                       f"({mn['scratch_store']} st / {mn['scratch_load']} ld) -- look into it, "
                       f"not a verdict (docs/09 s9.4)")
    if fail:
        return "FAIL", reasons
    return ("WATCH" if watch else "PASS"), reasons


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--kernel", default=KERNEL)
    ap.add_argument("--dump-dir", default=DUMP_ROOT,
                    help="root for per-(variant, shape) dump subdirectories")
    ap.add_argument("--variants", nargs="+", default=DEFAULT_VARIANTS,
                    choices=list(VARIANTS), metavar="NAME",
                    help=f"one knob at a time: {' '.join(VARIANTS)}")
    ap.add_argument("--shapes", nargs="*", default=None, metavar="SUBSTR",
                    help="substring filter over the shape tags; default is all six")
    ap.add_argument("--passes", nargs="+", default=["nt"], choices=["nt", "nn"])
    ap.add_argument("--spill-fail", type=int, default=SPILL_FAIL_DEFAULT,
                    help="total spill above this is a FAIL; at or below it is a WATCH "
                         f"(default {SPILL_FAIL_DEFAULT}; docs/09 s9.4)")
    ap.add_argument("--strict-spill", action="store_true",
                    help="any spill or scratch is a FAIL. docs/09 s9.4 records a measured "
                         "counterexample to this rule; off by default for that reason")
    ap.add_argument("--json-out", default=None)
    ap.add_argument("--baseline-kernel", default=None, metavar="PATH",
                    help="a second kernel file -- normally the committed one, e.g. "
                         "`git show HEAD:kernel/...py > /tmp/base.py`. Compiles it with NO knob "
                         "keywords at all and checks its assembly is byte-identical to this "
                         "kernel's control arm. That is what proves an opt-in knob is really "
                         "opt-in: the control is the shipped kernel rather than a re-derivation "
                         "of it. Skips the knob check on the baseline, which by definition does "
                         "not have the knobs.")
    args = ap.parse_args()

    # `_early_arg` already read --dump-dir before flydsl could latch the value; if
    # these disagree the early parse missed the form the user typed, and the dumps
    # would land somewhere the collector is not looking.
    if os.path.abspath(args.dump_dir) != DUMP_ROOT:
        sys.exit(f"!! --dump-dir {args.dump_dir!r} was not seen by the pre-import parse "
                 f"(which used {DUMP_ROOT!r}). Pass it as `--dump-dir PATH`, not through a "
                 f"config file or an abbreviation.")

    variants = list(dict.fromkeys(args.variants))
    shapes = SHAPES
    if args.shapes:
        shapes = [s for s in SHAPES if any(f in shape_tag(s) for f in args.shapes)]
        if not shapes:
            sys.exit(f"!! no shape tag matches {args.shapes}. Known tags:\n  "
                     + "\n  ".join(shape_tag(s) for s in SHAPES))

    K = load(args.kernel, "gg_hk_isa")
    patch_note = enforce_compile_only(K)
    entries = {"nt": K.grouped_gemm_bf16_nt_flydsl_kernel,
               "nn": K.grouped_gemm_bf16_nn_flydsl_kernel}
    for pas in args.passes:
        require_knobs(entries[pas], args.kernel)

    print(f"kernel      : {args.kernel}")
    print(f"device      : {torch.cuda.get_device_properties(0).gcnArchName}")
    print(f"COMPILE_ONLY: {os.environ['COMPILE_ONLY']}   (nothing below is launched)")
    print(f"            : {patch_note}")
    print(f"dump root   : {DUMP_ROOT}")
    print(f"variants    : {variants}")
    print(f"gate        : vgpr <= min({VGPR_FILE} // flat_wg_size, {VGPR_PER_LANE_CAP}); "
          + ("any spill or scratch FAILs (--strict-spill)" if args.strict_spill
             else f"spill > {args.spill_fail} FAILs, 1..{args.spill_fail} WATCHes"))
    print()

    rows = []
    for pas in args.passes:
        for sh in shapes:
            _model, _proj, G, n, k, avg_m = sh
            op = make_operands(pas, G, n, k, avg_m)
            if pas == "nt":
                tile = K._pick_config(op["n_out"], op["k_red"], op["avg_m"], G)
                b_tr = 0
            else:
                tile = K._pick_config_nn(op["n_out"], op["k_red"], op["avg_m"], G)
                b_tr = 1
            arena = lds_arena_bytes(K, tile, b_tr)
            for v in variants:
                tag = f"{pas}.{shape_tag(sh)}.{v}"
                ddir = Path(DUMP_ROOT) / v / f"{pas}.{shape_tag(sh)}"
                row = dict(pas=pas, shape=shape_tag(sh), variant=v, kwargs=dict(VARIANTS[v]),
                           tile=list(tile), lds_arena_calc=arena,
                           wg_per_cu=(LDS_PER_CU // arena) if arena else None)
                try:
                    asm, path = compile_one(K, op, dict(VARIANTS[v]), ddir)
                except Exception as e:  # noqa: BLE001
                    row.update(verdict="ERROR", reasons=[f"{type(e).__name__}: {str(e)[:220]}"])
                    rows.append(row)
                    print(f"  !! {tag}: {type(e).__name__}: {str(e)[:200]}", flush=True)
                    continue
                meta = metadata(asm)
                mn = mnemonics(asm)
                flat = meta.get("max_flat_workgroup_size") or (tile[3] * tile[4] * WAVE)
                budget = min(VGPR_FILE // flat, VGPR_PER_LANE_CAP)
                verdict, reasons = judge(meta, mn, budget, args.spill_fail, args.strict_spill)
                row.update(asm=path, meta=meta, flat_workgroup_size=flat, vgpr_budget=budget,
                           vgpr_margin=budget - meta.get("vgpr_count", 0),
                           mnemonics=dict(mn), ktile=per_ktile(tile, mn), sync=sync_ratios(mn),
                           asm_sha256=hashlib.sha256(asm.encode()).hexdigest(),
                           verdict=verdict, reasons=reasons)
                rows.append(row)
                print(f"  compiled {tag:<62s} -> {verdict}", flush=True)
            del op
            torch.cuda.empty_cache()

    # Did the knob change anything at all? A variant whose assembly is
    # byte-identical to the control's is the control under another name, which is
    # exactly the "silently measuring the control twice" failure -- and here it is
    # provable rather than inferred. The kernel's NN entry has a `**kw` catch-all
    # that drops unknown keywords on the native path, so a knob wired into the
    # signature but not forwarded to the launcher lands precisely here.
    ctl_hash = {(r["pas"], r["shape"]): r.get("asm_sha256")
                for r in rows if r["variant"] == "control"}
    inert = []
    for r in rows:
        h = ctl_hash.get((r["pas"], r["shape"]))
        r["same_asm_as_control"] = bool(h and r.get("asm_sha256") == h)
        if r["variant"] != "control" and r["same_asm_as_control"]:
            inert.append(r)
            r["reasons"] = list(r.get("reasons", [])) + [
                "assembly is byte-identical to the control: this knob changed nothing"]
            r["verdict"] = "INERT"
    print()

    ok = [r for r in rows if "meta" in r]
    if ok:
        print("=" * 150)
        print("REGISTERS / SPILL / LDS   -- the gate. Budget is the docs/09 s9.4 cliff "
              "min(131072 // flat_wg_size, 1024).")
        print("=" * 150)
        hdr = (f"{'variant':<12s} {'pass':<4s} {'shape':<42s} {'flat':>4s} {'vgpr':>5s} "
               f"{'budget':>6s} {'margin':>6s} {'vspl':>5s} {'sspl':>5s} {'scr':>5s} "
               f"{'sgpr':>5s} {'lds(meta)':>9s} {'lds(calc)':>9s} {'WG/CU':>5s} {'verdict':>7s}")
        print(hdr)
        print("-" * len(hdr))
        for r in ok:
            m = r["meta"]
            print(f"{r['variant']:<12s} {r['pas']:<4s} {r['shape']:<42s} "
                  f"{r['flat_workgroup_size']:>4d} {m.get('vgpr_count', -1):>5d} "
                  f"{r['vgpr_budget']:>6d} {r['vgpr_margin']:>6d} "
                  f"{m.get('vgpr_spill_count', -1):>5d} {m.get('sgpr_spill_count', -1):>5d} "
                  f"{m.get('private_segment_fixed_size', -1):>5d} {m.get('sgpr_count', -1):>5d} "
                  f"{m.get('group_segment_fixed_size', -1):>9d} "
                  f"{r['lds_arena_calc'] if r['lds_arena_calc'] else -1:>9d} "
                  f"{r['wg_per_cu'] if r['wg_per_cu'] else -1:>5d} {r['verdict']:>7s}")
        print("\nnote: lds(meta) is `.group_segment_fixed_size`. It reads 0 under a dynamic "
              "SharedAllocator (docs/09 s9.4 trap 2);")
        print("      lds(calc) is the arena recomputed from the tile config and is what WG/CU "
              f"= {LDS_PER_CU} // arena uses.")

        print()
        print("=" * 150)
        print("INSTRUCTION MIX   -- gfx12 spellings; `ds_read_*` returns zero on this part "
              "(docs/09 s9.11)")
        print("=" * 150)
        cols = ["v_wmma", "ds_load_b128", "ds_load_tr16_b128", "ds_store_b128", "s_wait_dscnt",
                "s_wait_tensorcnt", "s_barrier", "s_barrier_signal", "s_barrier_wait",
                "s_setreg", "scratch_store", "scratch_load"]
        hdr2 = f"{'variant':<12s} {'shape':<42s}" + "".join(f" {c[:9]:>9s}" for c in cols) + f" {'instr':>6s}"
        print(hdr2)
        print("-" * len(hdr2))
        for r in ok:
            mnm = r["mnemonics"]
            print(f"{r['variant']:<12s} {r['shape']:<42s}"
                  + "".join(f" {mnm.get(c, 0):>9d}" for c in cols)
                  + f" {mnm.get('_total_instr', 0):>6d}")
        print("\nnote: `s_barrier` counts BARE barriers only and is expected to be 0 -- gpu.barrier()")
        print("      already lowers to a signal/wait pair on gfx1250, so split_bar=1 does NOT change")
        print("      the s_barrier_signal / s_barrier_wait columns. Read `same asm as control` for it.")
        print("      `s_setreg` is where lock_simd (SCHED_MODE bit 2) and wmma_b2b (bit 4) both land;")
        print("      the column cannot tell the two bits apart, only that a setreg appeared.")

        print()
        print("=" * 150)
        print("OPERAND-PIPELINE DRAINS PER K-TILE   -- the sched_style=1 hypothesis is that the "
              "per-sub-step sched_barrier(0)")
        print("fences drain the operand pipeline less often than the fine-grained "
              "sched_dsrd / sched_mfma group-barrier interleave.")
        print("=" * 150)
        hdr3 = (f"{'variant':<12s} {'shape':<42s} {'K_WS':>5s} {'n_acc':>6s} {'bodies':>6s} "
                f"{'dscnt':>6s} {'/K-tile':>8s} {'/sub-step':>10s} {'sync/wmma narrow':>17s} "
                f"{'wide':>7s}")
        print(hdr3)
        print("-" * len(hdr3))
        for r in ok:
            kt, sy = r["ktile"], r["sync"]
            pk = f"{kt['dscnt_per_ktile']:.2f}" if kt["dscnt_per_ktile"] is not None else "n/a"
            ps = f"{kt['dscnt_per_substep']:.2f}" if kt["dscnt_per_substep"] is not None else "n/a"
            print(f"{r['variant']:<12s} {r['shape']:<42s} {kt['k_ws']:>5d} {kt['n_acc']:>6d} "
                  f"{kt['bodies'] if kt['bodies'] else -1:>6d} "
                  f"{r['mnemonics']['s_wait_dscnt']:>6d} {pk:>8s} {ps:>10s} "
                  f"{sy['ratio_narrow']:>17.3f} {sy['ratio_wide']:>7.3f}")
        print("\nbodies = v_wmma / (n_acc * K_WS): how many compute bodies the compiler emitted "
              "(2 in the production config).")
        print("'n/a' means the WMMA count is not an integer multiple of one body, so the "
              "per-K-tile figure is not derivable and is not guessed.")

        print()
        print("PER-VARIANT s_wait_dscnt PER K-TILE (mean over the shapes that compiled)")
        for v in variants:
            vals = [r["ktile"]["dscnt_per_ktile"] for r in ok
                    if r["variant"] == v and r["ktile"]["dscnt_per_ktile"] is not None]
            base = [r["ktile"]["dscnt_per_ktile"] for r in ok
                    if r["variant"] == "control" and r["ktile"]["dscnt_per_ktile"] is not None]
            if not vals:
                print(f"  {v:<12s} not derivable")
                continue
            mean = sum(vals) / len(vals)
            rel = (f"  ({mean / (sum(base) / len(base)):.3f}x control)"
                   if base and v != "control" else "")
            print(f"  {v:<12s} {mean:.2f} over {len(vals)} shape(s){rel}")

    # Is the control arm the shipped kernel, or a re-derivation of it that happens
    # to be spelled with the same defaults? Only a byte comparison against the
    # committed file answers that, and it is the premise every ratio in
    # `hk_ab.py` rests on -- a control arm that is not the shipped code makes the
    # whole campaign measure something nobody ships.
    baseline = []
    if args.baseline_kernel:
        print("=" * 150)
        print(f"BASELINE IDENTITY -- {args.baseline_kernel} compiled with NO knob keywords, "
              "against this kernel's control arm")
        print("=" * 150)
        B = load(args.baseline_kernel, "gg_hk_isa_base")
        enforce_compile_only(B)
        ctl_by_shape = {(r["pas"], r["shape"]): r.get("asm_sha256")
                        for r in rows if r["variant"] == "control"}
        hdr4 = f"{'pass':<5s} {'shape':<42s} {'baseline':<18s} {'control':<18s} {'identical':>9s}"
        print(hdr4)
        print("-" * len(hdr4))
        for pas in args.passes:
            for sh in shapes:
                _model, _proj, G, n, k, avg_m = sh
                op = make_operands(pas, G, n, k, avg_m)
                tag = shape_tag(sh)
                try:
                    asm, _p = compile_one(
                        B, op, {}, Path(DUMP_ROOT) / "_baseline" / f"{pas}.{tag}")
                    assert_nothing_launched(B, f"baseline {tag}")
                    bh = hashlib.sha256(asm.encode()).hexdigest()
                except Exception as e:  # noqa: BLE001
                    bh = f"ERROR:{type(e).__name__}"
                ch = ctl_by_shape.get((pas, tag))
                same = bool(ch and bh == ch)
                print(f"{pas:<5s} {tag:<42s} {bh[:16]:<18s} {(ch or 'n/a')[:16]:<18s} "
                      f"{str(same):>9s}")
                baseline.append(dict(pas=pas, shape=tag, baseline_sha256=bh,
                                     control_sha256=ch, identical=same))
                del op
            torch.cuda.empty_cache()
        n_diff = sum(1 for b in baseline if not b["identical"])
        if n_diff:
            print(f"\n!! {n_diff} shape(s) DIFFER. The knobs are not opt-in: adding them changed "
                  "the code that ships at")
            print("!! default settings, so the control arm is not the shipped kernel and no ratio "
                  "below means what it says.")
        else:
            print(f"\nall {len(baseline)} shape(s) byte-identical: the knobs are genuinely "
                  "opt-in, and the control arm is the shipped kernel.")
        print()

    n_fail = sum(1 for r in rows if r["verdict"] == "FAIL")
    n_watch = sum(1 for r in rows if r["verdict"] == "WATCH")
    n_err = sum(1 for r in rows if r["verdict"] == "ERROR")
    n_inert = sum(1 for r in rows if r["verdict"] == "INERT")
    n_pass = sum(1 for r in rows if r["verdict"] == "PASS")
    print(f"GATE: {n_pass} PASS / {n_watch} WATCH / {n_fail} FAIL / {n_inert} INERT / "
          f"{n_err} ERROR out of {len(rows)}")
    for r in rows:
        if r["verdict"] != "PASS":
            print(f"  {r['verdict']:<6s} {r['pas']}.{r['shape']}.{r['variant']}: "
                  + "; ".join(r["reasons"]))
    if inert:
        print(f"\n!! {len(inert)} variant(s) produced assembly byte-identical to the control.")
        print("!! Those knobs are not reaching the launcher -- benching them would measure the "
              "control twice and")
        print("!! report the result as 1.0000x. Fix the plumbing before running hk_ab.py.")
    print("\nA PASS here is permission to spend bench time, nothing more. docs/09 s9.8 records "
          "three candidates whose")
    print("compile gate and microbenchmark were both clean and whose end-to-end number was "
          "negative, one of them by 53.8%.")
    if n_watch:
        print("A WATCH is a thing to look into, not a rejection: docs/09 s9.4 has a version with "
              "3 spills running 5.3% FASTER")
        print("than the version with zero.")

    if args.json_out:
        out = Path(args.json_out)
        out.parent.mkdir(parents=True, exist_ok=True)
        json.dump(dict(
            kernel=args.kernel, dump_root=DUMP_ROOT, control=CONTROL,
            variants={v: VARIANTS[v] for v in variants},
            gate=dict(vgpr_file=VGPR_FILE, vgpr_per_lane_cap=VGPR_PER_LANE_CAP,
                      lds_per_cu=LDS_PER_CU, spill_fail=args.spill_fail,
                      strict_spill=args.strict_spill),
            rows=rows, baseline_identity=baseline,
            summary=dict(PASS=n_pass, WATCH=n_watch, FAIL=n_fail, INERT=n_inert, ERROR=n_err),
        ), open(out, "w"), indent=1, default=str)
        print(f"\nwrote {out}")
    return 1 if (n_fail or n_err or n_inert) else 0


if __name__ == "__main__":
    sys.exit(main())
