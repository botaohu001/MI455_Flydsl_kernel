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
	v_readfirstlane_b32 s31, v0
	s_add_co_i32 s2, s2, 1
	s_and_b32 s3, ttmp6, 15
	s_mul_i32 s2, ttmp9, s2
	s_getreg_b32 s4, hwreg(HW_REG_IB_STS2, 6, 4)
	s_add_co_i32 s5, s3, s2
	s_lshr_b32 s35, s31, 5
	s_mov_b32 s19, 0
	s_wait_kmcnt 0x0
	s_ashr_i32 s3, s26, 31
	s_mov_b32 s2, s26
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_lshl_b64 s[20:21], s[2:3], 1
	s_cmp_eq_u32 s4, 0
	s_cselect_b32 s2, ttmp9, s5
	s_ashr_i32 s3, s2, 31
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_lshr_b32 s3, s3, 24
	s_add_co_i32 s3, s2, s3
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 s12, s3, 0xffffff00
	s_ashr_i32 s3, s3, 8
	s_cmp_lg_u32 s2, s12
	s_cselect_b32 s4, -1, 0
	s_cmp_lt_i32 s2, 0
	s_cselect_b32 s5, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 s4, s5, s4
	s_sub_co_ci_u32 s29, s3, 0
	s_sub_co_i32 s38, s2, s12
	s_lshl_b32 s3, s29, 4
	s_abs_i32 s2, s38
	s_sub_co_i32 s4, 64, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_min_i32 s13, s4, 16
	s_abs_i32 s14, s13
	s_xor_b32 s12, s38, s13
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
	s_load_b32 s1, s[10:11], 0x40
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
	s_movk_i32 s16, 0x80
	s_cselect_b32 s0, s15, s0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s0, s0, s12
	s_sub_co_i32 s39, s0, s12
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s40, s39, s13
	s_sub_co_i32 s0, s38, s40
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_co_i32 s14, s0, s3
	s_wait_kmcnt 0x0
	s_cmp_gt_i32 s1, s14
	s_cselect_b32 s0, 8, 24
	s_cselect_b32 s2, 0, 17
	s_load_b32 s1, s[10:11], s0 offset:0x0 scale_offset
	s_cselect_b32 s3, 16, 32
	s_or_b32 s12, s0, 1
	s_wait_kmcnt 0x0
	s_cmp_gt_i32 s1, s14
	s_cselect_b32 s1, s2, s12
	s_cselect_b32 s0, s0, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s2, s1, s0
	s_lshr_b32 s2, s2, 1
	s_load_b32 s3, s[10:11], s2 offset:0x0 scale_offset
	s_or_b32 s12, s2, 1
	s_wait_kmcnt 0x0
	s_cmp_gt_i32 s3, s14
	s_cselect_b32 s3, s1, s12
	s_cselect_b32 s2, s2, s0
	s_mov_b32 s1, s19
	s_add_co_i32 s0, s3, s2
	s_delay_alu instid0(SALU_CYCLE_1)
	s_lshr_b32 s12, s0, 1
	s_load_b32 s0, s[10:11], s12 offset:0x0 scale_offset
	s_add_co_i32 s13, s12, 1
	s_wait_kmcnt 0x0
	s_cmp_gt_i32 s0, s14
	s_cselect_b32 s0, s3, s13
	s_cselect_b32 s18, s12, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_nc_u64 s[2:3], s[0:1], s[18:19]
	s_lshr_b64 s[2:3], s[2:3], 1
	s_delay_alu instid0(SALU_CYCLE_1)
	s_lshl_b64 s[12:13], s[2:3], 2
	s_add_co_i32 s3, s2, 1
	s_add_nc_u64 s[12:13], s[10:11], s[12:13]
	s_load_b32 s1, s[12:13], 0x0
	s_wait_kmcnt 0x0
	s_cmp_gt_i32 s1, s14
	s_cselect_b32 s0, s0, s3
	s_cselect_b32 s1, s2, s18
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s1, s0, s1
	s_lshr_b32 s1, s1, 1
	s_delay_alu instid0(SALU_CYCLE_1)
	s_min_u32 s2, s1, 31
	s_add_co_i32 s1, s1, 1
	s_load_b32 s2, s[10:11], s2 offset:0x0 scale_offset
	s_wait_kmcnt 0x0
	s_cmp_gt_i32 s2, s14
	s_cselect_b32 s0, s0, s1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_min_u32 s28, s0, 31
	s_add_co_i32 s0, s28, 32
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_ashr_i32 s1, s0, 31
	s_lshl_b64 s[0:1], s[0:1], 2
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_nc_u64 s[0:1], s[10:11], s[0:1]
	s_mov_b64 s[10:11], 0xffffffffffffff80
	s_load_b64 s[2:3], s[0:1], 0x0
	s_wait_xcnt 0x0
	s_add_nc_u64 s[0:1], s[0:1], s[10:11]
	s_load_b32 s0, s[0:1], 0x0
	s_wait_kmcnt 0x0
	s_sub_co_i32 s1, s3, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s3, s1, 0x7f
	s_ashr_i32 s10, s3, 31
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_lshr_b32 s10, s10, 25
	s_add_co_i32 s10, s3, s10
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 s11, s10, 0xffffff80
	s_ashr_i32 s10, s10, 7
	s_cmp_lg_u32 s3, s11
	s_cselect_b32 s11, -1, 0
	s_cmp_lt_i32 s3, 0
	s_cselect_b32 s3, -1, 0
	s_sub_co_i32 s0, s14, s0
	s_and_b32 s3, s3, s11
	s_add_co_i32 s0, s0, s10
	s_cmp_lg_u32 s3, 0
	s_sub_co_ci_u32 s0, s0, 0
	s_delay_alu instid0(SALU_CYCLE_1)
	s_lshl_b32 s3, s0, 7
	s_mov_b32 s0, 1
	s_sub_co_i32 s1, s1, s3
	s_add_co_i32 s3, s3, s2
	v_med3_i32 v1, s1, 0, 0x80
	s_cmp_gt_i32 s1, 0
	s_cselect_b32 s36, s3, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_ashr_i32 s37, s36, 31
	v_readfirstlane_b32 s33, v1
	s_cmp_eq_u32 s35, 0
	s_mul_u64 s[10:11], s[20:21], s[36:37]
	s_cselect_b32 s30, -1, 0
	s_cmp_lg_u32 s35, 0
	s_cbranch_scc1 .LBB0_2
	s_cmp_lg_u32 s26, -2.0
	s_add_nc_u64 s[2:3], s[6:7], s[10:11]
	s_cselect_b32 s17, s20, 0x100
	s_cselect_b32 s12, s21, 0
	s_max_i32 s13, s33, 0
	s_bitset1_b32 s3, 31
	s_lshl_b32 s14, s13, 16
	s_lshr_b32 s13, s13, 16
	s_mov_b32 s1, s19
	s_addk_co_i32 s14, 0x7fff
	s_or_b32 s15, s13, 0x1000000
	s_and_b32 s18, s12, 0xffff
	s_mov_b32 s13, 0xffff0000
	s_mov_b32 s12, 0x7700000
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[0:3], s[12:19]
.LBB0_2:
	s_ashr_i32 s1, s27, 31
	s_mov_b32 s0, s27
	s_delay_alu instid0(SALU_CYCLE_1)
	s_lshl_b64 s[22:23], s[0:1], 1
	s_cmp_lg_u32 s38, s40
	s_cselect_b32 s2, -1, 0
	s_cmp_lt_i32 s38, 0
	s_cselect_b32 s3, -1, 0
	s_cmp_gt_i32 s29, 4
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s3, s3, s12
	s_and_b32 s2, s3, s2
	s_sub_co_ci_u32 s2, s39, 0
	s_add_co_i32 s14, s25, 0xffffff80
	s_lshl_b32 s2, s2, 7
	s_ashr_i32 s29, s28, 31
	s_min_i32 s12, s2, s14
	s_cmp_eq_u32 s35, 1
	s_mul_u64 s[16:17], s[28:29], 0x1c00000
	s_cselect_b32 s38, -1, 0
	s_cmp_lg_u32 s35, 1
	s_add_nc_u64 s[28:29], s[8:9], s[16:17]
	s_cbranch_scc1 .LBB0_4
	s_ashr_i32 s13, s12, 31
	s_mov_b32 s41, 0x1000000
	s_lshl_b64 s[8:9], s[12:13], 1
	s_mov_b32 s16, 1
	s_add_nc_u64 s[18:19], s[28:29], s[8:9]
	s_mov_b32 s47, 0
	s_add_co_i32 s17, 0, 0x8800
	s_bitset1_b32 s19, 31
	s_and_b32 s46, s23, 0xffff
	s_movk_i32 s44, 0x80
	s_mov_b32 s42, 0x800000
	s_mov_b32 s40, 0xf700000
	s_mov_b32 s43, s41
	s_mov_b32 s45, s22
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[16:19], s[40:47]
.LBB0_4:
	s_ashr_i32 s3, s24, 31
	v_dual_lshrrev_b32 v3, 1, v0 :: v_dual_bitop2_b32 v1, 15, v0 bitop3:0x40
	s_lshr_b32 s3, s3, 25
	v_and_b32_e32 v2, 8, v0
	s_add_co_i32 s3, s24, s3
	s_set_vgpr_msb 64
	v_and_or_b32 v1 /*v257*/, 0xffffffc0, s31, v1
	s_and_b32 s8, s3, 0xffffff80
	s_ashr_i32 s39, s3, 7
	s_cmp_lg_u32 s24, s8
	s_wait_tensorcnt 0x0
	s_cselect_b32 s3, -1, 0
	s_cmp_lt_i32 s24, 0
	s_cselect_b32 s8, -1, 0
	s_lshl_b32 s9, s35, 6
	s_barrier_signal -1
	s_and_b32 s24, s9, 64
	s_and_b32 s8, s8, s3
	s_set_vgpr_msb 0x4000
	v_or3_b32 v1, s24, v2, s2
	s_set_vgpr_msb 4
	v_mul_lo_u32 v2, 0x110, v1 /*v257*/
	s_set_vgpr_msb 0x440
	v_and_b32_e32 v4 /*v260*/, 8, v3
	s_set_vgpr_msb 0x4000
	v_and_b32_e32 v3, 16, v0
	s_cmp_lg_u32 s8, 0
	v_subrev_nc_u32_e32 v1, s12, v1
	s_sub_co_ci_u32 s35, s39, 0
	s_mov_b32 s3, -1
	s_add_co_i32 s35, s35, -1
	s_set_vgpr_msb 64
	v_add_nc_u32_e32 v5 /*v261*/, v2, v3
	s_set_vgpr_msb 0x4010
	v_and_or_b32 v0, v0, 7, v4 /*v260*/
	v_lshlrev_b32_e32 v1, 1, v1
	s_cmp_gt_i32 s35, 0
	s_set_vgpr_msb 0x1044
	s_barrier_wait -1
	v_add_nc_u32_e32 v9 /*v265*/, 64, v5 /*v261*/
	s_set_vgpr_msb 0x4400
	v_mul_u32_u24_e32 v0, 0x120, v0
	s_set_vgpr_msb 0x44
	v_add_nc_u32_e32 v8 /*v264*/, 0x80, v5 /*v261*/
	v_add_nc_u32_e32 v7 /*v263*/, 0xc0, v5 /*v261*/
	s_set_vgpr_msb 0x4400
	s_cbranch_scc1 .LBB0_6
	s_set_vgpr_msb 4
	v_add_nc_u32_e32 v130, 64, v5 /*v261*/
	v_add_nc_u32_e32 v129, 0x80, v5 /*v261*/
	v_add_nc_u32_e32 v128, 0xc0, v5 /*v261*/
	s_mov_b32 s3, 0
	s_set_vgpr_msb 0x400
.LBB0_6:
	v_mov_b32_e32 v7, 0
	s_set_vgpr_msb 64
	v_add3_u32 v6 /*v262*/, v0, v1, 0x8800
	s_and_not1_b32 vcc_lo, exec_lo, s3
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v6, v7 :: v_dual_mov_b32 v5, v7
	v_dual_mov_b32 v4, v7 :: v_dual_mov_b32 v3, v7
	v_dual_mov_b32 v2, v7 :: v_dual_mov_b32 v1, v7
	v_dual_mov_b32 v0, v7 :: v_dual_mov_b32 v31, v7
	v_dual_mov_b32 v30, v7 :: v_dual_mov_b32 v29, v7
	v_dual_mov_b32 v28, v7 :: v_dual_mov_b32 v27, v7
	v_dual_mov_b32 v26, v7 :: v_dual_mov_b32 v25, v7
	v_dual_mov_b32 v24, v7 :: v_dual_mov_b32 v63, v7
	v_dual_mov_b32 v62, v7 :: v_dual_mov_b32 v61, v7
	v_dual_mov_b32 v60, v7 :: v_dual_mov_b32 v59, v7
	v_dual_mov_b32 v58, v7 :: v_dual_mov_b32 v57, v7
	v_dual_mov_b32 v56, v7 :: v_dual_mov_b32 v71, v7
	v_dual_mov_b32 v70, v7 :: v_dual_mov_b32 v69, v7
	v_dual_mov_b32 v68, v7 :: v_dual_mov_b32 v67, v7
	v_dual_mov_b32 v66, v7 :: v_dual_mov_b32 v65, v7
	v_dual_mov_b32 v64, v7 :: v_dual_mov_b32 v55, v7
	v_dual_mov_b32 v54, v7 :: v_dual_mov_b32 v53, v7
	v_dual_mov_b32 v52, v7 :: v_dual_mov_b32 v51, v7
	v_dual_mov_b32 v50, v7 :: v_dual_mov_b32 v49, v7
	v_dual_mov_b32 v48, v7 :: v_dual_mov_b32 v79, v7
	v_dual_mov_b32 v78, v7 :: v_dual_mov_b32 v77, v7
	v_dual_mov_b32 v76, v7 :: v_dual_mov_b32 v75, v7
	v_dual_mov_b32 v74, v7 :: v_dual_mov_b32 v73, v7
	v_dual_mov_b32 v72, v7 :: v_dual_mov_b32 v87, v7
	v_dual_mov_b32 v86, v7 :: v_dual_mov_b32 v85, v7
	v_dual_mov_b32 v84, v7 :: v_dual_mov_b32 v83, v7
	v_dual_mov_b32 v82, v7 :: v_dual_mov_b32 v81, v7
	v_dual_mov_b32 v80, v7 :: v_dual_mov_b32 v111, v7
	v_dual_mov_b32 v110, v7 :: v_dual_mov_b32 v109, v7
	v_dual_mov_b32 v108, v7 :: v_dual_mov_b32 v107, v7
	v_dual_mov_b32 v106, v7 :: v_dual_mov_b32 v105, v7
	v_dual_mov_b32 v104, v7 :: v_dual_mov_b32 v95, v7
	v_dual_mov_b32 v94, v7 :: v_dual_mov_b32 v93, v7
	v_dual_mov_b32 v92, v7 :: v_dual_mov_b32 v91, v7
	v_dual_mov_b32 v90, v7 :: v_dual_mov_b32 v89, v7
	v_dual_mov_b32 v88, v7 :: v_dual_mov_b32 v103, v7
	v_dual_mov_b32 v102, v7 :: v_dual_mov_b32 v101, v7
	v_dual_mov_b32 v100, v7 :: v_dual_mov_b32 v99, v7
	v_dual_mov_b32 v98, v7 :: v_dual_mov_b32 v97, v7
	v_dual_mov_b32 v96, v7 :: v_dual_mov_b32 v119, v7
	v_dual_mov_b32 v118, v7 :: v_dual_mov_b32 v117, v7
	v_dual_mov_b32 v116, v7 :: v_dual_mov_b32 v115, v7
	v_dual_mov_b32 v114, v7 :: v_dual_mov_b32 v113, v7
	v_dual_mov_b32 v112, v7 :: v_dual_mov_b32 v127, v7
	v_dual_mov_b32 v126, v7 :: v_dual_mov_b32 v125, v7
	v_dual_mov_b32 v124, v7 :: v_dual_mov_b32 v123, v7
	v_dual_mov_b32 v122, v7 :: v_dual_mov_b32 v121, v7
	v_dual_mov_b32 v120, v7 :: v_dual_mov_b32 v15, v7
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
	v_mov_b32_e32 v40, v7
	s_cbranch_vccnz .LBB0_14
	s_cmp_lg_u32 s26, -2.0
	v_cndmask_b32_e64 v1, 0, -1, s8
	s_cselect_b32 s13, s20, 0x100
	s_cselect_b32 s31, s21, 0
	s_ashr_i32 s3, s2, 31
	s_ashr_i32 s15, s14, 31
	s_add_nc_u64 s[26:27], s[6:7], s[10:11]
	v_min_i64 v[8:9], s[2:3], s[14:15]
	v_mov_b32_e32 v0, 0
	v_cndmask_b32_e64 v2, 0, 1, s30
	s_lshl_b64 s[6:7], s[0:1], 8
	s_max_i32 s3, s33, 0
	s_add_nc_u64 s[28:29], s[28:29], s[6:7]
	s_set_vgpr_msb 64
	v_dual_mov_b32 v0 /*v256*/, 1 :: v_dual_add_nc_u32 v10 /*v266*/, s39, v1
	v_cmp_ne_u32_e64 s0, 1, v2
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v1, v0 :: v_dual_mov_b32 v2, v0
	v_dual_mov_b32 v3, v0 :: v_dual_mov_b32 v4, v0
	v_dual_mov_b32 v5, v0 :: v_dual_mov_b32 v6, v0
	v_dual_mov_b32 v7, v0 :: v_dual_mov_b32 v24, v0
	v_dual_mov_b32 v25, v0 :: v_dual_mov_b32 v26, v0
	v_dual_mov_b32 v27, v0 :: v_dual_mov_b32 v28, v0
	v_dual_mov_b32 v29, v0 :: v_dual_mov_b32 v30, v0
	v_dual_mov_b32 v31, v0 :: v_dual_mov_b32 v56, v0
	v_dual_mov_b32 v57, v0 :: v_dual_mov_b32 v58, v0
	v_dual_mov_b32 v59, v0 :: v_dual_mov_b32 v60, v0
	v_dual_mov_b32 v61, v0 :: v_dual_mov_b32 v62, v0
	v_dual_mov_b32 v63, v0 :: v_dual_mov_b32 v64, v0
	v_dual_mov_b32 v65, v0 :: v_dual_mov_b32 v66, v0
	v_dual_mov_b32 v67, v0 :: v_dual_mov_b32 v68, v0
	v_lshlrev_b64_e32 v[8:9], 1, v[8:9]
	v_dual_mov_b32 v69, v0 :: v_dual_mov_b32 v70, v0
	v_dual_mov_b32 v71, v0 :: v_dual_mov_b32 v48, v0
	v_dual_mov_b32 v49, v0 :: v_dual_mov_b32 v50, v0
	s_set_vgpr_msb 64
	s_delay_alu instid0(VALU_DEP_4)
	v_add_nc_u64_e32 v[2:3] /*v[258:259]*/, s[28:29], v[8:9]
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v51, v0 :: v_dual_mov_b32 v52, v0
	v_dual_mov_b32 v53, v0 :: v_dual_mov_b32 v54, v0
	v_dual_mov_b32 v55, v0 :: v_dual_mov_b32 v72, v0
	v_dual_mov_b32 v73, v0 :: v_dual_mov_b32 v74, v0
	v_dual_mov_b32 v75, v0 :: v_dual_mov_b32 v76, v0
	v_dual_mov_b32 v77, v0 :: v_dual_mov_b32 v78, v0
	v_dual_mov_b32 v79, v0 :: v_dual_mov_b32 v80, v0
	v_dual_mov_b32 v81, v0 :: v_dual_mov_b32 v82, v0
	v_dual_mov_b32 v83, v0 :: v_dual_mov_b32 v84, v0
	v_dual_mov_b32 v85, v0 :: v_dual_mov_b32 v86, v0
	v_dual_mov_b32 v87, v0 :: v_dual_mov_b32 v104, v0
	v_dual_mov_b32 v105, v0 :: v_dual_mov_b32 v106, v0
	v_dual_mov_b32 v107, v0 :: v_dual_mov_b32 v108, v0
	v_dual_mov_b32 v109, v0 :: v_dual_mov_b32 v110, v0
	v_dual_mov_b32 v111, v0 :: v_dual_mov_b32 v88, v0
	v_dual_mov_b32 v89, v0 :: v_dual_mov_b32 v90, v0
	v_dual_mov_b32 v91, v0 :: v_dual_mov_b32 v92, v0
	v_dual_mov_b32 v93, v0 :: v_dual_mov_b32 v94, v0
	v_dual_mov_b32 v95, v0 :: v_dual_mov_b32 v96, v0
	v_dual_mov_b32 v97, v0 :: v_dual_mov_b32 v98, v0
	v_dual_mov_b32 v99, v0 :: v_dual_mov_b32 v100, v0
	v_dual_mov_b32 v101, v0 :: v_dual_mov_b32 v102, v0
	v_dual_mov_b32 v103, v0 :: v_dual_mov_b32 v112, v0
	v_dual_mov_b32 v113, v0 :: v_dual_mov_b32 v114, v0
	v_dual_mov_b32 v115, v0 :: v_dual_mov_b32 v116, v0
	v_dual_mov_b32 v117, v0 :: v_dual_mov_b32 v118, v0
	v_dual_mov_b32 v119, v0 :: v_dual_mov_b32 v120, v0
	v_dual_mov_b32 v121, v0 :: v_dual_mov_b32 v122, v0
	v_dual_mov_b32 v123, v0 :: v_dual_mov_b32 v124, v0
	v_dual_mov_b32 v125, v0 :: v_dual_mov_b32 v126, v0
	v_dual_mov_b32 v127, v0 :: v_dual_mov_b32 v8, v0
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
	v_mov_b32_e32 v47, v0
	s_mov_b32 s15, 0
	s_mov_b32 s17, 0x1000000
	s_movk_i32 s12, 0x80
	s_lshl_b32 s1, s3, 16
	s_lshr_b32 s3, s3, 16
	s_mov_b32 s9, 0xffff0000
	s_mov_b32 s8, 0x7700000
	s_mov_b32 s18, 0x800000
	s_mov_b32 s16, 0xf700000
	s_mov_b32 s21, s22
	s_and_b32 s22, s23, 0xffff
	s_mov_b32 s19, s17
	s_mov_b32 s20, s12
	s_mov_b32 s23, s15
	s_and_b32 s14, s31, 0xffff
	s_or_b32 s10, s1, 0x7fff
	s_or_b32 s11, s3, 0x1000000
	s_mov_b32 s28, 1
	s_add_nc_u64 s[26:27], s[26:27], 0x100
	s_mov_b32 s1, 1
	s_branch .LBB0_9
.LBB0_8:
	v_wmma_f32_16x16x32_bf16 v[0:7], v[208:215], v[232:239], v[0:7]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[224:231], v[232:239], v[24:31]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[240:247], v[232:239], v[56:63]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[248:255], v[232:239], v[64:71]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[248:255], v[216:223], v[104:111]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[240:247], v[216:223], v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[224:231], v[216:223], v[72:79]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[208:215], v[216:223], v[48:55]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[208:215], v[200:207], v[88:95]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[224:231], v[200:207], v[96:103]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[240:247], v[200:207], v[112:119]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[248:255], v[200:207], v[120:127]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[248:255], v[192:199], v[40:47]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[240:247], v[192:199], v[32:39]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[224:231], v[192:199], v[16:23]
	v_wmma_f32_16x16x32_bf16 v[8:15], v[208:215], v[192:199], v[8:15]
	s_set_vgpr_msb 1
	ds_load_b128 v[192:195], v12 /*v268*/ offset:128
	ds_load_b128 v[196:199], v12 /*v268*/ offset:160
	ds_load_b128 v[200:203], v12 /*v268*/ offset:4480
	ds_load_b128 v[204:207], v12 /*v268*/ offset:4512
	ds_load_b128 v[208:211], v12 /*v268*/ offset:8832
	ds_load_b128 v[212:215], v12 /*v268*/ offset:8864
	ds_load_b128 v[216:219], v12 /*v268*/ offset:13184
	ds_load_b128 v[220:223], v12 /*v268*/ offset:13216
	ds_load_tr16_b128 v[228:231], v11 /*v267*/ offset:23040
	ds_load_tr16_b128 v[224:227], v11 /*v267*/ offset:18432
	ds_load_tr16_b128 v[232:235], v11 /*v267*/ offset:18464
	ds_load_tr16_b128 v[236:239], v11 /*v267*/ offset:23072
	ds_load_tr16_b128 v[240:243], v11 /*v267*/ offset:18496
	ds_load_tr16_b128 v[244:247], v11 /*v267*/ offset:23104
	ds_load_tr16_b128 v[248:251], v11 /*v267*/ offset:18528
	ds_load_tr16_b128 v[252:255], v11 /*v267*/ offset:23136
	s_set_vgpr_msb 0x100
	s_wait_dscnt 0x10
	v_wmma_f32_16x16x32_bf16 v[0:7], v[144:151], v[168:175], v[0:7]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[160:167], v[168:175], v[24:31]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[176:183], v[168:175], v[56:63]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[184:191], v[168:175], v[64:71]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[184:191], v[152:159], v[104:111]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[176:183], v[152:159], v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[160:167], v[152:159], v[72:79]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[144:151], v[152:159], v[48:55]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[144:151], v[136:143], v[88:95]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[160:167], v[136:143], v[96:103]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[176:183], v[136:143], v[112:119]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[184:191], v[136:143], v[120:127]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[184:191], v[128:135], v[40:47]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[176:183], v[128:135], v[32:39]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[160:167], v[128:135], v[16:23]
	v_wmma_f32_16x16x32_bf16 v[8:15], v[144:151], v[128:135], v[8:15]
	s_set_vgpr_msb 1
	ds_load_b128 v[128:131], v12 /*v268*/ offset:192
	ds_load_b128 v[132:135], v12 /*v268*/ offset:224
	ds_load_b128 v[136:139], v12 /*v268*/ offset:4544
	ds_load_b128 v[140:143], v12 /*v268*/ offset:4576
	ds_load_b128 v[144:147], v12 /*v268*/ offset:8896
	ds_load_b128 v[148:151], v12 /*v268*/ offset:8928
	ds_load_b128 v[152:155], v12 /*v268*/ offset:13248
	ds_load_b128 v[156:159], v12 /*v268*/ offset:13280
	ds_load_tr16_b128 v[164:167], v11 /*v267*/ offset:32256
	ds_load_tr16_b128 v[160:163], v11 /*v267*/ offset:27648
	ds_load_tr16_b128 v[168:171], v11 /*v267*/ offset:27680
	ds_load_tr16_b128 v[172:175], v11 /*v267*/ offset:32288
	ds_load_tr16_b128 v[176:179], v11 /*v267*/ offset:27712
	ds_load_tr16_b128 v[180:183], v11 /*v267*/ offset:32320
	ds_load_tr16_b128 v[184:187], v11 /*v267*/ offset:27744
	ds_load_tr16_b128 v[188:191], v11 /*v267*/ offset:32352
	s_set_vgpr_msb 0x100
	s_wait_dscnt 0x16
	v_wmma_f32_16x16x32_bf16 v[0:7], v[224:231], v[192:199], v[0:7]
	s_wait_dscnt 0x0
	v_wmma_f32_16x16x32_bf16 v[24:31], v[232:239], v[192:199], v[24:31]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[240:247], v[192:199], v[56:63]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[248:255], v[192:199], v[64:71]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[248:255], v[200:207], v[104:111]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[240:247], v[200:207], v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[232:239], v[200:207], v[72:79]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[224:231], v[200:207], v[48:55]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[224:231], v[208:215], v[88:95]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[232:239], v[208:215], v[96:103]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[240:247], v[208:215], v[112:119]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[248:255], v[208:215], v[120:127]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[248:255], v[216:223], v[40:47]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[240:247], v[216:223], v[32:39]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[232:239], v[216:223], v[16:23]
	v_wmma_f32_16x16x32_bf16 v[8:15], v[224:231], v[216:223], v[8:15]
	s_wait_tensorcnt 0x0
	s_barrier_signal -1
	v_wmma_f32_16x16x32_bf16 v[0:7], v[160:167], v[128:135], v[0:7]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[168:175], v[128:135], v[24:31]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[176:183], v[128:135], v[56:63]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[184:191], v[128:135], v[64:71]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[184:191], v[136:143], v[104:111]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[176:183], v[136:143], v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[168:175], v[136:143], v[72:79]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[160:167], v[136:143], v[48:55]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[160:167], v[144:151], v[88:95]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[168:175], v[144:151], v[96:103]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[176:183], v[144:151], v[112:119]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[184:191], v[144:151], v[120:127]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[184:191], v[152:159], v[40:47]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[176:183], v[152:159], v[32:39]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[168:175], v[152:159], v[16:23]
	v_wmma_f32_16x16x32_bf16 v[8:15], v[160:167], v[152:159], v[8:15]
	s_add_co_i32 s1, s1, 1
	s_set_vgpr_msb 0x44
	v_add_nc_u64_e32 v[2:3] /*v[258:259]*/, s[6:7], v[2:3] /*v[258:259]*/
	v_cmp_ne_u32_e32 vcc_lo, s1, v10 /*v266*/
	s_add_nc_u64 s[26:27], s[26:27], 0x100
	s_set_vgpr_msb 0x4400
	s_barrier_wait -1
	s_cbranch_vccz .LBB0_13
.LBB0_9:
	s_bitcmp1_b32 s1, 0
	s_cselect_b32 s29, 0, 0x11800
	s_cselect_b32 s3, 0x11800, 0
	s_add_co_i32 s29, s29, 0
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x44
	v_dual_add_nc_u32 v12 /*v268*/, s29, v5 /*v261*/ :: v_dual_add_nc_u32 v11 /*v267*/, s29, v6 /*v262*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x4401
	ds_load_b128 v[232:235], v12 /*v268*/
	ds_load_b128 v[236:239], v12 /*v268*/ offset:32
	ds_load_b128 v[216:219], v12 /*v268*/ offset:4352
	ds_load_b128 v[220:223], v12 /*v268*/ offset:4384
	ds_load_b128 v[200:203], v12 /*v268*/ offset:8704
	ds_load_b128 v[204:207], v12 /*v268*/ offset:8736
	ds_load_b128 v[192:195], v12 /*v268*/ offset:13056
	ds_load_b128 v[196:199], v12 /*v268*/ offset:13088
	ds_load_tr16_b128 v[208:211], v11 /*v267*/
	ds_load_tr16_b128 v[224:227], v11 /*v267*/ offset:32
	ds_load_tr16_b128 v[212:215], v11 /*v267*/ offset:4608
	ds_load_tr16_b128 v[228:231], v11 /*v267*/ offset:4640
	ds_load_tr16_b128 v[240:243], v11 /*v267*/ offset:64
	ds_load_tr16_b128 v[248:251], v11 /*v267*/ offset:96
	ds_load_tr16_b128 v[244:247], v11 /*v267*/ offset:4672
	ds_load_tr16_b128 v[252:255], v11 /*v267*/ offset:4704
	ds_load_b128 v[168:171], v12 /*v268*/ offset:64
	ds_load_b128 v[172:175], v12 /*v268*/ offset:96
	ds_load_b128 v[152:155], v12 /*v268*/ offset:4416
	ds_load_b128 v[156:159], v12 /*v268*/ offset:4448
	ds_load_b128 v[136:139], v12 /*v268*/ offset:8768
	ds_load_b128 v[140:143], v12 /*v268*/ offset:8800
	ds_load_b128 v[128:131], v12 /*v268*/ offset:13120
	ds_load_b128 v[132:135], v12 /*v268*/ offset:13152
	ds_load_tr16_b128 v[144:147], v11 /*v267*/ offset:9216
	ds_load_tr16_b128 v[160:163], v11 /*v267*/ offset:9248
	ds_load_tr16_b128 v[148:151], v11 /*v267*/ offset:13824
	ds_load_tr16_b128 v[164:167], v11 /*v267*/ offset:13856
	ds_load_tr16_b128 v[176:179], v11 /*v267*/ offset:9280
	ds_load_tr16_b128 v[184:187], v11 /*v267*/ offset:9312
	ds_load_tr16_b128 v[180:183], v11 /*v267*/ offset:13888
	ds_load_tr16_b128 v[188:191], v11 /*v267*/ offset:13920
	s_wait_dscnt 0x10
	s_and_b32 vcc_lo, exec_lo, s0
	s_set_vgpr_msb 0x100
	s_cbranch_vccz .LBB0_11
	s_and_not1_b32 vcc_lo, exec_lo, s38
	s_cbranch_vccnz .LBB0_8
	s_branch .LBB0_12
.LBB0_11:
	s_add_co_i32 s29, s3, 0
	s_or_b32 s31, s27, 0x80000000
	s_mov_b32 s30, s26
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[28:31], s[8:15]
	s_and_not1_b32 vcc_lo, exec_lo, s38
	s_cbranch_vccnz .LBB0_8
.LBB0_12:
	s_add_co_i32 s3, s3, 0
	s_set_vgpr_msb 0x45
	v_or_b32_e32 v15 /*v271*/, 0x80000000, v3 /*v259*/
	s_add_co_i32 s3, s3, 0x8800
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_dual_mov_b32 v14 /*v270*/, v2 /*v258*/ :: v_dual_mov_b32 v13 /*v269*/, s3
	v_readfirstlane_b32 s40, v0 /*v256*/
	v_readfirstlane_b32 s43, v15 /*v271*/
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_readfirstlane_b32 s42, v14 /*v270*/
	v_readfirstlane_b32 s41, v13 /*v269*/
	s_delay_alu instid0(VALU_DEP_1)
	tensor_load_to_lds s[40:43], s[16:23]
	s_set_vgpr_msb 0x4500
	s_branch .LBB0_8
.LBB0_13:
	s_set_vgpr_msb 1
	v_dual_mov_b32 v130, v9 /*v265*/ :: v_dual_mov_b32 v129, v8 /*v264*/
	v_mov_b32_e32 v128, v7 /*v263*/
	s_set_vgpr_msb 0x100
.LBB0_14:
	s_lshr_b32 s0, s35, 31
	s_mov_b32 s7, 0
	s_add_co_i32 s0, s35, s0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s0, s0, 0x1ffffe
	s_sub_co_i32 s0, s35, s0
	s_ashr_i32 s35, s34, 31
	s_mul_i32 s0, s0, 0x11800
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_co_i32 s0, s0, 0
	s_set_vgpr_msb 4
	v_dual_add_nc_u32 v252, s0, v5 /*v261*/ :: v_dual_add_nc_u32 v253, s0, v6 /*v262*/
	s_set_vgpr_msb 0x400
	v_dual_add_nc_u32 v130, s0, v130 :: v_dual_add_nc_u32 v129, s0, v129
	v_add_nc_u32_e32 v128, s0, v128
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[132:135], v252
	ds_load_b128 v[136:139], v252 offset:32
	ds_load_b128 v[140:143], v252 offset:4352
	ds_load_b128 v[144:147], v252 offset:4384
	ds_load_b128 v[148:151], v252 offset:8704
	ds_load_b128 v[152:155], v252 offset:8736
	ds_load_b128 v[156:159], v252 offset:13056
	ds_load_b128 v[160:163], v252 offset:13088
	ds_load_tr16_b128 v[168:171], v253 offset:4608
	ds_load_tr16_b128 v[164:167], v253
	ds_load_tr16_b128 v[172:175], v253 offset:32
	ds_load_tr16_b128 v[176:179], v253 offset:4640
	ds_load_tr16_b128 v[180:183], v253 offset:64
	ds_load_tr16_b128 v[184:187], v253 offset:4672
	ds_load_tr16_b128 v[188:191], v253 offset:96
	ds_load_tr16_b128 v[192:195], v253 offset:4704
	ds_load_b128 v[196:199], v130
	ds_load_b128 v[200:203], v130 offset:32
	ds_load_b128 v[204:207], v252 offset:4416
	ds_load_b128 v[208:211], v252 offset:4448
	ds_load_b128 v[212:215], v252 offset:8768
	ds_load_b128 v[216:219], v252 offset:8800
	ds_load_b128 v[220:223], v252 offset:13120
	ds_load_b128 v[224:227], v252 offset:13152
	ds_load_tr16_b128 v[228:231], v253 offset:9216
	ds_load_tr16_b128 v[232:235], v253 offset:13824
	ds_load_tr16_b128 v[236:239], v253 offset:9248
	ds_load_tr16_b128 v[240:243], v253 offset:13856
	ds_load_tr16_b128 v[244:247], v253 offset:9280
	ds_load_tr16_b128 v[248:251], v253 offset:13888
	s_set_vgpr_msb 64
	ds_load_tr16_b128 v[6:9] /*v[262:265]*/, v253 offset:9312
	s_wait_alu depctr_vm_vsrc(6)
	ds_load_tr16_b128 v[10:13] /*v[266:269]*/, v253 offset:13920
	s_set_vgpr_msb 0x4000
	s_wait_dscnt 0x16
	v_wmma_f32_16x16x32_bf16 v[0:7], v[164:171], v[132:139], v[0:7]
	s_wait_dscnt 0x10
	s_sub_co_i32 s0, s25, s2
	v_wmma_f32_16x16x32_bf16 v[24:31], v[172:179], v[132:139], v[24:31]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[180:187], v[132:139], v[56:63]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[188:195], v[132:139], v[64:71]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[188:195], v[140:147], v[104:111]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[180:187], v[140:147], v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[172:179], v[140:147], v[72:79]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[164:171], v[140:147], v[48:55]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[164:171], v[148:155], v[88:95]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[172:179], v[148:155], v[96:103]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[180:187], v[148:155], v[112:119]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[188:195], v[148:155], v[120:127]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[188:195], v[156:163], v[40:47]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[180:187], v[156:163], v[32:39]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[172:179], v[156:163], v[16:23]
	v_wmma_f32_16x16x32_bf16 v[8:15], v[164:171], v[156:163], v[8:15]
	ds_load_b128 v[130:133], v129
	ds_load_b128 v[134:137], v129 offset:32
	ds_load_b128 v[138:141], v252 offset:4480
	ds_load_b128 v[142:145], v252 offset:4512
	ds_load_b128 v[146:149], v252 offset:8832
	ds_load_b128 v[150:153], v252 offset:8864
	ds_load_b128 v[154:157], v252 offset:13184
	ds_load_b128 v[158:161], v252 offset:13216
	ds_load_tr16_b128 v[166:169], v253 offset:23040
	ds_load_tr16_b128 v[162:165], v253 offset:18432
	ds_load_tr16_b128 v[170:173], v253 offset:18464
	ds_load_tr16_b128 v[174:177], v253 offset:23072
	ds_load_tr16_b128 v[178:181], v253 offset:18496
	ds_load_tr16_b128 v[182:185], v253 offset:23104
	ds_load_tr16_b128 v[186:189], v253 offset:18528
	ds_load_tr16_b128 v[190:193], v253 offset:23136
	s_wait_dscnt 0x16
	v_wmma_f32_16x16x32_bf16 v[0:7], v[228:235], v[196:203], v[0:7]
	s_wait_dscnt 0x10
	v_wmma_f32_16x16x32_bf16 v[24:31], v[236:243], v[196:203], v[24:31]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[244:251], v[196:203], v[56:63]
	s_set_vgpr_msb 1
	v_wmma_f32_16x16x32_bf16 v[64:71], v[6:13] /*v[262:269]*/, v[196:203], v[64:71]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[6:13] /*v[262:269]*/, v[204:211], v[104:111]
	s_set_vgpr_msb 0x100
	v_wmma_f32_16x16x32_bf16 v[80:87], v[244:251], v[204:211], v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[236:243], v[204:211], v[72:79]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[228:235], v[204:211], v[48:55]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[228:235], v[212:219], v[88:95]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[236:243], v[212:219], v[96:103]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[244:251], v[212:219], v[112:119]
	s_set_vgpr_msb 1
	v_wmma_f32_16x16x32_bf16 v[120:127], v[6:13] /*v[262:269]*/, v[212:219], v[120:127]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[6:13] /*v[262:269]*/, v[220:227], v[40:47]
	s_set_vgpr_msb 0x100
	v_wmma_f32_16x16x32_bf16 v[32:39], v[244:251], v[220:227], v[32:39]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[236:243], v[220:227], v[16:23]
	v_wmma_f32_16x16x32_bf16 v[8:15], v[228:235], v[220:227], v[8:15]
	ds_load_b128 v[194:197], v128
	ds_load_b128 v[198:201], v128 offset:32
	ds_load_b128 v[202:205], v252 offset:4544
	ds_load_b128 v[206:209], v252 offset:4576
	ds_load_b128 v[210:213], v252 offset:8896
	ds_load_b128 v[214:217], v252 offset:8928
	ds_load_b128 v[218:221], v252 offset:13248
	ds_load_b128 v[222:225], v252 offset:13280
	ds_load_tr16_b128 v[230:233], v253 offset:32256
	ds_load_tr16_b128 v[226:229], v253 offset:27648
	ds_load_tr16_b128 v[234:237], v253 offset:27680
	ds_load_tr16_b128 v[238:241], v253 offset:32288
	ds_load_tr16_b128 v[242:245], v253 offset:27712
	ds_load_tr16_b128 v[246:249], v253 offset:32320
	s_set_vgpr_msb 64
	ds_load_tr16_b128 v[6:9] /*v[262:265]*/, v253 offset:27744
	ds_load_tr16_b128 v[10:13] /*v[266:269]*/, v253 offset:32352
	s_set_vgpr_msb 0x4000
	s_wait_dscnt 0x16
	v_wmma_f32_16x16x32_bf16 v[0:7], v[162:169], v[130:137], v[0:7]
	s_wait_dscnt 0x0
	v_wmma_f32_16x16x32_bf16 v[24:31], v[170:177], v[130:137], v[24:31]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[178:185], v[130:137], v[56:63]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[186:193], v[130:137], v[64:71]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[186:193], v[138:145], v[104:111]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[178:185], v[138:145], v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[170:177], v[138:145], v[72:79]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[162:169], v[138:145], v[48:55]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[162:169], v[146:153], v[88:95]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[170:177], v[146:153], v[96:103]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[178:185], v[146:153], v[112:119]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[186:193], v[146:153], v[120:127]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[186:193], v[154:161], v[40:47]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[178:185], v[154:161], v[32:39]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[170:177], v[154:161], v[16:23]
	v_wmma_f32_16x16x32_bf16 v[8:15], v[162:169], v[154:161], v[8:15]
	s_wait_alu depctr_vm_vsrc(6)
	s_set_vgpr_msb 4
	v_or_b32_e32 v128, s24, v4 /*v260*/
	s_set_vgpr_msb 0x400
	v_wmma_f32_16x16x32_bf16 v[0:7], v[226:233], v[194:201], v[0:7]
	s_wait_tensorcnt 0x0
	s_barrier_signal -1
	v_lshlrev_b32_e32 v128, 1, v128
	s_barrier_wait -1
	s_mul_u64 s[10:11], s[36:37], s[34:35]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[234:241], v[194:201], v[24:31]
	s_set_vgpr_msb 1
	v_lshl_or_b32 v128, v1 /*v257*/, 8, v128
	v_nop
	s_set_vgpr_msb 0x100
	v_cvt_pk_bf16_f32 v7, v6, v7
	v_cvt_pk_bf16_f32 v6, v4, v5
	v_cvt_pk_bf16_f32 v5, v2, v3
	v_cvt_pk_bf16_f32 v4, v0, v1
	v_add_nc_u32_e32 v128, 0, v128
	s_ashr_i32 s3, s2, 31
	v_wmma_f32_16x16x32_bf16 v[56:63], v[242:249], v[194:201], v[56:63]
	v_cvt_pk_bf16_f32 v3, v30, v31
	v_cvt_pk_bf16_f32 v2, v28, v29
	v_cvt_pk_bf16_f32 v1, v26, v27
	v_cvt_pk_bf16_f32 v0, v24, v25
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v128, v[4:7]
	s_lshl_b64 s[10:11], s[10:11], 1
	s_lshl_b64 s[2:3], s[2:3], 1
	s_set_vgpr_msb 1
	v_wmma_f32_16x16x32_bf16 v[64:71], v[6:13] /*v[262:269]*/, v[194:201], v[64:71]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x100
	v_cvt_pk_bf16_f32 v7, v62, v63
	v_cvt_pk_bf16_f32 v6, v60, v61
	v_cvt_pk_bf16_f32 v5, v58, v59
	v_cvt_pk_bf16_f32 v4, v56, v57
	ds_store_b128 v128, v[0:3] offset:32
	s_cmp_lg_u32 s34, 0x80000000
	s_add_nc_u64 s[4:5], s[4:5], s[10:11]
	s_set_vgpr_msb 1
	v_wmma_f32_16x16x32_bf16 v[104:111], v[6:13] /*v[262:269]*/, v[202:209], v[104:111]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x100
	v_cvt_pk_bf16_f32 v3, v70, v71
	v_cvt_pk_bf16_f32 v2, v68, v69
	v_cvt_pk_bf16_f32 v1, v66, v67
	v_cvt_pk_bf16_f32 v0, v64, v65
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v128, v[4:7] offset:64
	s_cselect_b32 s13, s35, 0
	s_cselect_b32 s12, s34, 0x80
	v_wmma_f32_16x16x32_bf16 v[80:87], v[242:249], v[202:209], v[80:87]
	ds_store_b128 v128, v[0:3] offset:96
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v3, v110, v111
	v_cvt_pk_bf16_f32 v2, v108, v109
	v_cvt_pk_bf16_f32 v1, v106, v107
	v_cvt_pk_bf16_f32 v0, v104, v105
	s_bfe_u32 s1, ttmp8, 0x50019
	s_add_nc_u64 s[2:3], s[4:5], s[2:3]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[234:241], v[202:209], v[72:79]
	v_cvt_pk_bf16_f32 v7, v86, v87
	v_cvt_pk_bf16_f32 v6, v84, v85
	v_cvt_pk_bf16_f32 v5, v82, v83
	v_cvt_pk_bf16_f32 v4, v80, v81
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v128, v[0:3] offset:4192
	s_and_b32 s1, s1, 3
	s_mov_b32 s8, 1
	v_wmma_f32_16x16x32_bf16 v[48:55], v[226:233], v[202:209], v[48:55]
	ds_store_b128 v128, v[4:7] offset:4160
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v3, v78, v79
	v_cvt_pk_bf16_f32 v2, v76, v77
	v_cvt_pk_bf16_f32 v1, v74, v75
	v_cvt_pk_bf16_f32 v0, v72, v73
	s_lshl_b32 s6, s1, 6
	s_lshl_b32 s14, s1, 5
	v_wmma_f32_16x16x32_bf16 v[88:95], v[226:233], v[210:217], v[88:95]
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v7, v54, v55
	v_cvt_pk_bf16_f32 v6, v52, v53
	v_cvt_pk_bf16_f32 v5, v50, v51
	v_cvt_pk_bf16_f32 v4, v48, v49
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v128, v[0:3] offset:4128
	s_lshl_b32 s1, s1, 13
	s_mul_u64 s[4:5], s[12:13], s[6:7]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[234:241], v[210:217], v[96:103]
	ds_store_b128 v128, v[4:7] offset:4096
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v3, v94, v95
	v_cvt_pk_bf16_f32 v2, v92, v93
	v_cvt_pk_bf16_f32 v1, v90, v91
	v_cvt_pk_bf16_f32 v0, v88, v89
	s_add_co_i32 s9, s1, 0
	s_sub_co_i32 s1, s33, s14
	v_wmma_f32_16x16x32_bf16 v[112:119], v[242:249], v[210:217], v[112:119]
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v7, v102, v103
	v_cvt_pk_bf16_f32 v6, v100, v101
	v_cvt_pk_bf16_f32 v5, v98, v99
	v_cvt_pk_bf16_f32 v4, v96, v97
	s_add_nc_u64 s[10:11], s[4:5], s[2:3]
	s_max_i32 s3, s1, 0
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v128, v[0:3] offset:8192
	s_set_vgpr_msb 1
	v_wmma_f32_16x16x32_bf16 v[120:127], v[6:13] /*v[262:269]*/, v[210:217], v[120:127]
	s_set_vgpr_msb 0x100
	ds_store_b128 v128, v[4:7] offset:8224
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v3, v118, v119
	v_cvt_pk_bf16_f32 v2, v116, v117
	v_cvt_pk_bf16_f32 v1, v114, v115
	v_cvt_pk_bf16_f32 v0, v112, v113
	s_max_i32 s2, s0, 0
	s_lshr_b32 s0, s3, 16
	v_wmma_f32_16x16x32_bf16 v[32:39], v[242:249], v[218:225], v[32:39]
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v7, v126, v127
	v_cvt_pk_bf16_f32 v6, v124, v125
	v_cvt_pk_bf16_f32 v5, v122, v123
	v_cvt_pk_bf16_f32 v4, v120, v121
	s_lshl_b32 s1, s2, 16
	s_lshr_b64 s[2:3], s[2:3], 16
	s_bitset1_b32 s11, 31
	v_wmma_f32_16x16x32_bf16 v[8:15], v[226:233], v[218:225], v[8:15]
	s_or_b32 s3, s0, 0x800000
	s_and_b32 s6, s13, 0xffff
	s_mov_b32 s4, 32
	s_mov_b32 s0, 0x10000
	s_mov_b32 s5, s12
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v128, v[0:3] offset:8256
	ds_store_b128 v128, v[4:7] offset:8288
	v_wmma_f32_16x16x32_bf16 v[16:23], v[234:241], v[218:225], v[16:23]
	v_nop
	v_nop
	v_nop
	v_cvt_pk_bf16_f32 v15, v14, v15
	v_cvt_pk_bf16_f32 v14, v12, v13
	v_cvt_pk_bf16_f32 v13, v10, v11
	v_cvt_pk_bf16_f32 v12, v8, v9
	v_cvt_pk_bf16_f32 v11, v22, v23
	s_set_vgpr_msb 1
	v_wmma_f32_16x16x32_bf16 v[40:47], v[6:13] /*v[262:269]*/, v[218:225], v[40:47]
	s_set_vgpr_msb 0x100
	v_cvt_pk_bf16_f32 v10, v20, v21
	v_cvt_pk_bf16_f32 v9, v18, v19
	v_cvt_pk_bf16_f32 v8, v16, v17
	v_cvt_pk_bf16_f32 v19, v38, v39
	v_cvt_pk_bf16_f32 v18, v36, v37
	v_cvt_pk_bf16_f32 v17, v34, v35
	v_cvt_pk_bf16_f32 v16, v32, v33
	v_cvt_pk_bf16_f32 v23, v46, v47
	v_cvt_pk_bf16_f32 v22, v44, v45
	v_cvt_pk_bf16_f32 v21, v42, v43
	v_cvt_pk_bf16_f32 v20, v40, v41
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v128, v[12:15] offset:12288
	ds_store_b128 v128, v[8:11] offset:12320
	ds_store_b128 v128, v[16:19] offset:12352
	ds_store_b128 v128, v[20:23] offset:12384
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
		.amdhsa_next_free_vgpr 272
		.amdhsa_next_free_sgpr 48
		.amdhsa_named_barrier_count 0
		.amdhsa_reserve_vcc 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_fp16_overflow 0
		.amdhsa_memory_ordered 1
		.amdhsa_forward_progress 1
		.amdhsa_inst_pref_size 48
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

	.set kernel_grouped_nt_0.num_vgpr, 272
	.set kernel_grouped_nt_0.num_agpr, 0
	.set kernel_grouped_nt_0.numbered_sgpr, 48
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
    .sgpr_count:     50
    .sgpr_spill_count: 0
    .symbol:         kernel_grouped_nt_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     272
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.target:   amdgcn-amd-amdhsa--gfx1250
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
