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
	v_readfirstlane_b32 s40, v0
	s_add_co_i32 s2, s2, 1
	s_and_b32 s3, ttmp6, 15
	s_mul_i32 s2, ttmp9, s2
	s_getreg_b32 s4, hwreg(HW_REG_IB_STS2, 6, 4)
	s_add_co_i32 s5, s3, s2
	s_lshr_b32 s35, s40, 5
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
	s_sub_co_ci_u32 s29, s3, 0
	s_sub_co_i32 s30, s2, s12
	s_lshl_b32 s3, s29, 4
	s_abs_i32 s2, s30
	s_sub_co_i32 s4, 20, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_min_i32 s13, s4, 16
	s_abs_i32 s14, s13
	s_xor_b32 s12, s30, s13
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
	s_sub_co_i32 s31, s0, s12
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s38, s31, s13
	s_sub_co_i32 s0, s30, s38
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
	s_min_u32 s28, s0, 3
	s_add_co_i32 s0, s28, 4
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
	s_delay_alu instid0(SALU_CYCLE_1)
	s_lshl_b32 s3, s0, 8
	s_mov_b32 s0, 1
	s_sub_co_i32 s1, s1, s3
	s_add_co_i32 s3, s3, s2
	v_med3_i32 v1, s1, 0, 0x100
	s_cmp_gt_i32 s1, 0
	s_cselect_b32 s36, s3, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_ashr_i32 s37, s36, 31
	v_readfirstlane_b32 s33, v1
	s_cmp_eq_u32 s35, 0
	s_mul_u64 s[10:11], s[20:21], s[36:37]
	s_cselect_b32 s39, -1, 0
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
	s_cmp_lg_u32 s30, s38
	s_cselect_b32 s2, -1, 0
	s_cmp_lt_i32 s30, 0
	s_cselect_b32 s3, -1, 0
	s_cmp_gt_i32 s29, 1
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s3, s3, s12
	s_and_b32 s2, s3, s2
	s_sub_co_ci_u32 s2, s31, 0
	s_add_co_i32 s14, s25, 0xffffff00
	s_lshl_b32 s2, s2, 8
	s_ashr_i32 s29, s28, 31
	s_min_i32 s12, s2, s14
	s_cmp_eq_u32 s35, 1
	s_mul_u64 s[16:17], s[28:29], 0x1fa4000
	s_cselect_b32 s38, -1, 0
	s_cmp_lg_u32 s35, 1
	s_add_nc_u64 s[30:31], s[8:9], s[16:17]
	s_cbranch_scc1 .LBB0_4
	s_ashr_i32 s13, s12, 31
	s_brev_b32 s45, 64
	s_lshl_b64 s[8:9], s[12:13], 1
	s_mov_b32 s16, 1
	s_add_nc_u64 s[18:19], s[30:31], s[8:9]
	s_mov_b32 s51, 0
	s_add_co_i32 s17, 0, 0x11000
	s_bitset1_b32 s19, 31
	s_and_b32 s50, s23, 0xffff
	s_movk_i32 s48, 0x80
	s_mov_b32 s46, 0x800000
	s_mov_b32 s44, 0xfb00000
	s_mov_b32 s47, s45
	s_mov_b32 s49, s22
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[16:19], s[44:51]
.LBB0_4:
	s_ashr_i32 s3, s24, 31
	v_lshrrev_b32_e32 v1, 1, v0
	s_lshr_b32 s3, s3, 25
	s_set_vgpr_msb 0x80
	v_and_b32_e32 v4 /*v516*/, 16, v0
	s_add_co_i32 s3, s24, s3
	s_set_vgpr_msb 0x80c0
	v_and_b32_e32 v4 /*v772*/, 8, v1
	s_and_b32 s8, s3, 0xffffff80
	s_ashr_i32 s29, s3, 7
	s_cmp_lg_u32 s24, s8
	s_cselect_b32 s8, -1, 0
	s_cmp_lt_i32 s24, 0
	s_set_vgpr_msb 0xc030
	v_and_or_b32 v2, v0, 7, v4 /*v772*/
	s_cselect_b32 s9, -1, 0
	s_lshl_b32 s3, s40, 1
	s_lshl_b32 s35, s35, 7
	s_and_b32 s3, s3, 0xffffff80
	v_or_b32_e32 v1, s35, v0
	s_set_vgpr_msb 0x30c0
	v_and_or_b32 v1 /*v769*/, v0, 15, s3
	s_and_b32 s8, s9, s8
	v_or3_b32 v13 /*v781*/, v0, s3, 0x70
	s_cmp_lg_u32 s8, 0
	s_set_vgpr_msb 0xc000
	v_and_or_b32 v4, 0x88, v1, s2
	s_set_vgpr_msb 12
	v_mul_lo_u32 v3, 0x110, v1 /*v769*/
	s_set_vgpr_msb 0xc00
	v_mul_u32_u24_e32 v1, 0x220, v2
	s_sub_co_ci_u32 s24, s29, 0
	s_mov_b32 s9, -1
	v_subrev_nc_u32_e32 v2, s12, v4
	s_add_co_i32 s24, s24, -1
	s_delay_alu instid0(SALU_CYCLE_1)
	s_cmp_gt_i32 s24, 0
	s_set_vgpr_msb 0xc8
	v_add_nc_u32_e32 v9 /*v777*/, v3, v4 /*v516*/
	s_set_vgpr_msb 0xc800
	v_lshlrev_b32_e32 v2, 1, v2
	s_set_vgpr_msb 0xcc
	s_delay_alu instid0(VALU_DEP_2)
	v_add_nc_u32_e32 v14 /*v782*/, 64, v9 /*v777*/
	v_add_nc_u32_e32 v12 /*v780*/, 0x80, v9 /*v777*/
	v_add_nc_u32_e32 v11 /*v779*/, 0xc0, v9 /*v777*/
	s_set_vgpr_msb 0xcc00
	s_cbranch_scc1 .LBB0_6
	s_set_vgpr_msb 0x8c
	v_or3_b32 v0 /*v512*/, v0, s3, 0x70
	v_add_nc_u32_e32 v3 /*v515*/, 64, v9 /*v777*/
	v_add_nc_u32_e32 v2 /*v514*/, 0x80, v9 /*v777*/
	v_add_nc_u32_e32 v1 /*v513*/, 0xc0, v9 /*v777*/
	s_mov_b32 s9, 0
	s_set_vgpr_msb 0x8ce8
	v_mad_u32 v8 /*v776*/, 0x110, v0 /*v512*/, v4 /*v516*/
	s_set_vgpr_msb 0xe8cc
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u32_e32 v7 /*v775*/, 64, v8 /*v776*/
	v_add_nc_u32_e32 v6 /*v774*/, 0x80, v8 /*v776*/
	v_add_nc_u32_e32 v5 /*v773*/, 0xc0, v8 /*v776*/
	s_set_vgpr_msb 0xcc00
.LBB0_6:
	v_mov_b32_e32 v7, 0
	s_set_vgpr_msb 0xc0
	v_add3_u32 v10 /*v778*/, v1, v2, 0x11000
	s_and_not1_b32 vcc_lo, exec_lo, s9
	s_set_vgpr_msb 0xc000
	v_dual_mov_b32 v1, v7 :: v_dual_mov_b32 v2, v7
	v_dual_mov_b32 v6, v7 :: v_dual_mov_b32 v5, v7
	v_dual_mov_b32 v4, v7 :: v_dual_mov_b32 v3, v7
	v_dual_mov_b32 v0, v7 :: v_dual_mov_b32 v15, v7
	v_dual_mov_b32 v14, v7 :: v_dual_mov_b32 v13, v7
	v_dual_mov_b32 v12, v7 :: v_dual_mov_b32 v11, v7
	v_dual_mov_b32 v10, v7 :: v_dual_mov_b32 v9, v7
	v_dual_mov_b32 v8, v7 :: v_dual_mov_b32 v23, v7
	v_dual_mov_b32 v22, v7 :: v_dual_mov_b32 v21, v7
	v_dual_mov_b32 v20, v7 :: v_dual_mov_b32 v19, v7
	v_dual_mov_b32 v18, v7 :: v_dual_mov_b32 v17, v7
	v_dual_mov_b32 v16, v7 :: v_dual_mov_b32 v31, v7
	v_dual_mov_b32 v30, v7 :: v_dual_mov_b32 v29, v7
	v_dual_mov_b32 v28, v7 :: v_dual_mov_b32 v27, v7
	v_dual_mov_b32 v26, v7 :: v_dual_mov_b32 v25, v7
	v_dual_mov_b32 v24, v7 :: v_dual_mov_b32 v39, v7
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
	v_dual_mov_b32 v48, v7 :: v_dual_mov_b32 v63, v7
	v_dual_mov_b32 v62, v7 :: v_dual_mov_b32 v61, v7
	v_dual_mov_b32 v60, v7 :: v_dual_mov_b32 v59, v7
	v_dual_mov_b32 v58, v7 :: v_dual_mov_b32 v57, v7
	v_dual_mov_b32 v56, v7 :: v_dual_mov_b32 v71, v7
	v_dual_mov_b32 v70, v7 :: v_dual_mov_b32 v69, v7
	v_dual_mov_b32 v68, v7 :: v_dual_mov_b32 v67, v7
	v_dual_mov_b32 v66, v7 :: v_dual_mov_b32 v65, v7
	v_dual_mov_b32 v64, v7 :: v_dual_mov_b32 v79, v7
	v_dual_mov_b32 v78, v7 :: v_dual_mov_b32 v77, v7
	v_dual_mov_b32 v76, v7 :: v_dual_mov_b32 v75, v7
	v_dual_mov_b32 v74, v7 :: v_dual_mov_b32 v73, v7
	v_dual_mov_b32 v72, v7 :: v_dual_mov_b32 v87, v7
	v_dual_mov_b32 v86, v7 :: v_dual_mov_b32 v85, v7
	v_dual_mov_b32 v84, v7 :: v_dual_mov_b32 v83, v7
	v_dual_mov_b32 v82, v7 :: v_dual_mov_b32 v81, v7
	v_dual_mov_b32 v80, v7 :: v_dual_mov_b32 v95, v7
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
	v_dual_mov_b32 v104, v7 :: v_dual_mov_b32 v119, v7
	v_dual_mov_b32 v118, v7 :: v_dual_mov_b32 v117, v7
	v_dual_mov_b32 v116, v7 :: v_dual_mov_b32 v115, v7
	v_dual_mov_b32 v114, v7 :: v_dual_mov_b32 v113, v7
	v_dual_mov_b32 v112, v7 :: v_dual_mov_b32 v127, v7
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
	v_dual_mov_b32 v144, v7 :: v_dual_mov_b32 v159, v7
	v_dual_mov_b32 v158, v7 :: v_dual_mov_b32 v157, v7
	v_dual_mov_b32 v156, v7 :: v_dual_mov_b32 v155, v7
	v_dual_mov_b32 v154, v7 :: v_dual_mov_b32 v153, v7
	v_dual_mov_b32 v152, v7 :: v_dual_mov_b32 v167, v7
	v_dual_mov_b32 v166, v7 :: v_dual_mov_b32 v165, v7
	v_dual_mov_b32 v164, v7 :: v_dual_mov_b32 v163, v7
	v_dual_mov_b32 v162, v7 :: v_dual_mov_b32 v161, v7
	v_dual_mov_b32 v160, v7 :: v_dual_mov_b32 v175, v7
	v_dual_mov_b32 v174, v7 :: v_dual_mov_b32 v173, v7
	v_dual_mov_b32 v172, v7 :: v_dual_mov_b32 v171, v7
	v_dual_mov_b32 v170, v7 :: v_dual_mov_b32 v169, v7
	v_dual_mov_b32 v168, v7 :: v_dual_mov_b32 v183, v7
	v_dual_mov_b32 v182, v7 :: v_dual_mov_b32 v181, v7
	v_dual_mov_b32 v180, v7 :: v_dual_mov_b32 v179, v7
	v_dual_mov_b32 v178, v7 :: v_dual_mov_b32 v177, v7
	v_dual_mov_b32 v176, v7 :: v_dual_mov_b32 v191, v7
	v_dual_mov_b32 v190, v7 :: v_dual_mov_b32 v189, v7
	v_dual_mov_b32 v188, v7 :: v_dual_mov_b32 v187, v7
	v_dual_mov_b32 v186, v7 :: v_dual_mov_b32 v185, v7
	v_dual_mov_b32 v184, v7 :: v_dual_mov_b32 v199, v7
	v_dual_mov_b32 v198, v7 :: v_dual_mov_b32 v197, v7
	v_dual_mov_b32 v196, v7 :: v_dual_mov_b32 v195, v7
	v_dual_mov_b32 v194, v7 :: v_dual_mov_b32 v193, v7
	v_dual_mov_b32 v192, v7 :: v_dual_mov_b32 v207, v7
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
	v_dual_mov_b32 v216, v7 :: v_dual_mov_b32 v231, v7
	v_dual_mov_b32 v230, v7 :: v_dual_mov_b32 v229, v7
	v_dual_mov_b32 v228, v7 :: v_dual_mov_b32 v227, v7
	v_dual_mov_b32 v226, v7 :: v_dual_mov_b32 v225, v7
	v_dual_mov_b32 v224, v7 :: v_dual_mov_b32 v239, v7
	v_dual_mov_b32 v238, v7 :: v_dual_mov_b32 v237, v7
	v_dual_mov_b32 v236, v7 :: v_dual_mov_b32 v235, v7
	v_dual_mov_b32 v234, v7 :: v_dual_mov_b32 v233, v7
	v_dual_mov_b32 v232, v7 :: v_dual_mov_b32 v255, v7
	v_dual_mov_b32 v254, v7 :: v_dual_mov_b32 v253, v7
	v_dual_mov_b32 v252, v7 :: v_dual_mov_b32 v251, v7
	v_dual_mov_b32 v250, v7 :: v_dual_mov_b32 v249, v7
	v_dual_mov_b32 v248, v7 :: v_dual_mov_b32 v247, v7
	v_dual_mov_b32 v246, v7 :: v_dual_mov_b32 v245, v7
	v_dual_mov_b32 v244, v7 :: v_dual_mov_b32 v243, v7
	v_dual_mov_b32 v242, v7 :: v_dual_mov_b32 v241, v7
	v_mov_b32_e32 v240, v7
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
	v_dual_mov_b32 v35 /*v291*/, v7 :: v_dual_mov_b32 v34 /*v290*/, v7
	v_dual_mov_b32 v33 /*v289*/, v7 :: v_dual_mov_b32 v32 /*v288*/, v7
	v_dual_mov_b32 v47 /*v303*/, v7 :: v_dual_mov_b32 v46 /*v302*/, v7
	v_dual_mov_b32 v45 /*v301*/, v7 :: v_dual_mov_b32 v44 /*v300*/, v7
	v_dual_mov_b32 v43 /*v299*/, v7 :: v_dual_mov_b32 v42 /*v298*/, v7
	v_dual_mov_b32 v41 /*v297*/, v7 :: v_dual_mov_b32 v40 /*v296*/, v7
	v_dual_mov_b32 v55 /*v311*/, v7 :: v_dual_mov_b32 v54 /*v310*/, v7
	v_dual_mov_b32 v53 /*v309*/, v7 :: v_dual_mov_b32 v52 /*v308*/, v7
	v_dual_mov_b32 v51 /*v307*/, v7 :: v_dual_mov_b32 v50 /*v306*/, v7
	v_dual_mov_b32 v49 /*v305*/, v7 :: v_dual_mov_b32 v48 /*v304*/, v7
	v_dual_mov_b32 v63 /*v319*/, v7 :: v_dual_mov_b32 v62 /*v318*/, v7
	v_dual_mov_b32 v61 /*v317*/, v7 :: v_dual_mov_b32 v60 /*v316*/, v7
	v_dual_mov_b32 v59 /*v315*/, v7 :: v_dual_mov_b32 v58 /*v314*/, v7
	v_dual_mov_b32 v57 /*v313*/, v7 :: v_dual_mov_b32 v56 /*v312*/, v7
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
	v_dual_mov_b32 v95 /*v351*/, v7 :: v_dual_mov_b32 v94 /*v350*/, v7
	v_dual_mov_b32 v93 /*v349*/, v7 :: v_dual_mov_b32 v92 /*v348*/, v7
	v_dual_mov_b32 v91 /*v347*/, v7 :: v_dual_mov_b32 v90 /*v346*/, v7
	v_dual_mov_b32 v89 /*v345*/, v7 :: v_dual_mov_b32 v88 /*v344*/, v7
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
	v_dual_mov_b32 v127 /*v383*/, v7 :: v_dual_mov_b32 v126 /*v382*/, v7
	v_dual_mov_b32 v125 /*v381*/, v7 :: v_dual_mov_b32 v124 /*v380*/, v7
	v_dual_mov_b32 v123 /*v379*/, v7 :: v_dual_mov_b32 v122 /*v378*/, v7
	v_dual_mov_b32 v121 /*v377*/, v7 :: v_dual_mov_b32 v120 /*v376*/, v7
	v_dual_mov_b32 v135 /*v391*/, v7 :: v_dual_mov_b32 v134 /*v390*/, v7
	v_dual_mov_b32 v133 /*v389*/, v7 :: v_dual_mov_b32 v132 /*v388*/, v7
	v_dual_mov_b32 v131 /*v387*/, v7 :: v_dual_mov_b32 v130 /*v386*/, v7
	v_dual_mov_b32 v129 /*v385*/, v7 :: v_dual_mov_b32 v128 /*v384*/, v7
	v_dual_mov_b32 v143 /*v399*/, v7 :: v_dual_mov_b32 v142 /*v398*/, v7
	v_dual_mov_b32 v141 /*v397*/, v7 :: v_dual_mov_b32 v140 /*v396*/, v7
	v_dual_mov_b32 v139 /*v395*/, v7 :: v_dual_mov_b32 v138 /*v394*/, v7
	v_dual_mov_b32 v137 /*v393*/, v7 :: v_dual_mov_b32 v136 /*v392*/, v7
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
	v_dual_mov_b32 v183 /*v439*/, v7 :: v_dual_mov_b32 v182 /*v438*/, v7
	v_dual_mov_b32 v181 /*v437*/, v7 :: v_dual_mov_b32 v180 /*v436*/, v7
	v_dual_mov_b32 v179 /*v435*/, v7 :: v_dual_mov_b32 v178 /*v434*/, v7
	v_dual_mov_b32 v177 /*v433*/, v7 :: v_dual_mov_b32 v176 /*v432*/, v7
	v_dual_mov_b32 v199 /*v455*/, v7 :: v_dual_mov_b32 v198 /*v454*/, v7
	v_dual_mov_b32 v197 /*v453*/, v7 :: v_dual_mov_b32 v196 /*v452*/, v7
	v_dual_mov_b32 v195 /*v451*/, v7 :: v_dual_mov_b32 v194 /*v450*/, v7
	v_dual_mov_b32 v193 /*v449*/, v7 :: v_dual_mov_b32 v192 /*v448*/, v7
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
	v_dual_mov_b32 v231 /*v487*/, v7 :: v_dual_mov_b32 v230 /*v486*/, v7
	v_dual_mov_b32 v229 /*v485*/, v7 :: v_dual_mov_b32 v228 /*v484*/, v7
	v_dual_mov_b32 v227 /*v483*/, v7 :: v_dual_mov_b32 v226 /*v482*/, v7
	v_dual_mov_b32 v225 /*v481*/, v7 :: v_dual_mov_b32 v224 /*v480*/, v7
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
	s_cbranch_vccnz .LBB0_14
	s_cmp_lg_u32 s26, -2.0
	s_set_vgpr_msb 0xec
	v_mad_u32 v8 /*v776*/, 0x110, v13 /*v781*/, v4 /*v516*/
	s_cselect_b32 s13, s20, 0x100
	s_cselect_b32 s40, s21, 0
	s_ashr_i32 s3, s2, 31
	s_ashr_i32 s15, s14, 31
	s_set_vgpr_msb 0xec00
	v_cndmask_b32_e64 v1, 0, -1, s8
	v_min_i64 v[8:9], s[2:3], s[14:15]
	s_add_nc_u64 s[10:11], s[6:7], s[10:11]
	v_mov_b32_e32 v0, 0
	v_cndmask_b32_e64 v2, 0, 1, s39
	s_lshl_b64 s[6:7], s[0:1], 8
	s_max_i32 s14, s33, 0
	s_add_nc_u64 s[30:31], s[30:31], s[6:7]
	s_set_vgpr_msb 0xc0
	v_dual_mov_b32 v0 /*v768*/, 1 :: v_dual_add_nc_u32 v15 /*v783*/, s29, v1
	v_cmp_ne_u32_e64 s0, 1, v2
	s_set_vgpr_msb 0xc000
	v_dual_mov_b32 v1, v0 :: v_dual_mov_b32 v2, v0
	v_dual_mov_b32 v3, v0 :: v_dual_mov_b32 v4, v0
	v_dual_mov_b32 v5, v0 :: v_dual_mov_b32 v6, v0
	s_set_vgpr_msb 0xcc
	v_add_nc_u32_e32 v7 /*v775*/, 64, v8 /*v776*/
	v_add_nc_u32_e32 v6 /*v774*/, 0x80, v8 /*v776*/
	v_add_nc_u32_e32 v5 /*v773*/, 0xc0, v8 /*v776*/
	s_set_vgpr_msb 0xcc00
	v_dual_mov_b32 v7, v0 :: v_dual_mov_b32 v11, v0
	v_dual_mov_b32 v12, v0 :: v_dual_mov_b32 v13, v0
	v_dual_mov_b32 v14, v0 :: v_dual_mov_b32 v15, v0
	v_dual_mov_b32 v16, v0 :: v_dual_mov_b32 v17, v0
	v_dual_mov_b32 v18, v0 :: v_dual_mov_b32 v19, v0
	v_dual_mov_b32 v20, v0 :: v_dual_mov_b32 v21, v0
	v_dual_mov_b32 v22, v0 :: v_dual_mov_b32 v23, v0
	v_dual_mov_b32 v24, v0 :: v_dual_mov_b32 v25, v0
	v_dual_mov_b32 v26, v0 :: v_dual_mov_b32 v27, v0
	v_mov_b32_e32 v28, v0
	v_lshlrev_b64_e32 v[8:9], 1, v[8:9]
	v_dual_mov_b32 v29, v0 :: v_dual_mov_b32 v30, v0
	v_dual_mov_b32 v10, v0 :: v_dual_mov_b32 v31, v0
	v_mov_b32_e32 v32, v0
	s_set_vgpr_msb 0xc0
	s_delay_alu instid0(VALU_DEP_4)
	v_add_nc_u64_e32 v[2:3] /*v[770:771]*/, s[30:31], v[8:9]
	s_set_vgpr_msb 0xc000
	v_dual_mov_b32 v8, v0 :: v_dual_mov_b32 v33, v0
	v_dual_mov_b32 v34, v0 :: v_dual_mov_b32 v9, v0
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
	v_dual_mov_b32 v55, v0 :: v_dual_mov_b32 v56, v0
	v_dual_mov_b32 v57, v0 :: v_dual_mov_b32 v58, v0
	v_dual_mov_b32 v59, v0 :: v_dual_mov_b32 v60, v0
	v_dual_mov_b32 v61, v0 :: v_dual_mov_b32 v62, v0
	v_dual_mov_b32 v63, v0 :: v_dual_mov_b32 v64, v0
	v_dual_mov_b32 v65, v0 :: v_dual_mov_b32 v66, v0
	v_dual_mov_b32 v67, v0 :: v_dual_mov_b32 v68, v0
	v_dual_mov_b32 v69, v0 :: v_dual_mov_b32 v70, v0
	v_dual_mov_b32 v71, v0 :: v_dual_mov_b32 v72, v0
	v_dual_mov_b32 v73, v0 :: v_dual_mov_b32 v74, v0
	v_dual_mov_b32 v75, v0 :: v_dual_mov_b32 v76, v0
	v_dual_mov_b32 v77, v0 :: v_dual_mov_b32 v78, v0
	v_dual_mov_b32 v79, v0 :: v_dual_mov_b32 v80, v0
	v_dual_mov_b32 v81, v0 :: v_dual_mov_b32 v82, v0
	v_dual_mov_b32 v83, v0 :: v_dual_mov_b32 v84, v0
	v_dual_mov_b32 v85, v0 :: v_dual_mov_b32 v86, v0
	v_dual_mov_b32 v87, v0 :: v_dual_mov_b32 v88, v0
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
	v_dual_mov_b32 v111, v0 :: v_dual_mov_b32 v112, v0
	v_dual_mov_b32 v113, v0 :: v_dual_mov_b32 v114, v0
	v_dual_mov_b32 v115, v0 :: v_dual_mov_b32 v116, v0
	v_dual_mov_b32 v117, v0 :: v_dual_mov_b32 v118, v0
	v_dual_mov_b32 v119, v0 :: v_dual_mov_b32 v120, v0
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
	v_dual_mov_b32 v151, v0 :: v_dual_mov_b32 v152, v0
	v_dual_mov_b32 v153, v0 :: v_dual_mov_b32 v154, v0
	v_dual_mov_b32 v155, v0 :: v_dual_mov_b32 v156, v0
	v_dual_mov_b32 v157, v0 :: v_dual_mov_b32 v158, v0
	v_dual_mov_b32 v159, v0 :: v_dual_mov_b32 v160, v0
	v_dual_mov_b32 v161, v0 :: v_dual_mov_b32 v162, v0
	v_dual_mov_b32 v163, v0 :: v_dual_mov_b32 v164, v0
	v_dual_mov_b32 v165, v0 :: v_dual_mov_b32 v166, v0
	v_dual_mov_b32 v167, v0 :: v_dual_mov_b32 v168, v0
	v_dual_mov_b32 v169, v0 :: v_dual_mov_b32 v170, v0
	v_dual_mov_b32 v171, v0 :: v_dual_mov_b32 v172, v0
	v_dual_mov_b32 v173, v0 :: v_dual_mov_b32 v174, v0
	v_dual_mov_b32 v175, v0 :: v_dual_mov_b32 v176, v0
	v_dual_mov_b32 v177, v0 :: v_dual_mov_b32 v178, v0
	v_dual_mov_b32 v179, v0 :: v_dual_mov_b32 v180, v0
	v_dual_mov_b32 v181, v0 :: v_dual_mov_b32 v182, v0
	v_dual_mov_b32 v183, v0 :: v_dual_mov_b32 v184, v0
	v_dual_mov_b32 v185, v0 :: v_dual_mov_b32 v186, v0
	v_dual_mov_b32 v187, v0 :: v_dual_mov_b32 v188, v0
	v_dual_mov_b32 v189, v0 :: v_dual_mov_b32 v190, v0
	v_dual_mov_b32 v191, v0 :: v_dual_mov_b32 v192, v0
	v_dual_mov_b32 v193, v0 :: v_dual_mov_b32 v194, v0
	v_dual_mov_b32 v195, v0 :: v_dual_mov_b32 v196, v0
	v_dual_mov_b32 v197, v0 :: v_dual_mov_b32 v198, v0
	v_dual_mov_b32 v199, v0 :: v_dual_mov_b32 v200, v0
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
	v_dual_mov_b32 v223, v0 :: v_dual_mov_b32 v224, v0
	v_dual_mov_b32 v225, v0 :: v_dual_mov_b32 v226, v0
	v_dual_mov_b32 v227, v0 :: v_dual_mov_b32 v228, v0
	v_dual_mov_b32 v229, v0 :: v_dual_mov_b32 v230, v0
	v_dual_mov_b32 v231, v0 :: v_dual_mov_b32 v232, v0
	v_dual_mov_b32 v246, v0 :: v_dual_mov_b32 v245, v0
	v_dual_mov_b32 v244, v0 :: v_dual_mov_b32 v243, v0
	v_dual_mov_b32 v242, v0 :: v_dual_mov_b32 v241, v0
	v_dual_mov_b32 v240, v0 :: v_dual_mov_b32 v255, v0
	v_dual_mov_b32 v254, v0 :: v_dual_mov_b32 v253, v0
	v_dual_mov_b32 v252, v0 :: v_dual_mov_b32 v251, v0
	v_dual_mov_b32 v250, v0 :: v_dual_mov_b32 v249, v0
	v_dual_mov_b32 v248, v0 :: v_dual_mov_b32 v239, v0
	v_dual_mov_b32 v238, v0 :: v_dual_mov_b32 v237, v0
	v_dual_mov_b32 v236, v0 :: v_dual_mov_b32 v235, v0
	v_dual_mov_b32 v234, v0 :: v_dual_mov_b32 v233, v0
	v_mov_b32_e32 v247, v0
	s_set_vgpr_msb 64
	v_dual_mov_b32 v0 /*v256*/, v0 :: v_dual_mov_b32 v1 /*v257*/, v0
	v_dual_mov_b32 v2 /*v258*/, v0 :: v_dual_mov_b32 v3 /*v259*/, v0
	v_dual_mov_b32 v4 /*v260*/, v0 :: v_dual_mov_b32 v5 /*v261*/, v0
	v_dual_mov_b32 v6 /*v262*/, v0 :: v_dual_mov_b32 v7 /*v263*/, v0
	v_dual_mov_b32 v8 /*v264*/, v0 :: v_dual_mov_b32 v9 /*v265*/, v0
	v_dual_mov_b32 v10 /*v266*/, v0 :: v_dual_mov_b32 v11 /*v267*/, v0
	v_dual_mov_b32 v12 /*v268*/, v0 :: v_dual_mov_b32 v13 /*v269*/, v0
	v_dual_mov_b32 v14 /*v270*/, v0 :: v_dual_mov_b32 v15 /*v271*/, v0
	v_dual_mov_b32 v16 /*v272*/, v0 :: v_dual_mov_b32 v17 /*v273*/, v0
	v_dual_mov_b32 v18 /*v274*/, v0 :: v_dual_mov_b32 v19 /*v275*/, v0
	v_dual_mov_b32 v20 /*v276*/, v0 :: v_dual_mov_b32 v21 /*v277*/, v0
	v_dual_mov_b32 v22 /*v278*/, v0 :: v_dual_mov_b32 v23 /*v279*/, v0
	v_dual_mov_b32 v24 /*v280*/, v0 :: v_dual_mov_b32 v25 /*v281*/, v0
	v_dual_mov_b32 v26 /*v282*/, v0 :: v_dual_mov_b32 v27 /*v283*/, v0
	v_dual_mov_b32 v28 /*v284*/, v0 :: v_dual_mov_b32 v29 /*v285*/, v0
	v_dual_mov_b32 v30 /*v286*/, v0 :: v_dual_mov_b32 v31 /*v287*/, v0
	v_dual_mov_b32 v32 /*v288*/, v0 :: v_dual_mov_b32 v33 /*v289*/, v0
	v_dual_mov_b32 v34 /*v290*/, v0 :: v_dual_mov_b32 v35 /*v291*/, v0
	v_dual_mov_b32 v36 /*v292*/, v0 :: v_dual_mov_b32 v37 /*v293*/, v0
	v_dual_mov_b32 v38 /*v294*/, v0 :: v_dual_mov_b32 v39 /*v295*/, v0
	v_dual_mov_b32 v40 /*v296*/, v0 :: v_dual_mov_b32 v41 /*v297*/, v0
	v_dual_mov_b32 v42 /*v298*/, v0 :: v_dual_mov_b32 v43 /*v299*/, v0
	v_dual_mov_b32 v44 /*v300*/, v0 :: v_dual_mov_b32 v45 /*v301*/, v0
	v_dual_mov_b32 v46 /*v302*/, v0 :: v_dual_mov_b32 v47 /*v303*/, v0
	v_dual_mov_b32 v48 /*v304*/, v0 :: v_dual_mov_b32 v49 /*v305*/, v0
	v_dual_mov_b32 v50 /*v306*/, v0 :: v_dual_mov_b32 v51 /*v307*/, v0
	v_dual_mov_b32 v52 /*v308*/, v0 :: v_dual_mov_b32 v53 /*v309*/, v0
	v_dual_mov_b32 v54 /*v310*/, v0 :: v_dual_mov_b32 v55 /*v311*/, v0
	v_dual_mov_b32 v56 /*v312*/, v0 :: v_dual_mov_b32 v57 /*v313*/, v0
	v_dual_mov_b32 v58 /*v314*/, v0 :: v_dual_mov_b32 v59 /*v315*/, v0
	v_dual_mov_b32 v60 /*v316*/, v0 :: v_dual_mov_b32 v61 /*v317*/, v0
	v_dual_mov_b32 v62 /*v318*/, v0 :: v_dual_mov_b32 v63 /*v319*/, v0
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
	v_dual_mov_b32 v88 /*v344*/, v0 :: v_dual_mov_b32 v89 /*v345*/, v0
	v_dual_mov_b32 v90 /*v346*/, v0 :: v_dual_mov_b32 v91 /*v347*/, v0
	v_dual_mov_b32 v92 /*v348*/, v0 :: v_dual_mov_b32 v93 /*v349*/, v0
	v_dual_mov_b32 v94 /*v350*/, v0 :: v_dual_mov_b32 v95 /*v351*/, v0
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
	v_dual_mov_b32 v120 /*v376*/, v0 :: v_dual_mov_b32 v121 /*v377*/, v0
	v_dual_mov_b32 v122 /*v378*/, v0 :: v_dual_mov_b32 v123 /*v379*/, v0
	v_dual_mov_b32 v124 /*v380*/, v0 :: v_dual_mov_b32 v125 /*v381*/, v0
	v_dual_mov_b32 v126 /*v382*/, v0 :: v_dual_mov_b32 v127 /*v383*/, v0
	v_dual_mov_b32 v128 /*v384*/, v0 :: v_dual_mov_b32 v129 /*v385*/, v0
	v_dual_mov_b32 v130 /*v386*/, v0 :: v_dual_mov_b32 v131 /*v387*/, v0
	v_dual_mov_b32 v132 /*v388*/, v0 :: v_dual_mov_b32 v133 /*v389*/, v0
	v_dual_mov_b32 v134 /*v390*/, v0 :: v_dual_mov_b32 v135 /*v391*/, v0
	v_dual_mov_b32 v136 /*v392*/, v0 :: v_dual_mov_b32 v137 /*v393*/, v0
	v_dual_mov_b32 v138 /*v394*/, v0 :: v_dual_mov_b32 v139 /*v395*/, v0
	v_dual_mov_b32 v140 /*v396*/, v0 :: v_dual_mov_b32 v141 /*v397*/, v0
	v_dual_mov_b32 v142 /*v398*/, v0 :: v_dual_mov_b32 v143 /*v399*/, v0
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
	v_dual_mov_b32 v176 /*v432*/, v0 :: v_dual_mov_b32 v177 /*v433*/, v0
	v_dual_mov_b32 v178 /*v434*/, v0 :: v_dual_mov_b32 v179 /*v435*/, v0
	v_dual_mov_b32 v180 /*v436*/, v0 :: v_dual_mov_b32 v181 /*v437*/, v0
	v_dual_mov_b32 v182 /*v438*/, v0 :: v_dual_mov_b32 v183 /*v439*/, v0
	v_dual_mov_b32 v192 /*v448*/, v0 :: v_dual_mov_b32 v193 /*v449*/, v0
	v_dual_mov_b32 v194 /*v450*/, v0 :: v_dual_mov_b32 v195 /*v451*/, v0
	v_dual_mov_b32 v196 /*v452*/, v0 :: v_dual_mov_b32 v197 /*v453*/, v0
	v_dual_mov_b32 v198 /*v454*/, v0 :: v_dual_mov_b32 v199 /*v455*/, v0
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
	v_dual_mov_b32 v224 /*v480*/, v0 :: v_dual_mov_b32 v225 /*v481*/, v0
	v_dual_mov_b32 v226 /*v482*/, v0 :: v_dual_mov_b32 v227 /*v483*/, v0
	v_dual_mov_b32 v228 /*v484*/, v0 :: v_dual_mov_b32 v229 /*v485*/, v0
	v_dual_mov_b32 v230 /*v486*/, v0 :: v_dual_mov_b32 v231 /*v487*/, v0
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
	s_mov_b32 s15, 0
	s_brev_b32 s17, 64
	s_add_nc_u64 s[26:27], s[10:11], 0x100
	s_lshl_b32 s1, s14, 16
	s_lshr_b32 s11, s14, 16
	s_movk_i32 s12, 0x100
	s_mov_b32 s9, 0xffff0000
	s_mov_b32 s8, 0x7700000
	s_movk_i32 s20, 0x80
	s_mov_b32 s18, 0x800000
	s_mov_b32 s16, 0xfb00000
	s_mov_b32 s21, s22
	s_mov_b32 s28, 1
	s_mov_b32 s3, 1
	s_and_b32 s22, s23, 0xffff
	s_mov_b32 s19, s17
	s_mov_b32 s23, s15
	s_and_b32 s14, s40, 0xffff
	s_or_b32 s10, s1, 0x7fff
	s_bitset1_b32 s11, 24
	s_set_vgpr_msb 0x4000
	s_branch .LBB0_9
.LBB0_8:
	s_set_vgpr_msb 10
	s_wait_dscnt 0x8
	v_wmma_f32_16x16x32_bf16 v[0:7], v[136:143] /*v[648:655]*/, v[248:255] /*v[760:767]*/, v[0:7]
	v_wmma_f32_16x16x32_bf16 v[8:15], v[144:151] /*v[656:663]*/, v[248:255] /*v[760:767]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[152:159] /*v[664:671]*/, v[248:255] /*v[760:767]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[168:175] /*v[680:687]*/, v[248:255] /*v[760:767]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[176:183] /*v[688:695]*/, v[248:255] /*v[760:767]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[184:191] /*v[696:703]*/, v[248:255] /*v[760:767]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[200:207] /*v[712:719]*/, v[248:255] /*v[760:767]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[208:215] /*v[720:727]*/, v[248:255] /*v[760:767]*/, v[56:63]
	s_wait_dscnt 0x6
	v_wmma_f32_16x16x32_bf16 v[120:127], v[208:215] /*v[720:727]*/, v[240:247] /*v[752:759]*/, v[120:127]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[200:207] /*v[712:719]*/, v[240:247] /*v[752:759]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[184:191] /*v[696:703]*/, v[240:247] /*v[752:759]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[176:183] /*v[688:695]*/, v[240:247] /*v[752:759]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[168:175] /*v[680:687]*/, v[240:247] /*v[752:759]*/, v[88:95]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[152:159] /*v[664:671]*/, v[240:247] /*v[752:759]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[144:151] /*v[656:663]*/, v[240:247] /*v[752:759]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[136:143] /*v[648:655]*/, v[240:247] /*v[752:759]*/, v[64:71]
	s_wait_dscnt 0x4
	v_wmma_f32_16x16x32_bf16 v[128:135], v[136:143] /*v[648:655]*/, v[232:239] /*v[744:751]*/, v[128:135]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[144:151] /*v[656:663]*/, v[232:239] /*v[744:751]*/, v[136:143]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[152:159] /*v[664:671]*/, v[232:239] /*v[744:751]*/, v[144:151]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[168:175] /*v[680:687]*/, v[232:239] /*v[744:751]*/, v[152:159]
	v_wmma_f32_16x16x32_bf16 v[160:167], v[176:183] /*v[688:695]*/, v[232:239] /*v[744:751]*/, v[160:167]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[184:191] /*v[696:703]*/, v[232:239] /*v[744:751]*/, v[168:175]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[200:207] /*v[712:719]*/, v[232:239] /*v[744:751]*/, v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[208:215] /*v[720:727]*/, v[232:239] /*v[744:751]*/, v[184:191]
	s_wait_dscnt 0x2
	v_wmma_f32_16x16x32_bf16 v[240:247], v[208:215] /*v[720:727]*/, v[224:231] /*v[736:743]*/, v[240:247]
	v_wmma_f32_16x16x32_bf16 v[248:255], v[200:207] /*v[712:719]*/, v[224:231] /*v[736:743]*/, v[248:255]
	v_wmma_f32_16x16x32_bf16 v[232:239], v[184:191] /*v[696:703]*/, v[224:231] /*v[736:743]*/, v[232:239]
	v_wmma_f32_16x16x32_bf16 v[224:231], v[176:183] /*v[688:695]*/, v[224:231] /*v[736:743]*/, v[224:231]
	v_wmma_f32_16x16x32_bf16 v[216:223], v[168:175] /*v[680:687]*/, v[224:231] /*v[736:743]*/, v[216:223]
	v_wmma_f32_16x16x32_bf16 v[208:215], v[152:159] /*v[664:671]*/, v[224:231] /*v[736:743]*/, v[208:215]
	v_wmma_f32_16x16x32_bf16 v[200:207], v[144:151] /*v[656:663]*/, v[224:231] /*v[736:743]*/, v[200:207]
	v_wmma_f32_16x16x32_bf16 v[192:199], v[136:143] /*v[648:655]*/, v[224:231] /*v[736:743]*/, v[192:199]
	s_set_vgpr_msb 0xa5a
	s_wait_dscnt 0x0
	v_wmma_f32_16x16x32_bf16 v[0:7] /*v[256:263]*/, v[136:143] /*v[648:655]*/, v[216:223] /*v[728:735]*/, v[0:7] /*v[256:263]*/
	v_wmma_f32_16x16x32_bf16 v[8:15] /*v[264:271]*/, v[144:151] /*v[656:663]*/, v[216:223] /*v[728:735]*/, v[8:15] /*v[264:271]*/
	v_wmma_f32_16x16x32_bf16 v[16:23] /*v[272:279]*/, v[152:159] /*v[664:671]*/, v[216:223] /*v[728:735]*/, v[16:23] /*v[272:279]*/
	v_wmma_f32_16x16x32_bf16 v[24:31] /*v[280:287]*/, v[168:175] /*v[680:687]*/, v[216:223] /*v[728:735]*/, v[24:31] /*v[280:287]*/
	v_wmma_f32_16x16x32_bf16 v[32:39] /*v[288:295]*/, v[176:183] /*v[688:695]*/, v[216:223] /*v[728:735]*/, v[32:39] /*v[288:295]*/
	v_wmma_f32_16x16x32_bf16 v[40:47] /*v[296:303]*/, v[184:191] /*v[696:703]*/, v[216:223] /*v[728:735]*/, v[40:47] /*v[296:303]*/
	v_wmma_f32_16x16x32_bf16 v[48:55] /*v[304:311]*/, v[200:207] /*v[712:719]*/, v[216:223] /*v[728:735]*/, v[48:55] /*v[304:311]*/
	v_wmma_f32_16x16x32_bf16 v[56:63] /*v[312:319]*/, v[208:215] /*v[720:727]*/, v[216:223] /*v[728:735]*/, v[56:63] /*v[312:319]*/
	v_wmma_f32_16x16x32_bf16 v[120:127] /*v[376:383]*/, v[208:215] /*v[720:727]*/, v[192:199] /*v[704:711]*/, v[120:127] /*v[376:383]*/
	v_wmma_f32_16x16x32_bf16 v[112:119] /*v[368:375]*/, v[200:207] /*v[712:719]*/, v[192:199] /*v[704:711]*/, v[112:119] /*v[368:375]*/
	v_wmma_f32_16x16x32_bf16 v[104:111] /*v[360:367]*/, v[184:191] /*v[696:703]*/, v[192:199] /*v[704:711]*/, v[104:111] /*v[360:367]*/
	v_wmma_f32_16x16x32_bf16 v[96:103] /*v[352:359]*/, v[176:183] /*v[688:695]*/, v[192:199] /*v[704:711]*/, v[96:103] /*v[352:359]*/
	v_wmma_f32_16x16x32_bf16 v[88:95] /*v[344:351]*/, v[168:175] /*v[680:687]*/, v[192:199] /*v[704:711]*/, v[88:95] /*v[344:351]*/
	v_wmma_f32_16x16x32_bf16 v[80:87] /*v[336:343]*/, v[152:159] /*v[664:671]*/, v[192:199] /*v[704:711]*/, v[80:87] /*v[336:343]*/
	v_wmma_f32_16x16x32_bf16 v[72:79] /*v[328:335]*/, v[144:151] /*v[656:663]*/, v[192:199] /*v[704:711]*/, v[72:79] /*v[328:335]*/
	v_wmma_f32_16x16x32_bf16 v[64:71] /*v[320:327]*/, v[136:143] /*v[648:655]*/, v[192:199] /*v[704:711]*/, v[64:71] /*v[320:327]*/
	v_wmma_f32_16x16x32_bf16 v[128:135] /*v[384:391]*/, v[136:143] /*v[648:655]*/, v[160:167] /*v[672:679]*/, v[128:135] /*v[384:391]*/
	v_wmma_f32_16x16x32_bf16 v[136:143] /*v[392:399]*/, v[144:151] /*v[656:663]*/, v[160:167] /*v[672:679]*/, v[136:143] /*v[392:399]*/
	v_wmma_f32_16x16x32_bf16 v[144:151] /*v[400:407]*/, v[152:159] /*v[664:671]*/, v[160:167] /*v[672:679]*/, v[144:151] /*v[400:407]*/
	v_wmma_f32_16x16x32_bf16 v[152:159] /*v[408:415]*/, v[168:175] /*v[680:687]*/, v[160:167] /*v[672:679]*/, v[152:159] /*v[408:415]*/
	v_wmma_f32_16x16x32_bf16 v[160:167] /*v[416:423]*/, v[176:183] /*v[688:695]*/, v[160:167] /*v[672:679]*/, v[160:167] /*v[416:423]*/
	v_wmma_f32_16x16x32_bf16 v[168:175] /*v[424:431]*/, v[184:191] /*v[696:703]*/, v[160:167] /*v[672:679]*/, v[168:175] /*v[424:431]*/
	v_wmma_f32_16x16x32_bf16 v[176:183] /*v[432:439]*/, v[200:207] /*v[712:719]*/, v[160:167] /*v[672:679]*/, v[176:183] /*v[432:439]*/
	v_wmma_f32_16x16x32_bf16 v[192:199] /*v[448:455]*/, v[208:215] /*v[720:727]*/, v[160:167] /*v[672:679]*/, v[192:199] /*v[448:455]*/
	v_wmma_f32_16x16x32_bf16 v[248:255] /*v[504:511]*/, v[208:215] /*v[720:727]*/, v[128:135] /*v[640:647]*/, v[248:255] /*v[504:511]*/
	v_wmma_f32_16x16x32_bf16 v[240:247] /*v[496:503]*/, v[200:207] /*v[712:719]*/, v[128:135] /*v[640:647]*/, v[240:247] /*v[496:503]*/
	v_wmma_f32_16x16x32_bf16 v[232:239] /*v[488:495]*/, v[184:191] /*v[696:703]*/, v[128:135] /*v[640:647]*/, v[232:239] /*v[488:495]*/
	v_wmma_f32_16x16x32_bf16 v[224:231] /*v[480:487]*/, v[176:183] /*v[688:695]*/, v[128:135] /*v[640:647]*/, v[224:231] /*v[480:487]*/
	v_wmma_f32_16x16x32_bf16 v[216:223] /*v[472:479]*/, v[168:175] /*v[680:687]*/, v[128:135] /*v[640:647]*/, v[216:223] /*v[472:479]*/
	v_wmma_f32_16x16x32_bf16 v[208:215] /*v[464:471]*/, v[152:159] /*v[664:671]*/, v[128:135] /*v[640:647]*/, v[208:215] /*v[464:471]*/
	v_wmma_f32_16x16x32_bf16 v[200:207] /*v[456:463]*/, v[144:151] /*v[656:663]*/, v[128:135] /*v[640:647]*/, v[200:207] /*v[456:463]*/
	v_wmma_f32_16x16x32_bf16 v[184:191] /*v[440:447]*/, v[136:143] /*v[648:655]*/, v[128:135] /*v[640:647]*/, v[184:191] /*v[440:447]*/
	s_set_vgpr_msb 0x5a83
	ds_load_b128 v[128:131] /*v[640:643]*/, v17 /*v785*/ offset:128
	ds_load_b128 v[132:135] /*v[644:647]*/, v17 /*v785*/ offset:160
	ds_load_b128 v[136:139] /*v[648:651]*/, v17 /*v785*/ offset:4480
	ds_load_b128 v[140:143] /*v[652:655]*/, v17 /*v785*/ offset:4512
	ds_load_b128 v[144:147] /*v[656:659]*/, v17 /*v785*/ offset:8832
	ds_load_b128 v[148:151] /*v[660:663]*/, v17 /*v785*/ offset:8864
	ds_load_b128 v[152:155] /*v[664:667]*/, v17 /*v785*/ offset:13184
	ds_load_b128 v[156:159] /*v[668:671]*/, v17 /*v785*/ offset:13216
	ds_load_b128 v[160:163] /*v[672:675]*/, v17 /*v785*/ offset:17536
	ds_load_b128 v[164:167] /*v[676:679]*/, v17 /*v785*/ offset:17568
	ds_load_b128 v[168:171] /*v[680:683]*/, v17 /*v785*/ offset:21888
	ds_load_b128 v[172:175] /*v[684:687]*/, v17 /*v785*/ offset:21920
	ds_load_b128 v[176:179] /*v[688:691]*/, v17 /*v785*/ offset:26240
	ds_load_b128 v[180:183] /*v[692:695]*/, v17 /*v785*/ offset:26272
	ds_load_b128 v[184:187] /*v[696:699]*/, v18 /*v786*/ offset:128
	ds_load_b128 v[188:191] /*v[700:703]*/, v18 /*v786*/ offset:160
	ds_load_tr16_b128 v[192:195] /*v[704:707]*/, v16 /*v784*/ offset:34816
	ds_load_tr16_b128 v[200:203] /*v[712:715]*/, v16 /*v784*/ offset:34848
	ds_load_tr16_b128 v[196:199] /*v[708:711]*/, v16 /*v784*/ offset:43520
	ds_load_tr16_b128 v[204:207] /*v[716:719]*/, v16 /*v784*/ offset:43552
	ds_load_tr16_b128 v[208:211] /*v[720:723]*/, v16 /*v784*/ offset:34880
	ds_load_tr16_b128 v[216:219] /*v[728:731]*/, v16 /*v784*/ offset:34912
	ds_load_tr16_b128 v[212:215] /*v[724:727]*/, v16 /*v784*/ offset:43584
	ds_load_tr16_b128 v[220:223] /*v[732:735]*/, v16 /*v784*/ offset:43616
	ds_load_tr16_b128 v[224:227] /*v[736:739]*/, v16 /*v784*/ offset:34944
	ds_load_tr16_b128 v[232:235] /*v[744:747]*/, v16 /*v784*/ offset:34976
	ds_load_tr16_b128 v[228:231] /*v[740:743]*/, v16 /*v784*/ offset:43648
	ds_load_tr16_b128 v[236:239] /*v[748:751]*/, v16 /*v784*/ offset:43680
	ds_load_tr16_b128 v[240:243] /*v[752:755]*/, v16 /*v784*/ offset:35008
	ds_load_tr16_b128 v[248:251] /*v[760:763]*/, v16 /*v784*/ offset:35040
	ds_load_tr16_b128 v[244:247] /*v[756:759]*/, v16 /*v784*/ offset:43712
	ds_load_tr16_b128 v[252:255] /*v[764:767]*/, v16 /*v784*/ offset:43744
	s_set_vgpr_msb 0x830a
	v_wmma_f32_16x16x32_bf16 v[0:7], v[8:15] /*v[520:527]*/, v[120:127] /*v[632:639]*/, v[0:7]
	s_wait_dscnt 0x20
	v_wmma_f32_16x16x32_bf16 v[8:15], v[16:23] /*v[528:535]*/, v[120:127] /*v[632:639]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[24:31] /*v[536:543]*/, v[120:127] /*v[632:639]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[40:47] /*v[552:559]*/, v[120:127] /*v[632:639]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[48:55] /*v[560:567]*/, v[120:127] /*v[632:639]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[56:63] /*v[568:575]*/, v[120:127] /*v[632:639]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[72:79] /*v[584:591]*/, v[120:127] /*v[632:639]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[80:87] /*v[592:599]*/, v[120:127] /*v[632:639]*/, v[56:63]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[80:87] /*v[592:599]*/, v[112:119] /*v[624:631]*/, v[120:127]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[72:79] /*v[584:591]*/, v[112:119] /*v[624:631]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[56:63] /*v[568:575]*/, v[112:119] /*v[624:631]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[48:55] /*v[560:567]*/, v[112:119] /*v[624:631]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[40:47] /*v[552:559]*/, v[112:119] /*v[624:631]*/, v[88:95]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[24:31] /*v[536:543]*/, v[112:119] /*v[624:631]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[16:23] /*v[528:535]*/, v[112:119] /*v[624:631]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[8:15] /*v[520:527]*/, v[112:119] /*v[624:631]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[8:15] /*v[520:527]*/, v[104:111] /*v[616:623]*/, v[128:135]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[16:23] /*v[528:535]*/, v[104:111] /*v[616:623]*/, v[136:143]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[24:31] /*v[536:543]*/, v[104:111] /*v[616:623]*/, v[144:151]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[40:47] /*v[552:559]*/, v[104:111] /*v[616:623]*/, v[152:159]
	v_wmma_f32_16x16x32_bf16 v[160:167], v[48:55] /*v[560:567]*/, v[104:111] /*v[616:623]*/, v[160:167]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[56:63] /*v[568:575]*/, v[104:111] /*v[616:623]*/, v[168:175]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[72:79] /*v[584:591]*/, v[104:111] /*v[616:623]*/, v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[80:87] /*v[592:599]*/, v[104:111] /*v[616:623]*/, v[184:191]
	v_wmma_f32_16x16x32_bf16 v[240:247], v[80:87] /*v[592:599]*/, v[96:103] /*v[608:615]*/, v[240:247]
	v_wmma_f32_16x16x32_bf16 v[248:255], v[72:79] /*v[584:591]*/, v[96:103] /*v[608:615]*/, v[248:255]
	v_wmma_f32_16x16x32_bf16 v[232:239], v[56:63] /*v[568:575]*/, v[96:103] /*v[608:615]*/, v[232:239]
	v_wmma_f32_16x16x32_bf16 v[224:231], v[48:55] /*v[560:567]*/, v[96:103] /*v[608:615]*/, v[224:231]
	v_wmma_f32_16x16x32_bf16 v[216:223], v[40:47] /*v[552:559]*/, v[96:103] /*v[608:615]*/, v[216:223]
	v_wmma_f32_16x16x32_bf16 v[208:215], v[24:31] /*v[536:543]*/, v[96:103] /*v[608:615]*/, v[208:215]
	v_wmma_f32_16x16x32_bf16 v[200:207], v[16:23] /*v[528:535]*/, v[96:103] /*v[608:615]*/, v[200:207]
	v_wmma_f32_16x16x32_bf16 v[192:199], v[8:15] /*v[520:527]*/, v[96:103] /*v[608:615]*/, v[192:199]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[0:7] /*v[256:263]*/, v[8:15] /*v[520:527]*/, v[88:95] /*v[600:607]*/, v[0:7] /*v[256:263]*/
	v_wmma_f32_16x16x32_bf16 v[8:15] /*v[264:271]*/, v[16:23] /*v[528:535]*/, v[88:95] /*v[600:607]*/, v[8:15] /*v[264:271]*/
	v_wmma_f32_16x16x32_bf16 v[16:23] /*v[272:279]*/, v[24:31] /*v[536:543]*/, v[88:95] /*v[600:607]*/, v[16:23] /*v[272:279]*/
	v_wmma_f32_16x16x32_bf16 v[24:31] /*v[280:287]*/, v[40:47] /*v[552:559]*/, v[88:95] /*v[600:607]*/, v[24:31] /*v[280:287]*/
	v_wmma_f32_16x16x32_bf16 v[32:39] /*v[288:295]*/, v[48:55] /*v[560:567]*/, v[88:95] /*v[600:607]*/, v[32:39] /*v[288:295]*/
	v_wmma_f32_16x16x32_bf16 v[40:47] /*v[296:303]*/, v[56:63] /*v[568:575]*/, v[88:95] /*v[600:607]*/, v[40:47] /*v[296:303]*/
	v_wmma_f32_16x16x32_bf16 v[48:55] /*v[304:311]*/, v[72:79] /*v[584:591]*/, v[88:95] /*v[600:607]*/, v[48:55] /*v[304:311]*/
	v_wmma_f32_16x16x32_bf16 v[56:63] /*v[312:319]*/, v[80:87] /*v[592:599]*/, v[88:95] /*v[600:607]*/, v[56:63] /*v[312:319]*/
	v_wmma_f32_16x16x32_bf16 v[120:127] /*v[376:383]*/, v[80:87] /*v[592:599]*/, v[64:71] /*v[576:583]*/, v[120:127] /*v[376:383]*/
	v_wmma_f32_16x16x32_bf16 v[112:119] /*v[368:375]*/, v[72:79] /*v[584:591]*/, v[64:71] /*v[576:583]*/, v[112:119] /*v[368:375]*/
	v_wmma_f32_16x16x32_bf16 v[104:111] /*v[360:367]*/, v[56:63] /*v[568:575]*/, v[64:71] /*v[576:583]*/, v[104:111] /*v[360:367]*/
	v_wmma_f32_16x16x32_bf16 v[96:103] /*v[352:359]*/, v[48:55] /*v[560:567]*/, v[64:71] /*v[576:583]*/, v[96:103] /*v[352:359]*/
	v_wmma_f32_16x16x32_bf16 v[88:95] /*v[344:351]*/, v[40:47] /*v[552:559]*/, v[64:71] /*v[576:583]*/, v[88:95] /*v[344:351]*/
	v_wmma_f32_16x16x32_bf16 v[80:87] /*v[336:343]*/, v[24:31] /*v[536:543]*/, v[64:71] /*v[576:583]*/, v[80:87] /*v[336:343]*/
	v_wmma_f32_16x16x32_bf16 v[72:79] /*v[328:335]*/, v[16:23] /*v[528:535]*/, v[64:71] /*v[576:583]*/, v[72:79] /*v[328:335]*/
	v_wmma_f32_16x16x32_bf16 v[64:71] /*v[320:327]*/, v[8:15] /*v[520:527]*/, v[64:71] /*v[576:583]*/, v[64:71] /*v[320:327]*/
	v_wmma_f32_16x16x32_bf16 v[128:135] /*v[384:391]*/, v[8:15] /*v[520:527]*/, v[32:39] /*v[544:551]*/, v[128:135] /*v[384:391]*/
	v_wmma_f32_16x16x32_bf16 v[136:143] /*v[392:399]*/, v[16:23] /*v[528:535]*/, v[32:39] /*v[544:551]*/, v[136:143] /*v[392:399]*/
	v_wmma_f32_16x16x32_bf16 v[144:151] /*v[400:407]*/, v[24:31] /*v[536:543]*/, v[32:39] /*v[544:551]*/, v[144:151] /*v[400:407]*/
	v_wmma_f32_16x16x32_bf16 v[152:159] /*v[408:415]*/, v[40:47] /*v[552:559]*/, v[32:39] /*v[544:551]*/, v[152:159] /*v[408:415]*/
	v_wmma_f32_16x16x32_bf16 v[160:167] /*v[416:423]*/, v[48:55] /*v[560:567]*/, v[32:39] /*v[544:551]*/, v[160:167] /*v[416:423]*/
	v_wmma_f32_16x16x32_bf16 v[168:175] /*v[424:431]*/, v[56:63] /*v[568:575]*/, v[32:39] /*v[544:551]*/, v[168:175] /*v[424:431]*/
	v_wmma_f32_16x16x32_bf16 v[176:183] /*v[432:439]*/, v[72:79] /*v[584:591]*/, v[32:39] /*v[544:551]*/, v[176:183] /*v[432:439]*/
	v_wmma_f32_16x16x32_bf16 v[192:199] /*v[448:455]*/, v[80:87] /*v[592:599]*/, v[32:39] /*v[544:551]*/, v[192:199] /*v[448:455]*/
	v_wmma_f32_16x16x32_bf16 v[248:255] /*v[504:511]*/, v[80:87] /*v[592:599]*/, v[0:7] /*v[512:519]*/, v[248:255] /*v[504:511]*/
	v_wmma_f32_16x16x32_bf16 v[240:247] /*v[496:503]*/, v[72:79] /*v[584:591]*/, v[0:7] /*v[512:519]*/, v[240:247] /*v[496:503]*/
	v_wmma_f32_16x16x32_bf16 v[232:239] /*v[488:495]*/, v[56:63] /*v[568:575]*/, v[0:7] /*v[512:519]*/, v[232:239] /*v[488:495]*/
	v_wmma_f32_16x16x32_bf16 v[224:231] /*v[480:487]*/, v[48:55] /*v[560:567]*/, v[0:7] /*v[512:519]*/, v[224:231] /*v[480:487]*/
	v_wmma_f32_16x16x32_bf16 v[216:223] /*v[472:479]*/, v[40:47] /*v[552:559]*/, v[0:7] /*v[512:519]*/, v[216:223] /*v[472:479]*/
	v_wmma_f32_16x16x32_bf16 v[208:215] /*v[464:471]*/, v[24:31] /*v[536:543]*/, v[0:7] /*v[512:519]*/, v[208:215] /*v[464:471]*/
	v_wmma_f32_16x16x32_bf16 v[200:207] /*v[456:463]*/, v[16:23] /*v[528:535]*/, v[0:7] /*v[512:519]*/, v[200:207] /*v[456:463]*/
	v_wmma_f32_16x16x32_bf16 v[184:191] /*v[440:447]*/, v[8:15] /*v[520:527]*/, v[0:7] /*v[512:519]*/, v[184:191] /*v[440:447]*/
	s_set_vgpr_msb 0x5a83
	ds_load_b128 v[0:3] /*v[512:515]*/, v17 /*v785*/ offset:192
	ds_load_b128 v[4:7] /*v[516:519]*/, v17 /*v785*/ offset:224
	ds_load_b128 v[8:11] /*v[520:523]*/, v17 /*v785*/ offset:4544
	ds_load_b128 v[12:15] /*v[524:527]*/, v17 /*v785*/ offset:4576
	ds_load_b128 v[16:19] /*v[528:531]*/, v17 /*v785*/ offset:8896
	ds_load_b128 v[20:23] /*v[532:535]*/, v17 /*v785*/ offset:8928
	ds_load_b128 v[24:27] /*v[536:539]*/, v17 /*v785*/ offset:13248
	ds_load_b128 v[28:31] /*v[540:543]*/, v17 /*v785*/ offset:13280
	ds_load_b128 v[32:35] /*v[544:547]*/, v17 /*v785*/ offset:17600
	ds_load_b128 v[36:39] /*v[548:551]*/, v17 /*v785*/ offset:17632
	ds_load_b128 v[40:43] /*v[552:555]*/, v17 /*v785*/ offset:21952
	ds_load_b128 v[44:47] /*v[556:559]*/, v17 /*v785*/ offset:21984
	ds_load_b128 v[48:51] /*v[560:563]*/, v17 /*v785*/ offset:26304
	ds_load_b128 v[52:55] /*v[564:567]*/, v17 /*v785*/ offset:26336
	ds_load_b128 v[56:59] /*v[568:571]*/, v18 /*v786*/ offset:192
	ds_load_b128 v[60:63] /*v[572:575]*/, v18 /*v786*/ offset:224
	ds_load_tr16_b128 v[64:67] /*v[576:579]*/, v16 /*v784*/ offset:52224
	ds_load_tr16_b128 v[72:75] /*v[584:587]*/, v16 /*v784*/ offset:52256
	ds_load_tr16_b128 v[68:71] /*v[580:583]*/, v16 /*v784*/ offset:60928
	ds_load_tr16_b128 v[76:79] /*v[588:591]*/, v16 /*v784*/ offset:60960
	ds_load_tr16_b128 v[80:83] /*v[592:595]*/, v16 /*v784*/ offset:52288
	ds_load_tr16_b128 v[88:91] /*v[600:603]*/, v16 /*v784*/ offset:52320
	ds_load_tr16_b128 v[84:87] /*v[596:599]*/, v16 /*v784*/ offset:60992
	ds_load_tr16_b128 v[92:95] /*v[604:607]*/, v16 /*v784*/ offset:61024
	ds_load_tr16_b128 v[96:99] /*v[608:611]*/, v16 /*v784*/ offset:52352
	ds_load_tr16_b128 v[104:107] /*v[616:619]*/, v16 /*v784*/ offset:52384
	ds_load_tr16_b128 v[100:103] /*v[612:615]*/, v16 /*v784*/ offset:61056
	ds_load_tr16_b128 v[108:111] /*v[620:623]*/, v16 /*v784*/ offset:61088
	ds_load_tr16_b128 v[112:115] /*v[624:627]*/, v16 /*v784*/ offset:52416
	ds_load_tr16_b128 v[120:123] /*v[632:635]*/, v16 /*v784*/ offset:52448
	ds_load_tr16_b128 v[116:119] /*v[628:631]*/, v16 /*v784*/ offset:61120
	ds_load_tr16_b128 v[124:127] /*v[636:639]*/, v16 /*v784*/ offset:61152
	s_set_vgpr_msb 0x830a
	s_wait_dscnt 0x2d
	v_wmma_f32_16x16x32_bf16 v[0:7], v[192:199] /*v[704:711]*/, v[128:135] /*v[640:647]*/, v[0:7]
	s_wait_dscnt 0x20
	v_wmma_f32_16x16x32_bf16 v[8:15], v[200:207] /*v[712:719]*/, v[128:135] /*v[640:647]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[208:215] /*v[720:727]*/, v[128:135] /*v[640:647]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[216:223] /*v[728:735]*/, v[128:135] /*v[640:647]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[224:231] /*v[736:743]*/, v[128:135] /*v[640:647]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[232:239] /*v[744:751]*/, v[128:135] /*v[640:647]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[240:247] /*v[752:759]*/, v[128:135] /*v[640:647]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[248:255] /*v[760:767]*/, v[128:135] /*v[640:647]*/, v[56:63]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[248:255] /*v[760:767]*/, v[136:143] /*v[648:655]*/, v[120:127]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[240:247] /*v[752:759]*/, v[136:143] /*v[648:655]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[232:239] /*v[744:751]*/, v[136:143] /*v[648:655]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[224:231] /*v[736:743]*/, v[136:143] /*v[648:655]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[216:223] /*v[728:735]*/, v[136:143] /*v[648:655]*/, v[88:95]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[208:215] /*v[720:727]*/, v[136:143] /*v[648:655]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[200:207] /*v[712:719]*/, v[136:143] /*v[648:655]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[192:199] /*v[704:711]*/, v[136:143] /*v[648:655]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[192:199] /*v[704:711]*/, v[144:151] /*v[656:663]*/, v[128:135]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[200:207] /*v[712:719]*/, v[144:151] /*v[656:663]*/, v[136:143]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[208:215] /*v[720:727]*/, v[144:151] /*v[656:663]*/, v[144:151]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[216:223] /*v[728:735]*/, v[144:151] /*v[656:663]*/, v[152:159]
	v_wmma_f32_16x16x32_bf16 v[160:167], v[224:231] /*v[736:743]*/, v[144:151] /*v[656:663]*/, v[160:167]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[232:239] /*v[744:751]*/, v[144:151] /*v[656:663]*/, v[168:175]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[240:247] /*v[752:759]*/, v[144:151] /*v[656:663]*/, v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[248:255] /*v[760:767]*/, v[144:151] /*v[656:663]*/, v[184:191]
	v_wmma_f32_16x16x32_bf16 v[240:247], v[248:255] /*v[760:767]*/, v[152:159] /*v[664:671]*/, v[240:247]
	v_wmma_f32_16x16x32_bf16 v[248:255], v[240:247] /*v[752:759]*/, v[152:159] /*v[664:671]*/, v[248:255]
	v_wmma_f32_16x16x32_bf16 v[232:239], v[232:239] /*v[744:751]*/, v[152:159] /*v[664:671]*/, v[232:239]
	v_wmma_f32_16x16x32_bf16 v[224:231], v[224:231] /*v[736:743]*/, v[152:159] /*v[664:671]*/, v[224:231]
	v_wmma_f32_16x16x32_bf16 v[216:223], v[216:223] /*v[728:735]*/, v[152:159] /*v[664:671]*/, v[216:223]
	v_wmma_f32_16x16x32_bf16 v[208:215], v[208:215] /*v[720:727]*/, v[152:159] /*v[664:671]*/, v[208:215]
	v_wmma_f32_16x16x32_bf16 v[200:207], v[200:207] /*v[712:719]*/, v[152:159] /*v[664:671]*/, v[200:207]
	v_wmma_f32_16x16x32_bf16 v[192:199], v[192:199] /*v[704:711]*/, v[152:159] /*v[664:671]*/, v[192:199]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[0:7] /*v[256:263]*/, v[192:199] /*v[704:711]*/, v[160:167] /*v[672:679]*/, v[0:7] /*v[256:263]*/
	v_wmma_f32_16x16x32_bf16 v[8:15] /*v[264:271]*/, v[200:207] /*v[712:719]*/, v[160:167] /*v[672:679]*/, v[8:15] /*v[264:271]*/
	v_wmma_f32_16x16x32_bf16 v[16:23] /*v[272:279]*/, v[208:215] /*v[720:727]*/, v[160:167] /*v[672:679]*/, v[16:23] /*v[272:279]*/
	v_wmma_f32_16x16x32_bf16 v[24:31] /*v[280:287]*/, v[216:223] /*v[728:735]*/, v[160:167] /*v[672:679]*/, v[24:31] /*v[280:287]*/
	v_wmma_f32_16x16x32_bf16 v[32:39] /*v[288:295]*/, v[224:231] /*v[736:743]*/, v[160:167] /*v[672:679]*/, v[32:39] /*v[288:295]*/
	v_wmma_f32_16x16x32_bf16 v[40:47] /*v[296:303]*/, v[232:239] /*v[744:751]*/, v[160:167] /*v[672:679]*/, v[40:47] /*v[296:303]*/
	v_wmma_f32_16x16x32_bf16 v[48:55] /*v[304:311]*/, v[240:247] /*v[752:759]*/, v[160:167] /*v[672:679]*/, v[48:55] /*v[304:311]*/
	v_wmma_f32_16x16x32_bf16 v[56:63] /*v[312:319]*/, v[248:255] /*v[760:767]*/, v[160:167] /*v[672:679]*/, v[56:63] /*v[312:319]*/
	v_wmma_f32_16x16x32_bf16 v[120:127] /*v[376:383]*/, v[248:255] /*v[760:767]*/, v[168:175] /*v[680:687]*/, v[120:127] /*v[376:383]*/
	v_wmma_f32_16x16x32_bf16 v[112:119] /*v[368:375]*/, v[240:247] /*v[752:759]*/, v[168:175] /*v[680:687]*/, v[112:119] /*v[368:375]*/
	v_wmma_f32_16x16x32_bf16 v[104:111] /*v[360:367]*/, v[232:239] /*v[744:751]*/, v[168:175] /*v[680:687]*/, v[104:111] /*v[360:367]*/
	v_wmma_f32_16x16x32_bf16 v[96:103] /*v[352:359]*/, v[224:231] /*v[736:743]*/, v[168:175] /*v[680:687]*/, v[96:103] /*v[352:359]*/
	v_wmma_f32_16x16x32_bf16 v[88:95] /*v[344:351]*/, v[216:223] /*v[728:735]*/, v[168:175] /*v[680:687]*/, v[88:95] /*v[344:351]*/
	v_wmma_f32_16x16x32_bf16 v[80:87] /*v[336:343]*/, v[208:215] /*v[720:727]*/, v[168:175] /*v[680:687]*/, v[80:87] /*v[336:343]*/
	v_wmma_f32_16x16x32_bf16 v[72:79] /*v[328:335]*/, v[200:207] /*v[712:719]*/, v[168:175] /*v[680:687]*/, v[72:79] /*v[328:335]*/
	v_wmma_f32_16x16x32_bf16 v[64:71] /*v[320:327]*/, v[192:199] /*v[704:711]*/, v[168:175] /*v[680:687]*/, v[64:71] /*v[320:327]*/
	v_wmma_f32_16x16x32_bf16 v[128:135] /*v[384:391]*/, v[192:199] /*v[704:711]*/, v[176:183] /*v[688:695]*/, v[128:135] /*v[384:391]*/
	v_wmma_f32_16x16x32_bf16 v[136:143] /*v[392:399]*/, v[200:207] /*v[712:719]*/, v[176:183] /*v[688:695]*/, v[136:143] /*v[392:399]*/
	v_wmma_f32_16x16x32_bf16 v[144:151] /*v[400:407]*/, v[208:215] /*v[720:727]*/, v[176:183] /*v[688:695]*/, v[144:151] /*v[400:407]*/
	v_wmma_f32_16x16x32_bf16 v[152:159] /*v[408:415]*/, v[216:223] /*v[728:735]*/, v[176:183] /*v[688:695]*/, v[152:159] /*v[408:415]*/
	v_wmma_f32_16x16x32_bf16 v[160:167] /*v[416:423]*/, v[224:231] /*v[736:743]*/, v[176:183] /*v[688:695]*/, v[160:167] /*v[416:423]*/
	v_wmma_f32_16x16x32_bf16 v[168:175] /*v[424:431]*/, v[232:239] /*v[744:751]*/, v[176:183] /*v[688:695]*/, v[168:175] /*v[424:431]*/
	v_wmma_f32_16x16x32_bf16 v[176:183] /*v[432:439]*/, v[240:247] /*v[752:759]*/, v[176:183] /*v[688:695]*/, v[176:183] /*v[432:439]*/
	v_wmma_f32_16x16x32_bf16 v[192:199] /*v[448:455]*/, v[248:255] /*v[760:767]*/, v[176:183] /*v[688:695]*/, v[192:199] /*v[448:455]*/
	v_wmma_f32_16x16x32_bf16 v[248:255] /*v[504:511]*/, v[248:255] /*v[760:767]*/, v[184:191] /*v[696:703]*/, v[248:255] /*v[504:511]*/
	v_wmma_f32_16x16x32_bf16 v[240:247] /*v[496:503]*/, v[240:247] /*v[752:759]*/, v[184:191] /*v[696:703]*/, v[240:247] /*v[496:503]*/
	v_wmma_f32_16x16x32_bf16 v[232:239] /*v[488:495]*/, v[232:239] /*v[744:751]*/, v[184:191] /*v[696:703]*/, v[232:239] /*v[488:495]*/
	v_wmma_f32_16x16x32_bf16 v[224:231] /*v[480:487]*/, v[224:231] /*v[736:743]*/, v[184:191] /*v[696:703]*/, v[224:231] /*v[480:487]*/
	v_wmma_f32_16x16x32_bf16 v[216:223] /*v[472:479]*/, v[216:223] /*v[728:735]*/, v[184:191] /*v[696:703]*/, v[216:223] /*v[472:479]*/
	v_wmma_f32_16x16x32_bf16 v[208:215] /*v[464:471]*/, v[208:215] /*v[720:727]*/, v[184:191] /*v[696:703]*/, v[208:215] /*v[464:471]*/
	v_wmma_f32_16x16x32_bf16 v[200:207] /*v[456:463]*/, v[200:207] /*v[712:719]*/, v[184:191] /*v[696:703]*/, v[200:207] /*v[456:463]*/
	v_wmma_f32_16x16x32_bf16 v[184:191] /*v[440:447]*/, v[192:199] /*v[704:711]*/, v[184:191] /*v[696:703]*/, v[184:191] /*v[440:447]*/
	s_set_vgpr_msb 0x5a0a
	s_wait_dscnt 0xd
	v_wmma_f32_16x16x32_bf16 v[0:7], v[64:71] /*v[576:583]*/, v[0:7] /*v[512:519]*/, v[0:7]
	s_wait_dscnt 0x0
	v_wmma_f32_16x16x32_bf16 v[8:15], v[72:79] /*v[584:591]*/, v[0:7] /*v[512:519]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[80:87] /*v[592:599]*/, v[0:7] /*v[512:519]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[88:95] /*v[600:607]*/, v[0:7] /*v[512:519]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[96:103] /*v[608:615]*/, v[0:7] /*v[512:519]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[104:111] /*v[616:623]*/, v[0:7] /*v[512:519]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[112:119] /*v[624:631]*/, v[0:7] /*v[512:519]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[120:127] /*v[632:639]*/, v[0:7] /*v[512:519]*/, v[56:63]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[120:127] /*v[632:639]*/, v[8:15] /*v[520:527]*/, v[120:127]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[112:119] /*v[624:631]*/, v[8:15] /*v[520:527]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[104:111] /*v[616:623]*/, v[8:15] /*v[520:527]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[96:103] /*v[608:615]*/, v[8:15] /*v[520:527]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[88:95] /*v[600:607]*/, v[8:15] /*v[520:527]*/, v[88:95]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[80:87] /*v[592:599]*/, v[8:15] /*v[520:527]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[72:79] /*v[584:591]*/, v[8:15] /*v[520:527]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[64:71] /*v[576:583]*/, v[8:15] /*v[520:527]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[64:71] /*v[576:583]*/, v[16:23] /*v[528:535]*/, v[128:135]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[72:79] /*v[584:591]*/, v[16:23] /*v[528:535]*/, v[136:143]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[80:87] /*v[592:599]*/, v[16:23] /*v[528:535]*/, v[144:151]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[88:95] /*v[600:607]*/, v[16:23] /*v[528:535]*/, v[152:159]
	v_wmma_f32_16x16x32_bf16 v[160:167], v[96:103] /*v[608:615]*/, v[16:23] /*v[528:535]*/, v[160:167]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[104:111] /*v[616:623]*/, v[16:23] /*v[528:535]*/, v[168:175]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[112:119] /*v[624:631]*/, v[16:23] /*v[528:535]*/, v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[120:127] /*v[632:639]*/, v[16:23] /*v[528:535]*/, v[184:191]
	v_wmma_f32_16x16x32_bf16 v[240:247], v[120:127] /*v[632:639]*/, v[24:31] /*v[536:543]*/, v[240:247]
	v_wmma_f32_16x16x32_bf16 v[248:255], v[112:119] /*v[624:631]*/, v[24:31] /*v[536:543]*/, v[248:255]
	v_wmma_f32_16x16x32_bf16 v[232:239], v[104:111] /*v[616:623]*/, v[24:31] /*v[536:543]*/, v[232:239]
	v_wmma_f32_16x16x32_bf16 v[224:231], v[96:103] /*v[608:615]*/, v[24:31] /*v[536:543]*/, v[224:231]
	v_wmma_f32_16x16x32_bf16 v[216:223], v[88:95] /*v[600:607]*/, v[24:31] /*v[536:543]*/, v[216:223]
	v_wmma_f32_16x16x32_bf16 v[208:215], v[80:87] /*v[592:599]*/, v[24:31] /*v[536:543]*/, v[208:215]
	v_wmma_f32_16x16x32_bf16 v[200:207], v[72:79] /*v[584:591]*/, v[24:31] /*v[536:543]*/, v[200:207]
	v_wmma_f32_16x16x32_bf16 v[192:199], v[64:71] /*v[576:583]*/, v[24:31] /*v[536:543]*/, v[192:199]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[0:7] /*v[256:263]*/, v[64:71] /*v[576:583]*/, v[32:39] /*v[544:551]*/, v[0:7] /*v[256:263]*/
	v_wmma_f32_16x16x32_bf16 v[8:15] /*v[264:271]*/, v[72:79] /*v[584:591]*/, v[32:39] /*v[544:551]*/, v[8:15] /*v[264:271]*/
	v_wmma_f32_16x16x32_bf16 v[16:23] /*v[272:279]*/, v[80:87] /*v[592:599]*/, v[32:39] /*v[544:551]*/, v[16:23] /*v[272:279]*/
	v_wmma_f32_16x16x32_bf16 v[24:31] /*v[280:287]*/, v[88:95] /*v[600:607]*/, v[32:39] /*v[544:551]*/, v[24:31] /*v[280:287]*/
	v_wmma_f32_16x16x32_bf16 v[32:39] /*v[288:295]*/, v[96:103] /*v[608:615]*/, v[32:39] /*v[544:551]*/, v[32:39] /*v[288:295]*/
	v_wmma_f32_16x16x32_bf16 v[40:47] /*v[296:303]*/, v[104:111] /*v[616:623]*/, v[32:39] /*v[544:551]*/, v[40:47] /*v[296:303]*/
	v_wmma_f32_16x16x32_bf16 v[48:55] /*v[304:311]*/, v[112:119] /*v[624:631]*/, v[32:39] /*v[544:551]*/, v[48:55] /*v[304:311]*/
	v_wmma_f32_16x16x32_bf16 v[56:63] /*v[312:319]*/, v[120:127] /*v[632:639]*/, v[32:39] /*v[544:551]*/, v[56:63] /*v[312:319]*/
	v_wmma_f32_16x16x32_bf16 v[120:127] /*v[376:383]*/, v[120:127] /*v[632:639]*/, v[40:47] /*v[552:559]*/, v[120:127] /*v[376:383]*/
	v_wmma_f32_16x16x32_bf16 v[112:119] /*v[368:375]*/, v[112:119] /*v[624:631]*/, v[40:47] /*v[552:559]*/, v[112:119] /*v[368:375]*/
	v_wmma_f32_16x16x32_bf16 v[104:111] /*v[360:367]*/, v[104:111] /*v[616:623]*/, v[40:47] /*v[552:559]*/, v[104:111] /*v[360:367]*/
	v_wmma_f32_16x16x32_bf16 v[96:103] /*v[352:359]*/, v[96:103] /*v[608:615]*/, v[40:47] /*v[552:559]*/, v[96:103] /*v[352:359]*/
	v_wmma_f32_16x16x32_bf16 v[88:95] /*v[344:351]*/, v[88:95] /*v[600:607]*/, v[40:47] /*v[552:559]*/, v[88:95] /*v[344:351]*/
	v_wmma_f32_16x16x32_bf16 v[80:87] /*v[336:343]*/, v[80:87] /*v[592:599]*/, v[40:47] /*v[552:559]*/, v[80:87] /*v[336:343]*/
	v_wmma_f32_16x16x32_bf16 v[72:79] /*v[328:335]*/, v[72:79] /*v[584:591]*/, v[40:47] /*v[552:559]*/, v[72:79] /*v[328:335]*/
	v_wmma_f32_16x16x32_bf16 v[64:71] /*v[320:327]*/, v[64:71] /*v[576:583]*/, v[40:47] /*v[552:559]*/, v[64:71] /*v[320:327]*/
	v_wmma_f32_16x16x32_bf16 v[128:135] /*v[384:391]*/, v[64:71] /*v[576:583]*/, v[48:55] /*v[560:567]*/, v[128:135] /*v[384:391]*/
	v_wmma_f32_16x16x32_bf16 v[136:143] /*v[392:399]*/, v[72:79] /*v[584:591]*/, v[48:55] /*v[560:567]*/, v[136:143] /*v[392:399]*/
	v_wmma_f32_16x16x32_bf16 v[144:151] /*v[400:407]*/, v[80:87] /*v[592:599]*/, v[48:55] /*v[560:567]*/, v[144:151] /*v[400:407]*/
	v_wmma_f32_16x16x32_bf16 v[152:159] /*v[408:415]*/, v[88:95] /*v[600:607]*/, v[48:55] /*v[560:567]*/, v[152:159] /*v[408:415]*/
	v_wmma_f32_16x16x32_bf16 v[160:167] /*v[416:423]*/, v[96:103] /*v[608:615]*/, v[48:55] /*v[560:567]*/, v[160:167] /*v[416:423]*/
	v_wmma_f32_16x16x32_bf16 v[168:175] /*v[424:431]*/, v[104:111] /*v[616:623]*/, v[48:55] /*v[560:567]*/, v[168:175] /*v[424:431]*/
	v_wmma_f32_16x16x32_bf16 v[176:183] /*v[432:439]*/, v[112:119] /*v[624:631]*/, v[48:55] /*v[560:567]*/, v[176:183] /*v[432:439]*/
	v_wmma_f32_16x16x32_bf16 v[192:199] /*v[448:455]*/, v[120:127] /*v[632:639]*/, v[48:55] /*v[560:567]*/, v[192:199] /*v[448:455]*/
	v_wmma_f32_16x16x32_bf16 v[248:255] /*v[504:511]*/, v[120:127] /*v[632:639]*/, v[56:63] /*v[568:575]*/, v[248:255] /*v[504:511]*/
	v_wmma_f32_16x16x32_bf16 v[240:247] /*v[496:503]*/, v[112:119] /*v[624:631]*/, v[56:63] /*v[568:575]*/, v[240:247] /*v[496:503]*/
	v_wmma_f32_16x16x32_bf16 v[232:239] /*v[488:495]*/, v[104:111] /*v[616:623]*/, v[56:63] /*v[568:575]*/, v[232:239] /*v[488:495]*/
	v_wmma_f32_16x16x32_bf16 v[224:231] /*v[480:487]*/, v[96:103] /*v[608:615]*/, v[56:63] /*v[568:575]*/, v[224:231] /*v[480:487]*/
	v_wmma_f32_16x16x32_bf16 v[216:223] /*v[472:479]*/, v[88:95] /*v[600:607]*/, v[56:63] /*v[568:575]*/, v[216:223] /*v[472:479]*/
	v_wmma_f32_16x16x32_bf16 v[208:215] /*v[464:471]*/, v[80:87] /*v[592:599]*/, v[56:63] /*v[568:575]*/, v[208:215] /*v[464:471]*/
	v_wmma_f32_16x16x32_bf16 v[200:207] /*v[456:463]*/, v[72:79] /*v[584:591]*/, v[56:63] /*v[568:575]*/, v[200:207] /*v[456:463]*/
	v_wmma_f32_16x16x32_bf16 v[184:191] /*v[440:447]*/, v[64:71] /*v[576:583]*/, v[56:63] /*v[568:575]*/, v[184:191] /*v[440:447]*/
	s_add_co_i32 s3, s3, 1
	s_set_vgpr_msb 0x5acc
	v_add_nc_u64_e32 v[2:3] /*v[770:771]*/, s[6:7], v[2:3] /*v[770:771]*/
	v_cmp_ne_u32_e32 vcc_lo, s3, v15 /*v783*/
	s_add_nc_u64 s[26:27], s[26:27], 0x100
	s_set_vgpr_msb 0xcc00
	s_cbranch_vccz .LBB0_13
.LBB0_9:
	s_wait_tensorcnt 0x0
	s_barrier_signal -1
	s_bitcmp1_b32 s3, 0
	s_cselect_b32 s29, 0, 0x22000
	s_cselect_b32 s1, 0x22000, 0
	s_add_co_i32 s29, s29, 0
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xcc
	v_dual_add_nc_u32 v17 /*v785*/, s29, v9 /*v777*/ :: v_dual_add_nc_u32 v16 /*v784*/, s29, v10 /*v778*/
	v_add_nc_u32_e32 v18 /*v786*/, s29, v8 /*v776*/
	s_barrier_wait -1
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0xcc83
	ds_load_b128 v[192:195] /*v[704:707]*/, v17 /*v785*/ offset:21760
	ds_load_b128 v[196:199] /*v[708:711]*/, v17 /*v785*/ offset:21792
	ds_load_b128 v[160:163] /*v[672:675]*/, v17 /*v785*/ offset:26112
	ds_load_b128 v[164:167] /*v[676:679]*/, v17 /*v785*/ offset:26144
	ds_load_b128 v[128:131] /*v[640:643]*/, v18 /*v786*/
	ds_load_b128 v[132:135] /*v[644:647]*/, v18 /*v786*/ offset:32
	ds_load_tr16_b128 v[136:139] /*v[648:651]*/, v16 /*v784*/
	ds_load_tr16_b128 v[144:147] /*v[656:659]*/, v16 /*v784*/ offset:32
	ds_load_tr16_b128 v[140:143] /*v[652:655]*/, v16 /*v784*/ offset:8704
	ds_load_tr16_b128 v[148:151] /*v[660:663]*/, v16 /*v784*/ offset:8736
	ds_load_tr16_b128 v[152:155] /*v[664:667]*/, v16 /*v784*/ offset:64
	ds_load_tr16_b128 v[168:171] /*v[680:683]*/, v16 /*v784*/ offset:96
	ds_load_tr16_b128 v[156:159] /*v[668:671]*/, v16 /*v784*/ offset:8768
	ds_load_tr16_b128 v[172:175] /*v[684:687]*/, v16 /*v784*/ offset:8800
	ds_load_tr16_b128 v[176:179] /*v[688:691]*/, v16 /*v784*/ offset:128
	ds_load_tr16_b128 v[184:187] /*v[696:699]*/, v16 /*v784*/ offset:160
	ds_load_tr16_b128 v[180:183] /*v[692:695]*/, v16 /*v784*/ offset:8832
	ds_load_tr16_b128 v[188:191] /*v[700:703]*/, v16 /*v784*/ offset:8864
	ds_load_tr16_b128 v[200:203] /*v[712:715]*/, v16 /*v784*/ offset:192
	ds_load_tr16_b128 v[208:211] /*v[720:723]*/, v16 /*v784*/ offset:224
	ds_load_tr16_b128 v[204:207] /*v[716:719]*/, v16 /*v784*/ offset:8896
	ds_load_tr16_b128 v[212:215] /*v[724:727]*/, v16 /*v784*/ offset:8928
	ds_load_b128 v[120:123] /*v[632:635]*/, v17 /*v785*/ offset:64
	ds_load_b128 v[124:127] /*v[636:639]*/, v17 /*v785*/ offset:96
	ds_load_b128 v[112:115] /*v[624:627]*/, v17 /*v785*/ offset:4416
	ds_load_b128 v[116:119] /*v[628:631]*/, v17 /*v785*/ offset:4448
	ds_load_b128 v[104:107] /*v[616:619]*/, v17 /*v785*/ offset:8768
	ds_load_b128 v[108:111] /*v[620:623]*/, v17 /*v785*/ offset:8800
	ds_load_b128 v[96:99] /*v[608:611]*/, v17 /*v785*/ offset:13120
	ds_load_b128 v[100:103] /*v[612:615]*/, v17 /*v785*/ offset:13152
	ds_load_b128 v[88:91] /*v[600:603]*/, v17 /*v785*/ offset:17472
	ds_load_b128 v[92:95] /*v[604:607]*/, v17 /*v785*/ offset:17504
	ds_load_b128 v[64:67] /*v[576:579]*/, v17 /*v785*/ offset:21824
	ds_load_b128 v[68:71] /*v[580:583]*/, v17 /*v785*/ offset:21856
	ds_load_b128 v[32:35] /*v[544:547]*/, v17 /*v785*/ offset:26176
	ds_load_b128 v[36:39] /*v[548:551]*/, v17 /*v785*/ offset:26208
	ds_load_b128 v[0:3] /*v[512:515]*/, v18 /*v786*/ offset:64
	ds_load_b128 v[4:7] /*v[516:519]*/, v18 /*v786*/ offset:96
	ds_load_tr16_b128 v[8:11] /*v[520:523]*/, v16 /*v784*/ offset:17408
	ds_load_tr16_b128 v[16:19] /*v[528:531]*/, v16 /*v784*/ offset:17440
	ds_load_tr16_b128 v[12:15] /*v[524:527]*/, v16 /*v784*/ offset:26112
	ds_load_tr16_b128 v[20:23] /*v[532:535]*/, v16 /*v784*/ offset:26144
	ds_load_tr16_b128 v[24:27] /*v[536:539]*/, v16 /*v784*/ offset:17472
	ds_load_tr16_b128 v[40:43] /*v[552:555]*/, v16 /*v784*/ offset:17504
	ds_load_tr16_b128 v[28:31] /*v[540:543]*/, v16 /*v784*/ offset:26176
	ds_load_tr16_b128 v[44:47] /*v[556:559]*/, v16 /*v784*/ offset:26208
	ds_load_tr16_b128 v[48:51] /*v[560:563]*/, v16 /*v784*/ offset:17536
	ds_load_tr16_b128 v[56:59] /*v[568:571]*/, v16 /*v784*/ offset:17568
	ds_load_tr16_b128 v[52:55] /*v[564:567]*/, v16 /*v784*/ offset:26240
	ds_load_tr16_b128 v[60:63] /*v[572:575]*/, v16 /*v784*/ offset:26272
	ds_load_tr16_b128 v[72:75] /*v[584:587]*/, v16 /*v784*/ offset:17600
	ds_load_tr16_b128 v[80:83] /*v[592:595]*/, v16 /*v784*/ offset:17632
	ds_load_tr16_b128 v[76:79] /*v[588:591]*/, v16 /*v784*/ offset:26304
	ds_load_tr16_b128 v[84:87] /*v[596:599]*/, v16 /*v784*/ offset:26336
	ds_load_b128 v[248:251] /*v[760:763]*/, v17 /*v785*/
	ds_load_b128 v[252:255] /*v[764:767]*/, v17 /*v785*/ offset:32
	ds_load_b128 v[240:243] /*v[752:755]*/, v17 /*v785*/ offset:4352
	ds_load_b128 v[244:247] /*v[756:759]*/, v17 /*v785*/ offset:4384
	ds_load_b128 v[232:235] /*v[744:747]*/, v17 /*v785*/ offset:8704
	ds_load_b128 v[236:239] /*v[748:751]*/, v17 /*v785*/ offset:8736
	ds_load_b128 v[224:227] /*v[736:739]*/, v17 /*v785*/ offset:13056
	ds_load_b128 v[228:231] /*v[740:743]*/, v17 /*v785*/ offset:13088
	ds_load_b128 v[216:219] /*v[728:731]*/, v17 /*v785*/ offset:17408
	ds_load_b128 v[220:223] /*v[732:735]*/, v17 /*v785*/ offset:17440
	s_wait_dscnt 0x20
	s_and_b32 vcc_lo, exec_lo, s0
	s_set_vgpr_msb 0x8300
	s_cbranch_vccz .LBB0_11
	s_and_not1_b32 vcc_lo, exec_lo, s38
	s_cbranch_vccnz .LBB0_8
	s_branch .LBB0_12
.LBB0_11:
	s_add_co_i32 s29, s1, 0
	s_or_b32 s31, s27, 0x80000000
	s_mov_b32 s30, s26
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[28:31], s[8:15]
	s_and_not1_b32 vcc_lo, exec_lo, s38
	s_cbranch_vccnz .LBB0_8
.LBB0_12:
	s_add_co_i32 s1, s1, 0
	s_set_vgpr_msb 0xcf
	v_or_b32_e32 v21 /*v789*/, 0x80000000, v3 /*v771*/
	s_add_co_i32 s1, s1, 0x11000
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_dual_mov_b32 v20 /*v788*/, v2 /*v770*/ :: v_dual_mov_b32 v19 /*v787*/, s1
	v_readfirstlane_b32 s40, v0 /*v768*/
	v_readfirstlane_b32 s43, v21 /*v789*/
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_readfirstlane_b32 s42, v20 /*v788*/
	v_readfirstlane_b32 s41, v19 /*v787*/
	s_delay_alu instid0(VALU_DEP_1)
	tensor_load_to_lds s[40:43], s[16:23]
	s_set_vgpr_msb 0xcf00
	s_branch .LBB0_8
.LBB0_13:
	s_set_vgpr_msb 0x83
	v_dual_mov_b32 v0 /*v512*/, v13 /*v781*/ :: v_dual_mov_b32 v3 /*v515*/, v14 /*v782*/
	v_dual_mov_b32 v2 /*v514*/, v12 /*v780*/ :: v_dual_mov_b32 v1 /*v513*/, v11 /*v779*/
	s_set_vgpr_msb 0x8300
.LBB0_14:
	s_lshr_b32 s1, s24, 31
	s_wait_tensorcnt 0x0
	s_barrier_signal -1
	s_add_co_i32 s1, s24, s1
	s_and_b32 s0, s35, 0x80
	s_and_b32 s1, s1, 0x7fffe
	s_ashr_i32 s35, s34, 31
	s_sub_co_i32 s1, s24, s1
	s_mov_b32 s7, 0
	s_mul_i32 s1, s1, 0x22000
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_co_i32 s3, s1, 0
	s_sub_co_i32 s1, s25, s2
	s_set_vgpr_msb 0x8c
	v_dual_add_nc_u32 v252 /*v764*/, s3, v9 /*v777*/ :: v_dual_add_nc_u32 v253 /*v765*/, s3, v10 /*v778*/
	s_set_vgpr_msb 0x8c88
	v_add_nc_u32_e32 v3 /*v515*/, s3, v3 /*v515*/
	s_set_vgpr_msb 0x888e
	v_add_nc_u32_e32 v64 /*v576*/, s3, v8 /*v776*/
	s_barrier_wait -1
	s_wait_alu depctr_va_vdst(0)
	ds_load_tr16_b128 v[116:119] /*v[628:631]*/, v253 /*v765*/ offset:192
	ds_load_tr16_b128 v[124:127] /*v[636:639]*/, v253 /*v765*/ offset:224
	ds_load_tr16_b128 v[120:123] /*v[632:635]*/, v253 /*v765*/ offset:8896
	ds_load_tr16_b128 v[128:131] /*v[640:643]*/, v253 /*v765*/ offset:8928
	ds_load_b128 v[132:135] /*v[644:647]*/, v3 /*v515*/
	ds_load_b128 v[136:139] /*v[648:651]*/, v3 /*v515*/ offset:32
	ds_load_b128 v[140:143] /*v[652:655]*/, v252 /*v764*/ offset:4416
	ds_load_b128 v[144:147] /*v[656:659]*/, v252 /*v764*/ offset:4448
	ds_load_b128 v[148:151] /*v[660:663]*/, v252 /*v764*/ offset:8768
	ds_load_b128 v[152:155] /*v[664:667]*/, v252 /*v764*/ offset:8800
	ds_load_b128 v[156:159] /*v[668:671]*/, v252 /*v764*/ offset:13120
	ds_load_b128 v[160:163] /*v[672:675]*/, v252 /*v764*/ offset:13152
	ds_load_b128 v[164:167] /*v[676:679]*/, v252 /*v764*/ offset:17472
	ds_load_b128 v[168:171] /*v[680:683]*/, v252 /*v764*/ offset:17504
	s_wait_alu depctr_vm_vsrc(6)
	v_add_nc_u32_e32 v3 /*v515*/, s3, v7 /*v775*/
	ds_load_b128 v[172:175] /*v[684:687]*/, v252 /*v764*/ offset:21824
	ds_load_b128 v[176:179] /*v[688:691]*/, v252 /*v764*/ offset:21856
	ds_load_b128 v[180:183] /*v[692:695]*/, v252 /*v764*/ offset:26176
	ds_load_b128 v[184:187] /*v[696:699]*/, v252 /*v764*/ offset:26208
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[188:191] /*v[700:703]*/, v3 /*v515*/
	ds_load_b128 v[192:195] /*v[704:707]*/, v3 /*v515*/ offset:32
	ds_load_tr16_b128 v[196:199] /*v[708:711]*/, v253 /*v765*/ offset:17408
	ds_load_tr16_b128 v[204:207] /*v[716:719]*/, v253 /*v765*/ offset:17440
	ds_load_tr16_b128 v[200:203] /*v[712:715]*/, v253 /*v765*/ offset:26112
	ds_load_tr16_b128 v[208:211] /*v[720:723]*/, v253 /*v765*/ offset:26144
	ds_load_tr16_b128 v[212:215] /*v[724:727]*/, v253 /*v765*/ offset:17472
	ds_load_tr16_b128 v[220:223] /*v[732:735]*/, v253 /*v765*/ offset:17504
	ds_load_tr16_b128 v[216:219] /*v[728:731]*/, v253 /*v765*/ offset:26176
	ds_load_tr16_b128 v[224:227] /*v[736:739]*/, v253 /*v765*/ offset:26208
	ds_load_tr16_b128 v[228:231] /*v[740:743]*/, v253 /*v765*/ offset:17536
	ds_load_tr16_b128 v[236:239] /*v[748:751]*/, v253 /*v765*/ offset:17568
	ds_load_tr16_b128 v[232:235] /*v[744:747]*/, v253 /*v765*/ offset:26240
	ds_load_tr16_b128 v[240:243] /*v[752:755]*/, v253 /*v765*/ offset:26272
	ds_load_tr16_b128 v[244:247] /*v[756:759]*/, v253 /*v765*/ offset:17600
	s_set_vgpr_msb 0x8ec2
	ds_load_tr16_b128 v[8:11] /*v[776:779]*/, v253 /*v765*/ offset:17632
	s_set_vgpr_msb 0xc282
	ds_load_tr16_b128 v[248:251] /*v[760:763]*/, v253 /*v765*/ offset:26304
	s_set_vgpr_msb 0x82c2
	ds_load_tr16_b128 v[12:15] /*v[780:783]*/, v253 /*v765*/ offset:26336
	s_set_vgpr_msb 0xc282
	ds_load_b128 v[44:47] /*v[556:559]*/, v252 /*v764*/ offset:21760
	ds_load_b128 v[48:51] /*v[560:563]*/, v252 /*v764*/ offset:21792
	ds_load_b128 v[52:55] /*v[564:567]*/, v252 /*v764*/ offset:26112
	ds_load_b128 v[56:59] /*v[568:571]*/, v252 /*v764*/ offset:26144
	ds_load_b128 v[60:63] /*v[572:575]*/, v64 /*v576*/
	s_wait_alu depctr_vm_vsrc(0)
	ds_load_b128 v[64:67] /*v[576:579]*/, v64 /*v576*/ offset:32
	ds_load_tr16_b128 v[68:71] /*v[580:583]*/, v253 /*v765*/
	ds_load_tr16_b128 v[76:79] /*v[588:591]*/, v253 /*v765*/ offset:32
	ds_load_tr16_b128 v[72:75] /*v[584:587]*/, v253 /*v765*/ offset:8704
	ds_load_tr16_b128 v[80:83] /*v[592:595]*/, v253 /*v765*/ offset:8736
	ds_load_tr16_b128 v[84:87] /*v[596:599]*/, v253 /*v765*/ offset:64
	ds_load_tr16_b128 v[92:95] /*v[604:607]*/, v253 /*v765*/ offset:96
	ds_load_tr16_b128 v[88:91] /*v[600:603]*/, v253 /*v765*/ offset:8768
	ds_load_tr16_b128 v[96:99] /*v[608:611]*/, v253 /*v765*/ offset:8800
	ds_load_tr16_b128 v[100:103] /*v[612:615]*/, v253 /*v765*/ offset:128
	ds_load_tr16_b128 v[108:111] /*v[620:623]*/, v253 /*v765*/ offset:160
	ds_load_tr16_b128 v[104:107] /*v[616:619]*/, v253 /*v765*/ offset:8832
	ds_load_tr16_b128 v[112:115] /*v[624:627]*/, v253 /*v765*/ offset:8864
	ds_load_b128 v[4:7] /*v[516:519]*/, v252 /*v764*/
	ds_load_b128 v[8:11] /*v[520:523]*/, v252 /*v764*/ offset:32
	ds_load_b128 v[12:15] /*v[524:527]*/, v252 /*v764*/ offset:4352
	ds_load_b128 v[16:19] /*v[528:531]*/, v252 /*v764*/ offset:4384
	ds_load_b128 v[20:23] /*v[532:535]*/, v252 /*v764*/ offset:8704
	ds_load_b128 v[24:27] /*v[536:539]*/, v252 /*v764*/ offset:8736
	ds_load_b128 v[28:31] /*v[540:543]*/, v252 /*v764*/ offset:13056
	ds_load_b128 v[32:35] /*v[544:547]*/, v252 /*v764*/ offset:13088
	ds_load_b128 v[36:39] /*v[548:551]*/, v252 /*v764*/ offset:17408
	ds_load_b128 v[40:43] /*v[552:555]*/, v252 /*v764*/ offset:17440
	s_set_vgpr_msb 0x820a
	s_wait_dscnt 0x8
	v_wmma_f32_16x16x32_bf16 v[0:7], v[68:75] /*v[580:587]*/, v[4:11] /*v[516:523]*/, v[0:7]
	s_wait_dscnt 0x20
	v_wmma_f32_16x16x32_bf16 v[8:15], v[76:83] /*v[588:595]*/, v[4:11] /*v[516:523]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[84:91] /*v[596:603]*/, v[4:11] /*v[516:523]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[92:99] /*v[604:611]*/, v[4:11] /*v[516:523]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[100:107] /*v[612:619]*/, v[4:11] /*v[516:523]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[108:115] /*v[620:627]*/, v[4:11] /*v[516:523]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[116:123] /*v[628:635]*/, v[4:11] /*v[516:523]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[124:131] /*v[636:643]*/, v[4:11] /*v[516:523]*/, v[56:63]
	s_wait_dscnt 0x6
	v_wmma_f32_16x16x32_bf16 v[120:127], v[124:131] /*v[636:643]*/, v[12:19] /*v[524:531]*/, v[120:127]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[116:123] /*v[628:635]*/, v[12:19] /*v[524:531]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[108:115] /*v[620:627]*/, v[12:19] /*v[524:531]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[100:107] /*v[612:619]*/, v[12:19] /*v[524:531]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[92:99] /*v[604:611]*/, v[12:19] /*v[524:531]*/, v[88:95]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[84:91] /*v[596:603]*/, v[12:19] /*v[524:531]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[76:83] /*v[588:595]*/, v[12:19] /*v[524:531]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[68:75] /*v[580:587]*/, v[12:19] /*v[524:531]*/, v[64:71]
	s_wait_dscnt 0x4
	v_wmma_f32_16x16x32_bf16 v[128:135], v[68:75] /*v[580:587]*/, v[20:27] /*v[532:539]*/, v[128:135]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[76:83] /*v[588:595]*/, v[20:27] /*v[532:539]*/, v[136:143]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[84:91] /*v[596:603]*/, v[20:27] /*v[532:539]*/, v[144:151]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[92:99] /*v[604:611]*/, v[20:27] /*v[532:539]*/, v[152:159]
	v_wmma_f32_16x16x32_bf16 v[160:167], v[100:107] /*v[612:619]*/, v[20:27] /*v[532:539]*/, v[160:167]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[108:115] /*v[620:627]*/, v[20:27] /*v[532:539]*/, v[168:175]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[116:123] /*v[628:635]*/, v[20:27] /*v[532:539]*/, v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[124:131] /*v[636:643]*/, v[20:27] /*v[532:539]*/, v[184:191]
	s_wait_dscnt 0x2
	v_wmma_f32_16x16x32_bf16 v[240:247], v[124:131] /*v[636:643]*/, v[28:35] /*v[540:547]*/, v[240:247]
	v_wmma_f32_16x16x32_bf16 v[248:255], v[116:123] /*v[628:635]*/, v[28:35] /*v[540:547]*/, v[248:255]
	v_wmma_f32_16x16x32_bf16 v[232:239], v[108:115] /*v[620:627]*/, v[28:35] /*v[540:547]*/, v[232:239]
	v_wmma_f32_16x16x32_bf16 v[224:231], v[100:107] /*v[612:619]*/, v[28:35] /*v[540:547]*/, v[224:231]
	v_wmma_f32_16x16x32_bf16 v[216:223], v[92:99] /*v[604:611]*/, v[28:35] /*v[540:547]*/, v[216:223]
	v_wmma_f32_16x16x32_bf16 v[208:215], v[84:91] /*v[596:603]*/, v[28:35] /*v[540:547]*/, v[208:215]
	v_wmma_f32_16x16x32_bf16 v[200:207], v[76:83] /*v[588:595]*/, v[28:35] /*v[540:547]*/, v[200:207]
	v_wmma_f32_16x16x32_bf16 v[192:199], v[68:75] /*v[580:587]*/, v[28:35] /*v[540:547]*/, v[192:199]
	s_set_vgpr_msb 0xa5a
	s_wait_dscnt 0x0
	v_wmma_f32_16x16x32_bf16 v[0:7] /*v[256:263]*/, v[68:75] /*v[580:587]*/, v[36:43] /*v[548:555]*/, v[0:7] /*v[256:263]*/
	v_wmma_f32_16x16x32_bf16 v[8:15] /*v[264:271]*/, v[76:83] /*v[588:595]*/, v[36:43] /*v[548:555]*/, v[8:15] /*v[264:271]*/
	v_wmma_f32_16x16x32_bf16 v[16:23] /*v[272:279]*/, v[84:91] /*v[596:603]*/, v[36:43] /*v[548:555]*/, v[16:23] /*v[272:279]*/
	v_wmma_f32_16x16x32_bf16 v[24:31] /*v[280:287]*/, v[92:99] /*v[604:611]*/, v[36:43] /*v[548:555]*/, v[24:31] /*v[280:287]*/
	v_wmma_f32_16x16x32_bf16 v[32:39] /*v[288:295]*/, v[100:107] /*v[612:619]*/, v[36:43] /*v[548:555]*/, v[32:39] /*v[288:295]*/
	v_wmma_f32_16x16x32_bf16 v[40:47] /*v[296:303]*/, v[108:115] /*v[620:627]*/, v[36:43] /*v[548:555]*/, v[40:47] /*v[296:303]*/
	v_wmma_f32_16x16x32_bf16 v[48:55] /*v[304:311]*/, v[116:123] /*v[628:635]*/, v[36:43] /*v[548:555]*/, v[48:55] /*v[304:311]*/
	v_wmma_f32_16x16x32_bf16 v[56:63] /*v[312:319]*/, v[124:131] /*v[636:643]*/, v[36:43] /*v[548:555]*/, v[56:63] /*v[312:319]*/
	v_wmma_f32_16x16x32_bf16 v[120:127] /*v[376:383]*/, v[124:131] /*v[636:643]*/, v[44:51] /*v[556:563]*/, v[120:127] /*v[376:383]*/
	v_wmma_f32_16x16x32_bf16 v[112:119] /*v[368:375]*/, v[116:123] /*v[628:635]*/, v[44:51] /*v[556:563]*/, v[112:119] /*v[368:375]*/
	v_wmma_f32_16x16x32_bf16 v[104:111] /*v[360:367]*/, v[108:115] /*v[620:627]*/, v[44:51] /*v[556:563]*/, v[104:111] /*v[360:367]*/
	v_wmma_f32_16x16x32_bf16 v[96:103] /*v[352:359]*/, v[100:107] /*v[612:619]*/, v[44:51] /*v[556:563]*/, v[96:103] /*v[352:359]*/
	v_wmma_f32_16x16x32_bf16 v[88:95] /*v[344:351]*/, v[92:99] /*v[604:611]*/, v[44:51] /*v[556:563]*/, v[88:95] /*v[344:351]*/
	v_wmma_f32_16x16x32_bf16 v[80:87] /*v[336:343]*/, v[84:91] /*v[596:603]*/, v[44:51] /*v[556:563]*/, v[80:87] /*v[336:343]*/
	v_wmma_f32_16x16x32_bf16 v[72:79] /*v[328:335]*/, v[76:83] /*v[588:595]*/, v[44:51] /*v[556:563]*/, v[72:79] /*v[328:335]*/
	v_wmma_f32_16x16x32_bf16 v[64:71] /*v[320:327]*/, v[68:75] /*v[580:587]*/, v[44:51] /*v[556:563]*/, v[64:71] /*v[320:327]*/
	v_wmma_f32_16x16x32_bf16 v[128:135] /*v[384:391]*/, v[68:75] /*v[580:587]*/, v[52:59] /*v[564:571]*/, v[128:135] /*v[384:391]*/
	v_wmma_f32_16x16x32_bf16 v[136:143] /*v[392:399]*/, v[76:83] /*v[588:595]*/, v[52:59] /*v[564:571]*/, v[136:143] /*v[392:399]*/
	v_wmma_f32_16x16x32_bf16 v[144:151] /*v[400:407]*/, v[84:91] /*v[596:603]*/, v[52:59] /*v[564:571]*/, v[144:151] /*v[400:407]*/
	v_wmma_f32_16x16x32_bf16 v[152:159] /*v[408:415]*/, v[92:99] /*v[604:611]*/, v[52:59] /*v[564:571]*/, v[152:159] /*v[408:415]*/
	v_wmma_f32_16x16x32_bf16 v[160:167] /*v[416:423]*/, v[100:107] /*v[612:619]*/, v[52:59] /*v[564:571]*/, v[160:167] /*v[416:423]*/
	v_wmma_f32_16x16x32_bf16 v[168:175] /*v[424:431]*/, v[108:115] /*v[620:627]*/, v[52:59] /*v[564:571]*/, v[168:175] /*v[424:431]*/
	v_wmma_f32_16x16x32_bf16 v[176:183] /*v[432:439]*/, v[116:123] /*v[628:635]*/, v[52:59] /*v[564:571]*/, v[176:183] /*v[432:439]*/
	v_wmma_f32_16x16x32_bf16 v[192:199] /*v[448:455]*/, v[124:131] /*v[636:643]*/, v[52:59] /*v[564:571]*/, v[192:199] /*v[448:455]*/
	v_wmma_f32_16x16x32_bf16 v[248:255] /*v[504:511]*/, v[124:131] /*v[636:643]*/, v[60:67] /*v[572:579]*/, v[248:255] /*v[504:511]*/
	v_wmma_f32_16x16x32_bf16 v[240:247] /*v[496:503]*/, v[116:123] /*v[628:635]*/, v[60:67] /*v[572:579]*/, v[240:247] /*v[496:503]*/
	v_wmma_f32_16x16x32_bf16 v[232:239] /*v[488:495]*/, v[108:115] /*v[620:627]*/, v[60:67] /*v[572:579]*/, v[232:239] /*v[488:495]*/
	v_wmma_f32_16x16x32_bf16 v[224:231] /*v[480:487]*/, v[100:107] /*v[612:619]*/, v[60:67] /*v[572:579]*/, v[224:231] /*v[480:487]*/
	v_wmma_f32_16x16x32_bf16 v[216:223] /*v[472:479]*/, v[92:99] /*v[604:611]*/, v[60:67] /*v[572:579]*/, v[216:223] /*v[472:479]*/
	v_wmma_f32_16x16x32_bf16 v[208:215] /*v[464:471]*/, v[84:91] /*v[596:603]*/, v[60:67] /*v[572:579]*/, v[208:215] /*v[464:471]*/
	v_wmma_f32_16x16x32_bf16 v[200:207] /*v[456:463]*/, v[76:83] /*v[588:595]*/, v[60:67] /*v[572:579]*/, v[200:207] /*v[456:463]*/
	v_wmma_f32_16x16x32_bf16 v[184:191] /*v[440:447]*/, v[68:75] /*v[580:587]*/, v[60:67] /*v[572:579]*/, v[184:191] /*v[440:447]*/
	v_nop
	v_nop
	v_nop
	v_nop
	s_set_vgpr_msb 0x5a8e
	v_add_nc_u32_e32 v62 /*v574*/, s3, v6 /*v774*/
	ds_load_b128 v[42:45] /*v[554:557]*/, v252 /*v764*/ offset:21888
	ds_load_b128 v[46:49] /*v[558:561]*/, v252 /*v764*/ offset:21920
	ds_load_b128 v[50:53] /*v[562:565]*/, v252 /*v764*/ offset:26240
	ds_load_b128 v[54:57] /*v[566:569]*/, v252 /*v764*/ offset:26272
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[58:61] /*v[570:573]*/, v62 /*v574*/
	s_wait_alu depctr_vm_vsrc(0)
	ds_load_b128 v[62:65] /*v[574:577]*/, v62 /*v574*/ offset:32
	ds_load_tr16_b128 v[66:69] /*v[578:581]*/, v253 /*v765*/ offset:34816
	ds_load_tr16_b128 v[74:77] /*v[586:589]*/, v253 /*v765*/ offset:34848
	ds_load_tr16_b128 v[70:73] /*v[582:585]*/, v253 /*v765*/ offset:43520
	ds_load_tr16_b128 v[78:81] /*v[590:593]*/, v253 /*v765*/ offset:43552
	ds_load_tr16_b128 v[82:85] /*v[594:597]*/, v253 /*v765*/ offset:34880
	ds_load_tr16_b128 v[90:93] /*v[602:605]*/, v253 /*v765*/ offset:34912
	ds_load_tr16_b128 v[86:89] /*v[598:601]*/, v253 /*v765*/ offset:43584
	ds_load_tr16_b128 v[94:97] /*v[606:609]*/, v253 /*v765*/ offset:43616
	ds_load_tr16_b128 v[98:101] /*v[610:613]*/, v253 /*v765*/ offset:34944
	ds_load_tr16_b128 v[106:109] /*v[618:621]*/, v253 /*v765*/ offset:34976
	ds_load_tr16_b128 v[102:105] /*v[614:617]*/, v253 /*v765*/ offset:43648
	ds_load_tr16_b128 v[110:113] /*v[622:625]*/, v253 /*v765*/ offset:43680
	ds_load_tr16_b128 v[114:117] /*v[626:629]*/, v253 /*v765*/ offset:35008
	ds_load_tr16_b128 v[122:125] /*v[634:637]*/, v253 /*v765*/ offset:35040
	ds_load_tr16_b128 v[118:121] /*v[630:633]*/, v253 /*v765*/ offset:43712
	ds_load_tr16_b128 v[126:129] /*v[638:641]*/, v253 /*v765*/ offset:43744
	s_set_vgpr_msb 0x8e8a
	v_add_nc_u32_e32 v14 /*v526*/, s3, v2 /*v514*/
	ds_load_b128 v[2:5] /*v[514:517]*/, v252 /*v764*/ offset:4480
	ds_load_b128 v[6:9] /*v[518:521]*/, v252 /*v764*/ offset:4512
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[10:13] /*v[522:525]*/, v14 /*v526*/
	s_wait_alu depctr_vm_vsrc(0)
	ds_load_b128 v[14:17] /*v[526:529]*/, v14 /*v526*/ offset:32
	ds_load_b128 v[18:21] /*v[530:533]*/, v252 /*v764*/ offset:8832
	ds_load_b128 v[22:25] /*v[534:537]*/, v252 /*v764*/ offset:8864
	ds_load_b128 v[26:29] /*v[538:541]*/, v252 /*v764*/ offset:13184
	ds_load_b128 v[30:33] /*v[542:545]*/, v252 /*v764*/ offset:13216
	ds_load_b128 v[34:37] /*v[546:549]*/, v252 /*v764*/ offset:17536
	ds_load_b128 v[38:41] /*v[550:553]*/, v252 /*v764*/ offset:17568
	s_set_vgpr_msb 0x8a0a
	v_wmma_f32_16x16x32_bf16 v[0:7], v[196:203] /*v[708:715]*/, v[132:139] /*v[644:651]*/, v[0:7]
	s_wait_dscnt 0x20
	v_wmma_f32_16x16x32_bf16 v[8:15], v[204:211] /*v[716:723]*/, v[132:139] /*v[644:651]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[212:219] /*v[724:731]*/, v[132:139] /*v[644:651]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[220:227] /*v[732:739]*/, v[132:139] /*v[644:651]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[228:235] /*v[740:747]*/, v[132:139] /*v[644:651]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[236:243] /*v[748:755]*/, v[132:139] /*v[644:651]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[244:251] /*v[756:763]*/, v[132:139] /*v[644:651]*/, v[48:55]
	s_set_vgpr_msb 0xa0b
	v_wmma_f32_16x16x32_bf16 v[56:63], v[8:15] /*v[776:783]*/, v[132:139] /*v[644:651]*/, v[56:63]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[8:15] /*v[776:783]*/, v[140:147] /*v[652:659]*/, v[120:127]
	s_set_vgpr_msb 0xb0a
	v_wmma_f32_16x16x32_bf16 v[112:119], v[244:251] /*v[756:763]*/, v[140:147] /*v[652:659]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[236:243] /*v[748:755]*/, v[140:147] /*v[652:659]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[228:235] /*v[740:747]*/, v[140:147] /*v[652:659]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[220:227] /*v[732:739]*/, v[140:147] /*v[652:659]*/, v[88:95]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[212:219] /*v[724:731]*/, v[140:147] /*v[652:659]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[204:211] /*v[716:723]*/, v[140:147] /*v[652:659]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[196:203] /*v[708:715]*/, v[140:147] /*v[652:659]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[196:203] /*v[708:715]*/, v[148:155] /*v[660:667]*/, v[128:135]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[204:211] /*v[716:723]*/, v[148:155] /*v[660:667]*/, v[136:143]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[212:219] /*v[724:731]*/, v[148:155] /*v[660:667]*/, v[144:151]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[220:227] /*v[732:739]*/, v[148:155] /*v[660:667]*/, v[152:159]
	v_wmma_f32_16x16x32_bf16 v[160:167], v[228:235] /*v[740:747]*/, v[148:155] /*v[660:667]*/, v[160:167]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[236:243] /*v[748:755]*/, v[148:155] /*v[660:667]*/, v[168:175]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[244:251] /*v[756:763]*/, v[148:155] /*v[660:667]*/, v[176:183]
	s_set_vgpr_msb 0xa0b
	v_wmma_f32_16x16x32_bf16 v[184:191], v[8:15] /*v[776:783]*/, v[148:155] /*v[660:667]*/, v[184:191]
	v_wmma_f32_16x16x32_bf16 v[240:247], v[8:15] /*v[776:783]*/, v[156:163] /*v[668:675]*/, v[240:247]
	s_set_vgpr_msb 0xb0a
	v_wmma_f32_16x16x32_bf16 v[248:255], v[244:251] /*v[756:763]*/, v[156:163] /*v[668:675]*/, v[248:255]
	v_wmma_f32_16x16x32_bf16 v[232:239], v[236:243] /*v[748:755]*/, v[156:163] /*v[668:675]*/, v[232:239]
	v_wmma_f32_16x16x32_bf16 v[224:231], v[228:235] /*v[740:747]*/, v[156:163] /*v[668:675]*/, v[224:231]
	v_wmma_f32_16x16x32_bf16 v[216:223], v[220:227] /*v[732:739]*/, v[156:163] /*v[668:675]*/, v[216:223]
	v_wmma_f32_16x16x32_bf16 v[208:215], v[212:219] /*v[724:731]*/, v[156:163] /*v[668:675]*/, v[208:215]
	v_wmma_f32_16x16x32_bf16 v[200:207], v[204:211] /*v[716:723]*/, v[156:163] /*v[668:675]*/, v[200:207]
	v_wmma_f32_16x16x32_bf16 v[192:199], v[196:203] /*v[708:715]*/, v[156:163] /*v[668:675]*/, v[192:199]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[0:7] /*v[256:263]*/, v[196:203] /*v[708:715]*/, v[164:171] /*v[676:683]*/, v[0:7] /*v[256:263]*/
	v_wmma_f32_16x16x32_bf16 v[8:15] /*v[264:271]*/, v[204:211] /*v[716:723]*/, v[164:171] /*v[676:683]*/, v[8:15] /*v[264:271]*/
	v_wmma_f32_16x16x32_bf16 v[16:23] /*v[272:279]*/, v[212:219] /*v[724:731]*/, v[164:171] /*v[676:683]*/, v[16:23] /*v[272:279]*/
	v_wmma_f32_16x16x32_bf16 v[24:31] /*v[280:287]*/, v[220:227] /*v[732:739]*/, v[164:171] /*v[676:683]*/, v[24:31] /*v[280:287]*/
	v_wmma_f32_16x16x32_bf16 v[32:39] /*v[288:295]*/, v[228:235] /*v[740:747]*/, v[164:171] /*v[676:683]*/, v[32:39] /*v[288:295]*/
	v_wmma_f32_16x16x32_bf16 v[40:47] /*v[296:303]*/, v[236:243] /*v[748:755]*/, v[164:171] /*v[676:683]*/, v[40:47] /*v[296:303]*/
	v_wmma_f32_16x16x32_bf16 v[48:55] /*v[304:311]*/, v[244:251] /*v[756:763]*/, v[164:171] /*v[676:683]*/, v[48:55] /*v[304:311]*/
	s_set_vgpr_msb 0x5a5b
	v_wmma_f32_16x16x32_bf16 v[56:63] /*v[312:319]*/, v[8:15] /*v[776:783]*/, v[164:171] /*v[676:683]*/, v[56:63] /*v[312:319]*/
	v_wmma_f32_16x16x32_bf16 v[120:127] /*v[376:383]*/, v[8:15] /*v[776:783]*/, v[172:179] /*v[684:691]*/, v[120:127] /*v[376:383]*/
	s_set_vgpr_msb 0x5b5a
	v_wmma_f32_16x16x32_bf16 v[112:119] /*v[368:375]*/, v[244:251] /*v[756:763]*/, v[172:179] /*v[684:691]*/, v[112:119] /*v[368:375]*/
	v_wmma_f32_16x16x32_bf16 v[104:111] /*v[360:367]*/, v[236:243] /*v[748:755]*/, v[172:179] /*v[684:691]*/, v[104:111] /*v[360:367]*/
	v_wmma_f32_16x16x32_bf16 v[96:103] /*v[352:359]*/, v[228:235] /*v[740:747]*/, v[172:179] /*v[684:691]*/, v[96:103] /*v[352:359]*/
	v_wmma_f32_16x16x32_bf16 v[88:95] /*v[344:351]*/, v[220:227] /*v[732:739]*/, v[172:179] /*v[684:691]*/, v[88:95] /*v[344:351]*/
	v_wmma_f32_16x16x32_bf16 v[80:87] /*v[336:343]*/, v[212:219] /*v[724:731]*/, v[172:179] /*v[684:691]*/, v[80:87] /*v[336:343]*/
	v_wmma_f32_16x16x32_bf16 v[72:79] /*v[328:335]*/, v[204:211] /*v[716:723]*/, v[172:179] /*v[684:691]*/, v[72:79] /*v[328:335]*/
	v_wmma_f32_16x16x32_bf16 v[64:71] /*v[320:327]*/, v[196:203] /*v[708:715]*/, v[172:179] /*v[684:691]*/, v[64:71] /*v[320:327]*/
	v_wmma_f32_16x16x32_bf16 v[128:135] /*v[384:391]*/, v[196:203] /*v[708:715]*/, v[180:187] /*v[692:699]*/, v[128:135] /*v[384:391]*/
	v_wmma_f32_16x16x32_bf16 v[136:143] /*v[392:399]*/, v[204:211] /*v[716:723]*/, v[180:187] /*v[692:699]*/, v[136:143] /*v[392:399]*/
	v_wmma_f32_16x16x32_bf16 v[144:151] /*v[400:407]*/, v[212:219] /*v[724:731]*/, v[180:187] /*v[692:699]*/, v[144:151] /*v[400:407]*/
	v_wmma_f32_16x16x32_bf16 v[152:159] /*v[408:415]*/, v[220:227] /*v[732:739]*/, v[180:187] /*v[692:699]*/, v[152:159] /*v[408:415]*/
	v_wmma_f32_16x16x32_bf16 v[160:167] /*v[416:423]*/, v[228:235] /*v[740:747]*/, v[180:187] /*v[692:699]*/, v[160:167] /*v[416:423]*/
	v_wmma_f32_16x16x32_bf16 v[168:175] /*v[424:431]*/, v[236:243] /*v[748:755]*/, v[180:187] /*v[692:699]*/, v[168:175] /*v[424:431]*/
	v_wmma_f32_16x16x32_bf16 v[176:183] /*v[432:439]*/, v[244:251] /*v[756:763]*/, v[180:187] /*v[692:699]*/, v[176:183] /*v[432:439]*/
	s_set_vgpr_msb 0x5a5b
	v_wmma_f32_16x16x32_bf16 v[192:199] /*v[448:455]*/, v[8:15] /*v[776:783]*/, v[180:187] /*v[692:699]*/, v[192:199] /*v[448:455]*/
	v_wmma_f32_16x16x32_bf16 v[248:255] /*v[504:511]*/, v[8:15] /*v[776:783]*/, v[188:195] /*v[700:707]*/, v[248:255] /*v[504:511]*/
	s_set_vgpr_msb 0x5b5a
	v_wmma_f32_16x16x32_bf16 v[240:247] /*v[496:503]*/, v[244:251] /*v[756:763]*/, v[188:195] /*v[700:707]*/, v[240:247] /*v[496:503]*/
	v_wmma_f32_16x16x32_bf16 v[232:239] /*v[488:495]*/, v[236:243] /*v[748:755]*/, v[188:195] /*v[700:707]*/, v[232:239] /*v[488:495]*/
	v_wmma_f32_16x16x32_bf16 v[224:231] /*v[480:487]*/, v[228:235] /*v[740:747]*/, v[188:195] /*v[700:707]*/, v[224:231] /*v[480:487]*/
	v_wmma_f32_16x16x32_bf16 v[216:223] /*v[472:479]*/, v[220:227] /*v[732:739]*/, v[188:195] /*v[700:707]*/, v[216:223] /*v[472:479]*/
	v_wmma_f32_16x16x32_bf16 v[208:215] /*v[464:471]*/, v[212:219] /*v[724:731]*/, v[188:195] /*v[700:707]*/, v[208:215] /*v[464:471]*/
	v_wmma_f32_16x16x32_bf16 v[200:207] /*v[456:463]*/, v[204:211] /*v[716:723]*/, v[188:195] /*v[700:707]*/, v[200:207] /*v[456:463]*/
	v_wmma_f32_16x16x32_bf16 v[184:191] /*v[440:447]*/, v[196:203] /*v[708:715]*/, v[188:195] /*v[700:707]*/, v[184:191] /*v[440:447]*/
	s_set_vgpr_msb 0x5a8a
	v_add_nc_u32_e32 v1 /*v513*/, s3, v1 /*v513*/
	ds_load_b128 v[130:133] /*v[642:645]*/, v252 /*v764*/ offset:4544
	ds_load_b128 v[134:137] /*v[646:649]*/, v252 /*v764*/ offset:4576
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[138:141] /*v[650:653]*/, v1 /*v513*/
	ds_load_b128 v[142:145] /*v[654:657]*/, v1 /*v513*/ offset:32
	ds_load_b128 v[146:149] /*v[658:661]*/, v252 /*v764*/ offset:8896
	ds_load_b128 v[150:153] /*v[662:665]*/, v252 /*v764*/ offset:8928
	ds_load_b128 v[154:157] /*v[666:669]*/, v252 /*v764*/ offset:13248
	ds_load_b128 v[158:161] /*v[670:673]*/, v252 /*v764*/ offset:13280
	ds_load_b128 v[162:165] /*v[674:677]*/, v252 /*v764*/ offset:17600
	ds_load_b128 v[166:169] /*v[678:681]*/, v252 /*v764*/ offset:17632
	s_wait_alu depctr_vm_vsrc(6)
	s_set_vgpr_msb 0x8a8e
	v_add_nc_u32_e32 v1 /*v513*/, s3, v5 /*v773*/
	ds_load_b128 v[170:173] /*v[682:685]*/, v252 /*v764*/ offset:21952
	ds_load_b128 v[174:177] /*v[686:689]*/, v252 /*v764*/ offset:21984
	ds_load_b128 v[178:181] /*v[690:693]*/, v252 /*v764*/ offset:26304
	ds_load_b128 v[182:185] /*v[694:697]*/, v252 /*v764*/ offset:26336
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[186:189] /*v[698:701]*/, v1 /*v513*/
	ds_load_b128 v[190:193] /*v[702:705]*/, v1 /*v513*/ offset:32
	ds_load_tr16_b128 v[194:197] /*v[706:709]*/, v253 /*v765*/ offset:52224
	ds_load_tr16_b128 v[202:205] /*v[714:717]*/, v253 /*v765*/ offset:52256
	ds_load_tr16_b128 v[198:201] /*v[710:713]*/, v253 /*v765*/ offset:60928
	ds_load_tr16_b128 v[206:209] /*v[718:721]*/, v253 /*v765*/ offset:60960
	ds_load_tr16_b128 v[210:213] /*v[722:725]*/, v253 /*v765*/ offset:52288
	ds_load_tr16_b128 v[218:221] /*v[730:733]*/, v253 /*v765*/ offset:52320
	ds_load_tr16_b128 v[214:217] /*v[726:729]*/, v253 /*v765*/ offset:60992
	ds_load_tr16_b128 v[222:225] /*v[734:737]*/, v253 /*v765*/ offset:61024
	ds_load_tr16_b128 v[226:229] /*v[738:741]*/, v253 /*v765*/ offset:52352
	ds_load_tr16_b128 v[234:237] /*v[746:749]*/, v253 /*v765*/ offset:52384
	ds_load_tr16_b128 v[230:233] /*v[742:745]*/, v253 /*v765*/ offset:61056
	ds_load_tr16_b128 v[238:241] /*v[750:753]*/, v253 /*v765*/ offset:61088
	ds_load_tr16_b128 v[242:245] /*v[754:757]*/, v253 /*v765*/ offset:52416
	s_set_vgpr_msb 0x8ec2
	ds_load_tr16_b128 v[6:9] /*v[774:777]*/, v253 /*v765*/ offset:52448
	s_set_vgpr_msb 0xc282
	ds_load_tr16_b128 v[246:249] /*v[758:761]*/, v253 /*v765*/ offset:61120
	s_set_vgpr_msb 0x82c2
	ds_load_tr16_b128 v[10:13] /*v[778:781]*/, v253 /*v765*/ offset:61152
	s_set_vgpr_msb 0xc20a
	s_wait_dscnt 0x26
	v_wmma_f32_16x16x32_bf16 v[0:7], v[66:73] /*v[578:585]*/, v[10:17] /*v[522:529]*/, v[0:7]
	s_wait_dscnt 0x20
	v_wmma_f32_16x16x32_bf16 v[8:15], v[74:81] /*v[586:593]*/, v[10:17] /*v[522:529]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[82:89] /*v[594:601]*/, v[10:17] /*v[522:529]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[90:97] /*v[602:609]*/, v[10:17] /*v[522:529]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[98:105] /*v[610:617]*/, v[10:17] /*v[522:529]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[106:113] /*v[618:625]*/, v[10:17] /*v[522:529]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[114:121] /*v[626:633]*/, v[10:17] /*v[522:529]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[122:129] /*v[634:641]*/, v[10:17] /*v[522:529]*/, v[56:63]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[122:129] /*v[634:641]*/, v[2:9] /*v[514:521]*/, v[120:127]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[114:121] /*v[626:633]*/, v[2:9] /*v[514:521]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[106:113] /*v[618:625]*/, v[2:9] /*v[514:521]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[98:105] /*v[610:617]*/, v[2:9] /*v[514:521]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[90:97] /*v[602:609]*/, v[2:9] /*v[514:521]*/, v[88:95]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[82:89] /*v[594:601]*/, v[2:9] /*v[514:521]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[74:81] /*v[586:593]*/, v[2:9] /*v[514:521]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[66:73] /*v[578:585]*/, v[2:9] /*v[514:521]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[66:73] /*v[578:585]*/, v[18:25] /*v[530:537]*/, v[128:135]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[74:81] /*v[586:593]*/, v[18:25] /*v[530:537]*/, v[136:143]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[82:89] /*v[594:601]*/, v[18:25] /*v[530:537]*/, v[144:151]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[90:97] /*v[602:609]*/, v[18:25] /*v[530:537]*/, v[152:159]
	v_wmma_f32_16x16x32_bf16 v[160:167], v[98:105] /*v[610:617]*/, v[18:25] /*v[530:537]*/, v[160:167]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[106:113] /*v[618:625]*/, v[18:25] /*v[530:537]*/, v[168:175]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[114:121] /*v[626:633]*/, v[18:25] /*v[530:537]*/, v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[122:129] /*v[634:641]*/, v[18:25] /*v[530:537]*/, v[184:191]
	v_wmma_f32_16x16x32_bf16 v[240:247], v[122:129] /*v[634:641]*/, v[26:33] /*v[538:545]*/, v[240:247]
	v_wmma_f32_16x16x32_bf16 v[248:255], v[114:121] /*v[626:633]*/, v[26:33] /*v[538:545]*/, v[248:255]
	v_wmma_f32_16x16x32_bf16 v[232:239], v[106:113] /*v[618:625]*/, v[26:33] /*v[538:545]*/, v[232:239]
	v_wmma_f32_16x16x32_bf16 v[224:231], v[98:105] /*v[610:617]*/, v[26:33] /*v[538:545]*/, v[224:231]
	v_wmma_f32_16x16x32_bf16 v[216:223], v[90:97] /*v[602:609]*/, v[26:33] /*v[538:545]*/, v[216:223]
	v_wmma_f32_16x16x32_bf16 v[208:215], v[82:89] /*v[594:601]*/, v[26:33] /*v[538:545]*/, v[208:215]
	v_wmma_f32_16x16x32_bf16 v[200:207], v[74:81] /*v[586:593]*/, v[26:33] /*v[538:545]*/, v[200:207]
	v_wmma_f32_16x16x32_bf16 v[192:199], v[66:73] /*v[578:585]*/, v[26:33] /*v[538:545]*/, v[192:199]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[0:7] /*v[256:263]*/, v[66:73] /*v[578:585]*/, v[34:41] /*v[546:553]*/, v[0:7] /*v[256:263]*/
	v_wmma_f32_16x16x32_bf16 v[8:15] /*v[264:271]*/, v[74:81] /*v[586:593]*/, v[34:41] /*v[546:553]*/, v[8:15] /*v[264:271]*/
	v_wmma_f32_16x16x32_bf16 v[16:23] /*v[272:279]*/, v[82:89] /*v[594:601]*/, v[34:41] /*v[546:553]*/, v[16:23] /*v[272:279]*/
	v_wmma_f32_16x16x32_bf16 v[24:31] /*v[280:287]*/, v[90:97] /*v[602:609]*/, v[34:41] /*v[546:553]*/, v[24:31] /*v[280:287]*/
	v_wmma_f32_16x16x32_bf16 v[32:39] /*v[288:295]*/, v[98:105] /*v[610:617]*/, v[34:41] /*v[546:553]*/, v[32:39] /*v[288:295]*/
	v_wmma_f32_16x16x32_bf16 v[40:47] /*v[296:303]*/, v[106:113] /*v[618:625]*/, v[34:41] /*v[546:553]*/, v[40:47] /*v[296:303]*/
	v_wmma_f32_16x16x32_bf16 v[48:55] /*v[304:311]*/, v[114:121] /*v[626:633]*/, v[34:41] /*v[546:553]*/, v[48:55] /*v[304:311]*/
	v_wmma_f32_16x16x32_bf16 v[56:63] /*v[312:319]*/, v[122:129] /*v[634:641]*/, v[34:41] /*v[546:553]*/, v[56:63] /*v[312:319]*/
	v_wmma_f32_16x16x32_bf16 v[120:127] /*v[376:383]*/, v[122:129] /*v[634:641]*/, v[42:49] /*v[554:561]*/, v[120:127] /*v[376:383]*/
	v_wmma_f32_16x16x32_bf16 v[112:119] /*v[368:375]*/, v[114:121] /*v[626:633]*/, v[42:49] /*v[554:561]*/, v[112:119] /*v[368:375]*/
	v_wmma_f32_16x16x32_bf16 v[104:111] /*v[360:367]*/, v[106:113] /*v[618:625]*/, v[42:49] /*v[554:561]*/, v[104:111] /*v[360:367]*/
	v_wmma_f32_16x16x32_bf16 v[96:103] /*v[352:359]*/, v[98:105] /*v[610:617]*/, v[42:49] /*v[554:561]*/, v[96:103] /*v[352:359]*/
	v_wmma_f32_16x16x32_bf16 v[88:95] /*v[344:351]*/, v[90:97] /*v[602:609]*/, v[42:49] /*v[554:561]*/, v[88:95] /*v[344:351]*/
	v_wmma_f32_16x16x32_bf16 v[80:87] /*v[336:343]*/, v[82:89] /*v[594:601]*/, v[42:49] /*v[554:561]*/, v[80:87] /*v[336:343]*/
	v_wmma_f32_16x16x32_bf16 v[72:79] /*v[328:335]*/, v[74:81] /*v[586:593]*/, v[42:49] /*v[554:561]*/, v[72:79] /*v[328:335]*/
	v_wmma_f32_16x16x32_bf16 v[64:71] /*v[320:327]*/, v[66:73] /*v[578:585]*/, v[42:49] /*v[554:561]*/, v[64:71] /*v[320:327]*/
	v_wmma_f32_16x16x32_bf16 v[128:135] /*v[384:391]*/, v[66:73] /*v[578:585]*/, v[50:57] /*v[562:569]*/, v[128:135] /*v[384:391]*/
	v_wmma_f32_16x16x32_bf16 v[136:143] /*v[392:399]*/, v[74:81] /*v[586:593]*/, v[50:57] /*v[562:569]*/, v[136:143] /*v[392:399]*/
	v_wmma_f32_16x16x32_bf16 v[144:151] /*v[400:407]*/, v[82:89] /*v[594:601]*/, v[50:57] /*v[562:569]*/, v[144:151] /*v[400:407]*/
	v_wmma_f32_16x16x32_bf16 v[152:159] /*v[408:415]*/, v[90:97] /*v[602:609]*/, v[50:57] /*v[562:569]*/, v[152:159] /*v[408:415]*/
	v_wmma_f32_16x16x32_bf16 v[160:167] /*v[416:423]*/, v[98:105] /*v[610:617]*/, v[50:57] /*v[562:569]*/, v[160:167] /*v[416:423]*/
	v_wmma_f32_16x16x32_bf16 v[168:175] /*v[424:431]*/, v[106:113] /*v[618:625]*/, v[50:57] /*v[562:569]*/, v[168:175] /*v[424:431]*/
	v_wmma_f32_16x16x32_bf16 v[176:183] /*v[432:439]*/, v[114:121] /*v[626:633]*/, v[50:57] /*v[562:569]*/, v[176:183] /*v[432:439]*/
	v_wmma_f32_16x16x32_bf16 v[192:199] /*v[448:455]*/, v[122:129] /*v[634:641]*/, v[50:57] /*v[562:569]*/, v[192:199] /*v[448:455]*/
	v_wmma_f32_16x16x32_bf16 v[248:255] /*v[504:511]*/, v[122:129] /*v[634:641]*/, v[58:65] /*v[570:577]*/, v[248:255] /*v[504:511]*/
	v_wmma_f32_16x16x32_bf16 v[240:247] /*v[496:503]*/, v[114:121] /*v[626:633]*/, v[58:65] /*v[570:577]*/, v[240:247] /*v[496:503]*/
	v_wmma_f32_16x16x32_bf16 v[232:239] /*v[488:495]*/, v[106:113] /*v[618:625]*/, v[58:65] /*v[570:577]*/, v[232:239] /*v[488:495]*/
	v_wmma_f32_16x16x32_bf16 v[224:231] /*v[480:487]*/, v[98:105] /*v[610:617]*/, v[58:65] /*v[570:577]*/, v[224:231] /*v[480:487]*/
	v_wmma_f32_16x16x32_bf16 v[216:223] /*v[472:479]*/, v[90:97] /*v[602:609]*/, v[58:65] /*v[570:577]*/, v[216:223] /*v[472:479]*/
	v_wmma_f32_16x16x32_bf16 v[208:215] /*v[464:471]*/, v[82:89] /*v[594:601]*/, v[58:65] /*v[570:577]*/, v[208:215] /*v[464:471]*/
	v_wmma_f32_16x16x32_bf16 v[200:207] /*v[456:463]*/, v[74:81] /*v[586:593]*/, v[58:65] /*v[570:577]*/, v[200:207] /*v[456:463]*/
	v_wmma_f32_16x16x32_bf16 v[184:191] /*v[440:447]*/, v[66:73] /*v[578:585]*/, v[58:65] /*v[570:577]*/, v[184:191] /*v[440:447]*/
	s_set_vgpr_msb 0x5a0a
	s_wait_dscnt 0xd
	v_wmma_f32_16x16x32_bf16 v[0:7], v[194:201] /*v[706:713]*/, v[138:145] /*v[650:657]*/, v[0:7]
	s_wait_dscnt 0x0
	v_wmma_f32_16x16x32_bf16 v[8:15], v[202:209] /*v[714:721]*/, v[138:145] /*v[650:657]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[210:217] /*v[722:729]*/, v[138:145] /*v[650:657]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[218:225] /*v[730:737]*/, v[138:145] /*v[650:657]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[226:233] /*v[738:745]*/, v[138:145] /*v[650:657]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[234:241] /*v[746:753]*/, v[138:145] /*v[650:657]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[242:249] /*v[754:761]*/, v[138:145] /*v[650:657]*/, v[48:55]
	s_set_vgpr_msb 0xa0b
	v_wmma_f32_16x16x32_bf16 v[56:63], v[6:13] /*v[774:781]*/, v[138:145] /*v[650:657]*/, v[56:63]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[6:13] /*v[774:781]*/, v[130:137] /*v[642:649]*/, v[120:127]
	s_set_vgpr_msb 0xb0a
	v_wmma_f32_16x16x32_bf16 v[112:119], v[242:249] /*v[754:761]*/, v[130:137] /*v[642:649]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[234:241] /*v[746:753]*/, v[130:137] /*v[642:649]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[226:233] /*v[738:745]*/, v[130:137] /*v[642:649]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[218:225] /*v[730:737]*/, v[130:137] /*v[642:649]*/, v[88:95]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[210:217] /*v[722:729]*/, v[130:137] /*v[642:649]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[202:209] /*v[714:721]*/, v[130:137] /*v[642:649]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[194:201] /*v[706:713]*/, v[130:137] /*v[642:649]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[194:201] /*v[706:713]*/, v[146:153] /*v[658:665]*/, v[128:135]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[202:209] /*v[714:721]*/, v[146:153] /*v[658:665]*/, v[136:143]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[210:217] /*v[722:729]*/, v[146:153] /*v[658:665]*/, v[144:151]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[218:225] /*v[730:737]*/, v[146:153] /*v[658:665]*/, v[152:159]
	v_wmma_f32_16x16x32_bf16 v[160:167], v[226:233] /*v[738:745]*/, v[146:153] /*v[658:665]*/, v[160:167]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[234:241] /*v[746:753]*/, v[146:153] /*v[658:665]*/, v[168:175]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[242:249] /*v[754:761]*/, v[146:153] /*v[658:665]*/, v[176:183]
	s_set_vgpr_msb 0xa0b
	v_wmma_f32_16x16x32_bf16 v[184:191], v[6:13] /*v[774:781]*/, v[146:153] /*v[658:665]*/, v[184:191]
	v_wmma_f32_16x16x32_bf16 v[240:247], v[6:13] /*v[774:781]*/, v[154:161] /*v[666:673]*/, v[240:247]
	s_set_vgpr_msb 0xb0a
	v_wmma_f32_16x16x32_bf16 v[248:255], v[242:249] /*v[754:761]*/, v[154:161] /*v[666:673]*/, v[248:255]
	v_wmma_f32_16x16x32_bf16 v[232:239], v[234:241] /*v[746:753]*/, v[154:161] /*v[666:673]*/, v[232:239]
	v_wmma_f32_16x16x32_bf16 v[224:231], v[226:233] /*v[738:745]*/, v[154:161] /*v[666:673]*/, v[224:231]
	v_wmma_f32_16x16x32_bf16 v[216:223], v[218:225] /*v[730:737]*/, v[154:161] /*v[666:673]*/, v[216:223]
	v_wmma_f32_16x16x32_bf16 v[208:215], v[210:217] /*v[722:729]*/, v[154:161] /*v[666:673]*/, v[208:215]
	v_wmma_f32_16x16x32_bf16 v[200:207], v[202:209] /*v[714:721]*/, v[154:161] /*v[666:673]*/, v[200:207]
	v_wmma_f32_16x16x32_bf16 v[192:199], v[194:201] /*v[706:713]*/, v[154:161] /*v[666:673]*/, v[192:199]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[0:7] /*v[256:263]*/, v[194:201] /*v[706:713]*/, v[162:169] /*v[674:681]*/, v[0:7] /*v[256:263]*/
	v_wmma_f32_16x16x32_bf16 v[8:15] /*v[264:271]*/, v[202:209] /*v[714:721]*/, v[162:169] /*v[674:681]*/, v[8:15] /*v[264:271]*/
	v_wmma_f32_16x16x32_bf16 v[16:23] /*v[272:279]*/, v[210:217] /*v[722:729]*/, v[162:169] /*v[674:681]*/, v[16:23] /*v[272:279]*/
	v_wmma_f32_16x16x32_bf16 v[24:31] /*v[280:287]*/, v[218:225] /*v[730:737]*/, v[162:169] /*v[674:681]*/, v[24:31] /*v[280:287]*/
	v_wmma_f32_16x16x32_bf16 v[32:39] /*v[288:295]*/, v[226:233] /*v[738:745]*/, v[162:169] /*v[674:681]*/, v[32:39] /*v[288:295]*/
	v_wmma_f32_16x16x32_bf16 v[40:47] /*v[296:303]*/, v[234:241] /*v[746:753]*/, v[162:169] /*v[674:681]*/, v[40:47] /*v[296:303]*/
	v_wmma_f32_16x16x32_bf16 v[48:55] /*v[304:311]*/, v[242:249] /*v[754:761]*/, v[162:169] /*v[674:681]*/, v[48:55] /*v[304:311]*/
	s_set_vgpr_msb 0x5a5b
	v_wmma_f32_16x16x32_bf16 v[56:63] /*v[312:319]*/, v[6:13] /*v[774:781]*/, v[162:169] /*v[674:681]*/, v[56:63] /*v[312:319]*/
	v_wmma_f32_16x16x32_bf16 v[120:127] /*v[376:383]*/, v[6:13] /*v[774:781]*/, v[170:177] /*v[682:689]*/, v[120:127] /*v[376:383]*/
	s_set_vgpr_msb 0x5b5a
	v_wmma_f32_16x16x32_bf16 v[112:119] /*v[368:375]*/, v[242:249] /*v[754:761]*/, v[170:177] /*v[682:689]*/, v[112:119] /*v[368:375]*/
	v_wmma_f32_16x16x32_bf16 v[104:111] /*v[360:367]*/, v[234:241] /*v[746:753]*/, v[170:177] /*v[682:689]*/, v[104:111] /*v[360:367]*/
	v_wmma_f32_16x16x32_bf16 v[96:103] /*v[352:359]*/, v[226:233] /*v[738:745]*/, v[170:177] /*v[682:689]*/, v[96:103] /*v[352:359]*/
	v_wmma_f32_16x16x32_bf16 v[88:95] /*v[344:351]*/, v[218:225] /*v[730:737]*/, v[170:177] /*v[682:689]*/, v[88:95] /*v[344:351]*/
	v_wmma_f32_16x16x32_bf16 v[80:87] /*v[336:343]*/, v[210:217] /*v[722:729]*/, v[170:177] /*v[682:689]*/, v[80:87] /*v[336:343]*/
	v_wmma_f32_16x16x32_bf16 v[72:79] /*v[328:335]*/, v[202:209] /*v[714:721]*/, v[170:177] /*v[682:689]*/, v[72:79] /*v[328:335]*/
	v_wmma_f32_16x16x32_bf16 v[64:71] /*v[320:327]*/, v[194:201] /*v[706:713]*/, v[170:177] /*v[682:689]*/, v[64:71] /*v[320:327]*/
	v_wmma_f32_16x16x32_bf16 v[128:135] /*v[384:391]*/, v[194:201] /*v[706:713]*/, v[178:185] /*v[690:697]*/, v[128:135] /*v[384:391]*/
	v_wmma_f32_16x16x32_bf16 v[136:143] /*v[392:399]*/, v[202:209] /*v[714:721]*/, v[178:185] /*v[690:697]*/, v[136:143] /*v[392:399]*/
	v_wmma_f32_16x16x32_bf16 v[144:151] /*v[400:407]*/, v[210:217] /*v[722:729]*/, v[178:185] /*v[690:697]*/, v[144:151] /*v[400:407]*/
	v_wmma_f32_16x16x32_bf16 v[152:159] /*v[408:415]*/, v[218:225] /*v[730:737]*/, v[178:185] /*v[690:697]*/, v[152:159] /*v[408:415]*/
	v_wmma_f32_16x16x32_bf16 v[160:167] /*v[416:423]*/, v[226:233] /*v[738:745]*/, v[178:185] /*v[690:697]*/, v[160:167] /*v[416:423]*/
	v_wmma_f32_16x16x32_bf16 v[168:175] /*v[424:431]*/, v[234:241] /*v[746:753]*/, v[178:185] /*v[690:697]*/, v[168:175] /*v[424:431]*/
	v_wmma_f32_16x16x32_bf16 v[176:183] /*v[432:439]*/, v[242:249] /*v[754:761]*/, v[178:185] /*v[690:697]*/, v[176:183] /*v[432:439]*/
	s_set_vgpr_msb 0x5a5b
	v_wmma_f32_16x16x32_bf16 v[192:199] /*v[448:455]*/, v[6:13] /*v[774:781]*/, v[178:185] /*v[690:697]*/, v[192:199] /*v[448:455]*/
	v_wmma_f32_16x16x32_bf16 v[248:255] /*v[504:511]*/, v[6:13] /*v[774:781]*/, v[186:193] /*v[698:705]*/, v[248:255] /*v[504:511]*/
	s_set_vgpr_msb 0x5b5a
	v_wmma_f32_16x16x32_bf16 v[240:247] /*v[496:503]*/, v[242:249] /*v[754:761]*/, v[186:193] /*v[698:705]*/, v[240:247] /*v[496:503]*/
	v_wmma_f32_16x16x32_bf16 v[232:239] /*v[488:495]*/, v[234:241] /*v[746:753]*/, v[186:193] /*v[698:705]*/, v[232:239] /*v[488:495]*/
	v_wmma_f32_16x16x32_bf16 v[224:231] /*v[480:487]*/, v[226:233] /*v[738:745]*/, v[186:193] /*v[698:705]*/, v[224:231] /*v[480:487]*/
	v_wmma_f32_16x16x32_bf16 v[216:223] /*v[472:479]*/, v[218:225] /*v[730:737]*/, v[186:193] /*v[698:705]*/, v[216:223] /*v[472:479]*/
	v_wmma_f32_16x16x32_bf16 v[208:215] /*v[464:471]*/, v[210:217] /*v[722:729]*/, v[186:193] /*v[698:705]*/, v[208:215] /*v[464:471]*/
	v_wmma_f32_16x16x32_bf16 v[200:207] /*v[456:463]*/, v[202:209] /*v[714:721]*/, v[186:193] /*v[698:705]*/, v[200:207] /*v[456:463]*/
	v_wmma_f32_16x16x32_bf16 v[184:191] /*v[440:447]*/, v[194:201] /*v[706:713]*/, v[186:193] /*v[698:705]*/, v[184:191] /*v[440:447]*/
	s_wait_alu depctr_vm_vsrc(6)
	s_set_vgpr_msb 0x5a8c
	v_or_b32_e32 v1 /*v513*/, s0, v4 /*v772*/
	s_wait_tensorcnt 0x0
	s_set_vgpr_msb 0x8c00
	s_barrier_signal -1
	v_cvt_pk_bf16_f32 v7, v6, v7
	s_set_vgpr_msb 0x88
	v_lshlrev_b32_e32 v1 /*v513*/, 1, v1 /*v513*/
	s_set_vgpr_msb 0x8800
	v_cvt_pk_bf16_f32 v6, v4, v5
	v_cvt_pk_bf16_f32 v5, v2, v3
	v_cvt_pk_bf16_f32 v3, v14, v15
	v_cvt_pk_bf16_f32 v4, v0, v1
	s_set_vgpr_msb 35
	v_lshl_or_b32 v14, v1 /*v769*/, 9, v1 /*v513*/
	s_set_vgpr_msb 0x2300
	v_cvt_pk_bf16_f32 v2, v12, v13
	v_cvt_pk_bf16_f32 v1, v10, v11
	v_cvt_pk_bf16_f32 v0, v8, v9
	v_cvt_pk_bf16_f32 v11, v22, v23
	s_set_vgpr_msb 0x80
	v_add_nc_u32_e32 v2 /*v514*/, 0, v14
	s_set_vgpr_msb 0x8000
	v_cvt_pk_bf16_f32 v10, v20, v21
	v_cvt_pk_bf16_f32 v9, v18, v19
	v_cvt_pk_bf16_f32 v8, v16, v17
	v_cvt_pk_bf16_f32 v15, v30, v31
	v_cvt_pk_bf16_f32 v14, v28, v29
	v_cvt_pk_bf16_f32 v13, v26, v27
	v_cvt_pk_bf16_f32 v12, v24, v25
	s_barrier_wait -1
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 2
	ds_store_b128 v2 /*v514*/, v[4:7]
	ds_store_b128 v2 /*v514*/, v[0:3] offset:32
	ds_store_b128 v2 /*v514*/, v[8:11] offset:64
	ds_store_b128 v2 /*v514*/, v[12:15] offset:96
	s_wait_alu depctr_vm_vsrc(2)
	s_set_vgpr_msb 0x200
	v_cvt_pk_bf16_f32 v3, v38, v39
	v_cvt_pk_bf16_f32 v2, v36, v37
	v_cvt_pk_bf16_f32 v1, v34, v35
	v_cvt_pk_bf16_f32 v0, v32, v33
	v_cvt_pk_bf16_f32 v7, v46, v47
	v_cvt_pk_bf16_f32 v6, v44, v45
	v_cvt_pk_bf16_f32 v5, v42, v43
	v_cvt_pk_bf16_f32 v4, v40, v41
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v11, v54, v55
	v_cvt_pk_bf16_f32 v10, v52, v53
	v_cvt_pk_bf16_f32 v9, v50, v51
	v_cvt_pk_bf16_f32 v8, v48, v49
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v15, v62, v63
	v_cvt_pk_bf16_f32 v14, v60, v61
	v_cvt_pk_bf16_f32 v13, v58, v59
	v_cvt_pk_bf16_f32 v12, v56, v57
	v_cvt_pk_bf16_f32 v19, v70, v71
	v_cvt_pk_bf16_f32 v18, v68, v69
	v_cvt_pk_bf16_f32 v17, v66, v67
	v_cvt_pk_bf16_f32 v16, v64, v65
	v_cvt_pk_bf16_f32 v23, v78, v79
	v_cvt_pk_bf16_f32 v22, v76, v77
	v_cvt_pk_bf16_f32 v21, v74, v75
	v_cvt_pk_bf16_f32 v20, v72, v73
	s_wait_alu depctr_va_vdst(14)
	s_set_vgpr_msb 2
	ds_store_b128 v2 /*v514*/, v[0:3] offset:128
	ds_store_b128 v2 /*v514*/, v[4:7] offset:160
	s_wait_alu depctr_va_vdst(12)
	ds_store_b128 v2 /*v514*/, v[8:11] offset:192
	s_wait_alu depctr_va_vdst(8)
	ds_store_b128 v2 /*v514*/, v[12:15] offset:224
	s_wait_alu depctr_va_vdst(4)
	ds_store_b128 v2 /*v514*/, v[16:19] offset:8192
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v2 /*v514*/, v[20:23] offset:8224
	s_wait_alu depctr_vm_vsrc(5)
	s_set_vgpr_msb 0x200
	v_cvt_pk_bf16_f32 v3, v86, v87
	v_cvt_pk_bf16_f32 v2, v84, v85
	v_cvt_pk_bf16_f32 v1, v82, v83
	v_cvt_pk_bf16_f32 v0, v80, v81
	s_wait_alu depctr_vm_vsrc(4)
	v_cvt_pk_bf16_f32 v7, v94, v95
	v_cvt_pk_bf16_f32 v6, v92, v93
	v_cvt_pk_bf16_f32 v5, v90, v91
	v_cvt_pk_bf16_f32 v4, v88, v89
	s_wait_alu depctr_vm_vsrc(3)
	v_cvt_pk_bf16_f32 v11, v102, v103
	v_cvt_pk_bf16_f32 v10, v100, v101
	v_cvt_pk_bf16_f32 v9, v98, v99
	v_cvt_pk_bf16_f32 v8, v96, v97
	s_wait_alu depctr_vm_vsrc(2)
	v_cvt_pk_bf16_f32 v15, v110, v111
	v_cvt_pk_bf16_f32 v14, v108, v109
	v_cvt_pk_bf16_f32 v13, v106, v107
	v_cvt_pk_bf16_f32 v12, v104, v105
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v19, v118, v119
	v_cvt_pk_bf16_f32 v18, v116, v117
	v_cvt_pk_bf16_f32 v17, v114, v115
	v_cvt_pk_bf16_f32 v16, v112, v113
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v23, v126, v127
	v_cvt_pk_bf16_f32 v22, v124, v125
	v_cvt_pk_bf16_f32 v21, v122, v123
	v_cvt_pk_bf16_f32 v20, v120, v121
	s_wait_alu depctr_va_vdst(14)
	s_set_vgpr_msb 2
	ds_store_b128 v2 /*v514*/, v[0:3] offset:8256
	ds_store_b128 v2 /*v514*/, v[4:7] offset:8288
	s_wait_alu depctr_va_vdst(12)
	ds_store_b128 v2 /*v514*/, v[8:11] offset:8320
	s_wait_alu depctr_va_vdst(8)
	ds_store_b128 v2 /*v514*/, v[12:15] offset:8352
	s_wait_alu depctr_va_vdst(4)
	ds_store_b128 v2 /*v514*/, v[16:19] offset:8384
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v2 /*v514*/, v[20:23] offset:8416
	s_wait_alu depctr_vm_vsrc(5)
	s_set_vgpr_msb 0x200
	v_cvt_pk_bf16_f32 v3, v134, v135
	v_cvt_pk_bf16_f32 v2, v132, v133
	v_cvt_pk_bf16_f32 v1, v130, v131
	v_cvt_pk_bf16_f32 v0, v128, v129
	s_wait_alu depctr_vm_vsrc(4)
	v_cvt_pk_bf16_f32 v7, v142, v143
	v_cvt_pk_bf16_f32 v6, v140, v141
	v_cvt_pk_bf16_f32 v5, v138, v139
	v_cvt_pk_bf16_f32 v4, v136, v137
	s_wait_alu depctr_vm_vsrc(3)
	v_cvt_pk_bf16_f32 v11, v150, v151
	v_cvt_pk_bf16_f32 v10, v148, v149
	v_cvt_pk_bf16_f32 v9, v146, v147
	v_cvt_pk_bf16_f32 v8, v144, v145
	s_wait_alu depctr_vm_vsrc(2)
	v_cvt_pk_bf16_f32 v15, v158, v159
	v_cvt_pk_bf16_f32 v14, v156, v157
	v_cvt_pk_bf16_f32 v13, v154, v155
	v_cvt_pk_bf16_f32 v12, v152, v153
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v19, v166, v167
	v_cvt_pk_bf16_f32 v18, v164, v165
	v_cvt_pk_bf16_f32 v17, v162, v163
	v_cvt_pk_bf16_f32 v16, v160, v161
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v23, v174, v175
	v_cvt_pk_bf16_f32 v22, v172, v173
	v_cvt_pk_bf16_f32 v21, v170, v171
	v_cvt_pk_bf16_f32 v20, v168, v169
	s_wait_alu depctr_va_vdst(14)
	s_set_vgpr_msb 2
	ds_store_b128 v2 /*v514*/, v[0:3] offset:16384
	ds_store_b128 v2 /*v514*/, v[4:7] offset:16416
	s_wait_alu depctr_va_vdst(12)
	ds_store_b128 v2 /*v514*/, v[8:11] offset:16448
	s_wait_alu depctr_va_vdst(8)
	ds_store_b128 v2 /*v514*/, v[12:15] offset:16480
	s_wait_alu depctr_va_vdst(4)
	ds_store_b128 v2 /*v514*/, v[16:19] offset:16512
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v2 /*v514*/, v[20:23] offset:16544
	s_wait_alu depctr_vm_vsrc(5)
	s_set_vgpr_msb 0x200
	v_cvt_pk_bf16_f32 v3, v182, v183
	v_cvt_pk_bf16_f32 v2, v180, v181
	v_cvt_pk_bf16_f32 v1, v178, v179
	v_cvt_pk_bf16_f32 v0, v176, v177
	s_wait_alu depctr_vm_vsrc(4)
	v_cvt_pk_bf16_f32 v7, v190, v191
	v_cvt_pk_bf16_f32 v6, v188, v189
	v_cvt_pk_bf16_f32 v5, v186, v187
	v_cvt_pk_bf16_f32 v4, v184, v185
	s_wait_alu depctr_vm_vsrc(3)
	v_cvt_pk_bf16_f32 v11, v198, v199
	v_cvt_pk_bf16_f32 v10, v196, v197
	v_cvt_pk_bf16_f32 v9, v194, v195
	v_cvt_pk_bf16_f32 v8, v192, v193
	s_wait_alu depctr_vm_vsrc(2)
	v_cvt_pk_bf16_f32 v15, v206, v207
	v_cvt_pk_bf16_f32 v14, v204, v205
	v_cvt_pk_bf16_f32 v13, v202, v203
	v_cvt_pk_bf16_f32 v12, v200, v201
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v19, v214, v215
	v_cvt_pk_bf16_f32 v18, v212, v213
	v_cvt_pk_bf16_f32 v17, v210, v211
	v_cvt_pk_bf16_f32 v16, v208, v209
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v23, v222, v223
	v_cvt_pk_bf16_f32 v22, v220, v221
	v_cvt_pk_bf16_f32 v21, v218, v219
	v_cvt_pk_bf16_f32 v20, v216, v217
	s_wait_alu depctr_va_vdst(14)
	s_set_vgpr_msb 2
	ds_store_b128 v2 /*v514*/, v[0:3] offset:16576
	ds_store_b128 v2 /*v514*/, v[4:7] offset:16608
	s_wait_alu depctr_va_vdst(12)
	ds_store_b128 v2 /*v514*/, v[8:11] offset:24576
	s_wait_alu depctr_va_vdst(8)
	ds_store_b128 v2 /*v514*/, v[12:15] offset:24608
	s_wait_alu depctr_va_vdst(4)
	ds_store_b128 v2 /*v514*/, v[16:19] offset:24640
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v2 /*v514*/, v[20:23] offset:24672
	s_wait_alu depctr_vm_vsrc(5)
	s_set_vgpr_msb 0x200
	v_cvt_pk_bf16_f32 v3, v230, v231
	v_cvt_pk_bf16_f32 v2, v228, v229
	v_cvt_pk_bf16_f32 v1, v226, v227
	v_cvt_pk_bf16_f32 v0, v224, v225
	s_wait_alu depctr_vm_vsrc(4)
	v_cvt_pk_bf16_f32 v7, v238, v239
	v_cvt_pk_bf16_f32 v6, v236, v237
	v_cvt_pk_bf16_f32 v5, v234, v235
	v_cvt_pk_bf16_f32 v4, v232, v233
	s_wait_alu depctr_vm_vsrc(3)
	v_cvt_pk_bf16_f32 v11, v254, v255
	v_cvt_pk_bf16_f32 v10, v252, v253
	v_cvt_pk_bf16_f32 v9, v250, v251
	v_cvt_pk_bf16_f32 v8, v248, v249
	s_wait_alu depctr_vm_vsrc(2)
	v_cvt_pk_bf16_f32 v15, v246, v247
	v_cvt_pk_bf16_f32 v14, v244, v245
	v_cvt_pk_bf16_f32 v13, v242, v243
	v_cvt_pk_bf16_f32 v12, v240, v241
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v19, v6 /*v262*/, v7 /*v263*/
	v_cvt_pk_bf16_f32 v18, v4 /*v260*/, v5 /*v261*/
	v_cvt_pk_bf16_f32 v17, v2 /*v258*/, v3 /*v259*/
	v_cvt_pk_bf16_f32 v16, v0 /*v256*/, v1 /*v257*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v23, v14 /*v270*/, v15 /*v271*/
	v_cvt_pk_bf16_f32 v22, v12 /*v268*/, v13 /*v269*/
	v_cvt_pk_bf16_f32 v21, v10 /*v266*/, v11 /*v267*/
	v_cvt_pk_bf16_f32 v20, v8 /*v264*/, v9 /*v265*/
	s_wait_alu depctr_va_vdst(14)
	s_set_vgpr_msb 0x502
	ds_store_b128 v2 /*v514*/, v[0:3] offset:24704
	ds_store_b128 v2 /*v514*/, v[4:7] offset:24736
	s_wait_alu depctr_va_vdst(12)
	ds_store_b128 v2 /*v514*/, v[8:11] offset:24768
	s_wait_alu depctr_va_vdst(8)
	ds_store_b128 v2 /*v514*/, v[12:15] offset:24800
	s_wait_alu depctr_va_vdst(4)
	ds_store_b128 v2 /*v514*/, v[16:19] offset:32768
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v2 /*v514*/, v[20:23] offset:32800
	s_wait_alu depctr_vm_vsrc(5)
	s_set_vgpr_msb 0x205
	v_cvt_pk_bf16_f32 v3, v22 /*v278*/, v23 /*v279*/
	v_cvt_pk_bf16_f32 v2, v20 /*v276*/, v21 /*v277*/
	v_cvt_pk_bf16_f32 v1, v18 /*v274*/, v19 /*v275*/
	v_cvt_pk_bf16_f32 v0, v16 /*v272*/, v17 /*v273*/
	s_wait_alu depctr_vm_vsrc(4)
	v_cvt_pk_bf16_f32 v7, v30 /*v286*/, v31 /*v287*/
	v_cvt_pk_bf16_f32 v6, v28 /*v284*/, v29 /*v285*/
	v_cvt_pk_bf16_f32 v5, v26 /*v282*/, v27 /*v283*/
	v_cvt_pk_bf16_f32 v4, v24 /*v280*/, v25 /*v281*/
	s_wait_alu depctr_vm_vsrc(3)
	v_cvt_pk_bf16_f32 v11, v38 /*v294*/, v39 /*v295*/
	v_cvt_pk_bf16_f32 v10, v36 /*v292*/, v37 /*v293*/
	v_cvt_pk_bf16_f32 v9, v34 /*v290*/, v35 /*v291*/
	v_cvt_pk_bf16_f32 v8, v32 /*v288*/, v33 /*v289*/
	s_wait_alu depctr_vm_vsrc(2)
	v_cvt_pk_bf16_f32 v15, v46 /*v302*/, v47 /*v303*/
	v_cvt_pk_bf16_f32 v14, v44 /*v300*/, v45 /*v301*/
	v_cvt_pk_bf16_f32 v13, v42 /*v298*/, v43 /*v299*/
	v_cvt_pk_bf16_f32 v12, v40 /*v296*/, v41 /*v297*/
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v19, v54 /*v310*/, v55 /*v311*/
	v_cvt_pk_bf16_f32 v18, v52 /*v308*/, v53 /*v309*/
	v_cvt_pk_bf16_f32 v17, v50 /*v306*/, v51 /*v307*/
	v_cvt_pk_bf16_f32 v16, v48 /*v304*/, v49 /*v305*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v23, v62 /*v318*/, v63 /*v319*/
	v_cvt_pk_bf16_f32 v22, v60 /*v316*/, v61 /*v317*/
	v_cvt_pk_bf16_f32 v21, v58 /*v314*/, v59 /*v315*/
	v_cvt_pk_bf16_f32 v20, v56 /*v312*/, v57 /*v313*/
	s_wait_alu depctr_va_vdst(14)
	s_set_vgpr_msb 0x502
	ds_store_b128 v2 /*v514*/, v[0:3] offset:32832
	ds_store_b128 v2 /*v514*/, v[4:7] offset:32864
	s_wait_alu depctr_va_vdst(12)
	ds_store_b128 v2 /*v514*/, v[8:11] offset:32896
	s_wait_alu depctr_va_vdst(8)
	ds_store_b128 v2 /*v514*/, v[12:15] offset:32928
	s_wait_alu depctr_va_vdst(4)
	ds_store_b128 v2 /*v514*/, v[16:19] offset:32960
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v2 /*v514*/, v[20:23] offset:32992
	s_wait_alu depctr_vm_vsrc(5)
	s_set_vgpr_msb 0x205
	v_cvt_pk_bf16_f32 v3, v70 /*v326*/, v71 /*v327*/
	v_cvt_pk_bf16_f32 v2, v68 /*v324*/, v69 /*v325*/
	v_cvt_pk_bf16_f32 v1, v66 /*v322*/, v67 /*v323*/
	v_cvt_pk_bf16_f32 v0, v64 /*v320*/, v65 /*v321*/
	s_wait_alu depctr_vm_vsrc(4)
	v_cvt_pk_bf16_f32 v7, v78 /*v334*/, v79 /*v335*/
	v_cvt_pk_bf16_f32 v6, v76 /*v332*/, v77 /*v333*/
	v_cvt_pk_bf16_f32 v5, v74 /*v330*/, v75 /*v331*/
	v_cvt_pk_bf16_f32 v4, v72 /*v328*/, v73 /*v329*/
	s_wait_alu depctr_vm_vsrc(3)
	v_cvt_pk_bf16_f32 v11, v86 /*v342*/, v87 /*v343*/
	v_cvt_pk_bf16_f32 v10, v84 /*v340*/, v85 /*v341*/
	v_cvt_pk_bf16_f32 v9, v82 /*v338*/, v83 /*v339*/
	v_cvt_pk_bf16_f32 v8, v80 /*v336*/, v81 /*v337*/
	s_wait_alu depctr_vm_vsrc(2)
	v_cvt_pk_bf16_f32 v15, v94 /*v350*/, v95 /*v351*/
	v_cvt_pk_bf16_f32 v14, v92 /*v348*/, v93 /*v349*/
	v_cvt_pk_bf16_f32 v13, v90 /*v346*/, v91 /*v347*/
	v_cvt_pk_bf16_f32 v12, v88 /*v344*/, v89 /*v345*/
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v19, v102 /*v358*/, v103 /*v359*/
	v_cvt_pk_bf16_f32 v18, v100 /*v356*/, v101 /*v357*/
	v_cvt_pk_bf16_f32 v17, v98 /*v354*/, v99 /*v355*/
	v_cvt_pk_bf16_f32 v16, v96 /*v352*/, v97 /*v353*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v23, v110 /*v366*/, v111 /*v367*/
	v_cvt_pk_bf16_f32 v22, v108 /*v364*/, v109 /*v365*/
	v_cvt_pk_bf16_f32 v21, v106 /*v362*/, v107 /*v363*/
	v_cvt_pk_bf16_f32 v20, v104 /*v360*/, v105 /*v361*/
	s_wait_alu depctr_va_vdst(14)
	s_set_vgpr_msb 0x502
	ds_store_b128 v2 /*v514*/, v[0:3] offset:40960
	ds_store_b128 v2 /*v514*/, v[4:7] offset:40992
	s_wait_alu depctr_va_vdst(12)
	ds_store_b128 v2 /*v514*/, v[8:11] offset:41024
	s_wait_alu depctr_va_vdst(8)
	ds_store_b128 v2 /*v514*/, v[12:15] offset:41056
	s_wait_alu depctr_va_vdst(4)
	ds_store_b128 v2 /*v514*/, v[16:19] offset:41088
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v2 /*v514*/, v[20:23] offset:41120
	s_wait_alu depctr_vm_vsrc(5)
	s_set_vgpr_msb 0x205
	v_cvt_pk_bf16_f32 v3, v118 /*v374*/, v119 /*v375*/
	v_cvt_pk_bf16_f32 v2, v116 /*v372*/, v117 /*v373*/
	v_cvt_pk_bf16_f32 v1, v114 /*v370*/, v115 /*v371*/
	v_cvt_pk_bf16_f32 v0, v112 /*v368*/, v113 /*v369*/
	s_wait_alu depctr_vm_vsrc(4)
	v_cvt_pk_bf16_f32 v7, v126 /*v382*/, v127 /*v383*/
	v_cvt_pk_bf16_f32 v6, v124 /*v380*/, v125 /*v381*/
	v_cvt_pk_bf16_f32 v5, v122 /*v378*/, v123 /*v379*/
	v_cvt_pk_bf16_f32 v4, v120 /*v376*/, v121 /*v377*/
	s_wait_alu depctr_vm_vsrc(3)
	v_cvt_pk_bf16_f32 v11, v134 /*v390*/, v135 /*v391*/
	v_cvt_pk_bf16_f32 v10, v132 /*v388*/, v133 /*v389*/
	v_cvt_pk_bf16_f32 v9, v130 /*v386*/, v131 /*v387*/
	v_cvt_pk_bf16_f32 v8, v128 /*v384*/, v129 /*v385*/
	s_wait_alu depctr_vm_vsrc(2)
	v_cvt_pk_bf16_f32 v15, v142 /*v398*/, v143 /*v399*/
	v_cvt_pk_bf16_f32 v14, v140 /*v396*/, v141 /*v397*/
	v_cvt_pk_bf16_f32 v13, v138 /*v394*/, v139 /*v395*/
	v_cvt_pk_bf16_f32 v12, v136 /*v392*/, v137 /*v393*/
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v19, v150 /*v406*/, v151 /*v407*/
	v_cvt_pk_bf16_f32 v18, v148 /*v404*/, v149 /*v405*/
	v_cvt_pk_bf16_f32 v17, v146 /*v402*/, v147 /*v403*/
	v_cvt_pk_bf16_f32 v16, v144 /*v400*/, v145 /*v401*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v20, v152 /*v408*/, v153 /*v409*/
	v_cvt_pk_bf16_f32 v23, v158 /*v414*/, v159 /*v415*/
	v_cvt_pk_bf16_f32 v22, v156 /*v412*/, v157 /*v413*/
	v_cvt_pk_bf16_f32 v21, v154 /*v410*/, v155 /*v411*/
	s_wait_alu depctr_va_vdst(14)
	s_set_vgpr_msb 0x522
	ds_store_b128 v2 /*v514*/, v[0:3] offset:41152
	ds_store_b128 v2 /*v514*/, v[4:7] offset:41184
	s_wait_alu depctr_va_vdst(12)
	ds_store_b128 v2 /*v514*/, v[8:11] offset:49152
	s_wait_alu depctr_va_vdst(8)
	ds_store_b128 v2 /*v514*/, v[12:15] offset:49184
	s_wait_alu depctr_va_vdst(4)
	ds_store_b128 v2 /*v514*/, v[16:19] offset:49216
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v2 /*v514*/, v[20:23] offset:49248
	s_wait_alu depctr_vm_vsrc(0)
	v_lshl_or_b32 v20, v0 /*v512*/, 9, v1 /*v513*/
	s_set_vgpr_msb 0x2205
	v_cvt_pk_bf16_f32 v3, v166 /*v422*/, v167 /*v423*/
	v_cvt_pk_bf16_f32 v2, v164 /*v420*/, v165 /*v421*/
	v_cvt_pk_bf16_f32 v1, v162 /*v418*/, v163 /*v419*/
	v_cvt_pk_bf16_f32 v0, v160 /*v416*/, v161 /*v417*/
	v_cvt_pk_bf16_f32 v7, v174 /*v430*/, v175 /*v431*/
	v_cvt_pk_bf16_f32 v6, v172 /*v428*/, v173 /*v429*/
	v_cvt_pk_bf16_f32 v5, v170 /*v426*/, v171 /*v427*/
	v_cvt_pk_bf16_f32 v4, v168 /*v424*/, v169 /*v425*/
	v_cvt_pk_bf16_f32 v11, v182 /*v438*/, v183 /*v439*/
	v_cvt_pk_bf16_f32 v10, v180 /*v436*/, v181 /*v437*/
	v_cvt_pk_bf16_f32 v9, v178 /*v434*/, v179 /*v435*/
	v_cvt_pk_bf16_f32 v8, v176 /*v432*/, v177 /*v433*/
	v_cvt_pk_bf16_f32 v15, v198 /*v454*/, v199 /*v455*/
	v_cvt_pk_bf16_f32 v14, v196 /*v452*/, v197 /*v453*/
	v_cvt_pk_bf16_f32 v13, v194 /*v450*/, v195 /*v451*/
	v_cvt_pk_bf16_f32 v12, v192 /*v448*/, v193 /*v449*/
	v_cvt_pk_bf16_f32 v19, v190 /*v446*/, v191 /*v447*/
	v_cvt_pk_bf16_f32 v18, v188 /*v444*/, v189 /*v445*/
	v_cvt_pk_bf16_f32 v17, v186 /*v442*/, v187 /*v443*/
	v_cvt_pk_bf16_f32 v16, v184 /*v440*/, v185 /*v441*/
	s_set_vgpr_msb 0x500
	v_add_nc_u32_e32 v24, 0, v20
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v23, v206 /*v462*/, v207 /*v463*/
	v_cvt_pk_bf16_f32 v22, v204 /*v460*/, v205 /*v461*/
	v_cvt_pk_bf16_f32 v21, v202 /*v458*/, v203 /*v459*/
	v_cvt_pk_bf16_f32 v20, v200 /*v456*/, v201 /*v457*/
	s_wait_alu depctr_va_vdst(14)
	s_set_vgpr_msb 0x502
	ds_store_b128 v2 /*v514*/, v[0:3] offset:49280
	ds_store_b128 v2 /*v514*/, v[4:7] offset:49312
	s_wait_alu depctr_va_vdst(13)
	ds_store_b128 v2 /*v514*/, v[8:11] offset:49344
	s_wait_alu depctr_va_vdst(9)
	ds_store_b128 v2 /*v514*/, v[12:15] offset:49376
	s_wait_alu depctr_va_vdst(4)
	s_set_vgpr_msb 0x200
	ds_store_b128 v24, v[16:19]
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v24, v[20:23] offset:32
	s_wait_alu depctr_vm_vsrc(5)
	s_set_vgpr_msb 5
	v_cvt_pk_bf16_f32 v3, v214 /*v470*/, v215 /*v471*/
	v_cvt_pk_bf16_f32 v2, v212 /*v468*/, v213 /*v469*/
	v_cvt_pk_bf16_f32 v1, v210 /*v466*/, v211 /*v467*/
	v_cvt_pk_bf16_f32 v0, v208 /*v464*/, v209 /*v465*/
	s_wait_alu depctr_vm_vsrc(4)
	v_cvt_pk_bf16_f32 v7, v222 /*v478*/, v223 /*v479*/
	v_cvt_pk_bf16_f32 v6, v220 /*v476*/, v221 /*v477*/
	v_cvt_pk_bf16_f32 v5, v218 /*v474*/, v219 /*v475*/
	v_cvt_pk_bf16_f32 v4, v216 /*v472*/, v217 /*v473*/
	s_wait_alu depctr_vm_vsrc(3)
	v_cvt_pk_bf16_f32 v11, v230 /*v486*/, v231 /*v487*/
	v_cvt_pk_bf16_f32 v10, v228 /*v484*/, v229 /*v485*/
	v_cvt_pk_bf16_f32 v9, v226 /*v482*/, v227 /*v483*/
	v_cvt_pk_bf16_f32 v8, v224 /*v480*/, v225 /*v481*/
	s_mul_u64 s[10:11], s[36:37], s[34:35]
	s_ashr_i32 s3, s2, 31
	s_wait_alu depctr_vm_vsrc(2)
	v_cvt_pk_bf16_f32 v15, v238 /*v494*/, v239 /*v495*/
	v_cvt_pk_bf16_f32 v14, v236 /*v492*/, v237 /*v493*/
	v_cvt_pk_bf16_f32 v13, v234 /*v490*/, v235 /*v491*/
	v_cvt_pk_bf16_f32 v12, v232 /*v488*/, v233 /*v489*/
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v19, v246 /*v502*/, v247 /*v503*/
	v_cvt_pk_bf16_f32 v18, v244 /*v500*/, v245 /*v501*/
	v_cvt_pk_bf16_f32 v17, v242 /*v498*/, v243 /*v499*/
	v_cvt_pk_bf16_f32 v16, v240 /*v496*/, v241 /*v497*/
	s_lshl_b64 s[10:11], s[10:11], 1
	s_lshl_b64 s[2:3], s[2:3], 1
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v23, v254 /*v510*/, v255 /*v511*/
	v_cvt_pk_bf16_f32 v22, v252 /*v508*/, v253 /*v509*/
	v_cvt_pk_bf16_f32 v21, v250 /*v506*/, v251 /*v507*/
	v_cvt_pk_bf16_f32 v20, v248 /*v504*/, v249 /*v505*/
	s_wait_alu depctr_va_vdst(14)
	s_set_vgpr_msb 0x500
	ds_store_b128 v24, v[0:3] offset:64
	ds_store_b128 v24, v[4:7] offset:96
	s_wait_alu depctr_va_vdst(12)
	ds_store_b128 v24, v[8:11] offset:128
	s_wait_alu depctr_va_vdst(8)
	ds_store_b128 v24, v[12:15] offset:160
	s_wait_alu depctr_va_vdst(4)
	ds_store_b128 v24, v[16:19] offset:192
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v24, v[20:23] offset:224
	s_wait_dscnt 0x0
	s_barrier_signal -1
	s_cmp_lg_u32 s34, 0x80000000
	s_add_nc_u64 s[4:5], s[4:5], s[10:11]
	s_cselect_b32 s13, s35, 0
	s_cselect_b32 s12, s34, 0x100
	s_bfe_u32 s0, ttmp8, 0x50019
	s_add_nc_u64 s[2:3], s[4:5], s[2:3]
	s_and_b32 s0, s0, 3
	s_mov_b32 s8, 1
	s_lshl_b32 s6, s0, 7
	s_lshl_b32 s14, s0, 6
	s_lshl_b32 s0, s0, 15
	s_mul_u64 s[4:5], s[12:13], s[6:7]
	s_add_co_i32 s9, s0, 0
	s_sub_co_i32 s0, s33, s14
	s_add_nc_u64 s[10:11], s[4:5], s[2:3]
	s_max_i32 s3, s0, 0
	s_max_i32 s2, s1, 0
	s_lshr_b32 s0, s3, 16
	s_lshl_b32 s1, s2, 16
	s_lshr_b64 s[2:3], s[2:3], 16
	s_bitset1_b32 s11, 31
	s_or_b32 s3, s0, 0x1000000
	s_and_b32 s6, s13, 0xffff
	s_mov_b32 s4, 64
	s_mov_b32 s0, 0x10000
	s_mov_b32 s5, s12
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
		.amdhsa_next_free_vgpr 790
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
		.amdhsa_inst_pref_size 125
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

	.set kernel_grouped_nt_0.num_vgpr, 790
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
    .vgpr_count:     790
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.target:   amdgcn-amd-amdhsa--gfx1250
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
