#!/usr/bin/env bash
MC=${MC:-/opt/venv/lib/python3.12/site-packages/_rocm_sdk_core/lib/llvm/bin/llvm-mc}
LIB=/opt/venv/lib/python3.12/site-packages/_rocm_sdk_core/lib/llvm/lib/libLLVM.so.23.0git

echo "############ A. AMDGPU intrinsic names: transpose / tensor / wmma ############"
strings "$LIB" | grep -E '^llvm\.amdgcn\.' | sort -u \
  | grep -Ei 'tr\.b|tr16|tr8|tr4|tr6|tensor|wmma|permlane|transpose|swmmac' | sed 's/^/  /'
echo

echo "############ B. every 'ds_load_tr' / 'global_load_tr' mnemonic in the string table ############"
strings "$LIB" | grep -Ex '(ds|global|flat|buffer)_load_tr[a-z0-9_]*' | sort -u | sed 's/^/  /'
echo
echo "############ B2. every 'tensor_' mnemonic ############"
strings "$LIB" | grep -Ex 'tensor_[a-z0-9_]+' | sort -u | sed 's/^/  /'
echo

echo "############ C. all v_wmma* / v_swmmac* mnemonics that gfx1250 accepts ############"
for m in $(strings "$LIB" | grep -Ex 'v_(wmma|swmmac)[a-z0-9_]+' | sort -u); do
  out=$(printf '%s v[0:7], v[8:15], v[16:23], v[24:31]\n' "$m" \
        | "$MC" -arch=amdgcn -mcpu=gfx1250 -show-encoding 2>&1)
  grep -q 'not supported on this GPU' <<<"$out" && continue
  grep -q 'invalid instruction' <<<"$out" && continue
  echo "  gfx1250 accepts mnemonic: $m"
done
echo

echo "############ D. tensor_load_to_lds operand forms ############"
for a in "tensor_load_to_lds s[0:3], s[4:7], s[8:11], s[12:15] th:TH_LOAD_NT" \
         "tensor_load_to_lds s[0:3], s[4:7], s[8:11], s[12:15] scope:SCOPE_SYS" \
         "tensor_load_to_lds s[0:3], s[4:11], s[12:15], s[16:19]" \
         "tensor_load_to_lds s[0:7], s[8:15], s[16:23], s[24:31]" \
         "tensor_load_to_lds s[0:3]" ; do
  out=$(printf '%s\n' "$a" | "$MC" -arch=amdgcn -mcpu=gfx1250 -show-encoding 2>&1)
  printf '  %-64s -> %s\n' "$a" "$(grep -m1 -E 'error:|\[0x' <<<"$out" | sed 's/^ *//' | cut -c1-90)"
done
echo

echo "############ E. DS opcode neighbourhood of ds_load_tr16_b128 on gfx1250 ############"
# disassemble the tr-family encodings to confirm the opcode block
for enc in "0x00,0x00,0xf0,0xdb,0x04,0x00,0x00,0x00" \
           "0x00,0x00,0xf4,0xdb,0x04,0x00,0x00,0x00" \
           "0x00,0x00,0xec,0xdb,0x04,0x00,0x00,0x00" \
           "0x00,0x00,0xe8,0xdb,0x04,0x00,0x00,0x00"; do
  echo "  $enc -> $(echo "$enc" | tr ',' '\n' | sed 's/0x//' | tr -d '\n' | \
     xxd -r -p | "$MC" -arch=amdgcn -mcpu=gfx1250 -disassemble 2>&1 | grep -v '^\s*\.' | head -1)"
done
