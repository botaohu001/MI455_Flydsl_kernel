# 2. The dgrad transpose problem, end to end

This is the central problem of the whole port. It is worth following the chain
in order, because three of the obvious escapes are dead ends and knowing *why*
they are dead is most of the value.

---

## 2.1 The chain

**Step 1 — WMMA wants both operands contiguous along the reduction axis.**

`v_wmma_f32_16x16x32_bf16` takes A as 16×32 and B as 32×16. The fragment loader
gathers 8 consecutive 16-bit elements per lane *along the reduction*. If the
reduction axis is strided in memory, the fragment cannot be assembled with a
plain `ds_read_b128`.

**Step 2 — dgrad's reduction axis is the weight's strided axis.**

Line up all three passes using the NN entry's own convention,
`out[m,n] = Σ_k a[m,k] · b[g][k,n]`:

| pass | operand | memory shape | where the reduction axis sits | loader needed |
|---|---|---|---|---|
| fwd (NT) | `a[M,K]` | rows = m, cols = k | column — **contiguous** | `ds_read_b128` |
| fwd (NT) | `b_nt[G,N,K]` | rows = n, cols = k | column — **contiguous** | `ds_read_b128` |
| **dgrad (NN)** | `a[M,K]` | rows = m, cols = k | column — **contiguous** | `ds_read_b128` |
| **dgrad (NN)** | `b[G,K,N]` | rows = k, cols = n | **row — strided** | transpose read |
| wgrad | `A[M,OUT_M]` | rows = m, cols = i | **row — strided** | transpose read |
| wgrad | `B[M,OUT_N]` | rows = m, cols = j | **row — strided** | transpose read |

dgrad is the only pass with a **mixed** operand pair: one contiguous, one
strided. That mix is the whole problem.

**Step 3 — gfx950 solves this in hardware, wired into its NN pipeline.**

Its `gemm_bf16_nn_tile` flips one boolean, `a_transpose`, which swaps the
S2R loader between `S2RLoader16x16Bf16` (plain) and `S2RLoaderTr16x32Bf16Wide`
(a packed block of `ds_read_b64_tr_b16` inline asm). Same tile body, one loader
swapped. Its NN kernel therefore consumes `b[G,K,N]` natively.

**Step 4 — gfx1250 has the equivalent instruction, wired into the wrong pass.**

`ds_load_tr16_b128` exists, encodes, and is exercised on real hardware every
time the wgrad kernel runs — *both* of wgrad's operands go through it. It was
simply never connected to an NN pipeline, on the reasoning (recorded in the
upstream notes) that doing so meant "a third full kernel body written with no
hardware to check it against."

**Step 5 — so dgrad was the NT kernel fed a transposed weight.**

```python
b_nt = make_nn_weight_nt(b)       # b.transpose(1,2).contiguous()
da   = grouped_gemm_bf16_nn_flydsl_kernel(dout, b, offs, b_nt=b_nt)
```

Pure algebra, zero new kernel code, and somebody has to pay for the transpose.

**Step 6 — the cost is not a rounding error.**

**[MEASURED]** with the upstream helper, per call:

| shape | weight | transpose | the GEMM itself | ratio |
|---|--:|--:|--:|--:|
| deepseek-v3 fc1, avg_m=128 | 1.88 GB | **2.95 ms** | 0.296 ms | **10.0×** |
| deepseek-v3 fc2, avg_m=128 | 0.94 GB | 1.66 ms | 0.161 ms | 10.3× |
| qwen3-235b fc1, avg_m=512 | 1.07 GB | 1.55 ms | 0.379 ms | 4.1× |
| gpt-oss fc1, avg_m=512 | 0.13 GB | 0.238 ms | 0.074 ms | 3.2× |

Across the 24-cell matrix the per-call transpose makes dgrad **2.33× to 11.41×
slower** (median 3.87×) than the hoisted calibre, and lands it at **0.32×
Triton** — i.e. three times slower than just calling Triton. The integration
branch gated this path off by default for exactly that reason.

**Step 7 — the fix is to wire wgrad's transpose read onto NN.**

Look again at the table in step 2. **dgrad's B operand and wgrad's operands are
the same shape**: reduction axis on the rows, output axis contiguous on the
columns. The difference is what a row *means* — a token in wgrad, a reduction
index in dgrad — and **that meaning does not appear anywhere in the generated
code**. It is only `LDS_ROW` and a column offset.

So the NN pipeline is the NT pipeline with B's LDS geometry transposed and B's
fragment loader swapped. One boolean, `b_lds_transpose`, on the existing NT
launcher — structurally the same move gfx950 makes with `a_transpose`.

`docs/04-native-nn-pipeline.md` is the implementation.

---

## 2.2 Dead end: make the transpose cheap instead

Before replacing the pipeline, the obvious question is whether the transpose is
slow because transposes are slow, or because *this* transpose is slow.

**It is the helper.** **[MEASURED]**

| implementation | bandwidth | vs `make_nn_weight_nt` |
|---|--:|--:|
| `make_nn_weight_nt` = `b.transpose(1,2).contiguous()` | 1.07–1.39 TB/s | 1.0× |
| a plain `torch` copy of the same bytes, no permutation | 7.05–11.1 TB/s | ~6× |
| **a ~20-line tiled Triton transpose** | **15.5–17.1 TB/s** | **11.0–14.9×** |

MI455X HBM4 peak is ~19.6 TB/s, so the upstream helper runs at **6–7 % of peak**
and the replacement at **~82 %** — faster than torch's *non*-transposing copy.
Bit-exact against `make_nn_weight_nt` on every shape tested. The kernel is in
`benchmarks/bench_transpose.py`; it reads a `BN×BK` tile coalesced along K and
writes it coalesced along N, so both sides move full cache lines. The torch path
only gets one of them.

**This is a real and unconditional win — but it does not make the problem go
away.** Even with the fast transpose, the native NN pipeline is **1.357× faster
per call** (geomean, 24/24 cells, range 1.11–1.91×). The reason is in §2.5.

> **If you take one thing from this section:** before optimising around a slow
> operation, check whether the operation is slow or the *implementation* is. A
> 20-line kernel closed an 11–14× gap that three separate documents had been
> treating as a fixed cost of doing business.

---

## 2.3 Dead end: cache the transposed weight

If the transpose only changes when the weights change, cache it across the
micro-batches of one optimizer step. A prototype was built and it works —
**38 assertions, 0 failures**, covering hit/miss identity, bitwise equality
against a fresh hoist, `_version` refresh, three-live-weights isolation,
eviction on free, and `set_()` invalidation.

**It should not ship.** Four reasons, in descending order of severity.

### It is silently wrong under a fused optimizer

A cache keyed on `param._version` assumes every write to a parameter bumps it.
**[MEASURED]** on torch 2.11.0+rocm7.14:

| how the parameter is written | `_version` bumped? | |
|---|---|---|
| `SGD.step()` | 0→1 | safe |
| `AdamW.step()` (default / `foreach=True` / `foreach=False`) | 0→2 | safe |
| `Adam(capturable=True).step()` | 0→1 | safe |
| **`AdamW(fused=True).step()`** | **0→0** | **UNSAFE** |
| **`p.data.copy_(...)`** | **0→0** | **UNSAFE** |
| **`p.data.add_(...)`** | **0→0** | **UNSAFE** |
| `with no_grad: p.copy_/add_` | 0→1 | safe |
| `p.detach().copy_(...)` | 0→1 | safe |

Demonstrated end to end: after a real `AdamW(fused=True).step()` the cache
serves the previous step's transpose and dgrad comes out at **9.99e-02 relative
error**. No exception, no NaN, gradients that look entirely plausible.

A cache *can* be made safe — invalidate from an
`optimizer.register_step_post_hook` instead of from `_version` — but that is a
framework-level contract a kernel cannot enforce, and it **fails open**.

### It costs a full duplicate of the expert weights

**[MEASURED]** HBM on this part is 463 856 467 968 B = **432.0 GiB / 463.9 GB**.

| model (EP=8) | per MoE layer | all MoE layers | transposed copy | % of HBM |
|---|--:|--:|--:|--:|
| gpt-oss-20b | 189.8 MiB | 4.45 GiB | +4.45 GiB | 1.03 % |
| qwen3-30b-a3b | 384.0 MiB | 18.00 GiB | +18.00 GiB | 4.17 % |
| qwen3-235b-a22b | 1536.0 MiB | 141.00 GiB | **+141.00 GiB** | **32.64 %** |
| deepseek-v3 | 2688.0 MiB | 152.25 GiB | **+152.25 GiB** | **35.24 %** |

For the two large models that takes expert weights from 33–35 % of HBM to
65–70 %, before optimizer state and activations.

### It cannot be made smaller

Backward visits each layer once per micro-batch, so an entry filled at layer *L*
in micro-batch *i* is next hit at layer *L* in micro-batch *i+1* — after every
other layer has been through. **Bounding the cache to fewer entries than there
are layers drives the hit rate to zero.** It is all-or-nothing by construction.

### Once the transpose is fast, it buys almost nothing

With the tiled transpose, **every one of the 24 cells at `avg_m ≥ 1536` has
N\* < 1** (range 0.14–0.92) — the transpose pays for itself *inside a single
call*, so there is nothing left to amortise. Adding the cache lifts the geomean
over 42 cells from 1.099 to 1.171. **That is +7 %, on dgrad only, for 141–152
GiB and a silent-wrong-gradient failure mode.**

(N\* = `t_transpose / (t_triton − t_gemm)`, the number of calls a hoisted
transpose must serve before it beats falling back to Triton.)

The native NN pipeline makes the whole question moot: it reads the current
weights every call, so **there is structurally nothing to invalidate.**

---

## 2.4 Dead end: find an algebraic way out

**There isn't one, and it can be shown rather than argued.**

Write the weight as `W[g]`, logically `[N,K]`:

| pass | reduction axis | `W` stored `[G,N,K]` | `W` stored `[G,K,N]` |
|---|---|---|---|
| fwd `y = x·Wᵀ` | k | k contiguous ✓ | k strided ✗ |
| dgrad `dx = dy·W` | n | n strided ✗ | n contiguous ✓ |

**The two passes need opposite major orders of the same array.** No single
storage layout satisfies both. This is not a limitation of this kernel; it is
why the part has a transpose-read instruction in the first place.

`(AᵀB)ᵀ = BᵀA` does not rescue it. That identity renames which operand is A and
which is B and transposes the *output*; it changes the stride of neither operand
along `n`. It works for wgrad only because there the constraint being dodged is
`trans_c`, which is an **epilogue** property — C is an output and its layout is a
free choice. dgrad's problem is the storage orientation of an **input**.

### The one expressible reformulation, measured rather than argued

For a single group, `da[rows_g] = (dout[rows_g]ᵀ)ᵀ @ w[g]` is exactly one
variable-K call with `G=1`. This transposes the **activations** instead of the
weight, and `dout` is smaller than `w` whenever `avg_m < K` — by up to 56× for
deepseek fc1 at avg_m=128.

It is **numerically correct** — bitwise identical to the NT route in all 8 cells
tested — and **1.5× to 10.5× slower than everything else**:

| shape | variable-K route | NT + hoisted | NT + per-call fast tr | Triton |
|---|--:|--:|--:|--:|
| gpt-oss fc1 avg_m=512 | 0.359 | 0.077 | 0.109 | 0.122 |
| qwen3-30b fc1 avg_m=512 | 1.009 | 0.125 | 0.168 | 0.103 |
| qwen235b fc1 avg_m=2048 | 2.035 | 1.114 | 1.242 | 1.453 |
| deepseek fc1 avg_m=128 | 2.034 | 0.295 | 0.529 | 0.392 |
| deepseek fc2 avg_m=512 | 3.205 | 0.338 | 0.451 | 0.341 |

It pays G serialised launches (4–32), each with only `N` rows of reduction depth,
and drops to the 64×64 fallback tile when `avg_m < 256`. A cheap activation
transpose does not come close to covering that. Dead.

---

## 2.5 A modelling trap worth keeping

The natural cost model for "should I hoist the transpose?" is

```
t_eff(N) = t_gemm + t_transpose / N
```

Checked against directly measured end-to-end `N ∈ {1,2,4,8,16,32}`:

- **With the slow upstream transpose: the model holds.** Median |deviation|
  0.92 %, range −1.23 % to +4.69 % over 144 points.
- **With the fast transpose: it holds for N ≥ 2 and breaks at N = 1**, by up to
  **+35 %**. Expressed per window the miss is a **fixed ~5 µs** that does not
  scale with N — a dependent-launch boundary. It only looks large as a
  percentage because the fast transpose is itself only 11–236 µs.

**N = 1 is exactly the per-call case**, i.e. the model under-predicts the cost
precisely where you are deciding whether you can skip the cache.

This is also why the native NN pipeline's advantage over "flydsl + fast
transpose per call" is **1.357×** rather than the 1–6 % the linear model
predicts. **[MEASURED]** the two cannot overlap: the transpose must write the
entire weight and land it before the GEMM can read it, and what the GEMM then
reads is a cold L2 that the transpose just evicted. For gpt-oss fc1 at
avg_m=512 the transpose increment is 0.0963 − 0.0623 = **0.0340 ms**, i.e.
**7.8 TB/s** — about half its standalone measured bandwidth.

---

## 2.6 Where this left the dispatch decision

Before the native pipeline existed, the recommendation from the study was:

- replace `make_nn_weight_nt` with the tiled transpose, **unconditionally** —
  11–14×, bit-exact, ~20 lines, no memory cost, no new failure mode;
- **do not** add the cache;
- route dgrad to flydsl only for `avg_m ≥ 1536`, where it wins 24/24 with no
  cache at all, and let Triton have the rest.

The threshold was fitted on 42 cells from four models on one part, with 1536
interior to the sampled range 128–4096. **It should be re-measured, not
extrapolated, for a new arch or a new tuning table.**

With the native pipeline, the transpose is gone and the first two points are
moot. The third partly survives: flydsl's *GEMM* still loses to Triton on 4 of
24 dgrad cells, all at small `avg_m`. That is unrelated to the transpose, it
predates this work, and **the cause is still unknown** — see
`docs/05-optimization-log.md` §"Disproven hypotheses".
