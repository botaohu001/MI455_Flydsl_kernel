	.amdgcn_target "amdgcn-amd-amdhsa--gfx1250"
	.amdhsa_code_object_version 6
	.text
	.globl	kernel_grouped_nt_0
	.p2align	8
	.type	kernel_grouped_nt_0,@function
kernel_grouped_nt_0:
	s_setreg_imm32_b32 hwreg(HW_REG_WAVE_SCHED_MODE, 0, 2), 2
	s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
	s_clause 0x1
	s_load_b128 s[20:23], s[0:1], 0x20 nv
	s_load_b32 s28, s[0:1], 0x30 nv
	s_bfe_u32 s2, ttmp6, 0x4000c
	v_readfirstlane_b32 s40, v0
	s_add_co_i32 s2, s2, 1
	s_and_b32 s3, ttmp6, 15
	s_mul_i32 s2, ttmp9, s2
	s_getreg_b32 s4, hwreg(HW_REG_IB_STS2, 6, 4)
	s_add_co_i32 s5, s3, s2
	s_lshr_b32 s29, s40, 5
	s_mov_b32 s19, 0
	s_wait_kmcnt 0x0
	s_ashr_i32 s3, s22, 31
	s_mov_b32 s2, s22
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_lshl_b64 s[24:25], s[2:3], 1
	s_cmp_eq_u32 s4, 0
	s_cselect_b32 s2, ttmp9, s5
	s_mul_hi_i32 s3, s2, 0xb21642c9
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s3, s3, s2
	s_lshr_b32 s4, s3, 31
	s_ashr_i32 s3, s3, 8
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s3, s3, s4
	s_mul_i32 s12, s3, 0x170
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(SALU_CYCLE_1)
	s_cmp_lg_u32 s2, s12
	s_cselect_b32 s4, -1, 0
	s_cmp_lt_i32 s2, 0
	s_cselect_b32 s5, -1, 0
	s_and_b32 s4, s5, s4
	s_sub_co_ci_u32 s35, s3, 0
	s_sub_co_i32 s36, s2, s12
	s_lshl_b32 s3, s35, 4
	s_abs_i32 s2, s36
	s_sub_co_i32 s4, 20, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_min_i32 s13, s4, 16
	s_abs_i32 s14, s13
	s_xor_b32 s12, s36, s13
	s_cvt_f32_u32 s4, s14
	s_ashr_i32 s12, s12, 31
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_4) | instid1(TRANS32_DEP_1)
	v_rcp_iflag_f32_e32 v1, s4
	s_load_b256 s[4:11], s[0:1], 0x0 nv
	s_wait_xcnt 0x0
	s_sub_co_i32 s1, 0, s14
	v_nop
	v_readfirstlane_b32 s0, v1
	s_mul_f32 s0, s0, 0x4f7ffffe
	s_delay_alu instid0(SALU_CYCLE_3) | instskip(NEXT) | instid1(SALU_CYCLE_3)
	s_cvt_u32_f32 s0, s0
	s_mul_i32 s1, s1, s0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_hi_u32 s1, s0, s1
	s_add_co_i32 s0, s0, s1
	s_wait_kmcnt 0x0
	s_load_b32 s1, s[10:11], 0x8
	s_mul_hi_u32 s0, s2, s0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s15, s0, s14
	s_sub_co_i32 s2, s2, s15
	s_add_co_i32 s15, s0, 1
	s_sub_co_i32 s16, s2, s14
	s_cmp_ge_u32 s2, s14
	s_cselect_b32 s0, s15, s0
	s_cselect_b32 s2, s16, s2
	s_add_co_i32 s15, s0, 1
	s_cmp_ge_u32 s2, s14
	s_movk_i32 s16, 0x100
	s_cselect_b32 s0, s15, s0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s0, s0, s12
	s_sub_co_i32 s37, s0, s12
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s38, s37, s13
	s_sub_co_i32 s0, s36, s38
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s12, s0, s3
	s_wait_kmcnt 0x0
	s_cmp_gt_i32 s1, s12
	s_cselect_b32 s0, -1, 0
	s_and_b32 s0, s0, exec_lo
	s_cselect_b32 s18, 4, 12
	s_cselect_b32 s2, 1, 3
	s_add_nc_u64 s[0:1], s[10:11], s[18:19]
	s_cselect_b32 s3, 2, 4
	s_load_b32 s0, s[0:1], 0x0
	s_wait_xcnt 0x0
	s_cselect_b32 s1, 0, 3
	s_add_co_i32 s13, s2, 1
	s_wait_kmcnt 0x0
	s_cmp_gt_i32 s0, s12
	s_cselect_b32 s0, s1, s13
	s_cselect_b32 s1, s2, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s1, s0, s1
	s_lshr_b32 s1, s1, 1
	s_delay_alu instid0(SALU_CYCLE_1)
	s_min_u32 s2, s1, 3
	s_add_co_i32 s1, s1, 1
	s_load_b32 s2, s[10:11], s2 offset:0x0 scale_offset
	s_wait_kmcnt 0x0
	s_cmp_gt_i32 s2, s12
	s_cselect_b32 s0, s0, s1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_min_u32 s34, s0, 3
	s_add_co_i32 s0, s34, 4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_ashr_i32 s1, s0, 31
	s_lshl_b64 s[0:1], s[0:1], 2
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_nc_u64 s[0:1], s[10:11], s[0:1]
	s_load_b64 s[2:3], s[0:1], 0x0
	s_wait_xcnt 0x0
	s_add_nc_u64 s[0:1], s[0:1], -16
	s_load_b32 s0, s[0:1], 0x0
	s_wait_kmcnt 0x0
	s_sub_co_i32 s1, s3, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s3, s1, 0xff
	s_ashr_i32 s10, s3, 31
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_lshr_b32 s10, s10, 24
	s_add_co_i32 s10, s3, s10
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 s11, s10, 0xffffff00
	s_ashr_i32 s10, s10, 8
	s_cmp_lg_u32 s3, s11
	s_cselect_b32 s11, -1, 0
	s_cmp_lt_i32 s3, 0
	s_cselect_b32 s3, -1, 0
	s_sub_co_i32 s0, s12, s0
	s_and_b32 s3, s3, s11
	s_add_co_i32 s0, s0, s10
	s_cmp_lg_u32 s3, 0
	s_sub_co_ci_u32 s0, s0, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_lshl_b32 s0, s0, 8
	s_sub_co_i32 s1, s1, s0
	s_add_co_i32 s2, s0, s2
	s_cmp_gt_i32 s1, 0
	v_med3_i32 v1, s1, 0, 0x100
	s_cselect_b32 s30, s2, 0
	s_mov_b32 s0, 1
	s_ashr_i32 s31, s30, 31
	s_cmp_eq_u32 s29, 0
	v_readfirstlane_b32 s33, v1
	s_mul_u64 s[2:3], s[24:25], s[30:31]
	s_cselect_b32 s39, -1, 0
	s_cmp_lg_u32 s29, 0
	s_add_nc_u64 s[6:7], s[6:7], s[2:3]
	s_cbranch_scc1 .LBB0_2
	s_cmp_lg_u32 s22, -2.0
	s_mov_b32 s1, s19
	s_cselect_b32 s17, s24, 0x80
	s_cselect_b32 s10, s25, 0
	s_max_i32 s11, s33, 0
	s_or_b32 s3, s7, 0x80000000
	s_lshl_b32 s12, s11, 16
	s_lshr_b32 s11, s11, 16
	s_mov_b32 s2, s6
	s_or_b32 s14, s12, 0x7fff
	s_or_b32 s15, s11, 0x800000
	s_and_b32 s18, s10, 0xffff
	s_mov_b32 s13, 0xffff0000
	s_mov_b32 s12, 0x7300000
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[0:3], s[12:19]
.LBB0_2:
	s_ashr_i32 s11, s23, 31
	s_mov_b32 s10, s23
	s_delay_alu instid0(SALU_CYCLE_1)
	s_lshl_b64 s[26:27], s[10:11], 1
	s_cmp_lg_u32 s36, s38
	s_cselect_b32 s0, -1, 0
	s_cmp_lt_i32 s36, 0
	s_cselect_b32 s1, -1, 0
	s_cmp_gt_i32 s35, 1
	s_cselect_b32 s2, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s1, s1, s2
	s_and_b32 s0, s1, s0
	s_sub_co_ci_u32 s0, s37, 0
	s_ashr_i32 s35, s34, 31
	s_lshl_b32 s2, s0, 8
	s_mul_u64 s[34:35], s[34:35], 0x1fa4000
	s_ashr_i32 s3, s2, 31
	s_sub_co_i32 s21, s21, s2
	s_add_nc_u64 s[0:1], s[8:9], s[34:35]
	s_cmp_eq_u32 s29, 1
	s_mul_u64 s[12:13], s[26:27], s[2:3]
	s_cselect_b32 s18, -1, 0
	s_cmp_lg_u32 s29, 1
	s_add_nc_u64 s[16:17], s[0:1], s[12:13]
	s_cbranch_scc1 .LBB0_4
	s_cmp_lg_u32 s10, -2.0
	s_mov_b32 s51, 0
	s_cselect_b32 s49, s26, 0x80
	s_cselect_b32 s0, s27, 0
	s_max_i32 s1, s21, 0
	s_or_b32 s15, s17, 0x80000000
	s_lshl_b32 s19, s1, 16
	s_lshr_b32 s1, s1, 16
	s_add_co_i32 s13, 0, 0x9000
	s_mov_b32 s12, 1
	s_mov_b32 s14, s16
	s_or_b32 s46, s19, 0x7fff
	s_or_b32 s47, s1, 0x800000
	s_and_b32 s50, s0, 0xffff
	s_movk_i32 s48, 0x100
	s_mov_b32 s45, 0xffff0000
	s_mov_b32 s44, 0x7300000
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[12:15], s[44:51]
.LBB0_4:
	v_cndmask_b32_e64 v1, 0, 1, s39
	s_and_not1_b32 vcc_lo, exec_lo, s39
	s_mov_b32 s12, 1
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_ne_u32_e64 s0, 1, v1
	s_cbranch_vccnz .LBB0_6
	s_cmp_lg_u32 s22, -2.0
	s_add_nc_u64 s[14:15], s[6:7], 0x80
	s_cselect_b32 s49, s24, 0x80
	s_cselect_b32 s1, s25, 0
	s_max_i32 s19, s33, 0
	s_mov_b32 s51, 0
	s_lshl_b32 s23, s19, 16
	s_lshr_b32 s19, s19, 16
	s_bitset1_b32 s15, 31
	s_add_co_i32 s13, 0, 0x12000
	s_or_b32 s46, s23, 0x7fff
	s_or_b32 s47, s19, 0x800000
	s_and_b32 s50, s1, 0xffff
	s_movk_i32 s48, 0x100
	s_mov_b32 s45, 0xffff0000
	s_mov_b32 s44, 0x7300000
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[12:15], s[44:51]
.LBB0_6:
	v_cndmask_b32_e64 v1, 0, 1, s18
	s_and_not1_b32 vcc_lo, exec_lo, s18
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_ne_u32_e64 s1, 1, v1
	s_cbranch_vccnz .LBB0_8
	s_cmp_lg_u32 s10, -2.0
	s_add_nc_u64 s[14:15], s[16:17], 0x80
	s_cselect_b32 s49, s26, 0x80
	s_cselect_b32 s16, s27, 0
	s_max_i32 s17, s21, 0
	s_mov_b32 s51, 0
	s_lshl_b32 s18, s17, 16
	s_lshr_b32 s17, s17, 16
	s_bitset1_b32 s15, 31
	s_add_co_i32 s13, 0, 0x1b000
	s_or_b32 s46, s18, 0x7fff
	s_or_b32 s47, s17, 0x800000
	s_and_b32 s50, s16, 0xffff
	s_movk_i32 s48, 0x100
	s_mov_b32 s45, 0xffff0000
	s_mov_b32 s44, 0x7300000
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[12:15], s[44:51]
.LBB0_8:
	s_ashr_i32 s12, s20, 31
	s_set_vgpr_msb 0xc0
	v_and_b32_e32 v13 /*v781*/, 15, v0
	s_lshr_b32 s12, s12, 26
	v_bfe_u32 v3 /*v771*/, v0, 4, 1
	s_add_co_i32 s12, s20, s12
	s_wait_tensorcnt 0x1
	s_and_b32 s13, s12, 0xffffffc0
	s_ashr_i32 s12, s12, 6
	s_cmp_lg_u32 s20, s13
	s_cselect_b32 s13, -1, 0
	s_cmp_lt_i32 s20, 0
	s_barrier_signal -1
	s_cselect_b32 s14, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s14, s13
	s_sub_co_ci_u32 s37, s12, 0
	s_lshl_b32 s12, s40, 1
	s_and_b32 s13, s12, 0xffffff80
	s_lshl_b32 s12, s29, 7
	s_set_vgpr_msb 0xc0cc
	v_or_b32_e32 v2 /*v770*/, s13, v13 /*v781*/
	s_and_b32 s36, s12, 0x80
	s_set_vgpr_msb 0xcc8c
	v_dual_lshlrev_b32 v6 /*v518*/, 4, v3 /*v771*/ :: v_dual_bitop2_b32 v5 /*v517*/, s36, v13 /*v781*/ bitop3:0x54
	s_set_vgpr_msb 0x8cc0
	v_or3_b32 v17 /*v785*/, v0, s13, 0x70
	s_set_vgpr_msb 0xc00c
	v_mul_lo_u32 v1, 0x90, v2 /*v770*/
	s_mov_b32 s12, 0
	s_set_vgpr_msb 0xcc8
	v_or_b32_e32 v15 /*v783*/, 0x9000, v6 /*v518*/
	s_cmp_gt_i32 s37, 2
	s_barrier_wait -1
	s_delay_alu instid0(VALU_DEP_2)
	v_add_nc_u32_e32 v12 /*v780*/, v1, v6 /*v518*/
	s_set_vgpr_msb 0xc8cc
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u32_e32 v16 /*v784*/, 64, v12 /*v780*/
	v_add_nc_u32_e32 v14 /*v782*/, 0x60, v12 /*v780*/
	s_set_vgpr_msb 0xcc00
	s_cbranch_scc1 .LBB0_10
	s_set_vgpr_msb 0x88
	v_or3_b32 v43 /*v555*/, v0, s13, 0x70
	v_or_b32_e32 v4 /*v516*/, 0x9000, v6 /*v518*/
	s_set_vgpr_msb 0x8828
	v_mad_u32_u24 v1, 0x90, v5 /*v517*/, v6 /*v518*/
	s_max_i32 s13, s21, 0
	s_set_vgpr_msb 0x288c
	v_dual_add_nc_u32 v2 /*v514*/, 64, v12 /*v780*/ :: v_dual_mov_b32 v42 /*v554*/, s13
	s_set_vgpr_msb 0x8ce8
	v_mad_u32 v9 /*v777*/, 0x90, v43 /*v555*/, v6 /*v518*/
	v_mad_u32_u24 v8 /*v776*/, 0x90, v5 /*v517*/, v4 /*v516*/
	s_lshl_b32 s14, s13, 16
	s_set_vgpr_msb 0xe88c
	v_add_nc_u32_e32 v3 /*v515*/, 0x60, v12 /*v780*/
	s_set_vgpr_msb 0x8cc0
	v_add_nc_u32_e32 v4 /*v772*/, 0x9040, v1
	v_add_nc_u32_e32 v5 /*v773*/, 0x9060, v1
	s_set_vgpr_msb 0xc0cc
	v_add_nc_u32_e32 v10 /*v778*/, 32, v8 /*v776*/
	s_set_vgpr_msb 0xcc00
	v_mov_b32_e32 v1, s14
	s_set_vgpr_msb 0xcc
	v_dual_add_nc_u32 v11 /*v779*/, 32, v9 /*v777*/ :: v_dual_add_nc_u32 v6 /*v774*/, 64, v9 /*v777*/
	v_add_nc_u32_e32 v7 /*v775*/, 0x60, v9 /*v777*/
	s_set_vgpr_msb 0xcc00
	s_branch .LBB0_11
.LBB0_10:
	s_mov_b32 s12, -1
.LBB0_11:
	v_mov_b32_e32 v9, 0
	s_add_co_i32 s29, s37, -2
	s_and_not1_b32 vcc_lo, exec_lo, s12
	s_delay_alu instid0(VALU_DEP_1)
	v_dual_mov_b32 v8, v9 :: v_dual_mov_b32 v7, v9
	v_dual_mov_b32 v6, v9 :: v_dual_mov_b32 v5, v9
	v_dual_mov_b32 v4, v9 :: v_dual_mov_b32 v3, v9
	v_dual_mov_b32 v2, v9 :: v_dual_mov_b32 v17, v9
	v_dual_mov_b32 v16, v9 :: v_dual_mov_b32 v15, v9
	v_dual_mov_b32 v14, v9 :: v_dual_mov_b32 v13, v9
	v_dual_mov_b32 v12, v9 :: v_dual_mov_b32 v11, v9
	v_dual_mov_b32 v10, v9 :: v_dual_mov_b32 v25, v9
	v_dual_mov_b32 v24, v9 :: v_dual_mov_b32 v23, v9
	v_dual_mov_b32 v22, v9 :: v_dual_mov_b32 v21, v9
	v_dual_mov_b32 v20, v9 :: v_dual_mov_b32 v19, v9
	v_dual_mov_b32 v18, v9 :: v_dual_mov_b32 v41, v9
	v_dual_mov_b32 v40, v9 :: v_dual_mov_b32 v39, v9
	v_dual_mov_b32 v38, v9 :: v_dual_mov_b32 v37, v9
	v_dual_mov_b32 v36, v9 :: v_dual_mov_b32 v35, v9
	v_dual_mov_b32 v34, v9 :: v_dual_mov_b32 v49, v9
	v_dual_mov_b32 v48, v9 :: v_dual_mov_b32 v47, v9
	v_dual_mov_b32 v46, v9 :: v_dual_mov_b32 v45, v9
	v_dual_mov_b32 v44, v9 :: v_dual_mov_b32 v43, v9
	v_dual_mov_b32 v42, v9 :: v_dual_mov_b32 v57, v9
	v_dual_mov_b32 v56, v9 :: v_dual_mov_b32 v55, v9
	v_dual_mov_b32 v54, v9 :: v_dual_mov_b32 v53, v9
	v_dual_mov_b32 v52, v9 :: v_dual_mov_b32 v51, v9
	v_dual_mov_b32 v50, v9 :: v_dual_mov_b32 v73, v9
	v_dual_mov_b32 v72, v9 :: v_dual_mov_b32 v71, v9
	v_dual_mov_b32 v70, v9 :: v_dual_mov_b32 v69, v9
	v_dual_mov_b32 v68, v9 :: v_dual_mov_b32 v67, v9
	v_dual_mov_b32 v66, v9 :: v_dual_mov_b32 v97, v9
	v_dual_mov_b32 v96, v9 :: v_dual_mov_b32 v95, v9
	v_dual_mov_b32 v94, v9 :: v_dual_mov_b32 v93, v9
	v_dual_mov_b32 v92, v9 :: v_dual_mov_b32 v91, v9
	v_dual_mov_b32 v90, v9 :: v_dual_mov_b32 v33, v9
	v_dual_mov_b32 v32, v9 :: v_dual_mov_b32 v31, v9
	v_dual_mov_b32 v30, v9 :: v_dual_mov_b32 v29, v9
	v_dual_mov_b32 v28, v9 :: v_dual_mov_b32 v27, v9
	v_dual_mov_b32 v26, v9 :: v_dual_mov_b32 v65, v9
	v_dual_mov_b32 v64, v9 :: v_dual_mov_b32 v63, v9
	v_dual_mov_b32 v62, v9 :: v_dual_mov_b32 v61, v9
	v_dual_mov_b32 v60, v9 :: v_dual_mov_b32 v59, v9
	v_dual_mov_b32 v58, v9 :: v_dual_mov_b32 v113, v9
	v_dual_mov_b32 v112, v9 :: v_dual_mov_b32 v111, v9
	v_dual_mov_b32 v110, v9 :: v_dual_mov_b32 v109, v9
	v_dual_mov_b32 v108, v9 :: v_dual_mov_b32 v107, v9
	v_dual_mov_b32 v106, v9 :: v_dual_mov_b32 v153, v9
	v_dual_mov_b32 v152, v9 :: v_dual_mov_b32 v151, v9
	v_dual_mov_b32 v150, v9 :: v_dual_mov_b32 v149, v9
	v_dual_mov_b32 v148, v9 :: v_dual_mov_b32 v147, v9
	v_dual_mov_b32 v146, v9 :: v_dual_mov_b32 v169, v9
	v_dual_mov_b32 v168, v9 :: v_dual_mov_b32 v167, v9
	v_dual_mov_b32 v166, v9 :: v_dual_mov_b32 v165, v9
	v_dual_mov_b32 v164, v9 :: v_dual_mov_b32 v163, v9
	v_dual_mov_b32 v162, v9 :: v_dual_mov_b32 v177, v9
	v_dual_mov_b32 v176, v9 :: v_dual_mov_b32 v175, v9
	v_dual_mov_b32 v174, v9 :: v_dual_mov_b32 v173, v9
	v_dual_mov_b32 v172, v9 :: v_dual_mov_b32 v171, v9
	v_dual_mov_b32 v170, v9 :: v_dual_mov_b32 v201, v9
	v_dual_mov_b32 v200, v9 :: v_dual_mov_b32 v199, v9
	v_dual_mov_b32 v198, v9 :: v_dual_mov_b32 v197, v9
	v_dual_mov_b32 v196, v9 :: v_dual_mov_b32 v195, v9
	v_dual_mov_b32 v194, v9 :: v_dual_mov_b32 v233, v9
	v_dual_mov_b32 v232, v9 :: v_dual_mov_b32 v231, v9
	v_dual_mov_b32 v230, v9 :: v_dual_mov_b32 v229, v9
	v_dual_mov_b32 v228, v9 :: v_dual_mov_b32 v227, v9
	v_dual_mov_b32 v226, v9 :: v_dual_mov_b32 v185, v9
	v_dual_mov_b32 v184, v9 :: v_dual_mov_b32 v183, v9
	v_dual_mov_b32 v182, v9 :: v_dual_mov_b32 v181, v9
	v_dual_mov_b32 v180, v9 :: v_dual_mov_b32 v179, v9
	v_dual_mov_b32 v178, v9 :: v_dual_mov_b32 v193, v9
	v_dual_mov_b32 v192, v9 :: v_dual_mov_b32 v191, v9
	v_dual_mov_b32 v190, v9 :: v_dual_mov_b32 v189, v9
	v_dual_mov_b32 v188, v9 :: v_dual_mov_b32 v187, v9
	v_dual_mov_b32 v186, v9 :: v_dual_mov_b32 v209, v9
	v_dual_mov_b32 v208, v9 :: v_dual_mov_b32 v207, v9
	v_dual_mov_b32 v206, v9 :: v_dual_mov_b32 v205, v9
	v_dual_mov_b32 v204, v9 :: v_dual_mov_b32 v203, v9
	v_dual_mov_b32 v202, v9 :: v_dual_mov_b32 v217, v9
	v_dual_mov_b32 v216, v9 :: v_dual_mov_b32 v215, v9
	v_dual_mov_b32 v214, v9 :: v_dual_mov_b32 v213, v9
	v_dual_mov_b32 v212, v9 :: v_dual_mov_b32 v211, v9
	v_dual_mov_b32 v210, v9 :: v_dual_mov_b32 v225, v9
	v_dual_mov_b32 v224, v9 :: v_dual_mov_b32 v223, v9
	v_dual_mov_b32 v222, v9 :: v_dual_mov_b32 v221, v9
	v_dual_mov_b32 v220, v9 :: v_dual_mov_b32 v219, v9
	v_dual_mov_b32 v218, v9 :: v_dual_mov_b32 v241, v9
	v_dual_mov_b32 v240, v9 :: v_dual_mov_b32 v239, v9
	v_dual_mov_b32 v238, v9 :: v_dual_mov_b32 v237, v9
	v_dual_mov_b32 v236, v9 :: v_dual_mov_b32 v235, v9
	v_dual_mov_b32 v234, v9 :: v_dual_mov_b32 v249, v9
	v_dual_mov_b32 v248, v9 :: v_dual_mov_b32 v247, v9
	v_dual_mov_b32 v246, v9 :: v_dual_mov_b32 v245, v9
	v_dual_mov_b32 v244, v9 :: v_dual_mov_b32 v243, v9
	v_mov_b32_e32 v242, v9
	s_set_vgpr_msb 64
	v_dual_mov_b32 v65 /*v321*/, v9 :: v_dual_mov_b32 v64 /*v320*/, v9
	v_dual_mov_b32 v63 /*v319*/, v9 :: v_dual_mov_b32 v62 /*v318*/, v9
	v_dual_mov_b32 v61 /*v317*/, v9 :: v_dual_mov_b32 v60 /*v316*/, v9
	v_dual_mov_b32 v59 /*v315*/, v9 :: v_dual_mov_b32 v58 /*v314*/, v9
	v_dual_mov_b32 v1 /*v257*/, v9 :: v_dual_mov_b32 v0 /*v256*/, v9
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v255, v9 :: v_dual_mov_b32 v254, v9
	v_dual_mov_b32 v253, v9 :: v_dual_mov_b32 v252, v9
	v_dual_mov_b32 v251, v9 :: v_dual_mov_b32 v250, v9
	v_mov_b32_e32 v81, v9
	s_set_vgpr_msb 64
	v_dual_mov_b32 v9 /*v265*/, v9 :: v_dual_mov_b32 v8 /*v264*/, v9
	v_dual_mov_b32 v7 /*v263*/, v9 :: v_dual_mov_b32 v6 /*v262*/, v9
	v_dual_mov_b32 v5 /*v261*/, v9 :: v_dual_mov_b32 v4 /*v260*/, v9
	v_dual_mov_b32 v3 /*v259*/, v9 :: v_dual_mov_b32 v2 /*v258*/, v9
	v_dual_mov_b32 v17 /*v273*/, v9 :: v_dual_mov_b32 v16 /*v272*/, v9
	v_dual_mov_b32 v15 /*v271*/, v9 :: v_dual_mov_b32 v14 /*v270*/, v9
	v_dual_mov_b32 v13 /*v269*/, v9 :: v_dual_mov_b32 v12 /*v268*/, v9
	v_dual_mov_b32 v11 /*v267*/, v9 :: v_dual_mov_b32 v10 /*v266*/, v9
	v_dual_mov_b32 v25 /*v281*/, v9 :: v_dual_mov_b32 v24 /*v280*/, v9
	v_dual_mov_b32 v23 /*v279*/, v9 :: v_dual_mov_b32 v22 /*v278*/, v9
	v_dual_mov_b32 v21 /*v277*/, v9 :: v_dual_mov_b32 v20 /*v276*/, v9
	v_dual_mov_b32 v19 /*v275*/, v9 :: v_dual_mov_b32 v18 /*v274*/, v9
	v_dual_mov_b32 v33 /*v289*/, v9 :: v_dual_mov_b32 v32 /*v288*/, v9
	v_dual_mov_b32 v31 /*v287*/, v9 :: v_dual_mov_b32 v30 /*v286*/, v9
	v_dual_mov_b32 v29 /*v285*/, v9 :: v_dual_mov_b32 v28 /*v284*/, v9
	v_dual_mov_b32 v27 /*v283*/, v9 :: v_dual_mov_b32 v26 /*v282*/, v9
	v_dual_mov_b32 v41 /*v297*/, v9 :: v_dual_mov_b32 v40 /*v296*/, v9
	v_dual_mov_b32 v39 /*v295*/, v9 :: v_dual_mov_b32 v38 /*v294*/, v9
	v_dual_mov_b32 v37 /*v293*/, v9 :: v_dual_mov_b32 v36 /*v292*/, v9
	v_dual_mov_b32 v35 /*v291*/, v9 :: v_dual_mov_b32 v34 /*v290*/, v9
	v_dual_mov_b32 v49 /*v305*/, v9 :: v_dual_mov_b32 v48 /*v304*/, v9
	v_dual_mov_b32 v47 /*v303*/, v9 :: v_dual_mov_b32 v46 /*v302*/, v9
	v_dual_mov_b32 v45 /*v301*/, v9 :: v_dual_mov_b32 v44 /*v300*/, v9
	v_dual_mov_b32 v43 /*v299*/, v9 :: v_dual_mov_b32 v42 /*v298*/, v9
	v_dual_mov_b32 v57 /*v313*/, v9 :: v_dual_mov_b32 v56 /*v312*/, v9
	v_dual_mov_b32 v55 /*v311*/, v9 :: v_dual_mov_b32 v54 /*v310*/, v9
	v_dual_mov_b32 v53 /*v309*/, v9 :: v_dual_mov_b32 v52 /*v308*/, v9
	v_dual_mov_b32 v51 /*v307*/, v9 :: v_dual_mov_b32 v50 /*v306*/, v9
	v_dual_mov_b32 v73 /*v329*/, v9 :: v_dual_mov_b32 v72 /*v328*/, v9
	v_dual_mov_b32 v71 /*v327*/, v9 :: v_dual_mov_b32 v70 /*v326*/, v9
	v_dual_mov_b32 v69 /*v325*/, v9 :: v_dual_mov_b32 v68 /*v324*/, v9
	v_dual_mov_b32 v67 /*v323*/, v9 :: v_dual_mov_b32 v66 /*v322*/, v9
	v_dual_mov_b32 v81 /*v337*/, v9 :: v_dual_mov_b32 v80 /*v336*/, v9
	v_dual_mov_b32 v79 /*v335*/, v9 :: v_dual_mov_b32 v78 /*v334*/, v9
	v_dual_mov_b32 v77 /*v333*/, v9 :: v_dual_mov_b32 v76 /*v332*/, v9
	v_dual_mov_b32 v75 /*v331*/, v9 :: v_dual_mov_b32 v74 /*v330*/, v9
	v_dual_mov_b32 v89 /*v345*/, v9 :: v_dual_mov_b32 v88 /*v344*/, v9
	v_dual_mov_b32 v87 /*v343*/, v9 :: v_dual_mov_b32 v86 /*v342*/, v9
	v_dual_mov_b32 v85 /*v341*/, v9 :: v_dual_mov_b32 v84 /*v340*/, v9
	v_dual_mov_b32 v83 /*v339*/, v9 :: v_dual_mov_b32 v82 /*v338*/, v9
	v_dual_mov_b32 v105 /*v361*/, v9 :: v_dual_mov_b32 v104 /*v360*/, v9
	v_dual_mov_b32 v103 /*v359*/, v9 :: v_dual_mov_b32 v102 /*v358*/, v9
	v_dual_mov_b32 v101 /*v357*/, v9 :: v_dual_mov_b32 v100 /*v356*/, v9
	v_dual_mov_b32 v99 /*v355*/, v9 :: v_dual_mov_b32 v98 /*v354*/, v9
	v_dual_mov_b32 v113 /*v369*/, v9 :: v_dual_mov_b32 v112 /*v368*/, v9
	v_dual_mov_b32 v111 /*v367*/, v9 :: v_dual_mov_b32 v110 /*v366*/, v9
	v_dual_mov_b32 v109 /*v365*/, v9 :: v_dual_mov_b32 v108 /*v364*/, v9
	v_dual_mov_b32 v107 /*v363*/, v9 :: v_dual_mov_b32 v106 /*v362*/, v9
	v_dual_mov_b32 v121 /*v377*/, v9 :: v_dual_mov_b32 v120 /*v376*/, v9
	v_dual_mov_b32 v119 /*v375*/, v9 :: v_dual_mov_b32 v118 /*v374*/, v9
	v_dual_mov_b32 v117 /*v373*/, v9 :: v_dual_mov_b32 v116 /*v372*/, v9
	v_dual_mov_b32 v115 /*v371*/, v9 :: v_dual_mov_b32 v114 /*v370*/, v9
	v_dual_mov_b32 v137 /*v393*/, v9 :: v_dual_mov_b32 v136 /*v392*/, v9
	v_dual_mov_b32 v135 /*v391*/, v9 :: v_dual_mov_b32 v134 /*v390*/, v9
	v_dual_mov_b32 v133 /*v389*/, v9 :: v_dual_mov_b32 v132 /*v388*/, v9
	v_dual_mov_b32 v131 /*v387*/, v9 :: v_dual_mov_b32 v130 /*v386*/, v9
	v_dual_mov_b32 v145 /*v401*/, v9 :: v_dual_mov_b32 v144 /*v400*/, v9
	v_dual_mov_b32 v143 /*v399*/, v9 :: v_dual_mov_b32 v142 /*v398*/, v9
	v_dual_mov_b32 v141 /*v397*/, v9 :: v_dual_mov_b32 v140 /*v396*/, v9
	v_dual_mov_b32 v139 /*v395*/, v9 :: v_dual_mov_b32 v138 /*v394*/, v9
	v_dual_mov_b32 v97 /*v353*/, v9 :: v_dual_mov_b32 v96 /*v352*/, v9
	v_dual_mov_b32 v95 /*v351*/, v9 :: v_dual_mov_b32 v94 /*v350*/, v9
	v_dual_mov_b32 v93 /*v349*/, v9 :: v_dual_mov_b32 v92 /*v348*/, v9
	v_dual_mov_b32 v91 /*v347*/, v9 :: v_dual_mov_b32 v90 /*v346*/, v9
	v_dual_mov_b32 v129 /*v385*/, v9 :: v_dual_mov_b32 v128 /*v384*/, v9
	v_dual_mov_b32 v127 /*v383*/, v9 :: v_dual_mov_b32 v126 /*v382*/, v9
	v_dual_mov_b32 v125 /*v381*/, v9 :: v_dual_mov_b32 v124 /*v380*/, v9
	v_dual_mov_b32 v123 /*v379*/, v9 :: v_dual_mov_b32 v122 /*v378*/, v9
	v_dual_mov_b32 v153 /*v409*/, v9 :: v_dual_mov_b32 v152 /*v408*/, v9
	v_dual_mov_b32 v151 /*v407*/, v9 :: v_dual_mov_b32 v150 /*v406*/, v9
	v_dual_mov_b32 v149 /*v405*/, v9 :: v_dual_mov_b32 v148 /*v404*/, v9
	v_dual_mov_b32 v147 /*v403*/, v9 :: v_dual_mov_b32 v146 /*v402*/, v9
	v_dual_mov_b32 v161 /*v417*/, v9 :: v_dual_mov_b32 v160 /*v416*/, v9
	v_dual_mov_b32 v159 /*v415*/, v9 :: v_dual_mov_b32 v158 /*v414*/, v9
	v_dual_mov_b32 v157 /*v413*/, v9 :: v_dual_mov_b32 v156 /*v412*/, v9
	v_dual_mov_b32 v155 /*v411*/, v9 :: v_dual_mov_b32 v154 /*v410*/, v9
	v_dual_mov_b32 v169 /*v425*/, v9 :: v_dual_mov_b32 v168 /*v424*/, v9
	v_dual_mov_b32 v167 /*v423*/, v9 :: v_dual_mov_b32 v166 /*v422*/, v9
	v_dual_mov_b32 v165 /*v421*/, v9 :: v_dual_mov_b32 v164 /*v420*/, v9
	v_dual_mov_b32 v163 /*v419*/, v9 :: v_dual_mov_b32 v162 /*v418*/, v9
	v_dual_mov_b32 v177 /*v433*/, v9 :: v_dual_mov_b32 v176 /*v432*/, v9
	v_dual_mov_b32 v175 /*v431*/, v9 :: v_dual_mov_b32 v174 /*v430*/, v9
	v_dual_mov_b32 v173 /*v429*/, v9 :: v_dual_mov_b32 v172 /*v428*/, v9
	v_dual_mov_b32 v171 /*v427*/, v9 :: v_dual_mov_b32 v170 /*v426*/, v9
	v_dual_mov_b32 v201 /*v457*/, v9 :: v_dual_mov_b32 v200 /*v456*/, v9
	v_dual_mov_b32 v199 /*v455*/, v9 :: v_dual_mov_b32 v198 /*v454*/, v9
	v_dual_mov_b32 v197 /*v453*/, v9 :: v_dual_mov_b32 v196 /*v452*/, v9
	v_dual_mov_b32 v195 /*v451*/, v9 :: v_dual_mov_b32 v194 /*v450*/, v9
	v_dual_mov_b32 v233 /*v489*/, v9 :: v_dual_mov_b32 v232 /*v488*/, v9
	v_dual_mov_b32 v231 /*v487*/, v9 :: v_dual_mov_b32 v230 /*v486*/, v9
	v_dual_mov_b32 v229 /*v485*/, v9 :: v_dual_mov_b32 v228 /*v484*/, v9
	v_dual_mov_b32 v227 /*v483*/, v9 :: v_dual_mov_b32 v226 /*v482*/, v9
	v_dual_mov_b32 v185 /*v441*/, v9 :: v_dual_mov_b32 v184 /*v440*/, v9
	v_dual_mov_b32 v183 /*v439*/, v9 :: v_dual_mov_b32 v182 /*v438*/, v9
	v_dual_mov_b32 v181 /*v437*/, v9 :: v_dual_mov_b32 v180 /*v436*/, v9
	v_dual_mov_b32 v179 /*v435*/, v9 :: v_dual_mov_b32 v178 /*v434*/, v9
	v_dual_mov_b32 v193 /*v449*/, v9 :: v_dual_mov_b32 v192 /*v448*/, v9
	v_dual_mov_b32 v191 /*v447*/, v9 :: v_dual_mov_b32 v190 /*v446*/, v9
	v_dual_mov_b32 v189 /*v445*/, v9 :: v_dual_mov_b32 v188 /*v444*/, v9
	v_dual_mov_b32 v187 /*v443*/, v9 :: v_dual_mov_b32 v186 /*v442*/, v9
	v_dual_mov_b32 v209 /*v465*/, v9 :: v_dual_mov_b32 v208 /*v464*/, v9
	v_dual_mov_b32 v207 /*v463*/, v9 :: v_dual_mov_b32 v206 /*v462*/, v9
	v_dual_mov_b32 v205 /*v461*/, v9 :: v_dual_mov_b32 v204 /*v460*/, v9
	v_dual_mov_b32 v203 /*v459*/, v9 :: v_dual_mov_b32 v202 /*v458*/, v9
	v_dual_mov_b32 v217 /*v473*/, v9 :: v_dual_mov_b32 v216 /*v472*/, v9
	v_dual_mov_b32 v215 /*v471*/, v9 :: v_dual_mov_b32 v214 /*v470*/, v9
	v_dual_mov_b32 v213 /*v469*/, v9 :: v_dual_mov_b32 v212 /*v468*/, v9
	v_dual_mov_b32 v211 /*v467*/, v9 :: v_dual_mov_b32 v210 /*v466*/, v9
	v_dual_mov_b32 v225 /*v481*/, v9 :: v_dual_mov_b32 v224 /*v480*/, v9
	v_dual_mov_b32 v223 /*v479*/, v9 :: v_dual_mov_b32 v222 /*v478*/, v9
	v_dual_mov_b32 v221 /*v477*/, v9 :: v_dual_mov_b32 v220 /*v476*/, v9
	v_dual_mov_b32 v219 /*v475*/, v9 :: v_dual_mov_b32 v218 /*v474*/, v9
	v_dual_mov_b32 v241 /*v497*/, v9 :: v_dual_mov_b32 v240 /*v496*/, v9
	v_dual_mov_b32 v239 /*v495*/, v9 :: v_dual_mov_b32 v238 /*v494*/, v9
	v_dual_mov_b32 v237 /*v493*/, v9 :: v_dual_mov_b32 v236 /*v492*/, v9
	v_dual_mov_b32 v235 /*v491*/, v9 :: v_dual_mov_b32 v234 /*v490*/, v9
	v_dual_mov_b32 v249 /*v505*/, v9 :: v_dual_mov_b32 v248 /*v504*/, v9
	v_dual_mov_b32 v247 /*v503*/, v9 :: v_dual_mov_b32 v246 /*v502*/, v9
	v_dual_mov_b32 v245 /*v501*/, v9 :: v_dual_mov_b32 v244 /*v500*/, v9
	v_dual_mov_b32 v243 /*v499*/, v9 :: v_dual_mov_b32 v242 /*v498*/, v9
	s_set_vgpr_msb 0x4080
	v_dual_mov_b32 v1 /*v513*/, v9 :: v_dual_mov_b32 v0 /*v512*/, v9
	s_set_vgpr_msb 0x8040
	v_dual_mov_b32 v255 /*v511*/, v9 :: v_dual_mov_b32 v254 /*v510*/, v9
	v_dual_mov_b32 v253 /*v509*/, v9 :: v_dual_mov_b32 v252 /*v508*/, v9
	v_dual_mov_b32 v251 /*v507*/, v9 :: v_dual_mov_b32 v250 /*v506*/, v9
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v80, v9 :: v_dual_mov_b32 v79, v9
	v_dual_mov_b32 v78, v9 :: v_dual_mov_b32 v77, v9
	v_dual_mov_b32 v76, v9 :: v_dual_mov_b32 v75, v9
	v_dual_mov_b32 v74, v9 :: v_dual_mov_b32 v89, v9
	v_dual_mov_b32 v88, v9 :: v_dual_mov_b32 v87, v9
	v_dual_mov_b32 v86, v9 :: v_dual_mov_b32 v85, v9
	v_dual_mov_b32 v84, v9 :: v_dual_mov_b32 v83, v9
	v_dual_mov_b32 v82, v9 :: v_dual_mov_b32 v105, v9
	v_dual_mov_b32 v104, v9 :: v_dual_mov_b32 v103, v9
	v_dual_mov_b32 v102, v9 :: v_dual_mov_b32 v101, v9
	v_dual_mov_b32 v100, v9 :: v_dual_mov_b32 v99, v9
	v_dual_mov_b32 v98, v9 :: v_dual_mov_b32 v121, v9
	v_dual_mov_b32 v120, v9 :: v_dual_mov_b32 v119, v9
	v_dual_mov_b32 v118, v9 :: v_dual_mov_b32 v117, v9
	v_dual_mov_b32 v116, v9 :: v_dual_mov_b32 v115, v9
	v_dual_mov_b32 v114, v9 :: v_dual_mov_b32 v129, v9
	v_dual_mov_b32 v128, v9 :: v_dual_mov_b32 v127, v9
	v_dual_mov_b32 v126, v9 :: v_dual_mov_b32 v125, v9
	v_dual_mov_b32 v124, v9 :: v_dual_mov_b32 v123, v9
	v_dual_mov_b32 v122, v9 :: v_dual_mov_b32 v137, v9
	v_dual_mov_b32 v136, v9 :: v_dual_mov_b32 v135, v9
	v_dual_mov_b32 v134, v9 :: v_dual_mov_b32 v133, v9
	v_dual_mov_b32 v132, v9 :: v_dual_mov_b32 v131, v9
	v_dual_mov_b32 v130, v9 :: v_dual_mov_b32 v145, v9
	v_dual_mov_b32 v144, v9 :: v_dual_mov_b32 v143, v9
	v_dual_mov_b32 v142, v9 :: v_dual_mov_b32 v141, v9
	v_dual_mov_b32 v140, v9 :: v_dual_mov_b32 v139, v9
	v_dual_mov_b32 v138, v9 :: v_dual_mov_b32 v161, v9
	v_dual_mov_b32 v160, v9 :: v_dual_mov_b32 v159, v9
	v_dual_mov_b32 v158, v9 :: v_dual_mov_b32 v157, v9
	v_dual_mov_b32 v156, v9 :: v_dual_mov_b32 v155, v9
	v_mov_b32_e32 v154, v9
	s_cbranch_vccnz .LBB0_19
	s_cmp_lg_u32 s22, -2.0
	v_or3_b32 v2, v0, s36, 0x70
	s_cselect_b32 s17, s24, 0x80
	s_cselect_b32 s12, s25, 0
	s_max_i32 s13, s33, 0
	s_and_b32 s18, s12, 0xffff
	s_lshl_b32 s14, s13, 16
	s_lshr_b32 s13, s13, 16
	s_addk_co_i32 s14, 0x7fff
	s_or_b32 s15, s13, 0x800000
	s_cmp_lg_u32 s10, -2.0
	s_mul_u64 s[10:11], s[10:11], s[2:3]
	s_cselect_b32 s43, s26, 0x80
	s_cselect_b32 s20, s27, 0
	s_lshl_b64 s[10:11], s[10:11], 1
	s_mov_b32 s41, 0x9040
	s_add_nc_u64 s[10:11], s[8:9], s[10:11]
	s_mov_b32 s9, 0x9020
	s_add_nc_u64 s[10:11], s[10:11], s[34:35]
	v_mad_u32_u24 v0, 0x90, v2, s9
	s_set_vgpr_msb 0xc8
	v_mad_u32_u24 v23 /*v791*/, 0x90, v5 /*v517*/, s9
	s_mov_b32 s9, 0x9900
	s_mov_b32 s42, 0x9000
	v_mad_u32_u24 v24 /*v792*/, 0x90, v5 /*v517*/, s9
	s_mov_b32 s9, 0xa200
	s_add_nc_u64 s[34:35], s[10:11], 0x100
	v_mad_u32_u24 v26 /*v794*/, 0x90, v5 /*v517*/, s9
	s_mov_b32 s9, 0xab00
	s_mov_b32 s10, 0x9060
	v_mad_u32_u24 v28 /*v796*/, 0x90, v5 /*v517*/, s9
	s_mov_b32 s9, 0xb400
	s_set_vgpr_msb 0xc80c
	v_mul_lo_u32 v1, 0x90, v17 /*v785*/
	s_set_vgpr_msb 0xcc8
	v_mad_u32_u24 v30 /*v798*/, 0x90, v5 /*v517*/, s9
	s_mov_b32 s9, 0xbd00
	s_set_vgpr_msb 0xc8c0
	v_mad_u32_u24 v20 /*v788*/, 0x90, v2, s41
	s_set_vgpr_msb 0xc0c8
	v_mad_u32_u24 v32 /*v800*/, 0x90, v5 /*v517*/, s9
	s_mov_b32 s9, 0xc600
	s_set_vgpr_msb 0xc8c0
	v_mad_u32_u24 v21 /*v789*/, 0x90, v2, s10
	s_set_vgpr_msb 0xc0c8
	v_mad_u32_u24 v34 /*v802*/, 0x90, v5 /*v517*/, s9
	s_mov_b32 s9, 0x9940
	s_set_vgpr_msb 0xc8c0
	v_mad_u32_u24 v22 /*v790*/, 0x90, v2, s42
	s_set_vgpr_msb 0xc0c8
	v_mad_u32_u24 v37 /*v805*/, 0x90, v5 /*v517*/, s9
	s_mov_b32 s9, 0xa240
	s_set_vgpr_msb 0xc80c
	v_mul_u32_u24_e32 v2, 0x90, v13 /*v781*/
	s_set_vgpr_msb 0xcc8
	v_mad_u32_u24 v39 /*v807*/, 0x90, v5 /*v517*/, s9
	s_mov_b32 s9, 0xab40
	s_mov_b32 s11, 0x9920
	v_mad_u32_u24 v41 /*v809*/, 0x90, v5 /*v517*/, s9
	s_mov_b32 s9, 0xb440
	v_mad_u32_u24 v36 /*v804*/, 0x90, v5 /*v517*/, s10
	s_mov_b32 s10, 0x9960
	v_mad_u32_u24 v43 /*v811*/, 0x90, v5 /*v517*/, s9
	s_mov_b32 s9, 0xbd40
	v_mad_u32_u24 v18 /*v786*/, 0x90, v5 /*v517*/, s41
	v_mad_u32_u24 v25 /*v793*/, 0x90, v5 /*v517*/, s11
	s_mov_b32 s11, 0xa220
	v_mad_u32_u24 v38 /*v806*/, 0x90, v5 /*v517*/, s10
	s_mov_b32 s10, 0xa260
	v_mad_u32_u24 v45 /*v813*/, 0x90, v5 /*v517*/, s9
	s_lshr_b32 s9, s40, 6
	v_mad_u32_u24 v27 /*v795*/, 0x90, v5 /*v517*/, s11
	s_mov_b32 s11, 0xab20
	v_mad_u32_u24 v40 /*v808*/, 0x90, v5 /*v517*/, s10
	s_mov_b32 s10, 0xab60
	v_mad_u32 v47 /*v815*/, 0x4800, s9, v2
	v_mad_u32_u24 v29 /*v797*/, 0x90, v5 /*v517*/, s11
	s_mov_b32 s11, 0xb420
	v_mad_u32_u24 v42 /*v810*/, 0x90, v5 /*v517*/, s10
	s_mov_b32 s10, 0xb460
	s_set_vgpr_msb 0xc8fb
	v_mad_u32_u24 v8 /*v776*/, 0x90, v5 /*v517*/, v15 /*v783*/
	v_dual_add_nc_u32 v4 /*v772*/, v18 /*v786*/, v6 /*v518*/ :: v_dual_add_nc_u32 v19 /*v787*/, 0, v6 /*v518*/
	s_set_vgpr_msb 0xfbc8
	v_add_nc_u32_e32 v9 /*v777*/, v1, v6 /*v518*/
	s_set_vgpr_msb 0xc800
	v_mov_b32_e32 v2, 0
	s_set_vgpr_msb 0xc8
	v_mad_u32_u24 v31 /*v799*/, 0x90, v5 /*v517*/, s11
	s_mov_b32 s11, 0xbd20
	v_mad_u32_u24 v44 /*v812*/, 0x90, v5 /*v517*/, s10
	s_mov_b32 s10, 0xbd60
	s_max_i32 s38, s21, 0
	v_mad_u32_u24 v33 /*v801*/, 0x90, v5 /*v517*/, s11
	s_mov_b32 s11, 0xc620
	v_mad_u32_u24 v46 /*v814*/, 0x90, v5 /*v517*/, s10
	s_mov_b32 s10, 0xc640
	s_mov_b32 s9, 0xc660
	s_mov_b32 s19, 0
	s_lshl_b32 s39, s38, 16
	s_set_vgpr_msb 0xc8cc
	v_dual_add_nc_u32 v10 /*v778*/, 32, v8 /*v776*/ :: v_dual_add_nc_u32 v11 /*v779*/, 32, v9 /*v777*/
	s_lshr_b32 s21, s38, 16
	v_dual_add_nc_u32 v5 /*v773*/, 32, v4 /*v772*/ :: v_dual_add_nc_u32 v6 /*v774*/, 64, v9 /*v777*/
	v_add_nc_u32_e32 v7 /*v775*/, 0x60, v9 /*v777*/
	s_movk_i32 s16, 0x100
	s_set_vgpr_msb 0xccc8
	v_mad_u32_u24 v35 /*v803*/, 0x90, v5 /*v517*/, s11
	v_mad_u32_u24 v48 /*v816*/, 0x90, v5 /*v517*/, s10
	v_mad_u32_u24 v49 /*v817*/, 0x90, v5 /*v517*/, s9
	v_mad_u32_u24 v50 /*v818*/, 0x90, v5 /*v517*/, s42
	s_set_vgpr_msb 0xc8c0
	v_dual_add_nc_u32 v51 /*v819*/, 32, v1 :: v_dual_add_nc_u32 v53 /*v821*/, 64, v1
	v_add_nc_u32_e32 v52 /*v820*/, 0x60, v1
	s_set_vgpr_msb 0xc0cc
	v_dual_add_nc_u32 v54 /*v822*/, 32, v47 /*v815*/ :: v_dual_add_nc_u32 v67 /*v835*/, 64, v47 /*v815*/
	v_add_nc_u32_e32 v55 /*v823*/, 0x900, v47 /*v815*/
	v_add_nc_u32_e32 v56 /*v824*/, 0x920, v47 /*v815*/
	v_add_nc_u32_e32 v57 /*v825*/, 0x1200, v47 /*v815*/
	v_add_nc_u32_e32 v58 /*v826*/, 0x1220, v47 /*v815*/
	v_add_nc_u32_e32 v59 /*v827*/, 0x1b00, v47 /*v815*/
	v_add_nc_u32_e32 v60 /*v828*/, 0x1b20, v47 /*v815*/
	v_add_nc_u32_e32 v61 /*v829*/, 0x2400, v47 /*v815*/
	v_add_nc_u32_e32 v62 /*v830*/, 0x2420, v47 /*v815*/
	v_add_nc_u32_e32 v63 /*v831*/, 0x2d00, v47 /*v815*/
	v_add_nc_u32_e32 v64 /*v832*/, 0x2d20, v47 /*v815*/
	v_add_nc_u32_e32 v65 /*v833*/, 0x3600, v47 /*v815*/
	v_add_nc_u32_e32 v66 /*v834*/, 0x3620, v47 /*v815*/
	v_add_nc_u32_e32 v68 /*v836*/, 0x60, v47 /*v815*/
	v_add_nc_u32_e32 v69 /*v837*/, 0x940, v47 /*v815*/
	v_add_nc_u32_e32 v70 /*v838*/, 0x960, v47 /*v815*/
	v_add_nc_u32_e32 v71 /*v839*/, 0x1240, v47 /*v815*/
	v_add_nc_u32_e32 v72 /*v840*/, 0x1260, v47 /*v815*/
	v_add_nc_u32_e32 v73 /*v841*/, 0x1b40, v47 /*v815*/
	v_add_nc_u32_e32 v74 /*v842*/, 0x1b60, v47 /*v815*/
	v_add_nc_u32_e32 v75 /*v843*/, 0x2440, v47 /*v815*/
	v_add_nc_u32_e32 v76 /*v844*/, 0x2460, v47 /*v815*/
	v_add_nc_u32_e32 v77 /*v845*/, 0x2d40, v47 /*v815*/
	v_add_nc_u32_e32 v78 /*v846*/, 0x2d60, v47 /*v815*/
	v_add_nc_u32_e32 v79 /*v847*/, 0x3640, v47 /*v815*/
	v_add_nc_u32_e32 v80 /*v848*/, 0x3660, v47 /*v815*/
	s_set_vgpr_msb 0xcc00
	v_dual_mov_b32 v3, v2 :: v_dual_mov_b32 v4, v2
	v_dual_mov_b32 v5, v2 :: v_dual_mov_b32 v6, v2
	v_dual_mov_b32 v7, v2 :: v_dual_mov_b32 v8, v2
	v_dual_mov_b32 v9, v2 :: v_dual_mov_b32 v10, v2
	v_dual_mov_b32 v11, v2 :: v_dual_mov_b32 v12, v2
	v_dual_mov_b32 v13, v2 :: v_dual_mov_b32 v14, v2
	v_dual_mov_b32 v15, v2 :: v_dual_mov_b32 v16, v2
	v_dual_mov_b32 v17, v2 :: v_dual_mov_b32 v18, v2
	v_dual_mov_b32 v19, v2 :: v_dual_mov_b32 v20, v2
	v_dual_mov_b32 v21, v2 :: v_dual_mov_b32 v22, v2
	v_dual_mov_b32 v23, v2 :: v_dual_mov_b32 v24, v2
	v_dual_mov_b32 v25, v2 :: v_dual_mov_b32 v34, v2
	v_dual_mov_b32 v35, v2 :: v_dual_mov_b32 v36, v2
	v_dual_mov_b32 v37, v2 :: v_dual_mov_b32 v38, v2
	v_dual_mov_b32 v39, v2 :: v_dual_mov_b32 v40, v2
	v_dual_mov_b32 v41, v2 :: v_dual_mov_b32 v42, v2
	v_dual_mov_b32 v43, v2 :: v_dual_mov_b32 v44, v2
	v_dual_mov_b32 v45, v2 :: v_dual_mov_b32 v46, v2
	v_dual_mov_b32 v47, v2 :: v_dual_mov_b32 v48, v2
	v_dual_mov_b32 v49, v2 :: v_dual_mov_b32 v50, v2
	v_dual_mov_b32 v51, v2 :: v_dual_mov_b32 v52, v2
	v_dual_mov_b32 v53, v2 :: v_dual_mov_b32 v54, v2
	v_dual_mov_b32 v55, v2 :: v_dual_mov_b32 v56, v2
	v_dual_mov_b32 v57, v2 :: v_dual_mov_b32 v66, v2
	v_dual_mov_b32 v67, v2 :: v_dual_mov_b32 v68, v2
	v_dual_mov_b32 v69, v2 :: v_dual_mov_b32 v70, v2
	v_dual_mov_b32 v71, v2 :: v_dual_mov_b32 v72, v2
	v_dual_mov_b32 v73, v2 :: v_dual_mov_b32 v90, v2
	v_dual_mov_b32 v91, v2 :: v_dual_mov_b32 v92, v2
	v_dual_mov_b32 v93, v2 :: v_dual_mov_b32 v94, v2
	v_dual_mov_b32 v95, v2 :: v_dual_mov_b32 v96, v2
	v_dual_mov_b32 v97, v2 :: v_dual_mov_b32 v26, v2
	v_dual_mov_b32 v27, v2 :: v_dual_mov_b32 v28, v2
	v_dual_mov_b32 v29, v2 :: v_dual_mov_b32 v30, v2
	v_dual_mov_b32 v31, v2 :: v_dual_mov_b32 v32, v2
	v_dual_mov_b32 v33, v2 :: v_dual_mov_b32 v58, v2
	v_dual_mov_b32 v59, v2 :: v_dual_mov_b32 v60, v2
	v_dual_mov_b32 v61, v2 :: v_dual_mov_b32 v62, v2
	v_dual_mov_b32 v63, v2 :: v_dual_mov_b32 v64, v2
	v_dual_mov_b32 v65, v2 :: v_dual_mov_b32 v106, v2
	v_dual_mov_b32 v107, v2 :: v_dual_mov_b32 v108, v2
	v_dual_mov_b32 v109, v2 :: v_dual_mov_b32 v110, v2
	v_dual_mov_b32 v111, v2 :: v_dual_mov_b32 v112, v2
	v_dual_mov_b32 v113, v2 :: v_dual_mov_b32 v146, v2
	v_dual_mov_b32 v147, v2 :: v_dual_mov_b32 v148, v2
	v_dual_mov_b32 v149, v2 :: v_dual_mov_b32 v150, v2
	v_dual_mov_b32 v151, v2 :: v_dual_mov_b32 v152, v2
	v_dual_mov_b32 v153, v2 :: v_dual_mov_b32 v162, v2
	v_dual_mov_b32 v163, v2 :: v_dual_mov_b32 v164, v2
	v_dual_mov_b32 v165, v2 :: v_dual_mov_b32 v166, v2
	v_dual_mov_b32 v167, v2 :: v_dual_mov_b32 v168, v2
	v_dual_mov_b32 v169, v2 :: v_dual_mov_b32 v170, v2
	v_dual_mov_b32 v171, v2 :: v_dual_mov_b32 v172, v2
	v_dual_mov_b32 v173, v2 :: v_dual_mov_b32 v174, v2
	v_dual_mov_b32 v175, v2 :: v_dual_mov_b32 v176, v2
	v_dual_mov_b32 v177, v2 :: v_dual_mov_b32 v194, v2
	v_dual_mov_b32 v195, v2 :: v_dual_mov_b32 v196, v2
	v_dual_mov_b32 v197, v2 :: v_dual_mov_b32 v198, v2
	v_dual_mov_b32 v199, v2 :: v_dual_mov_b32 v200, v2
	v_dual_mov_b32 v201, v2 :: v_dual_mov_b32 v226, v2
	v_dual_mov_b32 v227, v2 :: v_dual_mov_b32 v228, v2
	v_dual_mov_b32 v229, v2 :: v_dual_mov_b32 v230, v2
	v_dual_mov_b32 v231, v2 :: v_dual_mov_b32 v232, v2
	v_dual_mov_b32 v233, v2 :: v_dual_mov_b32 v178, v2
	v_dual_mov_b32 v179, v2 :: v_dual_mov_b32 v180, v2
	v_dual_mov_b32 v181, v2 :: v_dual_mov_b32 v182, v2
	v_dual_mov_b32 v183, v2 :: v_dual_mov_b32 v184, v2
	v_dual_mov_b32 v185, v2 :: v_dual_mov_b32 v186, v2
	v_dual_mov_b32 v187, v2 :: v_dual_mov_b32 v188, v2
	v_dual_mov_b32 v189, v2 :: v_dual_mov_b32 v190, v2
	v_dual_mov_b32 v191, v2 :: v_dual_mov_b32 v192, v2
	v_dual_mov_b32 v193, v2 :: v_dual_mov_b32 v202, v2
	v_dual_mov_b32 v203, v2 :: v_dual_mov_b32 v204, v2
	v_dual_mov_b32 v205, v2 :: v_dual_mov_b32 v206, v2
	v_dual_mov_b32 v207, v2 :: v_dual_mov_b32 v208, v2
	v_dual_mov_b32 v209, v2 :: v_dual_mov_b32 v210, v2
	v_dual_mov_b32 v211, v2 :: v_dual_mov_b32 v212, v2
	v_dual_mov_b32 v213, v2 :: v_dual_mov_b32 v214, v2
	v_dual_mov_b32 v215, v2 :: v_dual_mov_b32 v216, v2
	v_dual_mov_b32 v217, v2 :: v_dual_mov_b32 v218, v2
	v_dual_mov_b32 v219, v2 :: v_dual_mov_b32 v220, v2
	v_dual_mov_b32 v221, v2 :: v_dual_mov_b32 v222, v2
	v_dual_mov_b32 v223, v2 :: v_dual_mov_b32 v224, v2
	v_dual_mov_b32 v225, v2 :: v_dual_mov_b32 v234, v2
	v_dual_mov_b32 v235, v2 :: v_dual_mov_b32 v236, v2
	v_dual_mov_b32 v237, v2 :: v_dual_mov_b32 v238, v2
	v_dual_mov_b32 v239, v2 :: v_dual_mov_b32 v240, v2
	v_dual_mov_b32 v241, v2 :: v_dual_mov_b32 v242, v2
	v_mov_b32_e32 v243, v2
	s_set_vgpr_msb 64
	v_dual_mov_b32 v56 /*v312*/, v2 :: v_dual_mov_b32 v55 /*v311*/, v2
	v_dual_mov_b32 v54 /*v310*/, v2 :: v_dual_mov_b32 v53 /*v309*/, v2
	v_dual_mov_b32 v52 /*v308*/, v2 :: v_dual_mov_b32 v51 /*v307*/, v2
	v_dual_mov_b32 v50 /*v306*/, v2 :: v_dual_mov_b32 v49 /*v305*/, v2
	v_dual_mov_b32 v48 /*v304*/, v2 :: v_dual_mov_b32 v47 /*v303*/, v2
	v_dual_mov_b32 v46 /*v302*/, v2 :: v_dual_mov_b32 v45 /*v301*/, v2
	v_dual_mov_b32 v44 /*v300*/, v2 :: v_dual_mov_b32 v43 /*v299*/, v2
	v_dual_mov_b32 v42 /*v298*/, v2 :: v_dual_mov_b32 v41 /*v297*/, v2
	v_dual_mov_b32 v40 /*v296*/, v2 :: v_dual_mov_b32 v39 /*v295*/, v2
	v_dual_mov_b32 v38 /*v294*/, v2 :: v_dual_mov_b32 v37 /*v293*/, v2
	v_dual_mov_b32 v36 /*v292*/, v2 :: v_dual_mov_b32 v35 /*v291*/, v2
	v_dual_mov_b32 v34 /*v290*/, v2 :: v_dual_mov_b32 v33 /*v289*/, v2
	v_dual_mov_b32 v32 /*v288*/, v2 :: v_dual_mov_b32 v31 /*v287*/, v2
	v_dual_mov_b32 v30 /*v286*/, v2 :: v_dual_mov_b32 v29 /*v285*/, v2
	v_dual_mov_b32 v28 /*v284*/, v2 :: v_dual_mov_b32 v27 /*v283*/, v2
	v_dual_mov_b32 v26 /*v282*/, v2 :: v_dual_mov_b32 v25 /*v281*/, v2
	v_dual_mov_b32 v24 /*v280*/, v2 :: v_dual_mov_b32 v23 /*v279*/, v2
	v_dual_mov_b32 v22 /*v278*/, v2 :: v_dual_mov_b32 v21 /*v277*/, v2
	v_dual_mov_b32 v20 /*v276*/, v2 :: v_dual_mov_b32 v19 /*v275*/, v2
	v_dual_mov_b32 v18 /*v274*/, v2 :: v_dual_mov_b32 v17 /*v273*/, v2
	v_dual_mov_b32 v16 /*v272*/, v2 :: v_dual_mov_b32 v15 /*v271*/, v2
	v_dual_mov_b32 v14 /*v270*/, v2 :: v_dual_mov_b32 v13 /*v269*/, v2
	v_dual_mov_b32 v12 /*v268*/, v2 :: v_dual_mov_b32 v11 /*v267*/, v2
	v_dual_mov_b32 v10 /*v266*/, v2 :: v_dual_mov_b32 v9 /*v265*/, v2
	v_dual_mov_b32 v8 /*v264*/, v2 :: v_dual_mov_b32 v7 /*v263*/, v2
	v_dual_mov_b32 v6 /*v262*/, v2 :: v_dual_mov_b32 v5 /*v261*/, v2
	v_dual_mov_b32 v4 /*v260*/, v2 :: v_dual_mov_b32 v3 /*v259*/, v2
	v_dual_mov_b32 v2 /*v258*/, v2 :: v_dual_mov_b32 v1 /*v257*/, v2
	v_dual_mov_b32 v0 /*v256*/, v2 :: v_dual_mov_b32 v65 /*v321*/, v2
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v255, v2 :: v_dual_mov_b32 v254, v2
	v_dual_mov_b32 v253, v2 :: v_dual_mov_b32 v252, v2
	v_dual_mov_b32 v251, v2 :: v_dual_mov_b32 v250, v2
	v_mov_b32_e32 v249, v2
	s_set_vgpr_msb 64
	v_dual_mov_b32 v64 /*v320*/, v2 :: v_dual_mov_b32 v63 /*v319*/, v2
	v_dual_mov_b32 v62 /*v318*/, v2 :: v_dual_mov_b32 v61 /*v317*/, v2
	v_dual_mov_b32 v60 /*v316*/, v2 :: v_dual_mov_b32 v59 /*v315*/, v2
	v_dual_mov_b32 v58 /*v314*/, v2 :: v_dual_mov_b32 v57 /*v313*/, v2
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v248, v2 :: v_dual_mov_b32 v247, v2
	v_dual_mov_b32 v246, v2 :: v_dual_mov_b32 v245, v2
	v_dual_mov_b32 v244, v2 :: v_dual_mov_b32 v74, v2
	s_set_vgpr_msb 64
	v_dual_mov_b32 v66 /*v322*/, v2 :: v_dual_mov_b32 v67 /*v323*/, v2
	v_dual_mov_b32 v68 /*v324*/, v2 :: v_dual_mov_b32 v69 /*v325*/, v2
	v_dual_mov_b32 v70 /*v326*/, v2 :: v_dual_mov_b32 v71 /*v327*/, v2
	v_dual_mov_b32 v72 /*v328*/, v2 :: v_dual_mov_b32 v73 /*v329*/, v2
	v_dual_mov_b32 v74 /*v330*/, v2 :: v_dual_mov_b32 v75 /*v331*/, v2
	v_dual_mov_b32 v76 /*v332*/, v2 :: v_dual_mov_b32 v77 /*v333*/, v2
	v_dual_mov_b32 v78 /*v334*/, v2 :: v_dual_mov_b32 v79 /*v335*/, v2
	v_dual_mov_b32 v80 /*v336*/, v2 :: v_dual_mov_b32 v81 /*v337*/, v2
	v_dual_mov_b32 v82 /*v338*/, v2 :: v_dual_mov_b32 v83 /*v339*/, v2
	v_dual_mov_b32 v84 /*v340*/, v2 :: v_dual_mov_b32 v85 /*v341*/, v2
	v_dual_mov_b32 v86 /*v342*/, v2 :: v_dual_mov_b32 v87 /*v343*/, v2
	v_dual_mov_b32 v88 /*v344*/, v2 :: v_dual_mov_b32 v89 /*v345*/, v2
	v_dual_mov_b32 v98 /*v354*/, v2 :: v_dual_mov_b32 v99 /*v355*/, v2
	v_dual_mov_b32 v100 /*v356*/, v2 :: v_dual_mov_b32 v101 /*v357*/, v2
	v_dual_mov_b32 v102 /*v358*/, v2 :: v_dual_mov_b32 v103 /*v359*/, v2
	v_dual_mov_b32 v104 /*v360*/, v2 :: v_dual_mov_b32 v105 /*v361*/, v2
	v_dual_mov_b32 v106 /*v362*/, v2 :: v_dual_mov_b32 v107 /*v363*/, v2
	v_dual_mov_b32 v108 /*v364*/, v2 :: v_dual_mov_b32 v109 /*v365*/, v2
	v_dual_mov_b32 v110 /*v366*/, v2 :: v_dual_mov_b32 v111 /*v367*/, v2
	v_dual_mov_b32 v112 /*v368*/, v2 :: v_dual_mov_b32 v113 /*v369*/, v2
	v_dual_mov_b32 v114 /*v370*/, v2 :: v_dual_mov_b32 v115 /*v371*/, v2
	v_dual_mov_b32 v116 /*v372*/, v2 :: v_dual_mov_b32 v117 /*v373*/, v2
	v_dual_mov_b32 v118 /*v374*/, v2 :: v_dual_mov_b32 v119 /*v375*/, v2
	v_dual_mov_b32 v120 /*v376*/, v2 :: v_dual_mov_b32 v121 /*v377*/, v2
	v_dual_mov_b32 v130 /*v386*/, v2 :: v_dual_mov_b32 v131 /*v387*/, v2
	v_dual_mov_b32 v132 /*v388*/, v2 :: v_dual_mov_b32 v133 /*v389*/, v2
	v_dual_mov_b32 v134 /*v390*/, v2 :: v_dual_mov_b32 v135 /*v391*/, v2
	v_dual_mov_b32 v136 /*v392*/, v2 :: v_dual_mov_b32 v137 /*v393*/, v2
	v_dual_mov_b32 v138 /*v394*/, v2 :: v_dual_mov_b32 v139 /*v395*/, v2
	v_dual_mov_b32 v140 /*v396*/, v2 :: v_dual_mov_b32 v141 /*v397*/, v2
	v_dual_mov_b32 v142 /*v398*/, v2 :: v_dual_mov_b32 v143 /*v399*/, v2
	v_dual_mov_b32 v144 /*v400*/, v2 :: v_dual_mov_b32 v145 /*v401*/, v2
	v_dual_mov_b32 v90 /*v346*/, v2 :: v_dual_mov_b32 v91 /*v347*/, v2
	v_dual_mov_b32 v92 /*v348*/, v2 :: v_dual_mov_b32 v93 /*v349*/, v2
	v_dual_mov_b32 v94 /*v350*/, v2 :: v_dual_mov_b32 v95 /*v351*/, v2
	v_dual_mov_b32 v96 /*v352*/, v2 :: v_dual_mov_b32 v97 /*v353*/, v2
	v_dual_mov_b32 v122 /*v378*/, v2 :: v_dual_mov_b32 v123 /*v379*/, v2
	v_dual_mov_b32 v124 /*v380*/, v2 :: v_dual_mov_b32 v125 /*v381*/, v2
	v_dual_mov_b32 v126 /*v382*/, v2 :: v_dual_mov_b32 v127 /*v383*/, v2
	v_dual_mov_b32 v128 /*v384*/, v2 :: v_dual_mov_b32 v129 /*v385*/, v2
	v_dual_mov_b32 v146 /*v402*/, v2 :: v_dual_mov_b32 v147 /*v403*/, v2
	v_dual_mov_b32 v148 /*v404*/, v2 :: v_dual_mov_b32 v149 /*v405*/, v2
	v_dual_mov_b32 v150 /*v406*/, v2 :: v_dual_mov_b32 v151 /*v407*/, v2
	v_dual_mov_b32 v152 /*v408*/, v2 :: v_dual_mov_b32 v153 /*v409*/, v2
	v_dual_mov_b32 v154 /*v410*/, v2 :: v_dual_mov_b32 v155 /*v411*/, v2
	v_dual_mov_b32 v156 /*v412*/, v2 :: v_dual_mov_b32 v157 /*v413*/, v2
	v_dual_mov_b32 v158 /*v414*/, v2 :: v_dual_mov_b32 v159 /*v415*/, v2
	v_dual_mov_b32 v160 /*v416*/, v2 :: v_dual_mov_b32 v161 /*v417*/, v2
	v_dual_mov_b32 v162 /*v418*/, v2 :: v_dual_mov_b32 v163 /*v419*/, v2
	v_dual_mov_b32 v164 /*v420*/, v2 :: v_dual_mov_b32 v165 /*v421*/, v2
	v_dual_mov_b32 v166 /*v422*/, v2 :: v_dual_mov_b32 v167 /*v423*/, v2
	v_dual_mov_b32 v168 /*v424*/, v2 :: v_dual_mov_b32 v169 /*v425*/, v2
	v_dual_mov_b32 v170 /*v426*/, v2 :: v_dual_mov_b32 v171 /*v427*/, v2
	v_dual_mov_b32 v172 /*v428*/, v2 :: v_dual_mov_b32 v173 /*v429*/, v2
	v_dual_mov_b32 v174 /*v430*/, v2 :: v_dual_mov_b32 v175 /*v431*/, v2
	v_dual_mov_b32 v176 /*v432*/, v2 :: v_dual_mov_b32 v177 /*v433*/, v2
	v_dual_mov_b32 v194 /*v450*/, v2 :: v_dual_mov_b32 v195 /*v451*/, v2
	v_dual_mov_b32 v196 /*v452*/, v2 :: v_dual_mov_b32 v197 /*v453*/, v2
	v_dual_mov_b32 v198 /*v454*/, v2 :: v_dual_mov_b32 v199 /*v455*/, v2
	v_dual_mov_b32 v200 /*v456*/, v2 :: v_dual_mov_b32 v201 /*v457*/, v2
	v_dual_mov_b32 v226 /*v482*/, v2 :: v_dual_mov_b32 v227 /*v483*/, v2
	v_dual_mov_b32 v228 /*v484*/, v2 :: v_dual_mov_b32 v229 /*v485*/, v2
	v_dual_mov_b32 v230 /*v486*/, v2 :: v_dual_mov_b32 v231 /*v487*/, v2
	v_dual_mov_b32 v232 /*v488*/, v2 :: v_dual_mov_b32 v233 /*v489*/, v2
	v_dual_mov_b32 v178 /*v434*/, v2 :: v_dual_mov_b32 v179 /*v435*/, v2
	v_dual_mov_b32 v180 /*v436*/, v2 :: v_dual_mov_b32 v181 /*v437*/, v2
	v_dual_mov_b32 v182 /*v438*/, v2 :: v_dual_mov_b32 v183 /*v439*/, v2
	v_dual_mov_b32 v184 /*v440*/, v2 :: v_dual_mov_b32 v185 /*v441*/, v2
	v_dual_mov_b32 v186 /*v442*/, v2 :: v_dual_mov_b32 v187 /*v443*/, v2
	v_dual_mov_b32 v188 /*v444*/, v2 :: v_dual_mov_b32 v189 /*v445*/, v2
	v_dual_mov_b32 v190 /*v446*/, v2 :: v_dual_mov_b32 v191 /*v447*/, v2
	v_dual_mov_b32 v192 /*v448*/, v2 :: v_dual_mov_b32 v193 /*v449*/, v2
	v_dual_mov_b32 v202 /*v458*/, v2 :: v_dual_mov_b32 v203 /*v459*/, v2
	v_dual_mov_b32 v204 /*v460*/, v2 :: v_dual_mov_b32 v205 /*v461*/, v2
	v_dual_mov_b32 v206 /*v462*/, v2 :: v_dual_mov_b32 v207 /*v463*/, v2
	v_dual_mov_b32 v208 /*v464*/, v2 :: v_dual_mov_b32 v209 /*v465*/, v2
	v_dual_mov_b32 v210 /*v466*/, v2 :: v_dual_mov_b32 v211 /*v467*/, v2
	v_dual_mov_b32 v212 /*v468*/, v2 :: v_dual_mov_b32 v213 /*v469*/, v2
	v_dual_mov_b32 v214 /*v470*/, v2 :: v_dual_mov_b32 v215 /*v471*/, v2
	v_dual_mov_b32 v216 /*v472*/, v2 :: v_dual_mov_b32 v217 /*v473*/, v2
	v_dual_mov_b32 v218 /*v474*/, v2 :: v_dual_mov_b32 v219 /*v475*/, v2
	v_dual_mov_b32 v220 /*v476*/, v2 :: v_dual_mov_b32 v221 /*v477*/, v2
	v_dual_mov_b32 v222 /*v478*/, v2 :: v_dual_mov_b32 v223 /*v479*/, v2
	v_dual_mov_b32 v224 /*v480*/, v2 :: v_dual_mov_b32 v225 /*v481*/, v2
	v_dual_mov_b32 v234 /*v490*/, v2 :: v_dual_mov_b32 v235 /*v491*/, v2
	v_dual_mov_b32 v236 /*v492*/, v2 :: v_dual_mov_b32 v237 /*v493*/, v2
	v_dual_mov_b32 v238 /*v494*/, v2 :: v_dual_mov_b32 v239 /*v495*/, v2
	v_dual_mov_b32 v240 /*v496*/, v2 :: v_dual_mov_b32 v241 /*v497*/, v2
	v_dual_mov_b32 v242 /*v498*/, v2 :: v_dual_mov_b32 v243 /*v499*/, v2
	v_dual_mov_b32 v244 /*v500*/, v2 :: v_dual_mov_b32 v245 /*v501*/, v2
	v_dual_mov_b32 v246 /*v502*/, v2 :: v_dual_mov_b32 v247 /*v503*/, v2
	v_dual_mov_b32 v248 /*v504*/, v2 :: v_dual_mov_b32 v249 /*v505*/, v2
	v_dual_mov_b32 v250 /*v506*/, v2 :: v_dual_mov_b32 v251 /*v507*/, v2
	v_dual_mov_b32 v252 /*v508*/, v2 :: v_dual_mov_b32 v253 /*v509*/, v2
	v_dual_mov_b32 v254 /*v510*/, v2 :: v_dual_mov_b32 v255 /*v511*/, v2
	s_set_vgpr_msb 0x4080
	v_dual_mov_b32 v0 /*v512*/, v2 :: v_dual_mov_b32 v1 /*v513*/, v2
	s_set_vgpr_msb 0x8000
	v_dual_mov_b32 v75, v2 :: v_dual_mov_b32 v76, v2
	v_dual_mov_b32 v77, v2 :: v_dual_mov_b32 v78, v2
	v_dual_mov_b32 v79, v2 :: v_dual_mov_b32 v80, v2
	v_dual_mov_b32 v81, v2 :: v_dual_mov_b32 v82, v2
	v_dual_mov_b32 v83, v2 :: v_dual_mov_b32 v84, v2
	v_dual_mov_b32 v85, v2 :: v_dual_mov_b32 v86, v2
	v_dual_mov_b32 v87, v2 :: v_dual_mov_b32 v88, v2
	v_dual_mov_b32 v89, v2 :: v_dual_mov_b32 v98, v2
	v_dual_mov_b32 v99, v2 :: v_dual_mov_b32 v100, v2
	v_dual_mov_b32 v101, v2 :: v_dual_mov_b32 v102, v2
	v_dual_mov_b32 v103, v2 :: v_dual_mov_b32 v104, v2
	v_dual_mov_b32 v105, v2 :: v_dual_mov_b32 v114, v2
	v_dual_mov_b32 v115, v2 :: v_dual_mov_b32 v116, v2
	v_dual_mov_b32 v117, v2 :: v_dual_mov_b32 v118, v2
	v_dual_mov_b32 v119, v2 :: v_dual_mov_b32 v120, v2
	v_dual_mov_b32 v121, v2 :: v_dual_mov_b32 v122, v2
	v_dual_mov_b32 v123, v2 :: v_dual_mov_b32 v124, v2
	v_dual_mov_b32 v125, v2 :: v_dual_mov_b32 v126, v2
	v_dual_mov_b32 v127, v2 :: v_dual_mov_b32 v128, v2
	v_dual_mov_b32 v129, v2 :: v_dual_mov_b32 v130, v2
	v_dual_mov_b32 v131, v2 :: v_dual_mov_b32 v132, v2
	v_dual_mov_b32 v133, v2 :: v_dual_mov_b32 v134, v2
	v_dual_mov_b32 v135, v2 :: v_dual_mov_b32 v136, v2
	v_dual_mov_b32 v137, v2 :: v_dual_mov_b32 v138, v2
	v_dual_mov_b32 v139, v2 :: v_dual_mov_b32 v140, v2
	v_dual_mov_b32 v141, v2 :: v_dual_mov_b32 v142, v2
	v_dual_mov_b32 v143, v2 :: v_dual_mov_b32 v144, v2
	v_dual_mov_b32 v145, v2 :: v_dual_mov_b32 v154, v2
	v_dual_mov_b32 v155, v2 :: v_dual_mov_b32 v156, v2
	v_dual_mov_b32 v157, v2 :: v_dual_mov_b32 v158, v2
	v_dual_mov_b32 v159, v2 :: v_dual_mov_b32 v160, v2
	v_mov_b32_e32 v161, v2
	s_mov_b32 s13, 0xffff0000
	s_mov_b32 s12, 0x7300000
	s_or_b32 s44, s39, 0x7fff
	s_or_b32 s45, s21, 0x800000
	s_and_b32 s46, s20, 0xffff
	s_mov_b64 s[26:27], s[18:19]
	s_mov_b64 s[24:25], s[16:17]
	s_mov_b64 s[22:23], s[14:15]
	s_mov_b64 s[20:21], s[12:13]
	s_mov_b32 s22, s44
	s_mov_b32 s23, s45
	s_mov_b32 s25, s43
	s_mov_b32 s26, s46
	s_add_nc_u64 s[6:7], s[6:7], 0x100
	s_mov_b32 s8, 1
	s_mov_b32 s40, 2
	s_mov_b32 s41, s19
	s_mov_b32 s42, s29
	s_mov_b32 s43, s19
	s_branch .LBB0_14
.LBB0_13:
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[2:9], v[106:113] /*v[618:625]*/, v[250:257] /*v[762:769]*/, v[2:9]
	v_wmma_f32_16x16x32_bf16 v[10:17], v[130:137] /*v[642:649]*/, v[250:257] /*v[762:769]*/, v[10:17]
	v_wmma_f32_16x16x32_bf16 v[18:25], v[162:169] /*v[674:681]*/, v[250:257] /*v[762:769]*/, v[18:25]
	v_wmma_f32_16x16x32_bf16 v[34:41], v[178:185] /*v[690:697]*/, v[250:257] /*v[762:769]*/, v[34:41]
	v_wmma_f32_16x16x32_bf16 v[42:49], v[194:201] /*v[706:713]*/, v[250:257] /*v[762:769]*/, v[42:49]
	v_wmma_f32_16x16x32_bf16 v[50:57], v[210:217] /*v[722:729]*/, v[250:257] /*v[762:769]*/, v[50:57]
	v_wmma_f32_16x16x32_bf16 v[66:73], v[218:225] /*v[730:737]*/, v[250:257] /*v[762:769]*/, v[66:73]
	v_wmma_f32_16x16x32_bf16 v[90:97], v[242:249] /*v[754:761]*/, v[250:257] /*v[762:769]*/, v[90:97]
	v_wmma_f32_16x16x32_bf16 v[226:233], v[242:249] /*v[754:761]*/, v[234:241] /*v[746:753]*/, v[226:233]
	v_wmma_f32_16x16x32_bf16 v[194:201], v[218:225] /*v[730:737]*/, v[234:241] /*v[746:753]*/, v[194:201]
	v_wmma_f32_16x16x32_bf16 v[170:177], v[210:217] /*v[722:729]*/, v[234:241] /*v[746:753]*/, v[170:177]
	v_wmma_f32_16x16x32_bf16 v[162:169], v[194:201] /*v[706:713]*/, v[234:241] /*v[746:753]*/, v[162:169]
	v_wmma_f32_16x16x32_bf16 v[146:153], v[178:185] /*v[690:697]*/, v[234:241] /*v[746:753]*/, v[146:153]
	v_wmma_f32_16x16x32_bf16 v[106:113], v[162:169] /*v[674:681]*/, v[234:241] /*v[746:753]*/, v[106:113]
	v_wmma_f32_16x16x32_bf16 v[58:65], v[130:137] /*v[642:649]*/, v[234:241] /*v[746:753]*/, v[58:65]
	v_wmma_f32_16x16x32_bf16 v[26:33], v[106:113] /*v[618:625]*/, v[234:241] /*v[746:753]*/, v[26:33]
	v_wmma_f32_16x16x32_bf16 v[178:185], v[106:113] /*v[618:625]*/, v[226:233] /*v[738:745]*/, v[178:185]
	v_wmma_f32_16x16x32_bf16 v[186:193], v[130:137] /*v[642:649]*/, v[226:233] /*v[738:745]*/, v[186:193]
	v_wmma_f32_16x16x32_bf16 v[202:209], v[162:169] /*v[674:681]*/, v[226:233] /*v[738:745]*/, v[202:209]
	v_wmma_f32_16x16x32_bf16 v[210:217], v[178:185] /*v[690:697]*/, v[226:233] /*v[738:745]*/, v[210:217]
	v_wmma_f32_16x16x32_bf16 v[218:225], v[194:201] /*v[706:713]*/, v[226:233] /*v[738:745]*/, v[218:225]
	v_wmma_f32_16x16x32_bf16 v[234:241], v[210:217] /*v[722:729]*/, v[226:233] /*v[738:745]*/, v[234:241]
	v_wmma_f32_16x16x32_bf16 v[242:249], v[218:225] /*v[730:737]*/, v[226:233] /*v[738:745]*/, v[242:249]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[58:65] /*v[314:321]*/, v[242:249] /*v[754:761]*/, v[226:233] /*v[738:745]*/, v[58:65] /*v[314:321]*/
	s_wait_dscnt 0x1f
	v_wmma_f32_16x16x32_bf16 v[50:57] /*v[306:313]*/, v[242:249] /*v[754:761]*/, v[202:209] /*v[714:721]*/, v[50:57] /*v[306:313]*/
	v_wmma_f32_16x16x32_bf16 v[42:49] /*v[298:305]*/, v[218:225] /*v[730:737]*/, v[202:209] /*v[714:721]*/, v[42:49] /*v[298:305]*/
	v_wmma_f32_16x16x32_bf16 v[34:41] /*v[290:297]*/, v[210:217] /*v[722:729]*/, v[202:209] /*v[714:721]*/, v[34:41] /*v[290:297]*/
	v_wmma_f32_16x16x32_bf16 v[26:33] /*v[282:289]*/, v[194:201] /*v[706:713]*/, v[202:209] /*v[714:721]*/, v[26:33] /*v[282:289]*/
	v_wmma_f32_16x16x32_bf16 v[18:25] /*v[274:281]*/, v[178:185] /*v[690:697]*/, v[202:209] /*v[714:721]*/, v[18:25] /*v[274:281]*/
	v_wmma_f32_16x16x32_bf16 v[10:17] /*v[266:273]*/, v[162:169] /*v[674:681]*/, v[202:209] /*v[714:721]*/, v[10:17] /*v[266:273]*/
	v_wmma_f32_16x16x32_bf16 v[2:9] /*v[258:265]*/, v[130:137] /*v[642:649]*/, v[202:209] /*v[714:721]*/, v[2:9] /*v[258:265]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[250:257], v[106:113] /*v[618:625]*/, v[202:209] /*v[714:721]*/, v[250:257]
	s_set_vgpr_msb 0xa5a
	s_wait_dscnt 0x18
	v_wmma_f32_16x16x32_bf16 v[66:73] /*v[322:329]*/, v[106:113] /*v[618:625]*/, v[186:193] /*v[698:705]*/, v[66:73] /*v[322:329]*/
	v_wmma_f32_16x16x32_bf16 v[74:81] /*v[330:337]*/, v[130:137] /*v[642:649]*/, v[186:193] /*v[698:705]*/, v[74:81] /*v[330:337]*/
	v_wmma_f32_16x16x32_bf16 v[82:89] /*v[338:345]*/, v[162:169] /*v[674:681]*/, v[186:193] /*v[698:705]*/, v[82:89] /*v[338:345]*/
	v_wmma_f32_16x16x32_bf16 v[98:105] /*v[354:361]*/, v[178:185] /*v[690:697]*/, v[186:193] /*v[698:705]*/, v[98:105] /*v[354:361]*/
	v_wmma_f32_16x16x32_bf16 v[106:113] /*v[362:369]*/, v[194:201] /*v[706:713]*/, v[186:193] /*v[698:705]*/, v[106:113] /*v[362:369]*/
	v_wmma_f32_16x16x32_bf16 v[114:121] /*v[370:377]*/, v[210:217] /*v[722:729]*/, v[186:193] /*v[698:705]*/, v[114:121] /*v[370:377]*/
	v_wmma_f32_16x16x32_bf16 v[130:137] /*v[386:393]*/, v[218:225] /*v[730:737]*/, v[186:193] /*v[698:705]*/, v[130:137] /*v[386:393]*/
	v_wmma_f32_16x16x32_bf16 v[138:145] /*v[394:401]*/, v[242:249] /*v[754:761]*/, v[186:193] /*v[698:705]*/, v[138:145] /*v[394:401]*/
	s_wait_dscnt 0x16
	v_wmma_f32_16x16x32_bf16 v[226:233] /*v[482:489]*/, v[242:249] /*v[754:761]*/, v[154:161] /*v[666:673]*/, v[226:233] /*v[482:489]*/
	v_wmma_f32_16x16x32_bf16 v[194:201] /*v[450:457]*/, v[218:225] /*v[730:737]*/, v[154:161] /*v[666:673]*/, v[194:201] /*v[450:457]*/
	v_wmma_f32_16x16x32_bf16 v[170:177] /*v[426:433]*/, v[210:217] /*v[722:729]*/, v[154:161] /*v[666:673]*/, v[170:177] /*v[426:433]*/
	v_wmma_f32_16x16x32_bf16 v[162:169] /*v[418:425]*/, v[194:201] /*v[706:713]*/, v[154:161] /*v[666:673]*/, v[162:169] /*v[418:425]*/
	v_wmma_f32_16x16x32_bf16 v[154:161] /*v[410:417]*/, v[178:185] /*v[690:697]*/, v[154:161] /*v[666:673]*/, v[154:161] /*v[410:417]*/
	v_wmma_f32_16x16x32_bf16 v[146:153] /*v[402:409]*/, v[162:169] /*v[674:681]*/, v[154:161] /*v[666:673]*/, v[146:153] /*v[402:409]*/
	v_wmma_f32_16x16x32_bf16 v[122:129] /*v[378:385]*/, v[130:137] /*v[642:649]*/, v[154:161] /*v[666:673]*/, v[122:129] /*v[378:385]*/
	v_wmma_f32_16x16x32_bf16 v[90:97] /*v[346:353]*/, v[106:113] /*v[618:625]*/, v[154:161] /*v[666:673]*/, v[90:97] /*v[346:353]*/
	s_wait_dscnt 0x14
	v_wmma_f32_16x16x32_bf16 v[178:185] /*v[434:441]*/, v[106:113] /*v[618:625]*/, v[122:129] /*v[634:641]*/, v[178:185] /*v[434:441]*/
	v_wmma_f32_16x16x32_bf16 v[186:193] /*v[442:449]*/, v[130:137] /*v[642:649]*/, v[122:129] /*v[634:641]*/, v[186:193] /*v[442:449]*/
	v_wmma_f32_16x16x32_bf16 v[202:209] /*v[458:465]*/, v[162:169] /*v[674:681]*/, v[122:129] /*v[634:641]*/, v[202:209] /*v[458:465]*/
	v_wmma_f32_16x16x32_bf16 v[210:217] /*v[466:473]*/, v[178:185] /*v[690:697]*/, v[122:129] /*v[634:641]*/, v[210:217] /*v[466:473]*/
	v_wmma_f32_16x16x32_bf16 v[218:225] /*v[474:481]*/, v[194:201] /*v[706:713]*/, v[122:129] /*v[634:641]*/, v[218:225] /*v[474:481]*/
	v_wmma_f32_16x16x32_bf16 v[234:241] /*v[490:497]*/, v[210:217] /*v[722:729]*/, v[122:129] /*v[634:641]*/, v[234:241] /*v[490:497]*/
	v_wmma_f32_16x16x32_bf16 v[242:249] /*v[498:505]*/, v[218:225] /*v[730:737]*/, v[122:129] /*v[634:641]*/, v[242:249] /*v[498:505]*/
	v_wmma_f32_16x16x32_bf16 v[250:257] /*v[506:513]*/, v[242:249] /*v[754:761]*/, v[122:129] /*v[634:641]*/, v[250:257] /*v[506:513]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[154:161], v[242:249] /*v[754:761]*/, v[90:97] /*v[602:609]*/, v[154:161]
	v_wmma_f32_16x16x32_bf16 v[138:145], v[218:225] /*v[730:737]*/, v[90:97] /*v[602:609]*/, v[138:145]
	v_wmma_f32_16x16x32_bf16 v[130:137], v[210:217] /*v[722:729]*/, v[90:97] /*v[602:609]*/, v[130:137]
	v_wmma_f32_16x16x32_bf16 v[122:129], v[194:201] /*v[706:713]*/, v[90:97] /*v[602:609]*/, v[122:129]
	v_wmma_f32_16x16x32_bf16 v[114:121], v[178:185] /*v[690:697]*/, v[90:97] /*v[602:609]*/, v[114:121]
	v_wmma_f32_16x16x32_bf16 v[98:105], v[162:169] /*v[674:681]*/, v[90:97] /*v[602:609]*/, v[98:105]
	v_wmma_f32_16x16x32_bf16 v[82:89], v[130:137] /*v[642:649]*/, v[90:97] /*v[602:609]*/, v[82:89]
	v_wmma_f32_16x16x32_bf16 v[74:81], v[106:113] /*v[618:625]*/, v[90:97] /*v[602:609]*/, v[74:81]
	s_wait_dscnt 0x0
	s_wait_tensorcnt 0x1
	s_barrier_signal -1
	v_wmma_f32_16x16x32_bf16 v[2:9], v[10:17] /*v[522:529]*/, v[170:177] /*v[682:689]*/, v[2:9]
	v_wmma_f32_16x16x32_bf16 v[10:17], v[26:33] /*v[538:545]*/, v[170:177] /*v[682:689]*/, v[10:17]
	v_wmma_f32_16x16x32_bf16 v[18:25], v[42:49] /*v[554:561]*/, v[170:177] /*v[682:689]*/, v[18:25]
	v_wmma_f32_16x16x32_bf16 v[34:41], v[50:57] /*v[562:569]*/, v[170:177] /*v[682:689]*/, v[34:41]
	v_wmma_f32_16x16x32_bf16 v[42:49], v[66:73] /*v[578:585]*/, v[170:177] /*v[682:689]*/, v[42:49]
	v_wmma_f32_16x16x32_bf16 v[50:57], v[82:89] /*v[594:601]*/, v[170:177] /*v[682:689]*/, v[50:57]
	v_wmma_f32_16x16x32_bf16 v[66:73], v[114:121] /*v[626:633]*/, v[170:177] /*v[682:689]*/, v[66:73]
	v_wmma_f32_16x16x32_bf16 v[90:97], v[138:145] /*v[650:657]*/, v[170:177] /*v[682:689]*/, v[90:97]
	v_wmma_f32_16x16x32_bf16 v[226:233], v[138:145] /*v[650:657]*/, v[146:153] /*v[658:665]*/, v[226:233]
	v_wmma_f32_16x16x32_bf16 v[194:201], v[114:121] /*v[626:633]*/, v[146:153] /*v[658:665]*/, v[194:201]
	v_wmma_f32_16x16x32_bf16 v[170:177], v[82:89] /*v[594:601]*/, v[146:153] /*v[658:665]*/, v[170:177]
	v_wmma_f32_16x16x32_bf16 v[162:169], v[66:73] /*v[578:585]*/, v[146:153] /*v[658:665]*/, v[162:169]
	v_wmma_f32_16x16x32_bf16 v[146:153], v[50:57] /*v[562:569]*/, v[146:153] /*v[658:665]*/, v[146:153]
	v_wmma_f32_16x16x32_bf16 v[106:113], v[42:49] /*v[554:561]*/, v[146:153] /*v[658:665]*/, v[106:113]
	v_wmma_f32_16x16x32_bf16 v[58:65], v[26:33] /*v[538:545]*/, v[146:153] /*v[658:665]*/, v[58:65]
	v_wmma_f32_16x16x32_bf16 v[26:33], v[10:17] /*v[522:529]*/, v[146:153] /*v[658:665]*/, v[26:33]
	v_wmma_f32_16x16x32_bf16 v[178:185], v[10:17] /*v[522:529]*/, v[98:105] /*v[610:617]*/, v[178:185]
	v_wmma_f32_16x16x32_bf16 v[186:193], v[26:33] /*v[538:545]*/, v[98:105] /*v[610:617]*/, v[186:193]
	v_wmma_f32_16x16x32_bf16 v[202:209], v[42:49] /*v[554:561]*/, v[98:105] /*v[610:617]*/, v[202:209]
	v_wmma_f32_16x16x32_bf16 v[210:217], v[50:57] /*v[562:569]*/, v[98:105] /*v[610:617]*/, v[210:217]
	v_wmma_f32_16x16x32_bf16 v[218:225], v[66:73] /*v[578:585]*/, v[98:105] /*v[610:617]*/, v[218:225]
	v_wmma_f32_16x16x32_bf16 v[234:241], v[82:89] /*v[594:601]*/, v[98:105] /*v[610:617]*/, v[234:241]
	v_wmma_f32_16x16x32_bf16 v[242:249], v[114:121] /*v[626:633]*/, v[98:105] /*v[610:617]*/, v[242:249]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[58:65] /*v[314:321]*/, v[138:145] /*v[650:657]*/, v[98:105] /*v[610:617]*/, v[58:65] /*v[314:321]*/
	v_wmma_f32_16x16x32_bf16 v[50:57] /*v[306:313]*/, v[138:145] /*v[650:657]*/, v[74:81] /*v[586:593]*/, v[50:57] /*v[306:313]*/
	v_wmma_f32_16x16x32_bf16 v[42:49] /*v[298:305]*/, v[114:121] /*v[626:633]*/, v[74:81] /*v[586:593]*/, v[42:49] /*v[298:305]*/
	v_wmma_f32_16x16x32_bf16 v[34:41] /*v[290:297]*/, v[82:89] /*v[594:601]*/, v[74:81] /*v[586:593]*/, v[34:41] /*v[290:297]*/
	v_wmma_f32_16x16x32_bf16 v[26:33] /*v[282:289]*/, v[66:73] /*v[578:585]*/, v[74:81] /*v[586:593]*/, v[26:33] /*v[282:289]*/
	v_wmma_f32_16x16x32_bf16 v[18:25] /*v[274:281]*/, v[50:57] /*v[562:569]*/, v[74:81] /*v[586:593]*/, v[18:25] /*v[274:281]*/
	v_wmma_f32_16x16x32_bf16 v[10:17] /*v[266:273]*/, v[42:49] /*v[554:561]*/, v[74:81] /*v[586:593]*/, v[10:17] /*v[266:273]*/
	v_wmma_f32_16x16x32_bf16 v[2:9] /*v[258:265]*/, v[26:33] /*v[538:545]*/, v[74:81] /*v[586:593]*/, v[2:9] /*v[258:265]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[250:257], v[10:17] /*v[522:529]*/, v[74:81] /*v[586:593]*/, v[250:257]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[66:73] /*v[322:329]*/, v[10:17] /*v[522:529]*/, v[58:65] /*v[570:577]*/, v[66:73] /*v[322:329]*/
	v_wmma_f32_16x16x32_bf16 v[74:81] /*v[330:337]*/, v[26:33] /*v[538:545]*/, v[58:65] /*v[570:577]*/, v[74:81] /*v[330:337]*/
	v_wmma_f32_16x16x32_bf16 v[82:89] /*v[338:345]*/, v[42:49] /*v[554:561]*/, v[58:65] /*v[570:577]*/, v[82:89] /*v[338:345]*/
	v_wmma_f32_16x16x32_bf16 v[98:105] /*v[354:361]*/, v[50:57] /*v[562:569]*/, v[58:65] /*v[570:577]*/, v[98:105] /*v[354:361]*/
	v_wmma_f32_16x16x32_bf16 v[106:113] /*v[362:369]*/, v[66:73] /*v[578:585]*/, v[58:65] /*v[570:577]*/, v[106:113] /*v[362:369]*/
	v_wmma_f32_16x16x32_bf16 v[114:121] /*v[370:377]*/, v[82:89] /*v[594:601]*/, v[58:65] /*v[570:577]*/, v[114:121] /*v[370:377]*/
	v_wmma_f32_16x16x32_bf16 v[130:137] /*v[386:393]*/, v[114:121] /*v[626:633]*/, v[58:65] /*v[570:577]*/, v[130:137] /*v[386:393]*/
	v_wmma_f32_16x16x32_bf16 v[138:145] /*v[394:401]*/, v[138:145] /*v[650:657]*/, v[58:65] /*v[570:577]*/, v[138:145] /*v[394:401]*/
	v_wmma_f32_16x16x32_bf16 v[226:233] /*v[482:489]*/, v[138:145] /*v[650:657]*/, v[34:41] /*v[546:553]*/, v[226:233] /*v[482:489]*/
	v_wmma_f32_16x16x32_bf16 v[194:201] /*v[450:457]*/, v[114:121] /*v[626:633]*/, v[34:41] /*v[546:553]*/, v[194:201] /*v[450:457]*/
	v_wmma_f32_16x16x32_bf16 v[170:177] /*v[426:433]*/, v[82:89] /*v[594:601]*/, v[34:41] /*v[546:553]*/, v[170:177] /*v[426:433]*/
	v_wmma_f32_16x16x32_bf16 v[162:169] /*v[418:425]*/, v[66:73] /*v[578:585]*/, v[34:41] /*v[546:553]*/, v[162:169] /*v[418:425]*/
	v_wmma_f32_16x16x32_bf16 v[154:161] /*v[410:417]*/, v[50:57] /*v[562:569]*/, v[34:41] /*v[546:553]*/, v[154:161] /*v[410:417]*/
	v_wmma_f32_16x16x32_bf16 v[146:153] /*v[402:409]*/, v[42:49] /*v[554:561]*/, v[34:41] /*v[546:553]*/, v[146:153] /*v[402:409]*/
	v_wmma_f32_16x16x32_bf16 v[122:129] /*v[378:385]*/, v[26:33] /*v[538:545]*/, v[34:41] /*v[546:553]*/, v[122:129] /*v[378:385]*/
	v_wmma_f32_16x16x32_bf16 v[90:97] /*v[346:353]*/, v[10:17] /*v[522:529]*/, v[34:41] /*v[546:553]*/, v[90:97] /*v[346:353]*/
	v_wmma_f32_16x16x32_bf16 v[178:185] /*v[434:441]*/, v[10:17] /*v[522:529]*/, v[18:25] /*v[530:537]*/, v[178:185] /*v[434:441]*/
	v_wmma_f32_16x16x32_bf16 v[186:193] /*v[442:449]*/, v[26:33] /*v[538:545]*/, v[18:25] /*v[530:537]*/, v[186:193] /*v[442:449]*/
	v_wmma_f32_16x16x32_bf16 v[202:209] /*v[458:465]*/, v[42:49] /*v[554:561]*/, v[18:25] /*v[530:537]*/, v[202:209] /*v[458:465]*/
	v_wmma_f32_16x16x32_bf16 v[210:217] /*v[466:473]*/, v[50:57] /*v[562:569]*/, v[18:25] /*v[530:537]*/, v[210:217] /*v[466:473]*/
	v_wmma_f32_16x16x32_bf16 v[218:225] /*v[474:481]*/, v[66:73] /*v[578:585]*/, v[18:25] /*v[530:537]*/, v[218:225] /*v[474:481]*/
	v_wmma_f32_16x16x32_bf16 v[234:241] /*v[490:497]*/, v[82:89] /*v[594:601]*/, v[18:25] /*v[530:537]*/, v[234:241] /*v[490:497]*/
	v_wmma_f32_16x16x32_bf16 v[242:249] /*v[498:505]*/, v[114:121] /*v[626:633]*/, v[18:25] /*v[530:537]*/, v[242:249] /*v[498:505]*/
	v_wmma_f32_16x16x32_bf16 v[250:257] /*v[506:513]*/, v[138:145] /*v[650:657]*/, v[18:25] /*v[530:537]*/, v[250:257] /*v[506:513]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[154:161], v[138:145] /*v[650:657]*/, v[2:9] /*v[514:521]*/, v[154:161]
	v_wmma_f32_16x16x32_bf16 v[138:145], v[114:121] /*v[626:633]*/, v[2:9] /*v[514:521]*/, v[138:145]
	v_wmma_f32_16x16x32_bf16 v[130:137], v[82:89] /*v[594:601]*/, v[2:9] /*v[514:521]*/, v[130:137]
	v_wmma_f32_16x16x32_bf16 v[122:129], v[66:73] /*v[578:585]*/, v[2:9] /*v[514:521]*/, v[122:129]
	v_wmma_f32_16x16x32_bf16 v[114:121], v[50:57] /*v[562:569]*/, v[2:9] /*v[514:521]*/, v[114:121]
	v_wmma_f32_16x16x32_bf16 v[98:105], v[42:49] /*v[554:561]*/, v[2:9] /*v[514:521]*/, v[98:105]
	v_wmma_f32_16x16x32_bf16 v[82:89], v[26:33] /*v[538:545]*/, v[2:9] /*v[514:521]*/, v[82:89]
	v_wmma_f32_16x16x32_bf16 v[74:81], v[10:17] /*v[522:529]*/, v[2:9] /*v[514:521]*/, v[74:81]
	s_add_co_i32 s42, s42, -1
	s_add_co_i32 s43, s43, 1
	s_add_co_i32 s41, s41, 0x12000
	s_add_co_i32 s40, s40, 1
	s_add_nc_u64 s[6:7], s[6:7], 0x80
	s_cmp_lg_u32 s42, 0
	s_add_nc_u64 s[34:35], s[34:35], 0x80
	s_set_vgpr_msb 0xa00
	s_barrier_wait -1
	s_cbranch_scc0 .LBB0_18
.LBB0_14:
	s_mul_hi_u32 s9, s43, 0xaaaaaaab
	s_set_vgpr_msb 0x8c
	v_add_nc_u32_e32 v115 /*v627*/, s41, v19 /*v787*/
	s_lshr_b32 s9, s9, 1
	s_delay_alu instid0(SALU_CYCLE_1)
	s_mul_i32 s9, s9, 0x36000
	s_set_vgpr_msb 0x8c80
	v_subrev_nc_u32_e32 v22 /*v534*/, s9, v1
	s_set_vgpr_msb 0x808c
	v_subrev_nc_u32_e32 v19 /*v531*/, s9, v51 /*v819*/
	v_subrev_nc_u32_e32 v18 /*v530*/, s9, v50 /*v818*/
	s_wait_alu depctr_vm_vsrc(6)
	v_subrev_nc_u32_e32 v4 /*v516*/, s9, v23 /*v791*/
	v_subrev_nc_u32_e32 v5 /*v517*/, s9, v24 /*v792*/
	v_subrev_nc_u32_e32 v6 /*v518*/, s9, v25 /*v793*/
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v22 /*v534*/, v115 /*v627*/, v22 /*v534*/ :: v_dual_add_nc_u32 v19 /*v531*/, v115 /*v627*/, v19 /*v531*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v7 /*v519*/, s9, v26 /*v794*/
	v_subrev_nc_u32_e32 v8 /*v520*/, s9, v27 /*v795*/
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v18 /*v530*/, v115 /*v627*/, v18 /*v530*/ :: v_dual_add_nc_u32 v4 /*v516*/, v115 /*v627*/, v4 /*v516*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v9 /*v521*/, s9, v28 /*v796*/
	v_subrev_nc_u32_e32 v10 /*v522*/, s9, v29 /*v797*/
	s_set_vgpr_msb 0x8c8a
	v_add_nc_u32_e32 v5 /*v517*/, v115 /*v627*/, v5 /*v517*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v11 /*v523*/, s9, v30 /*v798*/
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[90:93] /*v[602:605]*/, v22 /*v534*/
	ds_load_b128 v[94:97] /*v[606:609]*/, v19 /*v531*/
	ds_load_b128 v[106:109] /*v[618:621]*/, v18 /*v530*/
	ds_load_b128 v[110:113] /*v[622:625]*/, v4 /*v516*/
	ds_load_b128 v[130:133] /*v[642:645]*/, v5 /*v517*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x8e8a
	v_add_nc_u32_e32 v4 /*v516*/, v115 /*v627*/, v6 /*v518*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v12 /*v524*/, s9, v31 /*v799*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v5 /*v517*/, v115 /*v627*/, v7 /*v519*/ :: v_dual_add_nc_u32 v6 /*v518*/, v115 /*v627*/, v8 /*v520*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v13 /*v525*/, s9, v32 /*v800*/
	v_subrev_nc_u32_e32 v14 /*v526*/, s9, v33 /*v801*/
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v7 /*v519*/, v115 /*v627*/, v9 /*v521*/ :: v_dual_add_nc_u32 v8 /*v520*/, v115 /*v627*/, v10 /*v522*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v15 /*v527*/, s9, v34 /*v802*/
	v_subrev_nc_u32_e32 v16 /*v528*/, s9, v35 /*v803*/
	s_wait_alu depctr_va_vdst(7)
	ds_load_b128 v[134:137] /*v[646:649]*/, v4 /*v516*/
	s_wait_alu depctr_va_vdst(5)
	ds_load_b128 v[162:165] /*v[674:677]*/, v5 /*v517*/
	ds_load_b128 v[166:169] /*v[678:681]*/, v6 /*v518*/
	s_wait_alu depctr_va_vdst(2)
	ds_load_b128 v[178:181] /*v[690:693]*/, v7 /*v519*/
	ds_load_b128 v[182:185] /*v[694:697]*/, v8 /*v520*/
	s_wait_alu depctr_vm_vsrc(3)
	s_set_vgpr_msb 0x8e8a
	v_dual_add_nc_u32 v4 /*v516*/, v115 /*v627*/, v11 /*v523*/ :: v_dual_add_nc_u32 v5 /*v517*/, v115 /*v627*/, v12 /*v524*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v3 /*v515*/, s9, v22 /*v790*/
	s_set_vgpr_msb 0x8c80
	v_subrev_nc_u32_e32 v2 /*v514*/, s9, v0
	s_set_vgpr_msb 0x808c
	v_subrev_nc_u32_e32 v55 /*v567*/, s9, v47 /*v815*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v6 /*v518*/, v115 /*v627*/, v13 /*v525*/ :: v_dual_add_nc_u32 v7 /*v519*/, v115 /*v627*/, v14 /*v526*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v23 /*v535*/, s9, v54 /*v822*/
	v_subrev_nc_u32_e32 v41 /*v553*/, s9, v67 /*v835*/
	v_subrev_nc_u32_e32 v24 /*v536*/, s9, v55 /*v823*/
	v_subrev_nc_u32_e32 v42 /*v554*/, s9, v68 /*v836*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8c8a
	v_add_nc_u32_e32 v8 /*v520*/, v115 /*v627*/, v15 /*v527*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v25 /*v537*/, s9, v56 /*v824*/
	v_subrev_nc_u32_e32 v43 /*v555*/, s9, v69 /*v837*/
	s_wait_alu depctr_va_vdst(11)
	ds_load_b128 v[194:197] /*v[706:709]*/, v4 /*v516*/
	ds_load_b128 v[198:201] /*v[710:713]*/, v5 /*v517*/
	s_wait_alu depctr_va_vdst(7)
	ds_load_b128 v[210:213] /*v[722:725]*/, v6 /*v518*/
	ds_load_b128 v[214:217] /*v[726:729]*/, v7 /*v519*/
	s_wait_alu depctr_va_vdst(2)
	ds_load_b128 v[218:221] /*v[730:733]*/, v8 /*v520*/
	s_wait_alu depctr_vm_vsrc(4)
	s_set_vgpr_msb 0x8e8a
	v_add_nc_u32_e32 v4 /*v516*/, v115 /*v627*/, v16 /*v528*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v44 /*v556*/, s9, v70 /*v838*/
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v3 /*v515*/, v115 /*v627*/, v3 /*v515*/ :: v_dual_add_nc_u32 v2 /*v514*/, v115 /*v627*/, v2 /*v514*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v31 /*v543*/, s9, v57 /*v825*/
	v_subrev_nc_u32_e32 v45 /*v557*/, s9, v71 /*v839*/
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v55 /*v567*/, v115 /*v627*/, v55 /*v567*/ :: v_dual_add_nc_u32 v24 /*v536*/, v115 /*v627*/, v24 /*v536*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v32 /*v544*/, s9, v58 /*v826*/
	v_subrev_nc_u32_e32 v46 /*v558*/, s9, v72 /*v840*/
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v23 /*v535*/, v115 /*v627*/, v23 /*v535*/ :: v_dual_add_nc_u32 v25 /*v537*/, v115 /*v627*/, v25 /*v537*/
	s_wait_alu depctr_vm_vsrc(2)
	v_dual_add_nc_u32 v5 /*v517*/, v115 /*v627*/, v41 /*v553*/ :: v_dual_add_nc_u32 v6 /*v518*/, v115 /*v627*/, v42 /*v554*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v33 /*v545*/, s9, v59 /*v827*/
	v_subrev_nc_u32_e32 v47 /*v559*/, s9, v73 /*v841*/
	v_subrev_nc_u32_e32 v34 /*v546*/, s9, v60 /*v828*/
	v_subrev_nc_u32_e32 v48 /*v560*/, s9, v74 /*v842*/
	s_wait_alu depctr_va_vdst(13)
	ds_load_b128 v[222:225] /*v[734:737]*/, v4 /*v516*/
	s_wait_alu depctr_va_vdst(11)
	ds_load_b128 v[242:245] /*v[754:757]*/, v3 /*v515*/
	ds_load_b128 v[246:249] /*v[758:761]*/, v2 /*v514*/
	s_wait_alu depctr_va_vdst(4)
	ds_load_b128 v[170:173] /*v[682:685]*/, v5 /*v517*/
	ds_load_b128 v[174:177] /*v[686:689]*/, v6 /*v518*/
	s_wait_alu depctr_vm_vsrc(2)
	s_set_vgpr_msb 0x8e8a
	v_dual_add_nc_u32 v2 /*v514*/, v115 /*v627*/, v43 /*v555*/ :: v_dual_add_nc_u32 v3 /*v515*/, v115 /*v627*/, v44 /*v556*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v35 /*v547*/, s9, v61 /*v829*/
	v_subrev_nc_u32_e32 v49 /*v561*/, s9, v75 /*v843*/
	v_subrev_nc_u32_e32 v36 /*v548*/, s9, v62 /*v830*/
	v_subrev_nc_u32_e32 v56 /*v568*/, s9, v76 /*v844*/
	ds_load_b128 v[250:253] /*v[762:765]*/, v55 /*v567*/
	ds_load_b128 v[254:257] /*v[766:769]*/, v23 /*v535*/
	ds_load_b128 v[234:237] /*v[746:749]*/, v24 /*v536*/
	ds_load_b128 v[238:241] /*v[750:753]*/, v25 /*v537*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x8e8a
	v_dual_add_nc_u32 v23 /*v535*/, v115 /*v627*/, v31 /*v543*/ :: v_dual_add_nc_u32 v24 /*v536*/, v115 /*v627*/, v32 /*v544*/
	v_dual_add_nc_u32 v4 /*v516*/, v115 /*v627*/, v45 /*v557*/ :: v_dual_add_nc_u32 v5 /*v517*/, v115 /*v627*/, v46 /*v558*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v37 /*v549*/, s9, v63 /*v831*/
	v_subrev_nc_u32_e32 v57 /*v569*/, s9, v77 /*v845*/
	v_subrev_nc_u32_e32 v38 /*v550*/, s9, v64 /*v832*/
	v_subrev_nc_u32_e32 v58 /*v570*/, s9, v78 /*v846*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v25 /*v537*/, v115 /*v627*/, v33 /*v545*/ :: v_dual_add_nc_u32 v31 /*v543*/, v115 /*v627*/, v34 /*v546*/
	v_add_nc_u32_e32 v6 /*v518*/, v115 /*v627*/, v47 /*v559*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v17 /*v529*/, s9, v18 /*v786*/
	v_subrev_nc_u32_e32 v26 /*v538*/, s9, v36 /*v804*/
	v_subrev_nc_u32_e32 v50 /*v562*/, s9, v41 /*v809*/
	v_subrev_nc_u32_e32 v54 /*v566*/, s9, v45 /*v813*/
	v_subrev_nc_u32_e32 v88 /*v600*/, s9, v46 /*v814*/
	v_subrev_nc_u32_e32 v39 /*v551*/, s9, v65 /*v833*/
	v_subrev_nc_u32_e32 v40 /*v552*/, s9, v66 /*v834*/
	v_subrev_nc_u32_e32 v66 /*v578*/, s9, v79 /*v847*/
	s_wait_alu depctr_va_vdst(14)
	ds_load_b128 v[146:149] /*v[658:661]*/, v2 /*v514*/
	ds_load_b128 v[150:153] /*v[662:665]*/, v3 /*v515*/
	ds_load_b128 v[98:101] /*v[610:613]*/, v4 /*v516*/
	ds_load_b128 v[102:105] /*v[614:617]*/, v5 /*v517*/
	s_wait_alu depctr_va_vdst(8)
	ds_load_b128 v[74:77] /*v[586:589]*/, v6 /*v518*/
	s_wait_alu depctr_vm_vsrc(4)
	s_set_vgpr_msb 0x8e8a
	v_add_nc_u32_e32 v2 /*v514*/, v115 /*v627*/, v48 /*v560*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v27 /*v539*/, s9, v37 /*v805*/
	v_subrev_nc_u32_e32 v51 /*v563*/, s9, v42 /*v810*/
	v_subrev_nc_u32_e32 v89 /*v601*/, s9, v48 /*v816*/
	v_subrev_nc_u32_e32 v67 /*v579*/, s9, v80 /*v848*/
	s_wait_alu depctr_vm_vsrc(3)
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v32 /*v544*/, v115 /*v627*/, v35 /*v547*/ :: v_dual_add_nc_u32 v3 /*v515*/, v115 /*v627*/, v49 /*v561*/
	s_wait_alu depctr_vm_vsrc(2)
	v_add_nc_u32_e32 v4 /*v516*/, v115 /*v627*/, v56 /*v568*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v28 /*v540*/, s9, v38 /*v806*/
	v_subrev_nc_u32_e32 v52 /*v564*/, s9, v43 /*v811*/
	v_subrev_nc_u32_e32 v114 /*v626*/, s9, v49 /*v817*/
	v_subrev_nc_u32_e32 v21 /*v533*/, s9, v53 /*v821*/
	ds_load_b128 v[226:229] /*v[738:741]*/, v23 /*v535*/
	ds_load_b128 v[230:233] /*v[742:745]*/, v24 /*v536*/
	ds_load_b128 v[202:205] /*v[714:717]*/, v25 /*v537*/
	ds_load_b128 v[206:209] /*v[718:721]*/, v31 /*v543*/
	s_wait_alu depctr_va_vdst(5)
	ds_load_b128 v[186:189] /*v[698:701]*/, v32 /*v544*/
	s_wait_alu depctr_vm_vsrc(4)
	s_set_vgpr_msb 0x8e8a
	v_add_nc_u32_e32 v23 /*v535*/, v115 /*v627*/, v36 /*v548*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v86 /*v598*/, s9, v20 /*v788*/
	v_subrev_nc_u32_e32 v29 /*v541*/, s9, v39 /*v807*/
	v_subrev_nc_u32_e32 v53 /*v565*/, s9, v44 /*v812*/
	v_subrev_nc_u32_e32 v20 /*v532*/, s9, v52 /*v820*/
	s_wait_alu depctr_vm_vsrc(2)
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v24 /*v536*/, v115 /*v627*/, v37 /*v549*/ :: v_dual_add_nc_u32 v25 /*v537*/, v115 /*v627*/, v38 /*v550*/
	v_dual_add_nc_u32 v5 /*v517*/, v115 /*v627*/, v57 /*v569*/ :: v_dual_add_nc_u32 v6 /*v518*/, v115 /*v627*/, v58 /*v570*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v87 /*v599*/, s9, v21 /*v789*/
	v_subrev_nc_u32_e32 v30 /*v542*/, s9, v40 /*v808*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v31 /*v543*/, v115 /*v627*/, v39 /*v551*/ :: v_dual_add_nc_u32 v32 /*v544*/, v115 /*v627*/, v40 /*v552*/
	ds_load_b128 v[78:81] /*v[590:593]*/, v2 /*v514*/
	ds_load_b128 v[58:61] /*v[570:573]*/, v3 /*v515*/
	s_wait_alu depctr_va_vdst(14)
	ds_load_b128 v[62:65] /*v[574:577]*/, v4 /*v516*/
	s_wait_alu depctr_va_vdst(3)
	ds_load_b128 v[34:37] /*v[546:549]*/, v5 /*v517*/
	ds_load_b128 v[38:41] /*v[550:553]*/, v6 /*v518*/
	s_wait_alu depctr_vm_vsrc(3)
	v_dual_add_nc_u32 v2 /*v514*/, v115 /*v627*/, v66 /*v578*/ :: v_dual_add_nc_u32 v3 /*v515*/, v115 /*v627*/, v67 /*v579*/
	v_dual_add_nc_u32 v10 /*v522*/, v115 /*v627*/, v17 /*v529*/ :: v_dual_add_nc_u32 v14 /*v526*/, v115 /*v627*/, v26 /*v538*/
	v_dual_add_nc_u32 v50 /*v562*/, v115 /*v627*/, v50 /*v562*/ :: v_dual_add_nc_u32 v55 /*v567*/, v115 /*v627*/, v51 /*v563*/
	v_dual_add_nc_u32 v82 /*v594*/, v115 /*v627*/, v54 /*v566*/ :: v_dual_add_nc_u32 v88 /*v600*/, v115 /*v627*/, v88 /*v600*/
	v_dual_add_nc_u32 v26 /*v538*/, v115 /*v627*/, v27 /*v539*/ :: v_dual_add_nc_u32 v116 /*v628*/, v115 /*v627*/, v89 /*v601*/
	v_add_nc_u32_e32 v118 /*v630*/, v115 /*v627*/, v114 /*v626*/
	ds_load_b128 v[190:193] /*v[702:705]*/, v23 /*v535*/
	ds_load_b128 v[154:157] /*v[666:669]*/, v24 /*v536*/
	ds_load_b128 v[158:161] /*v[670:673]*/, v25 /*v537*/
	s_wait_alu depctr_va_vdst(6)
	ds_load_b128 v[122:125] /*v[634:637]*/, v31 /*v543*/
	ds_load_b128 v[126:129] /*v[638:641]*/, v32 /*v544*/
	s_wait_alu depctr_vm_vsrc(5)
	v_dual_add_nc_u32 v4 /*v516*/, v115 /*v627*/, v21 /*v533*/ :: v_dual_add_nc_u32 v6 /*v518*/, v115 /*v627*/, v20 /*v532*/
	s_wait_alu depctr_vm_vsrc(1)
	v_add_nc_u32_e32 v31 /*v543*/, v115 /*v627*/, v28 /*v540*/
	v_dual_add_nc_u32 v66 /*v578*/, v115 /*v627*/, v52 /*v564*/ :: v_dual_add_nc_u32 v70 /*v582*/, v115 /*v627*/, v53 /*v565*/
	v_dual_add_nc_u32 v42 /*v554*/, v115 /*v627*/, v29 /*v541*/ :: v_dual_add_nc_u32 v46 /*v558*/, v115 /*v627*/, v30 /*v542*/
	v_dual_add_nc_u32 v138 /*v650*/, v115 /*v627*/, v86 /*v598*/ :: v_dual_add_nc_u32 v142 /*v654*/, v115 /*v627*/, v87 /*v599*/
	s_wait_alu depctr_va_vdst(10)
	ds_load_b128 v[18:21] /*v[530:533]*/, v2 /*v514*/
	ds_load_b128 v[22:25] /*v[534:537]*/, v3 /*v515*/
	s_wait_alu depctr_va_vdst(4) depctr_vm_vsrc(0)
	ds_load_b128 v[2:5] /*v[514:517]*/, v4 /*v516*/
	ds_load_b128 v[6:9] /*v[518:521]*/, v6 /*v518*/
	ds_load_b128 v[10:13] /*v[522:525]*/, v10 /*v522*/
	ds_load_b128 v[14:17] /*v[526:529]*/, v14 /*v526*/
	ds_load_b128 v[26:29] /*v[538:541]*/, v26 /*v538*/
	s_wait_alu depctr_va_vdst(3)
	ds_load_b128 v[30:33] /*v[542:545]*/, v31 /*v543*/
	s_wait_alu depctr_va_vdst(1)
	ds_load_b128 v[42:45] /*v[554:557]*/, v42 /*v554*/
	ds_load_b128 v[46:49] /*v[558:561]*/, v46 /*v558*/
	ds_load_b128 v[50:53] /*v[562:565]*/, v50 /*v562*/
	ds_load_b128 v[54:57] /*v[566:569]*/, v55 /*v567*/
	ds_load_b128 v[66:69] /*v[578:581]*/, v66 /*v578*/
	ds_load_b128 v[70:73] /*v[582:585]*/, v70 /*v582*/
	ds_load_b128 v[82:85] /*v[594:597]*/, v82 /*v594*/
	ds_load_b128 v[86:89] /*v[598:601]*/, v88 /*v600*/
	ds_load_b128 v[114:117] /*v[626:629]*/, v116 /*v628*/
	ds_load_b128 v[118:121] /*v[630:633]*/, v118 /*v630*/
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[138:141] /*v[650:653]*/, v138 /*v650*/
	ds_load_b128 v[142:145] /*v[654:657]*/, v142 /*v654*/
	s_mul_hi_u32 s9, s40, 0xaaaaaaab
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_lshr_b32 s9, s9, 1
	s_mul_i32 s9, s9, 0x36000
	s_delay_alu instid0(SALU_CYCLE_1)
	s_sub_co_i32 s44, 0x2d000, s9
	s_wait_dscnt 0x20
	s_and_b32 vcc_lo, exec_lo, s0
	s_set_vgpr_msb 0x8a00
	s_cbranch_vccz .LBB0_16
	s_and_b32 vcc_lo, exec_lo, s1
	s_cbranch_vccnz .LBB0_13
	s_branch .LBB0_17
.LBB0_16:
	s_add_co_i32 s9, s41, 0
	s_or_b32 s11, s7, 0x80000000
	s_add_co_i32 s9, s9, s44
	s_mov_b32 s10, s6
	s_add_co_i32 s9, s9, 0xffff7000
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[8:11], s[12:19]
	s_and_b32 vcc_lo, exec_lo, s1
	s_cbranch_vccnz .LBB0_13
.LBB0_17:
	s_add_co_i32 s9, s41, 0
	s_or_b32 s11, s35, 0x80000000
	s_add_co_i32 s9, s9, s44
	s_mov_b32 s10, s34
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[8:11], s[20:27]
	s_branch .LBB0_13
.LBB0_18:
	v_mov_b32_e32 v1, s39
	s_wait_alu depctr_vm_vsrc(6)
	v_nop
	s_set_vgpr_msb 0x83
	v_dual_mov_b32 v42 /*v554*/, s38 :: v_dual_mov_b32 v43 /*v555*/, v17 /*v785*/
	v_nop
	v_dual_mov_b32 v4 /*v516*/, v15 /*v783*/ :: v_dual_mov_b32 v2 /*v514*/, v16 /*v784*/
	v_mov_b32_e32 v3 /*v515*/, v14 /*v782*/
	s_set_vgpr_msb 0x8300
.LBB0_19:
	s_mul_hi_i32 s0, s29, 0x55555556
	s_set_vgpr_msb 0xab
	v_add3_u32 v5 /*v517*/, v13 /*v781*/, s36, 16
	s_lshr_b32 s1, s0, 31
	s_mov_b32 s7, 0
	s_add_co_i32 s0, s0, s1
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mad_u32_u24 v4 /*v516*/, 0x90, v5 /*v517*/, v4 /*v516*/
	s_mul_i32 s0, s0, 3
	s_sub_co_i32 s0, s29, s0
	s_ashr_i32 s29, s28, 31
	s_mul_i32 s0, s0, 0x12000
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_co_i32 s0, s0, 0
	s_set_vgpr_msb 0xab8c
	v_dual_add_nc_u32 v5 /*v517*/, s0, v9 /*v777*/ :: v_dual_add_nc_u32 v38 /*v550*/, s0, v11 /*v779*/
	s_set_vgpr_msb 0x8c88
	v_add_nc_u32_e32 v41 /*v553*/, s0, v4 /*v516*/
	s_set_vgpr_msb 0x888c
	v_dual_add_nc_u32 v39 /*v551*/, s0, v8 /*v776*/ :: v_dual_add_nc_u32 v40 /*v552*/, s0, v10 /*v778*/
	s_set_vgpr_msb 0x8c0c
	v_add_nc_u32_e32 v0, s0, v12 /*v780*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0xc8a
	ds_load_b128 v[68:71] /*v[580:583]*/, v5 /*v517*/
	ds_load_b128 v[72:75] /*v[584:587]*/, v38 /*v550*/
	ds_load_b128 v[76:79] /*v[588:591]*/, v39 /*v551*/
	s_wait_alu depctr_vm_vsrc(6)
	ds_load_b128 v[80:83] /*v[592:595]*/, v40 /*v552*/
	ds_load_b128 v[84:87] /*v[596:599]*/, v41 /*v553*/
	ds_load_b128 v[88:91] /*v[600:603]*/, v41 /*v553*/ offset:32
	ds_load_b128 v[92:95] /*v[604:607]*/, v41 /*v553*/ offset:2304
	ds_load_b128 v[96:99] /*v[608:611]*/, v41 /*v553*/ offset:2336
	ds_load_b128 v[100:103] /*v[612:615]*/, v41 /*v553*/ offset:4608
	ds_load_b128 v[104:107] /*v[616:619]*/, v41 /*v553*/ offset:4640
	ds_load_b128 v[108:111] /*v[620:623]*/, v41 /*v553*/ offset:6912
	ds_load_b128 v[112:115] /*v[624:627]*/, v41 /*v553*/ offset:6944
	s_wait_alu depctr_vm_vsrc(6)
	ds_load_b128 v[116:119] /*v[628:631]*/, v41 /*v553*/ offset:9216
	ds_load_b128 v[120:123] /*v[632:635]*/, v41 /*v553*/ offset:9248
	v_dual_add_nc_u32 v5 /*v517*/, s0, v2 /*v514*/ :: v_dual_add_nc_u32 v38 /*v550*/, s0, v3 /*v515*/
	ds_load_b128 v[124:127] /*v[636:639]*/, v41 /*v553*/ offset:11520
	ds_load_b128 v[128:131] /*v[640:643]*/, v41 /*v553*/ offset:11552
	ds_load_b128 v[132:135] /*v[644:647]*/, v41 /*v553*/ offset:13824
	ds_load_b128 v[136:139] /*v[648:651]*/, v41 /*v553*/ offset:13856
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[140:143] /*v[652:655]*/, v5 /*v517*/
	ds_load_b128 v[144:147] /*v[656:659]*/, v38 /*v550*/
	s_set_vgpr_msb 0x8a8c
	ds_load_b128 v[148:151] /*v[660:663]*/, v0 offset:2368
	ds_load_b128 v[152:155] /*v[664:667]*/, v0 offset:2400
	ds_load_b128 v[156:159] /*v[668:671]*/, v0 offset:4672
	ds_load_b128 v[160:163] /*v[672:675]*/, v0 offset:4704
	ds_load_b128 v[164:167] /*v[676:679]*/, v0 offset:6976
	ds_load_b128 v[168:171] /*v[680:683]*/, v0 offset:7008
	ds_load_b128 v[172:175] /*v[684:687]*/, v0 offset:9280
	ds_load_b128 v[176:179] /*v[688:691]*/, v0 offset:9312
	ds_load_b128 v[180:183] /*v[692:695]*/, v0 offset:11584
	ds_load_b128 v[184:187] /*v[696:699]*/, v0 offset:11616
	s_wait_alu depctr_vm_vsrc(6)
	v_dual_add_nc_u32 v5 /*v517*/, s0, v6 /*v774*/ :: v_dual_add_nc_u32 v38 /*v550*/, s0, v7 /*v775*/
	v_dual_add_nc_u32 v39 /*v551*/, s0, v4 /*v772*/ :: v_dual_add_nc_u32 v40 /*v552*/, s0, v5 /*v773*/
	ds_load_b128 v[188:191] /*v[700:703]*/, v0 offset:13888
	ds_load_b128 v[192:195] /*v[704:707]*/, v0 offset:13920
	s_wait_alu depctr_va_vdst(1)
	s_set_vgpr_msb 0x8c82
	ds_load_b128 v[196:199] /*v[708:711]*/, v5 /*v517*/
	ds_load_b128 v[200:203] /*v[712:715]*/, v38 /*v550*/
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[204:207] /*v[716:719]*/, v39 /*v551*/
	ds_load_b128 v[208:211] /*v[720:723]*/, v40 /*v552*/
	ds_load_b128 v[212:215] /*v[724:727]*/, v41 /*v553*/ offset:64
	ds_load_b128 v[216:219] /*v[728:731]*/, v41 /*v553*/ offset:96
	ds_load_b128 v[220:223] /*v[732:735]*/, v41 /*v553*/ offset:2368
	ds_load_b128 v[224:227] /*v[736:739]*/, v41 /*v553*/ offset:2400
	ds_load_b128 v[228:231] /*v[740:743]*/, v41 /*v553*/ offset:4672
	ds_load_b128 v[232:235] /*v[744:747]*/, v41 /*v553*/ offset:4704
	ds_load_b128 v[236:239] /*v[748:751]*/, v41 /*v553*/ offset:6976
	ds_load_b128 v[240:243] /*v[752:755]*/, v41 /*v553*/ offset:7008
	ds_load_b128 v[244:247] /*v[756:759]*/, v41 /*v553*/ offset:9280
	ds_load_b128 v[248:251] /*v[760:763]*/, v41 /*v553*/ offset:9312
	s_set_vgpr_msb 0x82c2
	ds_load_b128 v[14:17] /*v[782:785]*/, v41 /*v553*/ offset:11584
	ds_load_b128 v[18:21] /*v[786:789]*/, v41 /*v553*/ offset:11616
	ds_load_b128 v[22:25] /*v[790:793]*/, v41 /*v553*/ offset:13888
	ds_load_b128 v[26:29] /*v[794:797]*/, v41 /*v553*/ offset:13920
	s_set_vgpr_msb 0xc280
	ds_load_b128 v[6:9] /*v[518:521]*/, v0
	ds_load_b128 v[10:13] /*v[522:525]*/, v0 offset:32
	ds_load_b128 v[14:17] /*v[526:529]*/, v0 offset:2304
	ds_load_b128 v[18:21] /*v[530:533]*/, v0 offset:2336
	ds_load_b128 v[22:25] /*v[534:537]*/, v0 offset:4608
	ds_load_b128 v[26:29] /*v[538:541]*/, v0 offset:4640
	ds_load_b128 v[30:33] /*v[542:545]*/, v0 offset:6912
	ds_load_b128 v[34:37] /*v[546:549]*/, v0 offset:6944
	ds_load_b128 v[44:47] /*v[556:559]*/, v0 offset:9216
	ds_load_b128 v[48:51] /*v[560:563]*/, v0 offset:9248
	ds_load_b128 v[52:55] /*v[564:567]*/, v0 offset:11520
	ds_load_b128 v[56:59] /*v[568:571]*/, v0 offset:11552
	ds_load_b128 v[60:63] /*v[572:575]*/, v0 offset:13824
	ds_load_b128 v[64:67] /*v[576:579]*/, v0 offset:13856
	s_set_vgpr_msb 0x800a
	s_wait_dscnt 0xc
	v_wmma_f32_16x16x32_bf16 v[2:9], v[76:83] /*v[588:595]*/, v[6:13] /*v[518:525]*/, v[2:9]
	s_wait_dscnt 0x20
	v_wmma_f32_16x16x32_bf16 v[10:17], v[84:91] /*v[596:603]*/, v[6:13] /*v[518:525]*/, v[10:17]
	v_wmma_f32_16x16x32_bf16 v[18:25], v[92:99] /*v[604:611]*/, v[6:13] /*v[518:525]*/, v[18:25]
	v_wmma_f32_16x16x32_bf16 v[34:41], v[100:107] /*v[612:619]*/, v[6:13] /*v[518:525]*/, v[34:41]
	v_wmma_f32_16x16x32_bf16 v[42:49], v[108:115] /*v[620:627]*/, v[6:13] /*v[518:525]*/, v[42:49]
	v_wmma_f32_16x16x32_bf16 v[50:57], v[116:123] /*v[628:635]*/, v[6:13] /*v[518:525]*/, v[50:57]
	v_wmma_f32_16x16x32_bf16 v[66:73], v[124:131] /*v[636:643]*/, v[6:13] /*v[518:525]*/, v[66:73]
	v_wmma_f32_16x16x32_bf16 v[90:97], v[132:139] /*v[644:651]*/, v[6:13] /*v[518:525]*/, v[90:97]
	s_wait_dscnt 0xa
	v_wmma_f32_16x16x32_bf16 v[226:233], v[132:139] /*v[644:651]*/, v[14:21] /*v[526:533]*/, v[226:233]
	v_wmma_f32_16x16x32_bf16 v[194:201], v[124:131] /*v[636:643]*/, v[14:21] /*v[526:533]*/, v[194:201]
	v_wmma_f32_16x16x32_bf16 v[170:177], v[116:123] /*v[628:635]*/, v[14:21] /*v[526:533]*/, v[170:177]
	v_wmma_f32_16x16x32_bf16 v[162:169], v[108:115] /*v[620:627]*/, v[14:21] /*v[526:533]*/, v[162:169]
	v_wmma_f32_16x16x32_bf16 v[146:153], v[100:107] /*v[612:619]*/, v[14:21] /*v[526:533]*/, v[146:153]
	v_wmma_f32_16x16x32_bf16 v[106:113], v[92:99] /*v[604:611]*/, v[14:21] /*v[526:533]*/, v[106:113]
	v_wmma_f32_16x16x32_bf16 v[58:65], v[84:91] /*v[596:603]*/, v[14:21] /*v[526:533]*/, v[58:65]
	v_wmma_f32_16x16x32_bf16 v[26:33], v[76:83] /*v[588:595]*/, v[14:21] /*v[526:533]*/, v[26:33]
	s_wait_dscnt 0x8
	v_wmma_f32_16x16x32_bf16 v[178:185], v[76:83] /*v[588:595]*/, v[22:29] /*v[534:541]*/, v[178:185]
	v_wmma_f32_16x16x32_bf16 v[186:193], v[84:91] /*v[596:603]*/, v[22:29] /*v[534:541]*/, v[186:193]
	v_wmma_f32_16x16x32_bf16 v[202:209], v[92:99] /*v[604:611]*/, v[22:29] /*v[534:541]*/, v[202:209]
	v_wmma_f32_16x16x32_bf16 v[210:217], v[100:107] /*v[612:619]*/, v[22:29] /*v[534:541]*/, v[210:217]
	v_wmma_f32_16x16x32_bf16 v[218:225], v[108:115] /*v[620:627]*/, v[22:29] /*v[534:541]*/, v[218:225]
	v_wmma_f32_16x16x32_bf16 v[234:241], v[116:123] /*v[628:635]*/, v[22:29] /*v[534:541]*/, v[234:241]
	v_wmma_f32_16x16x32_bf16 v[242:249], v[124:131] /*v[636:643]*/, v[22:29] /*v[534:541]*/, v[242:249]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[58:65] /*v[314:321]*/, v[132:139] /*v[644:651]*/, v[22:29] /*v[534:541]*/, v[58:65] /*v[314:321]*/
	s_wait_dscnt 0x6
	v_wmma_f32_16x16x32_bf16 v[50:57] /*v[306:313]*/, v[132:139] /*v[644:651]*/, v[30:37] /*v[542:549]*/, v[50:57] /*v[306:313]*/
	v_wmma_f32_16x16x32_bf16 v[42:49] /*v[298:305]*/, v[124:131] /*v[636:643]*/, v[30:37] /*v[542:549]*/, v[42:49] /*v[298:305]*/
	v_wmma_f32_16x16x32_bf16 v[34:41] /*v[290:297]*/, v[116:123] /*v[628:635]*/, v[30:37] /*v[542:549]*/, v[34:41] /*v[290:297]*/
	v_wmma_f32_16x16x32_bf16 v[26:33] /*v[282:289]*/, v[108:115] /*v[620:627]*/, v[30:37] /*v[542:549]*/, v[26:33] /*v[282:289]*/
	v_wmma_f32_16x16x32_bf16 v[18:25] /*v[274:281]*/, v[100:107] /*v[612:619]*/, v[30:37] /*v[542:549]*/, v[18:25] /*v[274:281]*/
	v_wmma_f32_16x16x32_bf16 v[10:17] /*v[266:273]*/, v[92:99] /*v[604:611]*/, v[30:37] /*v[542:549]*/, v[10:17] /*v[266:273]*/
	v_wmma_f32_16x16x32_bf16 v[2:9] /*v[258:265]*/, v[84:91] /*v[596:603]*/, v[30:37] /*v[542:549]*/, v[2:9] /*v[258:265]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[250:257], v[76:83] /*v[588:595]*/, v[30:37] /*v[542:549]*/, v[250:257]
	s_set_vgpr_msb 0xa5a
	s_wait_dscnt 0x4
	v_wmma_f32_16x16x32_bf16 v[66:73] /*v[322:329]*/, v[76:83] /*v[588:595]*/, v[44:51] /*v[556:563]*/, v[66:73] /*v[322:329]*/
	v_wmma_f32_16x16x32_bf16 v[74:81] /*v[330:337]*/, v[84:91] /*v[596:603]*/, v[44:51] /*v[556:563]*/, v[74:81] /*v[330:337]*/
	v_wmma_f32_16x16x32_bf16 v[82:89] /*v[338:345]*/, v[92:99] /*v[604:611]*/, v[44:51] /*v[556:563]*/, v[82:89] /*v[338:345]*/
	v_wmma_f32_16x16x32_bf16 v[98:105] /*v[354:361]*/, v[100:107] /*v[612:619]*/, v[44:51] /*v[556:563]*/, v[98:105] /*v[354:361]*/
	v_wmma_f32_16x16x32_bf16 v[106:113] /*v[362:369]*/, v[108:115] /*v[620:627]*/, v[44:51] /*v[556:563]*/, v[106:113] /*v[362:369]*/
	v_wmma_f32_16x16x32_bf16 v[114:121] /*v[370:377]*/, v[116:123] /*v[628:635]*/, v[44:51] /*v[556:563]*/, v[114:121] /*v[370:377]*/
	v_wmma_f32_16x16x32_bf16 v[130:137] /*v[386:393]*/, v[124:131] /*v[636:643]*/, v[44:51] /*v[556:563]*/, v[130:137] /*v[386:393]*/
	v_wmma_f32_16x16x32_bf16 v[138:145] /*v[394:401]*/, v[132:139] /*v[644:651]*/, v[44:51] /*v[556:563]*/, v[138:145] /*v[394:401]*/
	s_wait_dscnt 0x2
	v_wmma_f32_16x16x32_bf16 v[226:233] /*v[482:489]*/, v[132:139] /*v[644:651]*/, v[52:59] /*v[564:571]*/, v[226:233] /*v[482:489]*/
	v_wmma_f32_16x16x32_bf16 v[194:201] /*v[450:457]*/, v[124:131] /*v[636:643]*/, v[52:59] /*v[564:571]*/, v[194:201] /*v[450:457]*/
	v_wmma_f32_16x16x32_bf16 v[170:177] /*v[426:433]*/, v[116:123] /*v[628:635]*/, v[52:59] /*v[564:571]*/, v[170:177] /*v[426:433]*/
	v_wmma_f32_16x16x32_bf16 v[162:169] /*v[418:425]*/, v[108:115] /*v[620:627]*/, v[52:59] /*v[564:571]*/, v[162:169] /*v[418:425]*/
	v_wmma_f32_16x16x32_bf16 v[154:161] /*v[410:417]*/, v[100:107] /*v[612:619]*/, v[52:59] /*v[564:571]*/, v[154:161] /*v[410:417]*/
	v_wmma_f32_16x16x32_bf16 v[146:153] /*v[402:409]*/, v[92:99] /*v[604:611]*/, v[52:59] /*v[564:571]*/, v[146:153] /*v[402:409]*/
	v_wmma_f32_16x16x32_bf16 v[122:129] /*v[378:385]*/, v[84:91] /*v[596:603]*/, v[52:59] /*v[564:571]*/, v[122:129] /*v[378:385]*/
	v_wmma_f32_16x16x32_bf16 v[90:97] /*v[346:353]*/, v[76:83] /*v[588:595]*/, v[52:59] /*v[564:571]*/, v[90:97] /*v[346:353]*/
	s_wait_dscnt 0x0
	v_wmma_f32_16x16x32_bf16 v[178:185] /*v[434:441]*/, v[76:83] /*v[588:595]*/, v[60:67] /*v[572:579]*/, v[178:185] /*v[434:441]*/
	v_wmma_f32_16x16x32_bf16 v[186:193] /*v[442:449]*/, v[84:91] /*v[596:603]*/, v[60:67] /*v[572:579]*/, v[186:193] /*v[442:449]*/
	v_wmma_f32_16x16x32_bf16 v[202:209] /*v[458:465]*/, v[92:99] /*v[604:611]*/, v[60:67] /*v[572:579]*/, v[202:209] /*v[458:465]*/
	v_wmma_f32_16x16x32_bf16 v[210:217] /*v[466:473]*/, v[100:107] /*v[612:619]*/, v[60:67] /*v[572:579]*/, v[210:217] /*v[466:473]*/
	v_wmma_f32_16x16x32_bf16 v[218:225] /*v[474:481]*/, v[108:115] /*v[620:627]*/, v[60:67] /*v[572:579]*/, v[218:225] /*v[474:481]*/
	v_wmma_f32_16x16x32_bf16 v[234:241] /*v[490:497]*/, v[116:123] /*v[628:635]*/, v[60:67] /*v[572:579]*/, v[234:241] /*v[490:497]*/
	v_wmma_f32_16x16x32_bf16 v[242:249] /*v[498:505]*/, v[124:131] /*v[636:643]*/, v[60:67] /*v[572:579]*/, v[242:249] /*v[498:505]*/
	v_wmma_f32_16x16x32_bf16 v[250:257] /*v[506:513]*/, v[132:139] /*v[644:651]*/, v[60:67] /*v[572:579]*/, v[250:257] /*v[506:513]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[154:161], v[132:139] /*v[644:651]*/, v[68:75] /*v[580:587]*/, v[154:161]
	v_wmma_f32_16x16x32_bf16 v[138:145], v[124:131] /*v[636:643]*/, v[68:75] /*v[580:587]*/, v[138:145]
	v_wmma_f32_16x16x32_bf16 v[130:137], v[116:123] /*v[628:635]*/, v[68:75] /*v[580:587]*/, v[130:137]
	v_wmma_f32_16x16x32_bf16 v[122:129], v[108:115] /*v[620:627]*/, v[68:75] /*v[580:587]*/, v[122:129]
	v_wmma_f32_16x16x32_bf16 v[114:121], v[100:107] /*v[612:619]*/, v[68:75] /*v[580:587]*/, v[114:121]
	v_wmma_f32_16x16x32_bf16 v[98:105], v[92:99] /*v[604:611]*/, v[68:75] /*v[580:587]*/, v[98:105]
	v_wmma_f32_16x16x32_bf16 v[82:89], v[84:91] /*v[596:603]*/, v[68:75] /*v[580:587]*/, v[82:89]
	v_wmma_f32_16x16x32_bf16 v[74:81], v[76:83] /*v[588:595]*/, v[68:75] /*v[580:587]*/, v[74:81]
	s_wait_dscnt 0x0
	s_wait_tensorcnt 0x0
	s_barrier_signal -1
	v_wmma_f32_16x16x32_bf16 v[2:9], v[204:211] /*v[716:723]*/, v[140:147] /*v[652:659]*/, v[2:9]
	v_wmma_f32_16x16x32_bf16 v[10:17], v[212:219] /*v[724:731]*/, v[140:147] /*v[652:659]*/, v[10:17]
	v_wmma_f32_16x16x32_bf16 v[18:25], v[220:227] /*v[732:739]*/, v[140:147] /*v[652:659]*/, v[18:25]
	v_wmma_f32_16x16x32_bf16 v[34:41], v[228:235] /*v[740:747]*/, v[140:147] /*v[652:659]*/, v[34:41]
	v_wmma_f32_16x16x32_bf16 v[42:49], v[236:243] /*v[748:755]*/, v[140:147] /*v[652:659]*/, v[42:49]
	v_wmma_f32_16x16x32_bf16 v[50:57], v[244:251] /*v[756:763]*/, v[140:147] /*v[652:659]*/, v[50:57]
	s_set_vgpr_msb 0xa0b
	v_wmma_f32_16x16x32_bf16 v[66:73], v[14:21] /*v[782:789]*/, v[140:147] /*v[652:659]*/, v[66:73]
	v_wmma_f32_16x16x32_bf16 v[90:97], v[22:29] /*v[790:797]*/, v[140:147] /*v[652:659]*/, v[90:97]
	v_wmma_f32_16x16x32_bf16 v[226:233], v[22:29] /*v[790:797]*/, v[148:155] /*v[660:667]*/, v[226:233]
	v_wmma_f32_16x16x32_bf16 v[194:201], v[14:21] /*v[782:789]*/, v[148:155] /*v[660:667]*/, v[194:201]
	s_set_vgpr_msb 0xb0a
	v_wmma_f32_16x16x32_bf16 v[170:177], v[244:251] /*v[756:763]*/, v[148:155] /*v[660:667]*/, v[170:177]
	v_wmma_f32_16x16x32_bf16 v[162:169], v[236:243] /*v[748:755]*/, v[148:155] /*v[660:667]*/, v[162:169]
	v_wmma_f32_16x16x32_bf16 v[146:153], v[228:235] /*v[740:747]*/, v[148:155] /*v[660:667]*/, v[146:153]
	v_wmma_f32_16x16x32_bf16 v[106:113], v[220:227] /*v[732:739]*/, v[148:155] /*v[660:667]*/, v[106:113]
	v_wmma_f32_16x16x32_bf16 v[58:65], v[212:219] /*v[724:731]*/, v[148:155] /*v[660:667]*/, v[58:65]
	v_wmma_f32_16x16x32_bf16 v[26:33], v[204:211] /*v[716:723]*/, v[148:155] /*v[660:667]*/, v[26:33]
	v_wmma_f32_16x16x32_bf16 v[178:185], v[204:211] /*v[716:723]*/, v[156:163] /*v[668:675]*/, v[178:185]
	v_wmma_f32_16x16x32_bf16 v[186:193], v[212:219] /*v[724:731]*/, v[156:163] /*v[668:675]*/, v[186:193]
	v_wmma_f32_16x16x32_bf16 v[202:209], v[220:227] /*v[732:739]*/, v[156:163] /*v[668:675]*/, v[202:209]
	v_wmma_f32_16x16x32_bf16 v[210:217], v[228:235] /*v[740:747]*/, v[156:163] /*v[668:675]*/, v[210:217]
	v_wmma_f32_16x16x32_bf16 v[218:225], v[236:243] /*v[748:755]*/, v[156:163] /*v[668:675]*/, v[218:225]
	v_wmma_f32_16x16x32_bf16 v[234:241], v[244:251] /*v[756:763]*/, v[156:163] /*v[668:675]*/, v[234:241]
	s_set_vgpr_msb 0xa0b
	v_wmma_f32_16x16x32_bf16 v[242:249], v[14:21] /*v[782:789]*/, v[156:163] /*v[668:675]*/, v[242:249]
	s_set_vgpr_msb 0xb5b
	v_wmma_f32_16x16x32_bf16 v[58:65] /*v[314:321]*/, v[22:29] /*v[790:797]*/, v[156:163] /*v[668:675]*/, v[58:65] /*v[314:321]*/
	v_wmma_f32_16x16x32_bf16 v[50:57] /*v[306:313]*/, v[22:29] /*v[790:797]*/, v[164:171] /*v[676:683]*/, v[50:57] /*v[306:313]*/
	v_wmma_f32_16x16x32_bf16 v[42:49] /*v[298:305]*/, v[14:21] /*v[782:789]*/, v[164:171] /*v[676:683]*/, v[42:49] /*v[298:305]*/
	s_set_vgpr_msb 0x5b5a
	v_wmma_f32_16x16x32_bf16 v[34:41] /*v[290:297]*/, v[244:251] /*v[756:763]*/, v[164:171] /*v[676:683]*/, v[34:41] /*v[290:297]*/
	v_wmma_f32_16x16x32_bf16 v[26:33] /*v[282:289]*/, v[236:243] /*v[748:755]*/, v[164:171] /*v[676:683]*/, v[26:33] /*v[282:289]*/
	v_wmma_f32_16x16x32_bf16 v[18:25] /*v[274:281]*/, v[228:235] /*v[740:747]*/, v[164:171] /*v[676:683]*/, v[18:25] /*v[274:281]*/
	v_wmma_f32_16x16x32_bf16 v[10:17] /*v[266:273]*/, v[220:227] /*v[732:739]*/, v[164:171] /*v[676:683]*/, v[10:17] /*v[266:273]*/
	v_wmma_f32_16x16x32_bf16 v[2:9] /*v[258:265]*/, v[212:219] /*v[724:731]*/, v[164:171] /*v[676:683]*/, v[2:9] /*v[258:265]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[250:257], v[204:211] /*v[716:723]*/, v[164:171] /*v[676:683]*/, v[250:257]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[66:73] /*v[322:329]*/, v[204:211] /*v[716:723]*/, v[172:179] /*v[684:691]*/, v[66:73] /*v[322:329]*/
	v_wmma_f32_16x16x32_bf16 v[74:81] /*v[330:337]*/, v[212:219] /*v[724:731]*/, v[172:179] /*v[684:691]*/, v[74:81] /*v[330:337]*/
	v_wmma_f32_16x16x32_bf16 v[82:89] /*v[338:345]*/, v[220:227] /*v[732:739]*/, v[172:179] /*v[684:691]*/, v[82:89] /*v[338:345]*/
	v_wmma_f32_16x16x32_bf16 v[98:105] /*v[354:361]*/, v[228:235] /*v[740:747]*/, v[172:179] /*v[684:691]*/, v[98:105] /*v[354:361]*/
	v_wmma_f32_16x16x32_bf16 v[106:113] /*v[362:369]*/, v[236:243] /*v[748:755]*/, v[172:179] /*v[684:691]*/, v[106:113] /*v[362:369]*/
	v_wmma_f32_16x16x32_bf16 v[114:121] /*v[370:377]*/, v[244:251] /*v[756:763]*/, v[172:179] /*v[684:691]*/, v[114:121] /*v[370:377]*/
	s_set_vgpr_msb 0x5a5b
	v_wmma_f32_16x16x32_bf16 v[130:137] /*v[386:393]*/, v[14:21] /*v[782:789]*/, v[172:179] /*v[684:691]*/, v[130:137] /*v[386:393]*/
	v_wmma_f32_16x16x32_bf16 v[138:145] /*v[394:401]*/, v[22:29] /*v[790:797]*/, v[172:179] /*v[684:691]*/, v[138:145] /*v[394:401]*/
	v_wmma_f32_16x16x32_bf16 v[226:233] /*v[482:489]*/, v[22:29] /*v[790:797]*/, v[180:187] /*v[692:699]*/, v[226:233] /*v[482:489]*/
	v_wmma_f32_16x16x32_bf16 v[194:201] /*v[450:457]*/, v[14:21] /*v[782:789]*/, v[180:187] /*v[692:699]*/, v[194:201] /*v[450:457]*/
	s_set_vgpr_msb 0x5b5a
	v_wmma_f32_16x16x32_bf16 v[170:177] /*v[426:433]*/, v[244:251] /*v[756:763]*/, v[180:187] /*v[692:699]*/, v[170:177] /*v[426:433]*/
	v_wmma_f32_16x16x32_bf16 v[162:169] /*v[418:425]*/, v[236:243] /*v[748:755]*/, v[180:187] /*v[692:699]*/, v[162:169] /*v[418:425]*/
	v_wmma_f32_16x16x32_bf16 v[154:161] /*v[410:417]*/, v[228:235] /*v[740:747]*/, v[180:187] /*v[692:699]*/, v[154:161] /*v[410:417]*/
	v_wmma_f32_16x16x32_bf16 v[146:153] /*v[402:409]*/, v[220:227] /*v[732:739]*/, v[180:187] /*v[692:699]*/, v[146:153] /*v[402:409]*/
	v_wmma_f32_16x16x32_bf16 v[122:129] /*v[378:385]*/, v[212:219] /*v[724:731]*/, v[180:187] /*v[692:699]*/, v[122:129] /*v[378:385]*/
	v_wmma_f32_16x16x32_bf16 v[90:97] /*v[346:353]*/, v[204:211] /*v[716:723]*/, v[180:187] /*v[692:699]*/, v[90:97] /*v[346:353]*/
	v_wmma_f32_16x16x32_bf16 v[178:185] /*v[434:441]*/, v[204:211] /*v[716:723]*/, v[188:195] /*v[700:707]*/, v[178:185] /*v[434:441]*/
	v_wmma_f32_16x16x32_bf16 v[186:193] /*v[442:449]*/, v[212:219] /*v[724:731]*/, v[188:195] /*v[700:707]*/, v[186:193] /*v[442:449]*/
	v_wmma_f32_16x16x32_bf16 v[202:209] /*v[458:465]*/, v[220:227] /*v[732:739]*/, v[188:195] /*v[700:707]*/, v[202:209] /*v[458:465]*/
	v_wmma_f32_16x16x32_bf16 v[210:217] /*v[466:473]*/, v[228:235] /*v[740:747]*/, v[188:195] /*v[700:707]*/, v[210:217] /*v[466:473]*/
	v_wmma_f32_16x16x32_bf16 v[218:225] /*v[474:481]*/, v[236:243] /*v[748:755]*/, v[188:195] /*v[700:707]*/, v[218:225] /*v[474:481]*/
	v_wmma_f32_16x16x32_bf16 v[234:241] /*v[490:497]*/, v[244:251] /*v[756:763]*/, v[188:195] /*v[700:707]*/, v[234:241] /*v[490:497]*/
	s_set_vgpr_msb 0x5a5b
	v_wmma_f32_16x16x32_bf16 v[242:249] /*v[498:505]*/, v[14:21] /*v[782:789]*/, v[188:195] /*v[700:707]*/, v[242:249] /*v[498:505]*/
	v_wmma_f32_16x16x32_bf16 v[250:257] /*v[506:513]*/, v[22:29] /*v[790:797]*/, v[188:195] /*v[700:707]*/, v[250:257] /*v[506:513]*/
	s_set_vgpr_msb 0x5b0b
	v_wmma_f32_16x16x32_bf16 v[154:161], v[22:29] /*v[790:797]*/, v[196:203] /*v[708:715]*/, v[154:161]
	v_wmma_f32_16x16x32_bf16 v[138:145], v[14:21] /*v[782:789]*/, v[196:203] /*v[708:715]*/, v[138:145]
	s_set_vgpr_msb 0xb0a
	v_wmma_f32_16x16x32_bf16 v[130:137], v[244:251] /*v[756:763]*/, v[196:203] /*v[708:715]*/, v[130:137]
	v_wmma_f32_16x16x32_bf16 v[122:129], v[236:243] /*v[748:755]*/, v[196:203] /*v[708:715]*/, v[122:129]
	v_wmma_f32_16x16x32_bf16 v[114:121], v[228:235] /*v[740:747]*/, v[196:203] /*v[708:715]*/, v[114:121]
	v_wmma_f32_16x16x32_bf16 v[98:105], v[220:227] /*v[732:739]*/, v[196:203] /*v[708:715]*/, v[98:105]
	v_wmma_f32_16x16x32_bf16 v[82:89], v[212:219] /*v[724:731]*/, v[196:203] /*v[708:715]*/, v[82:89]
	v_wmma_f32_16x16x32_bf16 v[74:81], v[204:211] /*v[716:723]*/, v[196:203] /*v[708:715]*/, v[74:81]
	s_add_co_i32 s37, s37, -1
	s_barrier_wait -1
	s_mul_hi_i32 s0, s37, 0x55555556
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_lshr_b32 s1, s0, 31
	s_add_co_i32 s0, s0, s1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s0, s0, 3
	s_sub_co_i32 s0, s37, s0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s0, s0, 0x12000
	s_add_co_i32 s0, s0, 0
	s_wait_alu depctr_vm_vsrc(6)
	s_set_vgpr_msb 0xa88
	v_dual_add_nc_u32 v38 /*v550*/, s0, v4 /*v516*/ :: v_dual_add_nc_u32 v2 /*v514*/, s0, v2 /*v514*/
	s_set_vgpr_msb 0x888c
	v_dual_add_nc_u32 v5 /*v517*/, s0, v9 /*v777*/ :: v_dual_add_nc_u32 v6 /*v518*/, s0, v11 /*v779*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8c0c
	v_add_nc_u32_e32 v0, s0, v12 /*v780*/
	s_set_vgpr_msb 0xc8c
	v_dual_add_nc_u32 v7 /*v519*/, s0, v8 /*v776*/ :: v_dual_add_nc_u32 v8 /*v520*/, s0, v10 /*v778*/
	s_set_vgpr_msb 0x8c8a
	v_add_nc_u32_e32 v3 /*v515*/, s0, v3 /*v515*/
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[156:159] /*v[668:671]*/, v38 /*v550*/ offset:11520
	ds_load_b128 v[160:163] /*v[672:675]*/, v38 /*v550*/ offset:11552
	ds_load_b128 v[164:167] /*v[676:679]*/, v38 /*v550*/ offset:13824
	ds_load_b128 v[168:171] /*v[680:683]*/, v38 /*v550*/ offset:13856
	ds_load_b128 v[172:175] /*v[684:687]*/, v2 /*v514*/
	ds_load_b128 v[176:179] /*v[688:691]*/, v3 /*v515*/
	s_set_vgpr_msb 0x8a8c
	ds_load_b128 v[180:183] /*v[692:695]*/, v0 offset:2368
	ds_load_b128 v[184:187] /*v[696:699]*/, v0 offset:2400
	ds_load_b128 v[188:191] /*v[700:703]*/, v0 offset:4672
	ds_load_b128 v[192:195] /*v[704:707]*/, v0 offset:4704
	ds_load_b128 v[196:199] /*v[708:711]*/, v0 offset:6976
	ds_load_b128 v[200:203] /*v[712:715]*/, v0 offset:7008
	ds_load_b128 v[204:207] /*v[716:719]*/, v0 offset:9280
	ds_load_b128 v[208:211] /*v[720:723]*/, v0 offset:9312
	ds_load_b128 v[212:215] /*v[724:727]*/, v0 offset:11584
	ds_load_b128 v[216:219] /*v[728:731]*/, v0 offset:11616
	s_wait_alu depctr_vm_vsrc(6)
	v_add_nc_u32_e32 v2 /*v514*/, s0, v6 /*v774*/
	s_set_vgpr_msb 0x8c8e
	ds_load_b128 v[100:103] /*v[612:615]*/, v5 /*v517*/
	ds_load_b128 v[104:107] /*v[616:619]*/, v6 /*v518*/
	ds_load_b128 v[108:111] /*v[620:623]*/, v7 /*v519*/
	ds_load_b128 v[112:115] /*v[624:627]*/, v8 /*v520*/
	ds_load_b128 v[116:119] /*v[628:631]*/, v38 /*v550*/
	ds_load_b128 v[120:123] /*v[632:635]*/, v38 /*v550*/ offset:32
	ds_load_b128 v[124:127] /*v[636:639]*/, v38 /*v550*/ offset:2304
	ds_load_b128 v[128:131] /*v[640:643]*/, v38 /*v550*/ offset:2336
	ds_load_b128 v[132:135] /*v[644:647]*/, v38 /*v550*/ offset:4608
	ds_load_b128 v[136:139] /*v[648:651]*/, v38 /*v550*/ offset:4640
	ds_load_b128 v[140:143] /*v[652:655]*/, v38 /*v550*/ offset:6912
	ds_load_b128 v[144:147] /*v[656:659]*/, v38 /*v550*/ offset:6944
	ds_load_b128 v[148:151] /*v[660:663]*/, v38 /*v550*/ offset:9216
	ds_load_b128 v[152:155] /*v[664:667]*/, v38 /*v550*/ offset:9248
	s_wait_alu depctr_vm_vsrc(6)
	v_dual_add_nc_u32 v6 /*v518*/, s0, v7 /*v775*/ :: v_dual_add_nc_u32 v10 /*v522*/, s0, v4 /*v772*/
	v_add_nc_u32_e32 v11 /*v523*/, s0, v5 /*v773*/
	s_set_vgpr_msb 0x8e80
	ds_load_b128 v[220:223] /*v[732:735]*/, v0 offset:13888
	ds_load_b128 v[224:227] /*v[736:739]*/, v0 offset:13920
	s_wait_alu depctr_va_vdst(2)
	s_set_vgpr_msb 0x8082
	ds_load_b128 v[2:5] /*v[514:517]*/, v2 /*v514*/
	s_wait_alu depctr_va_vdst(1)
	ds_load_b128 v[6:9] /*v[518:521]*/, v6 /*v518*/
	ds_load_b128 v[228:231] /*v[740:743]*/, v10 /*v522*/
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[232:235] /*v[744:747]*/, v11 /*v523*/
	ds_load_b128 v[26:29] /*v[538:541]*/, v38 /*v550*/ offset:64
	ds_load_b128 v[30:33] /*v[542:545]*/, v38 /*v550*/ offset:96
	ds_load_b128 v[236:239] /*v[748:751]*/, v38 /*v550*/ offset:2368
	ds_load_b128 v[240:243] /*v[752:755]*/, v38 /*v550*/ offset:2400
	s_wait_alu depctr_vm_vsrc(4)
	ds_load_b128 v[10:13] /*v[522:525]*/, v38 /*v550*/ offset:4672
	ds_load_b128 v[14:17] /*v[526:529]*/, v38 /*v550*/ offset:4704
	ds_load_b128 v[244:247] /*v[756:759]*/, v38 /*v550*/ offset:6976
	ds_load_b128 v[248:251] /*v[760:763]*/, v38 /*v550*/ offset:7008
	ds_load_b128 v[18:21] /*v[530:533]*/, v38 /*v550*/ offset:9280
	ds_load_b128 v[22:25] /*v[534:537]*/, v38 /*v550*/ offset:9312
	s_set_vgpr_msb 0x82c2
	ds_load_b128 v[4:7] /*v[772:775]*/, v38 /*v550*/ offset:11584
	ds_load_b128 v[8:11] /*v[776:779]*/, v38 /*v550*/ offset:11616
	s_set_vgpr_msb 0xc282
	ds_load_b128 v[34:37] /*v[546:549]*/, v38 /*v550*/ offset:13888
	s_wait_alu depctr_vm_vsrc(0)
	ds_load_b128 v[38:41] /*v[550:553]*/, v38 /*v550*/ offset:13920
	s_set_vgpr_msb 0x8280
	ds_load_b128 v[44:47] /*v[556:559]*/, v0
	ds_load_b128 v[48:51] /*v[560:563]*/, v0 offset:32
	ds_load_b128 v[52:55] /*v[564:567]*/, v0 offset:2304
	ds_load_b128 v[56:59] /*v[568:571]*/, v0 offset:2336
	ds_load_b128 v[60:63] /*v[572:575]*/, v0 offset:4608
	ds_load_b128 v[64:67] /*v[576:579]*/, v0 offset:4640
	ds_load_b128 v[68:71] /*v[580:583]*/, v0 offset:6912
	ds_load_b128 v[72:75] /*v[584:587]*/, v0 offset:6944
	ds_load_b128 v[76:79] /*v[588:591]*/, v0 offset:9216
	ds_load_b128 v[80:83] /*v[592:595]*/, v0 offset:9248
	ds_load_b128 v[84:87] /*v[596:599]*/, v0 offset:11520
	ds_load_b128 v[88:91] /*v[600:603]*/, v0 offset:11552
	ds_load_b128 v[92:95] /*v[604:607]*/, v0 offset:13824
	ds_load_b128 v[96:99] /*v[608:611]*/, v0 offset:13856
	s_set_vgpr_msb 0x800a
	s_wait_dscnt 0xc
	v_wmma_f32_16x16x32_bf16 v[2:9], v[108:115] /*v[620:627]*/, v[44:51] /*v[556:563]*/, v[2:9]
	s_wait_dscnt 0x20
	v_wmma_f32_16x16x32_bf16 v[10:17], v[116:123] /*v[628:635]*/, v[44:51] /*v[556:563]*/, v[10:17]
	v_wmma_f32_16x16x32_bf16 v[18:25], v[124:131] /*v[636:643]*/, v[44:51] /*v[556:563]*/, v[18:25]
	v_wmma_f32_16x16x32_bf16 v[34:41], v[132:139] /*v[644:651]*/, v[44:51] /*v[556:563]*/, v[34:41]
	v_wmma_f32_16x16x32_bf16 v[42:49], v[140:147] /*v[652:659]*/, v[44:51] /*v[556:563]*/, v[42:49]
	v_wmma_f32_16x16x32_bf16 v[50:57], v[148:155] /*v[660:667]*/, v[44:51] /*v[556:563]*/, v[50:57]
	v_wmma_f32_16x16x32_bf16 v[66:73], v[156:163] /*v[668:675]*/, v[44:51] /*v[556:563]*/, v[66:73]
	v_wmma_f32_16x16x32_bf16 v[90:97], v[164:171] /*v[676:683]*/, v[44:51] /*v[556:563]*/, v[90:97]
	s_wait_dscnt 0xa
	v_wmma_f32_16x16x32_bf16 v[226:233], v[164:171] /*v[676:683]*/, v[52:59] /*v[564:571]*/, v[226:233]
	v_wmma_f32_16x16x32_bf16 v[194:201], v[156:163] /*v[668:675]*/, v[52:59] /*v[564:571]*/, v[194:201]
	v_wmma_f32_16x16x32_bf16 v[170:177], v[148:155] /*v[660:667]*/, v[52:59] /*v[564:571]*/, v[170:177]
	v_wmma_f32_16x16x32_bf16 v[162:169], v[140:147] /*v[652:659]*/, v[52:59] /*v[564:571]*/, v[162:169]
	v_wmma_f32_16x16x32_bf16 v[146:153], v[132:139] /*v[644:651]*/, v[52:59] /*v[564:571]*/, v[146:153]
	v_wmma_f32_16x16x32_bf16 v[106:113], v[124:131] /*v[636:643]*/, v[52:59] /*v[564:571]*/, v[106:113]
	v_wmma_f32_16x16x32_bf16 v[58:65], v[116:123] /*v[628:635]*/, v[52:59] /*v[564:571]*/, v[58:65]
	v_wmma_f32_16x16x32_bf16 v[26:33], v[108:115] /*v[620:627]*/, v[52:59] /*v[564:571]*/, v[26:33]
	s_wait_dscnt 0x8
	v_wmma_f32_16x16x32_bf16 v[178:185], v[108:115] /*v[620:627]*/, v[60:67] /*v[572:579]*/, v[178:185]
	v_wmma_f32_16x16x32_bf16 v[186:193], v[116:123] /*v[628:635]*/, v[60:67] /*v[572:579]*/, v[186:193]
	v_wmma_f32_16x16x32_bf16 v[202:209], v[124:131] /*v[636:643]*/, v[60:67] /*v[572:579]*/, v[202:209]
	v_wmma_f32_16x16x32_bf16 v[210:217], v[132:139] /*v[644:651]*/, v[60:67] /*v[572:579]*/, v[210:217]
	v_wmma_f32_16x16x32_bf16 v[218:225], v[140:147] /*v[652:659]*/, v[60:67] /*v[572:579]*/, v[218:225]
	v_wmma_f32_16x16x32_bf16 v[234:241], v[148:155] /*v[660:667]*/, v[60:67] /*v[572:579]*/, v[234:241]
	v_wmma_f32_16x16x32_bf16 v[242:249], v[156:163] /*v[668:675]*/, v[60:67] /*v[572:579]*/, v[242:249]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[58:65] /*v[314:321]*/, v[164:171] /*v[676:683]*/, v[60:67] /*v[572:579]*/, v[58:65] /*v[314:321]*/
	s_wait_dscnt 0x6
	v_wmma_f32_16x16x32_bf16 v[50:57] /*v[306:313]*/, v[164:171] /*v[676:683]*/, v[68:75] /*v[580:587]*/, v[50:57] /*v[306:313]*/
	v_wmma_f32_16x16x32_bf16 v[42:49] /*v[298:305]*/, v[156:163] /*v[668:675]*/, v[68:75] /*v[580:587]*/, v[42:49] /*v[298:305]*/
	v_wmma_f32_16x16x32_bf16 v[34:41] /*v[290:297]*/, v[148:155] /*v[660:667]*/, v[68:75] /*v[580:587]*/, v[34:41] /*v[290:297]*/
	v_wmma_f32_16x16x32_bf16 v[26:33] /*v[282:289]*/, v[140:147] /*v[652:659]*/, v[68:75] /*v[580:587]*/, v[26:33] /*v[282:289]*/
	v_wmma_f32_16x16x32_bf16 v[18:25] /*v[274:281]*/, v[132:139] /*v[644:651]*/, v[68:75] /*v[580:587]*/, v[18:25] /*v[274:281]*/
	v_wmma_f32_16x16x32_bf16 v[10:17] /*v[266:273]*/, v[124:131] /*v[636:643]*/, v[68:75] /*v[580:587]*/, v[10:17] /*v[266:273]*/
	v_wmma_f32_16x16x32_bf16 v[2:9] /*v[258:265]*/, v[116:123] /*v[628:635]*/, v[68:75] /*v[580:587]*/, v[2:9] /*v[258:265]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[250:257], v[108:115] /*v[620:627]*/, v[68:75] /*v[580:587]*/, v[250:257]
	s_set_vgpr_msb 0xa5a
	s_wait_dscnt 0x4
	v_wmma_f32_16x16x32_bf16 v[66:73] /*v[322:329]*/, v[108:115] /*v[620:627]*/, v[76:83] /*v[588:595]*/, v[66:73] /*v[322:329]*/
	v_wmma_f32_16x16x32_bf16 v[74:81] /*v[330:337]*/, v[116:123] /*v[628:635]*/, v[76:83] /*v[588:595]*/, v[74:81] /*v[330:337]*/
	v_wmma_f32_16x16x32_bf16 v[82:89] /*v[338:345]*/, v[124:131] /*v[636:643]*/, v[76:83] /*v[588:595]*/, v[82:89] /*v[338:345]*/
	v_wmma_f32_16x16x32_bf16 v[98:105] /*v[354:361]*/, v[132:139] /*v[644:651]*/, v[76:83] /*v[588:595]*/, v[98:105] /*v[354:361]*/
	v_wmma_f32_16x16x32_bf16 v[106:113] /*v[362:369]*/, v[140:147] /*v[652:659]*/, v[76:83] /*v[588:595]*/, v[106:113] /*v[362:369]*/
	v_wmma_f32_16x16x32_bf16 v[114:121] /*v[370:377]*/, v[148:155] /*v[660:667]*/, v[76:83] /*v[588:595]*/, v[114:121] /*v[370:377]*/
	v_wmma_f32_16x16x32_bf16 v[130:137] /*v[386:393]*/, v[156:163] /*v[668:675]*/, v[76:83] /*v[588:595]*/, v[130:137] /*v[386:393]*/
	v_wmma_f32_16x16x32_bf16 v[138:145] /*v[394:401]*/, v[164:171] /*v[676:683]*/, v[76:83] /*v[588:595]*/, v[138:145] /*v[394:401]*/
	s_wait_dscnt 0x2
	v_wmma_f32_16x16x32_bf16 v[226:233] /*v[482:489]*/, v[164:171] /*v[676:683]*/, v[84:91] /*v[596:603]*/, v[226:233] /*v[482:489]*/
	v_wmma_f32_16x16x32_bf16 v[194:201] /*v[450:457]*/, v[156:163] /*v[668:675]*/, v[84:91] /*v[596:603]*/, v[194:201] /*v[450:457]*/
	v_wmma_f32_16x16x32_bf16 v[170:177] /*v[426:433]*/, v[148:155] /*v[660:667]*/, v[84:91] /*v[596:603]*/, v[170:177] /*v[426:433]*/
	v_wmma_f32_16x16x32_bf16 v[162:169] /*v[418:425]*/, v[140:147] /*v[652:659]*/, v[84:91] /*v[596:603]*/, v[162:169] /*v[418:425]*/
	v_wmma_f32_16x16x32_bf16 v[154:161] /*v[410:417]*/, v[132:139] /*v[644:651]*/, v[84:91] /*v[596:603]*/, v[154:161] /*v[410:417]*/
	v_wmma_f32_16x16x32_bf16 v[146:153] /*v[402:409]*/, v[124:131] /*v[636:643]*/, v[84:91] /*v[596:603]*/, v[146:153] /*v[402:409]*/
	v_wmma_f32_16x16x32_bf16 v[122:129] /*v[378:385]*/, v[116:123] /*v[628:635]*/, v[84:91] /*v[596:603]*/, v[122:129] /*v[378:385]*/
	v_wmma_f32_16x16x32_bf16 v[90:97] /*v[346:353]*/, v[108:115] /*v[620:627]*/, v[84:91] /*v[596:603]*/, v[90:97] /*v[346:353]*/
	s_wait_dscnt 0x0
	v_wmma_f32_16x16x32_bf16 v[178:185] /*v[434:441]*/, v[108:115] /*v[620:627]*/, v[92:99] /*v[604:611]*/, v[178:185] /*v[434:441]*/
	v_wmma_f32_16x16x32_bf16 v[186:193] /*v[442:449]*/, v[116:123] /*v[628:635]*/, v[92:99] /*v[604:611]*/, v[186:193] /*v[442:449]*/
	v_wmma_f32_16x16x32_bf16 v[202:209] /*v[458:465]*/, v[124:131] /*v[636:643]*/, v[92:99] /*v[604:611]*/, v[202:209] /*v[458:465]*/
	v_wmma_f32_16x16x32_bf16 v[210:217] /*v[466:473]*/, v[132:139] /*v[644:651]*/, v[92:99] /*v[604:611]*/, v[210:217] /*v[466:473]*/
	v_wmma_f32_16x16x32_bf16 v[218:225] /*v[474:481]*/, v[140:147] /*v[652:659]*/, v[92:99] /*v[604:611]*/, v[218:225] /*v[474:481]*/
	v_wmma_f32_16x16x32_bf16 v[234:241] /*v[490:497]*/, v[148:155] /*v[660:667]*/, v[92:99] /*v[604:611]*/, v[234:241] /*v[490:497]*/
	v_wmma_f32_16x16x32_bf16 v[242:249] /*v[498:505]*/, v[156:163] /*v[668:675]*/, v[92:99] /*v[604:611]*/, v[242:249] /*v[498:505]*/
	v_wmma_f32_16x16x32_bf16 v[250:257] /*v[506:513]*/, v[164:171] /*v[676:683]*/, v[92:99] /*v[604:611]*/, v[250:257] /*v[506:513]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[154:161], v[164:171] /*v[676:683]*/, v[100:107] /*v[612:619]*/, v[154:161]
	v_wmma_f32_16x16x32_bf16 v[138:145], v[156:163] /*v[668:675]*/, v[100:107] /*v[612:619]*/, v[138:145]
	v_wmma_f32_16x16x32_bf16 v[130:137], v[148:155] /*v[660:667]*/, v[100:107] /*v[612:619]*/, v[130:137]
	v_wmma_f32_16x16x32_bf16 v[122:129], v[140:147] /*v[652:659]*/, v[100:107] /*v[612:619]*/, v[122:129]
	v_wmma_f32_16x16x32_bf16 v[114:121], v[132:139] /*v[644:651]*/, v[100:107] /*v[612:619]*/, v[114:121]
	v_wmma_f32_16x16x32_bf16 v[98:105], v[124:131] /*v[636:643]*/, v[100:107] /*v[612:619]*/, v[98:105]
	v_wmma_f32_16x16x32_bf16 v[82:89], v[116:123] /*v[628:635]*/, v[100:107] /*v[612:619]*/, v[82:89]
	v_wmma_f32_16x16x32_bf16 v[74:81], v[108:115] /*v[620:627]*/, v[100:107] /*v[612:619]*/, v[74:81]
	s_wait_dscnt 0x0
	v_wmma_f32_16x16x32_bf16 v[2:9], v[228:235] /*v[740:747]*/, v[172:179] /*v[684:691]*/, v[2:9]
	s_lshl_b32 s0, s36, 1
	s_wait_tensorcnt 0x0
	s_barrier_signal -1
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa03
	v_lshl_or_b32 v0, v3 /*v771*/, 4, s0
	s_mul_u64 s[0:1], s[30:31], s[28:29]
	s_lshl_b64 s[2:3], s[2:3], 1
	s_set_vgpr_msb 0x30a
	v_wmma_f32_16x16x32_bf16 v[10:17], v[26:33] /*v[538:545]*/, v[172:179] /*v[684:691]*/, v[10:17]
	v_nop
	v_nop
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v9, v8, v9
	v_cvt_pk_bf16_f32 v8, v6, v7
	v_cvt_pk_bf16_f32 v6, v2, v3
	s_set_vgpr_msb 3
	v_lshl_or_b32 v2, v2 /*v770*/, 9, v0
	s_set_vgpr_msb 0x300
	v_cvt_pk_bf16_f32 v7, v4, v5
	s_set_vgpr_msb 10
	v_lshl_or_b32 v0, v43 /*v555*/, 9, v0
	s_lshl_b64 s[0:1], s[0:1], 1
	v_wmma_f32_16x16x32_bf16 v[18:25], v[236:243] /*v[748:755]*/, v[172:179] /*v[684:691]*/, v[18:25]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v5, v16, v17
	v_dual_add_nc_u32 v16, 0, v2 :: v_dual_add_nc_u32 v0, 0, v0
	v_cvt_pk_bf16_f32 v4, v14, v15
	v_cvt_pk_bf16_f32 v3, v12, v13
	v_cvt_pk_bf16_f32 v2, v10, v11
	s_set_vgpr_msb 10
	s_barrier_wait -1
	v_wmma_f32_16x16x32_bf16 v[34:41], v[10:17] /*v[522:529]*/, v[172:179] /*v[684:691]*/, v[34:41]
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0xa00
	ds_store_b128 v16, v[6:9]
	ds_store_b128 v16, v[2:5] offset:32
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v7, v24, v25
	v_cvt_pk_bf16_f32 v6, v22, v23
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v5, v20, v21
	v_cvt_pk_bf16_f32 v4, v18, v19
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[42:49], v[244:251] /*v[756:763]*/, v[172:179] /*v[684:691]*/, v[42:49]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v11, v40, v41
	v_cvt_pk_bf16_f32 v10, v38, v39
	v_cvt_pk_bf16_f32 v9, v36, v37
	v_cvt_pk_bf16_f32 v8, v34, v35
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v16, v[4:7] offset:64
	ds_store_b128 v16, v[8:11] offset:96
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[50:57], v[18:25] /*v[530:537]*/, v[172:179] /*v[684:691]*/, v[50:57]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v5, v48, v49
	v_cvt_pk_bf16_f32 v4, v46, v47
	v_cvt_pk_bf16_f32 v3, v44, v45
	v_cvt_pk_bf16_f32 v2, v42, v43
	s_cmp_lg_u32 s28, 0x80000000
	s_add_nc_u64 s[0:1], s[4:5], s[0:1]
	s_cselect_b32 s13, s29, 0
	s_set_vgpr_msb 11
	v_wmma_f32_16x16x32_bf16 v[66:73], v[4:11] /*v[772:779]*/, v[172:179] /*v[684:691]*/, v[66:73]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xb00
	v_cvt_pk_bf16_f32 v9, v56, v57
	v_cvt_pk_bf16_f32 v8, v54, v55
	v_cvt_pk_bf16_f32 v7, v52, v53
	v_cvt_pk_bf16_f32 v6, v50, v51
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v16, v[2:5] offset:128
	ds_store_b128 v16, v[6:9] offset:160
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[90:97], v[34:41] /*v[546:553]*/, v[172:179] /*v[684:691]*/, v[90:97]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v5, v72, v73
	v_cvt_pk_bf16_f32 v4, v70, v71
	v_cvt_pk_bf16_f32 v3, v68, v69
	v_cvt_pk_bf16_f32 v2, v66, v67
	s_cselect_b32 s12, s28, 0x100
	s_bfe_u32 s6, ttmp8, 0x50019
	s_add_nc_u64 s[0:1], s[0:1], s[2:3]
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[226:233], v[34:41] /*v[546:553]*/, v[180:187] /*v[692:699]*/, v[226:233]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v9, v96, v97
	v_cvt_pk_bf16_f32 v8, v94, v95
	v_cvt_pk_bf16_f32 v7, v92, v93
	v_cvt_pk_bf16_f32 v6, v90, v91
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v16, v[2:5] offset:192
	ds_store_b128 v16, v[6:9] offset:224
	s_set_vgpr_msb 11
	v_wmma_f32_16x16x32_bf16 v[194:201], v[4:11] /*v[772:779]*/, v[180:187] /*v[692:699]*/, v[194:201]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xb00
	v_cvt_pk_bf16_f32 v5, v232, v233
	v_cvt_pk_bf16_f32 v4, v230, v231
	v_cvt_pk_bf16_f32 v3, v228, v229
	v_cvt_pk_bf16_f32 v2, v226, v227
	s_and_b32 s9, s6, 3
	s_mov_b32 s8, 1
	s_lshl_b32 s4, s9, 6
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[170:177], v[18:25] /*v[530:537]*/, v[180:187] /*v[692:699]*/, v[170:177]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v9, v200, v201
	v_cvt_pk_bf16_f32 v8, v198, v199
	v_cvt_pk_bf16_f32 v7, v196, v197
	v_cvt_pk_bf16_f32 v6, v194, v195
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v16, v[2:5] offset:8416
	ds_store_b128 v16, v[6:9] offset:8384
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[162:169], v[244:251] /*v[756:763]*/, v[180:187] /*v[692:699]*/, v[162:169]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v5, v176, v177
	v_cvt_pk_bf16_f32 v4, v174, v175
	v_cvt_pk_bf16_f32 v3, v172, v173
	v_cvt_pk_bf16_f32 v2, v170, v171
	s_sub_co_i32 s2, s33, s4
	s_lshl_b32 s6, s9, 7
	s_max_i32 s4, s2, 0
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[146:153], v[10:17] /*v[522:529]*/, v[180:187] /*v[692:699]*/, v[146:153]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v9, v168, v169
	v_cvt_pk_bf16_f32 v8, v166, v167
	v_cvt_pk_bf16_f32 v7, v164, v165
	v_cvt_pk_bf16_f32 v6, v162, v163
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v16, v[2:5] offset:8352
	ds_store_b128 v16, v[6:9] offset:8320
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[106:113], v[236:243] /*v[748:755]*/, v[180:187] /*v[692:699]*/, v[106:113]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v5, v152, v153
	v_cvt_pk_bf16_f32 v4, v150, v151
	v_cvt_pk_bf16_f32 v3, v148, v149
	v_cvt_pk_bf16_f32 v2, v146, v147
	s_mul_u64 s[2:3], s[12:13], s[6:7]
	s_set_vgpr_msb 0x80
	v_mov_b32_e32 v43 /*v555*/, s4
	s_add_nc_u64 s[10:11], s[2:3], s[0:1]
	s_set_vgpr_msb 0x800a
	v_wmma_f32_16x16x32_bf16 v[58:65], v[26:33] /*v[538:545]*/, v[180:187] /*v[692:699]*/, v[58:65]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v9, v112, v113
	v_cvt_pk_bf16_f32 v8, v110, v111
	v_cvt_pk_bf16_f32 v7, v108, v109
	v_cvt_pk_bf16_f32 v6, v106, v107
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v16, v[2:5] offset:8288
	ds_store_b128 v16, v[6:9] offset:8256
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[26:33], v[228:235] /*v[740:747]*/, v[180:187] /*v[692:699]*/, v[26:33]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v5, v64, v65
	v_cvt_pk_bf16_f32 v4, v62, v63
	v_cvt_pk_bf16_f32 v3, v60, v61
	v_cvt_pk_bf16_f32 v2, v58, v59
	s_lshr_b32 s0, s4, 16
	s_and_b32 s1, s13, 0xffff
	s_bitset1_b32 s0, 24
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[178:185], v[228:235] /*v[740:747]*/, v[188:195] /*v[700:707]*/, v[178:185]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v9, v32, v33
	v_cvt_pk_bf16_f32 v8, v30, v31
	v_cvt_pk_bf16_f32 v7, v28, v29
	v_cvt_pk_bf16_f32 v6, v26, v27
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v16, v[2:5] offset:8224
	ds_store_b128 v16, v[6:9] offset:8192
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[186:193], v[26:33] /*v[538:545]*/, v[188:195] /*v[700:707]*/, v[186:193]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v5, v184, v185
	v_cvt_pk_bf16_f32 v4, v182, v183
	v_cvt_pk_bf16_f32 v3, v180, v181
	v_cvt_pk_bf16_f32 v2, v178, v179
	s_lshl_b32 s5, s9, 15
	s_bitset1_b32 s11, 31
	s_add_co_i32 s9, s5, 0
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[202:209], v[236:243] /*v[748:755]*/, v[188:195] /*v[700:707]*/, v[202:209]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v9, v192, v193
	v_cvt_pk_bf16_f32 v8, v190, v191
	v_cvt_pk_bf16_f32 v7, v188, v189
	v_cvt_pk_bf16_f32 v6, v186, v187
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v16, v[2:5] offset:16384
	ds_store_b128 v16, v[6:9] offset:16416
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[210:217], v[10:17] /*v[522:529]*/, v[188:195] /*v[700:707]*/, v[210:217]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v5, v208, v209
	v_cvt_pk_bf16_f32 v4, v206, v207
	v_cvt_pk_bf16_f32 v3, v204, v205
	v_cvt_pk_bf16_f32 v2, v202, v203
	s_mov_b32 s4, 64
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v216, v217
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[218:225], v[244:251] /*v[756:763]*/, v[188:195] /*v[700:707]*/, v[218:225]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v8, v214, v215
	v_cvt_pk_bf16_f32 v7, v212, v213
	v_cvt_pk_bf16_f32 v6, v210, v211
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v16, v[2:5] offset:16448
	ds_store_b128 v16, v[6:9] offset:16480
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[234:241], v[18:25] /*v[530:537]*/, v[188:195] /*v[700:707]*/, v[234:241]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v5, v224, v225
	v_cvt_pk_bf16_f32 v4, v222, v223
	v_cvt_pk_bf16_f32 v3, v220, v221
	v_cvt_pk_bf16_f32 v2, v218, v219
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v240, v241
	s_set_vgpr_msb 11
	v_wmma_f32_16x16x32_bf16 v[242:249], v[4:11] /*v[772:779]*/, v[188:195] /*v[700:707]*/, v[242:249]
	s_set_vgpr_msb 0xb00
	v_cvt_pk_bf16_f32 v8, v238, v239
	v_cvt_pk_bf16_f32 v7, v236, v237
	v_cvt_pk_bf16_f32 v6, v234, v235
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v16, v[2:5] offset:16512
	ds_store_b128 v16, v[6:9] offset:16544
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[58:65] /*v[314:321]*/, v[34:41] /*v[546:553]*/, v[188:195] /*v[700:707]*/, v[58:65] /*v[314:321]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a00
	v_cvt_pk_bf16_f32 v5, v248, v249
	v_cvt_pk_bf16_f32 v4, v246, v247
	v_cvt_pk_bf16_f32 v3, v244, v245
	v_cvt_pk_bf16_f32 v2, v242, v243
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v9, v64 /*v320*/, v65 /*v321*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[50:57] /*v[306:313]*/, v[34:41] /*v[546:553]*/, v[196:203] /*v[708:715]*/, v[50:57] /*v[306:313]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v8, v62 /*v318*/, v63 /*v319*/
	v_cvt_pk_bf16_f32 v7, v60 /*v316*/, v61 /*v317*/
	v_cvt_pk_bf16_f32 v6, v58 /*v314*/, v59 /*v315*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:16576
	ds_store_b128 v16, v[6:9] offset:16608
	s_set_vgpr_msb 0x5b
	v_wmma_f32_16x16x32_bf16 v[42:49] /*v[298:305]*/, v[4:11] /*v[772:779]*/, v[196:203] /*v[708:715]*/, v[42:49] /*v[298:305]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5b05
	v_cvt_pk_bf16_f32 v5, v56 /*v312*/, v57 /*v313*/
	v_cvt_pk_bf16_f32 v4, v54 /*v310*/, v55 /*v311*/
	v_cvt_pk_bf16_f32 v3, v52 /*v308*/, v53 /*v309*/
	v_cvt_pk_bf16_f32 v2, v50 /*v306*/, v51 /*v307*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v48 /*v304*/, v49 /*v305*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[34:41] /*v[290:297]*/, v[18:25] /*v[530:537]*/, v[196:203] /*v[708:715]*/, v[34:41] /*v[290:297]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v8, v46 /*v302*/, v47 /*v303*/
	v_cvt_pk_bf16_f32 v7, v44 /*v300*/, v45 /*v301*/
	v_cvt_pk_bf16_f32 v6, v42 /*v298*/, v43 /*v299*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:24800
	ds_store_b128 v16, v[6:9] offset:24768
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[26:33] /*v[282:289]*/, v[244:251] /*v[756:763]*/, v[196:203] /*v[708:715]*/, v[26:33] /*v[282:289]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v5, v40 /*v296*/, v41 /*v297*/
	v_cvt_pk_bf16_f32 v4, v38 /*v294*/, v39 /*v295*/
	v_cvt_pk_bf16_f32 v3, v36 /*v292*/, v37 /*v293*/
	v_cvt_pk_bf16_f32 v2, v34 /*v290*/, v35 /*v291*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v32 /*v288*/, v33 /*v289*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[18:25] /*v[274:281]*/, v[10:17] /*v[522:529]*/, v[196:203] /*v[708:715]*/, v[18:25] /*v[274:281]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v8, v30 /*v286*/, v31 /*v287*/
	v_cvt_pk_bf16_f32 v7, v28 /*v284*/, v29 /*v285*/
	v_cvt_pk_bf16_f32 v6, v26 /*v282*/, v27 /*v283*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:24736
	ds_store_b128 v16, v[6:9] offset:24704
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[10:17] /*v[266:273]*/, v[236:243] /*v[748:755]*/, v[196:203] /*v[708:715]*/, v[10:17] /*v[266:273]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v5, v24 /*v280*/, v25 /*v281*/
	v_cvt_pk_bf16_f32 v4, v22 /*v278*/, v23 /*v279*/
	v_cvt_pk_bf16_f32 v3, v20 /*v276*/, v21 /*v277*/
	v_cvt_pk_bf16_f32 v2, v18 /*v274*/, v19 /*v275*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v16 /*v272*/, v17 /*v273*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[2:9] /*v[258:265]*/, v[26:33] /*v[538:545]*/, v[196:203] /*v[708:715]*/, v[2:9] /*v[258:265]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v8, v14 /*v270*/, v15 /*v271*/
	v_cvt_pk_bf16_f32 v7, v12 /*v268*/, v13 /*v269*/
	v_cvt_pk_bf16_f32 v6, v10 /*v266*/, v11 /*v267*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:24672
	ds_store_b128 v16, v[6:9] offset:24640
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[250:257], v[228:235] /*v[740:747]*/, v[196:203] /*v[708:715]*/, v[250:257]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa05
	v_cvt_pk_bf16_f32 v5, v8 /*v264*/, v9 /*v265*/
	v_cvt_pk_bf16_f32 v4, v6 /*v262*/, v7 /*v263*/
	v_cvt_pk_bf16_f32 v3, v4 /*v260*/, v5 /*v261*/
	v_cvt_pk_bf16_f32 v2, v2 /*v258*/, v3 /*v259*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v0 /*v256*/, v1 /*v257*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[66:73] /*v[322:329]*/, v[228:235] /*v[740:747]*/, v[204:211] /*v[716:723]*/, v[66:73] /*v[322:329]*/
	s_set_vgpr_msb 0x5a00
	v_cvt_pk_bf16_f32 v8, v254, v255
	v_cvt_pk_bf16_f32 v7, v252, v253
	v_cvt_pk_bf16_f32 v6, v250, v251
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v16, v[2:5] offset:24608
	ds_store_b128 v16, v[6:9] offset:24576
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[74:81] /*v[330:337]*/, v[26:33] /*v[538:545]*/, v[204:211] /*v[716:723]*/, v[74:81] /*v[330:337]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v5, v72 /*v328*/, v73 /*v329*/
	v_cvt_pk_bf16_f32 v4, v70 /*v326*/, v71 /*v327*/
	v_cvt_pk_bf16_f32 v3, v68 /*v324*/, v69 /*v325*/
	v_cvt_pk_bf16_f32 v2, v66 /*v322*/, v67 /*v323*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v80 /*v336*/, v81 /*v337*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[82:89] /*v[338:345]*/, v[236:243] /*v[748:755]*/, v[204:211] /*v[716:723]*/, v[82:89] /*v[338:345]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v8, v78 /*v334*/, v79 /*v335*/
	v_cvt_pk_bf16_f32 v7, v76 /*v332*/, v77 /*v333*/
	v_cvt_pk_bf16_f32 v6, v74 /*v330*/, v75 /*v331*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:32768
	ds_store_b128 v16, v[6:9] offset:32800
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[98:105] /*v[354:361]*/, v[10:17] /*v[522:529]*/, v[204:211] /*v[716:723]*/, v[98:105] /*v[354:361]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v5, v88 /*v344*/, v89 /*v345*/
	v_cvt_pk_bf16_f32 v4, v86 /*v342*/, v87 /*v343*/
	v_cvt_pk_bf16_f32 v3, v84 /*v340*/, v85 /*v341*/
	v_cvt_pk_bf16_f32 v2, v82 /*v338*/, v83 /*v339*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v104 /*v360*/, v105 /*v361*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[106:113] /*v[362:369]*/, v[244:251] /*v[756:763]*/, v[204:211] /*v[716:723]*/, v[106:113] /*v[362:369]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v8, v102 /*v358*/, v103 /*v359*/
	v_cvt_pk_bf16_f32 v7, v100 /*v356*/, v101 /*v357*/
	v_cvt_pk_bf16_f32 v6, v98 /*v354*/, v99 /*v355*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:32832
	ds_store_b128 v16, v[6:9] offset:32864
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[114:121] /*v[370:377]*/, v[18:25] /*v[530:537]*/, v[204:211] /*v[716:723]*/, v[114:121] /*v[370:377]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v5, v112 /*v368*/, v113 /*v369*/
	v_cvt_pk_bf16_f32 v4, v110 /*v366*/, v111 /*v367*/
	v_cvt_pk_bf16_f32 v3, v108 /*v364*/, v109 /*v365*/
	v_cvt_pk_bf16_f32 v2, v106 /*v362*/, v107 /*v363*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v120 /*v376*/, v121 /*v377*/
	s_set_vgpr_msb 0x55b
	v_wmma_f32_16x16x32_bf16 v[130:137] /*v[386:393]*/, v[4:11] /*v[772:779]*/, v[204:211] /*v[716:723]*/, v[130:137] /*v[386:393]*/
	s_set_vgpr_msb 0x5b05
	v_cvt_pk_bf16_f32 v8, v118 /*v374*/, v119 /*v375*/
	v_cvt_pk_bf16_f32 v7, v116 /*v372*/, v117 /*v373*/
	v_cvt_pk_bf16_f32 v6, v114 /*v370*/, v115 /*v371*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:32896
	ds_store_b128 v16, v[6:9] offset:32928
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[138:145] /*v[394:401]*/, v[34:41] /*v[546:553]*/, v[204:211] /*v[716:723]*/, v[138:145] /*v[394:401]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v5, v136 /*v392*/, v137 /*v393*/
	v_cvt_pk_bf16_f32 v4, v134 /*v390*/, v135 /*v391*/
	v_cvt_pk_bf16_f32 v3, v132 /*v388*/, v133 /*v389*/
	v_cvt_pk_bf16_f32 v2, v130 /*v386*/, v131 /*v387*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v144 /*v400*/, v145 /*v401*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[226:233] /*v[482:489]*/, v[34:41] /*v[546:553]*/, v[212:219] /*v[724:731]*/, v[226:233] /*v[482:489]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v8, v142 /*v398*/, v143 /*v399*/
	v_cvt_pk_bf16_f32 v7, v140 /*v396*/, v141 /*v397*/
	v_cvt_pk_bf16_f32 v6, v138 /*v394*/, v139 /*v395*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:32960
	ds_store_b128 v16, v[6:9] offset:32992
	s_set_vgpr_msb 0x5b
	v_wmma_f32_16x16x32_bf16 v[194:201] /*v[450:457]*/, v[4:11] /*v[772:779]*/, v[212:219] /*v[724:731]*/, v[194:201] /*v[450:457]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5b05
	v_cvt_pk_bf16_f32 v5, v232 /*v488*/, v233 /*v489*/
	v_cvt_pk_bf16_f32 v4, v230 /*v486*/, v231 /*v487*/
	v_cvt_pk_bf16_f32 v3, v228 /*v484*/, v229 /*v485*/
	v_cvt_pk_bf16_f32 v2, v226 /*v482*/, v227 /*v483*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v200 /*v456*/, v201 /*v457*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[170:177] /*v[426:433]*/, v[18:25] /*v[530:537]*/, v[212:219] /*v[724:731]*/, v[170:177] /*v[426:433]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v8, v198 /*v454*/, v199 /*v455*/
	v_cvt_pk_bf16_f32 v7, v196 /*v452*/, v197 /*v453*/
	v_cvt_pk_bf16_f32 v6, v194 /*v450*/, v195 /*v451*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:41184
	ds_store_b128 v16, v[6:9] offset:41152
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[162:169] /*v[418:425]*/, v[244:251] /*v[756:763]*/, v[212:219] /*v[724:731]*/, v[162:169] /*v[418:425]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v5, v176 /*v432*/, v177 /*v433*/
	v_cvt_pk_bf16_f32 v4, v174 /*v430*/, v175 /*v431*/
	v_cvt_pk_bf16_f32 v3, v172 /*v428*/, v173 /*v429*/
	v_cvt_pk_bf16_f32 v2, v170 /*v426*/, v171 /*v427*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v168 /*v424*/, v169 /*v425*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[154:161] /*v[410:417]*/, v[10:17] /*v[522:529]*/, v[212:219] /*v[724:731]*/, v[154:161] /*v[410:417]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v8, v166 /*v422*/, v167 /*v423*/
	v_cvt_pk_bf16_f32 v7, v164 /*v420*/, v165 /*v421*/
	v_cvt_pk_bf16_f32 v6, v162 /*v418*/, v163 /*v419*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:41120
	ds_store_b128 v16, v[6:9] offset:41088
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[146:153] /*v[402:409]*/, v[236:243] /*v[748:755]*/, v[212:219] /*v[724:731]*/, v[146:153] /*v[402:409]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v5, v160 /*v416*/, v161 /*v417*/
	v_cvt_pk_bf16_f32 v4, v158 /*v414*/, v159 /*v415*/
	v_cvt_pk_bf16_f32 v3, v156 /*v412*/, v157 /*v413*/
	v_cvt_pk_bf16_f32 v2, v154 /*v410*/, v155 /*v411*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v152 /*v408*/, v153 /*v409*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[122:129] /*v[378:385]*/, v[26:33] /*v[538:545]*/, v[212:219] /*v[724:731]*/, v[122:129] /*v[378:385]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v8, v150 /*v406*/, v151 /*v407*/
	v_cvt_pk_bf16_f32 v7, v148 /*v404*/, v149 /*v405*/
	v_cvt_pk_bf16_f32 v6, v146 /*v402*/, v147 /*v403*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:41056
	ds_store_b128 v16, v[6:9] offset:41024
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[90:97] /*v[346:353]*/, v[228:235] /*v[740:747]*/, v[212:219] /*v[724:731]*/, v[90:97] /*v[346:353]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v5, v128 /*v384*/, v129 /*v385*/
	v_cvt_pk_bf16_f32 v4, v126 /*v382*/, v127 /*v383*/
	v_cvt_pk_bf16_f32 v3, v124 /*v380*/, v125 /*v381*/
	v_cvt_pk_bf16_f32 v2, v122 /*v378*/, v123 /*v379*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v96 /*v352*/, v97 /*v353*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[178:185] /*v[434:441]*/, v[228:235] /*v[740:747]*/, v[220:227] /*v[732:739]*/, v[178:185] /*v[434:441]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v8, v94 /*v350*/, v95 /*v351*/
	v_cvt_pk_bf16_f32 v7, v92 /*v348*/, v93 /*v349*/
	v_cvt_pk_bf16_f32 v6, v90 /*v346*/, v91 /*v347*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:40992
	ds_store_b128 v16, v[6:9] offset:40960
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[186:193] /*v[442:449]*/, v[26:33] /*v[538:545]*/, v[220:227] /*v[732:739]*/, v[186:193] /*v[442:449]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v5, v184 /*v440*/, v185 /*v441*/
	v_cvt_pk_bf16_f32 v4, v182 /*v438*/, v183 /*v439*/
	v_cvt_pk_bf16_f32 v3, v180 /*v436*/, v181 /*v437*/
	v_cvt_pk_bf16_f32 v2, v178 /*v434*/, v179 /*v435*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v192 /*v448*/, v193 /*v449*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[202:209] /*v[458:465]*/, v[236:243] /*v[748:755]*/, v[220:227] /*v[732:739]*/, v[202:209] /*v[458:465]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v8, v190 /*v446*/, v191 /*v447*/
	v_cvt_pk_bf16_f32 v7, v188 /*v444*/, v189 /*v445*/
	v_cvt_pk_bf16_f32 v6, v186 /*v442*/, v187 /*v443*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:49152
	ds_store_b128 v16, v[6:9] offset:49184
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[210:217] /*v[466:473]*/, v[10:17] /*v[522:529]*/, v[220:227] /*v[732:739]*/, v[210:217] /*v[466:473]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v5, v208 /*v464*/, v209 /*v465*/
	v_cvt_pk_bf16_f32 v4, v206 /*v462*/, v207 /*v463*/
	v_cvt_pk_bf16_f32 v3, v204 /*v460*/, v205 /*v461*/
	v_cvt_pk_bf16_f32 v2, v202 /*v458*/, v203 /*v459*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v216 /*v472*/, v217 /*v473*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[218:225] /*v[474:481]*/, v[244:251] /*v[756:763]*/, v[220:227] /*v[732:739]*/, v[218:225] /*v[474:481]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v8, v214 /*v470*/, v215 /*v471*/
	v_cvt_pk_bf16_f32 v7, v212 /*v468*/, v213 /*v469*/
	v_cvt_pk_bf16_f32 v6, v210 /*v466*/, v211 /*v467*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:49216
	ds_store_b128 v16, v[6:9] offset:49248
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[234:241] /*v[490:497]*/, v[18:25] /*v[530:537]*/, v[220:227] /*v[732:739]*/, v[234:241] /*v[490:497]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v5, v224 /*v480*/, v225 /*v481*/
	v_cvt_pk_bf16_f32 v4, v222 /*v478*/, v223 /*v479*/
	v_cvt_pk_bf16_f32 v3, v220 /*v476*/, v221 /*v477*/
	v_cvt_pk_bf16_f32 v2, v218 /*v474*/, v219 /*v475*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v240 /*v496*/, v241 /*v497*/
	s_set_vgpr_msb 0x55b
	v_wmma_f32_16x16x32_bf16 v[242:249] /*v[498:505]*/, v[4:11] /*v[772:779]*/, v[220:227] /*v[732:739]*/, v[242:249] /*v[498:505]*/
	s_set_vgpr_msb 0x5b05
	v_cvt_pk_bf16_f32 v8, v238 /*v494*/, v239 /*v495*/
	v_cvt_pk_bf16_f32 v7, v236 /*v492*/, v237 /*v493*/
	v_cvt_pk_bf16_f32 v6, v234 /*v490*/, v235 /*v491*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:49280
	ds_store_b128 v16, v[6:9] offset:49312
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[250:257] /*v[506:513]*/, v[34:41] /*v[546:553]*/, v[220:227] /*v[732:739]*/, v[250:257] /*v[506:513]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v5, v248 /*v504*/, v249 /*v505*/
	v_cvt_pk_bf16_f32 v4, v246 /*v502*/, v247 /*v503*/
	v_cvt_pk_bf16_f32 v3, v244 /*v500*/, v245 /*v501*/
	v_cvt_pk_bf16_f32 v2, v242 /*v498*/, v243 /*v499*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x50a
	v_cvt_pk_bf16_f32 v9, v0 /*v512*/, v1 /*v513*/
	v_wmma_f32_16x16x32_bf16 v[74:81], v[228:235] /*v[740:747]*/, v[2:9] /*v[514:521]*/, v[74:81]
	s_set_vgpr_msb 0xa05
	v_cvt_pk_bf16_f32 v8, v254 /*v510*/, v255 /*v511*/
	v_cvt_pk_bf16_f32 v7, v252 /*v508*/, v253 /*v509*/
	v_cvt_pk_bf16_f32 v6, v250 /*v506*/, v251 /*v507*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v16, v[2:5] offset:49344
	ds_store_b128 v16, v[6:9] offset:49376
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[82:89], v[26:33] /*v[538:545]*/, v[2:9] /*v[514:521]*/, v[82:89]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v5, v80, v81
	v_cvt_pk_bf16_f32 v4, v78, v79
	v_cvt_pk_bf16_f32 v3, v76, v77
	v_cvt_pk_bf16_f32 v2, v74, v75
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v88, v89
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[98:105], v[236:243] /*v[748:755]*/, v[2:9] /*v[514:521]*/, v[98:105]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v8, v86, v87
	v_cvt_pk_bf16_f32 v7, v84, v85
	v_cvt_pk_bf16_f32 v6, v82, v83
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v0, v[2:5]
	ds_store_b128 v0, v[6:9] offset:32
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[114:121], v[10:17] /*v[522:529]*/, v[2:9] /*v[514:521]*/, v[114:121]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v5, v104, v105
	v_cvt_pk_bf16_f32 v4, v102, v103
	v_cvt_pk_bf16_f32 v3, v100, v101
	v_cvt_pk_bf16_f32 v2, v98, v99
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v9, v120, v121
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[122:129], v[244:251] /*v[756:763]*/, v[2:9] /*v[514:521]*/, v[122:129]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v8, v118, v119
	v_cvt_pk_bf16_f32 v7, v116, v117
	v_cvt_pk_bf16_f32 v6, v114, v115
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v13, v128, v129
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[130:137], v[18:25] /*v[530:537]*/, v[2:9] /*v[514:521]*/, v[130:137]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v12, v126, v127
	v_cvt_pk_bf16_f32 v11, v124, v125
	v_cvt_pk_bf16_f32 v10, v122, v123
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v17, v136, v137
	s_set_vgpr_msb 11
	v_wmma_f32_16x16x32_bf16 v[138:145], v[4:11] /*v[772:779]*/, v[2:9] /*v[514:521]*/, v[138:145]
	s_set_vgpr_msb 0xb00
	v_cvt_pk_bf16_f32 v16, v134, v135
	v_cvt_pk_bf16_f32 v15, v132, v133
	v_cvt_pk_bf16_f32 v14, v130, v131
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v21, v144, v145
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[154:161], v[34:41] /*v[546:553]*/, v[2:9] /*v[514:521]*/, v[154:161]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v20, v142, v143
	v_cvt_pk_bf16_f32 v19, v140, v141
	v_cvt_pk_bf16_f32 v18, v138, v139
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v25, v160, v161
	v_cvt_pk_bf16_f32 v24, v158, v159
	v_cvt_pk_bf16_f32 v23, v156, v157
	v_cvt_pk_bf16_f32 v22, v154, v155
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v0, v[2:5] offset:64
	ds_store_b128 v0, v[6:9] offset:96
	ds_store_b128 v0, v[10:13] offset:128
	ds_store_b128 v0, v[14:17] offset:160
	ds_store_b128 v0, v[18:21] offset:192
	ds_store_b128 v0, v[22:25] offset:224
	s_wait_dscnt 0x0
	s_barrier_signal -1
	s_wait_alu depctr_vm_vsrc(5)
	s_set_vgpr_msb 8
	v_lshrrev_b64 v[2:3], 16, v[42:43] /*v[554:555]*/
	v_dual_mov_b32 v3, s0 :: v_dual_mov_b32 v5, s12
	s_wait_alu depctr_vm_vsrc(4)
	v_mov_b32_e32 v6, s1
	v_readfirstlane_b32 s1, v1
	s_mov_b32 s0, 0x10000
	v_readfirstlane_b32 s2, v2
	v_readfirstlane_b32 s3, v3
	v_readfirstlane_b32 s5, v5
	v_readfirstlane_b32 s6, v6
	s_barrier_wait -1
	s_delay_alu instid0(VALU_DEP_1)
	tensor_store_from_lds s[8:11], s[0:7]
	s_wait_tensorcnt 0x0
	s_endpgm
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel kernel_grouped_nt_0
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 52
		.amdhsa_user_sgpr_count 2
		.amdhsa_user_sgpr_dispatch_ptr 0
		.amdhsa_user_sgpr_queue_ptr 0
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_dispatch_id 0
		.amdhsa_user_sgpr_kernarg_preload_length 0
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_user_sgpr_private_segment_size 0
		.amdhsa_wavefront_size32 1
		.amdhsa_uses_dynamic_stack 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 849
		.amdhsa_next_free_sgpr 52
		.amdhsa_named_barrier_count 0
		.amdhsa_reserve_vcc 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_fp16_overflow 0
		.amdhsa_memory_ordered 1
		.amdhsa_forward_progress 1
		.amdhsa_inst_pref_size 137
		.amdhsa_round_robin_scheduling 0
		.amdhsa_exception_fp_ieee_invalid_op 0
		.amdhsa_exception_fp_denorm_src 0
		.amdhsa_exception_fp_ieee_div_zero 0
		.amdhsa_exception_fp_ieee_overflow 0
		.amdhsa_exception_fp_ieee_underflow 0
		.amdhsa_exception_fp_ieee_inexact 0
		.amdhsa_exception_int_div_zero 0
	.end_amdhsa_kernel
	.text
.Lfunc_end0:
	.size	kernel_grouped_nt_0, .Lfunc_end0-kernel_grouped_nt_0

	.set kernel_grouped_nt_0.num_vgpr, 849
	.set kernel_grouped_nt_0.num_agpr, 0
	.set kernel_grouped_nt_0.numbered_sgpr, 52
	.set kernel_grouped_nt_0.num_named_barrier, 0
	.set kernel_grouped_nt_0.private_seg_size, 0
	.set kernel_grouped_nt_0.uses_vcc, 1
	.set kernel_grouped_nt_0.uses_flat_scratch, 0
	.set kernel_grouped_nt_0.has_dyn_sized_stack, 0
	.set kernel_grouped_nt_0.has_recursion, 0
	.set kernel_grouped_nt_0.has_indirect_call, 0
	.p2alignl 7, 3214868480
	.fill 96, 4, 3214868480
	.section	.AMDGPU.gpr_maximums,"",@progbits
	.set amdgpu.max_num_vgpr, 0
	.set amdgpu.max_num_agpr, 0
	.set amdgpu.max_num_sgpr, 0
	.set amdgpu.max_num_named_barrier, 0
	.text
	.section	".note.GNU-stack","",@progbits
	.amdgpu_metadata
---
amdhsa.kernels:
  - .args:
      - .address_space:  global
        .offset:         0
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         8
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         16
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         24
        .size:           8
        .value_kind:     global_buffer
      - .offset:         32
        .size:           4
        .value_kind:     by_value
      - .offset:         36
        .size:           4
        .value_kind:     by_value
      - .offset:         40
        .size:           4
        .value_kind:     by_value
      - .offset:         44
        .size:           4
        .value_kind:     by_value
      - .offset:         48
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 52
    .max_flat_workgroup_size: 128
    .name:           kernel_grouped_nt_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 128
      - 1
      - 1
    .sgpr_count:     54
    .sgpr_spill_count: 0
    .symbol:         kernel_grouped_nt_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     849
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.target:   amdgcn-amd-amdhsa--gfx1250
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
