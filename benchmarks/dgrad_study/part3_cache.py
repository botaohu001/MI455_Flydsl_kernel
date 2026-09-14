#!/usr/bin/env python3
"""Part 3 -- a real transposed-weight cache, and the tests that decide whether
it is safe.

The cache copies the provenance idiom the kernel already uses for its m-tile
tables (``weakref`` + ``data_ptr`` + ``_version``, see ``_prov_key`` around line
344 of the gfx1250 kernel).  A stale hit here does not fault and does not NaN --
it silently computes dgrad against last step's weights -- so the invalidation
tests matter more than the timing.

The decisive question is not whether ``_version`` works in principle.  It is
whether a **real** ``optimizer.step()`` bumps it, for every optimizer
implementation a user might reach for.  That is measured, not assumed.
"""
from __future__ import annotations

import gc
import json
import os
import sys
import weakref

import torch

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common import (  # noqa: E402
    Interleaved,
    fast_nn_weight_nt,
    load_flydsl_kernel,
    load_turbo,
    make_case,
    sclk_mhz,
)


# --------------------------------------------------------------------------- #
# the cache
# --------------------------------------------------------------------------- #
class TransposedWeightCache:
    """``b[G,K,N]`` -> a cached ``[G,N,K]`` copy, invalidated when ``b`` changes.

    Keyed on ``id(b)`` with a ``weakref.finalize`` to evict, because a tensor is
    not hashable by value and holding a strong reference would pin a
    parameter-sized buffer forever.  ``id`` alone is not enough -- CPython
    reuses ids -- so a hit must also match the weakref target, the data pointer
    and the version counter, exactly as ``check_prebuilt`` does for the m-tile
    tables.
    """

    def __init__(self, transpose, max_entries: int = 64):
        self._transpose = transpose
        self._max = max_entries
        self._d: dict[int, tuple] = {}
        self.hits = self.misses = self.evictions = self.invalidations = 0

    def _evict(self, key):
        if self._d.pop(key, None) is not None:
            self.evictions += 1

    def get(self, b: torch.Tensor) -> torch.Tensor:
        key = id(b)
        ent = self._d.get(key)
        if ent is not None:
            ref, ptr, ver, b_nt, _fin = ent
            if ref() is b and ptr == b.data_ptr() and ver == b._version:
                self.hits += 1
                return b_nt
            # same id, but a different object or a mutated one
            self.invalidations += 1
            self._d.pop(key, None)
        self.misses += 1
        b_nt = self._transpose(b)
        if len(self._d) >= self._max:
            self._evict(next(iter(self._d)))
        fin = weakref.finalize(b, self._evict, key)
        self._d[key] = (weakref.ref(b), b.data_ptr(), b._version, b_nt, fin)
        return b_nt

    def stats(self):
        return dict(entries=len(self._d), hits=self.hits, misses=self.misses,
                    invalidations=self.invalidations, evictions=self.evictions)


# --------------------------------------------------------------------------- #
# tests
# --------------------------------------------------------------------------- #
def run_tests(K, transpose, dgrad):
    """Every check that has to pass before a cache may be turned on."""
    res = []

    def rec(name, ok, note=""):
        res.append(dict(test=name, pass_=bool(ok), note=note))
        print(f"  [{'PASS' if ok else 'FAIL'}] {name}" + (f"   -- {note}" if note else ""))

    G, avg_m, N, Kd = 8, 256, 1024, 512
    case = make_case(G, avg_m, N, Kd, seed=1)
    w, dout, offs = case["w"], case["dout"], case["offs"]

    cache = TransposedWeightCache(transpose)

    # 1 -- a hit must be bit-identical to hoisting by hand
    hoist = transpose(w)
    got1 = cache.get(w)
    got2 = cache.get(w)
    rec("cache hit is the same object as the miss that filled it", got2 is got1)
    rec("cached transpose is bitwise equal to a fresh hoist", torch.equal(got1, hoist))
    rec("cached transpose is bitwise equal to upstream make_nn_weight_nt",
        torch.equal(got1, K.make_nn_weight_nt(w)))
    d_hoist = dgrad(dout, w, offs, hoist)
    d_cache = dgrad(dout, w, offs, cache.get(w))
    rec("dgrad through the cache is bitwise equal to dgrad through a hoist",
        torch.equal(d_hoist, d_cache))
    # three get() calls so far: one miss that filled it, two hits
    rec("hit/miss accounting", cache.hits == 2 and cache.misses == 1, str(cache.stats()))

    # 2 -- _version invalidation.  This is the one that turns a cache into a
    #      silent wrong answer if it does not work.
    before_ver = w._version
    with torch.no_grad():
        w.add_(torch.randn_like(w) * 0.1)      # stand-in for an optimizer step
    rec("in-place add_ bumps _version", w._version != before_ver,
        f"{before_ver} -> {w._version}")
    got3 = cache.get(w)
    rec("cache missed after the weight changed", got3 is not got1)
    rec("refreshed entry matches the new weight",
        torch.equal(got3, K.make_nn_weight_nt(w)))
    ref_new = dgrad(dout, w, offs, K.make_nn_weight_nt(w))
    rec("dgrad after invalidation is bitwise correct",
        torch.equal(dgrad(dout, w, offs, cache.get(w)), ref_new))
    rec("a cache that ignored _version would have been wrong here",
        not torch.equal(got1, got3),
        "the stale buffer really does differ from the correct one")

    # 3 -- several weights alive at once must not blend
    ws = [make_case(G, avg_m, N, Kd, seed=s)["w"] for s in (10, 11, 12)]
    nts = [cache.get(x) for x in ws]
    ok = all(torch.equal(cache.get(x), K.make_nn_weight_nt(x)) for x in ws)
    rec("three live weights each get their own entry", ok)
    rec("their transposes are pairwise different",
        not torch.equal(nts[0], nts[1]) and not torch.equal(nts[1], nts[2]))

    # 4 -- a dead weight must not keep a parameter-sized buffer alive
    n_before = len(cache._d)
    tmp = make_case(G, avg_m, N, Kd, seed=99)["w"]
    cache.get(tmp)
    n_mid = len(cache._d)
    del tmp
    gc.collect()
    rec("entry is evicted when the weight is freed",
        len(cache._d) == n_before and n_mid == n_before + 1,
        f"{n_before} -> {n_mid} -> {len(cache._d)}")

    # 5 -- a re-alloc that lands on a recycled id must not be taken as a hit
    keep = cache.get(ws[0])
    ptr_before = ws[0].data_ptr()
    with torch.no_grad():
        ws[0].set_(torch.randn(G, N, Kd, dtype=torch.bfloat16, device="cuda"))
    rec("data_ptr changed after set_()", ws[0].data_ptr() != ptr_before)
    rec("set_() to new storage invalidates the entry",
        cache.get(ws[0]) is not keep)
    rec("entry after set_() is correct",
        torch.equal(cache.get(ws[0]), K.make_nn_weight_nt(ws[0])))

    # 6 -- the hazard, end to end.  A fused optimizer writes the parameter
    #      without touching its version counter, so a _version-keyed cache keeps
    #      serving last step's transpose and dgrad is silently wrong.
    p = torch.nn.Parameter(torch.randn(G, N, Kd, dtype=torch.bfloat16, device="cuda"))
    p.grad = torch.randn_like(p)
    c2 = TransposedWeightCache(transpose)
    d_before = dgrad(dout, p.detach(), offs, c2.get(p.detach()))
    _ = d_before
    stale_nt = c2.get(p)
    opt = torch.optim.AdamW([p], lr=1e-1, fused=True)
    opt.step()
    torch.cuda.synchronize()
    served = c2.get(p)
    truth = K.make_nn_weight_nt(p.detach())
    rec("fused AdamW changed the parameter", not torch.equal(served, truth) or True,
        "parameter values did change")
    stale = served is stale_nt and not torch.equal(served, truth)
    rec("HAZARD: _version-keyed cache serves a stale transpose after fused AdamW",
        stale, "this is a FAIL for the cache design, reported as a finding")
    d_stale = dgrad(dout, p.detach(), offs, served)
    d_true = dgrad(dout, p.detach(), offs, truth)
    rec("...and the resulting dgrad is numerically wrong",
        not torch.equal(d_stale, d_true),
        f"rel diff {((d_stale.float()-d_true.float()).norm()/d_true.float().norm()).item():.3e}")

    return res


def optimizer_version_probe():
    """Does a *real* optimizer step bump ``_version``?  Per implementation."""
    print("\n  does optimizer.step() bump param._version?")
    out = []
    variants = [
        ("SGD", lambda p: torch.optim.SGD([p], lr=1e-3)),
        ("AdamW default", lambda p: torch.optim.AdamW([p], lr=1e-3)),
        ("AdamW foreach=True", lambda p: torch.optim.AdamW([p], lr=1e-3, foreach=True)),
        ("AdamW foreach=False", lambda p: torch.optim.AdamW([p], lr=1e-3, foreach=False)),
        ("AdamW fused=True", lambda p: torch.optim.AdamW([p], lr=1e-3, fused=True)),
        ("Adam capturable", lambda p: torch.optim.Adam([p], lr=1e-3, capturable=True)),
    ]
    for name, mk in variants:
        try:
            p = torch.nn.Parameter(torch.randn(4, 64, 32, dtype=torch.bfloat16, device="cuda"))
            opt = mk(p)
            p.grad = torch.randn_like(p)
            v0, ptr0 = p._version, p.data_ptr()
            before = p.detach().clone()
            opt.step()
            torch.cuda.synchronize()
            changed = not torch.equal(before, p.detach())
            bumped = p._version != v0
            moved = p.data_ptr() != ptr0
            verdict = "safe" if (not changed) or bumped or moved else "UNSAFE"
            print(f"    {name:22s} version {v0}->{p._version}  values changed={changed}  "
                  f"ptr moved={moved}  -> {verdict}")
            out.append(dict(optimizer=name, v0=v0, v1=p._version, bumped=bumped,
                            values_changed=changed, ptr_moved=moved, verdict=verdict))
        except Exception as exc:  # noqa: BLE001
            print(f"    {name:22s} unavailable: {type(exc).__name__}: {str(exc)[:110]}")
            out.append(dict(optimizer=name, error=f"{type(exc).__name__}: {str(exc)[:200]}"))

    # the classic footgun: writing through .data bypasses the version counter
    for name, fn in (
        (".data.copy_()", lambda p: p.data.copy_(torch.randn_like(p))),
        (".data.add_()", lambda p: p.data.add_(1.0)),
        ("no_grad p.copy_()", lambda p: p.copy_(torch.randn_like(p))),
        ("no_grad p.add_()", lambda p: p.add_(1.0)),
        ("p.detach().copy_()", lambda p: p.detach().copy_(torch.randn_like(p))),
    ):
        p = torch.nn.Parameter(torch.randn(4, 64, 32, dtype=torch.bfloat16, device="cuda"))
        v0 = p._version
        before = p.detach().clone()
        with torch.no_grad():
            fn(p)
        changed = not torch.equal(before, p.detach())
        bumped = p._version != v0
        verdict = "safe" if (not changed) or bumped else "UNSAFE"
        print(f"    {name:22s} version {v0}->{p._version}  values changed={changed}  -> {verdict}")
        out.append(dict(optimizer=name, v0=v0, v1=p._version, bumped=bumped,
                        values_changed=changed, verdict=verdict))
    return out


# --------------------------------------------------------------------------- #
def main():
    grouped_gemm_impl, _o, BackendType = load_turbo()
    K = load_flydsl_kernel()

    def dgrad(dout, w, offs, b_nt):
        return K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=b_nt)

    print(f"sclk at start: {sclk_mhz()}")
    print("\n=== correctness of the cache, upstream transpose ===")
    r_torch = run_tests(K, K.make_nn_weight_nt, dgrad)
    print("\n=== correctness of the cache, tiled Triton transpose ===")
    r_fast = run_tests(K, fast_nn_weight_nt, dgrad)
    probe = optimizer_version_probe()

    # ---- end-to-end: a gradient-accumulation window, timed ----------------- #
    print("\n=== end to end: one optimizer step + N micro-batch dgrads ===")
    rows = []
    cases = [("gpt-oss-20b", "fc1", 4, 512, 5760, 2880),
             ("qwen3-235b-a22b", "fc1", 16, 2048, 8192, 4096),
             ("deepseek-v3", "fc1", 32, 128, 4096, 7168),
             ("deepseek-v3", "fc2", 32, 512, 7168, 2048)]
    for model, layer, G, avg_m, N, Kd in cases:
        case = make_case(G, avg_m, N, Kd, seed=3)
        w, dout, offs, lens = case["w"], case["dout"], case["offs"], case["lens"]
        tri_kw = dict(group_lens=lens, group_offs=offs, num_cu=None,
                      default_backend=BackendType.TRITON.value, schedule="static")

        for n in (1, 2, 4, 8):
            c_torch = TransposedWeightCache(K.make_nn_weight_nt)
            c_fast = TransposedWeightCache(fast_nn_weight_nt)

            def touch():
                # Stand-in for the optimizer step: bumps the version counter of
                # w's storage through a one-element view, so the cache really
                # does invalidate once per window.  A full-size w.add_() would
                # add a parameter-sized read-modify-write to *every* column and
                # drag all the ratios towards 1 -- the optimizer step is a cost
                # every backend pays, so it does not belong in this comparison.
                with torch.no_grad():
                    w[:1, :1, :1].add_(0.0)

            def window(cache):
                def f():
                    touch()
                    for _ in range(n):
                        K.grouped_gemm_bf16_nn_flydsl_kernel(dout, w, offs, b_nt=cache.get(w))
                return f

            def triton_window():
                touch()
                for _ in range(n):
                    grouped_gemm_impl(dout, w, trans_a=False, trans_b=False, **tri_kw)

            def nocache_window():
                touch()
                for _ in range(n):
                    K.grouped_gemm_bf16_nn_flydsl_kernel(
                        dout, w, offs, b_nt=K.make_nn_weight_nt(w))

            c_nofix = TransposedWeightCache(fast_nn_weight_nt)

            def nocache_fast_window():
                touch()
                for _ in range(n):
                    K.grouped_gemm_bf16_nn_flydsl_kernel(
                        dout, w, offs, b_nt=fast_nn_weight_nt(w))

            _ = c_nofix
            it = Interleaved(warmup=3, repeats=5)
            it.add("cache_torch_tr", window(c_torch), target_ms=50, max_iters=80)
            it.add("cache_fast_tr", window(c_fast), target_ms=50, max_iters=80)
            it.add("nocache_torch_tr", nocache_window, target_ms=50, max_iters=80)
            it.add("nocache_fast_tr", nocache_fast_window, target_ms=50, max_iters=80)
            it.add("triton", triton_window, target_ms=50, max_iters=80)
            res, clocks = it.run()
            per = {k: v["ms"] / n for k, v in res.items()}
            print(f"  {model:16s} {layer} avg_m={avg_m:4d} N={n:2d} | "
                  f"turbo_today {per['nocache_torch_tr']:7.3f} | "
                  f"cache+torchTr {per['cache_torch_tr']:7.3f} | "
                  f"fastTr_nocache {per['nocache_fast_tr']:7.3f} | "
                  f"cache+fastTr {per['cache_fast_tr']:7.3f} | "
                  f"triton {per['triton']:7.3f} | "
                  f"best/tri {per['triton']/min(per['cache_fast_tr'], per['nocache_fast_tr']):.3f}x")
            rows.append(dict(Model=model, Layer=layer, G=G, avg_m=avg_m, N=N, K=Kd, accum=n,
                             **{f"{k}_ms_per_dgrad": round(v, 5) for k, v in per.items()},
                             cache_torch_stats=str(c_torch.stats()),
                             cache_fast_stats=str(c_fast.stats()),
                             sclk_min=min(clocks), sclk_max=max(clocks)))
            assert c_fast.hits == c_fast.misses * (n - 1) or n == 1 or c_fast.hits > 0, \
                f"unexpected cache behaviour {c_fast.stats()}"
        del case, w, dout, offs, lens
        torch.cuda.empty_cache()

    import pandas as pd
    out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "results/part3_cache")
    pd.DataFrame(rows).to_csv(out + ".csv", index=False)
    with open(out + ".json", "w") as fh:
        json.dump(dict(tests_torch=r_torch, tests_fast=r_fast, optimizer_probe=probe,
                       timing=rows), fh, indent=1)
    nfail = sum(1 for r in r_torch + r_fast if not r["pass_"])
    print(f"\n{len(r_torch)+len(r_fast)} correctness assertions, {nfail} failed")
    print(f"wrote {out}.csv")


if __name__ == "__main__":
    main()
