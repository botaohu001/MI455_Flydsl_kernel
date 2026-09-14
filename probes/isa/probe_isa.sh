#!/usr/bin/env bash
# Probe which instructions LLVM will encode for a given AMDGPU target.
#
# The discriminator that makes this useful:
#   "invalid instruction"                  -> mnemonic does not exist in AMDGPU at all
#   "instruction not supported on this GPU" -> mnemonic exists, but not for this -mcpu
#   (encoding printed)                      -> supported, and we get the real bits
MC=${MC:-/opt/venv/lib/python3.12/site-packages/_rocm_sdk_core/lib/llvm/bin/llvm-mc}

probe() {  # probe <mcpu> <asm...>
  local cpu="$1"; shift
  local asm="$*"
  local out
  out=$(printf '%s\n' "$asm" | "$MC" -arch=amdgcn -mcpu="$cpu" -show-encoding 2>&1)
  if grep -q 'invalid instruction' <<<"$out"; then
    printf '  %-14s %-56s  NO-SUCH-MNEMONIC\n' "$cpu" "$asm"
  elif grep -q 'not supported on this GPU' <<<"$out"; then
    printf '  %-14s %-56s  WRONG-TARGET\n' "$cpu" "$asm"
  elif grep -q 'error:' <<<"$out"; then
    printf '  %-14s %-56s  OPERAND-ERR: %s\n' "$cpu" "$asm" \
      "$(grep -m1 'error:' <<<"$out" | sed 's/.*error: //')"
  else
    printf '  %-14s %-56s  OK  %s\n' "$cpu" "$asm" \
      "$(grep -o '\[0x[^]]*\]' <<<"$out" | head -1)"
  fi
}

both() { probe gfx1250 "$@"; probe gfx950 "$@"; echo; }

echo "############ 1. DS transpose reads ############"
both "ds_load_tr16_b128 v[0:3], v4"
both "ds_load_tr8_b64 v[0:1], v4"
both "ds_load_tr6_b96 v[0:2], v4"
both "ds_load_tr4_b64 v[0:1], v4"
both "ds_read_b64_tr_b16 v[0:1], v4"
both "ds_read_b64_tr_b8 v[0:1], v4"
both "ds_read_b64_tr_b4 v[0:1], v4"
both "ds_read_b96_tr_b6 v[0:2], v4"

echo "############ 2. DS transpose with offset (imm field width) ############"
probe gfx1250 "ds_load_tr16_b128 v[0:3], v4 offset:65535"
probe gfx1250 "ds_load_tr16_b128 v[0:3], v4 offset:65536"
echo

echo "############ 3. WMMA family on gfx1250 ############"
for k in 16 32 64 128; do
  probe gfx1250 "v_wmma_f32_16x16x${k}_bf16 v[0:7], v[8:15], v[16:23], v[0:7]"
done
probe gfx1250 "v_wmma_f32_16x16x32_bf16 v[0:7], v[8:15], v[16:23], v[0:7] neg_lo:[1,0,0]"
probe gfx1250 "v_wmma_f32_16x16x32_bf16 v[0:7], v[8:15], v[16:23], v[0:7] transpose_a:1"
probe gfx1250 "v_wmma_f32_16x16x32_bf16 v[0:7], v[8:15], v[16:23], v[0:7] trans_a:1"
probe gfx1250 "v_wmma_f32_16x16x32_bf16 v[0:7], v[8:15], v[16:23], v[0:7] matrix_a_fmt:MATRIX_FMT_BF16"
probe gfx1250 "v_wmma_f32_16x16x32_bf16 v[0:7], v[8:15], v[16:23], v[0:7] matrix_a_scale:MATRIX_SCALE_ROW0"
echo

echo "############ 4. TDM / tensor DMA ############"
for m in "tensor_load_to_lds s[0:3], s[4:7], s[8:11], s[12:15]" \
         "tensor_save_from_lds s[0:3], s[4:7], s[8:11], s[12:15]" \
         "tensor_load_to_lds s[0:3], s[4:7]" \
         "tensor_stride_load_to_lds s[0:3], s[4:7]"; do
  probe gfx1250 "$m"
done
echo

echo "############ 5. global_load_lds / transpose-in-flight ############"
probe gfx1250 "global_load_lds_b128 v[0:1], off"
probe gfx1250 "global_load_lds_dwordx4 v[0:1], off"
probe gfx1250 "global_load_tr_b128 v[0:3], v[4:5], off"
probe gfx1250 "global_load_tr16_b128 v[0:3], v[4:5], off"
probe gfx1250 "ds_bpermute_b32 v0, v1, v2"
probe gfx1250 "v_permlane16_b32 v0, v1, s0, s1"
probe gfx1250 "v_permlane32_swap_b32 v0, v1"
probe gfx1250 "v_permlane16_swap_b32 v0, v1"
echo
