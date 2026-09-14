"""Probe which grouped-GEMM backends can_handle() on this device, per direction.

Prints, for the fwd (NT), dgrad (NN) and wgrad (variable-K) operators, whether each
registered backend accepts the inputs, and if it does, whether it actually runs.
"""

import torch

import primus_turbo.pytorch as turbo  # noqa: F401  (registers the custom ops)
from primus_turbo.pytorch.core.utils import build_ck, is_gfx950, is_gfx1250
from primus_turbo.pytorch.kernels.grouped_gemm.grouped_gemm_impl import (
    _GROUPED_GEMM_BACKENDS,
    _GROUPED_GEMM_VARIABLE_K_BACKENDS,
)
from primus_turbo.pytorch.kernels.grouped_gemm.grouped_gemm_utils import (
    group_offs_from_lens,
)

props = torch.cuda.get_device_properties(0)
print(f"device      : {props.gcnArchName}  CUs={props.multi_processor_count}")
print(f"is_gfx950   : {is_gfx950()}")
print(f"is_gfx1250  : {is_gfx1250()}")
print(f"build_ck    : {build_ck()}")
print()

G, M, N, K = 4, 512, 5760, 2880
dev, dt = "cuda", torch.bfloat16
group_lens = torch.full((G,), M, dtype=torch.int64, device=dev)
group_offs = group_offs_from_lens(group_lens)

a = torch.randn(G * M, K, dtype=dt, device=dev)
b_nt = torch.randn(G, N, K, dtype=dt, device=dev)
b_nn = torch.randn(G, K, N, dtype=dt, device=dev)
grad_out = torch.randn(G * M, N, dtype=dt, device=dev)


def probe(title, backends, kwargs):
    print(f"--- {title} ---")
    for name, entry in backends.items():
        try:
            ok = entry.impl.can_handle(**kwargs)
        except Exception as exc:  # noqa: BLE001
            print(f"  {name.name:<10} can_handle RAISED  {type(exc).__name__}: {exc}")
            continue
        if not ok:
            print(f"  {name.name:<10} can_handle=False")
            continue
        try:
            out = entry.impl.execute(**kwargs)
            torch.cuda.synchronize()
            print(f"  {name.name:<10} can_handle=True   execute OK  out={tuple(out.shape)}")
        except Exception as exc:  # noqa: BLE001
            msg = str(exc).replace("\n", " ")[:200]
            print(f"  {name.name:<10} can_handle=True   execute FAILED  {type(exc).__name__}: {msg}")
    print()


common = dict(group_lens=group_lens, group_offs=group_offs, num_cu=None, schedule="static")

probe(
    "fwd  NT   a[M,K] @ b[G,N,K]^T   (trans_b=True)",
    _GROUPED_GEMM_BACKENDS,
    dict(a=a, b=b_nt, trans_a=False, trans_b=True, **common),
)
probe(
    "dgrad NN  grad_out[M,N] @ b[G,K,N]  -- wait, dgrad uses trans_b=not fwd_trans_b=False",
    _GROUPED_GEMM_BACKENDS,
    dict(a=grad_out, b=b_nn, trans_a=False, trans_b=False, **common),
)
probe(
    "wgrad variable-K  a[M,K]^T @ grad_out[M,N]  (trans_a=True, trans_c=True)",
    _GROUPED_GEMM_VARIABLE_K_BACKENDS,
    dict(a=a, b=grad_out, trans_a=True, trans_b=False, trans_c=True, **common),
)
