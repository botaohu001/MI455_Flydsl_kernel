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
	v_readfirstlane_b32 s36, v0
	s_add_co_i32 s2, s2, 1
	s_and_b32 s3, ttmp6, 15
	s_mul_i32 s2, ttmp9, s2
	s_getreg_b32 s4, hwreg(HW_REG_IB_STS2, 6, 4)
	s_add_co_i32 s5, s3, s2
	s_lshr_b32 s29, s36, 5
	s_mov_b32 s19, 0
	s_wait_kmcnt 0x0
	s_ashr_i32 s3, s22, 31
	s_mov_b32 s2, s22
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_lshl_b64 s[24:25], s[2:3], 1
	s_cmp_eq_u32 s4, 0
	s_cselect_b32 s2, ttmp9, s5
	s_ashr_i32 s3, s2, 31
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_lshr_b32 s3, s3, 23
	s_add_co_i32 s3, s2, s3
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 s12, s3, 0xfffffe00
	s_ashr_i32 s3, s3, 9
	s_cmp_lg_u32 s2, s12
	s_cselect_b32 s4, -1, 0
	s_cmp_lt_i32 s2, 0
	s_cselect_b32 s5, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 s4, s5, s4
	s_sub_co_ci_u32 s35, s3, 0
	s_sub_co_i32 s37, s2, s12
	s_lshl_b32 s3, s35, 4
	s_abs_i32 s2, s37
	s_sub_co_i32 s4, 0x90, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_min_i32 s13, s4, 16
	s_abs_i32 s14, s13
	s_xor_b32 s12, s37, s13
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
	s_load_b32 s1, s[10:11], 0x20
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
	s_sub_co_i32 s38, s0, s12
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s39, s38, s13
	s_sub_co_i32 s0, s37, s39
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_co_i32 s12, s0, s3
	s_wait_kmcnt 0x0
	s_cmp_gt_i32 s1, s12
	s_cselect_b32 s0, 4, 12
	s_cselect_b32 s2, 0, 9
	s_load_b32 s1, s[10:11], s0 offset:0x0 scale_offset
	s_cselect_b32 s3, 8, 16
	s_or_b32 s13, s0, 1
	s_wait_kmcnt 0x0
	s_cmp_gt_i32 s1, s12
	s_cselect_b32 s1, s2, s13
	s_cselect_b32 s0, s0, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s2, s1, s0
	s_lshr_b32 s2, s2, 1
	s_load_b32 s3, s[10:11], s2 offset:0x0 scale_offset
	s_or_b32 s13, s2, 1
	s_wait_kmcnt 0x0
	s_cmp_gt_i32 s3, s12
	s_cselect_b32 s3, s1, s13
	s_cselect_b32 s2, s2, s0
	s_mov_b32 s1, s19
	s_add_co_i32 s0, s3, s2
	s_delay_alu instid0(SALU_CYCLE_1)
	s_lshr_b32 s13, s0, 1
	s_load_b32 s0, s[10:11], s13 offset:0x0 scale_offset
	s_add_co_i32 s14, s13, 1
	s_wait_kmcnt 0x0
	s_cmp_gt_i32 s0, s12
	s_cselect_b32 s0, s3, s14
	s_cselect_b32 s18, s13, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_nc_u64 s[2:3], s[0:1], s[18:19]
	s_lshr_b64 s[2:3], s[2:3], 1
	s_delay_alu instid0(SALU_CYCLE_1)
	s_min_u32 s1, s2, 15
	s_add_co_i32 s2, s2, 1
	s_load_b32 s1, s[10:11], s1 offset:0x0 scale_offset
	s_wait_kmcnt 0x0
	s_cmp_gt_i32 s1, s12
	s_cselect_b32 s0, s0, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_min_u32 s34, s0, 15
	s_add_co_i32 s0, s34, 16
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_ashr_i32 s1, s0, 31
	s_lshl_b64 s[0:1], s[0:1], 2
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_nc_u64 s[0:1], s[10:11], s[0:1]
	s_mov_b64 s[10:11], 0xffffffffffffffc0
	s_load_b64 s[2:3], s[0:1], 0x0
	s_wait_xcnt 0x0
	s_add_nc_u64 s[0:1], s[0:1], s[10:11]
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
	s_cselect_b32 s30, s3, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_ashr_i32 s31, s30, 31
	v_readfirstlane_b32 s33, v1
	s_cmp_eq_u32 s29, 0
	s_mul_u64 s[10:11], s[24:25], s[30:31]
	s_cselect_b32 s40, -1, 0
	s_cmp_lg_u32 s29, 0
	s_cbranch_scc1 .LBB0_2
	s_cmp_lg_u32 s22, -2.0
	s_add_nc_u64 s[2:3], s[6:7], s[10:11]
	s_cselect_b32 s17, s24, 0x100
	s_cselect_b32 s12, s25, 0
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
	s_ashr_i32 s1, s23, 31
	s_mov_b32 s0, s23
	s_delay_alu instid0(SALU_CYCLE_1)
	s_lshl_b64 s[26:27], s[0:1], 1
	s_cmp_lg_u32 s37, s39
	s_cselect_b32 s2, -1, 0
	s_cmp_lt_i32 s37, 0
	s_cselect_b32 s3, -1, 0
	s_cmp_gt_i32 s35, 9
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s3, s3, s12
	s_and_b32 s2, s3, s2
	s_sub_co_ci_u32 s2, s38, 0
	s_ashr_i32 s35, s34, 31
	s_lshl_b32 s2, s2, 8
	s_lshl_b64 s[34:35], s[34:35], 26
	s_sub_co_i32 s12, s21, s2
	s_ashr_i32 s3, s2, 31
	s_cmp_eq_u32 s29, 1
	s_cselect_b32 s37, -1, 0
	s_cmp_lg_u32 s29, 1
	s_cbranch_scc1 .LBB0_4
	s_mul_u64 s[14:15], s[26:27], s[2:3]
	s_add_nc_u64 s[16:17], s[8:9], s[34:35]
	s_cmp_lg_u32 s0, -2.0
	s_add_nc_u64 s[18:19], s[16:17], s[14:15]
	s_cselect_b32 s49, s26, 0x100
	s_cselect_b32 s13, s27, 0
	s_max_i32 s14, s12, 0
	s_movk_i32 s48, 0x100
	s_lshl_b32 s15, s14, 16
	s_lshr_b32 s14, s14, 16
	s_mov_b32 s51, 0
	s_bitset1_b32 s19, 31
	s_add_co_i32 s17, 0, 0x11000
	s_mov_b32 s16, 1
	s_or_b32 s46, s15, 0x7fff
	s_or_b32 s47, s14, 0x1000000
	s_and_b32 s50, s13, 0xffff
	s_mov_b32 s45, 0xffff0000
	s_mov_b32 s44, 0x7700000
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[16:19], s[44:51]
.LBB0_4:
	s_ashr_i32 s13, s20, 31
	s_set_vgpr_msb 0xc0
	v_and_b32_e32 v10 /*v778*/, 15, v0
	s_lshr_b32 s13, s13, 25
	v_bfe_u32 v3 /*v771*/, v0, 4, 1
	s_add_co_i32 s13, s20, s13
	s_wait_tensorcnt 0x0
	s_and_b32 s14, s13, 0xffffff80
	s_ashr_i32 s41, s13, 7
	s_cmp_lg_u32 s20, s14
	s_cselect_b32 s13, -1, 0
	s_cmp_lt_i32 s20, 0
	s_barrier_signal -1
	s_cselect_b32 s15, -1, 0
	s_lshl_b32 s14, s36, 1
	s_lshl_b32 s16, s29, 7
	s_and_b32 s14, s14, 0xffffff80
	s_and_b32 s36, s16, 0x80
	s_set_vgpr_msb 0xc0cc
	v_or_b32_e32 v2 /*v770*/, s14, v10 /*v778*/
	s_set_vgpr_msb 0xcc8c
	v_dual_lshlrev_b32 v7 /*v519*/, 4, v3 /*v771*/ :: v_dual_bitop2_b32 v8 /*v520*/, s36, v10 /*v778*/ bitop3:0x54
	s_and_b32 s13, s15, s13
	s_set_vgpr_msb 0x8cc0
	v_or3_b32 v17 /*v785*/, v0, s14, 0x70
	s_set_vgpr_msb 0xc00c
	v_mul_lo_u32 v1, 0x110, v2 /*v770*/
	s_cmp_lg_u32 s13, 0
	s_set_vgpr_msb 0xcc8
	v_or_b32_e32 v14 /*v782*/, 0x11000, v7 /*v519*/
	s_sub_co_ci_u32 s29, s41, 0
	s_set_vgpr_msb 0xc8a8
	v_mad_u32_u24 v6 /*v518*/, 0x110, v8 /*v520*/, v7 /*v519*/
	s_add_co_i32 s29, s29, -1
	s_mov_b32 s15, -1
	s_cmp_gt_i32 s29, 0
	s_set_vgpr_msb 0xa8c8
	v_add_nc_u32_e32 v13 /*v781*/, v1, v7 /*v519*/
	s_barrier_wait -1
	s_set_vgpr_msb 0xc8cc
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u32_e32 v18 /*v786*/, 64, v13 /*v781*/
	v_add_nc_u32_e32 v16 /*v784*/, 0x80, v13 /*v781*/
	v_add_nc_u32_e32 v15 /*v783*/, 0xc0, v13 /*v781*/
	s_set_vgpr_msb 0xcc00
	s_cbranch_scc1 .LBB0_6
	s_set_vgpr_msb 0x88
	v_or3_b32 v43 /*v555*/, v0, s14, 0x70
	v_or_b32_e32 v5 /*v517*/, 0x11000, v7 /*v519*/
	s_max_i32 s14, s12, 0
	s_set_vgpr_msb 0x888c
	v_dual_add_nc_u32 v4 /*v516*/, 64, v13 /*v781*/ :: v_dual_mov_b32 v42 /*v554*/, s14
	s_set_vgpr_msb 0x8ce8
	v_mad_u32 v11 /*v779*/, 0x110, v43 /*v555*/, v7 /*v519*/
	s_lshl_b32 s15, s14, 16
	v_add_nc_u32_e32 v8 /*v776*/, 0x11040, v6 /*v518*/
	s_set_vgpr_msb 0xe88c
	v_add_nc_u32_e32 v3 /*v515*/, 0x80, v13 /*v781*/
	s_set_vgpr_msb 0x8cc8
	v_add_nc_u32_e32 v6 /*v774*/, 0x11080, v6 /*v518*/
	s_set_vgpr_msb 0xc88c
	v_add_nc_u32_e32 v2 /*v514*/, 0xc0, v13 /*v781*/
	s_set_vgpr_msb 0x8ce8
	v_mad_u32_u24 v12 /*v780*/, 0x110, v8 /*v520*/, v5 /*v517*/
	v_add_nc_u32_e32 v4 /*v772*/, 0x110c0, v6 /*v518*/
	s_set_vgpr_msb 0xe8cc
	v_add_nc_u32_e32 v9 /*v777*/, 64, v11 /*v779*/
	v_add_nc_u32_e32 v7 /*v775*/, 0x80, v11 /*v779*/
	v_add_nc_u32_e32 v5 /*v773*/, 0xc0, v11 /*v779*/
	s_set_vgpr_msb 0xcc00
	v_mov_b32_e32 v1, s15
	s_mov_b32 s15, 0
.LBB0_6:
	v_mov_b32_e32 v17, 0
	s_and_not1_b32 vcc_lo, exec_lo, s15
	s_set_vgpr_msb 64
	s_delay_alu instid0(VALU_DEP_1)
	v_dual_mov_b32 v57 /*v313*/, v17 :: v_dual_mov_b32 v56 /*v312*/, v17
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v16, v17 :: v_dual_mov_b32 v15, v17
	v_dual_mov_b32 v14, v17 :: v_dual_mov_b32 v13, v17
	v_dual_mov_b32 v12, v17 :: v_dual_mov_b32 v11, v17
	v_dual_mov_b32 v10, v17 :: v_dual_mov_b32 v49, v17
	v_dual_mov_b32 v48, v17 :: v_dual_mov_b32 v47, v17
	v_dual_mov_b32 v46, v17 :: v_dual_mov_b32 v45, v17
	v_dual_mov_b32 v44, v17 :: v_dual_mov_b32 v43, v17
	v_dual_mov_b32 v42, v17 :: v_dual_mov_b32 v65, v17
	v_dual_mov_b32 v64, v17 :: v_dual_mov_b32 v63, v17
	v_dual_mov_b32 v62, v17 :: v_dual_mov_b32 v61, v17
	v_dual_mov_b32 v60, v17 :: v_dual_mov_b32 v59, v17
	v_dual_mov_b32 v58, v17 :: v_dual_mov_b32 v89, v17
	v_dual_mov_b32 v88, v17 :: v_dual_mov_b32 v87, v17
	v_dual_mov_b32 v86, v17 :: v_dual_mov_b32 v85, v17
	v_dual_mov_b32 v84, v17 :: v_dual_mov_b32 v83, v17
	v_dual_mov_b32 v82, v17 :: v_dual_mov_b32 v105, v17
	v_dual_mov_b32 v104, v17 :: v_dual_mov_b32 v103, v17
	v_dual_mov_b32 v102, v17 :: v_dual_mov_b32 v101, v17
	v_dual_mov_b32 v100, v17 :: v_dual_mov_b32 v99, v17
	v_dual_mov_b32 v98, v17 :: v_dual_mov_b32 v121, v17
	v_dual_mov_b32 v120, v17 :: v_dual_mov_b32 v119, v17
	v_dual_mov_b32 v118, v17 :: v_dual_mov_b32 v117, v17
	v_dual_mov_b32 v116, v17 :: v_dual_mov_b32 v115, v17
	v_dual_mov_b32 v114, v17 :: v_dual_mov_b32 v137, v17
	v_dual_mov_b32 v136, v17 :: v_dual_mov_b32 v135, v17
	v_dual_mov_b32 v134, v17 :: v_dual_mov_b32 v133, v17
	v_dual_mov_b32 v132, v17 :: v_dual_mov_b32 v131, v17
	v_dual_mov_b32 v130, v17 :: v_dual_mov_b32 v145, v17
	v_dual_mov_b32 v144, v17 :: v_dual_mov_b32 v143, v17
	v_dual_mov_b32 v142, v17 :: v_dual_mov_b32 v141, v17
	v_dual_mov_b32 v140, v17 :: v_dual_mov_b32 v139, v17
	v_dual_mov_b32 v138, v17 :: v_dual_mov_b32 v81, v17
	v_dual_mov_b32 v80, v17 :: v_dual_mov_b32 v79, v17
	v_dual_mov_b32 v78, v17 :: v_dual_mov_b32 v77, v17
	v_dual_mov_b32 v76, v17 :: v_dual_mov_b32 v75, v17
	v_dual_mov_b32 v74, v17 :: v_dual_mov_b32 v129, v17
	v_dual_mov_b32 v128, v17 :: v_dual_mov_b32 v127, v17
	v_dual_mov_b32 v126, v17 :: v_dual_mov_b32 v125, v17
	v_dual_mov_b32 v124, v17 :: v_dual_mov_b32 v123, v17
	v_dual_mov_b32 v122, v17 :: v_dual_mov_b32 v153, v17
	v_dual_mov_b32 v152, v17 :: v_dual_mov_b32 v151, v17
	v_dual_mov_b32 v150, v17 :: v_dual_mov_b32 v149, v17
	v_dual_mov_b32 v148, v17 :: v_dual_mov_b32 v147, v17
	v_dual_mov_b32 v146, v17 :: v_dual_mov_b32 v161, v17
	v_dual_mov_b32 v160, v17 :: v_dual_mov_b32 v159, v17
	v_dual_mov_b32 v158, v17 :: v_dual_mov_b32 v157, v17
	v_dual_mov_b32 v156, v17 :: v_dual_mov_b32 v155, v17
	v_dual_mov_b32 v154, v17 :: v_dual_mov_b32 v169, v17
	v_dual_mov_b32 v168, v17 :: v_dual_mov_b32 v167, v17
	v_dual_mov_b32 v166, v17 :: v_dual_mov_b32 v165, v17
	v_dual_mov_b32 v164, v17 :: v_dual_mov_b32 v163, v17
	v_dual_mov_b32 v162, v17 :: v_dual_mov_b32 v177, v17
	v_dual_mov_b32 v176, v17 :: v_dual_mov_b32 v175, v17
	v_dual_mov_b32 v174, v17 :: v_dual_mov_b32 v173, v17
	v_dual_mov_b32 v172, v17 :: v_dual_mov_b32 v171, v17
	v_dual_mov_b32 v170, v17 :: v_dual_mov_b32 v201, v17
	v_dual_mov_b32 v200, v17 :: v_dual_mov_b32 v199, v17
	v_dual_mov_b32 v198, v17 :: v_dual_mov_b32 v197, v17
	v_dual_mov_b32 v196, v17 :: v_dual_mov_b32 v195, v17
	v_dual_mov_b32 v194, v17 :: v_dual_mov_b32 v241, v17
	v_dual_mov_b32 v240, v17 :: v_dual_mov_b32 v239, v17
	v_dual_mov_b32 v238, v17 :: v_dual_mov_b32 v237, v17
	v_dual_mov_b32 v236, v17 :: v_dual_mov_b32 v235, v17
	v_dual_mov_b32 v234, v17 :: v_dual_mov_b32 v185, v17
	v_dual_mov_b32 v184, v17 :: v_dual_mov_b32 v183, v17
	v_dual_mov_b32 v182, v17 :: v_dual_mov_b32 v181, v17
	v_dual_mov_b32 v180, v17 :: v_dual_mov_b32 v179, v17
	v_dual_mov_b32 v178, v17 :: v_dual_mov_b32 v193, v17
	v_dual_mov_b32 v192, v17 :: v_dual_mov_b32 v191, v17
	v_dual_mov_b32 v190, v17 :: v_dual_mov_b32 v189, v17
	v_dual_mov_b32 v188, v17 :: v_dual_mov_b32 v187, v17
	v_dual_mov_b32 v186, v17 :: v_dual_mov_b32 v209, v17
	v_dual_mov_b32 v208, v17 :: v_dual_mov_b32 v207, v17
	v_dual_mov_b32 v206, v17 :: v_dual_mov_b32 v205, v17
	v_dual_mov_b32 v204, v17 :: v_dual_mov_b32 v203, v17
	v_dual_mov_b32 v202, v17 :: v_dual_mov_b32 v225, v17
	v_dual_mov_b32 v224, v17 :: v_dual_mov_b32 v223, v17
	v_dual_mov_b32 v222, v17 :: v_dual_mov_b32 v221, v17
	v_dual_mov_b32 v220, v17 :: v_dual_mov_b32 v219, v17
	v_dual_mov_b32 v218, v17 :: v_dual_mov_b32 v233, v17
	v_dual_mov_b32 v232, v17 :: v_dual_mov_b32 v231, v17
	v_dual_mov_b32 v230, v17 :: v_dual_mov_b32 v229, v17
	v_dual_mov_b32 v228, v17 :: v_dual_mov_b32 v227, v17
	v_dual_mov_b32 v226, v17 :: v_dual_mov_b32 v249, v17
	v_dual_mov_b32 v248, v17 :: v_dual_mov_b32 v247, v17
	v_dual_mov_b32 v246, v17 :: v_dual_mov_b32 v245, v17
	v_dual_mov_b32 v244, v17 :: v_dual_mov_b32 v243, v17
	v_mov_b32_e32 v242, v17
	s_set_vgpr_msb 64
	v_dual_mov_b32 v9 /*v265*/, v17 :: v_dual_mov_b32 v8 /*v264*/, v17
	v_dual_mov_b32 v7 /*v263*/, v17 :: v_dual_mov_b32 v6 /*v262*/, v17
	v_dual_mov_b32 v5 /*v261*/, v17 :: v_dual_mov_b32 v4 /*v260*/, v17
	v_dual_mov_b32 v3 /*v259*/, v17 :: v_dual_mov_b32 v2 /*v258*/, v17
	v_dual_mov_b32 v17 /*v273*/, v17 :: v_dual_mov_b32 v16 /*v272*/, v17
	v_dual_mov_b32 v15 /*v271*/, v17 :: v_dual_mov_b32 v14 /*v270*/, v17
	v_dual_mov_b32 v13 /*v269*/, v17 :: v_dual_mov_b32 v12 /*v268*/, v17
	v_dual_mov_b32 v11 /*v267*/, v17 :: v_dual_mov_b32 v10 /*v266*/, v17
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v217, v17 :: v_dual_mov_b32 v216, v17
	v_dual_mov_b32 v215, v17 :: v_dual_mov_b32 v214, v17
	v_dual_mov_b32 v213, v17 :: v_dual_mov_b32 v212, v17
	v_dual_mov_b32 v211, v17 :: v_dual_mov_b32 v210, v17
	s_set_vgpr_msb 64
	v_dual_mov_b32 v1 /*v257*/, v17 :: v_dual_mov_b32 v0 /*v256*/, v17
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v255, v17 :: v_dual_mov_b32 v254, v17
	v_dual_mov_b32 v253, v17 :: v_dual_mov_b32 v252, v17
	v_dual_mov_b32 v251, v17 :: v_dual_mov_b32 v250, v17
	v_mov_b32_e32 v9, v17
	s_set_vgpr_msb 64
	v_dual_mov_b32 v25 /*v281*/, v17 :: v_dual_mov_b32 v24 /*v280*/, v17
	v_dual_mov_b32 v23 /*v279*/, v17 :: v_dual_mov_b32 v22 /*v278*/, v17
	v_dual_mov_b32 v21 /*v277*/, v17 :: v_dual_mov_b32 v20 /*v276*/, v17
	v_dual_mov_b32 v19 /*v275*/, v17 :: v_dual_mov_b32 v18 /*v274*/, v17
	v_dual_mov_b32 v33 /*v289*/, v17 :: v_dual_mov_b32 v32 /*v288*/, v17
	v_dual_mov_b32 v31 /*v287*/, v17 :: v_dual_mov_b32 v30 /*v286*/, v17
	v_dual_mov_b32 v29 /*v285*/, v17 :: v_dual_mov_b32 v28 /*v284*/, v17
	v_dual_mov_b32 v27 /*v283*/, v17 :: v_dual_mov_b32 v26 /*v282*/, v17
	v_dual_mov_b32 v41 /*v297*/, v17 :: v_dual_mov_b32 v40 /*v296*/, v17
	v_dual_mov_b32 v39 /*v295*/, v17 :: v_dual_mov_b32 v38 /*v294*/, v17
	v_dual_mov_b32 v37 /*v293*/, v17 :: v_dual_mov_b32 v36 /*v292*/, v17
	v_dual_mov_b32 v35 /*v291*/, v17 :: v_dual_mov_b32 v34 /*v290*/, v17
	v_dual_mov_b32 v49 /*v305*/, v17 :: v_dual_mov_b32 v48 /*v304*/, v17
	v_dual_mov_b32 v47 /*v303*/, v17 :: v_dual_mov_b32 v46 /*v302*/, v17
	v_dual_mov_b32 v45 /*v301*/, v17 :: v_dual_mov_b32 v44 /*v300*/, v17
	v_dual_mov_b32 v43 /*v299*/, v17 :: v_dual_mov_b32 v42 /*v298*/, v17
	v_dual_mov_b32 v81 /*v337*/, v17 :: v_dual_mov_b32 v80 /*v336*/, v17
	v_dual_mov_b32 v79 /*v335*/, v17 :: v_dual_mov_b32 v78 /*v334*/, v17
	v_dual_mov_b32 v77 /*v333*/, v17 :: v_dual_mov_b32 v76 /*v332*/, v17
	v_dual_mov_b32 v75 /*v331*/, v17 :: v_dual_mov_b32 v74 /*v330*/, v17
	v_dual_mov_b32 v105 /*v361*/, v17 :: v_dual_mov_b32 v104 /*v360*/, v17
	v_dual_mov_b32 v103 /*v359*/, v17 :: v_dual_mov_b32 v102 /*v358*/, v17
	v_dual_mov_b32 v101 /*v357*/, v17 :: v_dual_mov_b32 v100 /*v356*/, v17
	v_dual_mov_b32 v99 /*v355*/, v17 :: v_dual_mov_b32 v98 /*v354*/, v17
	v_dual_mov_b32 v55 /*v311*/, v17 :: v_dual_mov_b32 v54 /*v310*/, v17
	v_dual_mov_b32 v53 /*v309*/, v17 :: v_dual_mov_b32 v52 /*v308*/, v17
	v_dual_mov_b32 v51 /*v307*/, v17 :: v_dual_mov_b32 v50 /*v306*/, v17
	v_dual_mov_b32 v65 /*v321*/, v17 :: v_dual_mov_b32 v64 /*v320*/, v17
	v_dual_mov_b32 v63 /*v319*/, v17 :: v_dual_mov_b32 v62 /*v318*/, v17
	v_dual_mov_b32 v61 /*v317*/, v17 :: v_dual_mov_b32 v60 /*v316*/, v17
	v_dual_mov_b32 v59 /*v315*/, v17 :: v_dual_mov_b32 v58 /*v314*/, v17
	v_dual_mov_b32 v73 /*v329*/, v17 :: v_dual_mov_b32 v72 /*v328*/, v17
	v_dual_mov_b32 v71 /*v327*/, v17 :: v_dual_mov_b32 v70 /*v326*/, v17
	v_dual_mov_b32 v69 /*v325*/, v17 :: v_dual_mov_b32 v68 /*v324*/, v17
	v_dual_mov_b32 v67 /*v323*/, v17 :: v_dual_mov_b32 v66 /*v322*/, v17
	v_dual_mov_b32 v97 /*v353*/, v17 :: v_dual_mov_b32 v96 /*v352*/, v17
	v_dual_mov_b32 v95 /*v351*/, v17 :: v_dual_mov_b32 v94 /*v350*/, v17
	v_dual_mov_b32 v93 /*v349*/, v17 :: v_dual_mov_b32 v92 /*v348*/, v17
	v_dual_mov_b32 v91 /*v347*/, v17 :: v_dual_mov_b32 v90 /*v346*/, v17
	v_dual_mov_b32 v113 /*v369*/, v17 :: v_dual_mov_b32 v112 /*v368*/, v17
	v_dual_mov_b32 v111 /*v367*/, v17 :: v_dual_mov_b32 v110 /*v366*/, v17
	v_dual_mov_b32 v109 /*v365*/, v17 :: v_dual_mov_b32 v108 /*v364*/, v17
	v_dual_mov_b32 v107 /*v363*/, v17 :: v_dual_mov_b32 v106 /*v362*/, v17
	v_dual_mov_b32 v121 /*v377*/, v17 :: v_dual_mov_b32 v120 /*v376*/, v17
	v_dual_mov_b32 v119 /*v375*/, v17 :: v_dual_mov_b32 v118 /*v374*/, v17
	v_dual_mov_b32 v117 /*v373*/, v17 :: v_dual_mov_b32 v116 /*v372*/, v17
	v_dual_mov_b32 v115 /*v371*/, v17 :: v_dual_mov_b32 v114 /*v370*/, v17
	v_dual_mov_b32 v137 /*v393*/, v17 :: v_dual_mov_b32 v136 /*v392*/, v17
	v_dual_mov_b32 v135 /*v391*/, v17 :: v_dual_mov_b32 v134 /*v390*/, v17
	v_dual_mov_b32 v133 /*v389*/, v17 :: v_dual_mov_b32 v132 /*v388*/, v17
	v_dual_mov_b32 v131 /*v387*/, v17 :: v_dual_mov_b32 v130 /*v386*/, v17
	v_dual_mov_b32 v145 /*v401*/, v17 :: v_dual_mov_b32 v144 /*v400*/, v17
	v_dual_mov_b32 v143 /*v399*/, v17 :: v_dual_mov_b32 v142 /*v398*/, v17
	v_dual_mov_b32 v141 /*v397*/, v17 :: v_dual_mov_b32 v140 /*v396*/, v17
	v_dual_mov_b32 v139 /*v395*/, v17 :: v_dual_mov_b32 v138 /*v394*/, v17
	v_dual_mov_b32 v89 /*v345*/, v17 :: v_dual_mov_b32 v88 /*v344*/, v17
	v_dual_mov_b32 v87 /*v343*/, v17 :: v_dual_mov_b32 v86 /*v342*/, v17
	v_dual_mov_b32 v85 /*v341*/, v17 :: v_dual_mov_b32 v84 /*v340*/, v17
	v_dual_mov_b32 v83 /*v339*/, v17 :: v_dual_mov_b32 v82 /*v338*/, v17
	v_dual_mov_b32 v129 /*v385*/, v17 :: v_dual_mov_b32 v128 /*v384*/, v17
	v_dual_mov_b32 v127 /*v383*/, v17 :: v_dual_mov_b32 v126 /*v382*/, v17
	v_dual_mov_b32 v125 /*v381*/, v17 :: v_dual_mov_b32 v124 /*v380*/, v17
	v_dual_mov_b32 v123 /*v379*/, v17 :: v_dual_mov_b32 v122 /*v378*/, v17
	v_dual_mov_b32 v153 /*v409*/, v17 :: v_dual_mov_b32 v152 /*v408*/, v17
	v_dual_mov_b32 v151 /*v407*/, v17 :: v_dual_mov_b32 v150 /*v406*/, v17
	v_dual_mov_b32 v149 /*v405*/, v17 :: v_dual_mov_b32 v148 /*v404*/, v17
	v_dual_mov_b32 v147 /*v403*/, v17 :: v_dual_mov_b32 v146 /*v402*/, v17
	v_dual_mov_b32 v161 /*v417*/, v17 :: v_dual_mov_b32 v160 /*v416*/, v17
	v_dual_mov_b32 v159 /*v415*/, v17 :: v_dual_mov_b32 v158 /*v414*/, v17
	v_dual_mov_b32 v157 /*v413*/, v17 :: v_dual_mov_b32 v156 /*v412*/, v17
	v_dual_mov_b32 v155 /*v411*/, v17 :: v_dual_mov_b32 v154 /*v410*/, v17
	v_dual_mov_b32 v169 /*v425*/, v17 :: v_dual_mov_b32 v168 /*v424*/, v17
	v_dual_mov_b32 v167 /*v423*/, v17 :: v_dual_mov_b32 v166 /*v422*/, v17
	v_dual_mov_b32 v165 /*v421*/, v17 :: v_dual_mov_b32 v164 /*v420*/, v17
	v_dual_mov_b32 v163 /*v419*/, v17 :: v_dual_mov_b32 v162 /*v418*/, v17
	v_dual_mov_b32 v177 /*v433*/, v17 :: v_dual_mov_b32 v176 /*v432*/, v17
	v_dual_mov_b32 v175 /*v431*/, v17 :: v_dual_mov_b32 v174 /*v430*/, v17
	v_dual_mov_b32 v173 /*v429*/, v17 :: v_dual_mov_b32 v172 /*v428*/, v17
	v_dual_mov_b32 v171 /*v427*/, v17 :: v_dual_mov_b32 v170 /*v426*/, v17
	v_dual_mov_b32 v201 /*v457*/, v17 :: v_dual_mov_b32 v200 /*v456*/, v17
	v_dual_mov_b32 v199 /*v455*/, v17 :: v_dual_mov_b32 v198 /*v454*/, v17
	v_dual_mov_b32 v197 /*v453*/, v17 :: v_dual_mov_b32 v196 /*v452*/, v17
	v_dual_mov_b32 v195 /*v451*/, v17 :: v_dual_mov_b32 v194 /*v450*/, v17
	v_dual_mov_b32 v233 /*v489*/, v17 :: v_dual_mov_b32 v232 /*v488*/, v17
	v_dual_mov_b32 v231 /*v487*/, v17 :: v_dual_mov_b32 v230 /*v486*/, v17
	v_dual_mov_b32 v229 /*v485*/, v17 :: v_dual_mov_b32 v228 /*v484*/, v17
	v_dual_mov_b32 v227 /*v483*/, v17 :: v_dual_mov_b32 v226 /*v482*/, v17
	v_dual_mov_b32 v185 /*v441*/, v17 :: v_dual_mov_b32 v184 /*v440*/, v17
	v_dual_mov_b32 v183 /*v439*/, v17 :: v_dual_mov_b32 v182 /*v438*/, v17
	v_dual_mov_b32 v181 /*v437*/, v17 :: v_dual_mov_b32 v180 /*v436*/, v17
	v_dual_mov_b32 v179 /*v435*/, v17 :: v_dual_mov_b32 v178 /*v434*/, v17
	v_dual_mov_b32 v193 /*v449*/, v17 :: v_dual_mov_b32 v192 /*v448*/, v17
	v_dual_mov_b32 v191 /*v447*/, v17 :: v_dual_mov_b32 v190 /*v446*/, v17
	v_dual_mov_b32 v189 /*v445*/, v17 :: v_dual_mov_b32 v188 /*v444*/, v17
	v_dual_mov_b32 v187 /*v443*/, v17 :: v_dual_mov_b32 v186 /*v442*/, v17
	v_dual_mov_b32 v209 /*v465*/, v17 :: v_dual_mov_b32 v208 /*v464*/, v17
	v_dual_mov_b32 v207 /*v463*/, v17 :: v_dual_mov_b32 v206 /*v462*/, v17
	v_dual_mov_b32 v205 /*v461*/, v17 :: v_dual_mov_b32 v204 /*v460*/, v17
	v_dual_mov_b32 v203 /*v459*/, v17 :: v_dual_mov_b32 v202 /*v458*/, v17
	v_dual_mov_b32 v217 /*v473*/, v17 :: v_dual_mov_b32 v216 /*v472*/, v17
	v_dual_mov_b32 v215 /*v471*/, v17 :: v_dual_mov_b32 v214 /*v470*/, v17
	v_dual_mov_b32 v213 /*v469*/, v17 :: v_dual_mov_b32 v212 /*v468*/, v17
	v_dual_mov_b32 v211 /*v467*/, v17 :: v_dual_mov_b32 v210 /*v466*/, v17
	v_dual_mov_b32 v225 /*v481*/, v17 :: v_dual_mov_b32 v224 /*v480*/, v17
	v_dual_mov_b32 v223 /*v479*/, v17 :: v_dual_mov_b32 v222 /*v478*/, v17
	v_dual_mov_b32 v221 /*v477*/, v17 :: v_dual_mov_b32 v220 /*v476*/, v17
	v_dual_mov_b32 v219 /*v475*/, v17 :: v_dual_mov_b32 v218 /*v474*/, v17
	v_dual_mov_b32 v241 /*v497*/, v17 :: v_dual_mov_b32 v240 /*v496*/, v17
	v_dual_mov_b32 v239 /*v495*/, v17 :: v_dual_mov_b32 v238 /*v494*/, v17
	v_dual_mov_b32 v237 /*v493*/, v17 :: v_dual_mov_b32 v236 /*v492*/, v17
	v_dual_mov_b32 v235 /*v491*/, v17 :: v_dual_mov_b32 v234 /*v490*/, v17
	v_dual_mov_b32 v249 /*v505*/, v17 :: v_dual_mov_b32 v248 /*v504*/, v17
	v_dual_mov_b32 v247 /*v503*/, v17 :: v_dual_mov_b32 v246 /*v502*/, v17
	v_dual_mov_b32 v245 /*v501*/, v17 :: v_dual_mov_b32 v244 /*v500*/, v17
	v_dual_mov_b32 v243 /*v499*/, v17 :: v_dual_mov_b32 v242 /*v498*/, v17
	s_set_vgpr_msb 0x4080
	v_dual_mov_b32 v1 /*v513*/, v17 :: v_dual_mov_b32 v0 /*v512*/, v17
	s_set_vgpr_msb 0x8040
	v_dual_mov_b32 v255 /*v511*/, v17 :: v_dual_mov_b32 v254 /*v510*/, v17
	v_dual_mov_b32 v253 /*v509*/, v17 :: v_dual_mov_b32 v252 /*v508*/, v17
	v_dual_mov_b32 v251 /*v507*/, v17 :: v_dual_mov_b32 v250 /*v506*/, v17
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v8, v17 :: v_dual_mov_b32 v7, v17
	v_dual_mov_b32 v6, v17 :: v_dual_mov_b32 v5, v17
	v_dual_mov_b32 v4, v17 :: v_dual_mov_b32 v3, v17
	v_dual_mov_b32 v2, v17 :: v_dual_mov_b32 v25, v17
	v_dual_mov_b32 v24, v17 :: v_dual_mov_b32 v23, v17
	v_dual_mov_b32 v22, v17 :: v_dual_mov_b32 v21, v17
	v_dual_mov_b32 v20, v17 :: v_dual_mov_b32 v19, v17
	v_dual_mov_b32 v18, v17 :: v_dual_mov_b32 v33, v17
	v_dual_mov_b32 v32, v17 :: v_dual_mov_b32 v31, v17
	v_dual_mov_b32 v30, v17 :: v_dual_mov_b32 v29, v17
	v_dual_mov_b32 v28, v17 :: v_dual_mov_b32 v27, v17
	v_dual_mov_b32 v26, v17 :: v_dual_mov_b32 v41, v17
	v_dual_mov_b32 v40, v17 :: v_dual_mov_b32 v39, v17
	v_dual_mov_b32 v38, v17 :: v_dual_mov_b32 v37, v17
	v_dual_mov_b32 v36, v17 :: v_dual_mov_b32 v35, v17
	v_dual_mov_b32 v34, v17 :: v_dual_mov_b32 v57, v17
	v_dual_mov_b32 v56, v17 :: v_dual_mov_b32 v55, v17
	v_dual_mov_b32 v54, v17 :: v_dual_mov_b32 v53, v17
	v_dual_mov_b32 v52, v17 :: v_dual_mov_b32 v51, v17
	v_dual_mov_b32 v50, v17 :: v_dual_mov_b32 v73, v17
	v_dual_mov_b32 v72, v17 :: v_dual_mov_b32 v71, v17
	v_dual_mov_b32 v70, v17 :: v_dual_mov_b32 v69, v17
	v_dual_mov_b32 v68, v17 :: v_dual_mov_b32 v67, v17
	v_dual_mov_b32 v66, v17 :: v_dual_mov_b32 v97, v17
	v_dual_mov_b32 v96, v17 :: v_dual_mov_b32 v95, v17
	v_dual_mov_b32 v94, v17 :: v_dual_mov_b32 v93, v17
	v_dual_mov_b32 v92, v17 :: v_dual_mov_b32 v91, v17
	v_dual_mov_b32 v90, v17 :: v_dual_mov_b32 v113, v17
	v_dual_mov_b32 v112, v17 :: v_dual_mov_b32 v111, v17
	v_dual_mov_b32 v110, v17 :: v_dual_mov_b32 v109, v17
	v_dual_mov_b32 v108, v17 :: v_dual_mov_b32 v107, v17
	v_mov_b32_e32 v106, v17
	s_cbranch_vccnz .LBB0_14
	s_cmp_lg_u32 s22, -2.0
	v_cndmask_b32_e64 v1, 0, -1, s13
	s_cselect_b32 s17, s24, 0x100
	s_cselect_b32 s13, s25, 0
	s_max_i32 s14, s33, 0
	s_set_vgpr_msb 0xec
	v_mad_u32 v11 /*v779*/, 0x110, v17 /*v785*/, v7 /*v519*/
	s_lshl_b32 s15, s14, 16
	s_lshr_b32 s18, s14, 16
	s_or_b32 s14, s15, 0x7fff
	s_or_b32 s15, s18, 0x1000000
	s_and_b32 s18, s13, 0xffff
	s_cmp_lg_u32 s0, -2.0
	s_mul_u64 s[0:1], s[0:1], s[2:3]
	s_cselect_b32 s42, s26, 0x100
	s_cselect_b32 s20, s27, 0
	s_lshl_b64 s[0:1], s[0:1], 1
	s_set_vgpr_msb 0xec00
	v_or3_b32 v0, v0, s36, 0x70
	v_dual_mov_b32 v10, 0 :: v_dual_add_nc_u32 v1, s41, v1
	v_cndmask_b32_e64 v2, 0, 1, s40
	s_add_nc_u64 s[0:1], s[8:9], s[0:1]
	s_max_i32 s38, s12, 0
	s_add_nc_u64 s[0:1], s[0:1], s[34:35]
	s_mov_b32 s19, 0
	s_lshr_b32 s21, s38, 16
	s_set_vgpr_msb 0xf8
	v_mad_u32_u24 v12 /*v780*/, 0x110, v8 /*v520*/, v14 /*v782*/
	v_add_nc_u32_e32 v8 /*v776*/, 0x11040, v6 /*v518*/
	s_lshl_b32 s39, s38, 16
	s_movk_i32 s16, 0x100
	s_set_vgpr_msb 0xf830
	v_mad_u32_u24 v0, 0x110, v0, v14 /*v782*/
	s_set_vgpr_msb 0x30cc
	v_add_nc_u32_e32 v9 /*v777*/, 64, v11 /*v779*/
	v_add_nc_u32_e32 v7 /*v775*/, 0x80, v11 /*v779*/
	s_set_vgpr_msb 0xccc8
	v_add_nc_u32_e32 v6 /*v774*/, 0x11080, v6 /*v518*/
	s_set_vgpr_msb 0xc8cc
	v_add_nc_u32_e32 v5 /*v773*/, 0xc0, v11 /*v779*/
	s_set_vgpr_msb 0xccc8
	v_add_nc_u32_e32 v4 /*v772*/, 0x110c0, v6 /*v518*/
	s_add_nc_u64 s[34:35], s[0:1], 0x100
	v_cmp_ne_u32_e64 s0, v2, 1
	s_set_vgpr_msb 0xc800
	v_dual_mov_b32 v11, v10 :: v_dual_mov_b32 v12, v10
	v_dual_mov_b32 v13, v10 :: v_dual_mov_b32 v14, v10
	v_dual_mov_b32 v15, v10 :: v_dual_mov_b32 v16, v10
	v_dual_mov_b32 v17, v10 :: v_dual_mov_b32 v42, v10
	v_dual_mov_b32 v43, v10 :: v_dual_mov_b32 v44, v10
	v_dual_mov_b32 v45, v10 :: v_dual_mov_b32 v46, v10
	v_dual_mov_b32 v47, v10 :: v_dual_mov_b32 v48, v10
	v_dual_mov_b32 v49, v10 :: v_dual_mov_b32 v58, v10
	v_dual_mov_b32 v59, v10 :: v_dual_mov_b32 v60, v10
	v_dual_mov_b32 v61, v10 :: v_dual_mov_b32 v62, v10
	v_dual_mov_b32 v63, v10 :: v_dual_mov_b32 v64, v10
	v_dual_mov_b32 v65, v10 :: v_dual_mov_b32 v82, v10
	v_dual_mov_b32 v83, v10 :: v_dual_mov_b32 v84, v10
	v_dual_mov_b32 v85, v10 :: v_dual_mov_b32 v86, v10
	v_dual_mov_b32 v87, v10 :: v_dual_mov_b32 v88, v10
	v_dual_mov_b32 v89, v10 :: v_dual_mov_b32 v98, v10
	v_dual_mov_b32 v99, v10 :: v_dual_mov_b32 v100, v10
	v_dual_mov_b32 v101, v10 :: v_dual_mov_b32 v102, v10
	v_dual_mov_b32 v103, v10 :: v_dual_mov_b32 v104, v10
	v_dual_mov_b32 v105, v10 :: v_dual_mov_b32 v114, v10
	v_dual_mov_b32 v115, v10 :: v_dual_mov_b32 v116, v10
	v_dual_mov_b32 v117, v10 :: v_dual_mov_b32 v118, v10
	v_dual_mov_b32 v119, v10 :: v_dual_mov_b32 v120, v10
	v_dual_mov_b32 v121, v10 :: v_dual_mov_b32 v130, v10
	v_dual_mov_b32 v131, v10 :: v_dual_mov_b32 v132, v10
	v_dual_mov_b32 v133, v10 :: v_dual_mov_b32 v134, v10
	v_dual_mov_b32 v135, v10 :: v_dual_mov_b32 v136, v10
	v_dual_mov_b32 v137, v10 :: v_dual_mov_b32 v138, v10
	v_dual_mov_b32 v139, v10 :: v_dual_mov_b32 v140, v10
	v_dual_mov_b32 v141, v10 :: v_dual_mov_b32 v142, v10
	v_dual_mov_b32 v143, v10 :: v_dual_mov_b32 v144, v10
	v_dual_mov_b32 v145, v10 :: v_dual_mov_b32 v74, v10
	v_dual_mov_b32 v75, v10 :: v_dual_mov_b32 v76, v10
	v_dual_mov_b32 v77, v10 :: v_dual_mov_b32 v78, v10
	v_dual_mov_b32 v79, v10 :: v_dual_mov_b32 v80, v10
	v_dual_mov_b32 v81, v10 :: v_dual_mov_b32 v122, v10
	v_dual_mov_b32 v123, v10 :: v_dual_mov_b32 v124, v10
	v_dual_mov_b32 v125, v10 :: v_dual_mov_b32 v126, v10
	v_dual_mov_b32 v127, v10 :: v_dual_mov_b32 v128, v10
	v_dual_mov_b32 v129, v10 :: v_dual_mov_b32 v146, v10
	v_dual_mov_b32 v147, v10 :: v_dual_mov_b32 v148, v10
	v_dual_mov_b32 v149, v10 :: v_dual_mov_b32 v150, v10
	v_dual_mov_b32 v151, v10 :: v_dual_mov_b32 v152, v10
	v_dual_mov_b32 v153, v10 :: v_dual_mov_b32 v154, v10
	v_dual_mov_b32 v155, v10 :: v_dual_mov_b32 v156, v10
	v_dual_mov_b32 v157, v10 :: v_dual_mov_b32 v158, v10
	v_dual_mov_b32 v159, v10 :: v_dual_mov_b32 v160, v10
	v_dual_mov_b32 v161, v10 :: v_dual_mov_b32 v162, v10
	v_dual_mov_b32 v163, v10 :: v_dual_mov_b32 v164, v10
	v_dual_mov_b32 v165, v10 :: v_dual_mov_b32 v166, v10
	v_dual_mov_b32 v167, v10 :: v_dual_mov_b32 v168, v10
	v_dual_mov_b32 v169, v10 :: v_dual_mov_b32 v170, v10
	v_dual_mov_b32 v171, v10 :: v_dual_mov_b32 v172, v10
	v_dual_mov_b32 v173, v10 :: v_dual_mov_b32 v174, v10
	v_dual_mov_b32 v175, v10 :: v_dual_mov_b32 v176, v10
	v_dual_mov_b32 v177, v10 :: v_dual_mov_b32 v194, v10
	v_dual_mov_b32 v195, v10 :: v_dual_mov_b32 v196, v10
	v_dual_mov_b32 v197, v10 :: v_dual_mov_b32 v198, v10
	v_dual_mov_b32 v199, v10 :: v_dual_mov_b32 v200, v10
	v_dual_mov_b32 v201, v10 :: v_dual_mov_b32 v234, v10
	v_dual_mov_b32 v235, v10 :: v_dual_mov_b32 v236, v10
	v_dual_mov_b32 v237, v10 :: v_dual_mov_b32 v238, v10
	v_dual_mov_b32 v239, v10 :: v_dual_mov_b32 v240, v10
	v_dual_mov_b32 v241, v10 :: v_dual_mov_b32 v178, v10
	v_dual_mov_b32 v179, v10 :: v_dual_mov_b32 v180, v10
	v_dual_mov_b32 v181, v10 :: v_dual_mov_b32 v182, v10
	v_dual_mov_b32 v183, v10 :: v_dual_mov_b32 v184, v10
	v_dual_mov_b32 v185, v10 :: v_dual_mov_b32 v186, v10
	v_dual_mov_b32 v187, v10 :: v_dual_mov_b32 v188, v10
	v_dual_mov_b32 v189, v10 :: v_dual_mov_b32 v190, v10
	v_dual_mov_b32 v191, v10 :: v_dual_mov_b32 v192, v10
	v_dual_mov_b32 v193, v10 :: v_dual_mov_b32 v202, v10
	v_dual_mov_b32 v203, v10 :: v_dual_mov_b32 v204, v10
	v_dual_mov_b32 v205, v10 :: v_dual_mov_b32 v206, v10
	v_dual_mov_b32 v207, v10 :: v_dual_mov_b32 v208, v10
	v_dual_mov_b32 v209, v10 :: v_dual_mov_b32 v218, v10
	v_dual_mov_b32 v219, v10 :: v_dual_mov_b32 v220, v10
	v_dual_mov_b32 v221, v10 :: v_dual_mov_b32 v222, v10
	v_dual_mov_b32 v223, v10 :: v_dual_mov_b32 v224, v10
	v_dual_mov_b32 v225, v10 :: v_dual_mov_b32 v226, v10
	v_dual_mov_b32 v227, v10 :: v_dual_mov_b32 v228, v10
	v_dual_mov_b32 v229, v10 :: v_dual_mov_b32 v230, v10
	v_dual_mov_b32 v231, v10 :: v_dual_mov_b32 v232, v10
	v_dual_mov_b32 v233, v10 :: v_dual_mov_b32 v242, v10
	v_dual_mov_b32 v243, v10 :: v_dual_mov_b32 v244, v10
	v_dual_mov_b32 v245, v10 :: v_dual_mov_b32 v246, v10
	v_dual_mov_b32 v247, v10 :: v_dual_mov_b32 v248, v10
	v_mov_b32_e32 v249, v10
	s_set_vgpr_msb 64
	v_dual_mov_b32 v2 /*v258*/, v10 :: v_dual_mov_b32 v3 /*v259*/, v10
	v_dual_mov_b32 v4 /*v260*/, v10 :: v_dual_mov_b32 v5 /*v261*/, v10
	v_dual_mov_b32 v6 /*v262*/, v10 :: v_dual_mov_b32 v7 /*v263*/, v10
	v_dual_mov_b32 v8 /*v264*/, v10 :: v_dual_mov_b32 v9 /*v265*/, v10
	v_dual_mov_b32 v10 /*v266*/, v10 :: v_dual_mov_b32 v11 /*v267*/, v10
	v_dual_mov_b32 v12 /*v268*/, v10 :: v_dual_mov_b32 v13 /*v269*/, v10
	v_dual_mov_b32 v14 /*v270*/, v10 :: v_dual_mov_b32 v15 /*v271*/, v10
	v_dual_mov_b32 v16 /*v272*/, v10 :: v_dual_mov_b32 v17 /*v273*/, v10
	s_set_vgpr_msb 0x4000
	v_dual_mov_b32 v210, v10 :: v_dual_mov_b32 v211, v10
	v_dual_mov_b32 v212, v10 :: v_dual_mov_b32 v213, v10
	v_dual_mov_b32 v214, v10 :: v_dual_mov_b32 v215, v10
	v_dual_mov_b32 v216, v10 :: v_dual_mov_b32 v217, v10
	v_dual_mov_b32 v250, v10 :: v_dual_mov_b32 v251, v10
	v_dual_mov_b32 v252, v10 :: v_dual_mov_b32 v253, v10
	v_dual_mov_b32 v254, v10 :: v_dual_mov_b32 v255, v10
	v_mov_b32_e32 v2, v10
	s_set_vgpr_msb 64
	v_dual_mov_b32 v0 /*v256*/, v10 :: v_dual_mov_b32 v1 /*v257*/, v10
	v_dual_mov_b32 v18 /*v274*/, v10 :: v_dual_mov_b32 v19 /*v275*/, v10
	v_dual_mov_b32 v20 /*v276*/, v10 :: v_dual_mov_b32 v21 /*v277*/, v10
	v_dual_mov_b32 v22 /*v278*/, v10 :: v_dual_mov_b32 v23 /*v279*/, v10
	v_dual_mov_b32 v24 /*v280*/, v10 :: v_dual_mov_b32 v25 /*v281*/, v10
	v_dual_mov_b32 v26 /*v282*/, v10 :: v_dual_mov_b32 v27 /*v283*/, v10
	v_dual_mov_b32 v28 /*v284*/, v10 :: v_dual_mov_b32 v29 /*v285*/, v10
	v_dual_mov_b32 v30 /*v286*/, v10 :: v_dual_mov_b32 v31 /*v287*/, v10
	v_dual_mov_b32 v32 /*v288*/, v10 :: v_dual_mov_b32 v33 /*v289*/, v10
	v_dual_mov_b32 v34 /*v290*/, v10 :: v_dual_mov_b32 v35 /*v291*/, v10
	v_dual_mov_b32 v36 /*v292*/, v10 :: v_dual_mov_b32 v37 /*v293*/, v10
	v_dual_mov_b32 v38 /*v294*/, v10 :: v_dual_mov_b32 v39 /*v295*/, v10
	v_dual_mov_b32 v40 /*v296*/, v10 :: v_dual_mov_b32 v41 /*v297*/, v10
	v_dual_mov_b32 v42 /*v298*/, v10 :: v_dual_mov_b32 v43 /*v299*/, v10
	v_dual_mov_b32 v44 /*v300*/, v10 :: v_dual_mov_b32 v45 /*v301*/, v10
	v_dual_mov_b32 v46 /*v302*/, v10 :: v_dual_mov_b32 v47 /*v303*/, v10
	v_dual_mov_b32 v104 /*v360*/, v10 :: v_dual_mov_b32 v103 /*v359*/, v10
	v_dual_mov_b32 v102 /*v358*/, v10 :: v_dual_mov_b32 v101 /*v357*/, v10
	v_dual_mov_b32 v100 /*v356*/, v10 :: v_dual_mov_b32 v99 /*v355*/, v10
	v_dual_mov_b32 v98 /*v354*/, v10 :: v_dual_mov_b32 v81 /*v337*/, v10
	v_dual_mov_b32 v80 /*v336*/, v10 :: v_dual_mov_b32 v79 /*v335*/, v10
	v_dual_mov_b32 v78 /*v334*/, v10 :: v_dual_mov_b32 v77 /*v333*/, v10
	v_dual_mov_b32 v76 /*v332*/, v10 :: v_dual_mov_b32 v75 /*v331*/, v10
	v_dual_mov_b32 v74 /*v330*/, v10 :: v_dual_mov_b32 v49 /*v305*/, v10
	v_dual_mov_b32 v48 /*v304*/, v10 :: v_dual_mov_b32 v105 /*v361*/, v10
	v_dual_mov_b32 v50 /*v306*/, v10 :: v_dual_mov_b32 v51 /*v307*/, v10
	v_dual_mov_b32 v52 /*v308*/, v10 :: v_dual_mov_b32 v53 /*v309*/, v10
	v_dual_mov_b32 v54 /*v310*/, v10 :: v_dual_mov_b32 v55 /*v311*/, v10
	v_dual_mov_b32 v56 /*v312*/, v10 :: v_dual_mov_b32 v57 /*v313*/, v10
	v_dual_mov_b32 v58 /*v314*/, v10 :: v_dual_mov_b32 v59 /*v315*/, v10
	v_dual_mov_b32 v60 /*v316*/, v10 :: v_dual_mov_b32 v61 /*v317*/, v10
	v_dual_mov_b32 v62 /*v318*/, v10 :: v_dual_mov_b32 v63 /*v319*/, v10
	v_dual_mov_b32 v64 /*v320*/, v10 :: v_dual_mov_b32 v65 /*v321*/, v10
	v_dual_mov_b32 v66 /*v322*/, v10 :: v_dual_mov_b32 v67 /*v323*/, v10
	v_dual_mov_b32 v68 /*v324*/, v10 :: v_dual_mov_b32 v69 /*v325*/, v10
	v_dual_mov_b32 v70 /*v326*/, v10 :: v_dual_mov_b32 v71 /*v327*/, v10
	v_dual_mov_b32 v72 /*v328*/, v10 :: v_dual_mov_b32 v73 /*v329*/, v10
	v_dual_mov_b32 v90 /*v346*/, v10 :: v_dual_mov_b32 v91 /*v347*/, v10
	v_dual_mov_b32 v92 /*v348*/, v10 :: v_dual_mov_b32 v93 /*v349*/, v10
	v_dual_mov_b32 v94 /*v350*/, v10 :: v_dual_mov_b32 v95 /*v351*/, v10
	v_dual_mov_b32 v96 /*v352*/, v10 :: v_dual_mov_b32 v97 /*v353*/, v10
	v_dual_mov_b32 v106 /*v362*/, v10 :: v_dual_mov_b32 v107 /*v363*/, v10
	v_dual_mov_b32 v108 /*v364*/, v10 :: v_dual_mov_b32 v109 /*v365*/, v10
	v_dual_mov_b32 v110 /*v366*/, v10 :: v_dual_mov_b32 v111 /*v367*/, v10
	v_dual_mov_b32 v112 /*v368*/, v10 :: v_dual_mov_b32 v113 /*v369*/, v10
	v_dual_mov_b32 v114 /*v370*/, v10 :: v_dual_mov_b32 v115 /*v371*/, v10
	v_dual_mov_b32 v116 /*v372*/, v10 :: v_dual_mov_b32 v117 /*v373*/, v10
	v_dual_mov_b32 v118 /*v374*/, v10 :: v_dual_mov_b32 v119 /*v375*/, v10
	v_dual_mov_b32 v120 /*v376*/, v10 :: v_dual_mov_b32 v121 /*v377*/, v10
	v_dual_mov_b32 v130 /*v386*/, v10 :: v_dual_mov_b32 v131 /*v387*/, v10
	v_dual_mov_b32 v132 /*v388*/, v10 :: v_dual_mov_b32 v133 /*v389*/, v10
	v_dual_mov_b32 v134 /*v390*/, v10 :: v_dual_mov_b32 v135 /*v391*/, v10
	v_dual_mov_b32 v136 /*v392*/, v10 :: v_dual_mov_b32 v137 /*v393*/, v10
	v_dual_mov_b32 v138 /*v394*/, v10 :: v_dual_mov_b32 v139 /*v395*/, v10
	v_dual_mov_b32 v140 /*v396*/, v10 :: v_dual_mov_b32 v141 /*v397*/, v10
	v_dual_mov_b32 v142 /*v398*/, v10 :: v_dual_mov_b32 v143 /*v399*/, v10
	v_dual_mov_b32 v144 /*v400*/, v10 :: v_dual_mov_b32 v145 /*v401*/, v10
	v_dual_mov_b32 v82 /*v338*/, v10 :: v_dual_mov_b32 v83 /*v339*/, v10
	v_dual_mov_b32 v84 /*v340*/, v10 :: v_dual_mov_b32 v85 /*v341*/, v10
	v_dual_mov_b32 v86 /*v342*/, v10 :: v_dual_mov_b32 v87 /*v343*/, v10
	v_dual_mov_b32 v88 /*v344*/, v10 :: v_dual_mov_b32 v89 /*v345*/, v10
	v_dual_mov_b32 v122 /*v378*/, v10 :: v_dual_mov_b32 v123 /*v379*/, v10
	v_dual_mov_b32 v124 /*v380*/, v10 :: v_dual_mov_b32 v125 /*v381*/, v10
	v_dual_mov_b32 v126 /*v382*/, v10 :: v_dual_mov_b32 v127 /*v383*/, v10
	v_dual_mov_b32 v128 /*v384*/, v10 :: v_dual_mov_b32 v129 /*v385*/, v10
	v_dual_mov_b32 v146 /*v402*/, v10 :: v_dual_mov_b32 v147 /*v403*/, v10
	v_dual_mov_b32 v148 /*v404*/, v10 :: v_dual_mov_b32 v149 /*v405*/, v10
	v_dual_mov_b32 v150 /*v406*/, v10 :: v_dual_mov_b32 v151 /*v407*/, v10
	v_dual_mov_b32 v152 /*v408*/, v10 :: v_dual_mov_b32 v153 /*v409*/, v10
	v_dual_mov_b32 v154 /*v410*/, v10 :: v_dual_mov_b32 v155 /*v411*/, v10
	v_dual_mov_b32 v156 /*v412*/, v10 :: v_dual_mov_b32 v157 /*v413*/, v10
	v_dual_mov_b32 v158 /*v414*/, v10 :: v_dual_mov_b32 v159 /*v415*/, v10
	v_dual_mov_b32 v160 /*v416*/, v10 :: v_dual_mov_b32 v161 /*v417*/, v10
	v_dual_mov_b32 v162 /*v418*/, v10 :: v_dual_mov_b32 v163 /*v419*/, v10
	v_dual_mov_b32 v164 /*v420*/, v10 :: v_dual_mov_b32 v165 /*v421*/, v10
	v_dual_mov_b32 v166 /*v422*/, v10 :: v_dual_mov_b32 v167 /*v423*/, v10
	v_dual_mov_b32 v168 /*v424*/, v10 :: v_dual_mov_b32 v169 /*v425*/, v10
	v_dual_mov_b32 v170 /*v426*/, v10 :: v_dual_mov_b32 v171 /*v427*/, v10
	v_dual_mov_b32 v172 /*v428*/, v10 :: v_dual_mov_b32 v173 /*v429*/, v10
	v_dual_mov_b32 v174 /*v430*/, v10 :: v_dual_mov_b32 v175 /*v431*/, v10
	v_dual_mov_b32 v176 /*v432*/, v10 :: v_dual_mov_b32 v177 /*v433*/, v10
	v_dual_mov_b32 v194 /*v450*/, v10 :: v_dual_mov_b32 v195 /*v451*/, v10
	v_dual_mov_b32 v196 /*v452*/, v10 :: v_dual_mov_b32 v197 /*v453*/, v10
	v_dual_mov_b32 v198 /*v454*/, v10 :: v_dual_mov_b32 v199 /*v455*/, v10
	v_dual_mov_b32 v200 /*v456*/, v10 :: v_dual_mov_b32 v201 /*v457*/, v10
	v_dual_mov_b32 v226 /*v482*/, v10 :: v_dual_mov_b32 v227 /*v483*/, v10
	v_dual_mov_b32 v228 /*v484*/, v10 :: v_dual_mov_b32 v229 /*v485*/, v10
	v_dual_mov_b32 v230 /*v486*/, v10 :: v_dual_mov_b32 v231 /*v487*/, v10
	v_dual_mov_b32 v232 /*v488*/, v10 :: v_dual_mov_b32 v233 /*v489*/, v10
	v_dual_mov_b32 v178 /*v434*/, v10 :: v_dual_mov_b32 v179 /*v435*/, v10
	v_dual_mov_b32 v180 /*v436*/, v10 :: v_dual_mov_b32 v181 /*v437*/, v10
	v_dual_mov_b32 v182 /*v438*/, v10 :: v_dual_mov_b32 v183 /*v439*/, v10
	v_dual_mov_b32 v184 /*v440*/, v10 :: v_dual_mov_b32 v185 /*v441*/, v10
	v_dual_mov_b32 v186 /*v442*/, v10 :: v_dual_mov_b32 v187 /*v443*/, v10
	v_dual_mov_b32 v188 /*v444*/, v10 :: v_dual_mov_b32 v189 /*v445*/, v10
	v_dual_mov_b32 v190 /*v446*/, v10 :: v_dual_mov_b32 v191 /*v447*/, v10
	v_dual_mov_b32 v192 /*v448*/, v10 :: v_dual_mov_b32 v193 /*v449*/, v10
	v_dual_mov_b32 v202 /*v458*/, v10 :: v_dual_mov_b32 v203 /*v459*/, v10
	v_dual_mov_b32 v204 /*v460*/, v10 :: v_dual_mov_b32 v205 /*v461*/, v10
	v_dual_mov_b32 v206 /*v462*/, v10 :: v_dual_mov_b32 v207 /*v463*/, v10
	v_dual_mov_b32 v208 /*v464*/, v10 :: v_dual_mov_b32 v209 /*v465*/, v10
	v_dual_mov_b32 v210 /*v466*/, v10 :: v_dual_mov_b32 v211 /*v467*/, v10
	v_dual_mov_b32 v212 /*v468*/, v10 :: v_dual_mov_b32 v213 /*v469*/, v10
	v_dual_mov_b32 v214 /*v470*/, v10 :: v_dual_mov_b32 v215 /*v471*/, v10
	v_dual_mov_b32 v216 /*v472*/, v10 :: v_dual_mov_b32 v217 /*v473*/, v10
	v_dual_mov_b32 v218 /*v474*/, v10 :: v_dual_mov_b32 v219 /*v475*/, v10
	v_dual_mov_b32 v220 /*v476*/, v10 :: v_dual_mov_b32 v221 /*v477*/, v10
	v_dual_mov_b32 v222 /*v478*/, v10 :: v_dual_mov_b32 v223 /*v479*/, v10
	v_dual_mov_b32 v224 /*v480*/, v10 :: v_dual_mov_b32 v225 /*v481*/, v10
	v_dual_mov_b32 v234 /*v490*/, v10 :: v_dual_mov_b32 v235 /*v491*/, v10
	v_dual_mov_b32 v236 /*v492*/, v10 :: v_dual_mov_b32 v237 /*v493*/, v10
	v_dual_mov_b32 v238 /*v494*/, v10 :: v_dual_mov_b32 v239 /*v495*/, v10
	v_dual_mov_b32 v240 /*v496*/, v10 :: v_dual_mov_b32 v241 /*v497*/, v10
	v_dual_mov_b32 v242 /*v498*/, v10 :: v_dual_mov_b32 v243 /*v499*/, v10
	v_dual_mov_b32 v244 /*v500*/, v10 :: v_dual_mov_b32 v245 /*v501*/, v10
	v_dual_mov_b32 v246 /*v502*/, v10 :: v_dual_mov_b32 v247 /*v503*/, v10
	v_dual_mov_b32 v248 /*v504*/, v10 :: v_dual_mov_b32 v249 /*v505*/, v10
	v_dual_mov_b32 v250 /*v506*/, v10 :: v_dual_mov_b32 v251 /*v507*/, v10
	v_dual_mov_b32 v252 /*v508*/, v10 :: v_dual_mov_b32 v253 /*v509*/, v10
	v_dual_mov_b32 v254 /*v510*/, v10 :: v_dual_mov_b32 v255 /*v511*/, v10
	s_set_vgpr_msb 0x4080
	v_dual_mov_b32 v0 /*v512*/, v10 :: v_dual_mov_b32 v1 /*v513*/, v10
	s_set_vgpr_msb 0x8000
	v_dual_mov_b32 v3, v10 :: v_dual_mov_b32 v4, v10
	v_dual_mov_b32 v5, v10 :: v_dual_mov_b32 v6, v10
	v_dual_mov_b32 v7, v10 :: v_dual_mov_b32 v8, v10
	v_dual_mov_b32 v9, v10 :: v_dual_mov_b32 v18, v10
	v_dual_mov_b32 v19, v10 :: v_dual_mov_b32 v20, v10
	v_dual_mov_b32 v21, v10 :: v_dual_mov_b32 v22, v10
	v_dual_mov_b32 v23, v10 :: v_dual_mov_b32 v24, v10
	v_dual_mov_b32 v25, v10 :: v_dual_mov_b32 v26, v10
	v_dual_mov_b32 v27, v10 :: v_dual_mov_b32 v28, v10
	v_dual_mov_b32 v29, v10 :: v_dual_mov_b32 v30, v10
	v_dual_mov_b32 v31, v10 :: v_dual_mov_b32 v32, v10
	v_dual_mov_b32 v33, v10 :: v_dual_mov_b32 v34, v10
	v_dual_mov_b32 v35, v10 :: v_dual_mov_b32 v36, v10
	v_dual_mov_b32 v37, v10 :: v_dual_mov_b32 v38, v10
	v_dual_mov_b32 v39, v10 :: v_dual_mov_b32 v40, v10
	v_dual_mov_b32 v41, v10 :: v_dual_mov_b32 v50, v10
	v_dual_mov_b32 v51, v10 :: v_dual_mov_b32 v52, v10
	v_dual_mov_b32 v53, v10 :: v_dual_mov_b32 v54, v10
	v_dual_mov_b32 v55, v10 :: v_dual_mov_b32 v56, v10
	v_dual_mov_b32 v57, v10 :: v_dual_mov_b32 v66, v10
	v_dual_mov_b32 v67, v10 :: v_dual_mov_b32 v68, v10
	v_dual_mov_b32 v69, v10 :: v_dual_mov_b32 v70, v10
	v_dual_mov_b32 v71, v10 :: v_dual_mov_b32 v72, v10
	v_dual_mov_b32 v73, v10 :: v_dual_mov_b32 v90, v10
	v_dual_mov_b32 v91, v10 :: v_dual_mov_b32 v92, v10
	v_dual_mov_b32 v93, v10 :: v_dual_mov_b32 v94, v10
	v_dual_mov_b32 v95, v10 :: v_dual_mov_b32 v96, v10
	v_dual_mov_b32 v97, v10 :: v_dual_mov_b32 v106, v10
	v_dual_mov_b32 v107, v10 :: v_dual_mov_b32 v108, v10
	v_dual_mov_b32 v109, v10 :: v_dual_mov_b32 v110, v10
	v_dual_mov_b32 v111, v10 :: v_dual_mov_b32 v112, v10
	v_mov_b32_e32 v113, v10
	s_mov_b32 s13, 0xffff0000
	s_mov_b32 s12, 0x7700000
	s_or_b32 s43, s39, 0x7fff
	s_or_b32 s44, s21, 0x1000000
	s_and_b32 s45, s20, 0xffff
	s_mov_b64 s[26:27], s[18:19]
	s_add_nc_u64 s[6:7], s[6:7], s[10:11]
	s_mov_b64 s[24:25], s[16:17]
	s_mov_b64 s[22:23], s[14:15]
	s_mov_b64 s[20:21], s[12:13]
	s_mov_b32 s22, s43
	s_mov_b32 s23, s44
	s_mov_b32 s25, s42
	s_mov_b32 s26, s45
	s_add_nc_u64 s[6:7], s[6:7], 0x100
	s_mov_b32 s8, 1
	s_mov_b32 s1, 1
	s_branch .LBB0_9
.LBB0_8:
	s_set_vgpr_msb 10
	s_wait_dscnt 0xa
	v_wmma_f32_16x16x32_bf16 v[10:17], v[138:145] /*v[650:657]*/, v[250:257] /*v[762:769]*/, v[10:17]
	v_wmma_f32_16x16x32_bf16 v[42:49], v[146:153] /*v[658:665]*/, v[250:257] /*v[762:769]*/, v[42:49]
	v_wmma_f32_16x16x32_bf16 v[58:65], v[154:161] /*v[666:673]*/, v[250:257] /*v[762:769]*/, v[58:65]
	v_wmma_f32_16x16x32_bf16 v[82:89], v[170:177] /*v[682:689]*/, v[250:257] /*v[762:769]*/, v[82:89]
	v_wmma_f32_16x16x32_bf16 v[98:105], v[178:185] /*v[690:697]*/, v[250:257] /*v[762:769]*/, v[98:105]
	v_wmma_f32_16x16x32_bf16 v[114:121], v[194:201] /*v[706:713]*/, v[250:257] /*v[762:769]*/, v[114:121]
	v_wmma_f32_16x16x32_bf16 v[130:137], v[202:209] /*v[714:721]*/, v[250:257] /*v[762:769]*/, v[130:137]
	v_wmma_f32_16x16x32_bf16 v[138:145], v[218:225] /*v[730:737]*/, v[250:257] /*v[762:769]*/, v[138:145]
	s_wait_dscnt 0x8
	v_wmma_f32_16x16x32_bf16 v[234:241], v[218:225] /*v[730:737]*/, v[242:249] /*v[754:761]*/, v[234:241]
	v_wmma_f32_16x16x32_bf16 v[194:201], v[202:209] /*v[714:721]*/, v[242:249] /*v[754:761]*/, v[194:201]
	v_wmma_f32_16x16x32_bf16 v[170:177], v[194:201] /*v[706:713]*/, v[242:249] /*v[754:761]*/, v[170:177]
	v_wmma_f32_16x16x32_bf16 v[162:169], v[178:185] /*v[690:697]*/, v[242:249] /*v[754:761]*/, v[162:169]
	v_wmma_f32_16x16x32_bf16 v[154:161], v[170:177] /*v[682:689]*/, v[242:249] /*v[754:761]*/, v[154:161]
	v_wmma_f32_16x16x32_bf16 v[146:153], v[154:161] /*v[666:673]*/, v[242:249] /*v[754:761]*/, v[146:153]
	v_wmma_f32_16x16x32_bf16 v[122:129], v[146:153] /*v[658:665]*/, v[242:249] /*v[754:761]*/, v[122:129]
	v_wmma_f32_16x16x32_bf16 v[74:81], v[138:145] /*v[650:657]*/, v[242:249] /*v[754:761]*/, v[74:81]
	s_wait_dscnt 0x6
	v_wmma_f32_16x16x32_bf16 v[178:185], v[138:145] /*v[650:657]*/, v[234:241] /*v[746:753]*/, v[178:185]
	v_wmma_f32_16x16x32_bf16 v[186:193], v[146:153] /*v[658:665]*/, v[234:241] /*v[746:753]*/, v[186:193]
	v_wmma_f32_16x16x32_bf16 v[202:209], v[154:161] /*v[666:673]*/, v[234:241] /*v[746:753]*/, v[202:209]
	v_wmma_f32_16x16x32_bf16 v[218:225], v[170:177] /*v[682:689]*/, v[234:241] /*v[746:753]*/, v[218:225]
	v_wmma_f32_16x16x32_bf16 v[226:233], v[178:185] /*v[690:697]*/, v[234:241] /*v[746:753]*/, v[226:233]
	v_wmma_f32_16x16x32_bf16 v[242:249], v[194:201] /*v[706:713]*/, v[234:241] /*v[746:753]*/, v[242:249]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[2:9] /*v[258:265]*/, v[202:209] /*v[714:721]*/, v[234:241] /*v[746:753]*/, v[2:9] /*v[258:265]*/
	v_wmma_f32_16x16x32_bf16 v[10:17] /*v[266:273]*/, v[218:225] /*v[730:737]*/, v[234:241] /*v[746:753]*/, v[10:17] /*v[266:273]*/
	s_wait_dscnt 0x4
	v_wmma_f32_16x16x32_bf16 v[98:105] /*v[354:361]*/, v[218:225] /*v[730:737]*/, v[226:233] /*v[738:745]*/, v[98:105] /*v[354:361]*/
	v_wmma_f32_16x16x32_bf16 v[74:81] /*v[330:337]*/, v[202:209] /*v[714:721]*/, v[226:233] /*v[738:745]*/, v[74:81] /*v[330:337]*/
	v_wmma_f32_16x16x32_bf16 v[42:49] /*v[298:305]*/, v[194:201] /*v[706:713]*/, v[226:233] /*v[738:745]*/, v[42:49] /*v[298:305]*/
	v_wmma_f32_16x16x32_bf16 v[34:41] /*v[290:297]*/, v[178:185] /*v[690:697]*/, v[226:233] /*v[738:745]*/, v[34:41] /*v[290:297]*/
	v_wmma_f32_16x16x32_bf16 v[26:33] /*v[282:289]*/, v[170:177] /*v[682:689]*/, v[226:233] /*v[738:745]*/, v[26:33] /*v[282:289]*/
	v_wmma_f32_16x16x32_bf16 v[18:25] /*v[274:281]*/, v[154:161] /*v[666:673]*/, v[226:233] /*v[738:745]*/, v[18:25] /*v[274:281]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[250:257], v[146:153] /*v[658:665]*/, v[226:233] /*v[738:745]*/, v[250:257]
	v_wmma_f32_16x16x32_bf16 v[210:217], v[138:145] /*v[650:657]*/, v[226:233] /*v[738:745]*/, v[210:217]
	s_set_vgpr_msb 0xa5a
	s_wait_dscnt 0x2
	v_wmma_f32_16x16x32_bf16 v[50:57] /*v[306:313]*/, v[138:145] /*v[650:657]*/, v[210:217] /*v[722:729]*/, v[50:57] /*v[306:313]*/
	v_wmma_f32_16x16x32_bf16 v[58:65] /*v[314:321]*/, v[146:153] /*v[658:665]*/, v[210:217] /*v[722:729]*/, v[58:65] /*v[314:321]*/
	v_wmma_f32_16x16x32_bf16 v[66:73] /*v[322:329]*/, v[154:161] /*v[666:673]*/, v[210:217] /*v[722:729]*/, v[66:73] /*v[322:329]*/
	v_wmma_f32_16x16x32_bf16 v[90:97] /*v[346:353]*/, v[170:177] /*v[682:689]*/, v[210:217] /*v[722:729]*/, v[90:97] /*v[346:353]*/
	v_wmma_f32_16x16x32_bf16 v[106:113] /*v[362:369]*/, v[178:185] /*v[690:697]*/, v[210:217] /*v[722:729]*/, v[106:113] /*v[362:369]*/
	v_wmma_f32_16x16x32_bf16 v[114:121] /*v[370:377]*/, v[194:201] /*v[706:713]*/, v[210:217] /*v[722:729]*/, v[114:121] /*v[370:377]*/
	v_wmma_f32_16x16x32_bf16 v[130:137] /*v[386:393]*/, v[202:209] /*v[714:721]*/, v[210:217] /*v[722:729]*/, v[130:137] /*v[386:393]*/
	v_wmma_f32_16x16x32_bf16 v[138:145] /*v[394:401]*/, v[218:225] /*v[730:737]*/, v[210:217] /*v[722:729]*/, v[138:145] /*v[394:401]*/
	s_wait_dscnt 0x0
	v_wmma_f32_16x16x32_bf16 v[226:233] /*v[482:489]*/, v[218:225] /*v[730:737]*/, v[186:193] /*v[698:705]*/, v[226:233] /*v[482:489]*/
	v_wmma_f32_16x16x32_bf16 v[194:201] /*v[450:457]*/, v[202:209] /*v[714:721]*/, v[186:193] /*v[698:705]*/, v[194:201] /*v[450:457]*/
	v_wmma_f32_16x16x32_bf16 v[170:177] /*v[426:433]*/, v[194:201] /*v[706:713]*/, v[186:193] /*v[698:705]*/, v[170:177] /*v[426:433]*/
	v_wmma_f32_16x16x32_bf16 v[162:169] /*v[418:425]*/, v[178:185] /*v[690:697]*/, v[186:193] /*v[698:705]*/, v[162:169] /*v[418:425]*/
	v_wmma_f32_16x16x32_bf16 v[154:161] /*v[410:417]*/, v[170:177] /*v[682:689]*/, v[186:193] /*v[698:705]*/, v[154:161] /*v[410:417]*/
	v_wmma_f32_16x16x32_bf16 v[146:153] /*v[402:409]*/, v[154:161] /*v[666:673]*/, v[186:193] /*v[698:705]*/, v[146:153] /*v[402:409]*/
	v_wmma_f32_16x16x32_bf16 v[122:129] /*v[378:385]*/, v[146:153] /*v[658:665]*/, v[186:193] /*v[698:705]*/, v[122:129] /*v[378:385]*/
	v_wmma_f32_16x16x32_bf16 v[82:89] /*v[338:345]*/, v[138:145] /*v[650:657]*/, v[186:193] /*v[698:705]*/, v[82:89] /*v[338:345]*/
	v_wmma_f32_16x16x32_bf16 v[178:185] /*v[434:441]*/, v[138:145] /*v[650:657]*/, v[162:169] /*v[674:681]*/, v[178:185] /*v[434:441]*/
	v_wmma_f32_16x16x32_bf16 v[186:193] /*v[442:449]*/, v[146:153] /*v[658:665]*/, v[162:169] /*v[674:681]*/, v[186:193] /*v[442:449]*/
	v_wmma_f32_16x16x32_bf16 v[202:209] /*v[458:465]*/, v[154:161] /*v[666:673]*/, v[162:169] /*v[674:681]*/, v[202:209] /*v[458:465]*/
	v_wmma_f32_16x16x32_bf16 v[210:217] /*v[466:473]*/, v[170:177] /*v[682:689]*/, v[162:169] /*v[674:681]*/, v[210:217] /*v[466:473]*/
	v_wmma_f32_16x16x32_bf16 v[218:225] /*v[474:481]*/, v[178:185] /*v[690:697]*/, v[162:169] /*v[674:681]*/, v[218:225] /*v[474:481]*/
	v_wmma_f32_16x16x32_bf16 v[234:241] /*v[490:497]*/, v[194:201] /*v[706:713]*/, v[162:169] /*v[674:681]*/, v[234:241] /*v[490:497]*/
	v_wmma_f32_16x16x32_bf16 v[242:249] /*v[498:505]*/, v[202:209] /*v[714:721]*/, v[162:169] /*v[674:681]*/, v[242:249] /*v[498:505]*/
	v_wmma_f32_16x16x32_bf16 v[250:257] /*v[506:513]*/, v[218:225] /*v[730:737]*/, v[162:169] /*v[674:681]*/, v[250:257] /*v[506:513]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[106:113], v[218:225] /*v[730:737]*/, v[130:137] /*v[642:649]*/, v[106:113]
	v_wmma_f32_16x16x32_bf16 v[90:97], v[202:209] /*v[714:721]*/, v[130:137] /*v[642:649]*/, v[90:97]
	v_wmma_f32_16x16x32_bf16 v[66:73], v[194:201] /*v[706:713]*/, v[130:137] /*v[642:649]*/, v[66:73]
	v_wmma_f32_16x16x32_bf16 v[50:57], v[178:185] /*v[690:697]*/, v[130:137] /*v[642:649]*/, v[50:57]
	v_wmma_f32_16x16x32_bf16 v[34:41], v[170:177] /*v[682:689]*/, v[130:137] /*v[642:649]*/, v[34:41]
	v_wmma_f32_16x16x32_bf16 v[26:33], v[154:161] /*v[666:673]*/, v[130:137] /*v[642:649]*/, v[26:33]
	v_wmma_f32_16x16x32_bf16 v[18:25], v[146:153] /*v[658:665]*/, v[130:137] /*v[642:649]*/, v[18:25]
	v_wmma_f32_16x16x32_bf16 v[2:9], v[138:145] /*v[650:657]*/, v[130:137] /*v[642:649]*/, v[2:9]
	s_set_vgpr_msb 0xa83
	ds_load_b128 v[130:133] /*v[642:645]*/, v21 /*v789*/ offset:128
	ds_load_b128 v[134:137] /*v[646:649]*/, v21 /*v789*/ offset:160
	ds_load_b128 v[138:141] /*v[650:653]*/, v21 /*v789*/ offset:4480
	ds_load_b128 v[142:145] /*v[654:657]*/, v21 /*v789*/ offset:4512
	ds_load_b128 v[146:149] /*v[658:661]*/, v21 /*v789*/ offset:8832
	ds_load_b128 v[150:153] /*v[662:665]*/, v21 /*v789*/ offset:8864
	ds_load_b128 v[154:157] /*v[666:669]*/, v21 /*v789*/ offset:13184
	ds_load_b128 v[158:161] /*v[670:673]*/, v21 /*v789*/ offset:13216
	ds_load_b128 v[162:165] /*v[674:677]*/, v21 /*v789*/ offset:17536
	ds_load_b128 v[166:169] /*v[678:681]*/, v21 /*v789*/ offset:17568
	ds_load_b128 v[170:173] /*v[682:685]*/, v21 /*v789*/ offset:21888
	ds_load_b128 v[174:177] /*v[686:689]*/, v21 /*v789*/ offset:21920
	ds_load_b128 v[178:181] /*v[690:693]*/, v21 /*v789*/ offset:26240
	ds_load_b128 v[182:185] /*v[694:697]*/, v21 /*v789*/ offset:26272
	ds_load_b128 v[186:189] /*v[698:701]*/, v22 /*v790*/ offset:128
	ds_load_b128 v[190:193] /*v[702:705]*/, v22 /*v790*/ offset:160
	ds_load_b128 v[194:197] /*v[706:709]*/, v19 /*v787*/ offset:128
	ds_load_b128 v[198:201] /*v[710:713]*/, v19 /*v787*/ offset:160
	ds_load_b128 v[202:205] /*v[714:717]*/, v19 /*v787*/ offset:4480
	ds_load_b128 v[206:209] /*v[718:721]*/, v19 /*v787*/ offset:4512
	ds_load_b128 v[210:213] /*v[722:725]*/, v19 /*v787*/ offset:8832
	ds_load_b128 v[214:217] /*v[726:729]*/, v19 /*v787*/ offset:8864
	ds_load_b128 v[218:221] /*v[730:733]*/, v19 /*v787*/ offset:13184
	ds_load_b128 v[222:225] /*v[734:737]*/, v19 /*v787*/ offset:13216
	ds_load_b128 v[226:229] /*v[738:741]*/, v19 /*v787*/ offset:17536
	ds_load_b128 v[230:233] /*v[742:745]*/, v19 /*v787*/ offset:17568
	ds_load_b128 v[234:237] /*v[746:749]*/, v19 /*v787*/ offset:21888
	ds_load_b128 v[238:241] /*v[750:753]*/, v19 /*v787*/ offset:21920
	ds_load_b128 v[242:245] /*v[754:757]*/, v19 /*v787*/ offset:26240
	ds_load_b128 v[246:249] /*v[758:761]*/, v19 /*v787*/ offset:26272
	ds_load_b128 v[250:253] /*v[762:765]*/, v20 /*v788*/ offset:128
	ds_load_b128 v[254:257] /*v[766:769]*/, v20 /*v788*/ offset:160
	s_set_vgpr_msb 0x830a
	v_wmma_f32_16x16x32_bf16 v[10:17], v[10:17] /*v[522:529]*/, v[122:129] /*v[634:641]*/, v[10:17]
	s_wait_dscnt 0x20
	v_wmma_f32_16x16x32_bf16 v[42:49], v[18:25] /*v[530:537]*/, v[122:129] /*v[634:641]*/, v[42:49]
	v_wmma_f32_16x16x32_bf16 v[58:65], v[26:33] /*v[538:545]*/, v[122:129] /*v[634:641]*/, v[58:65]
	v_wmma_f32_16x16x32_bf16 v[82:89], v[42:49] /*v[554:561]*/, v[122:129] /*v[634:641]*/, v[82:89]
	v_wmma_f32_16x16x32_bf16 v[98:105], v[50:57] /*v[562:569]*/, v[122:129] /*v[634:641]*/, v[98:105]
	v_wmma_f32_16x16x32_bf16 v[114:121], v[58:65] /*v[570:577]*/, v[122:129] /*v[634:641]*/, v[114:121]
	v_wmma_f32_16x16x32_bf16 v[130:137], v[66:73] /*v[578:585]*/, v[122:129] /*v[634:641]*/, v[130:137]
	v_wmma_f32_16x16x32_bf16 v[138:145], v[82:89] /*v[594:601]*/, v[122:129] /*v[634:641]*/, v[138:145]
	v_wmma_f32_16x16x32_bf16 v[234:241], v[82:89] /*v[594:601]*/, v[114:121] /*v[626:633]*/, v[234:241]
	v_wmma_f32_16x16x32_bf16 v[194:201], v[66:73] /*v[578:585]*/, v[114:121] /*v[626:633]*/, v[194:201]
	v_wmma_f32_16x16x32_bf16 v[170:177], v[58:65] /*v[570:577]*/, v[114:121] /*v[626:633]*/, v[170:177]
	v_wmma_f32_16x16x32_bf16 v[162:169], v[50:57] /*v[562:569]*/, v[114:121] /*v[626:633]*/, v[162:169]
	v_wmma_f32_16x16x32_bf16 v[154:161], v[42:49] /*v[554:561]*/, v[114:121] /*v[626:633]*/, v[154:161]
	v_wmma_f32_16x16x32_bf16 v[146:153], v[26:33] /*v[538:545]*/, v[114:121] /*v[626:633]*/, v[146:153]
	v_wmma_f32_16x16x32_bf16 v[122:129], v[18:25] /*v[530:537]*/, v[114:121] /*v[626:633]*/, v[122:129]
	v_wmma_f32_16x16x32_bf16 v[74:81], v[10:17] /*v[522:529]*/, v[114:121] /*v[626:633]*/, v[74:81]
	v_wmma_f32_16x16x32_bf16 v[178:185], v[10:17] /*v[522:529]*/, v[106:113] /*v[618:625]*/, v[178:185]
	v_wmma_f32_16x16x32_bf16 v[186:193], v[18:25] /*v[530:537]*/, v[106:113] /*v[618:625]*/, v[186:193]
	v_wmma_f32_16x16x32_bf16 v[202:209], v[26:33] /*v[538:545]*/, v[106:113] /*v[618:625]*/, v[202:209]
	v_wmma_f32_16x16x32_bf16 v[218:225], v[42:49] /*v[554:561]*/, v[106:113] /*v[618:625]*/, v[218:225]
	v_wmma_f32_16x16x32_bf16 v[226:233], v[50:57] /*v[562:569]*/, v[106:113] /*v[618:625]*/, v[226:233]
	v_wmma_f32_16x16x32_bf16 v[242:249], v[58:65] /*v[570:577]*/, v[106:113] /*v[618:625]*/, v[242:249]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[2:9] /*v[258:265]*/, v[66:73] /*v[578:585]*/, v[106:113] /*v[618:625]*/, v[2:9] /*v[258:265]*/
	v_wmma_f32_16x16x32_bf16 v[10:17] /*v[266:273]*/, v[82:89] /*v[594:601]*/, v[106:113] /*v[618:625]*/, v[10:17] /*v[266:273]*/
	v_wmma_f32_16x16x32_bf16 v[98:105] /*v[354:361]*/, v[82:89] /*v[594:601]*/, v[98:105] /*v[610:617]*/, v[98:105] /*v[354:361]*/
	v_wmma_f32_16x16x32_bf16 v[74:81] /*v[330:337]*/, v[66:73] /*v[578:585]*/, v[98:105] /*v[610:617]*/, v[74:81] /*v[330:337]*/
	v_wmma_f32_16x16x32_bf16 v[42:49] /*v[298:305]*/, v[58:65] /*v[570:577]*/, v[98:105] /*v[610:617]*/, v[42:49] /*v[298:305]*/
	v_wmma_f32_16x16x32_bf16 v[34:41] /*v[290:297]*/, v[50:57] /*v[562:569]*/, v[98:105] /*v[610:617]*/, v[34:41] /*v[290:297]*/
	v_wmma_f32_16x16x32_bf16 v[26:33] /*v[282:289]*/, v[42:49] /*v[554:561]*/, v[98:105] /*v[610:617]*/, v[26:33] /*v[282:289]*/
	v_wmma_f32_16x16x32_bf16 v[18:25] /*v[274:281]*/, v[26:33] /*v[538:545]*/, v[98:105] /*v[610:617]*/, v[18:25] /*v[274:281]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[250:257], v[18:25] /*v[530:537]*/, v[98:105] /*v[610:617]*/, v[250:257]
	v_wmma_f32_16x16x32_bf16 v[210:217], v[10:17] /*v[522:529]*/, v[98:105] /*v[610:617]*/, v[210:217]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[50:57] /*v[306:313]*/, v[10:17] /*v[522:529]*/, v[90:97] /*v[602:609]*/, v[50:57] /*v[306:313]*/
	v_wmma_f32_16x16x32_bf16 v[58:65] /*v[314:321]*/, v[18:25] /*v[530:537]*/, v[90:97] /*v[602:609]*/, v[58:65] /*v[314:321]*/
	v_wmma_f32_16x16x32_bf16 v[66:73] /*v[322:329]*/, v[26:33] /*v[538:545]*/, v[90:97] /*v[602:609]*/, v[66:73] /*v[322:329]*/
	v_wmma_f32_16x16x32_bf16 v[90:97] /*v[346:353]*/, v[42:49] /*v[554:561]*/, v[90:97] /*v[602:609]*/, v[90:97] /*v[346:353]*/
	v_wmma_f32_16x16x32_bf16 v[106:113] /*v[362:369]*/, v[50:57] /*v[562:569]*/, v[90:97] /*v[602:609]*/, v[106:113] /*v[362:369]*/
	v_wmma_f32_16x16x32_bf16 v[114:121] /*v[370:377]*/, v[58:65] /*v[570:577]*/, v[90:97] /*v[602:609]*/, v[114:121] /*v[370:377]*/
	v_wmma_f32_16x16x32_bf16 v[130:137] /*v[386:393]*/, v[66:73] /*v[578:585]*/, v[90:97] /*v[602:609]*/, v[130:137] /*v[386:393]*/
	v_wmma_f32_16x16x32_bf16 v[138:145] /*v[394:401]*/, v[82:89] /*v[594:601]*/, v[90:97] /*v[602:609]*/, v[138:145] /*v[394:401]*/
	v_wmma_f32_16x16x32_bf16 v[226:233] /*v[482:489]*/, v[82:89] /*v[594:601]*/, v[74:81] /*v[586:593]*/, v[226:233] /*v[482:489]*/
	v_wmma_f32_16x16x32_bf16 v[194:201] /*v[450:457]*/, v[66:73] /*v[578:585]*/, v[74:81] /*v[586:593]*/, v[194:201] /*v[450:457]*/
	v_wmma_f32_16x16x32_bf16 v[170:177] /*v[426:433]*/, v[58:65] /*v[570:577]*/, v[74:81] /*v[586:593]*/, v[170:177] /*v[426:433]*/
	v_wmma_f32_16x16x32_bf16 v[162:169] /*v[418:425]*/, v[50:57] /*v[562:569]*/, v[74:81] /*v[586:593]*/, v[162:169] /*v[418:425]*/
	v_wmma_f32_16x16x32_bf16 v[154:161] /*v[410:417]*/, v[42:49] /*v[554:561]*/, v[74:81] /*v[586:593]*/, v[154:161] /*v[410:417]*/
	v_wmma_f32_16x16x32_bf16 v[146:153] /*v[402:409]*/, v[26:33] /*v[538:545]*/, v[74:81] /*v[586:593]*/, v[146:153] /*v[402:409]*/
	v_wmma_f32_16x16x32_bf16 v[122:129] /*v[378:385]*/, v[18:25] /*v[530:537]*/, v[74:81] /*v[586:593]*/, v[122:129] /*v[378:385]*/
	v_wmma_f32_16x16x32_bf16 v[82:89] /*v[338:345]*/, v[10:17] /*v[522:529]*/, v[74:81] /*v[586:593]*/, v[82:89] /*v[338:345]*/
	v_wmma_f32_16x16x32_bf16 v[178:185] /*v[434:441]*/, v[10:17] /*v[522:529]*/, v[34:41] /*v[546:553]*/, v[178:185] /*v[434:441]*/
	v_wmma_f32_16x16x32_bf16 v[186:193] /*v[442:449]*/, v[18:25] /*v[530:537]*/, v[34:41] /*v[546:553]*/, v[186:193] /*v[442:449]*/
	v_wmma_f32_16x16x32_bf16 v[202:209] /*v[458:465]*/, v[26:33] /*v[538:545]*/, v[34:41] /*v[546:553]*/, v[202:209] /*v[458:465]*/
	v_wmma_f32_16x16x32_bf16 v[210:217] /*v[466:473]*/, v[42:49] /*v[554:561]*/, v[34:41] /*v[546:553]*/, v[210:217] /*v[466:473]*/
	v_wmma_f32_16x16x32_bf16 v[218:225] /*v[474:481]*/, v[50:57] /*v[562:569]*/, v[34:41] /*v[546:553]*/, v[218:225] /*v[474:481]*/
	v_wmma_f32_16x16x32_bf16 v[234:241] /*v[490:497]*/, v[58:65] /*v[570:577]*/, v[34:41] /*v[546:553]*/, v[234:241] /*v[490:497]*/
	v_wmma_f32_16x16x32_bf16 v[242:249] /*v[498:505]*/, v[66:73] /*v[578:585]*/, v[34:41] /*v[546:553]*/, v[242:249] /*v[498:505]*/
	v_wmma_f32_16x16x32_bf16 v[250:257] /*v[506:513]*/, v[82:89] /*v[594:601]*/, v[34:41] /*v[546:553]*/, v[250:257] /*v[506:513]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[106:113], v[82:89] /*v[594:601]*/, v[2:9] /*v[514:521]*/, v[106:113]
	v_wmma_f32_16x16x32_bf16 v[90:97], v[66:73] /*v[578:585]*/, v[2:9] /*v[514:521]*/, v[90:97]
	v_wmma_f32_16x16x32_bf16 v[66:73], v[58:65] /*v[570:577]*/, v[2:9] /*v[514:521]*/, v[66:73]
	v_wmma_f32_16x16x32_bf16 v[50:57], v[50:57] /*v[562:569]*/, v[2:9] /*v[514:521]*/, v[50:57]
	v_wmma_f32_16x16x32_bf16 v[34:41], v[42:49] /*v[554:561]*/, v[2:9] /*v[514:521]*/, v[34:41]
	v_wmma_f32_16x16x32_bf16 v[26:33], v[26:33] /*v[538:545]*/, v[2:9] /*v[514:521]*/, v[26:33]
	v_wmma_f32_16x16x32_bf16 v[18:25], v[18:25] /*v[530:537]*/, v[2:9] /*v[514:521]*/, v[18:25]
	v_wmma_f32_16x16x32_bf16 v[2:9], v[10:17] /*v[522:529]*/, v[2:9] /*v[514:521]*/, v[2:9]
	s_set_vgpr_msb 0xa83
	ds_load_b128 v[2:5] /*v[514:517]*/, v21 /*v789*/ offset:192
	ds_load_b128 v[6:9] /*v[518:521]*/, v21 /*v789*/ offset:224
	ds_load_b128 v[10:13] /*v[522:525]*/, v21 /*v789*/ offset:4544
	ds_load_b128 v[14:17] /*v[526:529]*/, v21 /*v789*/ offset:4576
	ds_load_b128 v[18:21] /*v[530:533]*/, v21 /*v789*/ offset:8896
	ds_load_b128 v[22:25] /*v[534:537]*/, v21 /*v789*/ offset:8928
	ds_load_b128 v[26:29] /*v[538:541]*/, v21 /*v789*/ offset:13248
	ds_load_b128 v[30:33] /*v[542:545]*/, v21 /*v789*/ offset:13280
	ds_load_b128 v[34:37] /*v[546:549]*/, v21 /*v789*/ offset:17600
	ds_load_b128 v[38:41] /*v[550:553]*/, v21 /*v789*/ offset:17632
	ds_load_b128 v[42:45] /*v[554:557]*/, v21 /*v789*/ offset:21952
	ds_load_b128 v[46:49] /*v[558:561]*/, v21 /*v789*/ offset:21984
	ds_load_b128 v[50:53] /*v[562:565]*/, v21 /*v789*/ offset:26304
	ds_load_b128 v[54:57] /*v[566:569]*/, v21 /*v789*/ offset:26336
	ds_load_b128 v[58:61] /*v[570:573]*/, v22 /*v790*/ offset:192
	ds_load_b128 v[62:65] /*v[574:577]*/, v22 /*v790*/ offset:224
	ds_load_b128 v[66:69] /*v[578:581]*/, v19 /*v787*/ offset:192
	ds_load_b128 v[70:73] /*v[582:585]*/, v19 /*v787*/ offset:224
	ds_load_b128 v[74:77] /*v[586:589]*/, v19 /*v787*/ offset:4544
	ds_load_b128 v[78:81] /*v[590:593]*/, v19 /*v787*/ offset:4576
	ds_load_b128 v[82:85] /*v[594:597]*/, v19 /*v787*/ offset:8896
	ds_load_b128 v[86:89] /*v[598:601]*/, v19 /*v787*/ offset:8928
	ds_load_b128 v[90:93] /*v[602:605]*/, v19 /*v787*/ offset:13248
	ds_load_b128 v[94:97] /*v[606:609]*/, v19 /*v787*/ offset:13280
	ds_load_b128 v[98:101] /*v[610:613]*/, v19 /*v787*/ offset:17600
	ds_load_b128 v[102:105] /*v[614:617]*/, v19 /*v787*/ offset:17632
	ds_load_b128 v[106:109] /*v[618:621]*/, v19 /*v787*/ offset:21952
	ds_load_b128 v[110:113] /*v[622:625]*/, v19 /*v787*/ offset:21984
	ds_load_b128 v[114:117] /*v[626:629]*/, v19 /*v787*/ offset:26304
	ds_load_b128 v[118:121] /*v[630:633]*/, v19 /*v787*/ offset:26336
	ds_load_b128 v[122:125] /*v[634:637]*/, v20 /*v788*/ offset:192
	ds_load_b128 v[126:129] /*v[638:641]*/, v20 /*v788*/ offset:224
	s_set_vgpr_msb 0x830a
	s_wait_dscnt 0x2e
	v_wmma_f32_16x16x32_bf16 v[10:17], v[194:201] /*v[706:713]*/, v[130:137] /*v[642:649]*/, v[10:17]
	s_wait_dscnt 0x20
	v_wmma_f32_16x16x32_bf16 v[42:49], v[202:209] /*v[714:721]*/, v[130:137] /*v[642:649]*/, v[42:49]
	v_wmma_f32_16x16x32_bf16 v[58:65], v[210:217] /*v[722:729]*/, v[130:137] /*v[642:649]*/, v[58:65]
	v_wmma_f32_16x16x32_bf16 v[82:89], v[218:225] /*v[730:737]*/, v[130:137] /*v[642:649]*/, v[82:89]
	v_wmma_f32_16x16x32_bf16 v[98:105], v[226:233] /*v[738:745]*/, v[130:137] /*v[642:649]*/, v[98:105]
	v_wmma_f32_16x16x32_bf16 v[114:121], v[234:241] /*v[746:753]*/, v[130:137] /*v[642:649]*/, v[114:121]
	v_wmma_f32_16x16x32_bf16 v[130:137], v[242:249] /*v[754:761]*/, v[130:137] /*v[642:649]*/, v[130:137]
	v_wmma_f32_16x16x32_bf16 v[138:145], v[250:257] /*v[762:769]*/, v[130:137] /*v[642:649]*/, v[138:145]
	v_wmma_f32_16x16x32_bf16 v[234:241], v[250:257] /*v[762:769]*/, v[138:145] /*v[650:657]*/, v[234:241]
	v_wmma_f32_16x16x32_bf16 v[194:201], v[242:249] /*v[754:761]*/, v[138:145] /*v[650:657]*/, v[194:201]
	v_wmma_f32_16x16x32_bf16 v[170:177], v[234:241] /*v[746:753]*/, v[138:145] /*v[650:657]*/, v[170:177]
	v_wmma_f32_16x16x32_bf16 v[162:169], v[226:233] /*v[738:745]*/, v[138:145] /*v[650:657]*/, v[162:169]
	v_wmma_f32_16x16x32_bf16 v[154:161], v[218:225] /*v[730:737]*/, v[138:145] /*v[650:657]*/, v[154:161]
	v_wmma_f32_16x16x32_bf16 v[146:153], v[210:217] /*v[722:729]*/, v[138:145] /*v[650:657]*/, v[146:153]
	v_wmma_f32_16x16x32_bf16 v[122:129], v[202:209] /*v[714:721]*/, v[138:145] /*v[650:657]*/, v[122:129]
	v_wmma_f32_16x16x32_bf16 v[74:81], v[194:201] /*v[706:713]*/, v[138:145] /*v[650:657]*/, v[74:81]
	v_wmma_f32_16x16x32_bf16 v[178:185], v[194:201] /*v[706:713]*/, v[146:153] /*v[658:665]*/, v[178:185]
	v_wmma_f32_16x16x32_bf16 v[186:193], v[202:209] /*v[714:721]*/, v[146:153] /*v[658:665]*/, v[186:193]
	v_wmma_f32_16x16x32_bf16 v[202:209], v[210:217] /*v[722:729]*/, v[146:153] /*v[658:665]*/, v[202:209]
	v_wmma_f32_16x16x32_bf16 v[218:225], v[218:225] /*v[730:737]*/, v[146:153] /*v[658:665]*/, v[218:225]
	v_wmma_f32_16x16x32_bf16 v[226:233], v[226:233] /*v[738:745]*/, v[146:153] /*v[658:665]*/, v[226:233]
	v_wmma_f32_16x16x32_bf16 v[242:249], v[234:241] /*v[746:753]*/, v[146:153] /*v[658:665]*/, v[242:249]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[2:9] /*v[258:265]*/, v[242:249] /*v[754:761]*/, v[146:153] /*v[658:665]*/, v[2:9] /*v[258:265]*/
	v_wmma_f32_16x16x32_bf16 v[10:17] /*v[266:273]*/, v[250:257] /*v[762:769]*/, v[146:153] /*v[658:665]*/, v[10:17] /*v[266:273]*/
	v_wmma_f32_16x16x32_bf16 v[98:105] /*v[354:361]*/, v[250:257] /*v[762:769]*/, v[154:161] /*v[666:673]*/, v[98:105] /*v[354:361]*/
	v_wmma_f32_16x16x32_bf16 v[74:81] /*v[330:337]*/, v[242:249] /*v[754:761]*/, v[154:161] /*v[666:673]*/, v[74:81] /*v[330:337]*/
	v_wmma_f32_16x16x32_bf16 v[42:49] /*v[298:305]*/, v[234:241] /*v[746:753]*/, v[154:161] /*v[666:673]*/, v[42:49] /*v[298:305]*/
	v_wmma_f32_16x16x32_bf16 v[34:41] /*v[290:297]*/, v[226:233] /*v[738:745]*/, v[154:161] /*v[666:673]*/, v[34:41] /*v[290:297]*/
	v_wmma_f32_16x16x32_bf16 v[26:33] /*v[282:289]*/, v[218:225] /*v[730:737]*/, v[154:161] /*v[666:673]*/, v[26:33] /*v[282:289]*/
	v_wmma_f32_16x16x32_bf16 v[18:25] /*v[274:281]*/, v[210:217] /*v[722:729]*/, v[154:161] /*v[666:673]*/, v[18:25] /*v[274:281]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[250:257], v[202:209] /*v[714:721]*/, v[154:161] /*v[666:673]*/, v[250:257]
	v_wmma_f32_16x16x32_bf16 v[210:217], v[194:201] /*v[706:713]*/, v[154:161] /*v[666:673]*/, v[210:217]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[50:57] /*v[306:313]*/, v[194:201] /*v[706:713]*/, v[162:169] /*v[674:681]*/, v[50:57] /*v[306:313]*/
	v_wmma_f32_16x16x32_bf16 v[58:65] /*v[314:321]*/, v[202:209] /*v[714:721]*/, v[162:169] /*v[674:681]*/, v[58:65] /*v[314:321]*/
	v_wmma_f32_16x16x32_bf16 v[66:73] /*v[322:329]*/, v[210:217] /*v[722:729]*/, v[162:169] /*v[674:681]*/, v[66:73] /*v[322:329]*/
	v_wmma_f32_16x16x32_bf16 v[90:97] /*v[346:353]*/, v[218:225] /*v[730:737]*/, v[162:169] /*v[674:681]*/, v[90:97] /*v[346:353]*/
	v_wmma_f32_16x16x32_bf16 v[106:113] /*v[362:369]*/, v[226:233] /*v[738:745]*/, v[162:169] /*v[674:681]*/, v[106:113] /*v[362:369]*/
	v_wmma_f32_16x16x32_bf16 v[114:121] /*v[370:377]*/, v[234:241] /*v[746:753]*/, v[162:169] /*v[674:681]*/, v[114:121] /*v[370:377]*/
	v_wmma_f32_16x16x32_bf16 v[130:137] /*v[386:393]*/, v[242:249] /*v[754:761]*/, v[162:169] /*v[674:681]*/, v[130:137] /*v[386:393]*/
	v_wmma_f32_16x16x32_bf16 v[138:145] /*v[394:401]*/, v[250:257] /*v[762:769]*/, v[162:169] /*v[674:681]*/, v[138:145] /*v[394:401]*/
	v_wmma_f32_16x16x32_bf16 v[226:233] /*v[482:489]*/, v[250:257] /*v[762:769]*/, v[170:177] /*v[682:689]*/, v[226:233] /*v[482:489]*/
	v_wmma_f32_16x16x32_bf16 v[194:201] /*v[450:457]*/, v[242:249] /*v[754:761]*/, v[170:177] /*v[682:689]*/, v[194:201] /*v[450:457]*/
	v_wmma_f32_16x16x32_bf16 v[170:177] /*v[426:433]*/, v[234:241] /*v[746:753]*/, v[170:177] /*v[682:689]*/, v[170:177] /*v[426:433]*/
	v_wmma_f32_16x16x32_bf16 v[162:169] /*v[418:425]*/, v[226:233] /*v[738:745]*/, v[170:177] /*v[682:689]*/, v[162:169] /*v[418:425]*/
	v_wmma_f32_16x16x32_bf16 v[154:161] /*v[410:417]*/, v[218:225] /*v[730:737]*/, v[170:177] /*v[682:689]*/, v[154:161] /*v[410:417]*/
	v_wmma_f32_16x16x32_bf16 v[146:153] /*v[402:409]*/, v[210:217] /*v[722:729]*/, v[170:177] /*v[682:689]*/, v[146:153] /*v[402:409]*/
	v_wmma_f32_16x16x32_bf16 v[122:129] /*v[378:385]*/, v[202:209] /*v[714:721]*/, v[170:177] /*v[682:689]*/, v[122:129] /*v[378:385]*/
	v_wmma_f32_16x16x32_bf16 v[82:89] /*v[338:345]*/, v[194:201] /*v[706:713]*/, v[170:177] /*v[682:689]*/, v[82:89] /*v[338:345]*/
	v_wmma_f32_16x16x32_bf16 v[178:185] /*v[434:441]*/, v[194:201] /*v[706:713]*/, v[178:185] /*v[690:697]*/, v[178:185] /*v[434:441]*/
	v_wmma_f32_16x16x32_bf16 v[186:193] /*v[442:449]*/, v[202:209] /*v[714:721]*/, v[178:185] /*v[690:697]*/, v[186:193] /*v[442:449]*/
	v_wmma_f32_16x16x32_bf16 v[202:209] /*v[458:465]*/, v[210:217] /*v[722:729]*/, v[178:185] /*v[690:697]*/, v[202:209] /*v[458:465]*/
	v_wmma_f32_16x16x32_bf16 v[210:217] /*v[466:473]*/, v[218:225] /*v[730:737]*/, v[178:185] /*v[690:697]*/, v[210:217] /*v[466:473]*/
	v_wmma_f32_16x16x32_bf16 v[218:225] /*v[474:481]*/, v[226:233] /*v[738:745]*/, v[178:185] /*v[690:697]*/, v[218:225] /*v[474:481]*/
	v_wmma_f32_16x16x32_bf16 v[234:241] /*v[490:497]*/, v[234:241] /*v[746:753]*/, v[178:185] /*v[690:697]*/, v[234:241] /*v[490:497]*/
	v_wmma_f32_16x16x32_bf16 v[242:249] /*v[498:505]*/, v[242:249] /*v[754:761]*/, v[178:185] /*v[690:697]*/, v[242:249] /*v[498:505]*/
	v_wmma_f32_16x16x32_bf16 v[250:257] /*v[506:513]*/, v[250:257] /*v[762:769]*/, v[178:185] /*v[690:697]*/, v[250:257] /*v[506:513]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[106:113], v[250:257] /*v[762:769]*/, v[186:193] /*v[698:705]*/, v[106:113]
	v_wmma_f32_16x16x32_bf16 v[90:97], v[242:249] /*v[754:761]*/, v[186:193] /*v[698:705]*/, v[90:97]
	v_wmma_f32_16x16x32_bf16 v[66:73], v[234:241] /*v[746:753]*/, v[186:193] /*v[698:705]*/, v[66:73]
	v_wmma_f32_16x16x32_bf16 v[50:57], v[226:233] /*v[738:745]*/, v[186:193] /*v[698:705]*/, v[50:57]
	v_wmma_f32_16x16x32_bf16 v[34:41], v[218:225] /*v[730:737]*/, v[186:193] /*v[698:705]*/, v[34:41]
	v_wmma_f32_16x16x32_bf16 v[26:33], v[210:217] /*v[722:729]*/, v[186:193] /*v[698:705]*/, v[26:33]
	v_wmma_f32_16x16x32_bf16 v[18:25], v[202:209] /*v[714:721]*/, v[186:193] /*v[698:705]*/, v[18:25]
	v_wmma_f32_16x16x32_bf16 v[2:9], v[194:201] /*v[706:713]*/, v[186:193] /*v[698:705]*/, v[2:9]
	s_wait_dscnt 0x0
	s_wait_tensorcnt 0x0
	s_barrier_signal -1
	v_wmma_f32_16x16x32_bf16 v[10:17], v[66:73] /*v[578:585]*/, v[2:9] /*v[514:521]*/, v[10:17]
	v_wmma_f32_16x16x32_bf16 v[42:49], v[74:81] /*v[586:593]*/, v[2:9] /*v[514:521]*/, v[42:49]
	v_wmma_f32_16x16x32_bf16 v[58:65], v[82:89] /*v[594:601]*/, v[2:9] /*v[514:521]*/, v[58:65]
	v_wmma_f32_16x16x32_bf16 v[82:89], v[90:97] /*v[602:609]*/, v[2:9] /*v[514:521]*/, v[82:89]
	v_wmma_f32_16x16x32_bf16 v[98:105], v[98:105] /*v[610:617]*/, v[2:9] /*v[514:521]*/, v[98:105]
	v_wmma_f32_16x16x32_bf16 v[114:121], v[106:113] /*v[618:625]*/, v[2:9] /*v[514:521]*/, v[114:121]
	v_wmma_f32_16x16x32_bf16 v[130:137], v[114:121] /*v[626:633]*/, v[2:9] /*v[514:521]*/, v[130:137]
	v_wmma_f32_16x16x32_bf16 v[138:145], v[122:129] /*v[634:641]*/, v[2:9] /*v[514:521]*/, v[138:145]
	v_wmma_f32_16x16x32_bf16 v[234:241], v[122:129] /*v[634:641]*/, v[10:17] /*v[522:529]*/, v[234:241]
	v_wmma_f32_16x16x32_bf16 v[194:201], v[114:121] /*v[626:633]*/, v[10:17] /*v[522:529]*/, v[194:201]
	v_wmma_f32_16x16x32_bf16 v[170:177], v[106:113] /*v[618:625]*/, v[10:17] /*v[522:529]*/, v[170:177]
	v_wmma_f32_16x16x32_bf16 v[162:169], v[98:105] /*v[610:617]*/, v[10:17] /*v[522:529]*/, v[162:169]
	v_wmma_f32_16x16x32_bf16 v[154:161], v[90:97] /*v[602:609]*/, v[10:17] /*v[522:529]*/, v[154:161]
	v_wmma_f32_16x16x32_bf16 v[146:153], v[82:89] /*v[594:601]*/, v[10:17] /*v[522:529]*/, v[146:153]
	v_wmma_f32_16x16x32_bf16 v[122:129], v[74:81] /*v[586:593]*/, v[10:17] /*v[522:529]*/, v[122:129]
	v_wmma_f32_16x16x32_bf16 v[74:81], v[66:73] /*v[578:585]*/, v[10:17] /*v[522:529]*/, v[74:81]
	v_wmma_f32_16x16x32_bf16 v[178:185], v[66:73] /*v[578:585]*/, v[18:25] /*v[530:537]*/, v[178:185]
	v_wmma_f32_16x16x32_bf16 v[186:193], v[74:81] /*v[586:593]*/, v[18:25] /*v[530:537]*/, v[186:193]
	v_wmma_f32_16x16x32_bf16 v[202:209], v[82:89] /*v[594:601]*/, v[18:25] /*v[530:537]*/, v[202:209]
	v_wmma_f32_16x16x32_bf16 v[218:225], v[90:97] /*v[602:609]*/, v[18:25] /*v[530:537]*/, v[218:225]
	v_wmma_f32_16x16x32_bf16 v[226:233], v[98:105] /*v[610:617]*/, v[18:25] /*v[530:537]*/, v[226:233]
	v_wmma_f32_16x16x32_bf16 v[242:249], v[106:113] /*v[618:625]*/, v[18:25] /*v[530:537]*/, v[242:249]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[2:9] /*v[258:265]*/, v[114:121] /*v[626:633]*/, v[18:25] /*v[530:537]*/, v[2:9] /*v[258:265]*/
	v_wmma_f32_16x16x32_bf16 v[10:17] /*v[266:273]*/, v[122:129] /*v[634:641]*/, v[18:25] /*v[530:537]*/, v[10:17] /*v[266:273]*/
	v_wmma_f32_16x16x32_bf16 v[98:105] /*v[354:361]*/, v[122:129] /*v[634:641]*/, v[26:33] /*v[538:545]*/, v[98:105] /*v[354:361]*/
	v_wmma_f32_16x16x32_bf16 v[74:81] /*v[330:337]*/, v[114:121] /*v[626:633]*/, v[26:33] /*v[538:545]*/, v[74:81] /*v[330:337]*/
	v_wmma_f32_16x16x32_bf16 v[42:49] /*v[298:305]*/, v[106:113] /*v[618:625]*/, v[26:33] /*v[538:545]*/, v[42:49] /*v[298:305]*/
	v_wmma_f32_16x16x32_bf16 v[34:41] /*v[290:297]*/, v[98:105] /*v[610:617]*/, v[26:33] /*v[538:545]*/, v[34:41] /*v[290:297]*/
	v_wmma_f32_16x16x32_bf16 v[26:33] /*v[282:289]*/, v[90:97] /*v[602:609]*/, v[26:33] /*v[538:545]*/, v[26:33] /*v[282:289]*/
	v_wmma_f32_16x16x32_bf16 v[18:25] /*v[274:281]*/, v[82:89] /*v[594:601]*/, v[26:33] /*v[538:545]*/, v[18:25] /*v[274:281]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[250:257], v[74:81] /*v[586:593]*/, v[26:33] /*v[538:545]*/, v[250:257]
	v_wmma_f32_16x16x32_bf16 v[210:217], v[66:73] /*v[578:585]*/, v[26:33] /*v[538:545]*/, v[210:217]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[50:57] /*v[306:313]*/, v[66:73] /*v[578:585]*/, v[34:41] /*v[546:553]*/, v[50:57] /*v[306:313]*/
	v_wmma_f32_16x16x32_bf16 v[58:65] /*v[314:321]*/, v[74:81] /*v[586:593]*/, v[34:41] /*v[546:553]*/, v[58:65] /*v[314:321]*/
	v_wmma_f32_16x16x32_bf16 v[66:73] /*v[322:329]*/, v[82:89] /*v[594:601]*/, v[34:41] /*v[546:553]*/, v[66:73] /*v[322:329]*/
	v_wmma_f32_16x16x32_bf16 v[90:97] /*v[346:353]*/, v[90:97] /*v[602:609]*/, v[34:41] /*v[546:553]*/, v[90:97] /*v[346:353]*/
	v_wmma_f32_16x16x32_bf16 v[106:113] /*v[362:369]*/, v[98:105] /*v[610:617]*/, v[34:41] /*v[546:553]*/, v[106:113] /*v[362:369]*/
	v_wmma_f32_16x16x32_bf16 v[114:121] /*v[370:377]*/, v[106:113] /*v[618:625]*/, v[34:41] /*v[546:553]*/, v[114:121] /*v[370:377]*/
	v_wmma_f32_16x16x32_bf16 v[130:137] /*v[386:393]*/, v[114:121] /*v[626:633]*/, v[34:41] /*v[546:553]*/, v[130:137] /*v[386:393]*/
	v_wmma_f32_16x16x32_bf16 v[138:145] /*v[394:401]*/, v[122:129] /*v[634:641]*/, v[34:41] /*v[546:553]*/, v[138:145] /*v[394:401]*/
	v_wmma_f32_16x16x32_bf16 v[226:233] /*v[482:489]*/, v[122:129] /*v[634:641]*/, v[42:49] /*v[554:561]*/, v[226:233] /*v[482:489]*/
	v_wmma_f32_16x16x32_bf16 v[194:201] /*v[450:457]*/, v[114:121] /*v[626:633]*/, v[42:49] /*v[554:561]*/, v[194:201] /*v[450:457]*/
	v_wmma_f32_16x16x32_bf16 v[170:177] /*v[426:433]*/, v[106:113] /*v[618:625]*/, v[42:49] /*v[554:561]*/, v[170:177] /*v[426:433]*/
	v_wmma_f32_16x16x32_bf16 v[162:169] /*v[418:425]*/, v[98:105] /*v[610:617]*/, v[42:49] /*v[554:561]*/, v[162:169] /*v[418:425]*/
	v_wmma_f32_16x16x32_bf16 v[154:161] /*v[410:417]*/, v[90:97] /*v[602:609]*/, v[42:49] /*v[554:561]*/, v[154:161] /*v[410:417]*/
	v_wmma_f32_16x16x32_bf16 v[146:153] /*v[402:409]*/, v[82:89] /*v[594:601]*/, v[42:49] /*v[554:561]*/, v[146:153] /*v[402:409]*/
	v_wmma_f32_16x16x32_bf16 v[122:129] /*v[378:385]*/, v[74:81] /*v[586:593]*/, v[42:49] /*v[554:561]*/, v[122:129] /*v[378:385]*/
	v_wmma_f32_16x16x32_bf16 v[82:89] /*v[338:345]*/, v[66:73] /*v[578:585]*/, v[42:49] /*v[554:561]*/, v[82:89] /*v[338:345]*/
	v_wmma_f32_16x16x32_bf16 v[178:185] /*v[434:441]*/, v[66:73] /*v[578:585]*/, v[50:57] /*v[562:569]*/, v[178:185] /*v[434:441]*/
	v_wmma_f32_16x16x32_bf16 v[186:193] /*v[442:449]*/, v[74:81] /*v[586:593]*/, v[50:57] /*v[562:569]*/, v[186:193] /*v[442:449]*/
	v_wmma_f32_16x16x32_bf16 v[202:209] /*v[458:465]*/, v[82:89] /*v[594:601]*/, v[50:57] /*v[562:569]*/, v[202:209] /*v[458:465]*/
	v_wmma_f32_16x16x32_bf16 v[210:217] /*v[466:473]*/, v[90:97] /*v[602:609]*/, v[50:57] /*v[562:569]*/, v[210:217] /*v[466:473]*/
	v_wmma_f32_16x16x32_bf16 v[218:225] /*v[474:481]*/, v[98:105] /*v[610:617]*/, v[50:57] /*v[562:569]*/, v[218:225] /*v[474:481]*/
	v_wmma_f32_16x16x32_bf16 v[234:241] /*v[490:497]*/, v[106:113] /*v[618:625]*/, v[50:57] /*v[562:569]*/, v[234:241] /*v[490:497]*/
	v_wmma_f32_16x16x32_bf16 v[242:249] /*v[498:505]*/, v[114:121] /*v[626:633]*/, v[50:57] /*v[562:569]*/, v[242:249] /*v[498:505]*/
	v_wmma_f32_16x16x32_bf16 v[250:257] /*v[506:513]*/, v[122:129] /*v[634:641]*/, v[50:57] /*v[562:569]*/, v[250:257] /*v[506:513]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[106:113], v[122:129] /*v[634:641]*/, v[58:65] /*v[570:577]*/, v[106:113]
	v_wmma_f32_16x16x32_bf16 v[90:97], v[114:121] /*v[626:633]*/, v[58:65] /*v[570:577]*/, v[90:97]
	v_wmma_f32_16x16x32_bf16 v[66:73], v[106:113] /*v[618:625]*/, v[58:65] /*v[570:577]*/, v[66:73]
	v_wmma_f32_16x16x32_bf16 v[50:57], v[98:105] /*v[610:617]*/, v[58:65] /*v[570:577]*/, v[50:57]
	v_wmma_f32_16x16x32_bf16 v[34:41], v[90:97] /*v[602:609]*/, v[58:65] /*v[570:577]*/, v[34:41]
	v_wmma_f32_16x16x32_bf16 v[26:33], v[82:89] /*v[594:601]*/, v[58:65] /*v[570:577]*/, v[26:33]
	v_wmma_f32_16x16x32_bf16 v[18:25], v[74:81] /*v[586:593]*/, v[58:65] /*v[570:577]*/, v[18:25]
	v_wmma_f32_16x16x32_bf16 v[2:9], v[66:73] /*v[578:585]*/, v[58:65] /*v[570:577]*/, v[2:9]
	s_add_co_i32 s1, s1, 1
	s_add_nc_u64 s[6:7], s[6:7], 0x100
	s_set_vgpr_msb 0xa00
	v_cmp_ne_u32_e32 vcc_lo, s1, v1
	s_add_nc_u64 s[34:35], s[34:35], 0x100
	s_barrier_wait -1
	s_cbranch_vccz .LBB0_13
.LBB0_9:
	s_bitcmp1_b32 s1, 0
	s_cselect_b32 s9, 0, 0x22000
	s_cselect_b32 s40, 0x22000, 0
	s_add_co_i32 s9, s9, 0
	s_wait_alu depctr_vm_vsrc(2)
	s_set_vgpr_msb 0xcc
	v_add_nc_u32_e32 v19 /*v787*/, s9, v12 /*v780*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xccc0
	v_add_nc_u32_e32 v20 /*v788*/, s9, v0
	s_set_vgpr_msb 0xc0cc
	v_dual_add_nc_u32 v21 /*v789*/, s9, v13 /*v781*/ :: v_dual_add_nc_u32 v22 /*v790*/, s9, v11 /*v779*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0xcc83
	ds_load_b128 v[194:197] /*v[706:709]*/, v19 /*v787*/ offset:21760
	ds_load_b128 v[198:201] /*v[710:713]*/, v19 /*v787*/ offset:21792
	ds_load_b128 v[202:205] /*v[714:717]*/, v19 /*v787*/ offset:26112
	ds_load_b128 v[206:209] /*v[718:721]*/, v19 /*v787*/ offset:26144
	ds_load_b128 v[218:221] /*v[730:733]*/, v20 /*v788*/
	ds_load_b128 v[222:225] /*v[734:737]*/, v20 /*v788*/ offset:32
	ds_load_b128 v[122:125] /*v[634:637]*/, v21 /*v789*/ offset:64
	ds_load_b128 v[126:129] /*v[638:641]*/, v21 /*v789*/ offset:96
	ds_load_b128 v[114:117] /*v[626:629]*/, v21 /*v789*/ offset:4416
	ds_load_b128 v[118:121] /*v[630:633]*/, v21 /*v789*/ offset:4448
	ds_load_b128 v[106:109] /*v[618:621]*/, v21 /*v789*/ offset:8768
	ds_load_b128 v[110:113] /*v[622:625]*/, v21 /*v789*/ offset:8800
	ds_load_b128 v[98:101] /*v[610:613]*/, v21 /*v789*/ offset:13120
	ds_load_b128 v[102:105] /*v[614:617]*/, v21 /*v789*/ offset:13152
	ds_load_b128 v[90:93] /*v[602:605]*/, v21 /*v789*/ offset:17472
	ds_load_b128 v[94:97] /*v[606:609]*/, v21 /*v789*/ offset:17504
	ds_load_b128 v[74:77] /*v[586:589]*/, v21 /*v789*/ offset:21824
	ds_load_b128 v[78:81] /*v[590:593]*/, v21 /*v789*/ offset:21856
	ds_load_b128 v[34:37] /*v[546:549]*/, v21 /*v789*/ offset:26176
	ds_load_b128 v[38:41] /*v[550:553]*/, v21 /*v789*/ offset:26208
	ds_load_b128 v[2:5] /*v[514:517]*/, v22 /*v790*/ offset:64
	ds_load_b128 v[6:9] /*v[518:521]*/, v22 /*v790*/ offset:96
	ds_load_b128 v[10:13] /*v[522:525]*/, v19 /*v787*/ offset:64
	ds_load_b128 v[14:17] /*v[526:529]*/, v19 /*v787*/ offset:96
	ds_load_b128 v[18:21] /*v[530:533]*/, v19 /*v787*/ offset:4416
	ds_load_b128 v[22:25] /*v[534:537]*/, v19 /*v787*/ offset:4448
	ds_load_b128 v[26:29] /*v[538:541]*/, v19 /*v787*/ offset:8768
	ds_load_b128 v[30:33] /*v[542:545]*/, v19 /*v787*/ offset:8800
	ds_load_b128 v[42:45] /*v[554:557]*/, v19 /*v787*/ offset:13120
	ds_load_b128 v[46:49] /*v[558:561]*/, v19 /*v787*/ offset:13152
	ds_load_b128 v[50:53] /*v[562:565]*/, v19 /*v787*/ offset:17472
	ds_load_b128 v[54:57] /*v[566:569]*/, v19 /*v787*/ offset:17504
	ds_load_b128 v[58:61] /*v[570:573]*/, v19 /*v787*/ offset:21824
	ds_load_b128 v[62:65] /*v[574:577]*/, v19 /*v787*/ offset:21856
	ds_load_b128 v[66:69] /*v[578:581]*/, v19 /*v787*/ offset:26176
	ds_load_b128 v[70:73] /*v[582:585]*/, v19 /*v787*/ offset:26208
	ds_load_b128 v[82:85] /*v[594:597]*/, v20 /*v788*/ offset:64
	ds_load_b128 v[86:89] /*v[598:601]*/, v20 /*v788*/ offset:96
	ds_load_b128 v[162:165] /*v[674:677]*/, v21 /*v789*/ offset:26112
	ds_load_b128 v[166:169] /*v[678:681]*/, v21 /*v789*/ offset:26144
	ds_load_b128 v[130:133] /*v[642:645]*/, v22 /*v790*/
	ds_load_b128 v[134:137] /*v[646:649]*/, v22 /*v790*/ offset:32
	ds_load_b128 v[138:141] /*v[650:653]*/, v19 /*v787*/
	ds_load_b128 v[142:145] /*v[654:657]*/, v19 /*v787*/ offset:32
	ds_load_b128 v[146:149] /*v[658:661]*/, v19 /*v787*/ offset:4352
	ds_load_b128 v[150:153] /*v[662:665]*/, v19 /*v787*/ offset:4384
	ds_load_b128 v[154:157] /*v[666:669]*/, v19 /*v787*/ offset:8704
	ds_load_b128 v[158:161] /*v[670:673]*/, v19 /*v787*/ offset:8736
	ds_load_b128 v[170:173] /*v[682:685]*/, v19 /*v787*/ offset:13056
	ds_load_b128 v[174:177] /*v[686:689]*/, v19 /*v787*/ offset:13088
	ds_load_b128 v[178:181] /*v[690:693]*/, v19 /*v787*/ offset:17408
	ds_load_b128 v[182:185] /*v[694:697]*/, v19 /*v787*/ offset:17440
	ds_load_b128 v[250:253] /*v[762:765]*/, v21 /*v789*/
	ds_load_b128 v[254:257] /*v[766:769]*/, v21 /*v789*/ offset:32
	ds_load_b128 v[242:245] /*v[754:757]*/, v21 /*v789*/ offset:4352
	ds_load_b128 v[246:249] /*v[758:761]*/, v21 /*v789*/ offset:4384
	ds_load_b128 v[234:237] /*v[746:749]*/, v21 /*v789*/ offset:8704
	ds_load_b128 v[238:241] /*v[750:753]*/, v21 /*v789*/ offset:8736
	ds_load_b128 v[226:229] /*v[738:741]*/, v21 /*v789*/ offset:13056
	ds_load_b128 v[230:233] /*v[742:745]*/, v21 /*v789*/ offset:13088
	ds_load_b128 v[210:213] /*v[722:725]*/, v21 /*v789*/ offset:17408
	ds_load_b128 v[214:217] /*v[726:729]*/, v21 /*v789*/ offset:17440
	ds_load_b128 v[186:189] /*v[698:701]*/, v21 /*v789*/ offset:21760
	ds_load_b128 v[190:193] /*v[702:705]*/, v21 /*v789*/ offset:21792
	s_wait_dscnt 0x20
	s_and_b32 vcc_lo, exec_lo, s0
	s_set_vgpr_msb 0x8300
	s_cbranch_vccz .LBB0_11
	s_and_not1_b32 vcc_lo, exec_lo, s37
	s_cbranch_vccnz .LBB0_8
	s_branch .LBB0_12
.LBB0_11:
	s_add_co_i32 s9, s40, 0
	s_or_b32 s11, s7, 0x80000000
	s_mov_b32 s10, s6
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[8:11], s[12:19]
	s_and_not1_b32 vcc_lo, exec_lo, s37
	s_cbranch_vccnz .LBB0_8
.LBB0_12:
	s_add_co_i32 s9, s40, 0
	s_or_b32 s11, s35, 0x80000000
	s_add_co_i32 s9, s9, 0x11000
	s_mov_b32 s10, s34
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[8:11], s[20:27]
	s_branch .LBB0_8
.LBB0_13:
	v_mov_b32_e32 v1, s39
	s_set_vgpr_msb 0x83
	v_dual_mov_b32 v42 /*v554*/, s38 :: v_dual_mov_b32 v43 /*v555*/, v17 /*v785*/
	v_dual_mov_b32 v5 /*v517*/, v14 /*v782*/ :: v_dual_mov_b32 v4 /*v516*/, v18 /*v786*/
	v_dual_mov_b32 v3 /*v515*/, v16 /*v784*/ :: v_dual_mov_b32 v2 /*v514*/, v15 /*v783*/
	s_set_vgpr_msb 0x8300
.LBB0_14:
	s_lshr_b32 s0, s29, 31
	s_set_vgpr_msb 0x8b
	v_add3_u32 v38 /*v550*/, v10 /*v778*/, s36, 16
	s_add_co_i32 s0, s29, s0
	s_mov_b32 s7, 0
	s_and_b32 s0, s0, 0x7fffe
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(SALU_CYCLE_1)
	v_mul_u32_u24_e32 v38 /*v550*/, 0x110, v38 /*v550*/
	s_sub_co_i32 s0, s29, s0
	s_ashr_i32 s29, s28, 31
	s_mul_i32 s0, s0, 0x22000
	s_add_co_i32 s0, s0, 0
	s_set_vgpr_msb 0x8b8a
	v_add3_u32 v38 /*v550*/, v5 /*v517*/, v38 /*v550*/, s0
	s_set_vgpr_msb 0x8a0c
	v_add_nc_u32_e32 v0, s0, v13 /*v781*/
	s_set_vgpr_msb 0xc88
	v_add_nc_u32_e32 v4 /*v516*/, s0, v4 /*v516*/
	s_set_vgpr_msb 0x888e
	v_dual_add_nc_u32 v39 /*v551*/, s0, v11 /*v779*/ :: v_dual_add_nc_u32 v40 /*v552*/, s0, v12 /*v780*/
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[124:127] /*v[636:639]*/, v38 /*v550*/ offset:21760
	ds_load_b128 v[128:131] /*v[640:643]*/, v38 /*v550*/ offset:21792
	ds_load_b128 v[132:135] /*v[644:647]*/, v38 /*v550*/ offset:26112
	ds_load_b128 v[136:139] /*v[648:651]*/, v38 /*v550*/ offset:26144
	ds_load_b128 v[140:143] /*v[652:655]*/, v4 /*v516*/
	ds_load_b128 v[144:147] /*v[656:659]*/, v4 /*v516*/ offset:32
	s_set_vgpr_msb 0x8e8c
	ds_load_b128 v[148:151] /*v[660:663]*/, v0 offset:4416
	ds_load_b128 v[152:155] /*v[664:667]*/, v0 offset:4448
	ds_load_b128 v[156:159] /*v[668:671]*/, v0 offset:8768
	ds_load_b128 v[160:163] /*v[672:675]*/, v0 offset:8800
	ds_load_b128 v[164:167] /*v[676:679]*/, v0 offset:13120
	ds_load_b128 v[168:171] /*v[680:683]*/, v0 offset:13152
	ds_load_b128 v[172:175] /*v[684:687]*/, v0 offset:17472
	ds_load_b128 v[176:179] /*v[688:691]*/, v0 offset:17504
	s_wait_alu depctr_vm_vsrc(6)
	v_dual_add_nc_u32 v4 /*v516*/, s0, v9 /*v777*/ :: v_dual_add_nc_u32 v5 /*v517*/, s0, v8 /*v776*/
	ds_load_b128 v[188:191] /*v[700:703]*/, v0 offset:26176
	ds_load_b128 v[192:195] /*v[704:707]*/, v0 offset:26208
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x8c82
	ds_load_b128 v[196:199] /*v[708:711]*/, v4 /*v516*/
	ds_load_b128 v[200:203] /*v[712:715]*/, v4 /*v516*/ offset:32
	ds_load_b128 v[204:207] /*v[716:719]*/, v5 /*v517*/
	ds_load_b128 v[208:211] /*v[720:723]*/, v5 /*v517*/ offset:32
	ds_load_b128 v[212:215] /*v[724:727]*/, v38 /*v550*/ offset:64
	ds_load_b128 v[216:219] /*v[728:731]*/, v38 /*v550*/ offset:96
	ds_load_b128 v[220:223] /*v[732:735]*/, v38 /*v550*/ offset:4416
	ds_load_b128 v[224:227] /*v[736:739]*/, v38 /*v550*/ offset:4448
	ds_load_b128 v[228:231] /*v[740:743]*/, v38 /*v550*/ offset:8768
	ds_load_b128 v[232:235] /*v[744:747]*/, v38 /*v550*/ offset:8800
	ds_load_b128 v[236:239] /*v[748:751]*/, v38 /*v550*/ offset:13120
	ds_load_b128 v[240:243] /*v[752:755]*/, v38 /*v550*/ offset:13152
	ds_load_b128 v[244:247] /*v[756:759]*/, v38 /*v550*/ offset:17472
	ds_load_b128 v[248:251] /*v[760:763]*/, v38 /*v550*/ offset:17504
	s_set_vgpr_msb 0x82c2
	ds_load_b128 v[8:11] /*v[776:779]*/, v38 /*v550*/ offset:21824
	ds_load_b128 v[12:15] /*v[780:783]*/, v38 /*v550*/ offset:21856
	ds_load_b128 v[16:19] /*v[784:787]*/, v38 /*v550*/ offset:26176
	ds_load_b128 v[20:23] /*v[788:791]*/, v38 /*v550*/ offset:26208
	s_set_vgpr_msb 0xc282
	ds_load_b128 v[68:71] /*v[580:583]*/, v39 /*v551*/
	ds_load_b128 v[72:75] /*v[584:587]*/, v39 /*v551*/ offset:32
	ds_load_b128 v[76:79] /*v[588:591]*/, v40 /*v552*/
	ds_load_b128 v[80:83] /*v[592:595]*/, v40 /*v552*/ offset:32
	ds_load_b128 v[84:87] /*v[596:599]*/, v38 /*v550*/
	ds_load_b128 v[88:91] /*v[600:603]*/, v38 /*v550*/ offset:32
	ds_load_b128 v[92:95] /*v[604:607]*/, v38 /*v550*/ offset:4352
	ds_load_b128 v[96:99] /*v[608:611]*/, v38 /*v550*/ offset:4384
	ds_load_b128 v[100:103] /*v[612:615]*/, v38 /*v550*/ offset:8704
	ds_load_b128 v[104:107] /*v[616:619]*/, v38 /*v550*/ offset:8736
	ds_load_b128 v[108:111] /*v[620:623]*/, v38 /*v550*/ offset:13056
	ds_load_b128 v[112:115] /*v[624:627]*/, v38 /*v550*/ offset:13088
	ds_load_b128 v[116:119] /*v[628:631]*/, v38 /*v550*/ offset:17408
	ds_load_b128 v[120:123] /*v[632:635]*/, v38 /*v550*/ offset:17440
	s_set_vgpr_msb 0x8280
	ds_load_b128 v[6:9] /*v[518:521]*/, v0
	ds_load_b128 v[10:13] /*v[522:525]*/, v0 offset:32
	ds_load_b128 v[14:17] /*v[526:529]*/, v0 offset:4352
	ds_load_b128 v[18:21] /*v[530:533]*/, v0 offset:4384
	ds_load_b128 v[22:25] /*v[534:537]*/, v0 offset:8704
	ds_load_b128 v[26:29] /*v[538:541]*/, v0 offset:8736
	ds_load_b128 v[30:33] /*v[542:545]*/, v0 offset:13056
	ds_load_b128 v[34:37] /*v[546:549]*/, v0 offset:13088
	ds_load_b128 v[44:47] /*v[556:559]*/, v0 offset:17408
	ds_load_b128 v[48:51] /*v[560:563]*/, v0 offset:17440
	ds_load_b128 v[52:55] /*v[564:567]*/, v0 offset:21760
	ds_load_b128 v[56:59] /*v[568:571]*/, v0 offset:21792
	ds_load_b128 v[60:63] /*v[572:575]*/, v0 offset:26112
	ds_load_b128 v[64:67] /*v[576:579]*/, v0 offset:26144
	ds_load_b128 v[180:183] /*v[692:695]*/, v0 offset:21824
	ds_load_b128 v[184:187] /*v[696:699]*/, v0 offset:21856
	s_set_vgpr_msb 0x800a
	s_wait_dscnt 0xe
	v_wmma_f32_16x16x32_bf16 v[10:17], v[76:83] /*v[588:595]*/, v[6:13] /*v[518:525]*/, v[10:17]
	s_wait_dscnt 0x20
	v_wmma_f32_16x16x32_bf16 v[42:49], v[84:91] /*v[596:603]*/, v[6:13] /*v[518:525]*/, v[42:49]
	v_wmma_f32_16x16x32_bf16 v[58:65], v[92:99] /*v[604:611]*/, v[6:13] /*v[518:525]*/, v[58:65]
	v_wmma_f32_16x16x32_bf16 v[82:89], v[100:107] /*v[612:619]*/, v[6:13] /*v[518:525]*/, v[82:89]
	v_wmma_f32_16x16x32_bf16 v[98:105], v[108:115] /*v[620:627]*/, v[6:13] /*v[518:525]*/, v[98:105]
	v_wmma_f32_16x16x32_bf16 v[114:121], v[116:123] /*v[628:635]*/, v[6:13] /*v[518:525]*/, v[114:121]
	v_wmma_f32_16x16x32_bf16 v[130:137], v[124:131] /*v[636:643]*/, v[6:13] /*v[518:525]*/, v[130:137]
	v_wmma_f32_16x16x32_bf16 v[138:145], v[132:139] /*v[644:651]*/, v[6:13] /*v[518:525]*/, v[138:145]
	s_wait_dscnt 0xc
	v_wmma_f32_16x16x32_bf16 v[234:241], v[132:139] /*v[644:651]*/, v[14:21] /*v[526:533]*/, v[234:241]
	v_wmma_f32_16x16x32_bf16 v[194:201], v[124:131] /*v[636:643]*/, v[14:21] /*v[526:533]*/, v[194:201]
	v_wmma_f32_16x16x32_bf16 v[170:177], v[116:123] /*v[628:635]*/, v[14:21] /*v[526:533]*/, v[170:177]
	v_wmma_f32_16x16x32_bf16 v[162:169], v[108:115] /*v[620:627]*/, v[14:21] /*v[526:533]*/, v[162:169]
	v_wmma_f32_16x16x32_bf16 v[154:161], v[100:107] /*v[612:619]*/, v[14:21] /*v[526:533]*/, v[154:161]
	v_wmma_f32_16x16x32_bf16 v[146:153], v[92:99] /*v[604:611]*/, v[14:21] /*v[526:533]*/, v[146:153]
	v_wmma_f32_16x16x32_bf16 v[122:129], v[84:91] /*v[596:603]*/, v[14:21] /*v[526:533]*/, v[122:129]
	v_wmma_f32_16x16x32_bf16 v[74:81], v[76:83] /*v[588:595]*/, v[14:21] /*v[526:533]*/, v[74:81]
	s_wait_dscnt 0xa
	v_wmma_f32_16x16x32_bf16 v[178:185], v[76:83] /*v[588:595]*/, v[22:29] /*v[534:541]*/, v[178:185]
	v_wmma_f32_16x16x32_bf16 v[186:193], v[84:91] /*v[596:603]*/, v[22:29] /*v[534:541]*/, v[186:193]
	v_wmma_f32_16x16x32_bf16 v[202:209], v[92:99] /*v[604:611]*/, v[22:29] /*v[534:541]*/, v[202:209]
	v_wmma_f32_16x16x32_bf16 v[218:225], v[100:107] /*v[612:619]*/, v[22:29] /*v[534:541]*/, v[218:225]
	v_wmma_f32_16x16x32_bf16 v[226:233], v[108:115] /*v[620:627]*/, v[22:29] /*v[534:541]*/, v[226:233]
	v_wmma_f32_16x16x32_bf16 v[242:249], v[116:123] /*v[628:635]*/, v[22:29] /*v[534:541]*/, v[242:249]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[2:9] /*v[258:265]*/, v[124:131] /*v[636:643]*/, v[22:29] /*v[534:541]*/, v[2:9] /*v[258:265]*/
	v_wmma_f32_16x16x32_bf16 v[10:17] /*v[266:273]*/, v[132:139] /*v[644:651]*/, v[22:29] /*v[534:541]*/, v[10:17] /*v[266:273]*/
	s_wait_dscnt 0x8
	v_wmma_f32_16x16x32_bf16 v[98:105] /*v[354:361]*/, v[132:139] /*v[644:651]*/, v[30:37] /*v[542:549]*/, v[98:105] /*v[354:361]*/
	v_wmma_f32_16x16x32_bf16 v[74:81] /*v[330:337]*/, v[124:131] /*v[636:643]*/, v[30:37] /*v[542:549]*/, v[74:81] /*v[330:337]*/
	v_wmma_f32_16x16x32_bf16 v[42:49] /*v[298:305]*/, v[116:123] /*v[628:635]*/, v[30:37] /*v[542:549]*/, v[42:49] /*v[298:305]*/
	v_wmma_f32_16x16x32_bf16 v[34:41] /*v[290:297]*/, v[108:115] /*v[620:627]*/, v[30:37] /*v[542:549]*/, v[34:41] /*v[290:297]*/
	v_wmma_f32_16x16x32_bf16 v[26:33] /*v[282:289]*/, v[100:107] /*v[612:619]*/, v[30:37] /*v[542:549]*/, v[26:33] /*v[282:289]*/
	v_wmma_f32_16x16x32_bf16 v[18:25] /*v[274:281]*/, v[92:99] /*v[604:611]*/, v[30:37] /*v[542:549]*/, v[18:25] /*v[274:281]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[250:257], v[84:91] /*v[596:603]*/, v[30:37] /*v[542:549]*/, v[250:257]
	v_wmma_f32_16x16x32_bf16 v[210:217], v[76:83] /*v[588:595]*/, v[30:37] /*v[542:549]*/, v[210:217]
	s_set_vgpr_msb 0xa5a
	s_wait_dscnt 0x6
	v_wmma_f32_16x16x32_bf16 v[50:57] /*v[306:313]*/, v[76:83] /*v[588:595]*/, v[44:51] /*v[556:563]*/, v[50:57] /*v[306:313]*/
	v_wmma_f32_16x16x32_bf16 v[58:65] /*v[314:321]*/, v[84:91] /*v[596:603]*/, v[44:51] /*v[556:563]*/, v[58:65] /*v[314:321]*/
	v_wmma_f32_16x16x32_bf16 v[66:73] /*v[322:329]*/, v[92:99] /*v[604:611]*/, v[44:51] /*v[556:563]*/, v[66:73] /*v[322:329]*/
	v_wmma_f32_16x16x32_bf16 v[90:97] /*v[346:353]*/, v[100:107] /*v[612:619]*/, v[44:51] /*v[556:563]*/, v[90:97] /*v[346:353]*/
	v_wmma_f32_16x16x32_bf16 v[106:113] /*v[362:369]*/, v[108:115] /*v[620:627]*/, v[44:51] /*v[556:563]*/, v[106:113] /*v[362:369]*/
	v_wmma_f32_16x16x32_bf16 v[114:121] /*v[370:377]*/, v[116:123] /*v[628:635]*/, v[44:51] /*v[556:563]*/, v[114:121] /*v[370:377]*/
	v_wmma_f32_16x16x32_bf16 v[130:137] /*v[386:393]*/, v[124:131] /*v[636:643]*/, v[44:51] /*v[556:563]*/, v[130:137] /*v[386:393]*/
	v_wmma_f32_16x16x32_bf16 v[138:145] /*v[394:401]*/, v[132:139] /*v[644:651]*/, v[44:51] /*v[556:563]*/, v[138:145] /*v[394:401]*/
	s_wait_dscnt 0x4
	v_wmma_f32_16x16x32_bf16 v[226:233] /*v[482:489]*/, v[132:139] /*v[644:651]*/, v[52:59] /*v[564:571]*/, v[226:233] /*v[482:489]*/
	v_wmma_f32_16x16x32_bf16 v[194:201] /*v[450:457]*/, v[124:131] /*v[636:643]*/, v[52:59] /*v[564:571]*/, v[194:201] /*v[450:457]*/
	v_wmma_f32_16x16x32_bf16 v[170:177] /*v[426:433]*/, v[116:123] /*v[628:635]*/, v[52:59] /*v[564:571]*/, v[170:177] /*v[426:433]*/
	v_wmma_f32_16x16x32_bf16 v[162:169] /*v[418:425]*/, v[108:115] /*v[620:627]*/, v[52:59] /*v[564:571]*/, v[162:169] /*v[418:425]*/
	v_wmma_f32_16x16x32_bf16 v[154:161] /*v[410:417]*/, v[100:107] /*v[612:619]*/, v[52:59] /*v[564:571]*/, v[154:161] /*v[410:417]*/
	v_wmma_f32_16x16x32_bf16 v[146:153] /*v[402:409]*/, v[92:99] /*v[604:611]*/, v[52:59] /*v[564:571]*/, v[146:153] /*v[402:409]*/
	v_wmma_f32_16x16x32_bf16 v[122:129] /*v[378:385]*/, v[84:91] /*v[596:603]*/, v[52:59] /*v[564:571]*/, v[122:129] /*v[378:385]*/
	v_wmma_f32_16x16x32_bf16 v[82:89] /*v[338:345]*/, v[76:83] /*v[588:595]*/, v[52:59] /*v[564:571]*/, v[82:89] /*v[338:345]*/
	s_wait_dscnt 0x2
	v_wmma_f32_16x16x32_bf16 v[178:185] /*v[434:441]*/, v[76:83] /*v[588:595]*/, v[60:67] /*v[572:579]*/, v[178:185] /*v[434:441]*/
	v_wmma_f32_16x16x32_bf16 v[186:193] /*v[442:449]*/, v[84:91] /*v[596:603]*/, v[60:67] /*v[572:579]*/, v[186:193] /*v[442:449]*/
	v_wmma_f32_16x16x32_bf16 v[202:209] /*v[458:465]*/, v[92:99] /*v[604:611]*/, v[60:67] /*v[572:579]*/, v[202:209] /*v[458:465]*/
	v_wmma_f32_16x16x32_bf16 v[210:217] /*v[466:473]*/, v[100:107] /*v[612:619]*/, v[60:67] /*v[572:579]*/, v[210:217] /*v[466:473]*/
	v_wmma_f32_16x16x32_bf16 v[218:225] /*v[474:481]*/, v[108:115] /*v[620:627]*/, v[60:67] /*v[572:579]*/, v[218:225] /*v[474:481]*/
	v_wmma_f32_16x16x32_bf16 v[234:241] /*v[490:497]*/, v[116:123] /*v[628:635]*/, v[60:67] /*v[572:579]*/, v[234:241] /*v[490:497]*/
	v_wmma_f32_16x16x32_bf16 v[242:249] /*v[498:505]*/, v[124:131] /*v[636:643]*/, v[60:67] /*v[572:579]*/, v[242:249] /*v[498:505]*/
	v_wmma_f32_16x16x32_bf16 v[250:257] /*v[506:513]*/, v[132:139] /*v[644:651]*/, v[60:67] /*v[572:579]*/, v[250:257] /*v[506:513]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[106:113], v[132:139] /*v[644:651]*/, v[68:75] /*v[580:587]*/, v[106:113]
	v_wmma_f32_16x16x32_bf16 v[90:97], v[124:131] /*v[636:643]*/, v[68:75] /*v[580:587]*/, v[90:97]
	v_wmma_f32_16x16x32_bf16 v[66:73], v[116:123] /*v[628:635]*/, v[68:75] /*v[580:587]*/, v[66:73]
	v_wmma_f32_16x16x32_bf16 v[50:57], v[108:115] /*v[620:627]*/, v[68:75] /*v[580:587]*/, v[50:57]
	v_wmma_f32_16x16x32_bf16 v[34:41], v[100:107] /*v[612:619]*/, v[68:75] /*v[580:587]*/, v[34:41]
	v_wmma_f32_16x16x32_bf16 v[26:33], v[92:99] /*v[604:611]*/, v[68:75] /*v[580:587]*/, v[26:33]
	v_wmma_f32_16x16x32_bf16 v[18:25], v[84:91] /*v[596:603]*/, v[68:75] /*v[580:587]*/, v[18:25]
	v_wmma_f32_16x16x32_bf16 v[2:9], v[76:83] /*v[588:595]*/, v[68:75] /*v[580:587]*/, v[2:9]
	s_set_vgpr_msb 0xa88
	v_add_nc_u32_e32 v3 /*v515*/, s0, v3 /*v515*/
	ds_load_b128 v[84:87] /*v[596:599]*/, v0 offset:21888
	ds_load_b128 v[88:91] /*v[600:603]*/, v0 offset:21920
	ds_load_b128 v[44:47] /*v[556:559]*/, v0 offset:4480
	ds_load_b128 v[48:51] /*v[560:563]*/, v0 offset:4512
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x8882
	ds_load_b128 v[52:55] /*v[564:567]*/, v3 /*v515*/
	ds_load_b128 v[56:59] /*v[568:571]*/, v3 /*v515*/ offset:32
	s_set_vgpr_msb 0x828c
	ds_load_b128 v[60:63] /*v[572:575]*/, v0 offset:8832
	ds_load_b128 v[64:67] /*v[576:579]*/, v0 offset:8864
	ds_load_b128 v[68:71] /*v[580:583]*/, v0 offset:13184
	ds_load_b128 v[72:75] /*v[584:587]*/, v0 offset:13216
	ds_load_b128 v[76:79] /*v[588:591]*/, v0 offset:17536
	ds_load_b128 v[80:83] /*v[592:595]*/, v0 offset:17568
	s_wait_alu depctr_vm_vsrc(6)
	v_dual_add_nc_u32 v3 /*v515*/, s0, v7 /*v775*/ :: v_dual_add_nc_u32 v4 /*v516*/, s0, v6 /*v774*/
	ds_load_b128 v[92:95] /*v[604:607]*/, v0 offset:26240
	ds_load_b128 v[96:99] /*v[608:611]*/, v0 offset:26272
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x8c82
	ds_load_b128 v[100:103] /*v[612:615]*/, v3 /*v515*/
	ds_load_b128 v[104:107] /*v[616:619]*/, v3 /*v515*/ offset:32
	ds_load_b128 v[108:111] /*v[620:623]*/, v4 /*v516*/
	ds_load_b128 v[112:115] /*v[624:627]*/, v4 /*v516*/ offset:32
	ds_load_b128 v[116:119] /*v[628:631]*/, v38 /*v550*/ offset:128
	ds_load_b128 v[120:123] /*v[632:635]*/, v38 /*v550*/ offset:160
	ds_load_b128 v[124:127] /*v[636:639]*/, v38 /*v550*/ offset:4480
	ds_load_b128 v[128:131] /*v[640:643]*/, v38 /*v550*/ offset:4512
	ds_load_b128 v[132:135] /*v[644:647]*/, v38 /*v550*/ offset:8832
	ds_load_b128 v[136:139] /*v[648:651]*/, v38 /*v550*/ offset:8864
	s_set_vgpr_msb 0x82c2
	ds_load_b128 v[24:27] /*v[792:795]*/, v38 /*v550*/ offset:13184
	ds_load_b128 v[28:31] /*v[796:799]*/, v38 /*v550*/ offset:13216
	ds_load_b128 v[32:35] /*v[800:803]*/, v38 /*v550*/ offset:17536
	ds_load_b128 v[36:39] /*v[804:807]*/, v38 /*v550*/ offset:17568
	ds_load_b128 v[40:43] /*v[808:811]*/, v38 /*v550*/ offset:21888
	ds_load_b128 v[44:47] /*v[812:815]*/, v38 /*v550*/ offset:21920
	ds_load_b128 v[48:51] /*v[816:819]*/, v38 /*v550*/ offset:26240
	ds_load_b128 v[52:55] /*v[820:823]*/, v38 /*v550*/ offset:26272
	s_set_vgpr_msb 0xc20a
	v_wmma_f32_16x16x32_bf16 v[10:17], v[204:211] /*v[716:723]*/, v[140:147] /*v[652:659]*/, v[10:17]
	s_wait_dscnt 0x20
	v_wmma_f32_16x16x32_bf16 v[42:49], v[212:219] /*v[724:731]*/, v[140:147] /*v[652:659]*/, v[42:49]
	v_wmma_f32_16x16x32_bf16 v[58:65], v[220:227] /*v[732:739]*/, v[140:147] /*v[652:659]*/, v[58:65]
	v_wmma_f32_16x16x32_bf16 v[82:89], v[228:235] /*v[740:747]*/, v[140:147] /*v[652:659]*/, v[82:89]
	v_wmma_f32_16x16x32_bf16 v[98:105], v[236:243] /*v[748:755]*/, v[140:147] /*v[652:659]*/, v[98:105]
	v_wmma_f32_16x16x32_bf16 v[114:121], v[244:251] /*v[756:763]*/, v[140:147] /*v[652:659]*/, v[114:121]
	s_set_vgpr_msb 0xa0b
	v_wmma_f32_16x16x32_bf16 v[130:137], v[8:15] /*v[776:783]*/, v[140:147] /*v[652:659]*/, v[130:137]
	v_wmma_f32_16x16x32_bf16 v[138:145], v[16:23] /*v[784:791]*/, v[140:147] /*v[652:659]*/, v[138:145]
	v_wmma_f32_16x16x32_bf16 v[234:241], v[16:23] /*v[784:791]*/, v[148:155] /*v[660:667]*/, v[234:241]
	v_wmma_f32_16x16x32_bf16 v[194:201], v[8:15] /*v[776:783]*/, v[148:155] /*v[660:667]*/, v[194:201]
	s_set_vgpr_msb 0xb0a
	v_wmma_f32_16x16x32_bf16 v[170:177], v[244:251] /*v[756:763]*/, v[148:155] /*v[660:667]*/, v[170:177]
	v_wmma_f32_16x16x32_bf16 v[162:169], v[236:243] /*v[748:755]*/, v[148:155] /*v[660:667]*/, v[162:169]
	v_wmma_f32_16x16x32_bf16 v[154:161], v[228:235] /*v[740:747]*/, v[148:155] /*v[660:667]*/, v[154:161]
	v_wmma_f32_16x16x32_bf16 v[146:153], v[220:227] /*v[732:739]*/, v[148:155] /*v[660:667]*/, v[146:153]
	v_wmma_f32_16x16x32_bf16 v[122:129], v[212:219] /*v[724:731]*/, v[148:155] /*v[660:667]*/, v[122:129]
	v_wmma_f32_16x16x32_bf16 v[74:81], v[204:211] /*v[716:723]*/, v[148:155] /*v[660:667]*/, v[74:81]
	v_wmma_f32_16x16x32_bf16 v[178:185], v[204:211] /*v[716:723]*/, v[156:163] /*v[668:675]*/, v[178:185]
	v_wmma_f32_16x16x32_bf16 v[186:193], v[212:219] /*v[724:731]*/, v[156:163] /*v[668:675]*/, v[186:193]
	v_wmma_f32_16x16x32_bf16 v[202:209], v[220:227] /*v[732:739]*/, v[156:163] /*v[668:675]*/, v[202:209]
	v_wmma_f32_16x16x32_bf16 v[218:225], v[228:235] /*v[740:747]*/, v[156:163] /*v[668:675]*/, v[218:225]
	v_wmma_f32_16x16x32_bf16 v[226:233], v[236:243] /*v[748:755]*/, v[156:163] /*v[668:675]*/, v[226:233]
	v_wmma_f32_16x16x32_bf16 v[242:249], v[244:251] /*v[756:763]*/, v[156:163] /*v[668:675]*/, v[242:249]
	s_set_vgpr_msb 0xa5b
	v_wmma_f32_16x16x32_bf16 v[2:9] /*v[258:265]*/, v[8:15] /*v[776:783]*/, v[156:163] /*v[668:675]*/, v[2:9] /*v[258:265]*/
	v_wmma_f32_16x16x32_bf16 v[10:17] /*v[266:273]*/, v[16:23] /*v[784:791]*/, v[156:163] /*v[668:675]*/, v[10:17] /*v[266:273]*/
	v_wmma_f32_16x16x32_bf16 v[98:105] /*v[354:361]*/, v[16:23] /*v[784:791]*/, v[164:171] /*v[676:683]*/, v[98:105] /*v[354:361]*/
	v_wmma_f32_16x16x32_bf16 v[74:81] /*v[330:337]*/, v[8:15] /*v[776:783]*/, v[164:171] /*v[676:683]*/, v[74:81] /*v[330:337]*/
	s_set_vgpr_msb 0x5b5a
	v_wmma_f32_16x16x32_bf16 v[42:49] /*v[298:305]*/, v[244:251] /*v[756:763]*/, v[164:171] /*v[676:683]*/, v[42:49] /*v[298:305]*/
	v_wmma_f32_16x16x32_bf16 v[34:41] /*v[290:297]*/, v[236:243] /*v[748:755]*/, v[164:171] /*v[676:683]*/, v[34:41] /*v[290:297]*/
	v_wmma_f32_16x16x32_bf16 v[26:33] /*v[282:289]*/, v[228:235] /*v[740:747]*/, v[164:171] /*v[676:683]*/, v[26:33] /*v[282:289]*/
	v_wmma_f32_16x16x32_bf16 v[18:25] /*v[274:281]*/, v[220:227] /*v[732:739]*/, v[164:171] /*v[676:683]*/, v[18:25] /*v[274:281]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[250:257], v[212:219] /*v[724:731]*/, v[164:171] /*v[676:683]*/, v[250:257]
	v_wmma_f32_16x16x32_bf16 v[210:217], v[204:211] /*v[716:723]*/, v[164:171] /*v[676:683]*/, v[210:217]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[50:57] /*v[306:313]*/, v[204:211] /*v[716:723]*/, v[172:179] /*v[684:691]*/, v[50:57] /*v[306:313]*/
	v_wmma_f32_16x16x32_bf16 v[58:65] /*v[314:321]*/, v[212:219] /*v[724:731]*/, v[172:179] /*v[684:691]*/, v[58:65] /*v[314:321]*/
	v_wmma_f32_16x16x32_bf16 v[66:73] /*v[322:329]*/, v[220:227] /*v[732:739]*/, v[172:179] /*v[684:691]*/, v[66:73] /*v[322:329]*/
	v_wmma_f32_16x16x32_bf16 v[90:97] /*v[346:353]*/, v[228:235] /*v[740:747]*/, v[172:179] /*v[684:691]*/, v[90:97] /*v[346:353]*/
	v_wmma_f32_16x16x32_bf16 v[106:113] /*v[362:369]*/, v[236:243] /*v[748:755]*/, v[172:179] /*v[684:691]*/, v[106:113] /*v[362:369]*/
	v_wmma_f32_16x16x32_bf16 v[114:121] /*v[370:377]*/, v[244:251] /*v[756:763]*/, v[172:179] /*v[684:691]*/, v[114:121] /*v[370:377]*/
	s_set_vgpr_msb 0x5a5b
	v_wmma_f32_16x16x32_bf16 v[130:137] /*v[386:393]*/, v[8:15] /*v[776:783]*/, v[172:179] /*v[684:691]*/, v[130:137] /*v[386:393]*/
	v_wmma_f32_16x16x32_bf16 v[138:145] /*v[394:401]*/, v[16:23] /*v[784:791]*/, v[172:179] /*v[684:691]*/, v[138:145] /*v[394:401]*/
	v_wmma_f32_16x16x32_bf16 v[226:233] /*v[482:489]*/, v[16:23] /*v[784:791]*/, v[180:187] /*v[692:699]*/, v[226:233] /*v[482:489]*/
	v_wmma_f32_16x16x32_bf16 v[194:201] /*v[450:457]*/, v[8:15] /*v[776:783]*/, v[180:187] /*v[692:699]*/, v[194:201] /*v[450:457]*/
	s_set_vgpr_msb 0x5b5a
	v_wmma_f32_16x16x32_bf16 v[170:177] /*v[426:433]*/, v[244:251] /*v[756:763]*/, v[180:187] /*v[692:699]*/, v[170:177] /*v[426:433]*/
	v_wmma_f32_16x16x32_bf16 v[162:169] /*v[418:425]*/, v[236:243] /*v[748:755]*/, v[180:187] /*v[692:699]*/, v[162:169] /*v[418:425]*/
	v_wmma_f32_16x16x32_bf16 v[154:161] /*v[410:417]*/, v[228:235] /*v[740:747]*/, v[180:187] /*v[692:699]*/, v[154:161] /*v[410:417]*/
	v_wmma_f32_16x16x32_bf16 v[146:153] /*v[402:409]*/, v[220:227] /*v[732:739]*/, v[180:187] /*v[692:699]*/, v[146:153] /*v[402:409]*/
	v_wmma_f32_16x16x32_bf16 v[122:129] /*v[378:385]*/, v[212:219] /*v[724:731]*/, v[180:187] /*v[692:699]*/, v[122:129] /*v[378:385]*/
	v_wmma_f32_16x16x32_bf16 v[82:89] /*v[338:345]*/, v[204:211] /*v[716:723]*/, v[180:187] /*v[692:699]*/, v[82:89] /*v[338:345]*/
	v_wmma_f32_16x16x32_bf16 v[178:185] /*v[434:441]*/, v[204:211] /*v[716:723]*/, v[188:195] /*v[700:707]*/, v[178:185] /*v[434:441]*/
	v_wmma_f32_16x16x32_bf16 v[186:193] /*v[442:449]*/, v[212:219] /*v[724:731]*/, v[188:195] /*v[700:707]*/, v[186:193] /*v[442:449]*/
	v_wmma_f32_16x16x32_bf16 v[202:209] /*v[458:465]*/, v[220:227] /*v[732:739]*/, v[188:195] /*v[700:707]*/, v[202:209] /*v[458:465]*/
	v_wmma_f32_16x16x32_bf16 v[210:217] /*v[466:473]*/, v[228:235] /*v[740:747]*/, v[188:195] /*v[700:707]*/, v[210:217] /*v[466:473]*/
	v_wmma_f32_16x16x32_bf16 v[218:225] /*v[474:481]*/, v[236:243] /*v[748:755]*/, v[188:195] /*v[700:707]*/, v[218:225] /*v[474:481]*/
	v_wmma_f32_16x16x32_bf16 v[234:241] /*v[490:497]*/, v[244:251] /*v[756:763]*/, v[188:195] /*v[700:707]*/, v[234:241] /*v[490:497]*/
	s_set_vgpr_msb 0x5a5b
	v_wmma_f32_16x16x32_bf16 v[242:249] /*v[498:505]*/, v[8:15] /*v[776:783]*/, v[188:195] /*v[700:707]*/, v[242:249] /*v[498:505]*/
	v_wmma_f32_16x16x32_bf16 v[250:257] /*v[506:513]*/, v[16:23] /*v[784:791]*/, v[188:195] /*v[700:707]*/, v[250:257] /*v[506:513]*/
	s_set_vgpr_msb 0x5b0b
	v_wmma_f32_16x16x32_bf16 v[106:113], v[16:23] /*v[784:791]*/, v[196:203] /*v[708:715]*/, v[106:113]
	v_wmma_f32_16x16x32_bf16 v[90:97], v[8:15] /*v[776:783]*/, v[196:203] /*v[708:715]*/, v[90:97]
	s_set_vgpr_msb 0xb0a
	v_wmma_f32_16x16x32_bf16 v[66:73], v[244:251] /*v[756:763]*/, v[196:203] /*v[708:715]*/, v[66:73]
	v_wmma_f32_16x16x32_bf16 v[50:57], v[236:243] /*v[748:755]*/, v[196:203] /*v[708:715]*/, v[50:57]
	v_wmma_f32_16x16x32_bf16 v[34:41], v[228:235] /*v[740:747]*/, v[196:203] /*v[708:715]*/, v[34:41]
	v_wmma_f32_16x16x32_bf16 v[26:33], v[220:227] /*v[732:739]*/, v[196:203] /*v[708:715]*/, v[26:33]
	v_wmma_f32_16x16x32_bf16 v[18:25], v[212:219] /*v[724:731]*/, v[196:203] /*v[708:715]*/, v[18:25]
	v_wmma_f32_16x16x32_bf16 v[2:9], v[204:211] /*v[716:723]*/, v[196:203] /*v[708:715]*/, v[2:9]
	s_set_vgpr_msb 0xa88
	v_add_nc_u32_e32 v2 /*v514*/, s0, v2 /*v514*/
	s_set_vgpr_msb 0x888c
	v_dual_add_nc_u32 v6 /*v518*/, s0, v5 /*v773*/ :: v_dual_add_nc_u32 v10 /*v522*/, s0, v4 /*v772*/
	ds_load_b128 v[140:143] /*v[652:655]*/, v0 offset:4544
	ds_load_b128 v[144:147] /*v[656:659]*/, v0 offset:4576
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x8c82
	ds_load_b128 v[148:151] /*v[660:663]*/, v2 /*v514*/
	ds_load_b128 v[152:155] /*v[664:667]*/, v2 /*v514*/ offset:32
	s_set_vgpr_msb 0x8280
	ds_load_b128 v[156:159] /*v[668:671]*/, v0 offset:8896
	ds_load_b128 v[160:163] /*v[672:675]*/, v0 offset:8928
	ds_load_b128 v[164:167] /*v[676:679]*/, v0 offset:13248
	ds_load_b128 v[168:171] /*v[680:683]*/, v0 offset:13280
	ds_load_b128 v[172:175] /*v[684:687]*/, v0 offset:17600
	ds_load_b128 v[176:179] /*v[688:691]*/, v0 offset:17632
	ds_load_b128 v[188:191] /*v[700:703]*/, v0 offset:26304
	ds_load_b128 v[192:195] /*v[704:707]*/, v0 offset:26336
	s_wait_alu depctr_vm_vsrc(6)
	s_set_vgpr_msb 0x8082
	ds_load_b128 v[2:5] /*v[514:517]*/, v6 /*v518*/
	s_wait_alu depctr_vm_vsrc(0)
	ds_load_b128 v[6:9] /*v[518:521]*/, v6 /*v518*/ offset:32
	ds_load_b128 v[196:199] /*v[708:711]*/, v10 /*v522*/
	ds_load_b128 v[200:203] /*v[712:715]*/, v10 /*v522*/ offset:32
	ds_load_b128 v[26:29] /*v[538:541]*/, v38 /*v550*/ offset:192
	ds_load_b128 v[30:33] /*v[542:545]*/, v38 /*v550*/ offset:224
	ds_load_b128 v[204:207] /*v[716:719]*/, v38 /*v550*/ offset:4544
	ds_load_b128 v[208:211] /*v[720:723]*/, v38 /*v550*/ offset:4576
	s_wait_alu depctr_vm_vsrc(4)
	ds_load_b128 v[10:13] /*v[522:525]*/, v38 /*v550*/ offset:8896
	ds_load_b128 v[14:17] /*v[526:529]*/, v38 /*v550*/ offset:8928
	ds_load_b128 v[212:215] /*v[724:727]*/, v38 /*v550*/ offset:13248
	ds_load_b128 v[216:219] /*v[728:731]*/, v38 /*v550*/ offset:13280
	ds_load_b128 v[18:21] /*v[530:533]*/, v38 /*v550*/ offset:17600
	ds_load_b128 v[22:25] /*v[534:537]*/, v38 /*v550*/ offset:17632
	ds_load_b128 v[220:223] /*v[732:735]*/, v38 /*v550*/ offset:21952
	ds_load_b128 v[224:227] /*v[736:739]*/, v38 /*v550*/ offset:21984
	ds_load_b128 v[34:37] /*v[546:549]*/, v38 /*v550*/ offset:26304
	s_wait_alu depctr_vm_vsrc(0)
	ds_load_b128 v[38:41] /*v[550:553]*/, v38 /*v550*/ offset:26336
	s_set_vgpr_msb 0x8280
	ds_load_b128 v[180:183] /*v[692:695]*/, v0 offset:21952
	ds_load_b128 v[184:187] /*v[696:699]*/, v0 offset:21984
	s_set_vgpr_msb 0x800a
	s_wait_dscnt 0x2e
	v_wmma_f32_16x16x32_bf16 v[10:17], v[108:115] /*v[620:627]*/, v[52:59] /*v[564:571]*/, v[10:17]
	s_wait_dscnt 0x20
	v_wmma_f32_16x16x32_bf16 v[42:49], v[116:123] /*v[628:635]*/, v[52:59] /*v[564:571]*/, v[42:49]
	v_wmma_f32_16x16x32_bf16 v[58:65], v[124:131] /*v[636:643]*/, v[52:59] /*v[564:571]*/, v[58:65]
	v_wmma_f32_16x16x32_bf16 v[82:89], v[132:139] /*v[644:651]*/, v[52:59] /*v[564:571]*/, v[82:89]
	s_set_vgpr_msb 0xa0b
	v_wmma_f32_16x16x32_bf16 v[98:105], v[24:31] /*v[792:799]*/, v[52:59] /*v[564:571]*/, v[98:105]
	v_wmma_f32_16x16x32_bf16 v[114:121], v[32:39] /*v[800:807]*/, v[52:59] /*v[564:571]*/, v[114:121]
	v_wmma_f32_16x16x32_bf16 v[130:137], v[40:47] /*v[808:815]*/, v[52:59] /*v[564:571]*/, v[130:137]
	v_wmma_f32_16x16x32_bf16 v[138:145], v[48:55] /*v[816:823]*/, v[52:59] /*v[564:571]*/, v[138:145]
	v_wmma_f32_16x16x32_bf16 v[234:241], v[48:55] /*v[816:823]*/, v[44:51] /*v[556:563]*/, v[234:241]
	v_wmma_f32_16x16x32_bf16 v[194:201], v[40:47] /*v[808:815]*/, v[44:51] /*v[556:563]*/, v[194:201]
	v_wmma_f32_16x16x32_bf16 v[170:177], v[32:39] /*v[800:807]*/, v[44:51] /*v[556:563]*/, v[170:177]
	v_wmma_f32_16x16x32_bf16 v[162:169], v[24:31] /*v[792:799]*/, v[44:51] /*v[556:563]*/, v[162:169]
	s_set_vgpr_msb 0xb0a
	v_wmma_f32_16x16x32_bf16 v[154:161], v[132:139] /*v[644:651]*/, v[44:51] /*v[556:563]*/, v[154:161]
	v_wmma_f32_16x16x32_bf16 v[146:153], v[124:131] /*v[636:643]*/, v[44:51] /*v[556:563]*/, v[146:153]
	v_wmma_f32_16x16x32_bf16 v[122:129], v[116:123] /*v[628:635]*/, v[44:51] /*v[556:563]*/, v[122:129]
	v_wmma_f32_16x16x32_bf16 v[74:81], v[108:115] /*v[620:627]*/, v[44:51] /*v[556:563]*/, v[74:81]
	v_wmma_f32_16x16x32_bf16 v[178:185], v[108:115] /*v[620:627]*/, v[60:67] /*v[572:579]*/, v[178:185]
	v_wmma_f32_16x16x32_bf16 v[186:193], v[116:123] /*v[628:635]*/, v[60:67] /*v[572:579]*/, v[186:193]
	v_wmma_f32_16x16x32_bf16 v[202:209], v[124:131] /*v[636:643]*/, v[60:67] /*v[572:579]*/, v[202:209]
	v_wmma_f32_16x16x32_bf16 v[218:225], v[132:139] /*v[644:651]*/, v[60:67] /*v[572:579]*/, v[218:225]
	s_set_vgpr_msb 0xa0b
	v_wmma_f32_16x16x32_bf16 v[226:233], v[24:31] /*v[792:799]*/, v[60:67] /*v[572:579]*/, v[226:233]
	v_wmma_f32_16x16x32_bf16 v[242:249], v[32:39] /*v[800:807]*/, v[60:67] /*v[572:579]*/, v[242:249]
	s_set_vgpr_msb 0xb5b
	v_wmma_f32_16x16x32_bf16 v[2:9] /*v[258:265]*/, v[40:47] /*v[808:815]*/, v[60:67] /*v[572:579]*/, v[2:9] /*v[258:265]*/
	v_wmma_f32_16x16x32_bf16 v[10:17] /*v[266:273]*/, v[48:55] /*v[816:823]*/, v[60:67] /*v[572:579]*/, v[10:17] /*v[266:273]*/
	v_wmma_f32_16x16x32_bf16 v[98:105] /*v[354:361]*/, v[48:55] /*v[816:823]*/, v[68:75] /*v[580:587]*/, v[98:105] /*v[354:361]*/
	v_wmma_f32_16x16x32_bf16 v[74:81] /*v[330:337]*/, v[40:47] /*v[808:815]*/, v[68:75] /*v[580:587]*/, v[74:81] /*v[330:337]*/
	v_wmma_f32_16x16x32_bf16 v[42:49] /*v[298:305]*/, v[32:39] /*v[800:807]*/, v[68:75] /*v[580:587]*/, v[42:49] /*v[298:305]*/
	v_wmma_f32_16x16x32_bf16 v[34:41] /*v[290:297]*/, v[24:31] /*v[792:799]*/, v[68:75] /*v[580:587]*/, v[34:41] /*v[290:297]*/
	s_set_vgpr_msb 0x5b5a
	v_wmma_f32_16x16x32_bf16 v[26:33] /*v[282:289]*/, v[132:139] /*v[644:651]*/, v[68:75] /*v[580:587]*/, v[26:33] /*v[282:289]*/
	v_wmma_f32_16x16x32_bf16 v[18:25] /*v[274:281]*/, v[124:131] /*v[636:643]*/, v[68:75] /*v[580:587]*/, v[18:25] /*v[274:281]*/
	s_set_vgpr_msb 0x5a0a
	v_wmma_f32_16x16x32_bf16 v[250:257], v[116:123] /*v[628:635]*/, v[68:75] /*v[580:587]*/, v[250:257]
	v_wmma_f32_16x16x32_bf16 v[210:217], v[108:115] /*v[620:627]*/, v[68:75] /*v[580:587]*/, v[210:217]
	s_set_vgpr_msb 0xa5a
	v_wmma_f32_16x16x32_bf16 v[50:57] /*v[306:313]*/, v[108:115] /*v[620:627]*/, v[76:83] /*v[588:595]*/, v[50:57] /*v[306:313]*/
	v_wmma_f32_16x16x32_bf16 v[58:65] /*v[314:321]*/, v[116:123] /*v[628:635]*/, v[76:83] /*v[588:595]*/, v[58:65] /*v[314:321]*/
	v_wmma_f32_16x16x32_bf16 v[66:73] /*v[322:329]*/, v[124:131] /*v[636:643]*/, v[76:83] /*v[588:595]*/, v[66:73] /*v[322:329]*/
	v_wmma_f32_16x16x32_bf16 v[90:97] /*v[346:353]*/, v[132:139] /*v[644:651]*/, v[76:83] /*v[588:595]*/, v[90:97] /*v[346:353]*/
	s_set_vgpr_msb 0x5a5b
	v_wmma_f32_16x16x32_bf16 v[106:113] /*v[362:369]*/, v[24:31] /*v[792:799]*/, v[76:83] /*v[588:595]*/, v[106:113] /*v[362:369]*/
	v_wmma_f32_16x16x32_bf16 v[114:121] /*v[370:377]*/, v[32:39] /*v[800:807]*/, v[76:83] /*v[588:595]*/, v[114:121] /*v[370:377]*/
	v_wmma_f32_16x16x32_bf16 v[130:137] /*v[386:393]*/, v[40:47] /*v[808:815]*/, v[76:83] /*v[588:595]*/, v[130:137] /*v[386:393]*/
	v_wmma_f32_16x16x32_bf16 v[138:145] /*v[394:401]*/, v[48:55] /*v[816:823]*/, v[76:83] /*v[588:595]*/, v[138:145] /*v[394:401]*/
	v_wmma_f32_16x16x32_bf16 v[226:233] /*v[482:489]*/, v[48:55] /*v[816:823]*/, v[84:91] /*v[596:603]*/, v[226:233] /*v[482:489]*/
	v_wmma_f32_16x16x32_bf16 v[194:201] /*v[450:457]*/, v[40:47] /*v[808:815]*/, v[84:91] /*v[596:603]*/, v[194:201] /*v[450:457]*/
	v_wmma_f32_16x16x32_bf16 v[170:177] /*v[426:433]*/, v[32:39] /*v[800:807]*/, v[84:91] /*v[596:603]*/, v[170:177] /*v[426:433]*/
	v_wmma_f32_16x16x32_bf16 v[162:169] /*v[418:425]*/, v[24:31] /*v[792:799]*/, v[84:91] /*v[596:603]*/, v[162:169] /*v[418:425]*/
	s_set_vgpr_msb 0x5b5a
	v_wmma_f32_16x16x32_bf16 v[154:161] /*v[410:417]*/, v[132:139] /*v[644:651]*/, v[84:91] /*v[596:603]*/, v[154:161] /*v[410:417]*/
	v_wmma_f32_16x16x32_bf16 v[146:153] /*v[402:409]*/, v[124:131] /*v[636:643]*/, v[84:91] /*v[596:603]*/, v[146:153] /*v[402:409]*/
	v_wmma_f32_16x16x32_bf16 v[122:129] /*v[378:385]*/, v[116:123] /*v[628:635]*/, v[84:91] /*v[596:603]*/, v[122:129] /*v[378:385]*/
	v_wmma_f32_16x16x32_bf16 v[82:89] /*v[338:345]*/, v[108:115] /*v[620:627]*/, v[84:91] /*v[596:603]*/, v[82:89] /*v[338:345]*/
	v_wmma_f32_16x16x32_bf16 v[178:185] /*v[434:441]*/, v[108:115] /*v[620:627]*/, v[92:99] /*v[604:611]*/, v[178:185] /*v[434:441]*/
	v_wmma_f32_16x16x32_bf16 v[186:193] /*v[442:449]*/, v[116:123] /*v[628:635]*/, v[92:99] /*v[604:611]*/, v[186:193] /*v[442:449]*/
	v_wmma_f32_16x16x32_bf16 v[202:209] /*v[458:465]*/, v[124:131] /*v[636:643]*/, v[92:99] /*v[604:611]*/, v[202:209] /*v[458:465]*/
	v_wmma_f32_16x16x32_bf16 v[210:217] /*v[466:473]*/, v[132:139] /*v[644:651]*/, v[92:99] /*v[604:611]*/, v[210:217] /*v[466:473]*/
	s_set_vgpr_msb 0x5a5b
	v_wmma_f32_16x16x32_bf16 v[218:225] /*v[474:481]*/, v[24:31] /*v[792:799]*/, v[92:99] /*v[604:611]*/, v[218:225] /*v[474:481]*/
	v_wmma_f32_16x16x32_bf16 v[234:241] /*v[490:497]*/, v[32:39] /*v[800:807]*/, v[92:99] /*v[604:611]*/, v[234:241] /*v[490:497]*/
	v_wmma_f32_16x16x32_bf16 v[242:249] /*v[498:505]*/, v[40:47] /*v[808:815]*/, v[92:99] /*v[604:611]*/, v[242:249] /*v[498:505]*/
	v_wmma_f32_16x16x32_bf16 v[250:257] /*v[506:513]*/, v[48:55] /*v[816:823]*/, v[92:99] /*v[604:611]*/, v[250:257] /*v[506:513]*/
	s_set_vgpr_msb 0x5b0b
	v_wmma_f32_16x16x32_bf16 v[106:113], v[48:55] /*v[816:823]*/, v[100:107] /*v[612:619]*/, v[106:113]
	v_wmma_f32_16x16x32_bf16 v[90:97], v[40:47] /*v[808:815]*/, v[100:107] /*v[612:619]*/, v[90:97]
	v_wmma_f32_16x16x32_bf16 v[66:73], v[32:39] /*v[800:807]*/, v[100:107] /*v[612:619]*/, v[66:73]
	v_wmma_f32_16x16x32_bf16 v[50:57], v[24:31] /*v[792:799]*/, v[100:107] /*v[612:619]*/, v[50:57]
	s_set_vgpr_msb 0xb0a
	v_wmma_f32_16x16x32_bf16 v[34:41], v[132:139] /*v[644:651]*/, v[100:107] /*v[612:619]*/, v[34:41]
	v_wmma_f32_16x16x32_bf16 v[26:33], v[124:131] /*v[636:643]*/, v[100:107] /*v[612:619]*/, v[26:33]
	v_wmma_f32_16x16x32_bf16 v[18:25], v[116:123] /*v[628:635]*/, v[100:107] /*v[612:619]*/, v[18:25]
	v_wmma_f32_16x16x32_bf16 v[2:9], v[108:115] /*v[620:627]*/, v[100:107] /*v[612:619]*/, v[2:9]
	s_wait_dscnt 0x0
	v_wmma_f32_16x16x32_bf16 v[10:17], v[196:203] /*v[708:715]*/, v[148:155] /*v[660:667]*/, v[10:17]
	s_lshl_b32 s0, s36, 1
	s_wait_tensorcnt 0x0
	s_barrier_signal -1
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa03
	v_lshl_or_b32 v0, v3 /*v771*/, 4, s0
	s_mul_u64 s[0:1], s[30:31], s[28:29]
	s_lshl_b64 s[2:3], s[2:3], 1
	s_set_vgpr_msb 0x30a
	v_wmma_f32_16x16x32_bf16 v[42:49], v[26:33] /*v[538:545]*/, v[148:155] /*v[660:667]*/, v[42:49]
	v_nop
	v_nop
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v17, v16, v17
	v_cvt_pk_bf16_f32 v16, v14, v15
	v_cvt_pk_bf16_f32 v14, v10, v11
	s_set_vgpr_msb 3
	v_lshl_or_b32 v10, v2 /*v770*/, 9, v0
	s_set_vgpr_msb 0x300
	v_cvt_pk_bf16_f32 v15, v12, v13
	s_set_vgpr_msb 10
	v_lshl_or_b32 v0, v43 /*v555*/, 9, v0
	s_lshl_b64 s[0:1], s[0:1], 1
	v_wmma_f32_16x16x32_bf16 v[58:65], v[204:211] /*v[716:723]*/, v[148:155] /*v[660:667]*/, v[58:65]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v13, v48, v49
	v_dual_add_nc_u32 v48, 0, v10 :: v_dual_add_nc_u32 v0, 0, v0
	v_cvt_pk_bf16_f32 v12, v46, v47
	v_cvt_pk_bf16_f32 v11, v44, v45
	v_cvt_pk_bf16_f32 v10, v42, v43
	s_set_vgpr_msb 10
	s_barrier_wait -1
	v_wmma_f32_16x16x32_bf16 v[82:89], v[10:17] /*v[522:529]*/, v[148:155] /*v[660:667]*/, v[82:89]
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0xa00
	ds_store_b128 v48, v[14:17]
	ds_store_b128 v48, v[10:13] offset:32
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v15, v64, v65
	v_cvt_pk_bf16_f32 v14, v62, v63
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v13, v60, v61
	v_cvt_pk_bf16_f32 v12, v58, v59
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[98:105], v[212:219] /*v[724:731]*/, v[148:155] /*v[660:667]*/, v[98:105]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v45, v88, v89
	v_cvt_pk_bf16_f32 v44, v86, v87
	v_cvt_pk_bf16_f32 v43, v84, v85
	v_cvt_pk_bf16_f32 v42, v82, v83
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v48, v[12:15] offset:64
	ds_store_b128 v48, v[42:45] offset:96
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[114:121], v[18:25] /*v[530:537]*/, v[148:155] /*v[660:667]*/, v[114:121]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v13, v104, v105
	v_cvt_pk_bf16_f32 v12, v102, v103
	v_cvt_pk_bf16_f32 v11, v100, v101
	v_cvt_pk_bf16_f32 v10, v98, v99
	s_cmp_lg_u32 s28, 0x80000000
	s_add_nc_u64 s[0:1], s[4:5], s[0:1]
	s_cselect_b32 s13, s29, 0
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[130:137], v[220:227] /*v[732:739]*/, v[148:155] /*v[660:667]*/, v[130:137]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v17, v120, v121
	v_cvt_pk_bf16_f32 v16, v118, v119
	v_cvt_pk_bf16_f32 v15, v116, v117
	v_cvt_pk_bf16_f32 v14, v114, v115
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v48, v[10:13] offset:128
	ds_store_b128 v48, v[14:17] offset:160
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[138:145], v[34:41] /*v[546:553]*/, v[148:155] /*v[660:667]*/, v[138:145]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v13, v136, v137
	v_cvt_pk_bf16_f32 v12, v134, v135
	v_cvt_pk_bf16_f32 v11, v132, v133
	v_cvt_pk_bf16_f32 v10, v130, v131
	s_cselect_b32 s12, s28, 0x100
	s_bfe_u32 s6, ttmp8, 0x50019
	s_add_nc_u64 s[0:1], s[0:1], s[2:3]
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[234:241], v[34:41] /*v[546:553]*/, v[140:147] /*v[652:659]*/, v[234:241]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v17, v144, v145
	v_cvt_pk_bf16_f32 v16, v142, v143
	v_cvt_pk_bf16_f32 v15, v140, v141
	v_cvt_pk_bf16_f32 v14, v138, v139
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v48, v[10:13] offset:192
	ds_store_b128 v48, v[14:17] offset:224
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[194:201], v[220:227] /*v[732:739]*/, v[140:147] /*v[652:659]*/, v[194:201]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v13, v240, v241
	v_cvt_pk_bf16_f32 v12, v238, v239
	v_cvt_pk_bf16_f32 v11, v236, v237
	v_cvt_pk_bf16_f32 v10, v234, v235
	s_and_b32 s9, s6, 3
	s_mov_b32 s8, 1
	s_lshl_b32 s4, s9, 6
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[170:177], v[18:25] /*v[530:537]*/, v[140:147] /*v[652:659]*/, v[170:177]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v17, v200, v201
	v_cvt_pk_bf16_f32 v16, v198, v199
	v_cvt_pk_bf16_f32 v15, v196, v197
	v_cvt_pk_bf16_f32 v14, v194, v195
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v48, v[10:13] offset:8416
	ds_store_b128 v48, v[14:17] offset:8384
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[162:169], v[212:219] /*v[724:731]*/, v[140:147] /*v[652:659]*/, v[162:169]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v13, v176, v177
	v_cvt_pk_bf16_f32 v12, v174, v175
	v_cvt_pk_bf16_f32 v11, v172, v173
	v_cvt_pk_bf16_f32 v10, v170, v171
	s_sub_co_i32 s2, s33, s4
	s_lshl_b32 s6, s9, 7
	s_max_i32 s4, s2, 0
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[154:161], v[10:17] /*v[522:529]*/, v[140:147] /*v[652:659]*/, v[154:161]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v17, v168, v169
	v_cvt_pk_bf16_f32 v16, v166, v167
	v_cvt_pk_bf16_f32 v15, v164, v165
	v_cvt_pk_bf16_f32 v14, v162, v163
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v48, v[10:13] offset:8352
	ds_store_b128 v48, v[14:17] offset:8320
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[146:153], v[204:211] /*v[716:723]*/, v[140:147] /*v[652:659]*/, v[146:153]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v13, v160, v161
	v_cvt_pk_bf16_f32 v12, v158, v159
	v_cvt_pk_bf16_f32 v11, v156, v157
	v_cvt_pk_bf16_f32 v10, v154, v155
	s_mul_u64 s[2:3], s[12:13], s[6:7]
	s_set_vgpr_msb 0x80
	v_mov_b32_e32 v43 /*v555*/, s4
	s_add_nc_u64 s[10:11], s[2:3], s[0:1]
	s_set_vgpr_msb 0x800a
	v_wmma_f32_16x16x32_bf16 v[122:129], v[26:33] /*v[538:545]*/, v[140:147] /*v[652:659]*/, v[122:129]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v17, v152, v153
	v_cvt_pk_bf16_f32 v16, v150, v151
	v_cvt_pk_bf16_f32 v15, v148, v149
	v_cvt_pk_bf16_f32 v14, v146, v147
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v48, v[10:13] offset:8288
	ds_store_b128 v48, v[14:17] offset:8256
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[74:81], v[196:203] /*v[708:715]*/, v[140:147] /*v[652:659]*/, v[74:81]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v13, v128, v129
	v_cvt_pk_bf16_f32 v12, v126, v127
	v_cvt_pk_bf16_f32 v11, v124, v125
	v_cvt_pk_bf16_f32 v10, v122, v123
	s_lshr_b32 s0, s4, 16
	s_and_b32 s1, s13, 0xffff
	s_bitset1_b32 s0, 24
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[178:185], v[196:203] /*v[708:715]*/, v[156:163] /*v[668:675]*/, v[178:185]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v17, v80, v81
	v_cvt_pk_bf16_f32 v16, v78, v79
	v_cvt_pk_bf16_f32 v15, v76, v77
	v_cvt_pk_bf16_f32 v14, v74, v75
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v48, v[10:13] offset:8224
	ds_store_b128 v48, v[14:17] offset:8192
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[186:193], v[26:33] /*v[538:545]*/, v[156:163] /*v[668:675]*/, v[186:193]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v13, v184, v185
	v_cvt_pk_bf16_f32 v12, v182, v183
	v_cvt_pk_bf16_f32 v11, v180, v181
	v_cvt_pk_bf16_f32 v10, v178, v179
	s_lshl_b32 s5, s9, 15
	s_bitset1_b32 s11, 31
	s_add_co_i32 s9, s5, 0
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[202:209], v[204:211] /*v[716:723]*/, v[156:163] /*v[668:675]*/, v[202:209]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v17, v192, v193
	v_cvt_pk_bf16_f32 v16, v190, v191
	v_cvt_pk_bf16_f32 v15, v188, v189
	v_cvt_pk_bf16_f32 v14, v186, v187
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v48, v[10:13] offset:16384
	ds_store_b128 v48, v[14:17] offset:16416
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[218:225], v[10:17] /*v[522:529]*/, v[156:163] /*v[668:675]*/, v[218:225]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v13, v208, v209
	v_cvt_pk_bf16_f32 v12, v206, v207
	v_cvt_pk_bf16_f32 v11, v204, v205
	v_cvt_pk_bf16_f32 v10, v202, v203
	s_mov_b32 s4, 64
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v224, v225
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[226:233], v[212:219] /*v[724:731]*/, v[156:163] /*v[668:675]*/, v[226:233]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v16, v222, v223
	v_cvt_pk_bf16_f32 v15, v220, v221
	v_cvt_pk_bf16_f32 v14, v218, v219
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v48, v[10:13] offset:16448
	ds_store_b128 v48, v[14:17] offset:16480
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[242:249], v[18:25] /*v[530:537]*/, v[156:163] /*v[668:675]*/, v[242:249]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v13, v232, v233
	v_cvt_pk_bf16_f32 v12, v230, v231
	v_cvt_pk_bf16_f32 v11, v228, v229
	v_cvt_pk_bf16_f32 v10, v226, v227
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v248, v249
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[2:9] /*v[258:265]*/, v[220:227] /*v[732:739]*/, v[156:163] /*v[668:675]*/, v[2:9] /*v[258:265]*/
	s_set_vgpr_msb 0x5a00
	v_cvt_pk_bf16_f32 v16, v246, v247
	v_cvt_pk_bf16_f32 v15, v244, v245
	v_cvt_pk_bf16_f32 v14, v242, v243
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v48, v[10:13] offset:16512
	ds_store_b128 v48, v[14:17] offset:16544
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[10:17] /*v[266:273]*/, v[34:41] /*v[546:553]*/, v[156:163] /*v[668:675]*/, v[10:17] /*v[266:273]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v13, v8 /*v264*/, v9 /*v265*/
	v_cvt_pk_bf16_f32 v12, v6 /*v262*/, v7 /*v263*/
	v_cvt_pk_bf16_f32 v11, v4 /*v260*/, v5 /*v261*/
	v_cvt_pk_bf16_f32 v10, v2 /*v258*/, v3 /*v259*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v16 /*v272*/, v17 /*v273*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[98:105] /*v[354:361]*/, v[34:41] /*v[546:553]*/, v[164:171] /*v[676:683]*/, v[98:105] /*v[354:361]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v16, v14 /*v270*/, v15 /*v271*/
	v_cvt_pk_bf16_f32 v15, v12 /*v268*/, v13 /*v269*/
	v_cvt_pk_bf16_f32 v14, v10 /*v266*/, v11 /*v267*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:16576
	ds_store_b128 v48, v[14:17] offset:16608
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[74:81] /*v[330:337]*/, v[220:227] /*v[732:739]*/, v[164:171] /*v[676:683]*/, v[74:81] /*v[330:337]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v13, v104 /*v360*/, v105 /*v361*/
	v_cvt_pk_bf16_f32 v12, v102 /*v358*/, v103 /*v359*/
	v_cvt_pk_bf16_f32 v11, v100 /*v356*/, v101 /*v357*/
	v_cvt_pk_bf16_f32 v10, v98 /*v354*/, v99 /*v355*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v80 /*v336*/, v81 /*v337*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[42:49] /*v[298:305]*/, v[18:25] /*v[530:537]*/, v[164:171] /*v[676:683]*/, v[42:49] /*v[298:305]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v16, v78 /*v334*/, v79 /*v335*/
	v_cvt_pk_bf16_f32 v15, v76 /*v332*/, v77 /*v333*/
	v_cvt_pk_bf16_f32 v14, v74 /*v330*/, v75 /*v331*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:24800
	ds_store_b128 v48, v[14:17] offset:24768
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[34:41] /*v[290:297]*/, v[212:219] /*v[724:731]*/, v[164:171] /*v[676:683]*/, v[34:41] /*v[290:297]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v13, v48 /*v304*/, v49 /*v305*/
	v_cvt_pk_bf16_f32 v12, v46 /*v302*/, v47 /*v303*/
	v_cvt_pk_bf16_f32 v11, v44 /*v300*/, v45 /*v301*/
	v_cvt_pk_bf16_f32 v10, v42 /*v298*/, v43 /*v299*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v40 /*v296*/, v41 /*v297*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[26:33] /*v[282:289]*/, v[10:17] /*v[522:529]*/, v[164:171] /*v[676:683]*/, v[26:33] /*v[282:289]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v16, v38 /*v294*/, v39 /*v295*/
	v_cvt_pk_bf16_f32 v15, v36 /*v292*/, v37 /*v293*/
	v_cvt_pk_bf16_f32 v14, v34 /*v290*/, v35 /*v291*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:24736
	ds_store_b128 v48, v[14:17] offset:24704
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[18:25] /*v[274:281]*/, v[204:211] /*v[716:723]*/, v[164:171] /*v[676:683]*/, v[18:25] /*v[274:281]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v13, v32 /*v288*/, v33 /*v289*/
	v_cvt_pk_bf16_f32 v12, v30 /*v286*/, v31 /*v287*/
	v_cvt_pk_bf16_f32 v11, v28 /*v284*/, v29 /*v285*/
	v_cvt_pk_bf16_f32 v10, v26 /*v282*/, v27 /*v283*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v24 /*v280*/, v25 /*v281*/
	s_set_vgpr_msb 0x50a
	v_wmma_f32_16x16x32_bf16 v[250:257], v[26:33] /*v[538:545]*/, v[164:171] /*v[676:683]*/, v[250:257]
	s_set_vgpr_msb 0xa05
	v_cvt_pk_bf16_f32 v16, v22 /*v278*/, v23 /*v279*/
	v_cvt_pk_bf16_f32 v15, v20 /*v276*/, v21 /*v277*/
	v_cvt_pk_bf16_f32 v14, v18 /*v274*/, v19 /*v275*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:24672
	ds_store_b128 v48, v[14:17] offset:24640
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[210:217], v[196:203] /*v[708:715]*/, v[164:171] /*v[676:683]*/, v[210:217]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa05
	v_cvt_pk_bf16_f32 v13, v0 /*v256*/, v1 /*v257*/
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v12, v254, v255
	v_cvt_pk_bf16_f32 v11, v252, v253
	v_cvt_pk_bf16_f32 v10, v250, v251
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v216, v217
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[50:57] /*v[306:313]*/, v[196:203] /*v[708:715]*/, v[172:179] /*v[684:691]*/, v[50:57] /*v[306:313]*/
	s_set_vgpr_msb 0x5a00
	v_cvt_pk_bf16_f32 v16, v214, v215
	v_cvt_pk_bf16_f32 v15, v212, v213
	v_cvt_pk_bf16_f32 v14, v210, v211
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v48, v[10:13] offset:24608
	ds_store_b128 v48, v[14:17] offset:24576
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[58:65] /*v[314:321]*/, v[26:33] /*v[538:545]*/, v[172:179] /*v[684:691]*/, v[58:65] /*v[314:321]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v13, v56 /*v312*/, v57 /*v313*/
	v_cvt_pk_bf16_f32 v12, v54 /*v310*/, v55 /*v311*/
	v_cvt_pk_bf16_f32 v11, v52 /*v308*/, v53 /*v309*/
	v_cvt_pk_bf16_f32 v10, v50 /*v306*/, v51 /*v307*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v64 /*v320*/, v65 /*v321*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[66:73] /*v[322:329]*/, v[204:211] /*v[716:723]*/, v[172:179] /*v[684:691]*/, v[66:73] /*v[322:329]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v16, v62 /*v318*/, v63 /*v319*/
	v_cvt_pk_bf16_f32 v15, v60 /*v316*/, v61 /*v317*/
	v_cvt_pk_bf16_f32 v14, v58 /*v314*/, v59 /*v315*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:32768
	ds_store_b128 v48, v[14:17] offset:32800
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[90:97] /*v[346:353]*/, v[10:17] /*v[522:529]*/, v[172:179] /*v[684:691]*/, v[90:97] /*v[346:353]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v13, v72 /*v328*/, v73 /*v329*/
	v_cvt_pk_bf16_f32 v12, v70 /*v326*/, v71 /*v327*/
	v_cvt_pk_bf16_f32 v11, v68 /*v324*/, v69 /*v325*/
	v_cvt_pk_bf16_f32 v10, v66 /*v322*/, v67 /*v323*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v96 /*v352*/, v97 /*v353*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[106:113] /*v[362:369]*/, v[212:219] /*v[724:731]*/, v[172:179] /*v[684:691]*/, v[106:113] /*v[362:369]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v16, v94 /*v350*/, v95 /*v351*/
	v_cvt_pk_bf16_f32 v15, v92 /*v348*/, v93 /*v349*/
	v_cvt_pk_bf16_f32 v14, v90 /*v346*/, v91 /*v347*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:32832
	ds_store_b128 v48, v[14:17] offset:32864
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[114:121] /*v[370:377]*/, v[18:25] /*v[530:537]*/, v[172:179] /*v[684:691]*/, v[114:121] /*v[370:377]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v13, v112 /*v368*/, v113 /*v369*/
	v_cvt_pk_bf16_f32 v12, v110 /*v366*/, v111 /*v367*/
	v_cvt_pk_bf16_f32 v11, v108 /*v364*/, v109 /*v365*/
	v_cvt_pk_bf16_f32 v10, v106 /*v362*/, v107 /*v363*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v120 /*v376*/, v121 /*v377*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[130:137] /*v[386:393]*/, v[220:227] /*v[732:739]*/, v[172:179] /*v[684:691]*/, v[130:137] /*v[386:393]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v16, v118 /*v374*/, v119 /*v375*/
	v_cvt_pk_bf16_f32 v15, v116 /*v372*/, v117 /*v373*/
	v_cvt_pk_bf16_f32 v14, v114 /*v370*/, v115 /*v371*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:32896
	ds_store_b128 v48, v[14:17] offset:32928
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[138:145] /*v[394:401]*/, v[34:41] /*v[546:553]*/, v[172:179] /*v[684:691]*/, v[138:145] /*v[394:401]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v13, v136 /*v392*/, v137 /*v393*/
	v_cvt_pk_bf16_f32 v12, v134 /*v390*/, v135 /*v391*/
	v_cvt_pk_bf16_f32 v11, v132 /*v388*/, v133 /*v389*/
	v_cvt_pk_bf16_f32 v10, v130 /*v386*/, v131 /*v387*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v144 /*v400*/, v145 /*v401*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[226:233] /*v[482:489]*/, v[34:41] /*v[546:553]*/, v[180:187] /*v[692:699]*/, v[226:233] /*v[482:489]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v16, v142 /*v398*/, v143 /*v399*/
	v_cvt_pk_bf16_f32 v15, v140 /*v396*/, v141 /*v397*/
	v_cvt_pk_bf16_f32 v14, v138 /*v394*/, v139 /*v395*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:32960
	ds_store_b128 v48, v[14:17] offset:32992
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[194:201] /*v[450:457]*/, v[220:227] /*v[732:739]*/, v[180:187] /*v[692:699]*/, v[194:201] /*v[450:457]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v13, v232 /*v488*/, v233 /*v489*/
	v_cvt_pk_bf16_f32 v12, v230 /*v486*/, v231 /*v487*/
	v_cvt_pk_bf16_f32 v11, v228 /*v484*/, v229 /*v485*/
	v_cvt_pk_bf16_f32 v10, v226 /*v482*/, v227 /*v483*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v200 /*v456*/, v201 /*v457*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[170:177] /*v[426:433]*/, v[18:25] /*v[530:537]*/, v[180:187] /*v[692:699]*/, v[170:177] /*v[426:433]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v16, v198 /*v454*/, v199 /*v455*/
	v_cvt_pk_bf16_f32 v15, v196 /*v452*/, v197 /*v453*/
	v_cvt_pk_bf16_f32 v14, v194 /*v450*/, v195 /*v451*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:41184
	ds_store_b128 v48, v[14:17] offset:41152
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[162:169] /*v[418:425]*/, v[212:219] /*v[724:731]*/, v[180:187] /*v[692:699]*/, v[162:169] /*v[418:425]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v13, v176 /*v432*/, v177 /*v433*/
	v_cvt_pk_bf16_f32 v12, v174 /*v430*/, v175 /*v431*/
	v_cvt_pk_bf16_f32 v11, v172 /*v428*/, v173 /*v429*/
	v_cvt_pk_bf16_f32 v10, v170 /*v426*/, v171 /*v427*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v168 /*v424*/, v169 /*v425*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[154:161] /*v[410:417]*/, v[10:17] /*v[522:529]*/, v[180:187] /*v[692:699]*/, v[154:161] /*v[410:417]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v16, v166 /*v422*/, v167 /*v423*/
	v_cvt_pk_bf16_f32 v15, v164 /*v420*/, v165 /*v421*/
	v_cvt_pk_bf16_f32 v14, v162 /*v418*/, v163 /*v419*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:41120
	ds_store_b128 v48, v[14:17] offset:41088
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[146:153] /*v[402:409]*/, v[204:211] /*v[716:723]*/, v[180:187] /*v[692:699]*/, v[146:153] /*v[402:409]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v13, v160 /*v416*/, v161 /*v417*/
	v_cvt_pk_bf16_f32 v12, v158 /*v414*/, v159 /*v415*/
	v_cvt_pk_bf16_f32 v11, v156 /*v412*/, v157 /*v413*/
	v_cvt_pk_bf16_f32 v10, v154 /*v410*/, v155 /*v411*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v152 /*v408*/, v153 /*v409*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[122:129] /*v[378:385]*/, v[26:33] /*v[538:545]*/, v[180:187] /*v[692:699]*/, v[122:129] /*v[378:385]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v16, v150 /*v406*/, v151 /*v407*/
	v_cvt_pk_bf16_f32 v15, v148 /*v404*/, v149 /*v405*/
	v_cvt_pk_bf16_f32 v14, v146 /*v402*/, v147 /*v403*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:41056
	ds_store_b128 v48, v[14:17] offset:41024
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[82:89] /*v[338:345]*/, v[196:203] /*v[708:715]*/, v[180:187] /*v[692:699]*/, v[82:89] /*v[338:345]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v13, v128 /*v384*/, v129 /*v385*/
	v_cvt_pk_bf16_f32 v12, v126 /*v382*/, v127 /*v383*/
	v_cvt_pk_bf16_f32 v11, v124 /*v380*/, v125 /*v381*/
	v_cvt_pk_bf16_f32 v10, v122 /*v378*/, v123 /*v379*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v88 /*v344*/, v89 /*v345*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[178:185] /*v[434:441]*/, v[196:203] /*v[708:715]*/, v[188:195] /*v[700:707]*/, v[178:185] /*v[434:441]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v16, v86 /*v342*/, v87 /*v343*/
	v_cvt_pk_bf16_f32 v15, v84 /*v340*/, v85 /*v341*/
	v_cvt_pk_bf16_f32 v14, v82 /*v338*/, v83 /*v339*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:40992
	ds_store_b128 v48, v[14:17] offset:40960
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[186:193] /*v[442:449]*/, v[26:33] /*v[538:545]*/, v[188:195] /*v[700:707]*/, v[186:193] /*v[442:449]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v13, v184 /*v440*/, v185 /*v441*/
	v_cvt_pk_bf16_f32 v12, v182 /*v438*/, v183 /*v439*/
	v_cvt_pk_bf16_f32 v11, v180 /*v436*/, v181 /*v437*/
	v_cvt_pk_bf16_f32 v10, v178 /*v434*/, v179 /*v435*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v192 /*v448*/, v193 /*v449*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[202:209] /*v[458:465]*/, v[204:211] /*v[716:723]*/, v[188:195] /*v[700:707]*/, v[202:209] /*v[458:465]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v16, v190 /*v446*/, v191 /*v447*/
	v_cvt_pk_bf16_f32 v15, v188 /*v444*/, v189 /*v445*/
	v_cvt_pk_bf16_f32 v14, v186 /*v442*/, v187 /*v443*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:49152
	ds_store_b128 v48, v[14:17] offset:49184
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[210:217] /*v[466:473]*/, v[10:17] /*v[522:529]*/, v[188:195] /*v[700:707]*/, v[210:217] /*v[466:473]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v13, v208 /*v464*/, v209 /*v465*/
	v_cvt_pk_bf16_f32 v12, v206 /*v462*/, v207 /*v463*/
	v_cvt_pk_bf16_f32 v11, v204 /*v460*/, v205 /*v461*/
	v_cvt_pk_bf16_f32 v10, v202 /*v458*/, v203 /*v459*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v216 /*v472*/, v217 /*v473*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[218:225] /*v[474:481]*/, v[212:219] /*v[724:731]*/, v[188:195] /*v[700:707]*/, v[218:225] /*v[474:481]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v16, v214 /*v470*/, v215 /*v471*/
	v_cvt_pk_bf16_f32 v15, v212 /*v468*/, v213 /*v469*/
	v_cvt_pk_bf16_f32 v14, v210 /*v466*/, v211 /*v467*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:49216
	ds_store_b128 v48, v[14:17] offset:49248
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[234:241] /*v[490:497]*/, v[18:25] /*v[530:537]*/, v[188:195] /*v[700:707]*/, v[234:241] /*v[490:497]*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v13, v224 /*v480*/, v225 /*v481*/
	v_cvt_pk_bf16_f32 v12, v222 /*v478*/, v223 /*v479*/
	v_cvt_pk_bf16_f32 v11, v220 /*v476*/, v221 /*v477*/
	v_cvt_pk_bf16_f32 v10, v218 /*v474*/, v219 /*v475*/
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v17, v240 /*v496*/, v241 /*v497*/
	s_set_vgpr_msb 0x55a
	v_wmma_f32_16x16x32_bf16 v[242:249] /*v[498:505]*/, v[220:227] /*v[732:739]*/, v[188:195] /*v[700:707]*/, v[242:249] /*v[498:505]*/
	s_set_vgpr_msb 0x5a05
	v_cvt_pk_bf16_f32 v16, v238 /*v494*/, v239 /*v495*/
	v_cvt_pk_bf16_f32 v15, v236 /*v492*/, v237 /*v493*/
	v_cvt_pk_bf16_f32 v14, v234 /*v490*/, v235 /*v491*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:49280
	ds_store_b128 v48, v[14:17] offset:49312
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[2:9], v[196:203] /*v[708:715]*/, v[2:9] /*v[514:521]*/, v[2:9]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0xa05
	v_cvt_pk_bf16_f32 v13, v248 /*v504*/, v249 /*v505*/
	v_cvt_pk_bf16_f32 v12, v246 /*v502*/, v247 /*v503*/
	v_cvt_pk_bf16_f32 v11, v244 /*v500*/, v245 /*v501*/
	v_cvt_pk_bf16_f32 v10, v242 /*v498*/, v243 /*v499*/
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v9, v8, v9
	s_set_vgpr_msb 0x5a
	v_wmma_f32_16x16x32_bf16 v[250:257] /*v[506:513]*/, v[34:41] /*v[546:553]*/, v[188:195] /*v[700:707]*/, v[250:257] /*v[506:513]*/
	s_set_vgpr_msb 0x5a00
	v_cvt_pk_bf16_f32 v8, v6, v7
	v_cvt_pk_bf16_f32 v7, v4, v5
	v_cvt_pk_bf16_f32 v6, v2, v3
	s_wait_alu depctr_vm_vsrc(0)
	v_nop
	s_set_vgpr_msb 10
	v_cvt_pk_bf16_f32 v17, v0 /*v512*/, v1 /*v513*/
	v_wmma_f32_16x16x32_bf16 v[18:25], v[26:33] /*v[538:545]*/, v[2:9] /*v[514:521]*/, v[18:25]
	s_set_vgpr_msb 0xa05
	v_cvt_pk_bf16_f32 v16, v254 /*v510*/, v255 /*v511*/
	v_cvt_pk_bf16_f32 v15, v252 /*v508*/, v253 /*v509*/
	v_cvt_pk_bf16_f32 v14, v250 /*v506*/, v251 /*v507*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_store_b128 v48, v[10:13] offset:49344
	ds_store_b128 v48, v[14:17] offset:49376
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[26:33], v[204:211] /*v[716:723]*/, v[2:9] /*v[514:521]*/, v[26:33]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v5, v24, v25
	v_cvt_pk_bf16_f32 v4, v22, v23
	v_cvt_pk_bf16_f32 v3, v20, v21
	v_cvt_pk_bf16_f32 v2, v18, v19
	ds_store_b128 v0, v[6:9]
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v0, v[2:5] offset:32
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[34:41], v[10:17] /*v[522:529]*/, v[2:9] /*v[514:521]*/, v[34:41]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v5, v32, v33
	v_cvt_pk_bf16_f32 v4, v30, v31
	v_cvt_pk_bf16_f32 v3, v28, v29
	v_cvt_pk_bf16_f32 v2, v26, v27
	s_delay_alu instid0(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v9, v40, v41
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[50:57], v[212:219] /*v[724:731]*/, v[2:9] /*v[514:521]*/, v[50:57]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v8, v38, v39
	v_cvt_pk_bf16_f32 v7, v36, v37
	v_cvt_pk_bf16_f32 v6, v34, v35
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v13, v56, v57
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[66:73], v[18:25] /*v[530:537]*/, v[2:9] /*v[514:521]*/, v[66:73]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v12, v54, v55
	v_cvt_pk_bf16_f32 v11, v52, v53
	v_cvt_pk_bf16_f32 v10, v50, v51
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v17, v72, v73
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[90:97], v[220:227] /*v[732:739]*/, v[2:9] /*v[514:521]*/, v[90:97]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v16, v70, v71
	v_cvt_pk_bf16_f32 v15, v68, v69
	v_cvt_pk_bf16_f32 v14, v66, v67
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v21, v96, v97
	s_set_vgpr_msb 10
	v_wmma_f32_16x16x32_bf16 v[106:113], v[34:41] /*v[546:553]*/, v[2:9] /*v[514:521]*/, v[106:113]
	s_set_vgpr_msb 0xa00
	v_cvt_pk_bf16_f32 v20, v94, v95
	v_cvt_pk_bf16_f32 v19, v92, v93
	v_cvt_pk_bf16_f32 v18, v90, v91
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v25, v112, v113
	v_cvt_pk_bf16_f32 v24, v110, v111
	v_cvt_pk_bf16_f32 v23, v108, v109
	v_cvt_pk_bf16_f32 v22, v106, v107
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
		.amdhsa_next_free_vgpr 824
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
		.amdhsa_inst_pref_size 132
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

	.set kernel_grouped_nt_0.num_vgpr, 824
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
    .vgpr_count:     824
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.target:   amdgcn-amd-amdhsa--gfx1250
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
