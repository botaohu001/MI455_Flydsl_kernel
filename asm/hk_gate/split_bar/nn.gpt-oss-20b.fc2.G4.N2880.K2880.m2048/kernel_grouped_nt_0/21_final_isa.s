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
	s_load_b128 s[24:27], s[0:1], 0x20 nv
	s_load_b32 s34, s[0:1], 0x30 nv
	s_bfe_u32 s2, ttmp6, 0x4000c
	v_readfirstlane_b32 s35, v0
	s_add_co_i32 s2, s2, 1
	s_and_b32 s3, ttmp6, 15
	s_mul_i32 s2, ttmp9, s2
	s_getreg_b32 s4, hwreg(HW_REG_IB_STS2, 6, 4)
	s_add_co_i32 s5, s3, s2
	s_lshr_b32 s43, s35, 5
	s_mov_b32 s19, 0
	s_wait_kmcnt 0x0
	s_ashr_i32 s3, s26, 31
	s_mov_b32 s2, s26
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_lshl_b64 s[20:21], s[2:3], 1
	s_cmp_eq_u32 s4, 0
	s_cselect_b32 s2, ttmp9, s5
	s_mul_hi_i32 s3, s2, 0x2aaaaaab
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_lshr_b32 s4, s3, 31
	s_ashr_i32 s3, s3, 5
	s_add_co_i32 s3, s3, s4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s12, s3, 0xc0
	s_cmp_lg_u32 s2, s12
	s_cselect_b32 s4, -1, 0
	s_cmp_lt_i32 s2, 0
	s_cselect_b32 s5, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 s4, s5, s4
	s_sub_co_ci_u32 s39, s3, 0
	s_sub_co_i32 s40, s2, s12
	s_lshl_b32 s3, s39, 4
	s_abs_i32 s2, s40
	s_sub_co_i32 s4, 36, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_min_i32 s13, s4, 16
	s_abs_i32 s14, s13
	s_xor_b32 s12, s40, s13
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
	s_sub_co_i32 s41, s0, s12
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s42, s41, s13
	s_sub_co_i32 s0, s40, s42
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
	s_min_u32 s38, s0, 3
	s_add_co_i32 s0, s38, 4
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
	s_cselect_b32 s36, s2, 0
	s_mov_b32 s0, 1
	s_ashr_i32 s37, s36, 31
	s_cmp_eq_u32 s43, 0
	v_readfirstlane_b32 s33, v1
	s_mul_u64 s[2:3], s[20:21], s[36:37]
	s_cselect_b32 s10, -1, 0
	s_cmp_lg_u32 s43, 0
	s_add_nc_u64 s[22:23], s[6:7], s[2:3]
	s_cbranch_scc1 .LBB0_2
	s_cmp_lg_u32 s26, -2.0
	s_mov_b32 s1, s19
	s_cselect_b32 s17, s20, 0x80
	s_cselect_b32 s6, s21, 0
	s_max_i32 s7, s33, 0
	s_or_b32 s3, s23, 0x80000000
	s_lshl_b32 s11, s7, 16
	s_lshr_b32 s7, s7, 16
	s_mov_b32 s2, s22
	s_or_b32 s14, s11, 0x7fff
	s_or_b32 s15, s7, 0x800000
	s_and_b32 s18, s6, 0xffff
	s_mov_b32 s13, 0xffff0000
	s_mov_b32 s12, 0x7300000
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[0:3], s[12:19]
.LBB0_2:
	s_ashr_i32 s31, s27, 31
	s_mov_b32 s30, s27
	s_delay_alu instid0(SALU_CYCLE_1)
	s_lshl_b64 s[28:29], s[30:31], 1
	s_cmp_lg_u32 s40, s42
	s_cselect_b32 s0, -1, 0
	s_cmp_lt_i32 s40, 0
	s_cselect_b32 s1, -1, 0
	s_cmp_gt_i32 s39, 2
	s_cselect_b32 s2, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s1, s1, s2
	s_and_b32 s0, s1, s0
	s_sub_co_ci_u32 s0, s41, 0
	s_add_co_i32 s14, s25, 0xffffff00
	s_lshl_b32 s2, s0, 8
	s_ashr_i32 s39, s38, 31
	s_min_i32 s6, s2, s14
	s_cmp_eq_u32 s43, 1
	s_mul_u64 s[0:1], s[38:39], 0xfd2000
	s_cselect_b32 s3, -1, 0
	s_cmp_lg_u32 s43, 1
	s_add_nc_u64 s[40:41], s[8:9], s[0:1]
	s_cbranch_scc1 .LBB0_4
	s_ashr_i32 s7, s6, 31
	s_brev_b32 s45, 64
	s_lshl_b64 s[0:1], s[6:7], 1
	s_mov_b32 s16, 1
	s_add_nc_u64 s[18:19], s[40:41], s[0:1]
	s_mov_b32 s51, 0
	s_add_co_i32 s17, 0, 0x9000
	s_bitset1_b32 s19, 31
	s_and_b32 s50, s29, 0xffff
	s_mov_b32 s48, 64
	s_mov_b32 s46, 0x400000
	s_mov_b32 s44, 0xfb00000
	s_mov_b32 s47, s45
	s_mov_b32 s49, s28
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[16:19], s[44:51]
.LBB0_4:
	v_cndmask_b32_e64 v1, 0, 1, s10
	s_and_not1_b32 vcc_lo, exec_lo, s10
	s_mov_b32 s8, 1
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_ne_u32_e64 s0, 1, v1
	s_cbranch_vccnz .LBB0_6
	s_cmp_lg_u32 s26, -2.0
	s_add_nc_u64 s[10:11], s[22:23], 0x80
	s_cselect_b32 s49, s20, 0x80
	s_cselect_b32 s1, s21, 0
	s_max_i32 s7, s33, 0
	s_mov_b32 s51, 0
	s_lshl_b32 s12, s7, 16
	s_lshr_b32 s7, s7, 16
	s_bitset1_b32 s11, 31
	s_add_co_i32 s9, 0, 0x11800
	s_or_b32 s46, s12, 0x7fff
	s_or_b32 s47, s7, 0x800000
	s_and_b32 s50, s1, 0xffff
	s_movk_i32 s48, 0x100
	s_mov_b32 s45, 0xffff0000
	s_mov_b32 s44, 0x7300000
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[8:11], s[44:51]
.LBB0_6:
	v_cndmask_b32_e64 v1, 0, 1, s3
	s_and_not1_b32 vcc_lo, exec_lo, s3
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_ne_u32_e64 s1, 1, v1
	s_cbranch_vccnz .LBB0_8
	s_ashr_i32 s7, s6, 31
	s_lshl_b64 s[8:9], s[30:31], 7
	s_lshl_b64 s[10:11], s[6:7], 1
	s_add_nc_u64 s[8:9], s[40:41], s[8:9]
	s_brev_b32 s45, 64
	s_add_nc_u64 s[10:11], s[8:9], s[10:11]
	s_mov_b32 s8, 1
	s_bitset1_b32 s11, 31
	s_mov_b32 s51, 0
	s_add_co_i32 s9, 0, 0x1a800
	s_and_b32 s50, s29, 0xffff
	s_mov_b32 s48, 64
	s_mov_b32 s46, 0x400000
	s_mov_b32 s44, 0xfb00000
	s_mov_b32 s47, s45
	s_mov_b32 s49, s28
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[8:11], s[44:51]
.LBB0_8:
	s_ashr_i32 s3, s24, 31
	s_set_vgpr_msb 0x80
	v_and_b32_e32 v2 /*v514*/, 15, v0
	s_lshr_b32 s3, s3, 26
	v_and_b32_e32 v3 /*v515*/, 16, v0
	s_add_co_i32 s3, s24, s3
	s_wait_tensorcnt 0x1
	s_and_b32 s7, s3, 0xffffffc0
	s_ashr_i32 s3, s3, 6
	s_cmp_lg_u32 s24, s7
	s_cselect_b32 s7, -1, 0
	s_cmp_lt_i32 s24, 0
	s_barrier_signal -1
	s_cselect_b32 s8, -1, 0
	s_set_vgpr_msb 0x8000
	v_lshrrev_b32_e32 v1, 1, v0
	s_and_b32 s7, s8, s7
	s_sub_co_ci_u32 s42, s3, 0
	s_lshl_b32 s3, s35, 1
	s_lshl_b32 s7, s43, 7
	s_and_b32 s9, s3, 0xffffff80
	s_set_vgpr_msb 0xc0
	v_and_b32_e32 v4 /*v772*/, 8, v1
	s_set_vgpr_msb 0xc0c8
	v_or_b32_e32 v1 /*v769*/, s9, v2 /*v514*/
	v_or3_b32 v14 /*v782*/, v0, s9, 0x70
	s_mov_b32 s8, 0
	s_mov_b32 s3, 0x9000
	s_set_vgpr_msb 0xc8b0
	v_and_or_b32 v4 /*v516*/, v0, 7, v4 /*v772*/
	s_set_vgpr_msb 0xb00c
	v_mul_lo_u32 v2, 0x90, v1 /*v769*/
	s_cmp_gt_i32 s42, 2
	s_set_vgpr_msb 0xcc8
	s_barrier_wait -1
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u32_e32 v7 /*v775*/, v2, v3 /*v515*/
	s_set_vgpr_msb 0xc8cc
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u32_e32 v13 /*v781*/, 64, v7 /*v775*/
	v_add_nc_u32_e32 v12 /*v780*/, 0x60, v7 /*v775*/
	s_set_vgpr_msb 0xcc00
	s_cbranch_scc1 .LBB0_10
	s_set_vgpr_msb 0x8c
	v_or3_b32 v40 /*v552*/, v0, s9, 0x70
	v_add_nc_u32_e32 v0 /*v512*/, 64, v7 /*v775*/
	v_add_nc_u32_e32 v1 /*v513*/, 0x60, v7 /*v775*/
	s_set_vgpr_msb 0x8ce8
	s_delay_alu instid0(VALU_DEP_3)
	v_mad_u32 v8 /*v776*/, 0x90, v40 /*v552*/, v3 /*v515*/
	s_set_vgpr_msb 0xe8cc
	s_delay_alu instid0(VALU_DEP_1)
	v_dual_add_nc_u32 v9 /*v777*/, 32, v8 /*v776*/ :: v_dual_add_nc_u32 v5 /*v773*/, 64, v8 /*v776*/
	v_add_nc_u32_e32 v6 /*v774*/, 0x60, v8 /*v776*/
	s_set_vgpr_msb 0xcc00
	s_branch .LBB0_11
.LBB0_10:
	s_mov_b32 s8, -1
.LBB0_11:
	v_mov_b32_e32 v7, 0
	s_set_vgpr_msb 0xc0
	v_and_b32_e32 v10 /*v778*/, 8, v0
	s_set_vgpr_msb 0xc0c8
	v_mad_u32_u24 v11 /*v779*/, 0x220, v4 /*v516*/, s3
	s_and_b32 s24, s7, 0x80
	s_add_co_i32 s7, s42, -2
	s_set_vgpr_msb 0xc800
	v_dual_mov_b32 v6, v7 :: v_dual_mov_b32 v5, v7
	v_dual_mov_b32 v4, v7 :: v_dual_mov_b32 v3, v7
	v_dual_mov_b32 v2, v7 :: v_dual_mov_b32 v1, v7
	v_dual_mov_b32 v0, v7 :: v_dual_mov_b32 v15, v7
	v_dual_mov_b32 v14, v7 :: v_dual_mov_b32 v13, v7
	v_dual_mov_b32 v12, v7 :: v_dual_mov_b32 v11, v7
	v_dual_mov_b32 v10, v7 :: v_dual_mov_b32 v9, v7
	v_dual_mov_b32 v8, v7 :: v_dual_mov_b32 v23, v7
	v_dual_mov_b32 v22, v7 :: v_dual_mov_b32 v21, v7
	v_dual_mov_b32 v20, v7 :: v_dual_mov_b32 v19, v7
	v_dual_mov_b32 v18, v7 :: v_dual_mov_b32 v17, v7
	v_dual_mov_b32 v16, v7 :: v_dual_mov_b32 v39, v7
	v_dual_mov_b32 v38, v7 :: v_dual_mov_b32 v37, v7
	v_dual_mov_b32 v36, v7 :: v_dual_mov_b32 v35, v7
	v_dual_mov_b32 v34, v7 :: v_dual_mov_b32 v33, v7
	v_dual_mov_b32 v32, v7 :: v_dual_mov_b32 v47, v7
	v_dual_mov_b32 v46, v7 :: v_dual_mov_b32 v45, v7
	v_dual_mov_b32 v44, v7 :: v_dual_mov_b32 v43, v7
	v_dual_mov_b32 v42, v7 :: v_dual_mov_b32 v41, v7
	v_dual_mov_b32 v40, v7 :: v_dual_mov_b32 v55, v7
	v_dual_mov_b32 v54, v7 :: v_dual_mov_b32 v53, v7
	v_dual_mov_b32 v52, v7 :: v_dual_mov_b32 v51, v7
	v_dual_mov_b32 v50, v7 :: v_dual_mov_b32 v49, v7
	v_dual_mov_b32 v48, v7 :: v_dual_mov_b32 v71, v7
	v_dual_mov_b32 v70, v7 :: v_dual_mov_b32 v69, v7
	v_dual_mov_b32 v68, v7 :: v_dual_mov_b32 v67, v7
	v_dual_mov_b32 v66, v7 :: v_dual_mov_b32 v65, v7
	v_dual_mov_b32 v64, v7 :: v_dual_mov_b32 v79, v7
	v_dual_mov_b32 v78, v7 :: v_dual_mov_b32 v77, v7
	v_dual_mov_b32 v76, v7 :: v_dual_mov_b32 v75, v7
	v_dual_mov_b32 v74, v7 :: v_dual_mov_b32 v73, v7
	v_dual_mov_b32 v72, v7 :: v_dual_mov_b32 v31, v7
	v_dual_mov_b32 v30, v7 :: v_dual_mov_b32 v29, v7
	v_dual_mov_b32 v28, v7 :: v_dual_mov_b32 v27, v7
	v_dual_mov_b32 v26, v7 :: v_dual_mov_b32 v25, v7
	v_dual_mov_b32 v24, v7 :: v_dual_mov_b32 v63, v7
	v_dual_mov_b32 v62, v7 :: v_dual_mov_b32 v61, v7
	v_dual_mov_b32 v60, v7 :: v_dual_mov_b32 v59, v7
	v_dual_mov_b32 v58, v7 :: v_dual_mov_b32 v57, v7
	v_dual_mov_b32 v56, v7 :: v_dual_mov_b32 v87, v7
	v_dual_mov_b32 v86, v7 :: v_dual_mov_b32 v85, v7
	v_dual_mov_b32 v84, v7 :: v_dual_mov_b32 v83, v7
	v_dual_mov_b32 v82, v7 :: v_dual_mov_b32 v81, v7
	v_dual_mov_b32 v80, v7 :: v_dual_mov_b32 v119, v7
	v_dual_mov_b32 v118, v7 :: v_dual_mov_b32 v117, v7
	v_dual_mov_b32 v116, v7 :: v_dual_mov_b32 v115, v7
	v_dual_mov_b32 v114, v7 :: v_dual_mov_b32 v113, v7
	v_dual_mov_b32 v112, v7 :: v_dual_mov_b32 v159, v7
	v_dual_mov_b32 v158, v7 :: v_dual_mov_b32 v157, v7
	v_dual_mov_b32 v156, v7 :: v_dual_mov_b32 v155, v7
	v_dual_mov_b32 v154, v7 :: v_dual_mov_b32 v153, v7
	v_dual_mov_b32 v152, v7 :: v_dual_mov_b32 v175, v7
	v_dual_mov_b32 v174, v7 :: v_dual_mov_b32 v173, v7
	v_dual_mov_b32 v172, v7 :: v_dual_mov_b32 v171, v7
	v_dual_mov_b32 v170, v7 :: v_dual_mov_b32 v169, v7
	v_dual_mov_b32 v168, v7 :: v_dual_mov_b32 v199, v7
	v_dual_mov_b32 v198, v7 :: v_dual_mov_b32 v197, v7
	v_dual_mov_b32 v196, v7 :: v_dual_mov_b32 v195, v7
	v_dual_mov_b32 v194, v7 :: v_dual_mov_b32 v193, v7
	v_dual_mov_b32 v192, v7 :: v_dual_mov_b32 v231, v7
	v_dual_mov_b32 v230, v7 :: v_dual_mov_b32 v229, v7
	v_dual_mov_b32 v228, v7 :: v_dual_mov_b32 v227, v7
	v_dual_mov_b32 v226, v7 :: v_dual_mov_b32 v225, v7
	v_dual_mov_b32 v224, v7 :: v_dual_mov_b32 v183, v7
	v_dual_mov_b32 v182, v7 :: v_dual_mov_b32 v181, v7
	v_dual_mov_b32 v180, v7 :: v_dual_mov_b32 v179, v7
	v_dual_mov_b32 v178, v7 :: v_dual_mov_b32 v177, v7
	v_dual_mov_b32 v176, v7 :: v_dual_mov_b32 v191, v7
	v_dual_mov_b32 v190, v7 :: v_dual_mov_b32 v189, v7
	v_dual_mov_b32 v188, v7 :: v_dual_mov_b32 v187, v7
	v_dual_mov_b32 v186, v7 :: v_dual_mov_b32 v185, v7
	v_dual_mov_b32 v184, v7 :: v_dual_mov_b32 v207, v7
	v_dual_mov_b32 v206, v7 :: v_dual_mov_b32 v205, v7
	v_dual_mov_b32 v204, v7 :: v_dual_mov_b32 v203, v7
	v_dual_mov_b32 v202, v7 :: v_dual_mov_b32 v201, v7
	v_dual_mov_b32 v200, v7 :: v_dual_mov_b32 v215, v7
	v_dual_mov_b32 v214, v7 :: v_dual_mov_b32 v213, v7
	v_dual_mov_b32 v212, v7 :: v_dual_mov_b32 v211, v7
	v_dual_mov_b32 v210, v7 :: v_dual_mov_b32 v209, v7
	v_dual_mov_b32 v208, v7 :: v_dual_mov_b32 v223, v7
	v_dual_mov_b32 v222, v7 :: v_dual_mov_b32 v221, v7
	v_dual_mov_b32 v220, v7 :: v_dual_mov_b32 v219, v7
	v_dual_mov_b32 v218, v7 :: v_dual_mov_b32 v217, v7
	v_mov_b32_e32 v216, v7
	s_set_vgpr_msb 64
	v_dual_mov_b32 v63 /*v319*/, v7 :: v_dual_mov_b32 v62 /*v318*/, v7
	v_dual_mov_b32 v61 /*v317*/, v7 :: v_dual_mov_b32 v60 /*v316*/, v7
	v_dual_mov_b32 v59 /*v315*/, v7 :: v_dual_mov_b32 v58 /*v314*/, v7
	v_dual_mov_b32 v57 /*v313*/, v7 :: v_dual_mov_b32 v56 /*v312*/, v7
	v_dual_mov_b32 v55 /*v311*/, v7 :: v_dual_mov_b32 v54 /*v310*/, v7
	v_dual_mov_b32 v53 /*v309*/, v7 :: v_dual_mov_b32 v52 /*v308*/, v7
	v_dual_mov_b32 v51 /*v307*/, v7 :: v_dual_mov_b32 v50 /*v306*/, v7
	v_dual_mov_b32 v49 /*v305*/, v7 :: v_dual_mov_b32 v48 /*v304*/, v7
	v_dual_mov_b32 v47 /*v303*/, v7 :: v_dual_mov_b32 v46 /*v302*/, v7
	v_dual_mov_b32 v45 /*v301*/, v7 :: v_dual_mov_b32 v44 /*v300*/, v7
	v_dual_mov_b32 v43 /*v299*/, v7 :: v_dual_mov_b32 v42 /*v298*/, v7
	v_dual_mov_b32 v41 /*v297*/, v7 :: v_dual_mov_b32 v40 /*v296*/, v7
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v239, v7 :: v_dual_mov_b32 v238, v7
	v_dual_mov_b32 v237, v7 :: v_dual_mov_b32 v236, v7
	v_dual_mov_b32 v235, v7 :: v_dual_mov_b32 v234, v7
	v_dual_mov_b32 v233, v7 :: v_dual_mov_b32 v232, v7
	v_dual_mov_b32 v247, v7 :: v_dual_mov_b32 v246, v7
	v_dual_mov_b32 v245, v7 :: v_dual_mov_b32 v244, v7
	v_dual_mov_b32 v243, v7 :: v_dual_mov_b32 v242, v7
	v_dual_mov_b32 v241, v7 :: v_dual_mov_b32 v240, v7
	v_dual_mov_b32 v255, v7 :: v_dual_mov_b32 v254, v7
	v_dual_mov_b32 v253, v7 :: v_dual_mov_b32 v252, v7
	v_dual_mov_b32 v251, v7 :: v_dual_mov_b32 v250, v7
	v_dual_mov_b32 v249, v7 :: v_dual_mov_b32 v248, v7
	v_mov_b32_e32 v95, v7
	s_set_vgpr_msb 64
	v_dual_mov_b32 v7 /*v263*/, v7 :: v_dual_mov_b32 v6 /*v262*/, v7
	v_dual_mov_b32 v5 /*v261*/, v7 :: v_dual_mov_b32 v4 /*v260*/, v7
	v_dual_mov_b32 v3 /*v259*/, v7 :: v_dual_mov_b32 v2 /*v258*/, v7
	v_dual_mov_b32 v1 /*v257*/, v7 :: v_dual_mov_b32 v0 /*v256*/, v7
	v_dual_mov_b32 v15 /*v271*/, v7 :: v_dual_mov_b32 v14 /*v270*/, v7
	v_dual_mov_b32 v13 /*v269*/, v7 :: v_dual_mov_b32 v12 /*v268*/, v7
	v_dual_mov_b32 v11 /*v267*/, v7 :: v_dual_mov_b32 v10 /*v266*/, v7
	v_dual_mov_b32 v9 /*v265*/, v7 :: v_dual_mov_b32 v8 /*v264*/, v7
	v_dual_mov_b32 v23 /*v279*/, v7 :: v_dual_mov_b32 v22 /*v278*/, v7
	v_dual_mov_b32 v21 /*v277*/, v7 :: v_dual_mov_b32 v20 /*v276*/, v7
	v_dual_mov_b32 v19 /*v275*/, v7 :: v_dual_mov_b32 v18 /*v274*/, v7
	v_dual_mov_b32 v17 /*v273*/, v7 :: v_dual_mov_b32 v16 /*v272*/, v7
	v_dual_mov_b32 v31 /*v287*/, v7 :: v_dual_mov_b32 v30 /*v286*/, v7
	v_dual_mov_b32 v29 /*v285*/, v7 :: v_dual_mov_b32 v28 /*v284*/, v7
	v_dual_mov_b32 v27 /*v283*/, v7 :: v_dual_mov_b32 v26 /*v282*/, v7
	v_dual_mov_b32 v25 /*v281*/, v7 :: v_dual_mov_b32 v24 /*v280*/, v7
	v_dual_mov_b32 v39 /*v295*/, v7 :: v_dual_mov_b32 v38 /*v294*/, v7
	v_dual_mov_b32 v37 /*v293*/, v7 :: v_dual_mov_b32 v36 /*v292*/, v7
	v_dual_mov_b32 v33 /*v289*/, v7 :: v_dual_mov_b32 v34 /*v290*/, v7
	v_dual_mov_b32 v35 /*v291*/, v7 :: v_dual_mov_b32 v32 /*v288*/, v7
	v_dual_mov_b32 v71 /*v327*/, v7 :: v_dual_mov_b32 v70 /*v326*/, v7
	v_dual_mov_b32 v69 /*v325*/, v7 :: v_dual_mov_b32 v68 /*v324*/, v7
	v_dual_mov_b32 v67 /*v323*/, v7 :: v_dual_mov_b32 v66 /*v322*/, v7
	v_dual_mov_b32 v65 /*v321*/, v7 :: v_dual_mov_b32 v64 /*v320*/, v7
	v_dual_mov_b32 v79 /*v335*/, v7 :: v_dual_mov_b32 v78 /*v334*/, v7
	v_dual_mov_b32 v77 /*v333*/, v7 :: v_dual_mov_b32 v76 /*v332*/, v7
	v_dual_mov_b32 v75 /*v331*/, v7 :: v_dual_mov_b32 v74 /*v330*/, v7
	v_dual_mov_b32 v73 /*v329*/, v7 :: v_dual_mov_b32 v72 /*v328*/, v7
	v_dual_mov_b32 v87 /*v343*/, v7 :: v_dual_mov_b32 v86 /*v342*/, v7
	v_dual_mov_b32 v85 /*v341*/, v7 :: v_dual_mov_b32 v84 /*v340*/, v7
	v_dual_mov_b32 v83 /*v339*/, v7 :: v_dual_mov_b32 v82 /*v338*/, v7
	v_dual_mov_b32 v81 /*v337*/, v7 :: v_dual_mov_b32 v80 /*v336*/, v7
	v_dual_mov_b32 v103 /*v359*/, v7 :: v_dual_mov_b32 v102 /*v358*/, v7
	v_dual_mov_b32 v101 /*v357*/, v7 :: v_dual_mov_b32 v100 /*v356*/, v7
	v_dual_mov_b32 v99 /*v355*/, v7 :: v_dual_mov_b32 v98 /*v354*/, v7
	v_dual_mov_b32 v97 /*v353*/, v7 :: v_dual_mov_b32 v96 /*v352*/, v7
	v_dual_mov_b32 v111 /*v367*/, v7 :: v_dual_mov_b32 v110 /*v366*/, v7
	v_dual_mov_b32 v109 /*v365*/, v7 :: v_dual_mov_b32 v108 /*v364*/, v7
	v_dual_mov_b32 v107 /*v363*/, v7 :: v_dual_mov_b32 v106 /*v362*/, v7
	v_dual_mov_b32 v105 /*v361*/, v7 :: v_dual_mov_b32 v104 /*v360*/, v7
	v_dual_mov_b32 v119 /*v375*/, v7 :: v_dual_mov_b32 v118 /*v374*/, v7
	v_dual_mov_b32 v117 /*v373*/, v7 :: v_dual_mov_b32 v116 /*v372*/, v7
	v_dual_mov_b32 v115 /*v371*/, v7 :: v_dual_mov_b32 v114 /*v370*/, v7
	v_dual_mov_b32 v113 /*v369*/, v7 :: v_dual_mov_b32 v112 /*v368*/, v7
	v_dual_mov_b32 v135 /*v391*/, v7 :: v_dual_mov_b32 v134 /*v390*/, v7
	v_dual_mov_b32 v133 /*v389*/, v7 :: v_dual_mov_b32 v132 /*v388*/, v7
	v_dual_mov_b32 v131 /*v387*/, v7 :: v_dual_mov_b32 v130 /*v386*/, v7
	v_dual_mov_b32 v129 /*v385*/, v7 :: v_dual_mov_b32 v128 /*v384*/, v7
	v_dual_mov_b32 v143 /*v399*/, v7 :: v_dual_mov_b32 v142 /*v398*/, v7
	v_dual_mov_b32 v141 /*v397*/, v7 :: v_dual_mov_b32 v140 /*v396*/, v7
	v_dual_mov_b32 v139 /*v395*/, v7 :: v_dual_mov_b32 v138 /*v394*/, v7
	v_dual_mov_b32 v137 /*v393*/, v7 :: v_dual_mov_b32 v136 /*v392*/, v7
	v_dual_mov_b32 v95 /*v351*/, v7 :: v_dual_mov_b32 v94 /*v350*/, v7
	v_dual_mov_b32 v93 /*v349*/, v7 :: v_dual_mov_b32 v92 /*v348*/, v7
	v_dual_mov_b32 v91 /*v347*/, v7 :: v_dual_mov_b32 v90 /*v346*/, v7
	v_dual_mov_b32 v89 /*v345*/, v7 :: v_dual_mov_b32 v88 /*v344*/, v7
	v_dual_mov_b32 v127 /*v383*/, v7 :: v_dual_mov_b32 v126 /*v382*/, v7
	v_dual_mov_b32 v125 /*v381*/, v7 :: v_dual_mov_b32 v124 /*v380*/, v7
	v_dual_mov_b32 v123 /*v379*/, v7 :: v_dual_mov_b32 v122 /*v378*/, v7
	v_dual_mov_b32 v121 /*v377*/, v7 :: v_dual_mov_b32 v120 /*v376*/, v7
	v_dual_mov_b32 v151 /*v407*/, v7 :: v_dual_mov_b32 v150 /*v406*/, v7
	v_dual_mov_b32 v149 /*v405*/, v7 :: v_dual_mov_b32 v148 /*v404*/, v7
	v_dual_mov_b32 v147 /*v403*/, v7 :: v_dual_mov_b32 v146 /*v402*/, v7
	v_dual_mov_b32 v145 /*v401*/, v7 :: v_dual_mov_b32 v144 /*v400*/, v7
	v_dual_mov_b32 v159 /*v415*/, v7 :: v_dual_mov_b32 v158 /*v414*/, v7
	v_dual_mov_b32 v157 /*v413*/, v7 :: v_dual_mov_b32 v156 /*v412*/, v7
	v_dual_mov_b32 v155 /*v411*/, v7 :: v_dual_mov_b32 v154 /*v410*/, v7
	v_dual_mov_b32 v153 /*v409*/, v7 :: v_dual_mov_b32 v152 /*v408*/, v7
	v_dual_mov_b32 v167 /*v423*/, v7 :: v_dual_mov_b32 v166 /*v422*/, v7
	v_dual_mov_b32 v165 /*v421*/, v7 :: v_dual_mov_b32 v164 /*v420*/, v7
	v_dual_mov_b32 v163 /*v419*/, v7 :: v_dual_mov_b32 v162 /*v418*/, v7
	v_dual_mov_b32 v161 /*v417*/, v7 :: v_dual_mov_b32 v160 /*v416*/, v7
	v_dual_mov_b32 v175 /*v431*/, v7 :: v_dual_mov_b32 v174 /*v430*/, v7
	v_dual_mov_b32 v173 /*v429*/, v7 :: v_dual_mov_b32 v172 /*v428*/, v7
	v_dual_mov_b32 v171 /*v427*/, v7 :: v_dual_mov_b32 v170 /*v426*/, v7
	v_dual_mov_b32 v169 /*v425*/, v7 :: v_dual_mov_b32 v168 /*v424*/, v7
	v_dual_mov_b32 v199 /*v455*/, v7 :: v_dual_mov_b32 v198 /*v454*/, v7
	v_dual_mov_b32 v197 /*v453*/, v7 :: v_dual_mov_b32 v196 /*v452*/, v7
	v_dual_mov_b32 v195 /*v451*/, v7 :: v_dual_mov_b32 v194 /*v450*/, v7
	v_dual_mov_b32 v193 /*v449*/, v7 :: v_dual_mov_b32 v192 /*v448*/, v7
	v_dual_mov_b32 v231 /*v487*/, v7 :: v_dual_mov_b32 v230 /*v486*/, v7
	v_dual_mov_b32 v229 /*v485*/, v7 :: v_dual_mov_b32 v228 /*v484*/, v7
	v_dual_mov_b32 v227 /*v483*/, v7 :: v_dual_mov_b32 v226 /*v482*/, v7
	v_dual_mov_b32 v225 /*v481*/, v7 :: v_dual_mov_b32 v224 /*v480*/, v7
	v_dual_mov_b32 v183 /*v439*/, v7 :: v_dual_mov_b32 v182 /*v438*/, v7
	v_dual_mov_b32 v181 /*v437*/, v7 :: v_dual_mov_b32 v180 /*v436*/, v7
	v_dual_mov_b32 v179 /*v435*/, v7 :: v_dual_mov_b32 v178 /*v434*/, v7
	v_dual_mov_b32 v177 /*v433*/, v7 :: v_dual_mov_b32 v176 /*v432*/, v7
	v_dual_mov_b32 v191 /*v447*/, v7 :: v_dual_mov_b32 v190 /*v446*/, v7
	v_dual_mov_b32 v189 /*v445*/, v7 :: v_dual_mov_b32 v188 /*v444*/, v7
	v_dual_mov_b32 v187 /*v443*/, v7 :: v_dual_mov_b32 v186 /*v442*/, v7
	v_dual_mov_b32 v185 /*v441*/, v7 :: v_dual_mov_b32 v184 /*v440*/, v7
	v_dual_mov_b32 v207 /*v463*/, v7 :: v_dual_mov_b32 v206 /*v462*/, v7
	v_dual_mov_b32 v205 /*v461*/, v7 :: v_dual_mov_b32 v204 /*v460*/, v7
	v_dual_mov_b32 v203 /*v459*/, v7 :: v_dual_mov_b32 v202 /*v458*/, v7
	v_dual_mov_b32 v201 /*v457*/, v7 :: v_dual_mov_b32 v200 /*v456*/, v7
	v_dual_mov_b32 v215 /*v471*/, v7 :: v_dual_mov_b32 v214 /*v470*/, v7
	v_dual_mov_b32 v213 /*v469*/, v7 :: v_dual_mov_b32 v212 /*v468*/, v7
	v_dual_mov_b32 v211 /*v467*/, v7 :: v_dual_mov_b32 v210 /*v466*/, v7
	v_dual_mov_b32 v209 /*v465*/, v7 :: v_dual_mov_b32 v208 /*v464*/, v7
	v_dual_mov_b32 v223 /*v479*/, v7 :: v_dual_mov_b32 v222 /*v478*/, v7
	v_dual_mov_b32 v221 /*v477*/, v7 :: v_dual_mov_b32 v220 /*v476*/, v7
	v_dual_mov_b32 v219 /*v475*/, v7 :: v_dual_mov_b32 v218 /*v474*/, v7
	v_dual_mov_b32 v217 /*v473*/, v7 :: v_dual_mov_b32 v216 /*v472*/, v7
	v_dual_mov_b32 v239 /*v495*/, v7 :: v_dual_mov_b32 v238 /*v494*/, v7
	v_dual_mov_b32 v237 /*v493*/, v7 :: v_dual_mov_b32 v236 /*v492*/, v7
	v_dual_mov_b32 v235 /*v491*/, v7 :: v_dual_mov_b32 v234 /*v490*/, v7
	v_dual_mov_b32 v233 /*v489*/, v7 :: v_dual_mov_b32 v232 /*v488*/, v7
	v_dual_mov_b32 v247 /*v503*/, v7 :: v_dual_mov_b32 v246 /*v502*/, v7
	v_dual_mov_b32 v245 /*v501*/, v7 :: v_dual_mov_b32 v244 /*v500*/, v7
	v_dual_mov_b32 v243 /*v499*/, v7 :: v_dual_mov_b32 v242 /*v498*/, v7
	v_dual_mov_b32 v241 /*v497*/, v7 :: v_dual_mov_b32 v240 /*v496*/, v7
	v_dual_mov_b32 v255 /*v511*/, v7 :: v_dual_mov_b32 v254 /*v510*/, v7
	v_dual_mov_b32 v253 /*v509*/, v7 :: v_dual_mov_b32 v252 /*v508*/, v7
	v_dual_mov_b32 v251 /*v507*/, v7 :: v_dual_mov_b32 v250 /*v506*/, v7
	v_dual_mov_b32 v249 /*v505*/, v7 :: v_dual_mov_b32 v248 /*v504*/, v7
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v94, v7 :: v_dual_mov_b32 v93, v7
	v_dual_mov_b32 v92, v7 :: v_dual_mov_b32 v91, v7
	v_dual_mov_b32 v90, v7 :: v_dual_mov_b32 v89, v7
	v_dual_mov_b32 v88, v7 :: v_dual_mov_b32 v103, v7
	v_dual_mov_b32 v102, v7 :: v_dual_mov_b32 v101, v7
	v_dual_mov_b32 v100, v7 :: v_dual_mov_b32 v99, v7
	v_dual_mov_b32 v98, v7 :: v_dual_mov_b32 v97, v7
	v_dual_mov_b32 v96, v7 :: v_dual_mov_b32 v111, v7
	v_dual_mov_b32 v110, v7 :: v_dual_mov_b32 v109, v7
	v_dual_mov_b32 v108, v7 :: v_dual_mov_b32 v107, v7
	v_dual_mov_b32 v106, v7 :: v_dual_mov_b32 v105, v7
	v_dual_mov_b32 v104, v7 :: v_dual_mov_b32 v127, v7
	v_dual_mov_b32 v126, v7 :: v_dual_mov_b32 v125, v7
	v_dual_mov_b32 v124, v7 :: v_dual_mov_b32 v123, v7
	v_dual_mov_b32 v122, v7 :: v_dual_mov_b32 v121, v7
	v_dual_mov_b32 v120, v7 :: v_dual_mov_b32 v135, v7
	v_dual_mov_b32 v134, v7 :: v_dual_mov_b32 v133, v7
	v_dual_mov_b32 v132, v7 :: v_dual_mov_b32 v131, v7
	v_dual_mov_b32 v130, v7 :: v_dual_mov_b32 v129, v7
	v_dual_mov_b32 v128, v7 :: v_dual_mov_b32 v143, v7
	v_dual_mov_b32 v142, v7 :: v_dual_mov_b32 v141, v7
	v_dual_mov_b32 v140, v7 :: v_dual_mov_b32 v139, v7
	v_dual_mov_b32 v138, v7 :: v_dual_mov_b32 v137, v7
	v_dual_mov_b32 v136, v7 :: v_dual_mov_b32 v151, v7
	v_dual_mov_b32 v150, v7 :: v_dual_mov_b32 v149, v7
	v_dual_mov_b32 v148, v7 :: v_dual_mov_b32 v147, v7
	v_dual_mov_b32 v146, v7 :: v_dual_mov_b32 v145, v7
	v_dual_mov_b32 v144, v7 :: v_dual_mov_b32 v167, v7
	v_dual_mov_b32 v166, v7 :: v_dual_mov_b32 v165, v7
	v_dual_mov_b32 v164, v7 :: v_dual_mov_b32 v163, v7
	v_dual_mov_b32 v162, v7 :: v_dual_mov_b32 v161, v7
	v_mov_b32_e32 v160, v7
	s_and_not1_b32 vcc_lo, exec_lo, s8
	s_cbranch_vccnz .LBB0_19
	s_cmp_lg_u32 s26, -2.0
	s_set_vgpr_msb 0xcc
	v_mul_lo_u32 v15 /*v783*/, 0x90, v14 /*v782*/
	s_cselect_b32 s13, s20, 0x80
	s_cselect_b32 s43, s21, 0
	s_ashr_i32 s3, s2, 31
	s_ashr_i32 s15, s14, 31
	s_lshl_b64 s[10:11], s[30:31], 8
	s_set_vgpr_msb 0xcc08
	v_min_i64 v[0:1], s[2:3], s[14:15]
	s_lshl_b64 s[38:39], s[30:31], 7
	s_add_nc_u64 s[30:31], s[40:41], s[10:11]
	v_mul_u32_u24_e32 v3, 0x90, v2 /*v514*/
	s_add_nc_u64 s[26:27], s[22:23], 0x100
	s_and_b32 s22, s29, 0xffff
	s_lshr_b32 s29, s35, 6
	v_mul_u32_u24_e32 v2, 0x220, v4 /*v516*/
	s_set_vgpr_msb 0x8cb
	v_mad_u32 v17 /*v785*/, 0x4800, s29, v3
	v_dual_add_nc_u32 v16 /*v784*/, 0, v3 /*v515*/ :: v_dual_add_nc_u32 v8 /*v776*/, v15 /*v783*/, v3 /*v515*/
	s_max_i32 s3, s33, 0
	s_set_vgpr_msb 0xcbcc
	v_dual_add_nc_u32 v18 /*v786*/, 32, v15 /*v783*/ :: v_dual_add_nc_u32 v20 /*v788*/, 64, v15 /*v783*/
	v_dual_mov_b32 v0 /*v768*/, 1 :: v_dual_add_nc_u32 v19 /*v787*/, 0x60, v15 /*v783*/
	v_dual_add_nc_u32 v9 /*v777*/, 32, v8 /*v776*/ :: v_dual_add_nc_u32 v5 /*v773*/, 64, v8 /*v776*/
	v_add_nc_u32_e32 v6 /*v774*/, 0x60, v8 /*v776*/
	v_dual_add_nc_u32 v21 /*v789*/, 32, v17 /*v785*/ :: v_dual_add_nc_u32 v34 /*v802*/, 64, v17 /*v785*/
	v_add_nc_u32_e32 v22 /*v790*/, 0x900, v17 /*v785*/
	v_add_nc_u32_e32 v23 /*v791*/, 0x920, v17 /*v785*/
	v_add_nc_u32_e32 v24 /*v792*/, 0x1200, v17 /*v785*/
	v_add_nc_u32_e32 v25 /*v793*/, 0x1220, v17 /*v785*/
	v_add_nc_u32_e32 v26 /*v794*/, 0x1b00, v17 /*v785*/
	v_add_nc_u32_e32 v27 /*v795*/, 0x1b20, v17 /*v785*/
	v_add_nc_u32_e32 v28 /*v796*/, 0x2400, v17 /*v785*/
	v_add_nc_u32_e32 v29 /*v797*/, 0x2420, v17 /*v785*/
	v_add_nc_u32_e32 v30 /*v798*/, 0x2d00, v17 /*v785*/
	v_add_nc_u32_e32 v31 /*v799*/, 0x2d20, v17 /*v785*/
	v_add_nc_u32_e32 v32 /*v800*/, 0x3600, v17 /*v785*/
	v_add_nc_u32_e32 v33 /*v801*/, 0x3620, v17 /*v785*/
	v_add_nc_u32_e32 v35 /*v803*/, 0x60, v17 /*v785*/
	v_add_nc_u32_e32 v36 /*v804*/, 0x940, v17 /*v785*/
	v_add_nc_u32_e32 v37 /*v805*/, 0x960, v17 /*v785*/
	v_add_nc_u32_e32 v38 /*v806*/, 0x1240, v17 /*v785*/
	s_set_vgpr_msb 0xcc00
	v_lshlrev_b64_e32 v[0:1], 1, v[0:1]
	s_set_vgpr_msb 0xcc
	v_add_nc_u32_e32 v39 /*v807*/, 0x1260, v17 /*v785*/
	v_add_nc_u32_e32 v40 /*v808*/, 0x1b40, v17 /*v785*/
	v_add_nc_u32_e32 v41 /*v809*/, 0x1b60, v17 /*v785*/
	v_add_nc_u32_e32 v42 /*v810*/, 0x2440, v17 /*v785*/
	v_add_nc_u32_e32 v43 /*v811*/, 0x2460, v17 /*v785*/
	s_set_vgpr_msb 0xccc0
	v_add_nc_u64_e32 v[2:3] /*v[770:771]*/, s[30:31], v[0:1]
	s_set_vgpr_msb 0xc030
	v_add3_u32 v0, s2, s24, v10 /*v778*/
	s_set_vgpr_msb 0x30cc
	v_add_nc_u32_e32 v44 /*v812*/, 0x2d40, v17 /*v785*/
	v_add_nc_u32_e32 v45 /*v813*/, 0x2d60, v17 /*v785*/
	v_add_nc_u32_e32 v46 /*v814*/, 0x3640, v17 /*v785*/
	v_add_nc_u32_e32 v47 /*v815*/, 0x3660, v17 /*v785*/
	s_set_vgpr_msb 0xcc00
	v_subrev_nc_u32_e32 v0, s6, v0
	s_set_vgpr_msb 0xc0
	v_add_nc_u32_e32 v48 /*v816*/, 0xf6e0, v2
	v_add_nc_u32_e32 v50 /*v818*/, 0xd4e0, v2
	v_add_nc_u32_e32 v51 /*v819*/, 0xf6c0, v2
	v_add_nc_u32_e32 v52 /*v820*/, 0xd4c0, v2
	v_lshl_add_u32 v49 /*v817*/, v0, 1, 0
	s_set_vgpr_msb 0xc000
	v_mov_b32_e32 v0, 0
	s_set_vgpr_msb 0xc0
	v_add_nc_u32_e32 v53 /*v821*/, 0xf6a0, v2
	v_add_nc_u32_e32 v54 /*v822*/, 0xd4a0, v2
	v_add_nc_u32_e32 v55 /*v823*/, 0xf680, v2
	v_add_nc_u32_e32 v56 /*v824*/, 0xd480, v2
	v_add_nc_u32_e32 v57 /*v825*/, 0xf660, v2
	v_add_nc_u32_e32 v58 /*v826*/, 0xd460, v2
	v_add_nc_u32_e32 v59 /*v827*/, 0xf640, v2
	v_add_nc_u32_e32 v60 /*v828*/, 0xd440, v2
	v_add_nc_u32_e32 v61 /*v829*/, 0xf620, v2
	v_add_nc_u32_e32 v62 /*v830*/, 0xd420, v2
	v_add_nc_u32_e32 v63 /*v831*/, 0xf600, v2
	v_add_nc_u32_e32 v64 /*v832*/, 0xd400, v2
	v_add_nc_u32_e32 v65 /*v833*/, 0xb2e0, v2
	v_add_nc_u32_e32 v66 /*v834*/, 0x90e0, v2
	v_add_nc_u32_e32 v67 /*v835*/, 0xb2c0, v2
	v_add_nc_u32_e32 v68 /*v836*/, 0x90c0, v2
	v_add_nc_u32_e32 v69 /*v837*/, 0xb2a0, v2
	v_add_nc_u32_e32 v70 /*v838*/, 0x90a0, v2
	v_add_nc_u32_e32 v71 /*v839*/, 0xb280, v2
	v_add_nc_u32_e32 v72 /*v840*/, 0x9080, v2
	v_add_nc_u32_e32 v73 /*v841*/, 0xb260, v2
	v_add_nc_u32_e32 v74 /*v842*/, 0x9060, v2
	v_add_nc_u32_e32 v75 /*v843*/, 0xb240, v2
	v_add_nc_u32_e32 v76 /*v844*/, 0x9040, v2
	v_add_nc_u32_e32 v77 /*v845*/, 0xb220, v2
	v_add_nc_u32_e32 v78 /*v846*/, 0x9020, v2
	v_add_nc_u32_e32 v79 /*v847*/, 0xb200, v2
	s_set_vgpr_msb 0xc000
	v_dual_mov_b32 v1, v0 :: v_dual_mov_b32 v2, v0
	v_dual_mov_b32 v3, v0 :: v_dual_mov_b32 v4, v0
	v_dual_mov_b32 v5, v0 :: v_dual_mov_b32 v6, v0
	v_dual_mov_b32 v7, v0 :: v_dual_mov_b32 v8, v0
	v_dual_mov_b32 v9, v0 :: v_dual_mov_b32 v10, v0
	v_dual_mov_b32 v11, v0 :: v_dual_mov_b32 v12, v0
	v_dual_mov_b32 v13, v0 :: v_dual_mov_b32 v14, v0
	v_dual_mov_b32 v15, v0 :: v_dual_mov_b32 v16, v0
	v_dual_mov_b32 v17, v0 :: v_dual_mov_b32 v18, v0
	v_dual_mov_b32 v19, v0 :: v_dual_mov_b32 v20, v0
	v_dual_mov_b32 v21, v0 :: v_dual_mov_b32 v22, v0
	v_dual_mov_b32 v23, v0 :: v_dual_mov_b32 v32, v0
	v_dual_mov_b32 v33, v0 :: v_dual_mov_b32 v34, v0
	v_dual_mov_b32 v35, v0 :: v_dual_mov_b32 v36, v0
	v_dual_mov_b32 v37, v0 :: v_dual_mov_b32 v38, v0
	v_dual_mov_b32 v39, v0 :: v_dual_mov_b32 v40, v0
	v_dual_mov_b32 v41, v0 :: v_dual_mov_b32 v42, v0
	v_dual_mov_b32 v43, v0 :: v_dual_mov_b32 v44, v0
	v_dual_mov_b32 v45, v0 :: v_dual_mov_b32 v46, v0
	v_dual_mov_b32 v47, v0 :: v_dual_mov_b32 v48, v0
	v_dual_mov_b32 v49, v0 :: v_dual_mov_b32 v50, v0
	v_dual_mov_b32 v51, v0 :: v_dual_mov_b32 v52, v0
	v_dual_mov_b32 v53, v0 :: v_dual_mov_b32 v54, v0
	v_dual_mov_b32 v55, v0 :: v_dual_mov_b32 v64, v0
	v_dual_mov_b32 v65, v0 :: v_dual_mov_b32 v66, v0
	v_dual_mov_b32 v67, v0 :: v_dual_mov_b32 v68, v0
	v_dual_mov_b32 v69, v0 :: v_dual_mov_b32 v70, v0
	v_dual_mov_b32 v71, v0 :: v_dual_mov_b32 v72, v0
	v_dual_mov_b32 v73, v0 :: v_dual_mov_b32 v74, v0
	v_dual_mov_b32 v75, v0 :: v_dual_mov_b32 v76, v0
	v_dual_mov_b32 v77, v0 :: v_dual_mov_b32 v78, v0
	v_dual_mov_b32 v79, v0 :: v_dual_mov_b32 v24, v0
	v_dual_mov_b32 v25, v0 :: v_dual_mov_b32 v26, v0
	v_dual_mov_b32 v27, v0 :: v_dual_mov_b32 v28, v0
	v_dual_mov_b32 v29, v0 :: v_dual_mov_b32 v30, v0
	v_dual_mov_b32 v31, v0 :: v_dual_mov_b32 v56, v0
	v_dual_mov_b32 v57, v0 :: v_dual_mov_b32 v58, v0
	v_dual_mov_b32 v59, v0 :: v_dual_mov_b32 v60, v0
	v_dual_mov_b32 v61, v0 :: v_dual_mov_b32 v62, v0
	v_dual_mov_b32 v63, v0 :: v_dual_mov_b32 v80, v0
	v_dual_mov_b32 v81, v0 :: v_dual_mov_b32 v82, v0
	v_dual_mov_b32 v83, v0 :: v_dual_mov_b32 v84, v0
	v_dual_mov_b32 v85, v0 :: v_dual_mov_b32 v86, v0
	v_dual_mov_b32 v87, v0 :: v_dual_mov_b32 v112, v0
	v_dual_mov_b32 v113, v0 :: v_dual_mov_b32 v114, v0
	v_dual_mov_b32 v115, v0 :: v_dual_mov_b32 v116, v0
	v_dual_mov_b32 v117, v0 :: v_dual_mov_b32 v118, v0
	v_dual_mov_b32 v119, v0 :: v_dual_mov_b32 v152, v0
	v_dual_mov_b32 v153, v0 :: v_dual_mov_b32 v154, v0
	v_dual_mov_b32 v155, v0 :: v_dual_mov_b32 v156, v0
	v_dual_mov_b32 v157, v0 :: v_dual_mov_b32 v158, v0
	v_dual_mov_b32 v159, v0 :: v_dual_mov_b32 v168, v0
	v_dual_mov_b32 v169, v0 :: v_dual_mov_b32 v170, v0
	v_dual_mov_b32 v171, v0 :: v_dual_mov_b32 v172, v0
	v_dual_mov_b32 v173, v0 :: v_dual_mov_b32 v174, v0
	v_dual_mov_b32 v175, v0 :: v_dual_mov_b32 v192, v0
	v_dual_mov_b32 v193, v0 :: v_dual_mov_b32 v194, v0
	v_dual_mov_b32 v195, v0 :: v_dual_mov_b32 v196, v0
	v_dual_mov_b32 v197, v0 :: v_dual_mov_b32 v198, v0
	v_dual_mov_b32 v199, v0 :: v_dual_mov_b32 v224, v0
	v_dual_mov_b32 v225, v0 :: v_dual_mov_b32 v226, v0
	v_dual_mov_b32 v227, v0 :: v_dual_mov_b32 v228, v0
	v_dual_mov_b32 v229, v0 :: v_dual_mov_b32 v230, v0
	v_dual_mov_b32 v231, v0 :: v_dual_mov_b32 v176, v0
	v_dual_mov_b32 v177, v0 :: v_dual_mov_b32 v178, v0
	v_dual_mov_b32 v179, v0 :: v_dual_mov_b32 v180, v0
	v_dual_mov_b32 v181, v0 :: v_dual_mov_b32 v182, v0
	v_dual_mov_b32 v183, v0 :: v_dual_mov_b32 v184, v0
	v_dual_mov_b32 v185, v0 :: v_dual_mov_b32 v186, v0
	v_dual_mov_b32 v187, v0 :: v_dual_mov_b32 v188, v0
	v_dual_mov_b32 v189, v0 :: v_dual_mov_b32 v190, v0
	v_dual_mov_b32 v191, v0 :: v_dual_mov_b32 v200, v0
	v_dual_mov_b32 v201, v0 :: v_dual_mov_b32 v202, v0
	v_dual_mov_b32 v203, v0 :: v_dual_mov_b32 v204, v0
	v_dual_mov_b32 v205, v0 :: v_dual_mov_b32 v206, v0
	v_dual_mov_b32 v207, v0 :: v_dual_mov_b32 v208, v0
	v_dual_mov_b32 v209, v0 :: v_dual_mov_b32 v210, v0
	v_dual_mov_b32 v211, v0 :: v_dual_mov_b32 v212, v0
	v_dual_mov_b32 v213, v0 :: v_dual_mov_b32 v214, v0
	v_dual_mov_b32 v215, v0 :: v_dual_mov_b32 v216, v0
	v_dual_mov_b32 v217, v0 :: v_dual_mov_b32 v218, v0
	v_dual_mov_b32 v219, v0 :: v_dual_mov_b32 v220, v0
	v_dual_mov_b32 v221, v0 :: v_dual_mov_b32 v222, v0
	v_mov_b32_e32 v223, v0
	s_set_vgpr_msb 64
	v_dual_mov_b32 v38 /*v294*/, v0 :: v_dual_mov_b32 v37 /*v293*/, v0
	v_dual_mov_b32 v36 /*v292*/, v0 :: v_dual_mov_b32 v35 /*v291*/, v0
	v_dual_mov_b32 v34 /*v290*/, v0 :: v_dual_mov_b32 v33 /*v289*/, v0
	v_dual_mov_b32 v32 /*v288*/, v0 :: v_dual_mov_b32 v31 /*v287*/, v0
	v_dual_mov_b32 v30 /*v286*/, v0 :: v_dual_mov_b32 v29 /*v285*/, v0
	v_dual_mov_b32 v28 /*v284*/, v0 :: v_dual_mov_b32 v27 /*v283*/, v0
	v_dual_mov_b32 v26 /*v282*/, v0 :: v_dual_mov_b32 v25 /*v281*/, v0
	v_dual_mov_b32 v24 /*v280*/, v0 :: v_dual_mov_b32 v23 /*v279*/, v0
	v_dual_mov_b32 v22 /*v278*/, v0 :: v_dual_mov_b32 v21 /*v277*/, v0
	v_dual_mov_b32 v20 /*v276*/, v0 :: v_dual_mov_b32 v19 /*v275*/, v0
	v_dual_mov_b32 v18 /*v274*/, v0 :: v_dual_mov_b32 v17 /*v273*/, v0
	v_dual_mov_b32 v16 /*v272*/, v0 :: v_dual_mov_b32 v15 /*v271*/, v0
	v_dual_mov_b32 v14 /*v270*/, v0 :: v_dual_mov_b32 v13 /*v269*/, v0
	v_dual_mov_b32 v12 /*v268*/, v0 :: v_dual_mov_b32 v11 /*v267*/, v0
	v_dual_mov_b32 v10 /*v266*/, v0 :: v_dual_mov_b32 v9 /*v265*/, v0
	v_dual_mov_b32 v8 /*v264*/, v0 :: v_dual_mov_b32 v7 /*v263*/, v0
	v_dual_mov_b32 v6 /*v262*/, v0 :: v_dual_mov_b32 v5 /*v261*/, v0
	v_dual_mov_b32 v4 /*v260*/, v0 :: v_dual_mov_b32 v3 /*v259*/, v0
	v_dual_mov_b32 v2 /*v258*/, v0 :: v_dual_mov_b32 v1 /*v257*/, v0
	v_dual_mov_b32 v0 /*v256*/, v0 :: v_dual_mov_b32 v47 /*v303*/, v0
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v255, v0 :: v_dual_mov_b32 v254, v0
	v_dual_mov_b32 v253, v0 :: v_dual_mov_b32 v252, v0
	v_dual_mov_b32 v251, v0 :: v_dual_mov_b32 v250, v0
	v_dual_mov_b32 v249, v0 :: v_dual_mov_b32 v248, v0
	v_dual_mov_b32 v247, v0 :: v_dual_mov_b32 v246, v0
	v_dual_mov_b32 v245, v0 :: v_dual_mov_b32 v244, v0
	v_dual_mov_b32 v243, v0 :: v_dual_mov_b32 v242, v0
	v_dual_mov_b32 v241, v0 :: v_dual_mov_b32 v240, v0
	v_dual_mov_b32 v239, v0 :: v_dual_mov_b32 v238, v0
	v_dual_mov_b32 v237, v0 :: v_dual_mov_b32 v236, v0
	v_dual_mov_b32 v235, v0 :: v_dual_mov_b32 v234, v0
	v_dual_mov_b32 v233, v0 :: v_dual_mov_b32 v232, v0
	v_mov_b32_e32 v88, v0
	s_set_vgpr_msb 64
	v_dual_mov_b32 v46 /*v302*/, v0 :: v_dual_mov_b32 v45 /*v301*/, v0
	v_dual_mov_b32 v44 /*v300*/, v0 :: v_dual_mov_b32 v43 /*v299*/, v0
	v_dual_mov_b32 v42 /*v298*/, v0 :: v_dual_mov_b32 v41 /*v297*/, v0
	v_dual_mov_b32 v40 /*v296*/, v0 :: v_dual_mov_b32 v55 /*v311*/, v0
	v_dual_mov_b32 v54 /*v310*/, v0 :: v_dual_mov_b32 v53 /*v309*/, v0
	v_dual_mov_b32 v52 /*v308*/, v0 :: v_dual_mov_b32 v51 /*v307*/, v0
	v_dual_mov_b32 v50 /*v306*/, v0 :: v_dual_mov_b32 v49 /*v305*/, v0
	v_dual_mov_b32 v48 /*v304*/, v0 :: v_dual_mov_b32 v63 /*v319*/, v0
	v_dual_mov_b32 v62 /*v318*/, v0 :: v_dual_mov_b32 v61 /*v317*/, v0
	v_dual_mov_b32 v60 /*v316*/, v0 :: v_dual_mov_b32 v59 /*v315*/, v0
	v_dual_mov_b32 v58 /*v314*/, v0 :: v_dual_mov_b32 v57 /*v313*/, v0
	v_dual_mov_b32 v56 /*v312*/, v0 :: v_dual_mov_b32 v39 /*v295*/, v0
	v_dual_mov_b32 v64 /*v320*/, v0 :: v_dual_mov_b32 v65 /*v321*/, v0
	v_dual_mov_b32 v66 /*v322*/, v0 :: v_dual_mov_b32 v67 /*v323*/, v0
	v_dual_mov_b32 v68 /*v324*/, v0 :: v_dual_mov_b32 v69 /*v325*/, v0
	v_dual_mov_b32 v70 /*v326*/, v0 :: v_dual_mov_b32 v71 /*v327*/, v0
	v_dual_mov_b32 v72 /*v328*/, v0 :: v_dual_mov_b32 v73 /*v329*/, v0
	v_dual_mov_b32 v74 /*v330*/, v0 :: v_dual_mov_b32 v75 /*v331*/, v0
	v_dual_mov_b32 v76 /*v332*/, v0 :: v_dual_mov_b32 v77 /*v333*/, v0
	v_dual_mov_b32 v78 /*v334*/, v0 :: v_dual_mov_b32 v79 /*v335*/, v0
	v_dual_mov_b32 v80 /*v336*/, v0 :: v_dual_mov_b32 v81 /*v337*/, v0
	v_dual_mov_b32 v82 /*v338*/, v0 :: v_dual_mov_b32 v83 /*v339*/, v0
	v_dual_mov_b32 v84 /*v340*/, v0 :: v_dual_mov_b32 v85 /*v341*/, v0
	v_dual_mov_b32 v86 /*v342*/, v0 :: v_dual_mov_b32 v87 /*v343*/, v0
	v_dual_mov_b32 v96 /*v352*/, v0 :: v_dual_mov_b32 v97 /*v353*/, v0
	v_dual_mov_b32 v98 /*v354*/, v0 :: v_dual_mov_b32 v99 /*v355*/, v0
	v_dual_mov_b32 v100 /*v356*/, v0 :: v_dual_mov_b32 v101 /*v357*/, v0
	v_dual_mov_b32 v102 /*v358*/, v0 :: v_dual_mov_b32 v103 /*v359*/, v0
	v_dual_mov_b32 v104 /*v360*/, v0 :: v_dual_mov_b32 v105 /*v361*/, v0
	v_dual_mov_b32 v106 /*v362*/, v0 :: v_dual_mov_b32 v107 /*v363*/, v0
	v_dual_mov_b32 v108 /*v364*/, v0 :: v_dual_mov_b32 v109 /*v365*/, v0
	v_dual_mov_b32 v110 /*v366*/, v0 :: v_dual_mov_b32 v111 /*v367*/, v0
	v_dual_mov_b32 v112 /*v368*/, v0 :: v_dual_mov_b32 v113 /*v369*/, v0
	v_dual_mov_b32 v114 /*v370*/, v0 :: v_dual_mov_b32 v115 /*v371*/, v0
	v_dual_mov_b32 v116 /*v372*/, v0 :: v_dual_mov_b32 v117 /*v373*/, v0
	v_dual_mov_b32 v118 /*v374*/, v0 :: v_dual_mov_b32 v119 /*v375*/, v0
	v_dual_mov_b32 v128 /*v384*/, v0 :: v_dual_mov_b32 v129 /*v385*/, v0
	v_dual_mov_b32 v130 /*v386*/, v0 :: v_dual_mov_b32 v131 /*v387*/, v0
	v_dual_mov_b32 v132 /*v388*/, v0 :: v_dual_mov_b32 v133 /*v389*/, v0
	v_dual_mov_b32 v134 /*v390*/, v0 :: v_dual_mov_b32 v135 /*v391*/, v0
	v_dual_mov_b32 v136 /*v392*/, v0 :: v_dual_mov_b32 v137 /*v393*/, v0
	v_dual_mov_b32 v138 /*v394*/, v0 :: v_dual_mov_b32 v139 /*v395*/, v0
	v_dual_mov_b32 v140 /*v396*/, v0 :: v_dual_mov_b32 v141 /*v397*/, v0
	v_dual_mov_b32 v142 /*v398*/, v0 :: v_dual_mov_b32 v143 /*v399*/, v0
	v_dual_mov_b32 v88 /*v344*/, v0 :: v_dual_mov_b32 v89 /*v345*/, v0
	v_dual_mov_b32 v90 /*v346*/, v0 :: v_dual_mov_b32 v91 /*v347*/, v0
	v_dual_mov_b32 v92 /*v348*/, v0 :: v_dual_mov_b32 v93 /*v349*/, v0
	v_dual_mov_b32 v94 /*v350*/, v0 :: v_dual_mov_b32 v95 /*v351*/, v0
	v_dual_mov_b32 v120 /*v376*/, v0 :: v_dual_mov_b32 v121 /*v377*/, v0
	v_dual_mov_b32 v122 /*v378*/, v0 :: v_dual_mov_b32 v123 /*v379*/, v0
	v_dual_mov_b32 v124 /*v380*/, v0 :: v_dual_mov_b32 v125 /*v381*/, v0
	v_dual_mov_b32 v126 /*v382*/, v0 :: v_dual_mov_b32 v127 /*v383*/, v0
	v_dual_mov_b32 v144 /*v400*/, v0 :: v_dual_mov_b32 v145 /*v401*/, v0
	v_dual_mov_b32 v146 /*v402*/, v0 :: v_dual_mov_b32 v147 /*v403*/, v0
	v_dual_mov_b32 v148 /*v404*/, v0 :: v_dual_mov_b32 v149 /*v405*/, v0
	v_dual_mov_b32 v150 /*v406*/, v0 :: v_dual_mov_b32 v151 /*v407*/, v0
	v_dual_mov_b32 v152 /*v408*/, v0 :: v_dual_mov_b32 v153 /*v409*/, v0
	v_dual_mov_b32 v154 /*v410*/, v0 :: v_dual_mov_b32 v155 /*v411*/, v0
	v_dual_mov_b32 v156 /*v412*/, v0 :: v_dual_mov_b32 v157 /*v413*/, v0
	v_dual_mov_b32 v158 /*v414*/, v0 :: v_dual_mov_b32 v159 /*v415*/, v0
	v_dual_mov_b32 v160 /*v416*/, v0 :: v_dual_mov_b32 v161 /*v417*/, v0
	v_dual_mov_b32 v162 /*v418*/, v0 :: v_dual_mov_b32 v163 /*v419*/, v0
	v_dual_mov_b32 v164 /*v420*/, v0 :: v_dual_mov_b32 v165 /*v421*/, v0
	v_dual_mov_b32 v166 /*v422*/, v0 :: v_dual_mov_b32 v167 /*v423*/, v0
	v_dual_mov_b32 v168 /*v424*/, v0 :: v_dual_mov_b32 v169 /*v425*/, v0
	v_dual_mov_b32 v170 /*v426*/, v0 :: v_dual_mov_b32 v171 /*v427*/, v0
	v_dual_mov_b32 v172 /*v428*/, v0 :: v_dual_mov_b32 v173 /*v429*/, v0
	v_dual_mov_b32 v174 /*v430*/, v0 :: v_dual_mov_b32 v175 /*v431*/, v0
	v_dual_mov_b32 v192 /*v448*/, v0 :: v_dual_mov_b32 v193 /*v449*/, v0
	v_dual_mov_b32 v194 /*v450*/, v0 :: v_dual_mov_b32 v195 /*v451*/, v0
	v_dual_mov_b32 v196 /*v452*/, v0 :: v_dual_mov_b32 v197 /*v453*/, v0
	v_dual_mov_b32 v198 /*v454*/, v0 :: v_dual_mov_b32 v199 /*v455*/, v0
	v_dual_mov_b32 v224 /*v480*/, v0 :: v_dual_mov_b32 v225 /*v481*/, v0
	v_dual_mov_b32 v226 /*v482*/, v0 :: v_dual_mov_b32 v227 /*v483*/, v0
	v_dual_mov_b32 v228 /*v484*/, v0 :: v_dual_mov_b32 v229 /*v485*/, v0
	v_dual_mov_b32 v230 /*v486*/, v0 :: v_dual_mov_b32 v231 /*v487*/, v0
	v_dual_mov_b32 v176 /*v432*/, v0 :: v_dual_mov_b32 v177 /*v433*/, v0
	v_dual_mov_b32 v178 /*v434*/, v0 :: v_dual_mov_b32 v179 /*v435*/, v0
	v_dual_mov_b32 v180 /*v436*/, v0 :: v_dual_mov_b32 v181 /*v437*/, v0
	v_dual_mov_b32 v182 /*v438*/, v0 :: v_dual_mov_b32 v183 /*v439*/, v0
	v_dual_mov_b32 v184 /*v440*/, v0 :: v_dual_mov_b32 v185 /*v441*/, v0
	v_dual_mov_b32 v186 /*v442*/, v0 :: v_dual_mov_b32 v187 /*v443*/, v0
	v_dual_mov_b32 v188 /*v444*/, v0 :: v_dual_mov_b32 v189 /*v445*/, v0
	v_dual_mov_b32 v190 /*v446*/, v0 :: v_dual_mov_b32 v191 /*v447*/, v0
	v_dual_mov_b32 v200 /*v456*/, v0 :: v_dual_mov_b32 v201 /*v457*/, v0
	v_dual_mov_b32 v202 /*v458*/, v0 :: v_dual_mov_b32 v203 /*v459*/, v0
	v_dual_mov_b32 v204 /*v460*/, v0 :: v_dual_mov_b32 v205 /*v461*/, v0
	v_dual_mov_b32 v206 /*v462*/, v0 :: v_dual_mov_b32 v207 /*v463*/, v0
	v_dual_mov_b32 v208 /*v464*/, v0 :: v_dual_mov_b32 v209 /*v465*/, v0
	v_dual_mov_b32 v210 /*v466*/, v0 :: v_dual_mov_b32 v211 /*v467*/, v0
	v_dual_mov_b32 v212 /*v468*/, v0 :: v_dual_mov_b32 v213 /*v469*/, v0
	v_dual_mov_b32 v214 /*v470*/, v0 :: v_dual_mov_b32 v215 /*v471*/, v0
	v_dual_mov_b32 v216 /*v472*/, v0 :: v_dual_mov_b32 v217 /*v473*/, v0
	v_dual_mov_b32 v218 /*v474*/, v0 :: v_dual_mov_b32 v219 /*v475*/, v0
	v_dual_mov_b32 v220 /*v476*/, v0 :: v_dual_mov_b32 v221 /*v477*/, v0
	v_dual_mov_b32 v222 /*v478*/, v0 :: v_dual_mov_b32 v223 /*v479*/, v0
	v_dual_mov_b32 v232 /*v488*/, v0 :: v_dual_mov_b32 v233 /*v489*/, v0
	v_dual_mov_b32 v234 /*v490*/, v0 :: v_dual_mov_b32 v235 /*v491*/, v0
	v_dual_mov_b32 v236 /*v492*/, v0 :: v_dual_mov_b32 v237 /*v493*/, v0
	v_dual_mov_b32 v238 /*v494*/, v0 :: v_dual_mov_b32 v239 /*v495*/, v0
	v_dual_mov_b32 v240 /*v496*/, v0 :: v_dual_mov_b32 v241 /*v497*/, v0
	v_dual_mov_b32 v242 /*v498*/, v0 :: v_dual_mov_b32 v243 /*v499*/, v0
	v_dual_mov_b32 v244 /*v500*/, v0 :: v_dual_mov_b32 v245 /*v501*/, v0
	v_dual_mov_b32 v246 /*v502*/, v0 :: v_dual_mov_b32 v247 /*v503*/, v0
	v_dual_mov_b32 v248 /*v504*/, v0 :: v_dual_mov_b32 v249 /*v505*/, v0
	v_dual_mov_b32 v250 /*v506*/, v0 :: v_dual_mov_b32 v251 /*v507*/, v0
	v_dual_mov_b32 v252 /*v508*/, v0 :: v_dual_mov_b32 v253 /*v509*/, v0
	v_dual_mov_b32 v254 /*v510*/, v0 :: v_dual_mov_b32 v255 /*v511*/, v0
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v89, v0 :: v_dual_mov_b32 v90, v0
	v_dual_mov_b32 v91, v0 :: v_dual_mov_b32 v92, v0
	v_dual_mov_b32 v93, v0 :: v_dual_mov_b32 v94, v0
	v_dual_mov_b32 v95, v0 :: v_dual_mov_b32 v96, v0
	v_dual_mov_b32 v97, v0 :: v_dual_mov_b32 v98, v0
	v_dual_mov_b32 v99, v0 :: v_dual_mov_b32 v100, v0
	v_dual_mov_b32 v101, v0 :: v_dual_mov_b32 v102, v0
	v_dual_mov_b32 v103, v0 :: v_dual_mov_b32 v104, v0
	v_dual_mov_b32 v105, v0 :: v_dual_mov_b32 v106, v0
	v_dual_mov_b32 v107, v0 :: v_dual_mov_b32 v108, v0
	v_dual_mov_b32 v109, v0 :: v_dual_mov_b32 v110, v0
	v_dual_mov_b32 v111, v0 :: v_dual_mov_b32 v120, v0
	v_dual_mov_b32 v121, v0 :: v_dual_mov_b32 v122, v0
	v_dual_mov_b32 v123, v0 :: v_dual_mov_b32 v124, v0
	v_dual_mov_b32 v125, v0 :: v_dual_mov_b32 v126, v0
	v_dual_mov_b32 v127, v0 :: v_dual_mov_b32 v128, v0
	v_dual_mov_b32 v129, v0 :: v_dual_mov_b32 v130, v0
	v_dual_mov_b32 v131, v0 :: v_dual_mov_b32 v132, v0
	v_dual_mov_b32 v133, v0 :: v_dual_mov_b32 v134, v0
	v_dual_mov_b32 v135, v0 :: v_dual_mov_b32 v136, v0
	v_dual_mov_b32 v137, v0 :: v_dual_mov_b32 v138, v0
	v_dual_mov_b32 v139, v0 :: v_dual_mov_b32 v140, v0
	v_dual_mov_b32 v141, v0 :: v_dual_mov_b32 v142, v0
	v_dual_mov_b32 v143, v0 :: v_dual_mov_b32 v144, v0
	v_dual_mov_b32 v145, v0 :: v_dual_mov_b32 v146, v0
	v_dual_mov_b32 v147, v0 :: v_dual_mov_b32 v148, v0
	v_dual_mov_b32 v149, v0 :: v_dual_mov_b32 v150, v0
	v_dual_mov_b32 v151, v0 :: v_dual_mov_b32 v160, v0
	v_dual_mov_b32 v161, v0 :: v_dual_mov_b32 v162, v0
	v_dual_mov_b32 v163, v0 :: v_dual_mov_b32 v164, v0
	v_dual_mov_b32 v165, v0 :: v_dual_mov_b32 v166, v0
	v_mov_b32_e32 v167, v0
	s_mov_b32 s15, 0
	s_brev_b32 s17, 64
	s_lshl_b32 s35, s3, 16
	s_lshr_b32 s3, s3, 16
	s_mov_b32 s20, 64
	s_movk_i32 s12, 0x100
	s_mov_b32 s9, 0xffff0000
	s_mov_b32 s8, 0x7300000
	s_mov_b32 s18, 0x400000
	s_mov_b32 s16, 0xfb00000
	s_mov_b32 s21, s28
	s_mov_b32 s28, 1
	s_mov_b32 s19, s17
	s_mov_b32 s23, s15
	s_and_b32 s14, s43, 0xffff
	s_or_b32 s10, s35, 0x7fff
	s_or_b32 s11, s3, 0x800000
	s_mov_b32 s3, 2
	s_mov_b32 s35, s15
	s_mov_b32 s40, s7
	s_mov_b32 s41, s15
	s_branch .LBB0_14
.LBB0_13:
	s_set_vgpr_msb 10
	s_wait_dscnt 0x14
	v_wmma_f32_16x16x32_bf16 v[0:7], v[96:103] /*v[608:615]*/, v[248:255] /*v[760:767]*/, v[0:7]
	s_wait_dscnt 0x0
	v_wmma_f32_16x16x32_bf16 v[8:15], v[136:143] /*v[648:655]*/, v[248:255] /*v[760:767]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[160:167] /*v[672:679]*/, v[248:255] /*v[760:767]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[176:183] /*v[688:695]*/, v[248:255] /*v[760:767]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[192:199] /*v[704:711]*/, v[248:255] /*v[760:767]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[208:215] /*v[720:727]*/, v[248:255] /*v[760:767]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[216:223] /*v[728:735]*/, v[248:255] /*v[760:767]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[240:247] /*v[752:759]*/, v[248:255] /*v[760:767]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[224:231], v[240:247] /*v[752:759]*/, v[232:239] /*v[744:751]*/, v[224:231]
	v_wmma_f32_16x16x32_bf16 v[192:199], v[216:223] /*v[728:735]*/, v[232:239] /*v[744:751]*/, v[192:199]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[208:215] /*v[720:727]*/, v[232:239] /*v[744:751]*/, v[168:175]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[192:199] /*v[704:711]*/, v[232:239] /*v[744:751]*/, v[152:159]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[176:183] /*v[688:695]*/, v[232:239] /*v[744:751]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[160:167] /*v[672:679]*/, v[232:239] /*v[744:751]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[136:143] /*v[648:655]*/, v[232:239] /*v[744:751]*/, v[56:63]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[96:103] /*v[608:615]*/, v[232:239] /*v[744:751]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[96:103] /*v[608:615]*/, v[224:231] /*v[736:743]*/, v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[136:143] /*v[648:655]*/, v[224:231] /*v[736:743]*/, v[184:191]
	v_wmma_f32_16x16x32_bf16 v[200:207], v[160:167] /*v[672:679]*/, v[224:231] /*v[736:743]*/, v[200:207]
	v_wmma_f32_16x16x32_bf16 v[208:215], v[176:183] /*v[688:695]*/, v[224:231] /*v[736:743]*/, v[208:215]
	v_wmma_f32_16x16x32_bf16 v[216:223], v[192:199] /*v[704:711]*/, v[224:231] /*v[736:743]*/, v[216:223]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[56:63] /*v[312:319]*/, v[208:215] /*v[720:727]*/, v[224:231] /*v[736:743]*/, v[56:63] /*v[312:319]*/
	v_wmma_f32_16x16x32_bf16 v[48:55] /*v[304:311]*/, v[216:223] /*v[728:735]*/, v[224:231] /*v[736:743]*/, v[48:55] /*v[304:311]*/
	v_wmma_f32_16x16x32_bf16 v[40:47] /*v[296:303]*/, v[240:247] /*v[752:759]*/, v[224:231] /*v[736:743]*/, v[40:47] /*v[296:303]*/
	v_wmma_f32_16x16x32_bf16 v[32:39] /*v[288:295]*/, v[240:247] /*v[752:759]*/, v[200:207] /*v[712:719]*/, v[32:39] /*v[288:295]*/
	v_wmma_f32_16x16x32_bf16 v[24:31] /*v[280:287]*/, v[216:223] /*v[728:735]*/, v[200:207] /*v[712:719]*/, v[24:31] /*v[280:287]*/
	v_wmma_f32_16x16x32_bf16 v[16:23] /*v[272:279]*/, v[208:215] /*v[720:727]*/, v[200:207] /*v[712:719]*/, v[16:23] /*v[272:279]*/
	v_wmma_f32_16x16x32_bf16 v[8:15] /*v[264:271]*/, v[192:199] /*v[704:711]*/, v[200:207] /*v[712:719]*/, v[8:15] /*v[264:271]*/
	v_wmma_f32_16x16x32_bf16 v[0:7] /*v[256:263]*/, v[176:183] /*v[688:695]*/, v[200:207] /*v[712:719]*/, v[0:7] /*v[256:263]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[248:255], v[160:167] /*v[672:679]*/, v[200:207] /*v[712:719]*/, v[248:255]
	v_wmma_f32_16x16x32_bf16 v[240:247], v[136:143] /*v[648:655]*/, v[200:207] /*v[712:719]*/, v[240:247]
	v_wmma_f32_16x16x32_bf16 v[232:239], v[96:103] /*v[608:615]*/, v[200:207] /*v[712:719]*/, v[232:239]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[64:71] /*v[320:327]*/, v[96:103] /*v[608:615]*/, v[184:191] /*v[696:703]*/, v[64:71] /*v[320:327]*/
	v_wmma_f32_16x16x32_bf16 v[72:79] /*v[328:335]*/, v[136:143] /*v[648:655]*/, v[184:191] /*v[696:703]*/, v[72:79] /*v[328:335]*/
	v_wmma_f32_16x16x32_bf16 v[80:87] /*v[336:343]*/, v[160:167] /*v[672:679]*/, v[184:191] /*v[696:703]*/, v[80:87] /*v[336:343]*/
	v_wmma_f32_16x16x32_bf16 v[96:103] /*v[352:359]*/, v[176:183] /*v[688:695]*/, v[184:191] /*v[696:703]*/, v[96:103] /*v[352:359]*/
	v_wmma_f32_16x16x32_bf16 v[104:111] /*v[360:367]*/, v[192:199] /*v[704:711]*/, v[184:191] /*v[696:703]*/, v[104:111] /*v[360:367]*/
	v_wmma_f32_16x16x32_bf16 v[112:119] /*v[368:375]*/, v[208:215] /*v[720:727]*/, v[184:191] /*v[696:703]*/, v[112:119] /*v[368:375]*/
	v_wmma_f32_16x16x32_bf16 v[128:135] /*v[384:391]*/, v[216:223] /*v[728:735]*/, v[184:191] /*v[696:703]*/, v[128:135] /*v[384:391]*/
	v_wmma_f32_16x16x32_bf16 v[136:143] /*v[392:399]*/, v[240:247] /*v[752:759]*/, v[184:191] /*v[696:703]*/, v[136:143] /*v[392:399]*/
	v_wmma_f32_16x16x32_bf16 v[224:231] /*v[480:487]*/, v[240:247] /*v[752:759]*/, v[152:159] /*v[664:671]*/, v[224:231] /*v[480:487]*/
	v_wmma_f32_16x16x32_bf16 v[192:199] /*v[448:455]*/, v[216:223] /*v[728:735]*/, v[152:159] /*v[664:671]*/, v[192:199] /*v[448:455]*/
	v_wmma_f32_16x16x32_bf16 v[168:175] /*v[424:431]*/, v[208:215] /*v[720:727]*/, v[152:159] /*v[664:671]*/, v[168:175] /*v[424:431]*/
	v_wmma_f32_16x16x32_bf16 v[160:167] /*v[416:423]*/, v[192:199] /*v[704:711]*/, v[152:159] /*v[664:671]*/, v[160:167] /*v[416:423]*/
	v_wmma_f32_16x16x32_bf16 v[152:159] /*v[408:415]*/, v[176:183] /*v[688:695]*/, v[152:159] /*v[664:671]*/, v[152:159] /*v[408:415]*/
	v_wmma_f32_16x16x32_bf16 v[144:151] /*v[400:407]*/, v[160:167] /*v[672:679]*/, v[152:159] /*v[664:671]*/, v[144:151] /*v[400:407]*/
	v_wmma_f32_16x16x32_bf16 v[120:127] /*v[376:383]*/, v[136:143] /*v[648:655]*/, v[152:159] /*v[664:671]*/, v[120:127] /*v[376:383]*/
	v_wmma_f32_16x16x32_bf16 v[88:95] /*v[344:351]*/, v[96:103] /*v[608:615]*/, v[152:159] /*v[664:671]*/, v[88:95] /*v[344:351]*/
	v_wmma_f32_16x16x32_bf16 v[176:183] /*v[432:439]*/, v[96:103] /*v[608:615]*/, v[120:127] /*v[632:639]*/, v[176:183] /*v[432:439]*/
	v_wmma_f32_16x16x32_bf16 v[184:191] /*v[440:447]*/, v[136:143] /*v[648:655]*/, v[120:127] /*v[632:639]*/, v[184:191] /*v[440:447]*/
	v_wmma_f32_16x16x32_bf16 v[200:207] /*v[456:463]*/, v[160:167] /*v[672:679]*/, v[120:127] /*v[632:639]*/, v[200:207] /*v[456:463]*/
	v_wmma_f32_16x16x32_bf16 v[208:215] /*v[464:471]*/, v[176:183] /*v[688:695]*/, v[120:127] /*v[632:639]*/, v[208:215] /*v[464:471]*/
	v_wmma_f32_16x16x32_bf16 v[216:223] /*v[472:479]*/, v[192:199] /*v[704:711]*/, v[120:127] /*v[632:639]*/, v[216:223] /*v[472:479]*/
	v_wmma_f32_16x16x32_bf16 v[232:239] /*v[488:495]*/, v[208:215] /*v[720:727]*/, v[120:127] /*v[632:639]*/, v[232:239] /*v[488:495]*/
	v_wmma_f32_16x16x32_bf16 v[240:247] /*v[496:503]*/, v[216:223] /*v[728:735]*/, v[120:127] /*v[632:639]*/, v[240:247] /*v[496:503]*/
	v_wmma_f32_16x16x32_bf16 v[248:255] /*v[504:511]*/, v[240:247] /*v[752:759]*/, v[120:127] /*v[632:639]*/, v[248:255] /*v[504:511]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[160:167], v[240:247] /*v[752:759]*/, v[88:95] /*v[600:607]*/, v[160:167]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[216:223] /*v[728:735]*/, v[88:95] /*v[600:607]*/, v[144:151]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[208:215] /*v[720:727]*/, v[88:95] /*v[600:607]*/, v[136:143]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[192:199] /*v[704:711]*/, v[88:95] /*v[600:607]*/, v[128:135]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[176:183] /*v[688:695]*/, v[88:95] /*v[600:607]*/, v[120:127]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[160:167] /*v[672:679]*/, v[88:95] /*v[600:607]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[136:143] /*v[648:655]*/, v[88:95] /*v[600:607]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[96:103] /*v[608:615]*/, v[88:95] /*v[600:607]*/, v[88:95]
	s_wait_tensorcnt 0x1
	s_barrier_signal -1
	v_wmma_f32_16x16x32_bf16 v[0:7], v[8:15] /*v[520:527]*/, v[168:175] /*v[680:687]*/, v[0:7]
	v_wmma_f32_16x16x32_bf16 v[8:15], v[24:31] /*v[536:543]*/, v[168:175] /*v[680:687]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[40:47] /*v[552:559]*/, v[168:175] /*v[680:687]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[48:55] /*v[560:567]*/, v[168:175] /*v[680:687]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[64:71] /*v[576:583]*/, v[168:175] /*v[680:687]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[80:87] /*v[592:599]*/, v[168:175] /*v[680:687]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[112:119] /*v[624:631]*/, v[168:175] /*v[680:687]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[128:135] /*v[640:647]*/, v[168:175] /*v[680:687]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[224:231], v[128:135] /*v[640:647]*/, v[144:151] /*v[656:663]*/, v[224:231]
	v_wmma_f32_16x16x32_bf16 v[192:199], v[112:119] /*v[624:631]*/, v[144:151] /*v[656:663]*/, v[192:199]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[80:87] /*v[592:599]*/, v[144:151] /*v[656:663]*/, v[168:175]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[64:71] /*v[576:583]*/, v[144:151] /*v[656:663]*/, v[152:159]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[48:55] /*v[560:567]*/, v[144:151] /*v[656:663]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[40:47] /*v[552:559]*/, v[144:151] /*v[656:663]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[24:31] /*v[536:543]*/, v[144:151] /*v[656:663]*/, v[56:63]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[8:15] /*v[520:527]*/, v[144:151] /*v[656:663]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[8:15] /*v[520:527]*/, v[104:111] /*v[616:623]*/, v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[24:31] /*v[536:543]*/, v[104:111] /*v[616:623]*/, v[184:191]
	v_wmma_f32_16x16x32_bf16 v[200:207], v[40:47] /*v[552:559]*/, v[104:111] /*v[616:623]*/, v[200:207]
	v_wmma_f32_16x16x32_bf16 v[208:215], v[48:55] /*v[560:567]*/, v[104:111] /*v[616:623]*/, v[208:215]
	v_wmma_f32_16x16x32_bf16 v[216:223], v[64:71] /*v[576:583]*/, v[104:111] /*v[616:623]*/, v[216:223]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[56:63] /*v[312:319]*/, v[80:87] /*v[592:599]*/, v[104:111] /*v[616:623]*/, v[56:63] /*v[312:319]*/
	v_wmma_f32_16x16x32_bf16 v[48:55] /*v[304:311]*/, v[112:119] /*v[624:631]*/, v[104:111] /*v[616:623]*/, v[48:55] /*v[304:311]*/
	v_wmma_f32_16x16x32_bf16 v[40:47] /*v[296:303]*/, v[128:135] /*v[640:647]*/, v[104:111] /*v[616:623]*/, v[40:47] /*v[296:303]*/
	v_wmma_f32_16x16x32_bf16 v[32:39] /*v[288:295]*/, v[128:135] /*v[640:647]*/, v[72:79] /*v[584:591]*/, v[32:39] /*v[288:295]*/
	v_wmma_f32_16x16x32_bf16 v[24:31] /*v[280:287]*/, v[112:119] /*v[624:631]*/, v[72:79] /*v[584:591]*/, v[24:31] /*v[280:287]*/
	v_wmma_f32_16x16x32_bf16 v[16:23] /*v[272:279]*/, v[80:87] /*v[592:599]*/, v[72:79] /*v[584:591]*/, v[16:23] /*v[272:279]*/
	v_wmma_f32_16x16x32_bf16 v[8:15] /*v[264:271]*/, v[64:71] /*v[576:583]*/, v[72:79] /*v[584:591]*/, v[8:15] /*v[264:271]*/
	v_wmma_f32_16x16x32_bf16 v[0:7] /*v[256:263]*/, v[48:55] /*v[560:567]*/, v[72:79] /*v[584:591]*/, v[0:7] /*v[256:263]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[248:255], v[40:47] /*v[552:559]*/, v[72:79] /*v[584:591]*/, v[248:255]
	v_wmma_f32_16x16x32_bf16 v[240:247], v[24:31] /*v[536:543]*/, v[72:79] /*v[584:591]*/, v[240:247]
	v_wmma_f32_16x16x32_bf16 v[232:239], v[8:15] /*v[520:527]*/, v[72:79] /*v[584:591]*/, v[232:239]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[64:71] /*v[320:327]*/, v[8:15] /*v[520:527]*/, v[56:63] /*v[568:575]*/, v[64:71] /*v[320:327]*/
	v_wmma_f32_16x16x32_bf16 v[72:79] /*v[328:335]*/, v[24:31] /*v[536:543]*/, v[56:63] /*v[568:575]*/, v[72:79] /*v[328:335]*/
	v_wmma_f32_16x16x32_bf16 v[80:87] /*v[336:343]*/, v[40:47] /*v[552:559]*/, v[56:63] /*v[568:575]*/, v[80:87] /*v[336:343]*/
	v_wmma_f32_16x16x32_bf16 v[96:103] /*v[352:359]*/, v[48:55] /*v[560:567]*/, v[56:63] /*v[568:575]*/, v[96:103] /*v[352:359]*/
	v_wmma_f32_16x16x32_bf16 v[104:111] /*v[360:367]*/, v[64:71] /*v[576:583]*/, v[56:63] /*v[568:575]*/, v[104:111] /*v[360:367]*/
	v_wmma_f32_16x16x32_bf16 v[112:119] /*v[368:375]*/, v[80:87] /*v[592:599]*/, v[56:63] /*v[568:575]*/, v[112:119] /*v[368:375]*/
	v_wmma_f32_16x16x32_bf16 v[128:135] /*v[384:391]*/, v[112:119] /*v[624:631]*/, v[56:63] /*v[568:575]*/, v[128:135] /*v[384:391]*/
	v_wmma_f32_16x16x32_bf16 v[136:143] /*v[392:399]*/, v[128:135] /*v[640:647]*/, v[56:63] /*v[568:575]*/, v[136:143] /*v[392:399]*/
	v_wmma_f32_16x16x32_bf16 v[224:231] /*v[480:487]*/, v[128:135] /*v[640:647]*/, v[32:39] /*v[544:551]*/, v[224:231] /*v[480:487]*/
	v_wmma_f32_16x16x32_bf16 v[192:199] /*v[448:455]*/, v[112:119] /*v[624:631]*/, v[32:39] /*v[544:551]*/, v[192:199] /*v[448:455]*/
	v_wmma_f32_16x16x32_bf16 v[168:175] /*v[424:431]*/, v[80:87] /*v[592:599]*/, v[32:39] /*v[544:551]*/, v[168:175] /*v[424:431]*/
	v_wmma_f32_16x16x32_bf16 v[160:167] /*v[416:423]*/, v[64:71] /*v[576:583]*/, v[32:39] /*v[544:551]*/, v[160:167] /*v[416:423]*/
	v_wmma_f32_16x16x32_bf16 v[152:159] /*v[408:415]*/, v[48:55] /*v[560:567]*/, v[32:39] /*v[544:551]*/, v[152:159] /*v[408:415]*/
	v_wmma_f32_16x16x32_bf16 v[144:151] /*v[400:407]*/, v[40:47] /*v[552:559]*/, v[32:39] /*v[544:551]*/, v[144:151] /*v[400:407]*/
	v_wmma_f32_16x16x32_bf16 v[120:127] /*v[376:383]*/, v[24:31] /*v[536:543]*/, v[32:39] /*v[544:551]*/, v[120:127] /*v[376:383]*/
	v_wmma_f32_16x16x32_bf16 v[88:95] /*v[344:351]*/, v[8:15] /*v[520:527]*/, v[32:39] /*v[544:551]*/, v[88:95] /*v[344:351]*/
	v_wmma_f32_16x16x32_bf16 v[176:183] /*v[432:439]*/, v[8:15] /*v[520:527]*/, v[16:23] /*v[528:535]*/, v[176:183] /*v[432:439]*/
	v_wmma_f32_16x16x32_bf16 v[184:191] /*v[440:447]*/, v[24:31] /*v[536:543]*/, v[16:23] /*v[528:535]*/, v[184:191] /*v[440:447]*/
	v_wmma_f32_16x16x32_bf16 v[200:207] /*v[456:463]*/, v[40:47] /*v[552:559]*/, v[16:23] /*v[528:535]*/, v[200:207] /*v[456:463]*/
	v_wmma_f32_16x16x32_bf16 v[208:215] /*v[464:471]*/, v[48:55] /*v[560:567]*/, v[16:23] /*v[528:535]*/, v[208:215] /*v[464:471]*/
	v_wmma_f32_16x16x32_bf16 v[216:223] /*v[472:479]*/, v[64:71] /*v[576:583]*/, v[16:23] /*v[528:535]*/, v[216:223] /*v[472:479]*/
	v_wmma_f32_16x16x32_bf16 v[232:239] /*v[488:495]*/, v[80:87] /*v[592:599]*/, v[16:23] /*v[528:535]*/, v[232:239] /*v[488:495]*/
	v_wmma_f32_16x16x32_bf16 v[240:247] /*v[496:503]*/, v[112:119] /*v[624:631]*/, v[16:23] /*v[528:535]*/, v[240:247] /*v[496:503]*/
	v_wmma_f32_16x16x32_bf16 v[248:255] /*v[504:511]*/, v[128:135] /*v[640:647]*/, v[16:23] /*v[528:535]*/, v[248:255] /*v[504:511]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[160:167], v[128:135] /*v[640:647]*/, v[0:7] /*v[512:519]*/, v[160:167]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[112:119] /*v[624:631]*/, v[0:7] /*v[512:519]*/, v[144:151]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[80:87] /*v[592:599]*/, v[0:7] /*v[512:519]*/, v[136:143]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[64:71] /*v[576:583]*/, v[0:7] /*v[512:519]*/, v[128:135]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[48:55] /*v[560:567]*/, v[0:7] /*v[512:519]*/, v[120:127]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[40:47] /*v[552:559]*/, v[0:7] /*v[512:519]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[24:31] /*v[536:543]*/, v[0:7] /*v[512:519]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[8:15] /*v[520:527]*/, v[0:7] /*v[512:519]*/, v[88:95]
	s_set_vgpr_msb 0xacc
	v_add_nc_u64_e32 v[2:3] /*v[770:771]*/, s[38:39], v[2:3] /*v[770:771]*/
	s_add_co_i32 s40, s40, -1
	s_add_co_i32 s41, s41, 1
	s_add_co_i32 s35, s35, 0x11800
	s_add_co_i32 s3, s3, 1
	s_cmp_lg_u32 s40, 0
	s_add_nc_u64 s[26:27], s[26:27], 0x80
	s_set_vgpr_msb 0xcc00
	s_barrier_wait -1
	s_cbranch_scc0 .LBB0_18
.LBB0_14:
	s_mul_hi_u32 s29, s41, 0xaaaaaaab
	s_set_vgpr_msb 0x8c
	v_dual_add_nc_u32 v55 /*v567*/, s35, v16 /*v784*/ :: v_dual_add_nc_u32 v113 /*v625*/, s35, v49 /*v817*/
	s_lshr_b32 s29, s29, 1
	s_delay_alu instid0(SALU_CYCLE_1)
	s_mul_i32 s29, s29, 0x34800
	v_nop
	v_nop
	v_subrev_nc_u32_e32 v4 /*v516*/, s29, v21 /*v789*/
	v_subrev_nc_u32_e32 v31 /*v543*/, s29, v17 /*v785*/
	v_subrev_nc_u32_e32 v5 /*v517*/, s29, v22 /*v790*/
	v_subrev_nc_u32_e32 v6 /*v518*/, s29, v23 /*v791*/
	v_subrev_nc_u32_e32 v7 /*v519*/, s29, v24 /*v792*/
	v_subrev_nc_u32_e32 v58 /*v570*/, s29, v11 /*v779*/
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v31 /*v543*/, v55 /*v567*/, v31 /*v543*/ :: v_dual_add_nc_u32 v4 /*v516*/, v55 /*v567*/, v4 /*v516*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v8 /*v520*/, s29, v25 /*v793*/
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v5 /*v517*/, v55 /*v567*/, v5 /*v517*/ :: v_dual_add_nc_u32 v58 /*v570*/, v113 /*v625*/, v58 /*v570*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v9 /*v521*/, s29, v26 /*v794*/
	s_set_vgpr_msb 0x8c8a
	v_add_nc_u32_e32 v6 /*v518*/, v55 /*v567*/, v6 /*v518*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v10 /*v522*/, s29, v27 /*v795*/
	v_subrev_nc_u32_e32 v11 /*v523*/, s29, v28 /*v796*/
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[252:255] /*v[764:767]*/, v4 /*v516*/
	ds_load_b128 v[232:235] /*v[744:747]*/, v5 /*v517*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x8e8a
	v_add_nc_u32_e32 v4 /*v516*/, v55 /*v567*/, v7 /*v519*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v12 /*v524*/, s29, v29 /*v797*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8c8a
	v_add_nc_u32_e32 v5 /*v517*/, v55 /*v567*/, v8 /*v520*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v13 /*v525*/, s29, v30 /*v798*/
	ds_load_b128 v[236:239] /*v[748:751]*/, v6 /*v518*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8e8a
	v_dual_add_nc_u32 v6 /*v518*/, v55 /*v567*/, v9 /*v521*/ :: v_dual_add_nc_u32 v7 /*v519*/, v55 /*v567*/, v10 /*v522*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v14 /*v526*/, s29, v31 /*v799*/
	s_wait_alu depctr_va_vdst(5)
	ds_load_b128 v[224:227] /*v[736:739]*/, v4 /*v516*/
	s_wait_alu depctr_va_vdst(3)
	ds_load_b128 v[228:231] /*v[740:743]*/, v5 /*v517*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x8e8a
	v_add_nc_u32_e32 v4 /*v516*/, v55 /*v567*/, v11 /*v523*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v15 /*v527*/, s29, v32 /*v800*/
	v_subrev_nc_u32_e32 v16 /*v528*/, s29, v33 /*v801*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8c8a
	v_add_nc_u32_e32 v5 /*v517*/, v55 /*v567*/, v12 /*v524*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v3 /*v515*/, s29, v15 /*v783*/
	s_wait_alu depctr_va_vdst(6)
	ds_load_b128 v[200:203] /*v[712:715]*/, v6 /*v518*/
	ds_load_b128 v[204:207] /*v[716:719]*/, v7 /*v519*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x8e8a
	v_add_nc_u32_e32 v6 /*v518*/, v55 /*v567*/, v13 /*v525*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v0 /*v512*/, s29, v18 /*v786*/
	v_subrev_nc_u32_e32 v59 /*v571*/, s29, v79 /*v847*/
	s_wait_alu depctr_va_vdst(7)
	ds_load_b128 v[184:187] /*v[696:699]*/, v4 /*v516*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8e8a
	v_dual_add_nc_u32 v4 /*v516*/, v55 /*v567*/, v14 /*v526*/ :: v_dual_add_nc_u32 v7 /*v519*/, v55 /*v567*/, v15 /*v527*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v57 /*v569*/, s29, v78 /*v846*/
	s_wait_alu depctr_va_vdst(6)
	ds_load_b128 v[188:191] /*v[700:703]*/, v5 /*v517*/
	s_wait_alu depctr_va_vdst(4)
	ds_load_b128 v[152:155] /*v[664:667]*/, v6 /*v518*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x8e8a
	v_dual_add_nc_u32 v5 /*v517*/, v55 /*v567*/, v16 /*v528*/ :: v_dual_add_nc_u32 v3 /*v515*/, v55 /*v567*/, v3 /*v515*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v56 /*v568*/, s29, v77 /*v845*/
	v_subrev_nc_u32_e32 v54 /*v566*/, s29, v76 /*v844*/
	s_set_vgpr_msb 0x8c8a
	v_add_nc_u32_e32 v0 /*v512*/, v55 /*v567*/, v0 /*v512*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v53 /*v565*/, s29, v75 /*v843*/
	v_subrev_nc_u32_e32 v47 /*v559*/, s29, v74 /*v842*/
	s_wait_alu depctr_va_vdst(7)
	ds_load_b128 v[156:159] /*v[668:671]*/, v4 /*v516*/
	ds_load_b128 v[120:123] /*v[632:635]*/, v7 /*v519*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x8e8a
	v_add_nc_u32_e32 v4 /*v516*/, v113 /*v625*/, v59 /*v571*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v46 /*v558*/, s29, v73 /*v841*/
	s_wait_alu depctr_va_vdst(7)
	ds_load_b128 v[124:127] /*v[636:639]*/, v5 /*v517*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8e8a
	v_add_nc_u32_e32 v5 /*v517*/, v113 /*v625*/, v57 /*v569*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v39 /*v551*/, s29, v72 /*v840*/
	ds_load_b128 v[88:91] /*v[600:603]*/, v3 /*v515*/
	s_wait_alu depctr_va_vdst(6)
	ds_load_b128 v[92:95] /*v[604:607]*/, v0 /*v512*/
	ds_load_tr16_b128 v[96:99] /*v[608:611]*/, v58 /*v570*/
	s_wait_alu depctr_va_vdst(3)
	ds_load_tr16_b128 v[100:103] /*v[612:615]*/, v4 /*v516*/
	s_wait_alu depctr_va_vdst(1)
	ds_load_tr16_b128 v[136:139] /*v[648:651]*/, v5 /*v517*/
	s_wait_alu depctr_vm_vsrc(3)
	s_set_vgpr_msb 0x8e8a
	v_add_nc_u32_e32 v0 /*v512*/, v113 /*v625*/, v56 /*v568*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v38 /*v550*/, s29, v71 /*v839*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v3 /*v515*/, v113 /*v625*/, v54 /*v566*/ :: v_dual_add_nc_u32 v4 /*v516*/, v113 /*v625*/, v53 /*v565*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v37 /*v549*/, s29, v70 /*v838*/
	v_subrev_nc_u32_e32 v36 /*v548*/, s29, v69 /*v837*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v5 /*v517*/, v113 /*v625*/, v47 /*v559*/ :: v_dual_add_nc_u32 v6 /*v518*/, v113 /*v625*/, v46 /*v558*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v35 /*v547*/, s29, v68 /*v836*/
	v_subrev_nc_u32_e32 v34 /*v546*/, s29, v67 /*v835*/
	s_wait_alu depctr_va_vdst(7)
	ds_load_tr16_b128 v[140:143] /*v[652:655]*/, v0 /*v512*/
	s_wait_alu depctr_va_vdst(5)
	ds_load_tr16_b128 v[160:163] /*v[672:675]*/, v3 /*v515*/
	ds_load_tr16_b128 v[164:167] /*v[676:679]*/, v4 /*v516*/
	s_wait_alu depctr_va_vdst(2)
	ds_load_tr16_b128 v[176:179] /*v[688:691]*/, v5 /*v517*/
	ds_load_tr16_b128 v[180:183] /*v[692:695]*/, v6 /*v518*/
	s_wait_alu depctr_vm_vsrc(3)
	s_set_vgpr_msb 0x8e8a
	v_dual_add_nc_u32 v0 /*v512*/, v113 /*v625*/, v39 /*v551*/ :: v_dual_add_nc_u32 v3 /*v515*/, v113 /*v625*/, v38 /*v550*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v33 /*v545*/, s29, v66 /*v834*/
	v_subrev_nc_u32_e32 v32 /*v544*/, s29, v65 /*v833*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v4 /*v516*/, v113 /*v625*/, v37 /*v549*/ :: v_dual_add_nc_u32 v5 /*v517*/, v113 /*v625*/, v36 /*v548*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v17 /*v529*/, s29, v34 /*v802*/
	v_subrev_nc_u32_e32 v18 /*v530*/, s29, v35 /*v803*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8c8a
	v_add_nc_u32_e32 v6 /*v518*/, v113 /*v625*/, v35 /*v547*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v19 /*v531*/, s29, v36 /*v804*/
	s_wait_alu depctr_va_vdst(7)
	ds_load_tr16_b128 v[192:195] /*v[704:707]*/, v0 /*v512*/
	ds_load_tr16_b128 v[196:199] /*v[708:711]*/, v3 /*v515*/
	s_wait_alu depctr_va_vdst(4)
	ds_load_tr16_b128 v[208:211] /*v[720:723]*/, v4 /*v516*/
	ds_load_tr16_b128 v[212:215] /*v[724:727]*/, v5 /*v517*/
	s_wait_alu depctr_va_vdst(1)
	ds_load_tr16_b128 v[216:219] /*v[728:731]*/, v6 /*v518*/
	s_wait_alu depctr_vm_vsrc(4)
	s_set_vgpr_msb 0x8e8a
	v_add_nc_u32_e32 v0 /*v512*/, v113 /*v625*/, v34 /*v546*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v20 /*v532*/, s29, v37 /*v805*/
	s_wait_alu depctr_vm_vsrc(2)
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v3 /*v515*/, v113 /*v625*/, v33 /*v545*/ :: v_dual_add_nc_u32 v4 /*v516*/, v113 /*v625*/, v32 /*v544*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v21 /*v533*/, s29, v38 /*v806*/
	v_subrev_nc_u32_e32 v22 /*v534*/, s29, v39 /*v807*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v5 /*v517*/, v55 /*v567*/, v17 /*v529*/ :: v_dual_add_nc_u32 v6 /*v518*/, v55 /*v567*/, v18 /*v530*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v23 /*v535*/, s29, v40 /*v808*/
	v_subrev_nc_u32_e32 v24 /*v536*/, s29, v41 /*v809*/
	s_wait_alu depctr_va_vdst(7)
	ds_load_tr16_b128 v[220:223] /*v[732:735]*/, v0 /*v512*/
	s_wait_alu depctr_va_vdst(5)
	ds_load_tr16_b128 v[240:243] /*v[752:755]*/, v3 /*v515*/
	ds_load_tr16_b128 v[244:247] /*v[756:759]*/, v4 /*v516*/
	s_wait_alu depctr_va_vdst(2)
	ds_load_b128 v[168:171] /*v[680:683]*/, v5 /*v517*/
	ds_load_b128 v[172:175] /*v[684:687]*/, v6 /*v518*/
	s_wait_alu depctr_vm_vsrc(3)
	s_set_vgpr_msb 0x8e8a
	v_dual_add_nc_u32 v0 /*v512*/, v55 /*v567*/, v19 /*v531*/ :: v_dual_add_nc_u32 v3 /*v515*/, v55 /*v567*/, v20 /*v532*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v25 /*v537*/, s29, v42 /*v810*/
	v_subrev_nc_u32_e32 v26 /*v538*/, s29, v43 /*v811*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v4 /*v516*/, v55 /*v567*/, v21 /*v533*/ :: v_dual_add_nc_u32 v5 /*v517*/, v55 /*v567*/, v22 /*v534*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v27 /*v539*/, s29, v44 /*v812*/
	v_subrev_nc_u32_e32 v28 /*v540*/, s29, v45 /*v813*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8c8a
	v_add_nc_u32_e32 v6 /*v518*/, v55 /*v567*/, v23 /*v535*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v29 /*v541*/, s29, v46 /*v814*/
	v_subrev_nc_u32_e32 v112 /*v624*/, s29, v53 /*v821*/
	v_subrev_nc_u32_e32 v52 /*v564*/, s29, v58 /*v826*/
	v_subrev_nc_u32_e32 v44 /*v556*/, s29, v63 /*v831*/
	v_subrev_nc_u32_e32 v45 /*v557*/, s29, v64 /*v832*/
	s_wait_alu depctr_va_vdst(11)
	ds_load_b128 v[144:147] /*v[656:659]*/, v0 /*v512*/
	ds_load_b128 v[148:151] /*v[660:663]*/, v3 /*v515*/
	s_wait_alu depctr_va_vdst(8)
	ds_load_b128 v[104:107] /*v[616:619]*/, v4 /*v516*/
	ds_load_b128 v[108:111] /*v[620:623]*/, v5 /*v517*/
	s_wait_alu depctr_va_vdst(5)
	ds_load_b128 v[72:75] /*v[584:587]*/, v6 /*v518*/
	s_wait_alu depctr_vm_vsrc(4)
	s_set_vgpr_msb 0x8e8a
	v_add_nc_u32_e32 v0 /*v512*/, v55 /*v567*/, v24 /*v536*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v30 /*v542*/, s29, v47 /*v815*/
	v_subrev_nc_u32_e32 v87 /*v599*/, s29, v52 /*v820*/
	v_subrev_nc_u32_e32 v48 /*v560*/, s29, v54 /*v822*/
	v_subrev_nc_u32_e32 v51 /*v563*/, s29, v57 /*v825*/
	v_subrev_nc_u32_e32 v43 /*v555*/, s29, v62 /*v830*/
	s_wait_alu depctr_vm_vsrc(2)
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v3 /*v515*/, v55 /*v567*/, v25 /*v537*/ :: v_dual_add_nc_u32 v4 /*v516*/, v55 /*v567*/, v26 /*v538*/
	s_set_vgpr_msb 0x8a8c
	v_subrev_nc_u32_e32 v2 /*v514*/, s29, v20 /*v788*/
	v_subrev_nc_u32_e32 v86 /*v598*/, s29, v51 /*v819*/
	v_subrev_nc_u32_e32 v50 /*v562*/, s29, v56 /*v824*/
	v_subrev_nc_u32_e32 v42 /*v554*/, s29, v61 /*v829*/
	v_subrev_nc_u32_e32 v1 /*v513*/, s29, v19 /*v787*/
	v_subrev_nc_u32_e32 v85 /*v597*/, s29, v50 /*v818*/
	v_subrev_nc_u32_e32 v49 /*v561*/, s29, v55 /*v823*/
	v_subrev_nc_u32_e32 v41 /*v553*/, s29, v60 /*v828*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8c8a
	v_dual_add_nc_u32 v5 /*v517*/, v55 /*v567*/, v27 /*v539*/ :: v_dual_add_nc_u32 v6 /*v518*/, v55 /*v567*/, v28 /*v540*/
	s_set_vgpr_msb 0x8a8e
	v_subrev_nc_u32_e32 v84 /*v596*/, s29, v48 /*v816*/
	v_subrev_nc_u32_e32 v40 /*v552*/, s29, v59 /*v827*/
	s_wait_alu depctr_va_vdst(14)
	ds_load_b128 v[76:79] /*v[588:591]*/, v0 /*v512*/
	s_wait_alu depctr_va_vdst(11)
	ds_load_b128 v[56:59] /*v[568:571]*/, v3 /*v515*/
	ds_load_b128 v[60:63] /*v[572:575]*/, v4 /*v516*/
	s_wait_alu depctr_va_vdst(2)
	ds_load_b128 v[32:35] /*v[544:547]*/, v5 /*v517*/
	ds_load_b128 v[36:39] /*v[548:551]*/, v6 /*v518*/
	s_wait_alu depctr_vm_vsrc(3)
	s_set_vgpr_msb 0x8e8a
	v_dual_add_nc_u32 v0 /*v512*/, v55 /*v567*/, v29 /*v541*/ :: v_dual_add_nc_u32 v3 /*v515*/, v55 /*v567*/, v30 /*v542*/
	v_dual_add_nc_u32 v8 /*v520*/, v113 /*v625*/, v45 /*v557*/ :: v_dual_add_nc_u32 v12 /*v524*/, v113 /*v625*/, v44 /*v556*/
	v_dual_add_nc_u32 v52 /*v564*/, v113 /*v625*/, v52 /*v564*/ :: v_dual_add_nc_u32 v53 /*v565*/, v113 /*v625*/, v51 /*v563*/
	v_dual_add_nc_u32 v112 /*v624*/, v113 /*v625*/, v112 /*v624*/ :: v_dual_add_nc_u32 v116 /*v628*/, v113 /*v625*/, v86 /*v598*/
	v_dual_add_nc_u32 v24 /*v536*/, v113 /*v625*/, v43 /*v555*/ :: v_dual_add_nc_u32 v28 /*v540*/, v113 /*v625*/, v42 /*v554*/
	v_dual_add_nc_u32 v80 /*v592*/, v113 /*v625*/, v48 /*v560*/ :: v_dual_add_nc_u32 v114 /*v626*/, v113 /*v625*/, v87 /*v599*/
	s_wait_alu depctr_vm_vsrc(2)
	v_dual_add_nc_u32 v2 /*v514*/, v55 /*v567*/, v2 /*v514*/ :: v_dual_add_nc_u32 v4 /*v516*/, v55 /*v567*/, v1 /*v513*/
	v_dual_add_nc_u32 v64 /*v576*/, v113 /*v625*/, v50 /*v562*/ :: v_dual_add_nc_u32 v68 /*v580*/, v113 /*v625*/, v49 /*v561*/
	v_dual_add_nc_u32 v41 /*v553*/, v113 /*v625*/, v41 /*v553*/ :: v_dual_add_nc_u32 v44 /*v556*/, v113 /*v625*/, v40 /*v552*/
	v_dual_add_nc_u32 v128 /*v640*/, v113 /*v625*/, v85 /*v597*/ :: v_dual_add_nc_u32 v132 /*v644*/, v113 /*v625*/, v84 /*v596*/
	ds_load_b128 v[248:251] /*v[760:763]*/, v31 /*v543*/
	s_wait_alu depctr_va_vdst(9)
	ds_load_b128 v[16:19] /*v[528:531]*/, v0 /*v512*/
	ds_load_b128 v[20:23] /*v[532:535]*/, v3 /*v515*/
	s_wait_alu depctr_va_vdst(3) depctr_vm_vsrc(0)
	ds_load_b128 v[0:3] /*v[512:515]*/, v2 /*v514*/
	ds_load_b128 v[4:7] /*v[516:519]*/, v4 /*v516*/
	ds_load_tr16_b128 v[8:11] /*v[520:523]*/, v8 /*v520*/
	ds_load_tr16_b128 v[12:15] /*v[524:527]*/, v12 /*v524*/
	ds_load_tr16_b128 v[24:27] /*v[536:539]*/, v24 /*v536*/
	ds_load_tr16_b128 v[28:31] /*v[540:543]*/, v28 /*v540*/
	s_wait_alu depctr_va_vdst(1)
	ds_load_tr16_b128 v[40:43] /*v[552:555]*/, v41 /*v553*/
	ds_load_tr16_b128 v[44:47] /*v[556:559]*/, v44 /*v556*/
	ds_load_tr16_b128 v[48:51] /*v[560:563]*/, v52 /*v564*/
	s_wait_alu depctr_vm_vsrc(0)
	ds_load_tr16_b128 v[52:55] /*v[564:567]*/, v53 /*v565*/
	ds_load_tr16_b128 v[64:67] /*v[576:579]*/, v64 /*v576*/
	ds_load_tr16_b128 v[68:71] /*v[580:583]*/, v68 /*v580*/
	ds_load_tr16_b128 v[80:83] /*v[592:595]*/, v80 /*v592*/
	ds_load_tr16_b128 v[84:87] /*v[596:599]*/, v112 /*v624*/
	s_wait_alu depctr_vm_vsrc(0)
	ds_load_tr16_b128 v[112:115] /*v[624:627]*/, v114 /*v626*/
	ds_load_tr16_b128 v[116:119] /*v[628:631]*/, v116 /*v628*/
	s_wait_alu depctr_va_vdst(0)
	ds_load_tr16_b128 v[128:131] /*v[640:643]*/, v128 /*v640*/
	ds_load_tr16_b128 v[132:135] /*v[644:647]*/, v132 /*v644*/
	s_mul_hi_u32 s29, s3, 0xaaaaaaab
	s_wait_dscnt 0x20
	s_lshr_b32 s29, s29, 1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s29, s29, 0x34800
	s_sub_co_i32 s43, 0x2c000, s29
	s_and_b32 vcc_lo, exec_lo, s0
	s_set_vgpr_msb 0x8a00
	s_cbranch_vccz .LBB0_16
	s_and_b32 vcc_lo, exec_lo, s1
	s_cbranch_vccnz .LBB0_13
	s_branch .LBB0_17
.LBB0_16:
	s_add_co_i32 s29, s35, 0
	s_or_b32 s31, s27, 0x80000000
	s_add_co_i32 s29, s29, s43
	s_mov_b32 s30, s26
	s_add_co_i32 s29, s29, 0xffff7000
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[28:31], s[8:15]
	s_and_b32 vcc_lo, exec_lo, s1
	s_cbranch_vccnz .LBB0_13
.LBB0_17:
	s_add_co_i32 s29, s35, 0
	s_set_vgpr_msb 0xcf
	v_or_b32_e32 v83 /*v851*/, 0x80000000, v3 /*v771*/
	s_add_co_i32 s29, s29, s43
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_dual_mov_b32 v80 /*v848*/, v2 /*v770*/ :: v_dual_mov_b32 v81 /*v849*/, s29
	v_readfirstlane_b32 s44, v0 /*v768*/
	v_readfirstlane_b32 s47, v83 /*v851*/
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_readfirstlane_b32 s46, v80 /*v848*/
	v_readfirstlane_b32 s45, v81 /*v849*/
	s_delay_alu instid0(VALU_DEP_1)
	tensor_load_to_lds s[44:47], s[16:23]
	s_set_vgpr_msb 0xcf00
	s_branch .LBB0_13
.LBB0_18:
	v_nop
	v_nop
	v_nop
	s_set_vgpr_msb 0x83
	v_dual_mov_b32 v40 /*v552*/, v14 /*v782*/ :: v_dual_mov_b32 v0 /*v512*/, v13 /*v781*/
	v_mov_b32_e32 v1 /*v513*/, v12 /*v780*/
	s_set_vgpr_msb 0x8300
.LBB0_19:
	s_mul_hi_i32 s0, s7, 0x55555556
	s_set_vgpr_msb 0x8c
	v_or3_b32 v2 /*v514*/, s24, v10 /*v778*/, s2
	s_lshr_b32 s1, s0, 31
	s_ashr_i32 s35, s34, 31
	s_add_co_i32 s0, s0, s1
	s_set_vgpr_msb 0x8cba
	v_subrev_nc_u32_e32 v2 /*v514*/, s6, v2 /*v514*/
	s_mul_i32 s0, s0, 3
	s_delay_alu instid0(SALU_CYCLE_1)
	s_sub_co_i32 s0, s7, s0
	s_mov_b32 s7, 0
	s_mul_i32 s0, s0, 0x11800
	v_lshl_add_u32 v34 /*v546*/, v2 /*v514*/, 1, v11 /*v779*/
	s_add_co_i32 s0, s0, 0
	s_set_vgpr_msb 0xba8c
	v_dual_add_nc_u32 v37 /*v549*/, s0, v8 /*v776*/ :: v_dual_add_nc_u32 v38 /*v550*/, s0, v9 /*v777*/
	v_add_nc_u32_e32 v35 /*v547*/, s0, v7 /*v775*/
	s_set_vgpr_msb 0x8c8a
	v_add_nc_u32_e32 v36 /*v548*/, s0, v34 /*v546*/
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[66:69] /*v[578:581]*/, v37 /*v549*/
	ds_load_b128 v[70:73] /*v[582:585]*/, v38 /*v550*/
	s_wait_alu depctr_vm_vsrc(0)
	v_dual_add_nc_u32 v37 /*v549*/, s0, v0 /*v512*/ :: v_dual_add_nc_u32 v38 /*v550*/, s0, v1 /*v513*/
	ds_load_b128 v[2:5] /*v[514:517]*/, v35 /*v547*/
	ds_load_b128 v[6:9] /*v[518:521]*/, v35 /*v547*/ offset:32
	ds_load_b128 v[10:13] /*v[522:525]*/, v35 /*v547*/ offset:2304
	ds_load_b128 v[14:17] /*v[526:529]*/, v35 /*v547*/ offset:2336
	ds_load_b128 v[18:21] /*v[530:533]*/, v35 /*v547*/ offset:4608
	ds_load_b128 v[22:25] /*v[534:537]*/, v35 /*v547*/ offset:4640
	ds_load_b128 v[26:29] /*v[538:541]*/, v35 /*v547*/ offset:6912
	ds_load_b128 v[30:33] /*v[542:545]*/, v35 /*v547*/ offset:6944
	ds_load_b128 v[42:45] /*v[554:557]*/, v35 /*v547*/ offset:9216
	ds_load_b128 v[46:49] /*v[558:561]*/, v35 /*v547*/ offset:9248
	ds_load_b128 v[50:53] /*v[562:565]*/, v35 /*v547*/ offset:11520
	ds_load_b128 v[54:57] /*v[566:569]*/, v35 /*v547*/ offset:11552
	ds_load_b128 v[58:61] /*v[570:573]*/, v35 /*v547*/ offset:13824
	ds_load_b128 v[62:65] /*v[574:577]*/, v35 /*v547*/ offset:13856
	ds_load_tr16_b128 v[78:81] /*v[590:593]*/, v36 /*v548*/ offset:8704
	ds_load_tr16_b128 v[74:77] /*v[586:589]*/, v36 /*v548*/
	ds_load_tr16_b128 v[82:85] /*v[594:597]*/, v36 /*v548*/ offset:32
	ds_load_tr16_b128 v[86:89] /*v[598:601]*/, v36 /*v548*/ offset:8736
	ds_load_tr16_b128 v[90:93] /*v[602:605]*/, v36 /*v548*/ offset:64
	ds_load_tr16_b128 v[94:97] /*v[606:609]*/, v36 /*v548*/ offset:8768
	ds_load_tr16_b128 v[98:101] /*v[610:613]*/, v36 /*v548*/ offset:96
	ds_load_tr16_b128 v[102:105] /*v[614:617]*/, v36 /*v548*/ offset:8800
	ds_load_tr16_b128 v[106:109] /*v[618:621]*/, v36 /*v548*/ offset:128
	ds_load_tr16_b128 v[110:113] /*v[622:625]*/, v36 /*v548*/ offset:8832
	ds_load_tr16_b128 v[114:117] /*v[626:629]*/, v36 /*v548*/ offset:160
	ds_load_tr16_b128 v[118:121] /*v[630:633]*/, v36 /*v548*/ offset:8864
	ds_load_tr16_b128 v[122:125] /*v[634:637]*/, v36 /*v548*/ offset:192
	ds_load_tr16_b128 v[126:129] /*v[638:641]*/, v36 /*v548*/ offset:8896
	ds_load_tr16_b128 v[130:133] /*v[642:645]*/, v36 /*v548*/ offset:224
	ds_load_tr16_b128 v[134:137] /*v[646:649]*/, v36 /*v548*/ offset:8928
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[138:141] /*v[650:653]*/, v37 /*v549*/
	ds_load_b128 v[142:145] /*v[654:657]*/, v38 /*v550*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8a8e
	v_dual_add_nc_u32 v37 /*v549*/, s0, v5 /*v773*/ :: v_dual_add_nc_u32 v38 /*v550*/, s0, v6 /*v774*/
	ds_load_b128 v[146:149] /*v[658:661]*/, v35 /*v547*/ offset:2368
	ds_load_b128 v[150:153] /*v[662:665]*/, v35 /*v547*/ offset:2400
	ds_load_b128 v[154:157] /*v[666:669]*/, v35 /*v547*/ offset:4672
	ds_load_b128 v[158:161] /*v[670:673]*/, v35 /*v547*/ offset:4704
	ds_load_b128 v[162:165] /*v[674:677]*/, v35 /*v547*/ offset:6976
	ds_load_b128 v[166:169] /*v[678:681]*/, v35 /*v547*/ offset:7008
	ds_load_b128 v[170:173] /*v[682:685]*/, v35 /*v547*/ offset:9280
	ds_load_b128 v[174:177] /*v[686:689]*/, v35 /*v547*/ offset:9312
	ds_load_b128 v[178:181] /*v[690:693]*/, v35 /*v547*/ offset:11584
	ds_load_b128 v[182:185] /*v[694:697]*/, v35 /*v547*/ offset:11616
	ds_load_b128 v[186:189] /*v[698:701]*/, v35 /*v547*/ offset:13888
	ds_load_b128 v[190:193] /*v[702:705]*/, v35 /*v547*/ offset:13920
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[194:197] /*v[706:709]*/, v37 /*v549*/
	ds_load_b128 v[198:201] /*v[710:713]*/, v38 /*v550*/
	ds_load_tr16_b128 v[202:205] /*v[714:717]*/, v36 /*v548*/ offset:17408
	ds_load_tr16_b128 v[206:209] /*v[718:721]*/, v36 /*v548*/ offset:26112
	ds_load_tr16_b128 v[210:213] /*v[722:725]*/, v36 /*v548*/ offset:17440
	ds_load_tr16_b128 v[214:217] /*v[726:729]*/, v36 /*v548*/ offset:26144
	ds_load_tr16_b128 v[218:221] /*v[730:733]*/, v36 /*v548*/ offset:17472
	ds_load_tr16_b128 v[222:225] /*v[734:737]*/, v36 /*v548*/ offset:26176
	ds_load_tr16_b128 v[226:229] /*v[738:741]*/, v36 /*v548*/ offset:17504
	ds_load_tr16_b128 v[230:233] /*v[742:745]*/, v36 /*v548*/ offset:26208
	ds_load_tr16_b128 v[234:237] /*v[746:749]*/, v36 /*v548*/ offset:17536
	ds_load_tr16_b128 v[238:241] /*v[750:753]*/, v36 /*v548*/ offset:26240
	ds_load_tr16_b128 v[242:245] /*v[754:757]*/, v36 /*v548*/ offset:17568
	ds_load_tr16_b128 v[246:249] /*v[758:761]*/, v36 /*v548*/ offset:26272
	s_set_vgpr_msb 0x8ec2
	ds_load_tr16_b128 v[10:13] /*v[778:781]*/, v36 /*v548*/ offset:17600
	ds_load_tr16_b128 v[14:17] /*v[782:785]*/, v36 /*v548*/ offset:26304
	ds_load_tr16_b128 v[18:21] /*v[786:789]*/, v36 /*v548*/ offset:17632
	ds_load_tr16_b128 v[22:25] /*v[790:793]*/, v36 /*v548*/ offset:26336
	s_set_vgpr_msb 0xc20a
	s_wait_dscnt 0x2e
	v_wmma_f32_16x16x32_bf16 v[0:7], v[74:81] /*v[586:593]*/, v[2:9] /*v[514:521]*/, v[0:7]
	s_sub_co_i32 s0, s25, s2
	s_wait_dscnt 0x0
	v_wmma_f32_16x16x32_bf16 v[8:15], v[82:89] /*v[594:601]*/, v[2:9] /*v[514:521]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[90:97] /*v[602:609]*/, v[2:9] /*v[514:521]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[98:105] /*v[610:617]*/, v[2:9] /*v[514:521]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[106:113] /*v[618:625]*/, v[2:9] /*v[514:521]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[114:121] /*v[626:633]*/, v[2:9] /*v[514:521]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[122:129] /*v[634:641]*/, v[2:9] /*v[514:521]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[130:137] /*v[642:649]*/, v[2:9] /*v[514:521]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[224:231], v[130:137] /*v[642:649]*/, v[10:17] /*v[522:529]*/, v[224:231]
	v_wmma_f32_16x16x32_bf16 v[192:199], v[122:129] /*v[634:641]*/, v[10:17] /*v[522:529]*/, v[192:199]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[114:121] /*v[626:633]*/, v[10:17] /*v[522:529]*/, v[168:175]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[106:113] /*v[618:625]*/, v[10:17] /*v[522:529]*/, v[152:159]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[98:105] /*v[610:617]*/, v[10:17] /*v[522:529]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[90:97] /*v[602:609]*/, v[10:17] /*v[522:529]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[82:89] /*v[594:601]*/, v[10:17] /*v[522:529]*/, v[56:63]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[74:81] /*v[586:593]*/, v[10:17] /*v[522:529]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[74:81] /*v[586:593]*/, v[18:25] /*v[530:537]*/, v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[82:89] /*v[594:601]*/, v[18:25] /*v[530:537]*/, v[184:191]
	v_wmma_f32_16x16x32_bf16 v[200:207], v[90:97] /*v[602:609]*/, v[18:25] /*v[530:537]*/, v[200:207]
	v_wmma_f32_16x16x32_bf16 v[208:215], v[98:105] /*v[610:617]*/, v[18:25] /*v[530:537]*/, v[208:215]
	v_wmma_f32_16x16x32_bf16 v[216:223], v[106:113] /*v[618:625]*/, v[18:25] /*v[530:537]*/, v[216:223]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[56:63] /*v[312:319]*/, v[114:121] /*v[626:633]*/, v[18:25] /*v[530:537]*/, v[56:63] /*v[312:319]*/
	v_wmma_f32_16x16x32_bf16 v[48:55] /*v[304:311]*/, v[122:129] /*v[634:641]*/, v[18:25] /*v[530:537]*/, v[48:55] /*v[304:311]*/
	v_wmma_f32_16x16x32_bf16 v[40:47] /*v[296:303]*/, v[130:137] /*v[642:649]*/, v[18:25] /*v[530:537]*/, v[40:47] /*v[296:303]*/
	v_wmma_f32_16x16x32_bf16 v[32:39] /*v[288:295]*/, v[130:137] /*v[642:649]*/, v[26:33] /*v[538:545]*/, v[32:39] /*v[288:295]*/
	v_wmma_f32_16x16x32_bf16 v[24:31] /*v[280:287]*/, v[122:129] /*v[634:641]*/, v[26:33] /*v[538:545]*/, v[24:31] /*v[280:287]*/
	v_wmma_f32_16x16x32_bf16 v[16:23] /*v[272:279]*/, v[114:121] /*v[626:633]*/, v[26:33] /*v[538:545]*/, v[16:23] /*v[272:279]*/
	v_wmma_f32_16x16x32_bf16 v[8:15] /*v[264:271]*/, v[106:113] /*v[618:625]*/, v[26:33] /*v[538:545]*/, v[8:15] /*v[264:271]*/
	v_wmma_f32_16x16x32_bf16 v[0:7] /*v[256:263]*/, v[98:105] /*v[610:617]*/, v[26:33] /*v[538:545]*/, v[0:7] /*v[256:263]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[248:255], v[90:97] /*v[602:609]*/, v[26:33] /*v[538:545]*/, v[248:255]
	v_wmma_f32_16x16x32_bf16 v[240:247], v[82:89] /*v[594:601]*/, v[26:33] /*v[538:545]*/, v[240:247]
	v_wmma_f32_16x16x32_bf16 v[232:239], v[74:81] /*v[586:593]*/, v[26:33] /*v[538:545]*/, v[232:239]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[64:71] /*v[320:327]*/, v[74:81] /*v[586:593]*/, v[42:49] /*v[554:561]*/, v[64:71] /*v[320:327]*/
	v_wmma_f32_16x16x32_bf16 v[72:79] /*v[328:335]*/, v[82:89] /*v[594:601]*/, v[42:49] /*v[554:561]*/, v[72:79] /*v[328:335]*/
	v_wmma_f32_16x16x32_bf16 v[80:87] /*v[336:343]*/, v[90:97] /*v[602:609]*/, v[42:49] /*v[554:561]*/, v[80:87] /*v[336:343]*/
	v_wmma_f32_16x16x32_bf16 v[96:103] /*v[352:359]*/, v[98:105] /*v[610:617]*/, v[42:49] /*v[554:561]*/, v[96:103] /*v[352:359]*/
	v_wmma_f32_16x16x32_bf16 v[104:111] /*v[360:367]*/, v[106:113] /*v[618:625]*/, v[42:49] /*v[554:561]*/, v[104:111] /*v[360:367]*/
	v_wmma_f32_16x16x32_bf16 v[112:119] /*v[368:375]*/, v[114:121] /*v[626:633]*/, v[42:49] /*v[554:561]*/, v[112:119] /*v[368:375]*/
	v_wmma_f32_16x16x32_bf16 v[128:135] /*v[384:391]*/, v[122:129] /*v[634:641]*/, v[42:49] /*v[554:561]*/, v[128:135] /*v[384:391]*/
	v_wmma_f32_16x16x32_bf16 v[136:143] /*v[392:399]*/, v[130:137] /*v[642:649]*/, v[42:49] /*v[554:561]*/, v[136:143] /*v[392:399]*/
	v_wmma_f32_16x16x32_bf16 v[224:231] /*v[480:487]*/, v[130:137] /*v[642:649]*/, v[50:57] /*v[562:569]*/, v[224:231] /*v[480:487]*/
	v_wmma_f32_16x16x32_bf16 v[192:199] /*v[448:455]*/, v[122:129] /*v[634:641]*/, v[50:57] /*v[562:569]*/, v[192:199] /*v[448:455]*/
	v_wmma_f32_16x16x32_bf16 v[168:175] /*v[424:431]*/, v[114:121] /*v[626:633]*/, v[50:57] /*v[562:569]*/, v[168:175] /*v[424:431]*/
	v_wmma_f32_16x16x32_bf16 v[160:167] /*v[416:423]*/, v[106:113] /*v[618:625]*/, v[50:57] /*v[562:569]*/, v[160:167] /*v[416:423]*/
	v_wmma_f32_16x16x32_bf16 v[152:159] /*v[408:415]*/, v[98:105] /*v[610:617]*/, v[50:57] /*v[562:569]*/, v[152:159] /*v[408:415]*/
	v_wmma_f32_16x16x32_bf16 v[144:151] /*v[400:407]*/, v[90:97] /*v[602:609]*/, v[50:57] /*v[562:569]*/, v[144:151] /*v[400:407]*/
	v_wmma_f32_16x16x32_bf16 v[120:127] /*v[376:383]*/, v[82:89] /*v[594:601]*/, v[50:57] /*v[562:569]*/, v[120:127] /*v[376:383]*/
	v_wmma_f32_16x16x32_bf16 v[88:95] /*v[344:351]*/, v[74:81] /*v[586:593]*/, v[50:57] /*v[562:569]*/, v[88:95] /*v[344:351]*/
	v_wmma_f32_16x16x32_bf16 v[176:183] /*v[432:439]*/, v[74:81] /*v[586:593]*/, v[58:65] /*v[570:577]*/, v[176:183] /*v[432:439]*/
	v_wmma_f32_16x16x32_bf16 v[184:191] /*v[440:447]*/, v[82:89] /*v[594:601]*/, v[58:65] /*v[570:577]*/, v[184:191] /*v[440:447]*/
	v_wmma_f32_16x16x32_bf16 v[200:207] /*v[456:463]*/, v[90:97] /*v[602:609]*/, v[58:65] /*v[570:577]*/, v[200:207] /*v[456:463]*/
	v_wmma_f32_16x16x32_bf16 v[208:215] /*v[464:471]*/, v[98:105] /*v[610:617]*/, v[58:65] /*v[570:577]*/, v[208:215] /*v[464:471]*/
	v_wmma_f32_16x16x32_bf16 v[216:223] /*v[472:479]*/, v[106:113] /*v[618:625]*/, v[58:65] /*v[570:577]*/, v[216:223] /*v[472:479]*/
	v_wmma_f32_16x16x32_bf16 v[232:239] /*v[488:495]*/, v[114:121] /*v[626:633]*/, v[58:65] /*v[570:577]*/, v[232:239] /*v[488:495]*/
	v_wmma_f32_16x16x32_bf16 v[240:247] /*v[496:503]*/, v[122:129] /*v[634:641]*/, v[58:65] /*v[570:577]*/, v[240:247] /*v[496:503]*/
	v_wmma_f32_16x16x32_bf16 v[248:255] /*v[504:511]*/, v[130:137] /*v[642:649]*/, v[58:65] /*v[570:577]*/, v[248:255] /*v[504:511]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[160:167], v[130:137] /*v[642:649]*/, v[66:73] /*v[578:585]*/, v[160:167]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[122:129] /*v[634:641]*/, v[66:73] /*v[578:585]*/, v[144:151]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[114:121] /*v[626:633]*/, v[66:73] /*v[578:585]*/, v[136:143]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[106:113] /*v[618:625]*/, v[66:73] /*v[578:585]*/, v[128:135]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[98:105] /*v[610:617]*/, v[66:73] /*v[578:585]*/, v[120:127]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[90:97] /*v[602:609]*/, v[66:73] /*v[578:585]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[82:89] /*v[594:601]*/, v[66:73] /*v[578:585]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[74:81] /*v[586:593]*/, v[66:73] /*v[578:585]*/, v[88:95]
	s_wait_tensorcnt 0x0
	s_barrier_signal -1
	v_wmma_f32_16x16x32_bf16 v[0:7], v[202:209] /*v[714:721]*/, v[138:145] /*v[650:657]*/, v[0:7]
	v_wmma_f32_16x16x32_bf16 v[8:15], v[210:217] /*v[722:729]*/, v[138:145] /*v[650:657]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[218:225] /*v[730:737]*/, v[138:145] /*v[650:657]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[226:233] /*v[738:745]*/, v[138:145] /*v[650:657]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[234:241] /*v[746:753]*/, v[138:145] /*v[650:657]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[242:249] /*v[754:761]*/, v[138:145] /*v[650:657]*/, v[48:55]
	s_set_vgpr_msb 0xa0b
	v_wmma_f32_16x16x32_bf16 v[64:71], v[10:17] /*v[778:785]*/, v[138:145] /*v[650:657]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[18:25] /*v[786:793]*/, v[138:145] /*v[650:657]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[224:231], v[18:25] /*v[786:793]*/, v[146:153] /*v[658:665]*/, v[224:231]
	v_wmma_f32_16x16x32_bf16 v[192:199], v[10:17] /*v[778:785]*/, v[146:153] /*v[658:665]*/, v[192:199]
	s_set_vgpr_msb 0xb0a
	v_wmma_f32_16x16x32_bf16 v[168:175], v[242:249] /*v[754:761]*/, v[146:153] /*v[658:665]*/, v[168:175]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[234:241] /*v[746:753]*/, v[146:153] /*v[658:665]*/, v[152:159]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[226:233] /*v[738:745]*/, v[146:153] /*v[658:665]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[218:225] /*v[730:737]*/, v[146:153] /*v[658:665]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[210:217] /*v[722:729]*/, v[146:153] /*v[658:665]*/, v[56:63]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[202:209] /*v[714:721]*/, v[146:153] /*v[658:665]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[202:209] /*v[714:721]*/, v[154:161] /*v[666:673]*/, v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[210:217] /*v[722:729]*/, v[154:161] /*v[666:673]*/, v[184:191]
	v_wmma_f32_16x16x32_bf16 v[200:207], v[218:225] /*v[730:737]*/, v[154:161] /*v[666:673]*/, v[200:207]
	v_wmma_f32_16x16x32_bf16 v[208:215], v[226:233] /*v[738:745]*/, v[154:161] /*v[666:673]*/, v[208:215]
	v_wmma_f32_16x16x32_bf16 v[216:223], v[234:241] /*v[746:753]*/, v[154:161] /*v[666:673]*/, v[216:223]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[56:63] /*v[312:319]*/, v[242:249] /*v[754:761]*/, v[154:161] /*v[666:673]*/, v[56:63] /*v[312:319]*/
	s_set_vgpr_msb 0x5a5b
	v_wmma_f32_16x16x32_bf16 v[48:55] /*v[304:311]*/, v[10:17] /*v[778:785]*/, v[154:161] /*v[666:673]*/, v[48:55] /*v[304:311]*/
	v_wmma_f32_16x16x32_bf16 v[40:47] /*v[296:303]*/, v[18:25] /*v[786:793]*/, v[154:161] /*v[666:673]*/, v[40:47] /*v[296:303]*/
	v_wmma_f32_16x16x32_bf16 v[32:39] /*v[288:295]*/, v[18:25] /*v[786:793]*/, v[162:169] /*v[674:681]*/, v[32:39] /*v[288:295]*/
	v_wmma_f32_16x16x32_bf16 v[24:31] /*v[280:287]*/, v[10:17] /*v[778:785]*/, v[162:169] /*v[674:681]*/, v[24:31] /*v[280:287]*/
	s_set_vgpr_msb 0x5b5a
	v_wmma_f32_16x16x32_bf16 v[16:23] /*v[272:279]*/, v[242:249] /*v[754:761]*/, v[162:169] /*v[674:681]*/, v[16:23] /*v[272:279]*/
	v_wmma_f32_16x16x32_bf16 v[8:15] /*v[264:271]*/, v[234:241] /*v[746:753]*/, v[162:169] /*v[674:681]*/, v[8:15] /*v[264:271]*/
	v_wmma_f32_16x16x32_bf16 v[0:7] /*v[256:263]*/, v[226:233] /*v[738:745]*/, v[162:169] /*v[674:681]*/, v[0:7] /*v[256:263]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[248:255], v[218:225] /*v[730:737]*/, v[162:169] /*v[674:681]*/, v[248:255]
	v_wmma_f32_16x16x32_bf16 v[240:247], v[210:217] /*v[722:729]*/, v[162:169] /*v[674:681]*/, v[240:247]
	v_wmma_f32_16x16x32_bf16 v[232:239], v[202:209] /*v[714:721]*/, v[162:169] /*v[674:681]*/, v[232:239]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[64:71] /*v[320:327]*/, v[202:209] /*v[714:721]*/, v[170:177] /*v[682:689]*/, v[64:71] /*v[320:327]*/
	v_wmma_f32_16x16x32_bf16 v[72:79] /*v[328:335]*/, v[210:217] /*v[722:729]*/, v[170:177] /*v[682:689]*/, v[72:79] /*v[328:335]*/
	v_wmma_f32_16x16x32_bf16 v[80:87] /*v[336:343]*/, v[218:225] /*v[730:737]*/, v[170:177] /*v[682:689]*/, v[80:87] /*v[336:343]*/
	v_wmma_f32_16x16x32_bf16 v[96:103] /*v[352:359]*/, v[226:233] /*v[738:745]*/, v[170:177] /*v[682:689]*/, v[96:103] /*v[352:359]*/
	v_wmma_f32_16x16x32_bf16 v[104:111] /*v[360:367]*/, v[234:241] /*v[746:753]*/, v[170:177] /*v[682:689]*/, v[104:111] /*v[360:367]*/
	v_wmma_f32_16x16x32_bf16 v[112:119] /*v[368:375]*/, v[242:249] /*v[754:761]*/, v[170:177] /*v[682:689]*/, v[112:119] /*v[368:375]*/
	s_set_vgpr_msb 0x5a5b
	v_wmma_f32_16x16x32_bf16 v[128:135] /*v[384:391]*/, v[10:17] /*v[778:785]*/, v[170:177] /*v[682:689]*/, v[128:135] /*v[384:391]*/
	v_wmma_f32_16x16x32_bf16 v[136:143] /*v[392:399]*/, v[18:25] /*v[786:793]*/, v[170:177] /*v[682:689]*/, v[136:143] /*v[392:399]*/
	v_wmma_f32_16x16x32_bf16 v[224:231] /*v[480:487]*/, v[18:25] /*v[786:793]*/, v[178:185] /*v[690:697]*/, v[224:231] /*v[480:487]*/
	v_wmma_f32_16x16x32_bf16 v[192:199] /*v[448:455]*/, v[10:17] /*v[778:785]*/, v[178:185] /*v[690:697]*/, v[192:199] /*v[448:455]*/
	s_set_vgpr_msb 0x5b5a
	v_wmma_f32_16x16x32_bf16 v[168:175] /*v[424:431]*/, v[242:249] /*v[754:761]*/, v[178:185] /*v[690:697]*/, v[168:175] /*v[424:431]*/
	v_wmma_f32_16x16x32_bf16 v[160:167] /*v[416:423]*/, v[234:241] /*v[746:753]*/, v[178:185] /*v[690:697]*/, v[160:167] /*v[416:423]*/
	v_wmma_f32_16x16x32_bf16 v[152:159] /*v[408:415]*/, v[226:233] /*v[738:745]*/, v[178:185] /*v[690:697]*/, v[152:159] /*v[408:415]*/
	v_wmma_f32_16x16x32_bf16 v[144:151] /*v[400:407]*/, v[218:225] /*v[730:737]*/, v[178:185] /*v[690:697]*/, v[144:151] /*v[400:407]*/
	v_wmma_f32_16x16x32_bf16 v[120:127] /*v[376:383]*/, v[210:217] /*v[722:729]*/, v[178:185] /*v[690:697]*/, v[120:127] /*v[376:383]*/
	v_wmma_f32_16x16x32_bf16 v[88:95] /*v[344:351]*/, v[202:209] /*v[714:721]*/, v[178:185] /*v[690:697]*/, v[88:95] /*v[344:351]*/
	v_wmma_f32_16x16x32_bf16 v[176:183] /*v[432:439]*/, v[202:209] /*v[714:721]*/, v[186:193] /*v[698:705]*/, v[176:183] /*v[432:439]*/
	v_wmma_f32_16x16x32_bf16 v[184:191] /*v[440:447]*/, v[210:217] /*v[722:729]*/, v[186:193] /*v[698:705]*/, v[184:191] /*v[440:447]*/
	v_wmma_f32_16x16x32_bf16 v[200:207] /*v[456:463]*/, v[218:225] /*v[730:737]*/, v[186:193] /*v[698:705]*/, v[200:207] /*v[456:463]*/
	v_wmma_f32_16x16x32_bf16 v[208:215] /*v[464:471]*/, v[226:233] /*v[738:745]*/, v[186:193] /*v[698:705]*/, v[208:215] /*v[464:471]*/
	v_wmma_f32_16x16x32_bf16 v[216:223] /*v[472:479]*/, v[234:241] /*v[746:753]*/, v[186:193] /*v[698:705]*/, v[216:223] /*v[472:479]*/
	v_wmma_f32_16x16x32_bf16 v[232:239] /*v[488:495]*/, v[242:249] /*v[754:761]*/, v[186:193] /*v[698:705]*/, v[232:239] /*v[488:495]*/
	s_set_vgpr_msb 0x5a5b
	v_wmma_f32_16x16x32_bf16 v[240:247] /*v[496:503]*/, v[10:17] /*v[778:785]*/, v[186:193] /*v[698:705]*/, v[240:247] /*v[496:503]*/
	v_wmma_f32_16x16x32_bf16 v[248:255] /*v[504:511]*/, v[18:25] /*v[786:793]*/, v[186:193] /*v[698:705]*/, v[248:255] /*v[504:511]*/
	s_set_vgpr_msb 0x5b0b
	v_wmma_f32_16x16x32_bf16 v[160:167], v[18:25] /*v[786:793]*/, v[194:201] /*v[706:713]*/, v[160:167]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[10:17] /*v[778:785]*/, v[194:201] /*v[706:713]*/, v[144:151]
	s_set_vgpr_msb 0xb0a
	v_wmma_f32_16x16x32_bf16 v[136:143], v[242:249] /*v[754:761]*/, v[194:201] /*v[706:713]*/, v[136:143]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[234:241] /*v[746:753]*/, v[194:201] /*v[706:713]*/, v[128:135]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[226:233] /*v[738:745]*/, v[194:201] /*v[706:713]*/, v[120:127]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[218:225] /*v[730:737]*/, v[194:201] /*v[706:713]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[210:217] /*v[722:729]*/, v[194:201] /*v[706:713]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[202:209] /*v[714:721]*/, v[194:201] /*v[706:713]*/, v[88:95]
	s_add_co_i32 s42, s42, -1
	s_barrier_wait -1
	s_mul_hi_i32 s1, s42, 0x55555556
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_lshr_b32 s3, s1, 31
	s_add_co_i32 s1, s1, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s1, s1, 3
	s_sub_co_i32 s1, s42, s1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s1, s1, 0x11800
	s_add_co_i32 s1, s1, 0
	s_set_vgpr_msb 0xa8c
	v_add_nc_u32_e32 v2 /*v514*/, s1, v7 /*v775*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8c88
	v_add_nc_u32_e32 v36 /*v548*/, s1, v34 /*v546*/
	s_set_vgpr_msb 0x888c
	v_dual_add_nc_u32 v3 /*v515*/, s1, v8 /*v776*/ :: v_dual_add_nc_u32 v4 /*v516*/, s1, v9 /*v777*/
	s_set_vgpr_msb 0x8c8a
	v_add_nc_u32_e32 v0 /*v512*/, s1, v0 /*v512*/
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[42:45] /*v[554:557]*/, v2 /*v514*/
	ds_load_b128 v[46:49] /*v[558:561]*/, v2 /*v514*/ offset:32
	ds_load_b128 v[50:53] /*v[562:565]*/, v2 /*v514*/ offset:2304
	ds_load_b128 v[54:57] /*v[566:569]*/, v2 /*v514*/ offset:2336
	ds_load_b128 v[58:61] /*v[570:573]*/, v2 /*v514*/ offset:4608
	ds_load_b128 v[62:65] /*v[574:577]*/, v2 /*v514*/ offset:4640
	ds_load_b128 v[66:69] /*v[578:581]*/, v2 /*v514*/ offset:6912
	ds_load_b128 v[70:73] /*v[582:585]*/, v2 /*v514*/ offset:6944
	ds_load_b128 v[74:77] /*v[586:589]*/, v2 /*v514*/ offset:9216
	ds_load_b128 v[78:81] /*v[590:593]*/, v2 /*v514*/ offset:9248
	ds_load_b128 v[82:85] /*v[594:597]*/, v2 /*v514*/ offset:11520
	ds_load_b128 v[86:89] /*v[598:601]*/, v2 /*v514*/ offset:11552
	ds_load_b128 v[90:93] /*v[602:605]*/, v2 /*v514*/ offset:13824
	ds_load_b128 v[94:97] /*v[606:609]*/, v2 /*v514*/ offset:13856
	ds_load_b128 v[98:101] /*v[610:613]*/, v3 /*v515*/
	ds_load_b128 v[102:105] /*v[614:617]*/, v4 /*v516*/
	ds_load_tr16_b128 v[110:113] /*v[622:625]*/, v36 /*v548*/ offset:8704
	ds_load_tr16_b128 v[106:109] /*v[618:621]*/, v36 /*v548*/
	ds_load_tr16_b128 v[114:117] /*v[626:629]*/, v36 /*v548*/ offset:32
	ds_load_tr16_b128 v[118:121] /*v[630:633]*/, v36 /*v548*/ offset:8736
	ds_load_tr16_b128 v[122:125] /*v[634:637]*/, v36 /*v548*/ offset:64
	ds_load_tr16_b128 v[126:129] /*v[638:641]*/, v36 /*v548*/ offset:8768
	ds_load_tr16_b128 v[130:133] /*v[642:645]*/, v36 /*v548*/ offset:96
	ds_load_tr16_b128 v[134:137] /*v[646:649]*/, v36 /*v548*/ offset:8800
	ds_load_tr16_b128 v[138:141] /*v[650:653]*/, v36 /*v548*/ offset:128
	ds_load_tr16_b128 v[142:145] /*v[654:657]*/, v36 /*v548*/ offset:8832
	ds_load_tr16_b128 v[146:149] /*v[658:661]*/, v36 /*v548*/ offset:160
	ds_load_tr16_b128 v[150:153] /*v[662:665]*/, v36 /*v548*/ offset:8864
	ds_load_tr16_b128 v[154:157] /*v[666:669]*/, v36 /*v548*/ offset:192
	v_add_nc_u32_e32 v1 /*v513*/, s1, v1 /*v513*/
	ds_load_tr16_b128 v[158:161] /*v[670:673]*/, v36 /*v548*/ offset:8896
	ds_load_tr16_b128 v[162:165] /*v[674:677]*/, v36 /*v548*/ offset:224
	ds_load_tr16_b128 v[166:169] /*v[678:681]*/, v36 /*v548*/ offset:8928
	ds_load_b128 v[170:173] /*v[682:685]*/, v0 /*v512*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x8a8e
	v_dual_add_nc_u32 v0 /*v512*/, s1, v5 /*v773*/ :: v_dual_add_nc_u32 v4 /*v516*/, s1, v6 /*v774*/
	s_wait_alu depctr_va_vdst(1)
	ds_load_b128 v[174:177] /*v[686:689]*/, v1 /*v513*/
	ds_load_b128 v[178:181] /*v[690:693]*/, v2 /*v514*/ offset:2368
	ds_load_b128 v[182:185] /*v[694:697]*/, v2 /*v514*/ offset:2400
	ds_load_b128 v[186:189] /*v[698:701]*/, v2 /*v514*/ offset:4672
	ds_load_b128 v[190:193] /*v[702:705]*/, v2 /*v514*/ offset:4704
	ds_load_b128 v[194:197] /*v[706:709]*/, v2 /*v514*/ offset:6976
	ds_load_b128 v[198:201] /*v[710:713]*/, v2 /*v514*/ offset:7008
	ds_load_b128 v[202:205] /*v[714:717]*/, v2 /*v514*/ offset:9280
	ds_load_b128 v[206:209] /*v[718:721]*/, v2 /*v514*/ offset:9312
	ds_load_b128 v[210:213] /*v[722:725]*/, v2 /*v514*/ offset:11584
	ds_load_b128 v[214:217] /*v[726:729]*/, v2 /*v514*/ offset:11616
	ds_load_b128 v[218:221] /*v[730:733]*/, v2 /*v514*/ offset:13888
	ds_load_b128 v[222:225] /*v[734:737]*/, v2 /*v514*/ offset:13920
	s_wait_alu depctr_va_vdst(0) depctr_vm_vsrc(0)
	ds_load_b128 v[0:3] /*v[512:515]*/, v0 /*v512*/
	ds_load_b128 v[4:7] /*v[516:519]*/, v4 /*v516*/
	ds_load_tr16_b128 v[226:229] /*v[738:741]*/, v36 /*v548*/ offset:17408
	ds_load_tr16_b128 v[230:233] /*v[742:745]*/, v36 /*v548*/ offset:26112
	ds_load_tr16_b128 v[24:27] /*v[536:539]*/, v36 /*v548*/ offset:17440
	ds_load_tr16_b128 v[28:31] /*v[540:543]*/, v36 /*v548*/ offset:26144
	ds_load_tr16_b128 v[234:237] /*v[746:749]*/, v36 /*v548*/ offset:17472
	ds_load_tr16_b128 v[238:241] /*v[750:753]*/, v36 /*v548*/ offset:26176
	ds_load_tr16_b128 v[8:11] /*v[520:523]*/, v36 /*v548*/ offset:17504
	ds_load_tr16_b128 v[12:15] /*v[524:527]*/, v36 /*v548*/ offset:26208
	ds_load_tr16_b128 v[242:245] /*v[754:757]*/, v36 /*v548*/ offset:17536
	ds_load_tr16_b128 v[246:249] /*v[758:761]*/, v36 /*v548*/ offset:26240
	ds_load_tr16_b128 v[16:19] /*v[528:531]*/, v36 /*v548*/ offset:17568
	ds_load_tr16_b128 v[20:23] /*v[532:535]*/, v36 /*v548*/ offset:26272
	s_set_vgpr_msb 0x8ec2
	ds_load_tr16_b128 v[6:9] /*v[774:777]*/, v36 /*v548*/ offset:17600
	ds_load_tr16_b128 v[10:13] /*v[778:781]*/, v36 /*v548*/ offset:26304
	s_set_vgpr_msb 0xc282
	ds_load_tr16_b128 v[32:35] /*v[544:547]*/, v36 /*v548*/ offset:17632
	s_wait_alu depctr_vm_vsrc(0)
	ds_load_tr16_b128 v[36:39] /*v[548:551]*/, v36 /*v548*/ offset:26336
	s_set_vgpr_msb 0x820a
	s_wait_dscnt 0x2e
	v_wmma_f32_16x16x32_bf16 v[0:7], v[106:113] /*v[618:625]*/, v[42:49] /*v[554:561]*/, v[0:7]
	s_wait_dscnt 0x0
	v_wmma_f32_16x16x32_bf16 v[8:15], v[114:121] /*v[626:633]*/, v[42:49] /*v[554:561]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[122:129] /*v[634:641]*/, v[42:49] /*v[554:561]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[130:137] /*v[642:649]*/, v[42:49] /*v[554:561]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[138:145] /*v[650:657]*/, v[42:49] /*v[554:561]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[146:153] /*v[658:665]*/, v[42:49] /*v[554:561]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[154:161] /*v[666:673]*/, v[42:49] /*v[554:561]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[162:169] /*v[674:681]*/, v[42:49] /*v[554:561]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[224:231], v[162:169] /*v[674:681]*/, v[50:57] /*v[562:569]*/, v[224:231]
	v_wmma_f32_16x16x32_bf16 v[192:199], v[154:161] /*v[666:673]*/, v[50:57] /*v[562:569]*/, v[192:199]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[146:153] /*v[658:665]*/, v[50:57] /*v[562:569]*/, v[168:175]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[138:145] /*v[650:657]*/, v[50:57] /*v[562:569]*/, v[152:159]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[130:137] /*v[642:649]*/, v[50:57] /*v[562:569]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[122:129] /*v[634:641]*/, v[50:57] /*v[562:569]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[114:121] /*v[626:633]*/, v[50:57] /*v[562:569]*/, v[56:63]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[106:113] /*v[618:625]*/, v[50:57] /*v[562:569]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[106:113] /*v[618:625]*/, v[58:65] /*v[570:577]*/, v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[114:121] /*v[626:633]*/, v[58:65] /*v[570:577]*/, v[184:191]
	v_wmma_f32_16x16x32_bf16 v[200:207], v[122:129] /*v[634:641]*/, v[58:65] /*v[570:577]*/, v[200:207]
	v_wmma_f32_16x16x32_bf16 v[208:215], v[130:137] /*v[642:649]*/, v[58:65] /*v[570:577]*/, v[208:215]
	v_wmma_f32_16x16x32_bf16 v[216:223], v[138:145] /*v[650:657]*/, v[58:65] /*v[570:577]*/, v[216:223]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[56:63] /*v[312:319]*/, v[146:153] /*v[658:665]*/, v[58:65] /*v[570:577]*/, v[56:63] /*v[312:319]*/
	v_wmma_f32_16x16x32_bf16 v[48:55] /*v[304:311]*/, v[154:161] /*v[666:673]*/, v[58:65] /*v[570:577]*/, v[48:55] /*v[304:311]*/
	v_wmma_f32_16x16x32_bf16 v[40:47] /*v[296:303]*/, v[162:169] /*v[674:681]*/, v[58:65] /*v[570:577]*/, v[40:47] /*v[296:303]*/
	v_wmma_f32_16x16x32_bf16 v[32:39] /*v[288:295]*/, v[162:169] /*v[674:681]*/, v[66:73] /*v[578:585]*/, v[32:39] /*v[288:295]*/
	v_wmma_f32_16x16x32_bf16 v[24:31] /*v[280:287]*/, v[154:161] /*v[666:673]*/, v[66:73] /*v[578:585]*/, v[24:31] /*v[280:287]*/
	v_wmma_f32_16x16x32_bf16 v[16:23] /*v[272:279]*/, v[146:153] /*v[658:665]*/, v[66:73] /*v[578:585]*/, v[16:23] /*v[272:279]*/
	v_wmma_f32_16x16x32_bf16 v[8:15] /*v[264:271]*/, v[138:145] /*v[650:657]*/, v[66:73] /*v[578:585]*/, v[8:15] /*v[264:271]*/
	v_wmma_f32_16x16x32_bf16 v[0:7] /*v[256:263]*/, v[130:137] /*v[642:649]*/, v[66:73] /*v[578:585]*/, v[0:7] /*v[256:263]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[248:255], v[122:129] /*v[634:641]*/, v[66:73] /*v[578:585]*/, v[248:255]
	v_wmma_f32_16x16x32_bf16 v[240:247], v[114:121] /*v[626:633]*/, v[66:73] /*v[578:585]*/, v[240:247]
	v_wmma_f32_16x16x32_bf16 v[232:239], v[106:113] /*v[618:625]*/, v[66:73] /*v[578:585]*/, v[232:239]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[64:71] /*v[320:327]*/, v[106:113] /*v[618:625]*/, v[74:81] /*v[586:593]*/, v[64:71] /*v[320:327]*/
	v_wmma_f32_16x16x32_bf16 v[72:79] /*v[328:335]*/, v[114:121] /*v[626:633]*/, v[74:81] /*v[586:593]*/, v[72:79] /*v[328:335]*/
	v_wmma_f32_16x16x32_bf16 v[80:87] /*v[336:343]*/, v[122:129] /*v[634:641]*/, v[74:81] /*v[586:593]*/, v[80:87] /*v[336:343]*/
	v_wmma_f32_16x16x32_bf16 v[96:103] /*v[352:359]*/, v[130:137] /*v[642:649]*/, v[74:81] /*v[586:593]*/, v[96:103] /*v[352:359]*/
	v_wmma_f32_16x16x32_bf16 v[104:111] /*v[360:367]*/, v[138:145] /*v[650:657]*/, v[74:81] /*v[586:593]*/, v[104:111] /*v[360:367]*/
	v_wmma_f32_16x16x32_bf16 v[112:119] /*v[368:375]*/, v[146:153] /*v[658:665]*/, v[74:81] /*v[586:593]*/, v[112:119] /*v[368:375]*/
	v_wmma_f32_16x16x32_bf16 v[128:135] /*v[384:391]*/, v[154:161] /*v[666:673]*/, v[74:81] /*v[586:593]*/, v[128:135] /*v[384:391]*/
	v_wmma_f32_16x16x32_bf16 v[136:143] /*v[392:399]*/, v[162:169] /*v[674:681]*/, v[74:81] /*v[586:593]*/, v[136:143] /*v[392:399]*/
	v_wmma_f32_16x16x32_bf16 v[224:231] /*v[480:487]*/, v[162:169] /*v[674:681]*/, v[82:89] /*v[594:601]*/, v[224:231] /*v[480:487]*/
	v_wmma_f32_16x16x32_bf16 v[192:199] /*v[448:455]*/, v[154:161] /*v[666:673]*/, v[82:89] /*v[594:601]*/, v[192:199] /*v[448:455]*/
	v_wmma_f32_16x16x32_bf16 v[168:175] /*v[424:431]*/, v[146:153] /*v[658:665]*/, v[82:89] /*v[594:601]*/, v[168:175] /*v[424:431]*/
	v_wmma_f32_16x16x32_bf16 v[160:167] /*v[416:423]*/, v[138:145] /*v[650:657]*/, v[82:89] /*v[594:601]*/, v[160:167] /*v[416:423]*/
	v_wmma_f32_16x16x32_bf16 v[152:159] /*v[408:415]*/, v[130:137] /*v[642:649]*/, v[82:89] /*v[594:601]*/, v[152:159] /*v[408:415]*/
	v_wmma_f32_16x16x32_bf16 v[144:151] /*v[400:407]*/, v[122:129] /*v[634:641]*/, v[82:89] /*v[594:601]*/, v[144:151] /*v[400:407]*/
	v_wmma_f32_16x16x32_bf16 v[120:127] /*v[376:383]*/, v[114:121] /*v[626:633]*/, v[82:89] /*v[594:601]*/, v[120:127] /*v[376:383]*/
	v_wmma_f32_16x16x32_bf16 v[88:95] /*v[344:351]*/, v[106:113] /*v[618:625]*/, v[82:89] /*v[594:601]*/, v[88:95] /*v[344:351]*/
	v_wmma_f32_16x16x32_bf16 v[176:183] /*v[432:439]*/, v[106:113] /*v[618:625]*/, v[90:97] /*v[602:609]*/, v[176:183] /*v[432:439]*/
	v_wmma_f32_16x16x32_bf16 v[184:191] /*v[440:447]*/, v[114:121] /*v[626:633]*/, v[90:97] /*v[602:609]*/, v[184:191] /*v[440:447]*/
	v_wmma_f32_16x16x32_bf16 v[200:207] /*v[456:463]*/, v[122:129] /*v[634:641]*/, v[90:97] /*v[602:609]*/, v[200:207] /*v[456:463]*/
	v_wmma_f32_16x16x32_bf16 v[208:215] /*v[464:471]*/, v[130:137] /*v[642:649]*/, v[90:97] /*v[602:609]*/, v[208:215] /*v[464:471]*/
	v_wmma_f32_16x16x32_bf16 v[216:223] /*v[472:479]*/, v[138:145] /*v[650:657]*/, v[90:97] /*v[602:609]*/, v[216:223] /*v[472:479]*/
	v_wmma_f32_16x16x32_bf16 v[232:239] /*v[488:495]*/, v[146:153] /*v[658:665]*/, v[90:97] /*v[602:609]*/, v[232:239] /*v[488:495]*/
	v_wmma_f32_16x16x32_bf16 v[240:247] /*v[496:503]*/, v[154:161] /*v[666:673]*/, v[90:97] /*v[602:609]*/, v[240:247] /*v[496:503]*/
	v_wmma_f32_16x16x32_bf16 v[248:255] /*v[504:511]*/, v[162:169] /*v[674:681]*/, v[90:97] /*v[602:609]*/, v[248:255] /*v[504:511]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[160:167], v[162:169] /*v[674:681]*/, v[98:105] /*v[610:617]*/, v[160:167]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[154:161] /*v[666:673]*/, v[98:105] /*v[610:617]*/, v[144:151]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[146:153] /*v[658:665]*/, v[98:105] /*v[610:617]*/, v[136:143]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[138:145] /*v[650:657]*/, v[98:105] /*v[610:617]*/, v[128:135]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[130:137] /*v[642:649]*/, v[98:105] /*v[610:617]*/, v[120:127]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[122:129] /*v[634:641]*/, v[98:105] /*v[610:617]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[114:121] /*v[626:633]*/, v[98:105] /*v[610:617]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[106:113] /*v[618:625]*/, v[98:105] /*v[610:617]*/, v[88:95]
	s_set_vgpr_msb 0xa8c
	v_or_b32_e32 v41 /*v553*/, s24, v4 /*v772*/
	s_set_vgpr_msb 0x8c0a
	v_wmma_f32_16x16x32_bf16 v[0:7], v[226:233] /*v[738:745]*/, v[170:177] /*v[682:689]*/, v[0:7]
	s_wait_tensorcnt 0x0
	s_set_vgpr_msb 0xa88
	s_barrier_signal -1
	v_lshlrev_b32_e32 v41 /*v553*/, 1, v41 /*v553*/
	s_barrier_wait -1
	s_mul_u64 s[10:11], s[36:37], s[34:35]
	s_set_vgpr_msb 0x880a
	v_wmma_f32_16x16x32_bf16 v[8:15], v[24:31] /*v[536:543]*/, v[170:177] /*v[682:689]*/, v[8:15]
	v_nop
	v_nop
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v7, v6, v7
	v_cvt_pk_bf16_f32 v6, v4, v5
	v_cvt_pk_bf16_f32 v5, v2, v3
	v_cvt_pk_bf16_f32 v4, v0, v1
	s_ashr_i32 s3, s2, 31
	s_lshl_b64 s[10:11], s[10:11], 1
	s_lshl_b64 s[2:3], s[2:3], 1
	v_cvt_pk_bf16_f32 v3, v14, v15
	s_set_vgpr_msb 35
	v_lshl_or_b32 v14, v1 /*v769*/, 9, v41 /*v553*/
	s_set_vgpr_msb 0x230a
	v_wmma_f32_16x16x32_bf16 v[16:23], v[234:241] /*v[746:753]*/, v[170:177] /*v[682:689]*/, v[16:23]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v2, v12, v13
	v_cvt_pk_bf16_f32 v1, v10, v11
	v_cvt_pk_bf16_f32 v0, v8, v9
	v_add_nc_u32_e32 v13, 0, v14
	s_cmp_lg_u32 s34, 0x80000000
	s_set_vgpr_msb 34
	v_lshl_or_b32 v12, v40 /*v552*/, 9, v41 /*v553*/
	s_cselect_b32 s13, s35, 0
	s_set_vgpr_msb 0x220a
	v_wmma_f32_16x16x32_bf16 v[32:39], v[8:15] /*v[520:527]*/, v[170:177] /*v[682:689]*/, v[32:39]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v11, v22, v23
	v_cvt_pk_bf16_f32 v10, v20, v21
	v_cvt_pk_bf16_f32 v9, v18, v19
	v_cvt_pk_bf16_f32 v8, v16, v17
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v13, v[0:3] offset:32
	ds_store_b128 v13, v[4:7]
	s_cselect_b32 s12, s34, 0x100
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[40:47], v[242:249] /*v[754:761]*/, v[170:177] /*v[682:689]*/, v[40:47]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v3, v38, v39
	v_cvt_pk_bf16_f32 v2, v36, v37
	v_cvt_pk_bf16_f32 v1, v34, v35
	v_cvt_pk_bf16_f32 v0, v32, v33
	ds_store_b128 v13, v[8:11] offset:64
	s_bfe_u32 s1, ttmp8, 0x50019
	v_add_nc_u32_e32 v32, 0, v12
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[48:55], v[16:23] /*v[528:535]*/, v[170:177] /*v[682:689]*/, v[48:55]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v5, v46, v47
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v13, v[0:3] offset:96
	v_cvt_pk_bf16_f32 v4, v44, v45
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v42, v43
	v_cvt_pk_bf16_f32 v2, v40, v41
	s_and_b32 s1, s1, 3
	s_add_nc_u64 s[4:5], s[4:5], s[10:11]
	s_set_vgpr_msb 11
	v_wmma_f32_16x16x32_bf16 v[64:71], v[6:13] /*v[774:781]*/, v[170:177] /*v[682:689]*/, v[64:71]
	s_set_vgpr_msb 0xb00
	v_cvt_pk_bf16_f32 v9, v54, v55
	v_cvt_pk_bf16_f32 v8, v52, v53
	v_cvt_pk_bf16_f32 v7, v50, v51
	v_cvt_pk_bf16_f32 v6, v48, v49
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v13, v[2:5] offset:128
	s_lshl_b32 s6, s1, 7
	s_lshl_b32 s14, s1, 6
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[72:79], v[32:39] /*v[544:551]*/, v[170:177] /*v[682:689]*/, v[72:79]
	s_set_vgpr_msb 0xa00
	ds_store_b128 v13, v[6:9] offset:160
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v3, v70, v71
	v_cvt_pk_bf16_f32 v2, v68, v69
	v_cvt_pk_bf16_f32 v1, v66, v67
	v_cvt_pk_bf16_f32 v0, v64, v65
	s_lshl_b32 s1, s1, 15
	s_add_nc_u64 s[2:3], s[4:5], s[2:3]
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[224:231], v[32:39] /*v[544:551]*/, v[178:185] /*v[690:697]*/, v[224:231]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v7, v78, v79
	v_cvt_pk_bf16_f32 v6, v76, v77
	v_cvt_pk_bf16_f32 v5, v74, v75
	v_cvt_pk_bf16_f32 v4, v72, v73
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v13, v[0:3] offset:192
	s_mul_u64 s[4:5], s[12:13], s[6:7]
	s_add_co_i32 s9, s1, 0
	s_set_vgpr_msb 11
	v_wmma_f32_16x16x32_bf16 v[192:199], v[6:13] /*v[774:781]*/, v[178:185] /*v[690:697]*/, v[192:199]
	s_set_vgpr_msb 0xb00
	ds_store_b128 v13, v[4:7] offset:224
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v3, v230, v231
	v_cvt_pk_bf16_f32 v2, v228, v229
	v_cvt_pk_bf16_f32 v1, v226, v227
	v_cvt_pk_bf16_f32 v0, v224, v225
	s_sub_co_i32 s1, s33, s14
	s_add_nc_u64 s[10:11], s[4:5], s[2:3]
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[168:175], v[16:23] /*v[528:535]*/, v[178:185] /*v[690:697]*/, v[168:175]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v7, v198, v199
	v_cvt_pk_bf16_f32 v6, v196, v197
	v_cvt_pk_bf16_f32 v5, v194, v195
	v_cvt_pk_bf16_f32 v4, v192, v193
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v13, v[0:3] offset:8416
	s_max_i32 s3, s1, 0
	s_max_i32 s2, s0, 0
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[152:159], v[242:249] /*v[754:761]*/, v[178:185] /*v[690:697]*/, v[152:159]
	s_set_vgpr_msb 0xa00
	ds_store_b128 v13, v[4:7] offset:8384
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v3, v174, v175
	v_cvt_pk_bf16_f32 v2, v172, v173
	v_cvt_pk_bf16_f32 v1, v170, v171
	v_cvt_pk_bf16_f32 v0, v168, v169
	s_lshr_b32 s0, s3, 16
	s_lshl_b32 s1, s2, 16
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[112:119], v[8:15] /*v[520:527]*/, v[178:185] /*v[690:697]*/, v[112:119]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v7, v158, v159
	v_cvt_pk_bf16_f32 v6, v156, v157
	v_cvt_pk_bf16_f32 v5, v154, v155
	v_cvt_pk_bf16_f32 v4, v152, v153
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v13, v[0:3] offset:8352
	s_lshr_b64 s[2:3], s[2:3], 16
	s_mov_b32 s8, 1
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[80:87], v[234:241] /*v[746:753]*/, v[178:185] /*v[690:697]*/, v[80:87]
	s_set_vgpr_msb 0xa00
	ds_store_b128 v13, v[4:7] offset:8320
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v3, v118, v119
	v_cvt_pk_bf16_f32 v2, v116, v117
	v_cvt_pk_bf16_f32 v1, v114, v115
	v_cvt_pk_bf16_f32 v0, v112, v113
	s_bitset1_b32 s11, 31
	s_or_b32 s3, s0, 0x1000000
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[56:63], v[24:31] /*v[536:543]*/, v[178:185] /*v[690:697]*/, v[56:63]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v7, v86, v87
	v_cvt_pk_bf16_f32 v6, v84, v85
	v_cvt_pk_bf16_f32 v5, v82, v83
	v_cvt_pk_bf16_f32 v4, v80, v81
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v13, v[0:3] offset:8288
	s_and_b32 s6, s13, 0xffff
	s_mov_b32 s4, 64
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[24:31], v[226:233] /*v[738:745]*/, v[178:185] /*v[690:697]*/, v[24:31]
	s_set_vgpr_msb 0xa00
	ds_store_b128 v13, v[4:7] offset:8256
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v3, v62, v63
	v_cvt_pk_bf16_f32 v2, v60, v61
	v_cvt_pk_bf16_f32 v1, v58, v59
	v_cvt_pk_bf16_f32 v0, v56, v57
	s_mov_b32 s0, 0x10000
	s_mov_b32 s5, s12
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[176:183], v[226:233] /*v[738:745]*/, v[186:193] /*v[698:705]*/, v[176:183]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v7, v30, v31
	v_cvt_pk_bf16_f32 v6, v28, v29
	v_cvt_pk_bf16_f32 v5, v26, v27
	v_cvt_pk_bf16_f32 v4, v24, v25
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v13, v[0:3] offset:8224
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v182, v183
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[184:191], v[24:31] /*v[536:543]*/, v[186:193] /*v[698:705]*/, v[184:191]
	s_set_vgpr_msb 0xa00
	ds_store_b128 v13, v[4:7] offset:8192
	v_cvt_pk_bf16_f32 v2, v180, v181
	v_cvt_pk_bf16_f32 v1, v178, v179
	v_cvt_pk_bf16_f32 v0, v176, v177
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v13, v[0:3] offset:16384
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[200:207], v[234:241] /*v[746:753]*/, v[186:193] /*v[698:705]*/, v[200:207]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v7, v190, v191
	v_cvt_pk_bf16_f32 v6, v188, v189
	v_cvt_pk_bf16_f32 v5, v186, v187
	v_cvt_pk_bf16_f32 v4, v184, v185
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v206, v207
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[208:215], v[8:15] /*v[520:527]*/, v[186:193] /*v[698:705]*/, v[208:215]
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0xa00
	ds_store_b128 v13, v[4:7] offset:16416
	v_cvt_pk_bf16_f32 v2, v204, v205
	v_cvt_pk_bf16_f32 v1, v202, v203
	v_cvt_pk_bf16_f32 v0, v200, v201
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v13, v[0:3] offset:16448
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[216:223], v[242:249] /*v[754:761]*/, v[186:193] /*v[698:705]*/, v[216:223]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v7, v214, v215
	v_cvt_pk_bf16_f32 v6, v212, v213
	v_cvt_pk_bf16_f32 v5, v210, v211
	v_cvt_pk_bf16_f32 v4, v208, v209
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v222, v223
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[56:63] /*v[312:319]*/, v[16:23] /*v[528:535]*/, v[186:193] /*v[698:705]*/, v[56:63] /*v[312:319]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5a00
	ds_store_b128 v13, v[4:7] offset:16480
	v_cvt_pk_bf16_f32 v2, v220, v221
	v_cvt_pk_bf16_f32 v1, v218, v219
	v_cvt_pk_bf16_f32 v0, v216, v217
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v13, v[0:3] offset:16512
	s_set_vgpr_msb 0x5b
	v_wmma_f32_16x16x32_bf16 v[48:55] /*v[304:311]*/, v[6:13] /*v[774:781]*/, v[186:193] /*v[698:705]*/, v[48:55] /*v[304:311]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5b05
	v_cvt_pk_bf16_f32 v7, v62 /*v318*/, v63 /*v319*/
	v_cvt_pk_bf16_f32 v6, v60 /*v316*/, v61 /*v317*/
	v_cvt_pk_bf16_f32 v5, v58 /*v314*/, v59 /*v315*/
	v_cvt_pk_bf16_f32 v4, v56 /*v312*/, v57 /*v313*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v54 /*v310*/, v55 /*v311*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[40:47] /*v[296:303]*/, v[32:39] /*v[544:551]*/, v[186:193] /*v[698:705]*/, v[40:47] /*v[296:303]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5a00
	ds_store_b128 v13, v[4:7] offset:16544
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v52 /*v308*/, v53 /*v309*/
	v_cvt_pk_bf16_f32 v1, v50 /*v306*/, v51 /*v307*/
	v_cvt_pk_bf16_f32 v0, v48 /*v304*/, v49 /*v305*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:16576
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[32:39] /*v[288:295]*/, v[32:39] /*v[544:551]*/, v[194:201] /*v[706:713]*/, v[32:39] /*v[288:295]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v7, v46 /*v302*/, v47 /*v303*/
	v_cvt_pk_bf16_f32 v6, v44 /*v300*/, v45 /*v301*/
	v_cvt_pk_bf16_f32 v5, v42 /*v298*/, v43 /*v299*/
	v_cvt_pk_bf16_f32 v4, v40 /*v296*/, v41 /*v297*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v38 /*v294*/, v39 /*v295*/
	s_set_vgpr_msb 0x55b
	v_wmma_f32_16x16x32_bf16 v[24:31] /*v[280:287]*/, v[6:13] /*v[774:781]*/, v[194:201] /*v[706:713]*/, v[24:31] /*v[280:287]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5b00
	ds_store_b128 v13, v[4:7] offset:16608
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v36 /*v292*/, v37 /*v293*/
	v_cvt_pk_bf16_f32 v1, v34 /*v290*/, v35 /*v291*/
	v_cvt_pk_bf16_f32 v0, v32 /*v288*/, v33 /*v289*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:24800
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[16:23] /*v[272:279]*/, v[16:23] /*v[528:535]*/, v[194:201] /*v[706:713]*/, v[16:23] /*v[272:279]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v7, v30 /*v286*/, v31 /*v287*/
	v_cvt_pk_bf16_f32 v6, v28 /*v284*/, v29 /*v285*/
	v_cvt_pk_bf16_f32 v5, v26 /*v282*/, v27 /*v283*/
	v_cvt_pk_bf16_f32 v4, v24 /*v280*/, v25 /*v281*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v22 /*v278*/, v23 /*v279*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[8:15] /*v[264:271]*/, v[242:249] /*v[754:761]*/, v[194:201] /*v[706:713]*/, v[8:15] /*v[264:271]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5a00
	ds_store_b128 v13, v[4:7] offset:24768
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v20 /*v276*/, v21 /*v277*/
	v_cvt_pk_bf16_f32 v1, v18 /*v274*/, v19 /*v275*/
	v_cvt_pk_bf16_f32 v0, v16 /*v272*/, v17 /*v273*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:24736
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[0:7] /*v[256:263]*/, v[8:15] /*v[520:527]*/, v[194:201] /*v[706:713]*/, v[0:7] /*v[256:263]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v7, v14 /*v270*/, v15 /*v271*/
	v_cvt_pk_bf16_f32 v6, v12 /*v268*/, v13 /*v269*/
	v_cvt_pk_bf16_f32 v5, v10 /*v266*/, v11 /*v267*/
	v_cvt_pk_bf16_f32 v4, v8 /*v264*/, v9 /*v265*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v6 /*v262*/, v7 /*v263*/
	s_set_vgpr_msb 0x50a
	v_wmma_f32_16x16x32_bf16 v[248:255], v[234:241] /*v[746:753]*/, v[194:201] /*v[706:713]*/, v[248:255]
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0xa00
	ds_store_b128 v13, v[4:7] offset:24704
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v4 /*v260*/, v5 /*v261*/
	v_cvt_pk_bf16_f32 v1, v2 /*v258*/, v3 /*v259*/
	v_cvt_pk_bf16_f32 v0, v0 /*v256*/, v1 /*v257*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:24672
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[240:247], v[24:31] /*v[536:543]*/, v[194:201] /*v[706:713]*/, v[240:247]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v7, v254, v255
	v_cvt_pk_bf16_f32 v6, v252, v253
	v_cvt_pk_bf16_f32 v5, v250, v251
	v_cvt_pk_bf16_f32 v4, v248, v249
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v246, v247
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[232:239], v[226:233] /*v[738:745]*/, v[194:201] /*v[706:713]*/, v[232:239]
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0xa00
	ds_store_b128 v13, v[4:7] offset:24640
	v_cvt_pk_bf16_f32 v2, v244, v245
	v_cvt_pk_bf16_f32 v1, v242, v243
	v_cvt_pk_bf16_f32 v0, v240, v241
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v13, v[0:3] offset:24608
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[64:71] /*v[320:327]*/, v[226:233] /*v[738:745]*/, v[202:209] /*v[714:721]*/, v[64:71] /*v[320:327]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a00
	v_cvt_pk_bf16_f32 v7, v238, v239
	v_cvt_pk_bf16_f32 v6, v236, v237
	v_cvt_pk_bf16_f32 v5, v234, v235
	v_cvt_pk_bf16_f32 v4, v232, v233
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v3, v70 /*v326*/, v71 /*v327*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[72:79] /*v[328:335]*/, v[24:31] /*v[536:543]*/, v[202:209] /*v[714:721]*/, v[72:79] /*v[328:335]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5a00
	ds_store_b128 v13, v[4:7] offset:24576
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v68 /*v324*/, v69 /*v325*/
	v_cvt_pk_bf16_f32 v1, v66 /*v322*/, v67 /*v323*/
	v_cvt_pk_bf16_f32 v0, v64 /*v320*/, v65 /*v321*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:32768
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[80:87] /*v[336:343]*/, v[234:241] /*v[746:753]*/, v[202:209] /*v[714:721]*/, v[80:87] /*v[336:343]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v7, v78 /*v334*/, v79 /*v335*/
	v_cvt_pk_bf16_f32 v6, v76 /*v332*/, v77 /*v333*/
	v_cvt_pk_bf16_f32 v5, v74 /*v330*/, v75 /*v331*/
	v_cvt_pk_bf16_f32 v4, v72 /*v328*/, v73 /*v329*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v86 /*v342*/, v87 /*v343*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[96:103] /*v[352:359]*/, v[8:15] /*v[520:527]*/, v[202:209] /*v[714:721]*/, v[96:103] /*v[352:359]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5a00
	ds_store_b128 v13, v[4:7] offset:32800
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v84 /*v340*/, v85 /*v341*/
	v_cvt_pk_bf16_f32 v1, v82 /*v338*/, v83 /*v339*/
	v_cvt_pk_bf16_f32 v0, v80 /*v336*/, v81 /*v337*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:32832
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[104:111] /*v[360:367]*/, v[242:249] /*v[754:761]*/, v[202:209] /*v[714:721]*/, v[104:111] /*v[360:367]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v7, v102 /*v358*/, v103 /*v359*/
	v_cvt_pk_bf16_f32 v6, v100 /*v356*/, v101 /*v357*/
	v_cvt_pk_bf16_f32 v5, v98 /*v354*/, v99 /*v355*/
	v_cvt_pk_bf16_f32 v4, v96 /*v352*/, v97 /*v353*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v110 /*v366*/, v111 /*v367*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[112:119] /*v[368:375]*/, v[16:23] /*v[528:535]*/, v[202:209] /*v[714:721]*/, v[112:119] /*v[368:375]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5a00
	ds_store_b128 v13, v[4:7] offset:32864
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v108 /*v364*/, v109 /*v365*/
	v_cvt_pk_bf16_f32 v1, v106 /*v362*/, v107 /*v363*/
	v_cvt_pk_bf16_f32 v0, v104 /*v360*/, v105 /*v361*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:32896
	s_set_vgpr_msb 0x5b
	v_wmma_f32_16x16x32_bf16 v[128:135] /*v[384:391]*/, v[6:13] /*v[774:781]*/, v[202:209] /*v[714:721]*/, v[128:135] /*v[384:391]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5b05
	v_cvt_pk_bf16_f32 v7, v118 /*v374*/, v119 /*v375*/
	v_cvt_pk_bf16_f32 v6, v116 /*v372*/, v117 /*v373*/
	v_cvt_pk_bf16_f32 v5, v114 /*v370*/, v115 /*v371*/
	v_cvt_pk_bf16_f32 v4, v112 /*v368*/, v113 /*v369*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v134 /*v390*/, v135 /*v391*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[136:143] /*v[392:399]*/, v[32:39] /*v[544:551]*/, v[202:209] /*v[714:721]*/, v[136:143] /*v[392:399]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5a00
	ds_store_b128 v13, v[4:7] offset:32928
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v132 /*v388*/, v133 /*v389*/
	v_cvt_pk_bf16_f32 v1, v130 /*v386*/, v131 /*v387*/
	v_cvt_pk_bf16_f32 v0, v128 /*v384*/, v129 /*v385*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:32960
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[224:231] /*v[480:487]*/, v[32:39] /*v[544:551]*/, v[210:217] /*v[722:729]*/, v[224:231] /*v[480:487]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v7, v142 /*v398*/, v143 /*v399*/
	v_cvt_pk_bf16_f32 v6, v140 /*v396*/, v141 /*v397*/
	v_cvt_pk_bf16_f32 v5, v138 /*v394*/, v139 /*v395*/
	v_cvt_pk_bf16_f32 v4, v136 /*v392*/, v137 /*v393*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v230 /*v486*/, v231 /*v487*/
	s_set_vgpr_msb 0x55b
	v_wmma_f32_16x16x32_bf16 v[192:199] /*v[448:455]*/, v[6:13] /*v[774:781]*/, v[210:217] /*v[722:729]*/, v[192:199] /*v[448:455]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5b00
	ds_store_b128 v13, v[4:7] offset:32992
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v228 /*v484*/, v229 /*v485*/
	v_cvt_pk_bf16_f32 v1, v226 /*v482*/, v227 /*v483*/
	v_cvt_pk_bf16_f32 v0, v224 /*v480*/, v225 /*v481*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:41184
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[168:175] /*v[424:431]*/, v[16:23] /*v[528:535]*/, v[210:217] /*v[722:729]*/, v[168:175] /*v[424:431]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v7, v198 /*v454*/, v199 /*v455*/
	v_cvt_pk_bf16_f32 v6, v196 /*v452*/, v197 /*v453*/
	v_cvt_pk_bf16_f32 v5, v194 /*v450*/, v195 /*v451*/
	v_cvt_pk_bf16_f32 v4, v192 /*v448*/, v193 /*v449*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v174 /*v430*/, v175 /*v431*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[160:167] /*v[416:423]*/, v[242:249] /*v[754:761]*/, v[210:217] /*v[722:729]*/, v[160:167] /*v[416:423]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5a00
	ds_store_b128 v13, v[4:7] offset:41152
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v172 /*v428*/, v173 /*v429*/
	v_cvt_pk_bf16_f32 v1, v170 /*v426*/, v171 /*v427*/
	v_cvt_pk_bf16_f32 v0, v168 /*v424*/, v169 /*v425*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:41120
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[152:159] /*v[408:415]*/, v[8:15] /*v[520:527]*/, v[210:217] /*v[722:729]*/, v[152:159] /*v[408:415]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v7, v166 /*v422*/, v167 /*v423*/
	v_cvt_pk_bf16_f32 v6, v164 /*v420*/, v165 /*v421*/
	v_cvt_pk_bf16_f32 v5, v162 /*v418*/, v163 /*v419*/
	v_cvt_pk_bf16_f32 v4, v160 /*v416*/, v161 /*v417*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v158 /*v414*/, v159 /*v415*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[144:151] /*v[400:407]*/, v[234:241] /*v[746:753]*/, v[210:217] /*v[722:729]*/, v[144:151] /*v[400:407]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5a00
	ds_store_b128 v13, v[4:7] offset:41088
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v156 /*v412*/, v157 /*v413*/
	v_cvt_pk_bf16_f32 v1, v154 /*v410*/, v155 /*v411*/
	v_cvt_pk_bf16_f32 v0, v152 /*v408*/, v153 /*v409*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:41056
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[120:127] /*v[376:383]*/, v[24:31] /*v[536:543]*/, v[210:217] /*v[722:729]*/, v[120:127] /*v[376:383]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v7, v150 /*v406*/, v151 /*v407*/
	v_cvt_pk_bf16_f32 v6, v148 /*v404*/, v149 /*v405*/
	v_cvt_pk_bf16_f32 v5, v146 /*v402*/, v147 /*v403*/
	v_cvt_pk_bf16_f32 v4, v144 /*v400*/, v145 /*v401*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v126 /*v382*/, v127 /*v383*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[88:95] /*v[344:351]*/, v[226:233] /*v[738:745]*/, v[210:217] /*v[722:729]*/, v[88:95] /*v[344:351]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5a00
	ds_store_b128 v13, v[4:7] offset:41024
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v124 /*v380*/, v125 /*v381*/
	v_cvt_pk_bf16_f32 v1, v122 /*v378*/, v123 /*v379*/
	v_cvt_pk_bf16_f32 v0, v120 /*v376*/, v121 /*v377*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:40992
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[176:183] /*v[432:439]*/, v[226:233] /*v[738:745]*/, v[218:225] /*v[730:737]*/, v[176:183] /*v[432:439]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v7, v94 /*v350*/, v95 /*v351*/
	v_cvt_pk_bf16_f32 v6, v92 /*v348*/, v93 /*v349*/
	v_cvt_pk_bf16_f32 v5, v90 /*v346*/, v91 /*v347*/
	v_cvt_pk_bf16_f32 v4, v88 /*v344*/, v89 /*v345*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v182 /*v438*/, v183 /*v439*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[184:191] /*v[440:447]*/, v[24:31] /*v[536:543]*/, v[218:225] /*v[730:737]*/, v[184:191] /*v[440:447]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5a00
	ds_store_b128 v13, v[4:7] offset:40960
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v180 /*v436*/, v181 /*v437*/
	v_cvt_pk_bf16_f32 v1, v178 /*v434*/, v179 /*v435*/
	v_cvt_pk_bf16_f32 v0, v176 /*v432*/, v177 /*v433*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:49152
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[200:207] /*v[456:463]*/, v[234:241] /*v[746:753]*/, v[218:225] /*v[730:737]*/, v[200:207] /*v[456:463]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v7, v190 /*v446*/, v191 /*v447*/
	v_cvt_pk_bf16_f32 v6, v188 /*v444*/, v189 /*v445*/
	v_cvt_pk_bf16_f32 v5, v186 /*v442*/, v187 /*v443*/
	v_cvt_pk_bf16_f32 v4, v184 /*v440*/, v185 /*v441*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v206 /*v462*/, v207 /*v463*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[208:215] /*v[464:471]*/, v[8:15] /*v[520:527]*/, v[218:225] /*v[730:737]*/, v[208:215] /*v[464:471]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5a00
	ds_store_b128 v13, v[4:7] offset:49184
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v204 /*v460*/, v205 /*v461*/
	v_cvt_pk_bf16_f32 v1, v202 /*v458*/, v203 /*v459*/
	v_cvt_pk_bf16_f32 v0, v200 /*v456*/, v201 /*v457*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:49216
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[216:223] /*v[472:479]*/, v[242:249] /*v[754:761]*/, v[218:225] /*v[730:737]*/, v[216:223] /*v[472:479]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v7, v214 /*v470*/, v215 /*v471*/
	v_cvt_pk_bf16_f32 v6, v212 /*v468*/, v213 /*v469*/
	v_cvt_pk_bf16_f32 v5, v210 /*v466*/, v211 /*v467*/
	v_cvt_pk_bf16_f32 v4, v208 /*v464*/, v209 /*v465*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v222 /*v478*/, v223 /*v479*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[232:239] /*v[488:495]*/, v[16:23] /*v[528:535]*/, v[218:225] /*v[730:737]*/, v[232:239] /*v[488:495]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5a00
	ds_store_b128 v13, v[4:7] offset:49248
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v220 /*v476*/, v221 /*v477*/
	v_cvt_pk_bf16_f32 v1, v218 /*v474*/, v219 /*v475*/
	v_cvt_pk_bf16_f32 v0, v216 /*v472*/, v217 /*v473*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:49280
	s_set_vgpr_msb 0x5b
	v_wmma_f32_16x16x32_bf16 v[240:247] /*v[496:503]*/, v[6:13] /*v[774:781]*/, v[218:225] /*v[730:737]*/, v[240:247] /*v[496:503]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5b05
	v_cvt_pk_bf16_f32 v7, v238 /*v494*/, v239 /*v495*/
	v_cvt_pk_bf16_f32 v6, v236 /*v492*/, v237 /*v493*/
	v_cvt_pk_bf16_f32 v5, v234 /*v490*/, v235 /*v491*/
	v_cvt_pk_bf16_f32 v4, v232 /*v488*/, v233 /*v489*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v246 /*v502*/, v247 /*v503*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[248:255] /*v[504:511]*/, v[32:39] /*v[544:551]*/, v[218:225] /*v[730:737]*/, v[248:255] /*v[504:511]*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x5a00
	ds_store_b128 v13, v[4:7] offset:49312
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v2, v244 /*v500*/, v245 /*v501*/
	v_cvt_pk_bf16_f32 v1, v242 /*v498*/, v243 /*v499*/
	v_cvt_pk_bf16_f32 v0, v240 /*v496*/, v241 /*v497*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v13, v[0:3] offset:49344
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[88:95], v[226:233] /*v[738:745]*/, v[0:7] /*v[512:519]*/, v[88:95]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa05
	v_cvt_pk_bf16_f32 v7, v254 /*v510*/, v255 /*v511*/
	v_cvt_pk_bf16_f32 v6, v252 /*v508*/, v253 /*v509*/
	v_cvt_pk_bf16_f32 v5, v250 /*v506*/, v251 /*v507*/
	v_cvt_pk_bf16_f32 v4, v248 /*v504*/, v249 /*v505*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v3, v94, v95
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[96:103], v[24:31] /*v[536:543]*/, v[0:7] /*v[512:519]*/, v[96:103]
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0xa00
	ds_store_b128 v13, v[4:7] offset:49376
	v_cvt_pk_bf16_f32 v2, v92, v93
	v_cvt_pk_bf16_f32 v1, v90, v91
	v_cvt_pk_bf16_f32 v0, v88, v89
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v32, v[0:3]
	s_set_vgpr_msb 11
	v_wmma_f32_16x16x32_bf16 v[144:151], v[6:13] /*v[774:781]*/, v[0:7] /*v[512:519]*/, v[144:151]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xb00
	v_cvt_pk_bf16_f32 v7, v102, v103
	v_cvt_pk_bf16_f32 v6, v100, v101
	v_cvt_pk_bf16_f32 v5, v98, v99
	v_cvt_pk_bf16_f32 v4, v96, v97
	s_delay_alu instid0(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v19, v150, v151
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[128:135], v[242:249] /*v[754:761]*/, v[0:7] /*v[512:519]*/, v[128:135]
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0xa00
	ds_store_b128 v32, v[4:7] offset:32
	v_cvt_pk_bf16_f32 v18, v148, v149
	v_cvt_pk_bf16_f32 v17, v146, v147
	v_cvt_pk_bf16_f32 v16, v144, v145
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v32, v[16:19] offset:192
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[104:111], v[234:241] /*v[746:753]*/, v[0:7] /*v[512:519]*/, v[104:111]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v11, v134, v135
	v_cvt_pk_bf16_f32 v10, v132, v133
	v_cvt_pk_bf16_f32 v9, v130, v131
	v_cvt_pk_bf16_f32 v8, v128, v129
	s_wait_alu depctr_vm_vsrc(2)
	s_delay_alu instid0(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v3, v110, v111
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[120:127], v[8:15] /*v[520:527]*/, v[0:7] /*v[512:519]*/, v[120:127]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v2, v108, v109
	v_cvt_pk_bf16_f32 v1, v106, v107
	v_cvt_pk_bf16_f32 v0, v104, v105
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v32, v[8:11] offset:128
	ds_store_b128 v32, v[0:3] offset:64
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[136:143], v[16:23] /*v[528:535]*/, v[0:7] /*v[512:519]*/, v[136:143]
	s_wait_alu depctr_vm_vsrc(3)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v7, v126, v127
	v_cvt_pk_bf16_f32 v6, v124, v125
	v_cvt_pk_bf16_f32 v5, v122, v123
	v_cvt_pk_bf16_f32 v4, v120, v121
	s_delay_alu instid0(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v15, v142, v143
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[160:167], v[32:39] /*v[544:551]*/, v[0:7] /*v[512:519]*/, v[160:167]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v14, v140, v141
	v_cvt_pk_bf16_f32 v13, v138, v139
	v_cvt_pk_bf16_f32 v12, v136, v137
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v32, v[4:7] offset:96
	ds_store_b128 v32, v[12:15] offset:160
	v_nop
	v_cvt_pk_bf16_f32 v23, v166, v167
	v_cvt_pk_bf16_f32 v22, v164, v165
	v_cvt_pk_bf16_f32 v21, v162, v163
	v_cvt_pk_bf16_f32 v20, v160, v161
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v32, v[20:23] offset:224
	s_wait_dscnt 0x0
	s_barrier_signal -1
	s_barrier_wait -1
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
		.amdhsa_next_free_vgpr 852
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
		.amdhsa_inst_pref_size 133
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

	.set kernel_grouped_nt_0.num_vgpr, 852
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
    .vgpr_count:     852
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.target:   amdgcn-amd-amdhsa--gfx1250
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
