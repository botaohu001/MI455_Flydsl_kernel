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
	s_load_b32 s34, s[0:1], 0x30 nv
	s_bfe_u32 s2, ttmp6, 0x4000c
	v_readfirstlane_b32 s42, v0
	s_add_co_i32 s2, s2, 1
	s_and_b32 s3, ttmp6, 15
	s_mul_i32 s2, ttmp9, s2
	s_getreg_b32 s4, hwreg(HW_REG_IB_STS2, 6, 4)
	s_add_co_i32 s5, s3, s2
	s_lshr_b32 s35, s42, 5
	s_mov_b32 s19, 0
	s_wait_kmcnt 0x0
	s_ashr_i32 s3, s22, 31
	s_mov_b32 s2, s22
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_lshl_b64 s[24:25], s[2:3], 1
	s_cmp_eq_u32 s4, 0
	s_cselect_b32 s2, ttmp9, s5
	s_mul_hi_i32 s3, s2, 0x88888889
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s3, s3, s2
	s_lshr_b32 s4, s3, 31
	s_ashr_i32 s3, s3, 7
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s3, s3, s4
	s_mul_i32 s12, s3, 0xf0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(SALU_CYCLE_1)
	s_cmp_lg_u32 s2, s12
	s_cselect_b32 s4, -1, 0
	s_cmp_lt_i32 s2, 0
	s_cselect_b32 s5, -1, 0
	s_and_b32 s4, s5, s4
	s_sub_co_ci_u32 s29, s3, 0
	s_sub_co_i32 s36, s2, s12
	s_lshl_b32 s3, s29, 4
	s_abs_i32 s2, s36
	s_sub_co_i32 s4, 0x44, s3
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
	s_movk_i32 s16, 0x80
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
	s_sub_co_i32 s0, s12, s0
	s_and_b32 s3, s3, s11
	s_add_co_i32 s0, s0, s10
	s_cmp_lg_u32 s3, 0
	s_sub_co_ci_u32 s0, s0, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_lshl_b32 s0, s0, 7
	s_sub_co_i32 s1, s1, s0
	s_add_co_i32 s2, s0, s2
	s_cmp_gt_i32 s1, 0
	v_med3_i32 v1, s1, 0, 0x80
	s_cselect_b32 s10, s2, 0
	s_mov_b32 s0, 1
	s_ashr_i32 s11, s10, 31
	s_cmp_eq_u32 s35, 0
	v_readfirstlane_b32 s33, v1
	s_mul_u64 s[2:3], s[24:25], s[10:11]
	s_cselect_b32 s39, -1, 0
	s_cmp_lg_u32 s35, 0
	s_add_nc_u64 s[6:7], s[6:7], s[2:3]
	s_cbranch_scc1 .LBB0_2
	s_cmp_lg_u32 s22, -2.0
	s_mov_b32 s1, s19
	s_cselect_b32 s17, s24, 0x80
	s_cselect_b32 s12, s25, 0
	s_max_i32 s13, s33, 0
	s_or_b32 s3, s7, 0x80000000
	s_lshl_b32 s14, s13, 16
	s_lshr_b32 s13, s13, 16
	s_mov_b32 s2, s6
	s_addk_co_i32 s14, 0x7fff
	s_or_b32 s15, s13, 0x800000
	s_and_b32 s18, s12, 0xffff
	s_mov_b32 s13, 0xffff0000
	s_mov_b32 s12, 0x7300000
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[0:3], s[12:19]
.LBB0_2:
	s_ashr_i32 s31, s23, 31
	s_mov_b32 s30, s23
	s_movk_i32 s16, 0xc0
	s_lshl_b64 s[26:27], s[30:31], 1
	s_cmp_lg_u32 s36, s38
	s_cselect_b32 s0, -1, 0
	s_cmp_lt_i32 s36, 0
	s_cselect_b32 s1, -1, 0
	s_cmp_gt_i32 s29, 4
	s_cselect_b32 s2, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s1, s1, s2
	s_and_b32 s0, s1, s0
	s_sub_co_ci_u32 s0, s37, 0
	s_ashr_i32 s29, s28, 31
	s_mul_i32 s2, s0, 0xc0
	s_mul_u64 s[36:37], s[28:29], 0xfd2000
	s_ashr_i32 s3, s2, 31
	s_sub_co_i32 s21, s21, s2
	s_add_nc_u64 s[0:1], s[8:9], s[36:37]
	s_cmp_eq_u32 s35, 1
	s_mul_u64 s[12:13], s[26:27], s[2:3]
	s_cselect_b32 s23, -1, 0
	s_cmp_lg_u32 s35, 1
	s_add_nc_u64 s[28:29], s[0:1], s[12:13]
	s_cbranch_scc1 .LBB0_4
	s_cmp_lg_u32 s30, -2.0
	s_mov_b32 s44, 1
	s_cselect_b32 s17, s26, 0x80
	s_cselect_b32 s0, s27, 0
	s_max_i32 s1, s21, 0
	s_or_b32 s47, s29, 0x80000000
	s_lshl_b32 s12, s1, 16
	s_lshr_b32 s1, s1, 16
	s_add_co_i32 s45, 0, 0x4800
	s_mov_b32 s46, s28
	s_or_b32 s14, s12, 0x7fff
	s_or_b32 s15, s1, 0x800000
	s_and_b32 s18, s0, 0xffff
	s_mov_b32 s13, 0xffff0000
	s_mov_b32 s12, 0x7300000
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[44:47], s[12:19]
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
	s_max_i32 s16, s33, 0
	s_movk_i32 s48, 0x80
	s_lshl_b32 s17, s16, 16
	s_lshr_b32 s16, s16, 16
	s_mov_b32 s51, 0
	s_bitset1_b32 s15, 31
	s_add_co_i32 s13, 0, 0xb400
	s_or_b32 s46, s17, 0x7fff
	s_or_b32 s47, s16, 0x800000
	s_and_b32 s50, s1, 0xffff
	s_mov_b32 s45, 0xffff0000
	s_mov_b32 s44, 0x7300000
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[12:15], s[44:51]
.LBB0_6:
	v_cndmask_b32_e64 v1, 0, 1, s23
	s_and_not1_b32 vcc_lo, exec_lo, s23
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_ne_u32_e64 s1, 1, v1
	s_cbranch_vccnz .LBB0_8
	s_cmp_lg_u32 s30, -2.0
	s_add_nc_u64 s[46:47], s[28:29], 0x80
	s_cselect_b32 s17, s26, 0x80
	s_cselect_b32 s12, s27, 0
	s_max_i32 s13, s21, 0
	s_bitset1_b32 s47, 31
	s_lshl_b32 s14, s13, 16
	s_lshr_b32 s13, s13, 16
	s_add_co_i32 s45, 0, 0xfc00
	s_mov_b32 s44, 1
	s_addk_co_i32 s14, 0x7fff
	s_or_b32 s15, s13, 0x800000
	s_and_b32 s18, s12, 0xffff
	s_movk_i32 s16, 0xc0
	s_mov_b32 s13, 0xffff0000
	s_mov_b32 s12, 0x7300000
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[44:47], s[12:19]
.LBB0_8:
	s_ashr_i32 s12, s20, 31
	s_set_vgpr_msb 64
	v_bfe_u32 v96 /*v352*/, v0, 4, 1
	s_lshr_b32 s12, s12, 26
	s_wait_tensorcnt 0x1
	s_add_co_i32 s12, s20, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 s13, s12, 0xffffffc0
	s_ashr_i32 s12, s12, 6
	s_cmp_lg_u32 s20, s13
	s_barrier_signal -1
	s_cselect_b32 s13, -1, 0
	s_cmp_lt_i32 s20, 0
	s_cselect_b32 s14, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 s13, s14, s13
	s_sub_co_ci_u32 s39, s12, 0
	s_bitcmp1_b32 s35, 0
	s_mov_b32 s12, 0
	s_cselect_b32 s38, 0x60, 0
	s_set_vgpr_msb 0x4004
	v_lshlrev_b32_e32 v198, 4, v96 /*v352*/
	s_set_vgpr_msb 0x450
	v_and_b32_e32 v119 /*v375*/, 15, v0
	s_cmp_gt_i32 s39, 2
	s_barrier_wait -1
	s_delay_alu instid0(VALU_DEP_1)
	v_and_or_b32 v97 /*v353*/, 0xffffffc0, s42, v119 /*v375*/
	s_set_vgpr_msb 0x5004
	s_delay_alu instid0(VALU_DEP_1)
	v_mul_lo_u32 v0, 0x90, v97 /*v353*/
	s_set_vgpr_msb 0x440
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u32_e32 v116 /*v372*/, v0, v198
	s_set_vgpr_msb 0x4004
	v_or_b32_e32 v197, s38, v119 /*v375*/
	s_set_vgpr_msb 0x440
	v_or_b32_e32 v122 /*v378*/, 0x4800, v198
	s_set_vgpr_msb 0x4000
	v_or_b32_e32 v199, 0x4840, v198
	s_set_vgpr_msb 0x44
	v_add_nc_u32_e32 v121 /*v377*/, 64, v116 /*v372*/
	v_add_nc_u32_e32 v120 /*v376*/, 0x60, v116 /*v372*/
	s_set_vgpr_msb 0x4400
	s_cbranch_scc1 .LBB0_10
	s_add_co_i32 s13, s38, 32
	s_add_co_i32 s14, s38, 48
	s_set_vgpr_msb 4
	v_dual_add_nc_u32 v192, 64, v116 /*v372*/ :: v_dual_bitop2_b32 v0, s13, v119 /*v375*/ bitop3:0x54
	v_or_b32_e32 v1, s14, v119 /*v375*/
	s_add_co_i32 s13, s38, 64
	s_add_co_i32 s14, s38, 0x50
	s_set_vgpr_msb 0x400
	v_or_b32_e32 v196, 0x4800, v198
	s_set_vgpr_msb 4
	v_or_b32_e32 v2, s13, v119 /*v375*/
	v_or_b32_e32 v3, s14, v119 /*v375*/
	s_max_i32 s13, s21, 0
	s_set_vgpr_msb 0x440
	v_mad_u32_u24 v106 /*v362*/, 0x90, v197, v199
	s_lshl_b32 s14, s13, 16
	v_mad_u32_u24 v117 /*v373*/, 0x90, v197, v196
	v_mad_u32_u24 v113 /*v369*/, 0x90, v0, v196
	v_mad_u32_u24 v108 /*v364*/, 0x90, v3, v196
	v_mad_u32_u24 v103 /*v359*/, 0x90, v0, v199
	v_mad_u32_u24 v98 /*v354*/, 0x90, v3, v199
	s_set_vgpr_msb 0x4000
	v_mov_b32_e32 v193, s14
	s_set_vgpr_msb 64
	v_mad_u32_u24 v112 /*v368*/, 0x90, v1, v196
	v_mad_u32_u24 v101 /*v357*/, 0x90, v1, v199
	s_set_vgpr_msb 0x4000
	v_mov_b32_e32 v194, s13
	s_set_vgpr_msb 64
	v_mad_u32_u24 v110 /*v366*/, 0x90, v2, v196
	v_mad_u32_u24 v99 /*v355*/, 0x90, v2, v199
	s_set_vgpr_msb 0x4044
	v_dual_add_nc_u32 v118 /*v374*/, 32, v117 /*v373*/ :: v_dual_add_nc_u32 v114 /*v370*/, 32, v112 /*v368*/
	s_delay_alu instid0(VALU_DEP_3)
	v_dual_add_nc_u32 v115 /*v371*/, 32, v113 /*v369*/ :: v_dual_add_nc_u32 v111 /*v367*/, 32, v110 /*v366*/
	v_dual_add_nc_u32 v109 /*v365*/, 32, v108 /*v364*/ :: v_dual_add_nc_u32 v107 /*v363*/, 32, v106 /*v362*/
	s_set_vgpr_msb 0x4404
	v_add_nc_u32_e32 v195, 0x60, v116 /*v372*/
	s_set_vgpr_msb 0x444
	v_dual_add_nc_u32 v105 /*v361*/, 32, v103 /*v359*/ :: v_dual_add_nc_u32 v104 /*v360*/, 32, v101 /*v357*/
	v_dual_add_nc_u32 v102 /*v358*/, 32, v99 /*v355*/ :: v_dual_add_nc_u32 v100 /*v356*/, 32, v98 /*v354*/
	s_set_vgpr_msb 0x4400
	s_branch .LBB0_11
.LBB0_10:
	s_mov_b32 s12, -1
.LBB0_11:
	v_mov_b32_e32 v15, 0
	s_add_co_i32 s35, s39, -2
	s_and_not1_b32 vcc_lo, exec_lo, s12
	s_mov_b32 s28, 1
	s_delay_alu instid0(VALU_DEP_1)
	v_dual_mov_b32 v14, v15 :: v_dual_mov_b32 v13, v15
	v_dual_mov_b32 v12, v15 :: v_dual_mov_b32 v11, v15
	v_dual_mov_b32 v10, v15 :: v_dual_mov_b32 v9, v15
	v_dual_mov_b32 v8, v15 :: v_dual_mov_b32 v55, v15
	v_dual_mov_b32 v54, v15 :: v_dual_mov_b32 v53, v15
	v_dual_mov_b32 v52, v15 :: v_dual_mov_b32 v51, v15
	v_dual_mov_b32 v50, v15 :: v_dual_mov_b32 v49, v15
	v_dual_mov_b32 v48, v15 :: v_dual_mov_b32 v71, v15
	v_dual_mov_b32 v70, v15 :: v_dual_mov_b32 v69, v15
	v_dual_mov_b32 v68, v15 :: v_dual_mov_b32 v67, v15
	v_dual_mov_b32 v66, v15 :: v_dual_mov_b32 v65, v15
	v_dual_mov_b32 v64, v15 :: v_dual_mov_b32 v87, v15
	v_dual_mov_b32 v86, v15 :: v_dual_mov_b32 v85, v15
	v_dual_mov_b32 v84, v15 :: v_dual_mov_b32 v83, v15
	v_dual_mov_b32 v82, v15 :: v_dual_mov_b32 v81, v15
	v_dual_mov_b32 v80, v15 :: v_dual_mov_b32 v95, v15
	v_dual_mov_b32 v94, v15 :: v_dual_mov_b32 v93, v15
	v_dual_mov_b32 v92, v15 :: v_dual_mov_b32 v91, v15
	v_dual_mov_b32 v90, v15 :: v_dual_mov_b32 v89, v15
	v_dual_mov_b32 v88, v15 :: v_dual_mov_b32 v111, v15
	v_dual_mov_b32 v110, v15 :: v_dual_mov_b32 v109, v15
	v_dual_mov_b32 v108, v15 :: v_dual_mov_b32 v107, v15
	v_dual_mov_b32 v106, v15 :: v_dual_mov_b32 v105, v15
	v_dual_mov_b32 v104, v15 :: v_dual_mov_b32 v79, v15
	v_dual_mov_b32 v78, v15 :: v_dual_mov_b32 v77, v15
	v_dual_mov_b32 v76, v15 :: v_dual_mov_b32 v75, v15
	v_dual_mov_b32 v74, v15 :: v_dual_mov_b32 v73, v15
	v_dual_mov_b32 v72, v15 :: v_dual_mov_b32 v103, v15
	v_dual_mov_b32 v102, v15 :: v_dual_mov_b32 v101, v15
	v_dual_mov_b32 v100, v15 :: v_dual_mov_b32 v99, v15
	v_dual_mov_b32 v98, v15 :: v_dual_mov_b32 v97, v15
	v_dual_mov_b32 v96, v15 :: v_dual_mov_b32 v119, v15
	v_dual_mov_b32 v118, v15 :: v_dual_mov_b32 v117, v15
	v_dual_mov_b32 v116, v15 :: v_dual_mov_b32 v115, v15
	v_dual_mov_b32 v114, v15 :: v_dual_mov_b32 v113, v15
	v_dual_mov_b32 v112, v15 :: v_dual_mov_b32 v127, v15
	v_dual_mov_b32 v126, v15 :: v_dual_mov_b32 v125, v15
	v_dual_mov_b32 v124, v15 :: v_dual_mov_b32 v123, v15
	v_dual_mov_b32 v122, v15 :: v_dual_mov_b32 v121, v15
	v_dual_mov_b32 v120, v15 :: v_dual_mov_b32 v143, v15
	v_dual_mov_b32 v142, v15 :: v_dual_mov_b32 v141, v15
	v_dual_mov_b32 v140, v15 :: v_dual_mov_b32 v139, v15
	v_dual_mov_b32 v138, v15 :: v_dual_mov_b32 v137, v15
	v_dual_mov_b32 v136, v15 :: v_dual_mov_b32 v167, v15
	v_dual_mov_b32 v166, v15 :: v_dual_mov_b32 v165, v15
	v_dual_mov_b32 v164, v15 :: v_dual_mov_b32 v163, v15
	v_dual_mov_b32 v162, v15 :: v_dual_mov_b32 v161, v15
	v_dual_mov_b32 v160, v15 :: v_dual_mov_b32 v135, v15
	v_dual_mov_b32 v134, v15 :: v_dual_mov_b32 v133, v15
	v_dual_mov_b32 v132, v15 :: v_dual_mov_b32 v131, v15
	v_dual_mov_b32 v130, v15 :: v_dual_mov_b32 v129, v15
	v_dual_mov_b32 v128, v15 :: v_dual_mov_b32 v151, v15
	v_dual_mov_b32 v150, v15 :: v_dual_mov_b32 v149, v15
	v_dual_mov_b32 v148, v15 :: v_dual_mov_b32 v147, v15
	v_dual_mov_b32 v146, v15 :: v_dual_mov_b32 v145, v15
	v_dual_mov_b32 v144, v15 :: v_dual_mov_b32 v159, v15
	v_dual_mov_b32 v158, v15 :: v_dual_mov_b32 v157, v15
	v_dual_mov_b32 v156, v15 :: v_dual_mov_b32 v155, v15
	v_dual_mov_b32 v154, v15 :: v_dual_mov_b32 v153, v15
	v_dual_mov_b32 v152, v15 :: v_dual_mov_b32 v175, v15
	v_dual_mov_b32 v174, v15 :: v_dual_mov_b32 v173, v15
	v_dual_mov_b32 v172, v15 :: v_dual_mov_b32 v171, v15
	v_dual_mov_b32 v170, v15 :: v_dual_mov_b32 v169, v15
	v_dual_mov_b32 v168, v15 :: v_dual_mov_b32 v183, v15
	v_dual_mov_b32 v182, v15 :: v_dual_mov_b32 v181, v15
	v_dual_mov_b32 v180, v15 :: v_dual_mov_b32 v179, v15
	v_dual_mov_b32 v178, v15 :: v_dual_mov_b32 v177, v15
	v_dual_mov_b32 v176, v15 :: v_dual_mov_b32 v191, v15
	v_dual_mov_b32 v190, v15 :: v_dual_mov_b32 v189, v15
	v_dual_mov_b32 v188, v15 :: v_dual_mov_b32 v187, v15
	v_dual_mov_b32 v186, v15 :: v_dual_mov_b32 v185, v15
	v_dual_mov_b32 v184, v15 :: v_dual_mov_b32 v7, v15
	v_dual_mov_b32 v6, v15 :: v_dual_mov_b32 v5, v15
	v_dual_mov_b32 v4, v15 :: v_dual_mov_b32 v3, v15
	v_dual_mov_b32 v2, v15 :: v_dual_mov_b32 v1, v15
	v_dual_mov_b32 v0, v15 :: v_dual_mov_b32 v23, v15
	v_dual_mov_b32 v22, v15 :: v_dual_mov_b32 v21, v15
	v_dual_mov_b32 v20, v15 :: v_dual_mov_b32 v19, v15
	v_dual_mov_b32 v18, v15 :: v_dual_mov_b32 v17, v15
	v_dual_mov_b32 v16, v15 :: v_dual_mov_b32 v31, v15
	v_dual_mov_b32 v30, v15 :: v_dual_mov_b32 v29, v15
	v_dual_mov_b32 v28, v15 :: v_dual_mov_b32 v27, v15
	v_dual_mov_b32 v26, v15 :: v_dual_mov_b32 v25, v15
	v_dual_mov_b32 v24, v15 :: v_dual_mov_b32 v39, v15
	v_dual_mov_b32 v38, v15 :: v_dual_mov_b32 v37, v15
	v_dual_mov_b32 v36, v15 :: v_dual_mov_b32 v35, v15
	v_dual_mov_b32 v34, v15 :: v_dual_mov_b32 v33, v15
	v_dual_mov_b32 v32, v15 :: v_dual_mov_b32 v47, v15
	v_dual_mov_b32 v46, v15 :: v_dual_mov_b32 v45, v15
	v_dual_mov_b32 v44, v15 :: v_dual_mov_b32 v43, v15
	v_dual_mov_b32 v42, v15 :: v_dual_mov_b32 v41, v15
	v_dual_mov_b32 v40, v15 :: v_dual_mov_b32 v63, v15
	v_dual_mov_b32 v62, v15 :: v_dual_mov_b32 v61, v15
	v_dual_mov_b32 v60, v15 :: v_dual_mov_b32 v59, v15
	v_dual_mov_b32 v58, v15 :: v_dual_mov_b32 v57, v15
	v_mov_b32_e32 v56, v15
	s_cbranch_vccnz .LBB0_19
	s_add_co_i32 s12, s38, 32
	s_add_co_i32 s13, s38, 48
	s_set_vgpr_msb 4
	v_dual_mov_b32 v8, 0 :: v_dual_bitop2_b32 v0, s12, v119 /*v375*/ bitop3:0x54
	v_or_b32_e32 v1, s13, v119 /*v375*/
	s_add_co_i32 s12, s38, 64
	s_add_co_i32 s13, s38, 0x50
	s_cmp_lg_u32 s22, -2.0
	v_dual_mov_b32 v10, v8 :: v_dual_bitop2_b32 v2, s12, v119 /*v375*/ bitop3:0x54
	v_dual_mov_b32 v11, v8 :: v_dual_bitop2_b32 v3, s13, v119 /*v375*/ bitop3:0x54
	s_cselect_b32 s17, s24, 0x80
	s_cselect_b32 s12, s25, 0
	s_max_i32 s13, s33, 0
	s_and_b32 s18, s12, 0xffff
	s_lshl_b32 s14, s13, 16
	s_lshr_b32 s13, s13, 16
	s_addk_co_i32 s14, 0x7fff
	s_or_b32 s15, s13, 0x800000
	s_cmp_lg_u32 s30, -2.0
	s_mul_u64 s[30:31], s[30:31], s[2:3]
	s_cselect_b32 s25, s26, 0x80
	s_cselect_b32 s20, s27, 0
	s_lshl_b64 s[30:31], s[30:31], 1
	s_set_vgpr_msb 0x450
	v_mad_u32_u24 v113 /*v369*/, 0x90, v0, v122 /*v378*/
	s_add_nc_u64 s[8:9], s[8:9], s[30:31]
	s_movk_i32 s31, 0x5120
	s_movk_i32 s30, 0x4820
	v_mad_u32_u24 v126 /*v382*/, 0x90, v197, s31
	s_movk_i32 s31, 0x5a20
	v_mad_u32_u24 v123 /*v379*/, 0x90, v197, s30
	s_movk_i32 s30, 0x5100
	v_mad_u32_u24 v128 /*v384*/, 0x90, v197, s31
	s_movk_i32 s31, 0x6320
	v_mad_u32_u24 v125 /*v381*/, 0x90, v197, s30
	s_movk_i32 s30, 0x5a00
	v_mad_u32_u24 v130 /*v386*/, 0x90, v197, s31
	s_movk_i32 s31, 0x6c20
	v_mad_u32_u24 v127 /*v383*/, 0x90, v197, s30
	s_movk_i32 s30, 0x6300
	v_mad_u32_u24 v132 /*v388*/, 0x90, v197, s31
	s_movk_i32 s31, 0x7520
	v_mad_u32_u24 v129 /*v385*/, 0x90, v197, s30
	s_movk_i32 s30, 0x6c00
	v_mad_u32_u24 v134 /*v390*/, 0x90, v197, s31
	s_movk_i32 s31, 0x5140
	v_mad_u32_u24 v131 /*v387*/, 0x90, v197, s30
	s_movk_i32 s30, 0x7500
	v_mad_u32_u24 v137 /*v393*/, 0x90, v197, s31
	s_movk_i32 s31, 0x5a40
	s_set_vgpr_msb 0x5040
	v_mad_u32_u24 v103 /*v359*/, 0x90, v0, v199
	s_set_vgpr_msb 0x4004
	v_mul_u32_u24_e32 v0, 0x90, v119 /*v375*/
	s_set_vgpr_msb 0x440
	v_mad_u32_u24 v133 /*v389*/, 0x90, v197, s30
	s_movk_i32 s30, 0x4860
	v_mad_u32_u24 v139 /*v395*/, 0x90, v197, s31
	s_movk_i32 s31, 0x6340
	v_mad_u32_u24 v136 /*v392*/, 0x90, v197, s30
	s_movk_i32 s30, 0x5160
	v_mad_u32_u24 v141 /*v397*/, 0x90, v197, s31
	s_lshr_b32 s31, s42, 6
	v_mad_u32_u24 v138 /*v394*/, 0x90, v197, s30
	s_movk_i32 s30, 0x5a60
	v_mad_u32 v143 /*v399*/, 0x2400, s31, v0
	v_mad_u32_u24 v140 /*v396*/, 0x90, v197, s30
	s_movk_i32 s30, 0x6360
	s_set_vgpr_msb 0x4050
	v_mad_u32_u24 v117 /*v373*/, 0x90, v197, v122 /*v378*/
	v_mad_u32_u24 v110 /*v366*/, 0x90, v2, v122 /*v378*/
	v_mad_u32_u24 v108 /*v364*/, 0x90, v3, v122 /*v378*/
	s_set_vgpr_msb 0x5040
	v_mad_u32_u24 v106 /*v362*/, 0x90, v197, v199
	v_mad_u32_u24 v99 /*v355*/, 0x90, v2, v199
	v_mad_u32_u24 v98 /*v354*/, 0x90, v3, v199
	s_set_vgpr_msb 0x4000
	v_mov_b32_e32 v9, v8
	s_set_vgpr_msb 0x50
	v_mad_u32_u24 v112 /*v368*/, 0x90, v1, v122 /*v378*/
	s_set_vgpr_msb 0x5040
	v_mad_u32_u24 v101 /*v357*/, 0x90, v1, v199
	v_mad_u32_u24 v142 /*v398*/, 0x90, v197, s30
	s_movk_i32 s30, 0x6c40
	s_movk_i32 s29, 0x90
	s_movk_i32 s43, 0x4840
	s_add_nc_u64 s[8:9], s[8:9], s[36:37]
	s_movk_i32 s36, 0x6c60
	v_mad_u32_u24 v144 /*v400*/, 0x90, v197, s30
	s_movk_i32 s30, 0x7540
	s_movk_i32 s31, 0x7560
	s_max_i32 s40, s21, 0
	s_set_vgpr_msb 0x4044
	v_dual_add_nc_u32 v118 /*v374*/, 32, v117 /*v373*/ :: v_dual_add_nc_u32 v114 /*v370*/, 32, v112 /*v368*/
	v_dual_add_nc_u32 v115 /*v371*/, 32, v113 /*v369*/ :: v_dual_add_nc_u32 v111 /*v367*/, 32, v110 /*v366*/
	v_dual_add_nc_u32 v109 /*v365*/, 32, v108 /*v364*/ :: v_dual_add_nc_u32 v107 /*v363*/, 32, v106 /*v362*/
	v_dual_add_nc_u32 v105 /*v361*/, 32, v103 /*v359*/ :: v_dual_add_nc_u32 v104 /*v360*/, 32, v101 /*v357*/
	v_dual_add_nc_u32 v102 /*v358*/, 32, v99 /*v355*/ :: v_dual_add_nc_u32 v100 /*v356*/, 32, v98 /*v354*/
	s_set_vgpr_msb 0x4440
	v_add_nc_u32_e32 v124 /*v380*/, 0, v198
	v_mad_u32_u24 v135 /*v391*/, 0x90, v197, s43
	v_mad_u32_u24 v145 /*v401*/, 0x90, v197, s36
	v_mad_u32_u24 v146 /*v402*/, 0x90, v197, s30
	v_mad_u32_u24 v147 /*v403*/, 0x90, v197, s31
	v_mad_u32_u24 v148 /*v404*/, v197, s29, 0x4800
	s_set_vgpr_msb 0x4044
	v_dual_add_nc_u32 v149 /*v405*/, 32, v143 /*v399*/ :: v_dual_add_nc_u32 v156 /*v412*/, 64, v143 /*v399*/
	v_add_nc_u32_e32 v150 /*v406*/, 0x900, v143 /*v399*/
	v_add_nc_u32_e32 v151 /*v407*/, 0x920, v143 /*v399*/
	v_add_nc_u32_e32 v152 /*v408*/, 0x1200, v143 /*v399*/
	v_add_nc_u32_e32 v153 /*v409*/, 0x1220, v143 /*v399*/
	v_add_nc_u32_e32 v154 /*v410*/, 0x1b00, v143 /*v399*/
	v_add_nc_u32_e32 v155 /*v411*/, 0x1b20, v143 /*v399*/
	v_add_nc_u32_e32 v157 /*v413*/, 0x60, v143 /*v399*/
	v_add_nc_u32_e32 v158 /*v414*/, 0x940, v143 /*v399*/
	v_add_nc_u32_e32 v159 /*v415*/, 0x960, v143 /*v399*/
	v_add_nc_u32_e32 v160 /*v416*/, 0x1240, v143 /*v399*/
	s_set_vgpr_msb 0x4400
	v_dual_mov_b32 v12, v8 :: v_dual_mov_b32 v13, v8
	v_dual_mov_b32 v14, v8 :: v_dual_mov_b32 v15, v8
	v_dual_mov_b32 v48, v8 :: v_dual_mov_b32 v49, v8
	v_dual_mov_b32 v50, v8 :: v_dual_mov_b32 v51, v8
	v_dual_mov_b32 v52, v8 :: v_dual_mov_b32 v53, v8
	v_dual_mov_b32 v54, v8 :: v_dual_mov_b32 v55, v8
	v_dual_mov_b32 v64, v8 :: v_dual_mov_b32 v65, v8
	v_dual_mov_b32 v66, v8 :: v_dual_mov_b32 v67, v8
	v_dual_mov_b32 v68, v8 :: v_dual_mov_b32 v69, v8
	v_dual_mov_b32 v70, v8 :: v_dual_mov_b32 v71, v8
	v_dual_mov_b32 v80, v8 :: v_dual_mov_b32 v81, v8
	v_dual_mov_b32 v82, v8 :: v_dual_mov_b32 v83, v8
	v_dual_mov_b32 v84, v8 :: v_dual_mov_b32 v85, v8
	v_dual_mov_b32 v86, v8 :: v_dual_mov_b32 v87, v8
	v_dual_mov_b32 v88, v8 :: v_dual_mov_b32 v89, v8
	v_dual_mov_b32 v90, v8 :: v_dual_mov_b32 v91, v8
	v_dual_mov_b32 v92, v8 :: v_dual_mov_b32 v93, v8
	v_dual_mov_b32 v94, v8 :: v_dual_mov_b32 v95, v8
	v_dual_mov_b32 v104, v8 :: v_dual_mov_b32 v105, v8
	v_dual_mov_b32 v106, v8 :: v_dual_mov_b32 v107, v8
	v_dual_mov_b32 v108, v8 :: v_dual_mov_b32 v109, v8
	v_dual_mov_b32 v110, v8 :: v_dual_mov_b32 v111, v8
	v_dual_mov_b32 v72, v8 :: v_dual_mov_b32 v73, v8
	v_dual_mov_b32 v74, v8 :: v_dual_mov_b32 v75, v8
	v_dual_mov_b32 v76, v8 :: v_dual_mov_b32 v77, v8
	v_dual_mov_b32 v78, v8 :: v_dual_mov_b32 v79, v8
	v_dual_mov_b32 v96, v8 :: v_dual_mov_b32 v97, v8
	v_dual_mov_b32 v98, v8 :: v_dual_mov_b32 v99, v8
	v_dual_mov_b32 v100, v8 :: v_dual_mov_b32 v101, v8
	v_dual_mov_b32 v102, v8 :: v_dual_mov_b32 v103, v8
	v_dual_mov_b32 v112, v8 :: v_dual_mov_b32 v113, v8
	v_dual_mov_b32 v114, v8 :: v_dual_mov_b32 v115, v8
	v_dual_mov_b32 v116, v8 :: v_dual_mov_b32 v117, v8
	v_dual_mov_b32 v118, v8 :: v_dual_mov_b32 v119, v8
	v_dual_mov_b32 v120, v8 :: v_dual_mov_b32 v121, v8
	v_dual_mov_b32 v122, v8 :: v_dual_mov_b32 v123, v8
	v_dual_mov_b32 v124, v8 :: v_dual_mov_b32 v125, v8
	v_dual_mov_b32 v126, v8 :: v_dual_mov_b32 v127, v8
	v_dual_mov_b32 v136, v8 :: v_dual_mov_b32 v137, v8
	v_dual_mov_b32 v138, v8 :: v_dual_mov_b32 v139, v8
	v_dual_mov_b32 v140, v8 :: v_dual_mov_b32 v141, v8
	v_dual_mov_b32 v142, v8 :: v_dual_mov_b32 v143, v8
	v_dual_mov_b32 v160, v8 :: v_dual_mov_b32 v161, v8
	v_dual_mov_b32 v162, v8 :: v_dual_mov_b32 v163, v8
	v_dual_mov_b32 v164, v8 :: v_dual_mov_b32 v165, v8
	v_dual_mov_b32 v166, v8 :: v_dual_mov_b32 v167, v8
	v_dual_mov_b32 v128, v8 :: v_dual_mov_b32 v129, v8
	v_dual_mov_b32 v130, v8 :: v_dual_mov_b32 v131, v8
	v_dual_mov_b32 v132, v8 :: v_dual_mov_b32 v133, v8
	v_dual_mov_b32 v134, v8 :: v_dual_mov_b32 v135, v8
	v_dual_mov_b32 v144, v8 :: v_dual_mov_b32 v145, v8
	v_dual_mov_b32 v146, v8 :: v_dual_mov_b32 v147, v8
	v_dual_mov_b32 v148, v8 :: v_dual_mov_b32 v149, v8
	v_dual_mov_b32 v150, v8 :: v_dual_mov_b32 v151, v8
	v_dual_mov_b32 v152, v8 :: v_dual_mov_b32 v153, v8
	v_dual_mov_b32 v154, v8 :: v_dual_mov_b32 v155, v8
	v_dual_mov_b32 v156, v8 :: v_dual_mov_b32 v157, v8
	v_dual_mov_b32 v158, v8 :: v_dual_mov_b32 v159, v8
	v_dual_mov_b32 v168, v8 :: v_dual_mov_b32 v169, v8
	v_dual_mov_b32 v170, v8 :: v_dual_mov_b32 v171, v8
	v_dual_mov_b32 v172, v8 :: v_dual_mov_b32 v173, v8
	v_dual_mov_b32 v174, v8 :: v_dual_mov_b32 v175, v8
	v_dual_mov_b32 v176, v8 :: v_dual_mov_b32 v177, v8
	v_dual_mov_b32 v178, v8 :: v_dual_mov_b32 v179, v8
	v_dual_mov_b32 v180, v8 :: v_dual_mov_b32 v181, v8
	v_dual_mov_b32 v182, v8 :: v_dual_mov_b32 v183, v8
	v_dual_mov_b32 v184, v8 :: v_dual_mov_b32 v185, v8
	v_dual_mov_b32 v186, v8 :: v_dual_mov_b32 v187, v8
	v_dual_mov_b32 v188, v8 :: v_dual_mov_b32 v189, v8
	v_dual_mov_b32 v190, v8 :: v_dual_mov_b32 v191, v8
	v_dual_mov_b32 v0, v8 :: v_dual_mov_b32 v1, v8
	v_dual_mov_b32 v2, v8 :: v_dual_mov_b32 v3, v8
	v_dual_mov_b32 v4, v8 :: v_dual_mov_b32 v5, v8
	v_dual_mov_b32 v6, v8 :: v_dual_mov_b32 v7, v8
	v_dual_mov_b32 v16, v8 :: v_dual_mov_b32 v17, v8
	v_dual_mov_b32 v18, v8 :: v_dual_mov_b32 v19, v8
	v_dual_mov_b32 v20, v8 :: v_dual_mov_b32 v21, v8
	v_dual_mov_b32 v22, v8 :: v_dual_mov_b32 v23, v8
	v_dual_mov_b32 v24, v8 :: v_dual_mov_b32 v25, v8
	v_dual_mov_b32 v26, v8 :: v_dual_mov_b32 v27, v8
	v_dual_mov_b32 v28, v8 :: v_dual_mov_b32 v29, v8
	v_dual_mov_b32 v30, v8 :: v_dual_mov_b32 v31, v8
	v_dual_mov_b32 v32, v8 :: v_dual_mov_b32 v33, v8
	v_dual_mov_b32 v34, v8 :: v_dual_mov_b32 v35, v8
	v_dual_mov_b32 v36, v8 :: v_dual_mov_b32 v37, v8
	v_dual_mov_b32 v38, v8 :: v_dual_mov_b32 v39, v8
	v_dual_mov_b32 v40, v8 :: v_dual_mov_b32 v41, v8
	v_dual_mov_b32 v42, v8 :: v_dual_mov_b32 v43, v8
	v_dual_mov_b32 v44, v8 :: v_dual_mov_b32 v45, v8
	v_dual_mov_b32 v46, v8 :: v_dual_mov_b32 v47, v8
	v_dual_mov_b32 v56, v8 :: v_dual_mov_b32 v57, v8
	v_dual_mov_b32 v58, v8 :: v_dual_mov_b32 v59, v8
	v_dual_mov_b32 v60, v8 :: v_dual_mov_b32 v61, v8
	v_dual_mov_b32 v62, v8 :: v_dual_mov_b32 v63, v8
	s_set_vgpr_msb 0x44
	v_add_nc_u32_e32 v161 /*v417*/, 0x1260, v143 /*v399*/
	v_add_nc_u32_e32 v162 /*v418*/, 0x1b40, v143 /*v399*/
	v_add_nc_u32_e32 v163 /*v419*/, 0x1b60, v143 /*v399*/
	s_mov_b32 s13, 0xffff0000
	s_mov_b32 s12, 0x7300000
	s_lshl_b32 s41, s40, 16
	s_lshr_b32 s21, s40, 16
	s_movk_i32 s16, 0x80
	s_or_b32 s22, s41, 0x7fff
	s_or_b32 s23, s21, 0x800000
	s_and_b32 s26, s20, 0xffff
	s_movk_i32 s24, 0xc0
	s_mov_b32 s20, s12
	s_mov_b32 s21, s13
	s_mov_b32 s27, s19
	s_add_nc_u64 s[6:7], s[6:7], 0x100
	s_add_nc_u64 s[8:9], s[8:9], 0x100
	s_mov_b32 s36, 2
	s_mov_b32 s37, s19
	s_mov_b32 s42, s35
	s_mov_b32 s43, s19
	s_set_vgpr_msb 0x4400
	s_branch .LBB0_14
.LBB0_13:
	s_set_vgpr_msb 4
	v_wmma_f32_16x16x32_bf16 v[8:15], v[232:239], v[40:47] /*v[296:303]*/, v[8:15]
	s_set_vgpr_msb 0x405
	v_wmma_f32_16x16x32_bf16 v[48:55], v[8:15] /*v[264:271]*/, v[40:47] /*v[296:303]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[24:31] /*v[280:287]*/, v[40:47] /*v[296:303]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[56:63] /*v[312:319]*/, v[40:47] /*v[296:303]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[72:79] /*v[328:335]*/, v[40:47] /*v[296:303]*/, v[88:95]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[88:95] /*v[344:351]*/, v[40:47] /*v[296:303]*/, v[104:111]
	s_set_vgpr_msb 0x501
	v_wmma_f32_16x16x32_bf16 v[160:167], v[88:95] /*v[344:351]*/, v[248:255], v[160:167]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[72:79] /*v[328:335]*/, v[248:255], v[136:143]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[56:63] /*v[312:319]*/, v[248:255], v[120:127]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[24:31] /*v[280:287]*/, v[248:255], v[112:119]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[8:15] /*v[264:271]*/, v[248:255], v[96:103]
	s_set_vgpr_msb 0x100
	v_wmma_f32_16x16x32_bf16 v[72:79], v[232:239], v[248:255], v[72:79]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[232:239], v[216:223], v[128:135]
	s_set_vgpr_msb 1
	v_wmma_f32_16x16x32_bf16 v[144:151], v[8:15] /*v[264:271]*/, v[216:223], v[144:151]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[24:31] /*v[280:287]*/, v[216:223], v[152:159]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[56:63] /*v[312:319]*/, v[216:223], v[168:175]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[72:79] /*v[328:335]*/, v[216:223], v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[88:95] /*v[344:351]*/, v[216:223], v[184:191]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[88:95] /*v[344:351]*/, v[200:207], v[56:63]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[72:79] /*v[328:335]*/, v[200:207], v[40:47]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[56:63] /*v[312:319]*/, v[200:207], v[32:39]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[24:31] /*v[280:287]*/, v[200:207], v[24:31]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[8:15] /*v[264:271]*/, v[200:207], v[16:23]
	s_set_vgpr_msb 0x100
	v_wmma_f32_16x16x32_bf16 v[0:7], v[232:239], v[200:207], v[0:7]
	s_wait_dscnt 0x0
	s_wait_tensorcnt 0x1
	s_barrier_signal -1
	s_set_vgpr_msb 4
	v_wmma_f32_16x16x32_bf16 v[8:15], v[224:231], v[32:39] /*v[288:295]*/, v[8:15]
	s_set_vgpr_msb 0x405
	v_wmma_f32_16x16x32_bf16 v[48:55], v[0:7] /*v[256:263]*/, v[32:39] /*v[288:295]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[16:23] /*v[272:279]*/, v[32:39] /*v[288:295]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[48:55] /*v[304:311]*/, v[32:39] /*v[288:295]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[64:71] /*v[320:327]*/, v[32:39] /*v[288:295]*/, v[88:95]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[80:87] /*v[336:343]*/, v[32:39] /*v[288:295]*/, v[104:111]
	s_set_vgpr_msb 0x501
	v_wmma_f32_16x16x32_bf16 v[160:167], v[80:87] /*v[336:343]*/, v[240:247], v[160:167]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[64:71] /*v[320:327]*/, v[240:247], v[136:143]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[48:55] /*v[304:311]*/, v[240:247], v[120:127]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[16:23] /*v[272:279]*/, v[240:247], v[112:119]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[0:7] /*v[256:263]*/, v[240:247], v[96:103]
	s_set_vgpr_msb 0x100
	v_wmma_f32_16x16x32_bf16 v[72:79], v[224:231], v[240:247], v[72:79]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[224:231], v[208:215], v[128:135]
	s_set_vgpr_msb 1
	v_wmma_f32_16x16x32_bf16 v[144:151], v[0:7] /*v[256:263]*/, v[208:215], v[144:151]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[16:23] /*v[272:279]*/, v[208:215], v[152:159]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[48:55] /*v[304:311]*/, v[208:215], v[168:175]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[64:71] /*v[320:327]*/, v[208:215], v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[80:87] /*v[336:343]*/, v[208:215], v[184:191]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[80:87] /*v[336:343]*/, v[192:199], v[56:63]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[64:71] /*v[320:327]*/, v[192:199], v[40:47]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[48:55] /*v[304:311]*/, v[192:199], v[32:39]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[16:23] /*v[272:279]*/, v[192:199], v[24:31]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[0:7] /*v[256:263]*/, v[192:199], v[16:23]
	s_set_vgpr_msb 0x100
	v_wmma_f32_16x16x32_bf16 v[0:7], v[224:231], v[192:199], v[0:7]
	s_add_co_i32 s42, s42, -1
	s_add_co_i32 s43, s43, 1
	s_add_co_i32 s37, s37, 0xb400
	s_add_co_i32 s36, s36, 1
	s_add_nc_u64 s[6:7], s[6:7], 0x80
	s_cmp_lg_u32 s42, 0
	s_add_nc_u64 s[8:9], s[8:9], 0x80
	s_barrier_wait -1
	s_cbranch_scc0 .LBB0_18
.LBB0_14:
	s_mul_hi_u32 s29, s43, 0xaaaaaaab
	s_set_vgpr_msb 0x44
	v_add_nc_u32_e32 v65 /*v321*/, s37, v124 /*v380*/
	s_lshr_b32 s29, s29, 1
	s_delay_alu instid0(SALU_CYCLE_1)
	s_mul_i32 s29, s29, 0x21c00
	s_set_vgpr_msb 0x4404
	v_subrev_nc_u32_e32 v216, s29, v143 /*v399*/
	v_subrev_nc_u32_e32 v201, s29, v149 /*v405*/
	v_subrev_nc_u32_e32 v202, s29, v150 /*v406*/
	v_subrev_nc_u32_e32 v203, s29, v151 /*v407*/
	v_subrev_nc_u32_e32 v204, s29, v152 /*v408*/
	v_subrev_nc_u32_e32 v205, s29, v153 /*v409*/
	s_set_vgpr_msb 0x401
	v_dual_add_nc_u32 v216, v65 /*v321*/, v216 :: v_dual_add_nc_u32 v201, v65 /*v321*/, v201
	s_set_vgpr_msb 0x104
	v_subrev_nc_u32_e32 v206, s29, v154 /*v410*/
	v_subrev_nc_u32_e32 v207, s29, v155 /*v411*/
	s_set_vgpr_msb 0x401
	v_dual_add_nc_u32 v202, v65 /*v321*/, v202 :: v_dual_add_nc_u32 v203, v65 /*v321*/, v203
	s_set_vgpr_msb 0x104
	v_subrev_nc_u32_e32 v200, s29, v148 /*v404*/
	v_subrev_nc_u32_e32 v192, s29, v123 /*v379*/
	v_add_nc_u32_e32 v204, v204, v65 /*v321*/
	s_wait_alu depctr_vm_vsrc(6)
	v_subrev_nc_u32_e32 v193, s29, v125 /*v381*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x440
	ds_load_b128 v[40:43] /*v[296:299]*/, v216
	ds_load_b128 v[44:47] /*v[300:303]*/, v201
	s_set_vgpr_msb 0x4000
	ds_load_b128 v[248:251], v202
	ds_load_b128 v[252:255], v203
	s_wait_alu depctr_vm_vsrc(3)
	ds_load_b128 v[216:219], v204
	s_wait_alu depctr_vm_vsrc(3)
	s_set_vgpr_msb 1
	v_add_nc_u32_e32 v201, v65 /*v321*/, v205
	s_set_vgpr_msb 0x104
	v_subrev_nc_u32_e32 v194, s29, v126 /*v382*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x401
	v_dual_add_nc_u32 v202, v65 /*v321*/, v206 :: v_dual_add_nc_u32 v204, v65 /*v321*/, v207
	s_set_vgpr_msb 0x104
	v_subrev_nc_u32_e32 v195, s29, v127 /*v383*/
	v_subrev_nc_u32_e32 v196, s29, v128 /*v384*/
	v_add_nc_u32_e32 v229, v200, v65 /*v321*/
	v_subrev_nc_u32_e32 v197, s29, v129 /*v385*/
	v_add_nc_u32_e32 v192, v192, v65 /*v321*/
	v_subrev_nc_u32_e32 v198, s29, v130 /*v386*/
	s_wait_alu depctr_va_vdst(8)
	ds_load_b128 v[220:223], v201
	s_wait_alu depctr_va_vdst(6) depctr_vm_vsrc(0)
	ds_load_b128 v[200:203], v202
	ds_load_b128 v[204:207], v204
	s_wait_alu depctr_va_vdst(3)
	ds_load_b128 v[232:235], v229
	s_wait_alu depctr_va_vdst(1)
	ds_load_b128 v[236:239], v192
	s_wait_alu depctr_vm_vsrc(0)
	v_add_nc_u32_e32 v192, v193, v65 /*v321*/
	v_subrev_nc_u32_e32 v199, s29, v131 /*v387*/
	v_add_nc_u32_e32 v193, v194, v65 /*v321*/
	v_subrev_nc_u32_e32 v208, s29, v132 /*v388*/
	s_set_vgpr_msb 0x401
	v_dual_add_nc_u32 v194, v65 /*v321*/, v195 :: v_dual_add_nc_u32 v195, v65 /*v321*/, v196
	s_set_vgpr_msb 0x104
	v_subrev_nc_u32_e32 v209, s29, v133 /*v389*/
	v_subrev_nc_u32_e32 v210, s29, v134 /*v390*/
	v_add_nc_u32_e32 v196, v197, v65 /*v321*/
	v_subrev_nc_u32_e32 v211, s29, v156 /*v412*/
	s_wait_alu depctr_va_vdst(8)
	s_set_vgpr_msb 0x440
	ds_load_b128 v[8:11] /*v[264:267]*/, v192
	s_wait_alu depctr_va_vdst(6)
	ds_load_b128 v[12:15] /*v[268:271]*/, v193
	s_wait_alu depctr_va_vdst(4)
	ds_load_b128 v[24:27] /*v[280:283]*/, v194
	ds_load_b128 v[28:31] /*v[284:287]*/, v195
	s_wait_alu depctr_va_vdst(1)
	ds_load_b128 v[56:59] /*v[312:315]*/, v196
	s_wait_alu depctr_vm_vsrc(4)
	s_set_vgpr_msb 0x4001
	v_add_nc_u32_e32 v192, v65 /*v321*/, v198
	s_set_vgpr_msb 0x104
	v_subrev_nc_u32_e32 v214, s29, v157 /*v413*/
	s_wait_alu depctr_vm_vsrc(2)
	s_set_vgpr_msb 0x401
	v_dual_add_nc_u32 v193, v65 /*v321*/, v199 :: v_dual_add_nc_u32 v194, v65 /*v321*/, v208
	s_set_vgpr_msb 0x104
	v_subrev_nc_u32_e32 v215, s29, v158 /*v414*/
	v_subrev_nc_u32_e32 v224, s29, v159 /*v415*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x401
	v_dual_add_nc_u32 v195, v65 /*v321*/, v209 :: v_dual_add_nc_u32 v196, v65 /*v321*/, v210
	s_set_vgpr_msb 0x104
	v_subrev_nc_u32_e32 v225, s29, v160 /*v416*/
	s_set_vgpr_msb 0x444
	v_subrev_nc_u32_e32 v0 /*v256*/, s29, v137 /*v393*/
	v_subrev_nc_u32_e32 v52 /*v308*/, s29, v142 /*v398*/
	s_set_vgpr_msb 0x4404
	v_subrev_nc_u32_e32 v226, s29, v161 /*v417*/
	s_wait_alu depctr_va_vdst(9)
	s_set_vgpr_msb 0x440
	ds_load_b128 v[60:63] /*v[316:319]*/, v192
	s_wait_alu depctr_va_vdst(7)
	ds_load_b128 v[72:75] /*v[328:331]*/, v193
	ds_load_b128 v[76:79] /*v[332:335]*/, v194
	s_wait_alu depctr_va_vdst(4)
	ds_load_b128 v[88:91] /*v[344:347]*/, v195
	ds_load_b128 v[92:95] /*v[348:351]*/, v196
	s_wait_alu depctr_vm_vsrc(3)
	s_set_vgpr_msb 0x4001
	v_dual_add_nc_u32 v192, v65 /*v321*/, v211 :: v_dual_add_nc_u32 v193, v65 /*v321*/, v214
	s_set_vgpr_msb 0x144
	v_subrev_nc_u32_e32 v1 /*v257*/, s29, v138 /*v394*/
	v_subrev_nc_u32_e32 v4 /*v260*/, s29, v141 /*v397*/
	v_subrev_nc_u32_e32 v53 /*v309*/, s29, v144 /*v400*/
	s_set_vgpr_msb 0x4404
	v_subrev_nc_u32_e32 v227, s29, v162 /*v418*/
	s_set_vgpr_msb 0x444
	v_subrev_nc_u32_e32 v2 /*v258*/, s29, v139 /*v395*/
	v_subrev_nc_u32_e32 v54 /*v310*/, s29, v145 /*v401*/
	s_set_vgpr_msb 0x4404
	v_subrev_nc_u32_e32 v228, s29, v163 /*v419*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x401
	v_dual_add_nc_u32 v194, v65 /*v321*/, v215 :: v_dual_add_nc_u32 v195, v65 /*v321*/, v224
	s_set_vgpr_msb 0x104
	v_subrev_nc_u32_e32 v212, s29, v135 /*v391*/
	s_set_vgpr_msb 0x444
	v_subrev_nc_u32_e32 v3 /*v259*/, s29, v140 /*v396*/
	v_subrev_nc_u32_e32 v55 /*v311*/, s29, v146 /*v402*/
	s_set_vgpr_msb 0x4404
	v_subrev_nc_u32_e32 v213, s29, v136 /*v392*/
	s_set_vgpr_msb 0x444
	v_subrev_nc_u32_e32 v64 /*v320*/, s29, v147 /*v403*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x4401
	v_add_nc_u32_e32 v196, v65 /*v321*/, v225
	s_wait_alu depctr_va_vdst(14)
	s_set_vgpr_msb 0x140
	ds_load_b128 v[32:35] /*v[288:291]*/, v192
	ds_load_b128 v[36:39] /*v[292:295]*/, v193
	s_wait_alu depctr_va_vdst(6)
	s_set_vgpr_msb 0x4000
	ds_load_b128 v[240:243], v194
	ds_load_b128 v[244:247], v195
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[208:211], v196
	s_wait_alu depctr_vm_vsrc(4)
	s_set_vgpr_msb 1
	v_add_nc_u32_e32 v192, v65 /*v321*/, v226
	s_set_vgpr_msb 0x145
	v_dual_add_nc_u32 v0 /*v256*/, v65 /*v321*/, v0 /*v256*/ :: v_dual_add_nc_u32 v5 /*v261*/, v65 /*v321*/, v1 /*v257*/
	v_dual_add_nc_u32 v52 /*v308*/, v65 /*v321*/, v52 /*v308*/ :: v_dual_add_nc_u32 v68 /*v324*/, v65 /*v321*/, v54 /*v310*/
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x4501
	v_dual_add_nc_u32 v193, v65 /*v321*/, v227 :: v_dual_add_nc_u32 v196, v65 /*v321*/, v228
	s_set_vgpr_msb 0x145
	v_dual_add_nc_u32 v48 /*v304*/, v65 /*v321*/, v4 /*v260*/ :: v_dual_add_nc_u32 v66 /*v322*/, v65 /*v321*/, v53 /*v309*/
	v_dual_add_nc_u32 v16 /*v272*/, v65 /*v321*/, v2 /*v258*/ :: v_dual_add_nc_u32 v20 /*v276*/, v65 /*v321*/, v3 /*v259*/
	s_set_vgpr_msb 0x4501
	v_dual_add_nc_u32 v224, v65 /*v321*/, v212 :: v_dual_add_nc_u32 v228, v65 /*v321*/, v213
	s_set_vgpr_msb 0x145
	v_dual_add_nc_u32 v80 /*v336*/, v65 /*v321*/, v55 /*v311*/ :: v_dual_add_nc_u32 v84 /*v340*/, v65 /*v321*/, v64 /*v320*/
	s_wait_alu depctr_va_vdst(7)
	s_set_vgpr_msb 0x4500
	ds_load_b128 v[212:215], v192
	s_wait_alu depctr_va_vdst(4) depctr_vm_vsrc(0)
	ds_load_b128 v[192:195], v193
	ds_load_b128 v[196:199], v196
	s_wait_alu depctr_va_vdst(1)
	ds_load_b128 v[224:227], v224
	ds_load_b128 v[228:231], v228
	s_set_vgpr_msb 0x41
	ds_load_b128 v[0:3] /*v[256:259]*/, v0 /*v256*/
	ds_load_b128 v[4:7] /*v[260:263]*/, v5 /*v261*/
	ds_load_b128 v[16:19] /*v[272:275]*/, v16 /*v272*/
	ds_load_b128 v[20:23] /*v[276:279]*/, v20 /*v276*/
	ds_load_b128 v[48:51] /*v[304:307]*/, v48 /*v304*/
	ds_load_b128 v[52:55] /*v[308:311]*/, v52 /*v308*/
	ds_load_b128 v[64:67] /*v[320:323]*/, v66 /*v322*/
	ds_load_b128 v[68:71] /*v[324:327]*/, v68 /*v324*/
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[80:83] /*v[336:339]*/, v80 /*v336*/
	ds_load_b128 v[84:87] /*v[340:343]*/, v84 /*v340*/
	s_mul_hi_u32 s29, s36, 0xaaaaaaab
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_lshr_b32 s29, s29, 1
	s_mul_i32 s29, s29, 0x21c00
	s_delay_alu instid0(SALU_CYCLE_1)
	s_sub_co_i32 s44, 0x1b000, s29
	s_wait_dscnt 0x14
	s_and_b32 vcc_lo, exec_lo, s0
	s_set_vgpr_msb 0x4100
	s_cbranch_vccz .LBB0_16
	s_and_b32 vcc_lo, exec_lo, s1
	s_cbranch_vccnz .LBB0_13
	s_branch .LBB0_17
.LBB0_16:
	s_add_co_i32 s29, s37, 0
	s_or_b32 s31, s7, 0x80000000
	s_add_co_i32 s29, s29, s44
	s_mov_b32 s30, s6
	s_addk_co_i32 s29, 0xb800
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[28:31], s[12:19]
	s_and_b32 vcc_lo, exec_lo, s1
	s_cbranch_vccnz .LBB0_13
.LBB0_17:
	s_add_co_i32 s29, s37, 0
	s_or_b32 s31, s9, 0x80000000
	s_add_co_i32 s29, s29, s44
	s_mov_b32 s30, s8
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[28:31], s[20:27]
	s_branch .LBB0_13
.LBB0_18:
	s_wait_alu depctr_vm_vsrc(6)
	v_nop
	v_nop
	v_nop
	v_nop
	v_dual_mov_b32 v193, s41 :: v_dual_mov_b32 v194, s40
	s_set_vgpr_msb 1
	v_dual_mov_b32 v196, v122 /*v378*/ :: v_dual_mov_b32 v192, v121 /*v377*/
	v_mov_b32_e32 v195, v120 /*v376*/
	s_set_vgpr_msb 0x100
.LBB0_19:
	s_mul_hi_i32 s0, s35, 0x55555556
	s_set_vgpr_msb 1
	v_add3_u32 v197, v119 /*v375*/, s38, 16
	s_lshr_b32 s1, s0, 31
	s_mov_b32 s7, 0
	s_add_co_i32 s0, s0, s1
	s_set_vgpr_msb 0x140
	v_mad_u32_u24 v92 /*v348*/, 0x90, v197, v196
	s_mul_i32 s0, s0, 3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_sub_co_i32 s0, s35, s0
	s_ashr_i32 s35, s34, 31
	s_mul_i32 s0, s0, 0xb400
	s_add_co_i32 s0, s0, 0
	s_wait_alu depctr_vm_vsrc(5)
	s_set_vgpr_msb 0x4044
	v_dual_add_nc_u32 v48 /*v304*/, s0, v116 /*v372*/ :: v_dual_add_nc_u32 v0 /*v256*/, s0, v114 /*v370*/
	s_set_vgpr_msb 0x4404
	v_dual_add_nc_u32 v228, s0, v117 /*v373*/ :: v_dual_add_nc_u32 v232, s0, v118 /*v374*/
	s_set_vgpr_msb 0x444
	v_dual_add_nc_u32 v64 /*v320*/, s0, v92 /*v348*/ :: v_dual_add_nc_u32 v4 /*v260*/, s0, v110 /*v366*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x4401
	ds_load_b128 v[196:199], v48 /*v304*/
	ds_load_b128 v[200:203], v48 /*v304*/ offset:32
	ds_load_b128 v[204:207], v48 /*v304*/ offset:2304
	ds_load_b128 v[208:211], v48 /*v304*/ offset:2336
	ds_load_b128 v[212:215], v48 /*v304*/ offset:4608
	ds_load_b128 v[216:219], v48 /*v304*/ offset:4640
	ds_load_b128 v[220:223], v48 /*v304*/ offset:6912
	ds_load_b128 v[224:227], v48 /*v304*/ offset:6944
	s_set_vgpr_msb 0x100
	ds_load_b128 v[228:231], v228
	ds_load_b128 v[232:235], v232
	s_set_vgpr_msb 1
	ds_load_b128 v[236:239], v64 /*v320*/
	ds_load_b128 v[240:243], v64 /*v320*/ offset:32
	s_set_vgpr_msb 0x144
	v_dual_add_nc_u32 v8 /*v264*/, s0, v111 /*v367*/ :: v_dual_add_nc_u32 v12 /*v268*/, s0, v108 /*v364*/
	s_set_vgpr_msb 0x4404
	v_dual_add_nc_u32 v244, s0, v113 /*v369*/ :: v_dual_add_nc_u32 v248, s0, v115 /*v371*/
	s_wait_alu depctr_vm_vsrc(6)
	s_set_vgpr_msb 0x444
	v_dual_add_nc_u32 v16 /*v272*/, s0, v109 /*v365*/ :: v_dual_add_nc_u32 v52 /*v308*/, s0, v106 /*v362*/
	v_dual_add_nc_u32 v80 /*v336*/, s0, v104 /*v360*/ :: v_dual_add_nc_u32 v84 /*v340*/, s0, v99 /*v355*/
	s_set_vgpr_msb 0x4440
	v_dual_add_nc_u32 v20 /*v276*/, s0, v192 :: v_dual_add_nc_u32 v24 /*v280*/, s0, v195
	s_set_vgpr_msb 0x4004
	v_add_nc_u32_e32 v252, s0, v112 /*v368*/
	s_set_vgpr_msb 0x445
	v_dual_add_nc_u32 v68 /*v324*/, s0, v103 /*v359*/ :: v_dual_add_nc_u32 v76 /*v332*/, s0, v101 /*v357*/
	v_dual_add_nc_u32 v88 /*v344*/, s0, v102 /*v358*/ :: v_dual_add_nc_u32 v94 /*v350*/, s0, v100 /*v356*/
	s_wait_alu depctr_va_vdst(7)
	ds_load_b128 v[8:11] /*v[264:267]*/, v8 /*v264*/
	ds_load_b128 v[12:15] /*v[268:271]*/, v12 /*v268*/
	s_wait_alu depctr_va_vdst(5)
	ds_load_b128 v[16:19] /*v[272:275]*/, v16 /*v272*/
	s_wait_alu depctr_va_vdst(3)
	ds_load_b128 v[20:23] /*v[276:279]*/, v20 /*v276*/
	ds_load_b128 v[24:27] /*v[280:283]*/, v24 /*v280*/
	ds_load_b128 v[28:31] /*v[284:287]*/, v48 /*v304*/ offset:2368
	ds_load_b128 v[32:35] /*v[288:291]*/, v48 /*v304*/ offset:2400
	v_dual_add_nc_u32 v56 /*v312*/, s0, v107 /*v363*/ :: v_dual_add_nc_u32 v72 /*v328*/, s0, v105 /*v361*/
	v_add_nc_u32_e32 v93 /*v349*/, s0, v98 /*v354*/
	ds_load_b128 v[36:39] /*v[292:295]*/, v48 /*v304*/ offset:4672
	ds_load_b128 v[40:43] /*v[296:299]*/, v48 /*v304*/ offset:4704
	ds_load_b128 v[44:47] /*v[300:303]*/, v48 /*v304*/ offset:6976
	s_wait_alu depctr_vm_vsrc(0)
	ds_load_b128 v[48:51] /*v[304:307]*/, v48 /*v304*/ offset:7008
	ds_load_b128 v[52:55] /*v[308:311]*/, v52 /*v308*/
	s_wait_alu depctr_va_vdst(1)
	ds_load_b128 v[56:59] /*v[312:315]*/, v56 /*v312*/
	s_set_vgpr_msb 0x4500
	ds_load_b128 v[244:247], v244
	ds_load_b128 v[248:251], v248
	ds_load_b128 v[252:255], v252
	s_set_vgpr_msb 0x41
	ds_load_b128 v[0:3] /*v[256:259]*/, v0 /*v256*/
	ds_load_b128 v[4:7] /*v[260:263]*/, v4 /*v260*/
	ds_load_b128 v[60:63] /*v[316:319]*/, v64 /*v320*/ offset:64
	s_wait_alu depctr_vm_vsrc(0)
	ds_load_b128 v[64:67] /*v[320:323]*/, v64 /*v320*/ offset:96
	ds_load_b128 v[68:71] /*v[324:327]*/, v68 /*v324*/
	ds_load_b128 v[72:75] /*v[328:331]*/, v72 /*v328*/
	ds_load_b128 v[76:79] /*v[332:335]*/, v76 /*v332*/
	ds_load_b128 v[80:83] /*v[336:339]*/, v80 /*v336*/
	ds_load_b128 v[84:87] /*v[340:343]*/, v84 /*v340*/
	ds_load_b128 v[88:91] /*v[344:347]*/, v88 /*v344*/
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[120:123] /*v[376:379]*/, v93 /*v349*/
	ds_load_b128 v[124:127] /*v[380:383]*/, v94 /*v350*/
	s_set_vgpr_msb 0x4100
	s_wait_dscnt 0x1e
	v_wmma_f32_16x16x32_bf16 v[8:15], v[228:235], v[196:203], v[8:15]
	s_wait_dscnt 0x14
	v_wmma_f32_16x16x32_bf16 v[48:55], v[236:243], v[196:203], v[48:55]
	s_wait_dscnt 0xd
	v_wmma_f32_16x16x32_bf16 v[64:71], v[244:251], v[196:203], v[64:71]
	s_wait_dscnt 0xb
	v_wmma_f32_16x16x32_bf16 v[80:87], v[252:259], v[196:203], v[80:87]
	s_set_vgpr_msb 1
	s_wait_dscnt 0xa
	v_wmma_f32_16x16x32_bf16 v[88:95], v[4:11] /*v[260:267]*/, v[196:203], v[88:95]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[12:19] /*v[268:275]*/, v[196:203], v[104:111]
	v_wmma_f32_16x16x32_bf16 v[160:167], v[12:19] /*v[268:275]*/, v[204:211], v[160:167]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[4:11] /*v[260:267]*/, v[204:211], v[136:143]
	s_set_vgpr_msb 0x100
	v_wmma_f32_16x16x32_bf16 v[120:127], v[252:259], v[204:211], v[120:127]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[244:251], v[204:211], v[112:119]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[236:243], v[204:211], v[96:103]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[228:235], v[204:211], v[72:79]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[228:235], v[212:219], v[128:135]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[236:243], v[212:219], v[144:151]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[244:251], v[212:219], v[152:159]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[252:259], v[212:219], v[168:175]
	s_set_vgpr_msb 1
	v_wmma_f32_16x16x32_bf16 v[176:183], v[4:11] /*v[260:267]*/, v[212:219], v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[12:19] /*v[268:275]*/, v[212:219], v[184:191]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[12:19] /*v[268:275]*/, v[220:227], v[56:63]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[4:11] /*v[260:267]*/, v[220:227], v[40:47]
	s_set_vgpr_msb 0x100
	v_wmma_f32_16x16x32_bf16 v[32:39], v[252:259], v[220:227], v[32:39]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[244:251], v[220:227], v[24:31]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[236:243], v[220:227], v[16:23]
	v_wmma_f32_16x16x32_bf16 v[0:7], v[228:235], v[220:227], v[0:7]
	s_wait_dscnt 0x0
	s_wait_tensorcnt 0x0
	s_barrier_signal -1
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[8:15], v[52:59] /*v[308:315]*/, v[20:27] /*v[276:283]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[60:67] /*v[316:323]*/, v[20:27] /*v[276:283]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[68:75] /*v[324:331]*/, v[20:27] /*v[276:283]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[76:83] /*v[332:339]*/, v[20:27] /*v[276:283]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[84:91] /*v[340:347]*/, v[20:27] /*v[276:283]*/, v[88:95]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[120:127] /*v[376:383]*/, v[20:27] /*v[276:283]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[160:167], v[120:127] /*v[376:383]*/, v[28:35] /*v[284:291]*/, v[160:167]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[84:91] /*v[340:347]*/, v[28:35] /*v[284:291]*/, v[136:143]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[76:83] /*v[332:339]*/, v[28:35] /*v[284:291]*/, v[120:127]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[68:75] /*v[324:331]*/, v[28:35] /*v[284:291]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[60:67] /*v[316:323]*/, v[28:35] /*v[284:291]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[52:59] /*v[308:315]*/, v[28:35] /*v[284:291]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[52:59] /*v[308:315]*/, v[36:43] /*v[292:299]*/, v[128:135]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[60:67] /*v[316:323]*/, v[36:43] /*v[292:299]*/, v[144:151]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[68:75] /*v[324:331]*/, v[36:43] /*v[292:299]*/, v[152:159]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[76:83] /*v[332:339]*/, v[36:43] /*v[292:299]*/, v[168:175]
	v_wmma_f32_16x16x32_bf16 v[176:183], v[84:91] /*v[340:347]*/, v[36:43] /*v[292:299]*/, v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[120:127] /*v[376:383]*/, v[36:43] /*v[292:299]*/, v[184:191]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[120:127] /*v[376:383]*/, v[44:51] /*v[300:307]*/, v[56:63]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[84:91] /*v[340:347]*/, v[44:51] /*v[300:307]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[76:83] /*v[332:339]*/, v[44:51] /*v[300:307]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[68:75] /*v[324:331]*/, v[44:51] /*v[300:307]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[60:67] /*v[316:323]*/, v[44:51] /*v[300:307]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[0:7], v[52:59] /*v[308:315]*/, v[44:51] /*v[300:307]*/, v[0:7]
	s_add_co_i32 s39, s39, -1
	s_barrier_wait -1
	s_mul_hi_i32 s0, s39, 0x55555556
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_lshr_b32 s1, s0, 31
	s_add_co_i32 s0, s0, s1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s0, s0, 3
	s_sub_co_i32 s0, s39, s0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s0, s0, 0xb400
	s_add_co_i32 s0, s0, 0
	s_set_vgpr_msb 0x544
	v_dual_add_nc_u32 v8 /*v264*/, s0, v111 /*v367*/ :: v_dual_add_nc_u32 v12 /*v268*/, s0, v108 /*v364*/
	v_nop
	v_nop
	v_nop
	v_dual_add_nc_u32 v48 /*v304*/, s0, v116 /*v372*/ :: v_dual_add_nc_u32 v0 /*v256*/, s0, v114 /*v370*/
	s_wait_alu depctr_vm_vsrc(2)
	v_dual_add_nc_u32 v16 /*v272*/, s0, v109 /*v365*/ :: v_dual_add_nc_u32 v88 /*v344*/, s0, v102 /*v358*/
	s_set_vgpr_msb 0x4400
	v_dual_add_nc_u32 v192, s0, v192 :: v_dual_add_nc_u32 v195, s0, v195
	s_set_vgpr_msb 0x44
	v_dual_add_nc_u32 v64 /*v320*/, s0, v92 /*v348*/ :: v_dual_add_nc_u32 v4 /*v260*/, s0, v110 /*v366*/
	s_set_vgpr_msb 0x4404
	v_dual_add_nc_u32 v228, s0, v117 /*v373*/ :: v_dual_add_nc_u32 v232, s0, v118 /*v374*/
	v_add_nc_u32_e32 v252, s0, v112 /*v368*/
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x441
	ds_load_b128 v[8:11] /*v[264:267]*/, v8 /*v264*/
	ds_load_b128 v[12:15] /*v[268:271]*/, v12 /*v268*/
	ds_load_b128 v[16:19] /*v[272:275]*/, v16 /*v272*/
	s_set_vgpr_msb 0x4140
	ds_load_b128 v[20:23] /*v[276:279]*/, v192
	ds_load_b128 v[24:27] /*v[280:283]*/, v195
	s_set_vgpr_msb 0x4041
	ds_load_b128 v[28:31] /*v[284:287]*/, v48 /*v304*/ offset:2368
	ds_load_b128 v[32:35] /*v[288:291]*/, v48 /*v304*/ offset:2400
	s_wait_alu depctr_vm_vsrc(3)
	s_set_vgpr_msb 0x4105
	v_add_nc_u32_e32 v192, s0, v106 /*v362*/
	ds_load_b128 v[196:199], v48 /*v304*/
	ds_load_b128 v[200:203], v48 /*v304*/ offset:32
	ds_load_b128 v[204:207], v48 /*v304*/ offset:2304
	ds_load_b128 v[208:211], v48 /*v304*/ offset:2336
	ds_load_b128 v[212:215], v48 /*v304*/ offset:4608
	ds_load_b128 v[216:219], v48 /*v304*/ offset:4640
	ds_load_b128 v[220:223], v48 /*v304*/ offset:6912
	ds_load_b128 v[224:227], v48 /*v304*/ offset:6944
	s_set_vgpr_msb 0x500
	ds_load_b128 v[228:231], v228
	ds_load_b128 v[232:235], v232
	s_set_vgpr_msb 5
	ds_load_b128 v[236:239], v64 /*v320*/
	ds_load_b128 v[240:243], v64 /*v320*/ offset:32
	s_wait_alu depctr_vm_vsrc(6)
	v_add_nc_u32_e32 v195, s0, v107 /*v363*/
	s_set_vgpr_msb 0x541
	ds_load_b128 v[36:39] /*v[292:295]*/, v48 /*v304*/ offset:4672
	ds_load_b128 v[40:43] /*v[296:299]*/, v48 /*v304*/ offset:4704
	ds_load_b128 v[44:47] /*v[300:303]*/, v48 /*v304*/ offset:6976
	s_wait_alu depctr_vm_vsrc(0)
	ds_load_b128 v[48:51] /*v[304:307]*/, v48 /*v304*/ offset:7008
	s_wait_alu depctr_va_vdst(1)
	s_set_vgpr_msb 0x4140
	ds_load_b128 v[52:55] /*v[308:311]*/, v192
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[56:59] /*v[312:315]*/, v195
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x4004
	v_dual_add_nc_u32 v192, s0, v103 /*v359*/ :: v_dual_add_nc_u32 v195, s0, v105 /*v361*/
	s_set_vgpr_msb 0x444
	v_dual_add_nc_u32 v76 /*v332*/, s0, v101 /*v357*/ :: v_dual_add_nc_u32 v92 /*v348*/, s0, v98 /*v354*/
	s_set_vgpr_msb 0x4404
	v_dual_add_nc_u32 v244, s0, v113 /*v369*/ :: v_dual_add_nc_u32 v248, s0, v115 /*v371*/
	s_set_vgpr_msb 0x441
	ds_load_b128 v[60:63] /*v[316:319]*/, v64 /*v320*/ offset:64
	s_wait_alu depctr_vm_vsrc(0)
	ds_load_b128 v[64:67] /*v[320:323]*/, v64 /*v320*/ offset:96
	s_wait_alu depctr_va_vdst(2)
	s_set_vgpr_msb 0x4140
	ds_load_b128 v[68:71] /*v[324:327]*/, v192
	ds_load_b128 v[72:75] /*v[328:331]*/, v195
	s_wait_alu depctr_va_vdst(1)
	s_set_vgpr_msb 0x4041
	ds_load_b128 v[76:79] /*v[332:335]*/, v76 /*v332*/
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x4104
	v_dual_add_nc_u32 v192, s0, v104 /*v360*/ :: v_dual_add_nc_u32 v195, s0, v99 /*v355*/
	s_set_vgpr_msb 0x444
	v_add_nc_u32_e32 v93 /*v349*/, s0, v100 /*v356*/
	s_wait_alu depctr_va_vdst(2)
	s_set_vgpr_msb 0x4400
	ds_load_b128 v[244:247], v244
	ds_load_b128 v[248:251], v248
	ds_load_b128 v[252:255], v252
	s_set_vgpr_msb 0x41
	ds_load_b128 v[0:3] /*v[256:259]*/, v0 /*v256*/
	ds_load_b128 v[4:7] /*v[260:263]*/, v4 /*v260*/
	s_wait_alu depctr_va_vdst(1)
	s_set_vgpr_msb 0x4140
	ds_load_b128 v[80:83] /*v[336:339]*/, v192
	ds_load_b128 v[84:87] /*v[340:343]*/, v195
	s_set_vgpr_msb 0x4041
	ds_load_b128 v[88:91] /*v[344:347]*/, v88 /*v344*/
	ds_load_b128 v[98:101] /*v[354:357]*/, v92 /*v348*/
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[102:105] /*v[358:361]*/, v93 /*v349*/
	s_set_vgpr_msb 0x4100
	s_wait_dscnt 0x17
	v_wmma_f32_16x16x32_bf16 v[8:15], v[228:235], v[196:203], v[8:15]
	s_wait_dscnt 0x14
	v_wmma_f32_16x16x32_bf16 v[48:55], v[236:243], v[196:203], v[48:55]
	s_wait_dscnt 0x8
	v_wmma_f32_16x16x32_bf16 v[64:71], v[244:251], v[196:203], v[64:71]
	s_wait_dscnt 0x6
	v_wmma_f32_16x16x32_bf16 v[80:87], v[252:259], v[196:203], v[80:87]
	s_set_vgpr_msb 1
	s_wait_dscnt 0x5
	v_wmma_f32_16x16x32_bf16 v[88:95], v[4:11] /*v[260:267]*/, v[196:203], v[88:95]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[12:19] /*v[268:275]*/, v[196:203], v[104:111]
	v_wmma_f32_16x16x32_bf16 v[160:167], v[12:19] /*v[268:275]*/, v[204:211], v[160:167]
	v_wmma_f32_16x16x32_bf16 v[136:143], v[4:11] /*v[260:267]*/, v[204:211], v[136:143]
	s_set_vgpr_msb 0x100
	v_wmma_f32_16x16x32_bf16 v[120:127], v[252:259], v[204:211], v[120:127]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[244:251], v[204:211], v[112:119]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[236:243], v[204:211], v[96:103]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[228:235], v[204:211], v[72:79]
	v_wmma_f32_16x16x32_bf16 v[128:135], v[228:235], v[212:219], v[128:135]
	v_wmma_f32_16x16x32_bf16 v[144:151], v[236:243], v[212:219], v[144:151]
	v_wmma_f32_16x16x32_bf16 v[152:159], v[244:251], v[212:219], v[152:159]
	v_wmma_f32_16x16x32_bf16 v[168:175], v[252:259], v[212:219], v[168:175]
	s_set_vgpr_msb 1
	v_wmma_f32_16x16x32_bf16 v[176:183], v[4:11] /*v[260:267]*/, v[212:219], v[176:183]
	v_wmma_f32_16x16x32_bf16 v[184:191], v[12:19] /*v[268:275]*/, v[212:219], v[184:191]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[12:19] /*v[268:275]*/, v[220:227], v[56:63]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[4:11] /*v[260:267]*/, v[220:227], v[40:47]
	s_set_vgpr_msb 0x100
	v_wmma_f32_16x16x32_bf16 v[32:39], v[252:259], v[220:227], v[32:39]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[244:251], v[220:227], v[24:31]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[236:243], v[220:227], v[16:23]
	v_wmma_f32_16x16x32_bf16 v[0:7], v[228:235], v[220:227], v[0:7]
	s_wait_dscnt 0x0
	s_set_vgpr_msb 5
	v_lshl_or_b32 v192, v96 /*v352*/, 3, s38
	s_wait_tensorcnt 0x0
	s_barrier_signal -1
	v_wmma_f32_16x16x32_bf16 v[8:15], v[52:59] /*v[308:315]*/, v[20:27] /*v[276:283]*/, v[8:15]
	s_wait_alu depctr_vm_vsrc(4)
	v_mad_u32 v192, 0xc0, v97 /*v353*/, v192
	s_mul_u64 s[0:1], s[10:11], s[34:35]
	s_lshl_b64 s[2:3], s[2:3], 1
	s_lshl_b64 s[0:1], s[0:1], 1
	s_cmp_lg_u32 s34, 0x80000000
	s_add_nc_u64 s[0:1], s[4:5], s[0:1]
	s_cselect_b32 s13, s35, 0
	v_wmma_f32_16x16x32_bf16 v[48:55], v[60:67] /*v[316:323]*/, v[20:27] /*v[276:283]*/, v[48:55]
	v_nop
	v_nop
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v15, v14, v15
	v_cvt_pk_bf16_f32 v14, v12, v13
	v_cvt_pk_bf16_f32 v13, v10, v11
	v_cvt_pk_bf16_f32 v12, v8, v9
	v_lshl_add_u32 v192, v192, 1, 0
	s_cselect_b32 s12, s34, 0xc0
	s_set_vgpr_msb 5
	s_barrier_wait -1
	v_wmma_f32_16x16x32_bf16 v[64:71], v[68:75] /*v[324:331]*/, v[20:27] /*v[276:283]*/, v[64:71]
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v11, v54, v55
	v_cvt_pk_bf16_f32 v10, v52, v53
	v_cvt_pk_bf16_f32 v9, v50, v51
	v_cvt_pk_bf16_f32 v8, v48, v49
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v192, v[12:15]
	ds_store_b128 v192, v[8:11] offset:32
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[80:87], v[76:83] /*v[332:339]*/, v[20:27] /*v[276:283]*/, v[80:87]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v11, v70, v71
	v_cvt_pk_bf16_f32 v10, v68, v69
	v_cvt_pk_bf16_f32 v9, v66, v67
	v_cvt_pk_bf16_f32 v8, v64, v65
	s_bfe_u32 s6, ttmp8, 0x50019
	s_add_nc_u64 s[0:1], s[0:1], s[2:3]
	s_and_b32 s9, s6, 3
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[88:95], v[84:91] /*v[340:347]*/, v[20:27] /*v[276:283]*/, v[88:95]
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v15, v86, v87
	v_cvt_pk_bf16_f32 v14, v84, v85
	v_cvt_pk_bf16_f32 v13, v82, v83
	v_cvt_pk_bf16_f32 v12, v80, v81
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v192, v[8:11] offset:64
	ds_store_b128 v192, v[12:15] offset:96
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[104:111], v[98:105] /*v[354:361]*/, v[20:27] /*v[276:283]*/, v[104:111]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v11, v94, v95
	v_cvt_pk_bf16_f32 v10, v92, v93
	v_cvt_pk_bf16_f32 v9, v90, v91
	v_cvt_pk_bf16_f32 v8, v88, v89
	s_lshl_b32 s4, s9, 5
	s_lshl_b32 s6, s9, 6
	s_sub_co_i32 s2, s33, s4
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[160:167], v[98:105] /*v[354:361]*/, v[28:35] /*v[284:291]*/, v[160:167]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v15, v110, v111
	v_cvt_pk_bf16_f32 v14, v108, v109
	v_cvt_pk_bf16_f32 v13, v106, v107
	v_cvt_pk_bf16_f32 v12, v104, v105
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v192, v[8:11] offset:128
	ds_store_b128 v192, v[12:15] offset:160
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[136:143], v[84:91] /*v[340:347]*/, v[28:35] /*v[284:291]*/, v[136:143]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v11, v166, v167
	v_cvt_pk_bf16_f32 v10, v164, v165
	v_cvt_pk_bf16_f32 v9, v162, v163
	v_cvt_pk_bf16_f32 v8, v160, v161
	s_max_i32 s4, s2, 0
	s_mul_u64 s[2:3], s[12:13], s[6:7]
	s_mul_i32 s5, s9, 0x3000
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[120:127], v[76:83] /*v[332:339]*/, v[28:35] /*v[284:291]*/, v[120:127]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v15, v142, v143
	v_cvt_pk_bf16_f32 v14, v140, v141
	v_cvt_pk_bf16_f32 v13, v138, v139
	v_cvt_pk_bf16_f32 v12, v136, v137
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v192, v[8:11] offset:6304
	ds_store_b128 v192, v[12:15] offset:6272
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[112:119], v[68:75] /*v[324:331]*/, v[28:35] /*v[284:291]*/, v[112:119]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v11, v126, v127
	v_cvt_pk_bf16_f32 v10, v124, v125
	v_cvt_pk_bf16_f32 v9, v122, v123
	v_cvt_pk_bf16_f32 v8, v120, v121
	s_add_nc_u64 s[10:11], s[2:3], s[0:1]
	s_lshr_b32 s0, s4, 16
	s_and_b32 s1, s13, 0xffff
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[96:103], v[60:67] /*v[316:323]*/, v[28:35] /*v[284:291]*/, v[96:103]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v15, v118, v119
	v_cvt_pk_bf16_f32 v14, v116, v117
	v_cvt_pk_bf16_f32 v13, v114, v115
	v_cvt_pk_bf16_f32 v12, v112, v113
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v192, v[8:11] offset:6240
	ds_store_b128 v192, v[12:15] offset:6208
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[72:79], v[52:59] /*v[308:315]*/, v[28:35] /*v[284:291]*/, v[72:79]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v11, v102, v103
	v_cvt_pk_bf16_f32 v10, v100, v101
	v_cvt_pk_bf16_f32 v9, v98, v99
	v_cvt_pk_bf16_f32 v8, v96, v97
	s_or_b32 s0, s0, 0xc00000
	v_mov_b32_e32 v195, s4
	s_add_co_i32 s9, s5, 0
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[128:135], v[52:59] /*v[308:315]*/, v[36:43] /*v[292:299]*/, v[128:135]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v15, v78, v79
	v_cvt_pk_bf16_f32 v14, v76, v77
	v_cvt_pk_bf16_f32 v13, v74, v75
	v_cvt_pk_bf16_f32 v12, v72, v73
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v192, v[8:11] offset:6176
	ds_store_b128 v192, v[12:15] offset:6144
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[144:151], v[60:67] /*v[316:323]*/, v[36:43] /*v[292:299]*/, v[144:151]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v11, v134, v135
	v_cvt_pk_bf16_f32 v10, v132, v133
	v_cvt_pk_bf16_f32 v9, v130, v131
	v_cvt_pk_bf16_f32 v8, v128, v129
	s_mov_b32 s8, 1
	s_bitset1_b32 s11, 31
	s_mov_b32 s4, 32
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[152:159], v[68:75] /*v[324:331]*/, v[36:43] /*v[292:299]*/, v[152:159]
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v15, v150, v151
	v_cvt_pk_bf16_f32 v14, v148, v149
	v_cvt_pk_bf16_f32 v13, v146, v147
	v_cvt_pk_bf16_f32 v12, v144, v145
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v192, v[8:11] offset:12288
	ds_store_b128 v192, v[12:15] offset:12320
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[168:175], v[76:83] /*v[332:339]*/, v[36:43] /*v[292:299]*/, v[168:175]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v11, v158, v159
	v_cvt_pk_bf16_f32 v10, v156, v157
	v_cvt_pk_bf16_f32 v9, v154, v155
	v_cvt_pk_bf16_f32 v8, v152, v153
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v15, v174, v175
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[176:183], v[84:91] /*v[340:347]*/, v[36:43] /*v[292:299]*/, v[176:183]
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v14, v172, v173
	v_cvt_pk_bf16_f32 v13, v170, v171
	v_cvt_pk_bf16_f32 v12, v168, v169
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v192, v[8:11] offset:12352
	ds_store_b128 v192, v[12:15] offset:12384
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[184:191], v[98:105] /*v[354:361]*/, v[36:43] /*v[292:299]*/, v[184:191]
	s_wait_alu depctr_vm_vsrc(1)
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v11, v182, v183
	v_cvt_pk_bf16_f32 v10, v180, v181
	v_cvt_pk_bf16_f32 v9, v178, v179
	v_cvt_pk_bf16_f32 v8, v176, v177
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v15, v190, v191
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[0:7], v[52:59] /*v[308:315]*/, v[44:51] /*v[300:307]*/, v[0:7]
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v14, v188, v189
	v_cvt_pk_bf16_f32 v13, v186, v187
	v_cvt_pk_bf16_f32 v12, v184, v185
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v192, v[8:11] offset:12416
	ds_store_b128 v192, v[12:15] offset:12448
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[16:23], v[60:67] /*v[316:323]*/, v[44:51] /*v[300:307]*/, v[16:23]
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v7, v6, v7
	v_cvt_pk_bf16_f32 v6, v4, v5
	v_cvt_pk_bf16_f32 v5, v2, v3
	v_cvt_pk_bf16_f32 v4, v0, v1
	s_delay_alu instid0(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v3, v22, v23
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[24:31], v[68:75] /*v[324:331]*/, v[44:51] /*v[300:307]*/, v[24:31]
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v2, v20, v21
	v_cvt_pk_bf16_f32 v1, v18, v19
	v_cvt_pk_bf16_f32 v0, v16, v17
	s_wait_alu depctr_vm_vsrc(1)
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v11, v30, v31
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[32:39], v[76:83] /*v[332:339]*/, v[44:51] /*v[300:307]*/, v[32:39]
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v10, v28, v29
	v_cvt_pk_bf16_f32 v9, v26, v27
	v_cvt_pk_bf16_f32 v8, v24, v25
	s_wait_alu depctr_vm_vsrc(0)
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v15, v38, v39
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[40:47], v[84:91] /*v[340:347]*/, v[44:51] /*v[300:307]*/, v[40:47]
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v14, v36, v37
	v_cvt_pk_bf16_f32 v13, v34, v35
	v_cvt_pk_bf16_f32 v12, v32, v33
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v19, v46, v47
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[56:63], v[98:105] /*v[354:361]*/, v[44:51] /*v[300:307]*/, v[56:63]
	s_set_vgpr_msb 0x500
	v_cvt_pk_bf16_f32 v18, v44, v45
	v_cvt_pk_bf16_f32 v17, v42, v43
	v_cvt_pk_bf16_f32 v16, v40, v41
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v23, v62, v63
	v_cvt_pk_bf16_f32 v22, v60, v61
	v_cvt_pk_bf16_f32 v21, v58, v59
	v_cvt_pk_bf16_f32 v20, v56, v57
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v192, v[4:7] offset:18432
	ds_store_b128 v192, v[0:3] offset:18464
	ds_store_b128 v192, v[8:11] offset:18496
	ds_store_b128 v192, v[12:15] offset:18528
	ds_store_b128 v192, v[16:19] offset:18560
	ds_store_b128 v192, v[20:23] offset:18592
	s_wait_dscnt 0x0
	s_barrier_signal -1
	s_wait_alu depctr_vm_vsrc(4)
	v_mov_b32_e32 v3, s0
	v_lshrrev_b64 v[0:1], 16, v[194:195]
	v_dual_mov_b32 v5, s12 :: v_dual_mov_b32 v6, s1
	v_readfirstlane_b32 s1, v193
	s_delay_alu instid0(VALU_DEP_4)
	v_readfirstlane_b32 s3, v3
	s_mov_b32 s0, 0x10000
	v_readfirstlane_b32 s2, v0
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
		.amdhsa_next_free_vgpr 420
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
		.amdhsa_inst_pref_size 78
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

	.set kernel_grouped_nt_0.num_vgpr, 420
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
    .vgpr_count:     420
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.target:   amdgcn-amd-amdhsa--gfx1250
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
