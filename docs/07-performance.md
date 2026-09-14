# 7. Performance

Full three-section delivery matrix plus the comparisons that matter. Raw
per-point CSVs are in `results/`.

> **These are absolute throughput figures for pre-release hardware.** Check your
> organisation's disclosure policy before quoting them outside it.

---

## 7.0 Measurement conditions — read before using any number

| | |
|---|---|
| hardware | **1 × AMD MI455X (gfx1250)**, 256 CU, 432.0 GiB / 463.9 GB HBM. Single card; the other cards in the node were idle. Internal pre-release test system. |
| clocks | **not pinned.** `sclk` sampled at every timed point and reported in the tables; it ranged **2010–2331 MHz** across this run. |
| software | torch 2.11.0+rocm7.14, **flydsl 0.2.4**, ROCm 7.x container. No `/opt/rocm`; the toolchain ships as a wheel. |
| timing | `torch.utils.benchmark.Timer`, 6 warmup calls (which also burns the first-call risk), then each sample is a launch loop filling ~40 ms. **Median of 5 samples**, `cv` reported. |
| stability | **all 72 delivery points at cv < 2 %** (max 0.85 % in the dgrad round). No point needed flagging. |
| numerics | fp32 per-group reference, judged host-side in float64. Not device fp64 — see `docs/06-pitfalls.md`. |
| MFU denominator | **5033.2 TF/s** (MI455X spec peak dense bf16). |

**Why clocks are not pinned:** the Triton and hipBLASLt baselines were measured
unpinned, and pinning only one side would invalidate the comparison. What
substitutes for it: competing implementations are measured **in the same
process, interleaved repeat by repeat**, so a clock excursion lands on both.

⚠️ **Do not compare absolute numbers across the three sections below.** fwd and
wgrad were measured in an earlier round than dgrad, at a different clock range
(2106–2304 vs 2186–2331). Those code paths are **bitwise unchanged** (verified
48/48) — the difference is the clock, not the kernel. Within a section, and
within the four-calibre table in §7.4, everything is same-session.

**Shapes** are the MoE fc1 (gate+up) and fc2 (down) projections of four models
at EP=8, i.e. a subset of Primus-Turbo's own case table rather than a new set.
`avg_m` is tokens actually routed to one expert
(`seq · batch · topk / n_routed`).

---

## 7.1 Forward (NT)

| model | proj | G | EP | batch | seq | avg_m | M(total) | N | K | dtype | ms | TF/s | MFU | config | sclk |
|---|---|--:|--:|--:|--:|--:|--:|--:|--:|---|--:|--:|--:|---|--:|
| gpt-oss-20b | fc1 | 4 | 8 | 1 | 4096 | 512 | 2048 | 5760 | 2880 | bf16 | 0.0669 | 1015.5 | 20.2% | BM128/BN128/BK64/mw2/nw2/nb3 | 2237 |
| gpt-oss-20b | fc1 | 4 | 8 | 2 | 4096 | 1024 | 4096 | 5760 | 2880 | bf16 | 0.0957 | 1419.8 | 28.2% | BM256/BN256/BK64/mw2/nw2/nb3 | 2191 |
| gpt-oss-20b | fc1 | 4 | 8 | 4 | 4096 | 2048 | 8192 | 5760 | 2880 | bf16 | 0.1687 | 1611.4 | 32.0% | BM128/BN192/BK64/mw2/nw2/nb3 | 2128 |
| gpt-oss-20b | fc2 | 4 | 8 | 1 | 4096 | 512 | 2048 | 2880 | 2880 | bf16 | 0.0301 | 1128.2 | 22.4% | BM128/BN128/BK64/mw2/nw2/nb3 | 2304 |
| gpt-oss-20b | fc2 | 4 | 8 | 2 | 4096 | 1024 | 4096 | 2880 | 2880 | bf16 | 0.0466 | 1457.3 | 29.0% | BM256/BN256/BK64/mw2/nw2/nb3 | 2268 |
| gpt-oss-20b | fc2 | 4 | 8 | 4 | 4096 | 2048 | 8192 | 2880 | 2880 | bf16 | 0.0823 | 1651.3 | 32.8% | BM128/BN192/BK64/mw2/nw2/nb3 | 2200 |
| qwen3-30b-a3b | fc1 | 16 | 8 | 1 | 8192 | 512 | 8192 | 4096 | 2048 | bf16 | 0.1014 | 1355.2 | 26.9% | BM256/BN256/BK128/mw2/nw2/nb2 | 2203 |
| qwen3-30b-a3b | fc1 | 16 | 8 | 2 | 8192 | 1024 | 16384 | 4096 | 2048 | bf16 | 0.1696 | 1621.0 | 32.2% | BM256/BN256/BK128/mw2/nw2/nb2 | 2141 |
| qwen3-30b-a3b | fc1 | 16 | 8 | 4 | 8192 | 2048 | 32768 | 4096 | 2048 | bf16 | 0.3033 | 1812.9 | 36.0% | BM256/BN256/BK128/mw2/nw2/nb2 | 2118 |
| qwen3-30b-a3b | fc2 | 16 | 8 | 1 | 8192 | 512 | 8192 | 2048 | 2048 | bf16 | 0.0589 | 1167.0 | 23.2% | BM256/BN256/BK128/mw2/nw2/nb2 | 2267 |
| qwen3-30b-a3b | fc2 | 16 | 8 | 2 | 8192 | 1024 | 16384 | 2048 | 2048 | bf16 | 0.0942 | 1458.5 | 29.0% | BM256/BN256/BK128/mw2/nw2/nb2 | 2190 |
| qwen3-30b-a3b | fc2 | 16 | 8 | 4 | 8192 | 2048 | 32768 | 2048 | 2048 | bf16 | 0.1621 | 1695.7 | 33.7% | BM256/BN256/BK128/mw2/nw2/nb2 | 2124 |
| qwen3-235b-a22b | fc1 | 16 | 8 | 1 | 8192 | 512 | 8192 | 8192 | 4096 | bf16 | 0.3788 | 1451.1 | 28.8% | BM256/BN256/BK128/mw2/nw2/nb2 | 2151 |
| qwen3-235b-a22b | fc1 | 16 | 8 | 2 | 8192 | 1024 | 16384 | 8192 | 4096 | bf16 | 0.6365 | 1727.5 | 34.3% | BM256/BN256/BK128/mw2/nw2/nb2 | 2126 |
| qwen3-235b-a22b | fc1 | 16 | 8 | 4 | 8192 | 2048 | 32768 | 8192 | 4096 | bf16 | 1.1246 | **1955.4** | **38.8%** | BM256/BN256/BK128/mw2/nw2/nb2 | 2108 |
| qwen3-235b-a22b | fc2 | 16 | 8 | 1 | 8192 | 512 | 8192 | 4096 | 4096 | bf16 | 0.19 | 1446.5 | 28.7% | BM256/BN256/BK128/mw2/nw2/nb2 | 2154 |
| qwen3-235b-a22b | fc2 | 16 | 8 | 2 | 8192 | 1024 | 16384 | 4096 | 4096 | bf16 | 0.3198 | 1718.8 | 34.2% | BM256/BN256/BK128/mw2/nw2/nb2 | 2116 |
| qwen3-235b-a22b | fc2 | 16 | 8 | 4 | 8192 | 2048 | 32768 | 4096 | 4096 | bf16 | 0.569 | 1932.5 | 38.4% | BM256/BN256/BK128/mw2/nw2/nb2 | 2106 |
| deepseek-v3 | fc1 | 32 | 8 | 1 | 4096 | 128 | 4096 | 4096 | 7168 | bf16 | 0.2858 | 841.7 | 16.7% | BM128/BN128/BK128/mw2/nw2/nb2 | 2186 |
| deepseek-v3 | fc1 | 32 | 8 | 2 | 4096 | 256 | 8192 | 4096 | 7168 | bf16 | 0.4141 | 1161.6 | 23.1% | BM256/BN256/BK128/mw2/nw2/nb2 | 2184 |
| deepseek-v3 | fc1 | 32 | 8 | 4 | 4096 | 512 | 16384 | 4096 | 7168 | bf16 | 0.6444 | 1492.9 | 29.7% | BM256/BN256/BK128/mw2/nw2/nb2 | 2155 |
| deepseek-v3 | fc2 | 32 | 8 | 1 | 4096 | 128 | 4096 | 7168 | 2048 | bf16 | 0.1523 | **789.5** | **15.7%** | BM128/BN128/BK128/mw2/nw2/nb2 | 2206 |
| deepseek-v3 | fc2 | 32 | 8 | 2 | 4096 | 256 | 8192 | 7168 | 2048 | bf16 | 0.2237 | 1074.9 | 21.4% | BM256/BN256/BK128/mw2/nw2/nb2 | 2187 |
| deepseek-v3 | fc2 | 32 | 8 | 4 | 4096 | 512 | 16384 | 7168 | 2048 | bf16 | 0.3557 | 1352.3 | 26.9% | BM256/BN256/BK128/mw2/nw2/nb2 | 2156 |

**mean 1430.8 TF/s, peak 1955.4 · MFU mean 28.4 %, peak 38.9 % · cv max 1.98 %**

---

## 7.2 Backward dgrad — the native NN pipeline

No transposed weight copy. `b[G,K,N]` read in place.

| model | proj | G | EP | batch | seq | avg_m | M(total) | N | K | dtype | ms | TF/s | MFU | config | sclk |
|---|---|--:|--:|--:|--:|--:|--:|--:|--:|---|--:|--:|--:|---|--:|
| gpt-oss-20b | fc1 | 4 | 8 | 1 | 4096 | 512 | 2048 | 5760 | 2880 | bf16 | 0.0629 | 1080.6 | 21.5% | BM128/BN128/BK128/mw2/nw2/nb2 | 2295 |
| gpt-oss-20b | fc1 | 4 | 8 | 2 | 4096 | 1024 | 4096 | 5760 | 2880 | bf16 | 0.0895 | 1519.1 | 30.2% | BM256/BN256/BK128/mw2/nw2/nb2 | 2254 |
| gpt-oss-20b | fc1 | 4 | 8 | 4 | 4096 | 2048 | 8192 | 5760 | 2880 | bf16 | 0.1686 | 1612.2 | 32.0% | BM256/BN256/BK128/mw2/nw2/nb2 | 2225 |
| gpt-oss-20b | fc2 | 4 | 8 | 1 | 4096 | 512 | 2048 | 2880 | 2880 | bf16 | 0.0307 | 1107.5 | 22.0% | BM128/BN256/BK64/mw2/nw2/nb3 | 2331 |
| gpt-oss-20b | fc2 | 4 | 8 | 2 | 4096 | 1024 | 4096 | 2880 | 2880 | bf16 | 0.0482 | 1409.5 | 28.0% | BM256/BN256/BK64/mw2/nw2/nb3 | 2315 |
| gpt-oss-20b | fc2 | 4 | 8 | 4 | 4096 | 2048 | 8192 | 2880 | 2880 | bf16 | 0.0931 | 1459.5 | 29.0% | BM256/BN256/BK64/mw2/nw2/nb3 | 2282 |
| qwen3-30b-a3b | fc1 | 16 | 8 | 1 | 8192 | 512 | 8192 | 4096 | 2048 | bf16 | 0.1126 | 1221.0 | 24.3% | BM256/BN256/BK128/mw2/nw2/nb2 | 2267 |
| qwen3-30b-a3b | fc1 | 16 | 8 | 2 | 8192 | 1024 | 16384 | 4096 | 2048 | bf16 | 0.179 | 1535.9 | 30.5% | BM256/BN256/BK128/mw2/nw2/nb2 | 2228 |
| qwen3-30b-a3b | fc1 | 16 | 8 | 4 | 8192 | 2048 | 32768 | 4096 | 2048 | bf16 | 0.3072 | 1789.4 | 35.6% | BM256/BN256/BK128/mw2/nw2/nb2 | 2218 |
| qwen3-30b-a3b | fc2 | 16 | 8 | 1 | 8192 | 512 | 8192 | 2048 | 2048 | bf16 | 0.0606 | 1133.7 | 22.5% | BM256/BN256/BK128/mw2/nw2/nb2 | 2306 |
| qwen3-30b-a3b | fc2 | 16 | 8 | 2 | 8192 | 1024 | 16384 | 2048 | 2048 | bf16 | 0.096 | 1431.1 | 28.4% | BM256/BN256/BK128/mw2/nw2/nb2 | 2266 |
| qwen3-30b-a3b | fc2 | 16 | 8 | 4 | 8192 | 2048 | 32768 | 2048 | 2048 | bf16 | 0.1637 | 1679.4 | 33.4% | BM256/BN256/BK128/mw2/nw2/nb2 | 2227 |
| qwen3-235b-a22b | fc1 | 16 | 8 | 1 | 8192 | 512 | 8192 | 8192 | 4096 | bf16 | 0.3743 | 1468.6 | 29.2% | BM256/BN256/BK128/mw2/nw2/nb2 | 2189 |
| qwen3-235b-a22b | fc1 | 16 | 8 | 2 | 8192 | 1024 | 16384 | 8192 | 4096 | bf16 | 0.6283 | 1750.0 | 34.8% | BM256/BN256/BK128/mw2/nw2/nb2 | 2197 |
| qwen3-235b-a22b | fc1 | 16 | 8 | 4 | 8192 | 2048 | 32768 | 8192 | 4096 | bf16 | 1.1146 | **1972.9** | **39.2%** | BM256/BN256/BK128/mw2/nw2/nb2 | 2187 |
| qwen3-235b-a22b | fc2 | 16 | 8 | 1 | 8192 | 512 | 8192 | 4096 | 4096 | bf16 | 0.193 | 1424.4 | 28.3% | BM256/BN256/BK128/mw2/nw2/nb2 | 2193 |
| qwen3-235b-a22b | fc2 | 16 | 8 | 2 | 8192 | 1024 | 16384 | 4096 | 4096 | bf16 | 0.3254 | 1689.7 | 33.6% | BM256/BN256/BK128/mw2/nw2/nb2 | 2191 |
| qwen3-235b-a22b | fc2 | 16 | 8 | 4 | 8192 | 2048 | 32768 | 4096 | 4096 | bf16 | 0.5775 | 1903.8 | 37.8% | BM256/BN256/BK128/mw2/nw2/nb2 | 2202 |
| deepseek-v3 | fc1 | 32 | 8 | 1 | 4096 | 128 | 4096 | 4096 | 7168 | bf16 | 0.2922 | **823.2** | **16.4%** | BM128/BN128/BK128/mw2/nw2/nb2 | 2189 |
| deepseek-v3 | fc1 | 32 | 8 | 2 | 4096 | 256 | 8192 | 4096 | 7168 | bf16 | 0.4318 | 1114.0 | 22.1% | BM256/BN256/BK128/mw2/nw2/nb2 | 2209 |
| deepseek-v3 | fc1 | 32 | 8 | 4 | 4096 | 512 | 16384 | 4096 | 7168 | bf16 | 0.6867 | 1401.1 | 27.8% | BM256/BN256/BK128/mw2/nw2/nb2 | 2203 |
| deepseek-v3 | fc2 | 32 | 8 | 1 | 4096 | 128 | 4096 | 7168 | 2048 | bf16 | 0.1422 | 846.0 | 16.8% | BM128/BN128/BK128/mw2/nw2/nb2 | 2188 |
| deepseek-v3 | fc2 | 32 | 8 | 2 | 4096 | 256 | 8192 | 7168 | 2048 | bf16 | 0.2116 | 1136.5 | 22.6% | BM256/BN256/BK128/mw2/nw2/nb2 | 2200 |
| deepseek-v3 | fc2 | 32 | 8 | 4 | 4096 | 512 | 16384 | 7168 | 2048 | bf16 | 0.3287 | 1463.7 | 29.1% | BM256/BN256/BK128/mw2/nw2/nb2 | 2186 |

**mean 1415.5 TF/s, peak 1972.9 · MFU mean 28.1 %, peak 39.2 % · cv max 0.70 %**

---

## 7.3 Backward wgrad (variable-K)

End-to-end calibre: both operands read token-major as they are, transposed in
LDS. **No `.t().contiguous()` anywhere in the timer** — directly comparable to
the CK and Triton variable-K backends without correction.

| model | proj | G | EP | batch | seq | avg_m | M(total) | N | K | dtype | ms | TF/s | MFU | config | sclk |
|---|---|--:|--:|--:|--:|--:|--:|--:|--:|---|--:|--:|--:|---|--:|
| gpt-oss-20b | fc1 | 4 | 8 | 1 | 4096 | 512 | 2048 | 5760 | 2880 | bf16 | 0.0649 | 1047.1 | 20.8% | BM256/BN256/BK128/mw4/nw2/nb2 | 2237 |
| gpt-oss-20b | fc1 | 4 | 8 | 2 | 4096 | 1024 | 4096 | 5760 | 2880 | bf16 | 0.1042 | 1303.9 | 25.9% | BM256/BN256/BK128/mw4/nw2/nb2 | 2191 |
| gpt-oss-20b | fc1 | 4 | 8 | 4 | 4096 | 2048 | 8192 | 5760 | 2880 | bf16 | 0.1899 | 1431.5 | 28.4% | BM256/BN256/BK128/mw4/nw2/nb2 | 2128 |
| gpt-oss-20b | fc2 | 4 | 8 | 1 | 4096 | 512 | 2048 | 2880 | 2880 | bf16 | 0.041 | 827.8 | 16.4% | BM256/BN256/BK128/mw4/nw2/nb2 | 2304 |
| gpt-oss-20b | fc2 | 4 | 8 | 2 | 4096 | 1024 | 4096 | 2880 | 2880 | bf16 | 0.0638 | 1064.2 | 21.1% | BM256/BN256/BK128/mw4/nw2/nb2 | 2268 |
| gpt-oss-20b | fc2 | 4 | 8 | 4 | 4096 | 2048 | 8192 | 2880 | 2880 | bf16 | 0.1118 | 1215.4 | 24.1% | BM256/BN256/BK128/mw4/nw2/nb2 | 2200 |
| qwen3-30b-a3b | fc1 | 16 | 8 | 1 | 8192 | 512 | 8192 | 4096 | 2048 | bf16 | 0.1048 | 1311.3 | 26.1% | BM256/BN256/BK128/mw4/nw2/nb2 | 2203 |
| qwen3-30b-a3b | fc1 | 16 | 8 | 2 | 8192 | 1024 | 16384 | 4096 | 2048 | bf16 | 0.1812 | 1516.9 | 30.1% | BM256/BN256/BK128/mw4/nw2/nb2 | 2141 |
| qwen3-30b-a3b | fc1 | 16 | 8 | 4 | 8192 | 2048 | 32768 | 4096 | 2048 | bf16 | 0.321 | 1712.8 | 34.0% | BM256/BN256/BK128/mw4/nw2/nb2 | 2118 |
| qwen3-30b-a3b | fc2 | 16 | 8 | 1 | 8192 | 512 | 8192 | 2048 | 2048 | bf16 | 0.0521 | 1319.9 | 26.2% | BM256/BN256/BK128/mw4/nw2/nb2 | 2267 |
| qwen3-30b-a3b | fc2 | 16 | 8 | 2 | 8192 | 1024 | 16384 | 2048 | 2048 | bf16 | 0.0911 | 1509.1 | 30.0% | BM256/BN256/BK128/mw4/nw2/nb2 | 2190 |
| qwen3-30b-a3b | fc2 | 16 | 8 | 4 | 8192 | 2048 | 32768 | 2048 | 2048 | bf16 | 0.1652 | 1664.4 | 33.1% | BM256/BN256/BK128/mw4/nw2/nb2 | 2124 |
| qwen3-235b-a22b | fc1 | 16 | 8 | 1 | 8192 | 512 | 8192 | 8192 | 4096 | bf16 | 0.4285 | 1282.8 | 25.5% | BM256/BN256/BK128/mw4/nw2/nb2 | 2151 |
| qwen3-235b-a22b | fc1 | 16 | 8 | 2 | 8192 | 1024 | 16384 | 8192 | 4096 | bf16 | 0.7051 | 1559.4 | 31.0% | BM256/BN256/BK128/mw4/nw2/nb2 | 2126 |
| qwen3-235b-a22b | fc1 | 16 | 8 | 4 | 8192 | 2048 | 32768 | 8192 | 4096 | bf16 | 1.2509 | **1758.0** | **34.9%** | BM256/BN256/BK128/mw4/nw2/nb2 | 2108 |
| qwen3-235b-a22b | fc2 | 16 | 8 | 1 | 8192 | 512 | 8192 | 4096 | 4096 | bf16 | 0.2156 | 1275.0 | 25.3% | BM256/BN256/BK128/mw4/nw2/nb2 | 2154 |
| qwen3-235b-a22b | fc2 | 16 | 8 | 2 | 8192 | 1024 | 16384 | 4096 | 4096 | bf16 | 0.3615 | 1520.8 | 30.2% | BM256/BN256/BK128/mw4/nw2/nb2 | 2116 |
| qwen3-235b-a22b | fc2 | 16 | 8 | 4 | 8192 | 2048 | 32768 | 4096 | 4096 | bf16 | 0.6374 | 1725.1 | 34.3% | BM256/BN256/BK128/mw4/nw2/nb2 | 2106 |
| deepseek-v3 | fc1 | 32 | 8 | 1 | 4096 | 128 | 4096 | 4096 | 7168 | bf16 | 0.4046 | **594.4** | **11.8%** | BM256/BN256/BK128/mw4/nw2/nb2 | 2186 |
| deepseek-v3 | fc1 | 32 | 8 | 2 | 4096 | 256 | 8192 | 4096 | 7168 | bf16 | 0.5278 | 911.5 | 18.1% | BM256/BN256/BK128/mw4/nw2/nb2 | 2184 |
| deepseek-v3 | fc1 | 32 | 8 | 4 | 4096 | 512 | 16384 | 4096 | 7168 | bf16 | 0.7649 | 1257.7 | 25.0% | BM256/BN256/BK128/mw4/nw2/nb2 | 2155 |
| deepseek-v3 | fc2 | 32 | 8 | 1 | 4096 | 128 | 4096 | 7168 | 2048 | bf16 | 0.1903 | 632.0 | 12.6% | BM256/BN256/BK128/mw4/nw2/nb2 | 2206 |
| deepseek-v3 | fc2 | 32 | 8 | 2 | 4096 | 256 | 8192 | 7168 | 2048 | bf16 | 0.2668 | 901.6 | 17.9% | BM256/BN256/BK128/mw4/nw2/nb2 | 2187 |
| deepseek-v3 | fc2 | 32 | 8 | 4 | 4096 | 512 | 16384 | 7168 | 2048 | bf16 | 0.3903 | 1232.4 | 24.5% | BM256/BN256/BK128/mw4/nw2/nb2 | 2156 |

**mean 1274.0 TF/s, peak 1758.0 · MFU mean 25.3 %, peak 34.9 % · cv max 0.67 %**

Note every wgrad row runs the **same** tile, `mw4` and not `mw2`: `avg_m` is the
reduction dimension here and deliberately does not enter tile selection
(`docs/05-optimization-log.md`).

The worst point, deepseek-v3 fc1 @ avg_m=128 at 594 TF/s, is **not a tile
problem**: that shape writes 1.88 GB of output for 240 GFLOP of work. It is
output-bandwidth bound and no tile fixes it.

---

## 7.4 Four calibres, same process, interleaved

The comparison that actually settles "was the native NN pipeline worth it".
All four measured point by point in one process, so clock drift hits all of them
equally.

- **native** — the shipped NN pipeline, `b[G,K,N]` read in place
- **hoist** — `b_nt` prebuilt outside the timer; the *upper bound* a real
  training loop could reach with a transposed copy
- **fast_pc** — flydsl + the tiled Triton transpose, **per call, inside the
  timer** (not the 1.07 TB/s upstream helper)
- **triton** — Triton's grouped GEMM

| model | proj | avg_m | native ms | hoist ms | fast_pc ms | triton ms | nat/hoist | nat/fast_pc | nat/triton |
|---|---|--:|--:|--:|--:|--:|--:|--:|--:|
| gpt-oss-20b | fc1 | 512 | 0.0630 | 0.0623 | 0.0963 | 0.1202 | 0.990 | 1.529 | 1.909 |
| gpt-oss-20b | fc1 | 1024 | 0.0896 | 0.0859 | 0.1190 | 0.1259 | 0.958 | 1.327 | 1.405 |
| gpt-oss-20b | fc1 | 2048 | 0.1688 | 0.1616 | 0.1922 | 0.2454 | 0.957 | 1.139 | 1.454 |
| gpt-oss-20b | fc2 | 512 | 0.0306 | 0.0311 | 0.0584 | 0.0645 | **1.015** | 1.908 | 2.107 |
| gpt-oss-20b | fc2 | 1024 | 0.0482 | 0.0464 | 0.0724 | 0.0682 | 0.964 | 1.502 | 1.416 |
| gpt-oss-20b | fc2 | 2048 | 0.0934 | 0.0814 | 0.1072 | 0.1363 | **0.872** | 1.147 | 1.459 |
| qwen3-30b-a3b | fc1 | 512 | 0.1129 | 0.1107 | 0.1545 | 0.1005 | 0.981 | 1.368 | **0.890** |
| qwen3-30b-a3b | fc1 | 1024 | 0.1795 | 0.1763 | 0.2176 | 0.1933 | 0.982 | 1.212 | 1.077 |
| qwen3-30b-a3b | fc1 | 2048 | 0.3080 | 0.3027 | 0.3428 | 0.3820 | 0.983 | 1.113 | 1.240 |
| qwen3-30b-a3b | fc2 | 512 | 0.0607 | 0.0591 | 0.0955 | 0.0563 | 0.973 | 1.572 | **0.926** |
| qwen3-30b-a3b | fc2 | 1024 | 0.0960 | 0.0940 | 0.1279 | 0.1095 | 0.980 | 1.333 | 1.141 |
| qwen3-30b-a3b | fc2 | 2048 | 0.1641 | 0.1620 | 0.1935 | 0.2135 | 0.987 | 1.179 | 1.301 |
| qwen3-235b-a22b | fc1 | 512 | 0.3757 | 0.3688 | 0.5029 | 0.3762 | 0.982 | 1.339 | 1.001 |
| qwen3-235b-a22b | fc1 | 1024 | 0.6289 | 0.6197 | 0.7540 | 0.7286 | 0.985 | 1.199 | 1.158 |
| qwen3-235b-a22b | fc1 | 2048 | 1.1133 | 1.1032 | 1.2342 | 1.4425 | 0.991 | 1.109 | 1.296 |
| qwen3-235b-a22b | fc2 | 512 | 0.1932 | 0.1908 | 0.2582 | 0.1997 | 0.987 | 1.336 | 1.033 |
| qwen3-235b-a22b | fc2 | 1024 | 0.3254 | 0.3196 | 0.3886 | 0.3855 | 0.982 | 1.194 | 1.185 |
| qwen3-235b-a22b | fc2 | 2048 | 0.5772 | 0.5682 | 0.6393 | 0.7650 | 0.984 | 1.108 | 1.325 |
| deepseek-v3 | fc1 | 128 | 0.2910 | 0.2846 | 0.5230 | 0.3903 | 0.978 | 1.797 | 1.341 |
| deepseek-v3 | fc1 | 256 | 0.4322 | 0.4236 | 0.6628 | 0.4035 | 0.980 | 1.534 | **0.934** |
| deepseek-v3 | fc1 | 512 | 0.6881 | 0.6756 | 0.9142 | 0.6990 | 0.982 | 1.329 | 1.016 |
| deepseek-v3 | fc2 | 128 | 0.1424 | 0.1467 | 0.2629 | 0.1755 | **1.031** | 1.847 | 1.233 |
| deepseek-v3 | fc2 | 256 | 0.2113 | 0.2096 | 0.3265 | 0.1802 | 0.992 | 1.545 | **0.853** |
| deepseek-v3 | fc2 | 512 | 0.3291 | 0.3269 | 0.4429 | 0.3402 | 0.993 | 1.345 | 1.034 |

| comparison | geomean | min | max | native faster on |
|---|--:|--:|--:|---|
| **native vs hoist** | **0.9792** | 0.872 | 1.031 | 2/24 |
| **native vs flydsl + fast transpose, per call** | **1.3574** | 1.108 | 1.908 | **24/24** |
| **native vs Triton** | **1.2082** | 0.853 | 2.107 | 20/24 |

### All three numbers, stated plainly

**The native GEMM is 2.1 % slower than the NT GEMM** (0.979). That is the honest
like-for-like: same work, same session, and the NT path had a transposed weight
handed to it for free.

**Against what a caller can actually do per call it is 1.357× faster**, 24/24.
"hoist" is an upper bound that requires the caller to maintain a parameter-sized
copy and invalidate it correctly; "fast_pc" is what you get if you do not.

**Against Triton it is 1.208×, winning 20 of 24.**

The 2.1 % buys: **no transposed weight copy** (up to 2.62 GiB per layer),
**nothing to invalidate** (so the fused-AdamW `_version` hazard cannot occur),
and no cache lifetime question.

### The 4 cells that still lose to Triton

| model | proj | avg_m | native/triton |
|---|---|--:|--:|
| deepseek-v3 | fc2 | 256 | **0.853** |
| qwen3-30b-a3b | fc1 | 512 | **0.890** |
| qwen3-30b-a3b | fc2 | 512 | **0.926** |
| deepseek-v3 | fc1 | 256 | **0.934** |

All at small `avg_m`. **These are not caused by this work** — the same cells
lose in the hoisted calibre too, so it is flydsl's GEMM and not the transpose
read. Wave quantisation has been **disproven** as the mechanism
(`docs/05-optimization-log.md` §5.4) and the real cause is **unknown**.

If you are wiring this into a dispatcher, an autotuning selector will route
around them; a hard pin to flydsl will not.

### The worst native-vs-hoist point, explained

**gpt-oss fc2 dgrad @ avg_m=2048 = 0.872.** Cause identified and it is **not the
transpose read**: `_pick_config` returns `tile_n=192` here, and TDM's
`pad_interval` must be a power of two, so a 192-wide transposing B stage cannot
be built at all. The native path falls back to 256×256×64 while hoist keeps the
192 tile.

What is being given up is a tile that `_pick_config`'s own docstring flags as
**fitted, mechanism not established, "the highest extrapolation risk in this
function."**

---

## 7.5 Against the other backends on this part

Measured with the same driver, same session, same statistics, so these ratios
carry no methodology difference. (Verified separately: re-measuring the Triton
baseline under the changed statistics gives a ratio of **1.0000** over 72
points.)

| direction | FlyDSL | Triton | hipBLASLt | FlyDSL/Triton | FlyDSL/hipBLASLt |
|---|--:|--:|--:|---|---|
| fwd | **1342.4** | 1134.0 | 813.6 | **1.202×** (0.793–1.657) | **1.912×** (0.965–3.395) |
| dgrad (hoist calibre) | **1355.3** | 1197.0 | 64.3 | **1.165×** (0.771–1.643) | **21.34×** |
| wgrad | **1232.7** | 624.1 | 64.6 | **1.998×** (1.776–2.295) | **18.89×** |
| dgrad (per-call transpose) | 390.2 | 1197.0 | 64.3 | **0.324×** | 5.85× |

*(This table is from the earlier round — see the cross-section warning in §7.0.
Use it for ratios, not for absolute comparison with §7.1–7.3.)*

**wgrad is the cleanest and largest win: all 24 points faster, 1.78×–2.30×, no
exceptions.** It is also precisely where Triton is weakest (625 TF/s mean,
12.4 % MFU — the only real soft spot in the Triton baseline), and the two
calibres are naturally comparable.

**fwd and dgrad are moderate wins, not sweeps.** Of 48 fwd/dgrad points FlyDSL
is faster on 38, clearly slower on 8, level on 2. The losses concentrate at
**batch=1** (mean 1.15× at batch=1 vs 1.27–1.31× at batch=4) and at small N·K.

**The last row is the one that justified this whole project.** Without the native
pipeline and without hoisting, dgrad ran at **0.324× Triton** — three times
slower than not using this kernel at all.

---

## 7.6 What was not measured

- **Cross-session reproducibility.** Everything here is one session per round.
- **Multi-GPU, and the production backend registry path.** All measurements go
  through a standalone dispatch entry, not `BackendType.FLYDSL`.
- **fp8 / fp16.**
- **`inplace_add_to_out`** (Megatron-fused wgrad), which both FlyDSL backends
  decline.
- **`masked_k` on the NN path** — the entry has no such parameter. It *is*
  verified on wgrad, including padded pools with `valid % tile_k != 0` and
  poisoned dead rows (finite `1e4` and `NaN`, 8 points each, all passing at the
  noise floor).
