	.amdgcn_target "amdgcn-amd-amdhsa--gfx1250"
	.amdhsa_code_object_version 6
	.text
	.globl	kernel_grouped_nt_0
	.p2align	8
	.type	kernel_grouped_nt_0,@function
kernel_grouped_nt_0:
	s_setreg_imm32_b32 hwreg(HW_REG_WAVE_SCHED_MODE, 0, 2), 2
	s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
	s_clause 0x2
	s_load_b256 s[4:11], s[0:1], 0x0 nv
	s_load_b128 s[20:23], s[0:1], 0x20 nv
	s_load_b32 s34, s[0:1], 0x30 nv
	s_wait_xcnt 0x0
	s_mov_b32 s0, 1
	v_mov_b32_e32 v3, 0
	s_setreg_imm32_b32 hwreg(HW_REG_WAVE_SCHED_MODE, 2, 1), 1
	s_wait_kmcnt 0x0
	s_wait_alu depctr_va_vdst(0)
	global_load_b32 v1, v3, s[10:11] offset:64
	s_bfe_u32 s12, ttmp6, 0x4000c
	v_readfirstlane_b32 s35, v0
	s_ashr_i32 s3, s22, 31
	s_mov_b32 s2, s22
	s_add_co_i32 s12, s12, 1
	s_and_b32 s1, ttmp6, 15
	s_lshl_b64 s[24:25], s[2:3], 1
	s_mul_i32 s2, ttmp9, s12
	s_getreg_b32 s13, hwreg(HW_REG_IB_STS2, 6, 4)
	s_lshr_b32 s38, s35, 5
	s_add_co_i32 s1, s1, s2
	s_cmp_eq_u32 s13, 0
	s_cselect_b32 s1, ttmp9, s1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_hi_i32 s2, s1, 0x92492493
	s_add_co_i32 s2, s2, s1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_lshr_b32 s3, s2, 31
	s_ashr_i32 s2, s2, 9
	s_add_co_i32 s2, s2, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s3, s2, 0x380
	s_cmp_lg_u32 s1, s3
	s_cselect_b32 s12, -1, 0
	s_cmp_lt_i32 s1, 0
	s_cselect_b32 s13, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 s12, s13, s12
	s_sub_co_ci_u32 s29, s2, 0
	s_sub_co_i32 s36, s1, s3
	s_lshl_b32 s2, s29, 4
	s_abs_i32 s3, s36
	s_sub_co_i32 s12, 64, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_min_i32 s12, s12, 16
	s_abs_i32 s13, s12
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_cvt_f32_u32 s14, s13
	s_sub_co_i32 s15, 0, s13
	v_rcp_iflag_f32_e32 v2, s14
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_3)
	v_readfirstlane_b32 s14, v2
	s_mul_f32 s14, s14, 0x4f7ffffe
	s_cvt_u32_f32 s14, s14
	s_delay_alu instid0(SALU_CYCLE_3) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s15, s15, s14
	s_mul_hi_u32 s1, s14, s15
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s14, s14, s1
	s_mul_hi_u32 s1, s3, s14
	s_xor_b32 s14, s36, s12
	s_mul_i32 s15, s1, s13
	s_ashr_i32 s14, s14, 31
	s_sub_co_i32 s3, s3, s15
	s_add_co_i32 s15, s1, 1
	s_sub_co_i32 s16, s3, s13
	s_cmp_ge_u32 s3, s13
	s_cselect_b32 s1, s15, s1
	s_cselect_b32 s3, s16, s3
	s_add_co_i32 s15, s1, 1
	s_cmp_ge_u32 s3, s13
	s_movk_i32 s16, 0x80
	s_cselect_b32 s1, s15, s1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s1, s1, s14
	s_sub_co_i32 s37, s1, s14
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s39, s37, s12
	s_sub_co_i32 s1, s36, s39
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_co_i32 s1, s1, s2
	s_wait_loadcnt 0x0
	v_cmp_lt_i32_e32 vcc_lo, s1, v1
	v_cndmask_b32_e64 v2, 24, 8, vcc_lo
	v_cndmask_b32_e64 v1, 17, 0, vcc_lo
	v_cndmask_b32_e64 v5, 32, 16, vcc_lo
	s_wait_alu depctr_va_vdst(0)
	global_load_b32 v4, v2, s[10:11] scale_offset
	s_wait_loadcnt 0x0
	v_cmp_lt_i32_e32 vcc_lo, s1, v4
	v_or_b32_e32 v6, 1, v2
	s_wait_alu depctr_vm_vsrc(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_dual_cndmask_b32 v2, v5, v2 :: v_dual_cndmask_b32 v1, v6, v1
	v_add_nc_u32_e32 v4, v1, v2
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v4, 1, v4
	s_wait_alu depctr_va_vdst(0)
	global_load_b32 v5, v4, s[10:11] scale_offset
	s_wait_loadcnt 0x0
	v_cmp_lt_i32_e32 vcc_lo, s1, v5
	v_dual_mov_b32 v5, v3 :: v_dual_bitop2_b32 v6, 1, v4 bitop3:0x54
	v_cndmask_b32_e32 v2, v2, v4, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v1, v6, v1, vcc_lo
	s_wait_alu depctr_vm_vsrc(0)
	v_add_nc_u32_e32 v4, v1, v2
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v6, 1, v4
	s_wait_alu depctr_va_vdst(0)
	global_load_b32 v4, v6, s[10:11] scale_offset
	s_wait_loadcnt 0x0
	v_cmp_lt_i32_e32 vcc_lo, s1, v4
	v_add_nc_u32_e32 v7, 1, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_dual_cndmask_b32 v4, v7, v1, vcc_lo :: v_dual_cndmask_b32 v2, v2, v6, vcc_lo
	s_wait_alu depctr_vm_vsrc(0)
	v_add_nc_u64_e32 v[6:7], v[4:5], v[2:3]
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshrrev_b64 v[6:7], 1, v[6:7]
	v_lshlrev_b64_e32 v[8:9], 2, v[6:7]
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u64_e32 v[8:9], s[10:11], v[8:9]
	s_wait_alu depctr_va_vdst(0)
	global_load_b32 v1, v[8:9], off
	s_wait_loadcnt 0x0
	v_cmp_lt_i32_e32 vcc_lo, s1, v1
	v_dual_cndmask_b32 v2, v2, v6 :: v_dual_add_nc_u32 v5, 1, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_cndmask_b32_e32 v1, v5, v4, vcc_lo
	v_add_nc_u32_e32 v2, v1, v2
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshrrev_b32_e32 v2, 1, v2
	v_min_u32_e32 v4, 31, v2
	v_add_nc_u32_e32 v2, 1, v2
	s_wait_alu depctr_va_vdst(1)
	global_load_b32 v4, v4, s[10:11] scale_offset
	s_wait_loadcnt 0x0
	v_cmp_lt_i32_e32 vcc_lo, s1, v4
	v_cndmask_b32_e32 v1, v2, v1, vcc_lo
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_min_u32_e32 v1, 31, v1
	v_readfirstlane_b32 s28, v1
	s_add_co_i32 s2, s28, 32
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_ashr_i32 s3, s2, 31
	v_mov_b32_e32 v1, s2
	s_lshl_b64 s[12:13], s[2:3], 2
	s_add_nc_u64 s[12:13], s[10:11], s[12:13]
	s_wait_alu depctr_va_vdst(5)
	global_load_b64 v[2:3], v3, s[12:13]
	s_wait_alu depctr_va_vdst(0)
	global_load_b32 v1, v1, s[10:11] offset:-128 scale_offset
	s_wait_loadcnt 0x1
	v_readfirstlane_b32 s2, v2
	v_readfirstlane_b32 s3, v3
	s_sub_co_i32 s3, s3, s2
	s_wait_xcnt 0x0
	s_add_co_i32 s10, s3, 0x7f
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_ashr_i32 s11, s10, 31
	s_lshr_b32 s11, s11, 25
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_co_i32 s11, s10, s11
	s_and_b32 s12, s11, 0xffffff80
	s_ashr_i32 s11, s11, 7
	s_cmp_lg_u32 s10, s12
	s_wait_loadcnt 0x0
	v_readfirstlane_b32 s12, v1
	s_cselect_b32 s13, -1, 0
	s_cmp_lt_i32 s10, 0
	s_cselect_b32 s10, -1, 0
	s_sub_co_i32 s1, s1, s12
	s_and_b32 s10, s10, s13
	s_add_co_i32 s1, s1, s11
	s_cmp_lg_u32 s10, 0
	s_sub_co_ci_u32 s1, s1, 0
	s_delay_alu instid0(SALU_CYCLE_1)
	s_lshl_b32 s10, s1, 7
	s_mov_b32 s1, 0
	s_sub_co_i32 s3, s3, s10
	s_add_co_i32 s10, s10, s2
	s_wait_alu depctr_vm_vsrc(0)
	v_med3_i32 v1, s3, 0, 0x80
	s_cmp_gt_i32 s3, 0
	s_cselect_b32 s10, s10, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_ashr_i32 s11, s10, 31
	v_readfirstlane_b32 s33, v1
	s_cmp_eq_u32 s38, 0
	s_mul_u64 s[30:31], s[24:25], s[10:11]
	s_cselect_b32 s42, -1, 0
	s_cmp_lg_u32 s38, 0
	s_cbranch_scc1 .LBB0_2
	s_cmp_lg_u32 s22, -2.0
	s_add_nc_u64 s[2:3], s[6:7], s[30:31]
	s_cselect_b32 s17, s24, 0x100
	s_cselect_b32 s12, s25, 0
	s_max_i32 s13, s33, 0
	s_bitset1_b32 s3, 31
	s_lshl_b32 s14, s13, 16
	s_lshr_b32 s13, s13, 16
	s_addk_co_i32 s14, 0x7fff
	s_or_b32 s15, s13, 0x1000000
	s_and_b32 s18, s12, 0xffff
	s_mov_b32 s13, 0xffff0000
	s_mov_b32 s12, 0x7700000
	s_mov_b32 s19, s1
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[0:3], s[12:19]
.LBB0_2:
	s_ashr_i32 s1, s23, 31
	s_mov_b32 s0, s23
	s_delay_alu instid0(SALU_CYCLE_1)
	s_lshl_b64 s[26:27], s[0:1], 1
	s_cmp_lg_u32 s36, s39
	s_cselect_b32 s2, -1, 0
	s_cmp_lt_i32 s36, 0
	s_cselect_b32 s3, -1, 0
	s_cmp_gt_i32 s29, 4
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s3, s3, s12
	s_and_b32 s2, s3, s2
	s_sub_co_ci_u32 s2, s37, 0
	s_ashr_i32 s29, s28, 31
	s_lshl_b32 s2, s2, 7
	s_mul_u64 s[36:37], s[28:29], 0x1c00000
	s_sub_co_i32 s12, s21, s2
	s_ashr_i32 s3, s2, 31
	s_cmp_eq_u32 s38, 1
	s_cselect_b32 s39, -1, 0
	s_cmp_lg_u32 s38, 1
	s_cbranch_scc1 .LBB0_4
	s_mul_u64 s[14:15], s[26:27], s[2:3]
	s_add_nc_u64 s[16:17], s[8:9], s[36:37]
	s_cmp_lg_u32 s0, -2.0
	s_add_nc_u64 s[18:19], s[16:17], s[14:15]
	s_cselect_b32 s49, s26, 0x100
	s_cselect_b32 s13, s27, 0
	s_max_i32 s14, s12, 0
	s_mov_b32 s51, 0
	s_lshl_b32 s15, s14, 16
	s_lshr_b32 s14, s14, 16
	s_bitset1_b32 s19, 31
	s_add_co_i32 s17, 0, 0x8800
	s_mov_b32 s16, 1
	s_or_b32 s46, s15, 0x7fff
	s_or_b32 s47, s14, 0x1000000
	s_and_b32 s50, s13, 0xffff
	s_movk_i32 s48, 0x80
	s_mov_b32 s45, 0xffff0000
	s_mov_b32 s44, 0x7700000
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[16:19], s[44:51]
.LBB0_4:
	s_ashr_i32 s13, s20, 31
	s_set_vgpr_msb 0x50
	v_and_b32_e32 v69 /*v325*/, 15, v0
	s_lshr_b32 s13, s13, 25
	v_bfe_u32 v64 /*v320*/, v0, 4, 1
	s_add_co_i32 s13, s20, s13
	s_wait_tensorcnt 0x0
	s_and_b32 s14, s13, 0xffffff80
	v_and_or_b32 v65 /*v321*/, 0xffffffc0, s35, v69 /*v325*/
	s_ashr_i32 s29, s13, 7
	s_cmp_lg_u32 s20, s14
	s_cselect_b32 s13, -1, 0
	s_cmp_lt_i32 s20, 0
	s_set_vgpr_msb 0x5004
	v_mul_lo_u32 v1, 0x110, v65 /*v321*/
	s_cselect_b32 s14, -1, 0
	s_lshl_b32 s15, s38, 6
	s_barrier_signal -1
	s_and_b32 s38, s15, 64
	v_lshlrev_b32_e32 v0, 4, v64 /*v320*/
	s_and_b32 s13, s14, s13
	s_mov_b32 s14, -1
	s_cmp_lg_u32 s13, 0
	s_set_vgpr_msb 0x440
	v_add_nc_u32_e32 v70 /*v326*/, v1, v0
	s_set_vgpr_msb 0x4004
	v_or_b32_e32 v135, s38, v69 /*v325*/
	s_sub_co_ci_u32 s35, s29, 0
	s_set_vgpr_msb 0x440
	v_or_b32_e32 v75 /*v331*/, 0x8800, v0
	s_add_co_i32 s35, s35, -1
	s_set_vgpr_msb 0x4044
	v_add_nc_u32_e32 v74 /*v330*/, 64, v70 /*v326*/
	s_set_vgpr_msb 0x4400
	v_mad_u32_u24 v134, 0x110, v135, v0
	s_set_vgpr_msb 0x44
	v_add_nc_u32_e32 v73 /*v329*/, 0x80, v70 /*v326*/
	v_add_nc_u32_e32 v72 /*v328*/, 0xc0, v70 /*v326*/
	s_cmp_gt_i32 s35, 0
	s_set_vgpr_msb 0x4400
	s_barrier_wait -1
	s_cbranch_scc1 .LBB0_6
	v_or_b32_e32 v133, 0x8800, v0
	s_max_i32 s14, s12, 0
	s_set_vgpr_msb 64
	v_add_nc_u32_e32 v68 /*v324*/, 0x8840, v134
	s_lshl_b32 s15, s14, 16
	s_set_vgpr_msb 0x4004
	v_dual_mov_b32 v129, s15 :: v_dual_add_nc_u32 v132, 64, v70 /*v326*/
	v_dual_mov_b32 v130, s14 :: v_dual_add_nc_u32 v131, 0x80, v70 /*v326*/
	s_set_vgpr_msb 0x440
	v_add_nc_u32_e32 v67 /*v323*/, 0x8880, v134
	v_mad_u32_u24 v71 /*v327*/, 0x110, v135, v133
	s_set_vgpr_msb 0x4004
	v_add_nc_u32_e32 v128, 0xc0, v70 /*v326*/
	s_set_vgpr_msb 0x440
	v_add_nc_u32_e32 v66 /*v322*/, 0x88c0, v134
	s_mov_b32 s14, 0
	s_set_vgpr_msb 0x4000
.LBB0_6:
	v_mov_b32_e32 v15, 0
	s_and_not1_b32 vcc_lo, exec_lo, s14
	s_mov_b32 s28, 1
	s_delay_alu instid0(VALU_DEP_1)
	v_dual_mov_b32 v14, v15 :: v_dual_mov_b32 v13, v15
	v_dual_mov_b32 v12, v15 :: v_dual_mov_b32 v11, v15
	v_dual_mov_b32 v10, v15 :: v_dual_mov_b32 v9, v15
	v_dual_mov_b32 v8, v15 :: v_dual_mov_b32 v47, v15
	v_dual_mov_b32 v46, v15 :: v_dual_mov_b32 v45, v15
	v_dual_mov_b32 v44, v15 :: v_dual_mov_b32 v43, v15
	v_dual_mov_b32 v42, v15 :: v_dual_mov_b32 v41, v15
	v_dual_mov_b32 v40, v15 :: v_dual_mov_b32 v63, v15
	v_dual_mov_b32 v62, v15 :: v_dual_mov_b32 v61, v15
	v_dual_mov_b32 v60, v15 :: v_dual_mov_b32 v59, v15
	v_dual_mov_b32 v58, v15 :: v_dual_mov_b32 v57, v15
	v_dual_mov_b32 v56, v15 :: v_dual_mov_b32 v71, v15
	v_dual_mov_b32 v70, v15 :: v_dual_mov_b32 v69, v15
	v_dual_mov_b32 v68, v15 :: v_dual_mov_b32 v67, v15
	v_dual_mov_b32 v66, v15 :: v_dual_mov_b32 v65, v15
	v_dual_mov_b32 v64, v15 :: v_dual_mov_b32 v55, v15
	v_dual_mov_b32 v54, v15 :: v_dual_mov_b32 v53, v15
	v_dual_mov_b32 v52, v15 :: v_dual_mov_b32 v51, v15
	v_dual_mov_b32 v50, v15 :: v_dual_mov_b32 v49, v15
	v_dual_mov_b32 v48, v15 :: v_dual_mov_b32 v79, v15
	v_dual_mov_b32 v78, v15 :: v_dual_mov_b32 v77, v15
	v_dual_mov_b32 v76, v15 :: v_dual_mov_b32 v75, v15
	v_dual_mov_b32 v74, v15 :: v_dual_mov_b32 v73, v15
	v_dual_mov_b32 v72, v15 :: v_dual_mov_b32 v87, v15
	v_dual_mov_b32 v86, v15 :: v_dual_mov_b32 v85, v15
	v_dual_mov_b32 v84, v15 :: v_dual_mov_b32 v83, v15
	v_dual_mov_b32 v82, v15 :: v_dual_mov_b32 v81, v15
	v_dual_mov_b32 v80, v15 :: v_dual_mov_b32 v111, v15
	v_dual_mov_b32 v110, v15 :: v_dual_mov_b32 v109, v15
	v_dual_mov_b32 v108, v15 :: v_dual_mov_b32 v107, v15
	v_dual_mov_b32 v106, v15 :: v_dual_mov_b32 v105, v15
	v_dual_mov_b32 v104, v15 :: v_dual_mov_b32 v95, v15
	v_dual_mov_b32 v94, v15 :: v_dual_mov_b32 v93, v15
	v_dual_mov_b32 v92, v15 :: v_dual_mov_b32 v91, v15
	v_dual_mov_b32 v90, v15 :: v_dual_mov_b32 v89, v15
	v_dual_mov_b32 v88, v15 :: v_dual_mov_b32 v103, v15
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
	v_dual_mov_b32 v120, v15 :: v_dual_mov_b32 v7, v15
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
	v_mov_b32_e32 v32, v15
	s_cbranch_vccnz .LBB0_14
	s_cmp_lg_u32 s22, -2.0
	v_cndmask_b32_e64 v0, 0, -1, s13
	s_cselect_b32 s17, s24, 0x100
	s_cselect_b32 s13, s25, 0
	s_max_i32 s14, s33, 0
	v_mov_b32_e32 v8, 0
	s_lshl_b32 s15, s14, 16
	s_lshr_b32 s18, s14, 16
	s_or_b32 s14, s15, 0x7fff
	s_or_b32 s15, s18, 0x1000000
	s_and_b32 s18, s13, 0xffff
	s_cmp_lg_u32 s0, -2.0
	s_mul_u64 s[0:1], s[0:1], s[2:3]
	s_set_vgpr_msb 64
	v_add_nc_u32_e32 v76 /*v332*/, s29, v0
	s_set_vgpr_msb 0x4000
	v_cndmask_b32_e64 v0, 0, 1, s42
	s_cselect_b32 s43, s26, 0x100
	s_cselect_b32 s20, s27, 0
	s_lshl_b64 s[0:1], s[0:1], 1
	s_max_i32 s40, s12, 0
	s_add_nc_u64 s[0:1], s[8:9], s[0:1]
	s_mov_b32 s19, 0
	s_lshl_b32 s41, s40, 16
	s_lshr_b32 s21, s40, 16
	s_set_vgpr_msb 0x50
	v_mad_u32_u24 v71 /*v327*/, 0x110, v135, v75 /*v331*/
	v_add_nc_u32_e32 v68 /*v324*/, 0x8840, v134
	s_movk_i32 s16, 0x80
	v_add_nc_u32_e32 v67 /*v323*/, 0x8880, v134
	v_add_nc_u32_e32 v66 /*v322*/, 0x88c0, v134
	s_add_nc_u64 s[8:9], s[0:1], s[36:37]
	v_cmp_ne_u32_e64 s0, 1, v0
	s_set_vgpr_msb 0x5000
	v_dual_mov_b32 v9, v8 :: v_dual_mov_b32 v10, v8
	v_dual_mov_b32 v11, v8 :: v_dual_mov_b32 v12, v8
	v_dual_mov_b32 v13, v8 :: v_dual_mov_b32 v14, v8
	v_dual_mov_b32 v15, v8 :: v_dual_mov_b32 v40, v8
	v_dual_mov_b32 v41, v8 :: v_dual_mov_b32 v42, v8
	v_dual_mov_b32 v43, v8 :: v_dual_mov_b32 v44, v8
	v_dual_mov_b32 v45, v8 :: v_dual_mov_b32 v46, v8
	v_dual_mov_b32 v47, v8 :: v_dual_mov_b32 v56, v8
	v_dual_mov_b32 v57, v8 :: v_dual_mov_b32 v58, v8
	v_dual_mov_b32 v59, v8 :: v_dual_mov_b32 v60, v8
	v_dual_mov_b32 v61, v8 :: v_dual_mov_b32 v62, v8
	v_dual_mov_b32 v63, v8 :: v_dual_mov_b32 v64, v8
	v_dual_mov_b32 v65, v8 :: v_dual_mov_b32 v66, v8
	v_dual_mov_b32 v67, v8 :: v_dual_mov_b32 v68, v8
	v_dual_mov_b32 v69, v8 :: v_dual_mov_b32 v70, v8
	v_dual_mov_b32 v71, v8 :: v_dual_mov_b32 v48, v8
	v_dual_mov_b32 v49, v8 :: v_dual_mov_b32 v50, v8
	v_dual_mov_b32 v51, v8 :: v_dual_mov_b32 v52, v8
	v_dual_mov_b32 v53, v8 :: v_dual_mov_b32 v54, v8
	v_dual_mov_b32 v55, v8 :: v_dual_mov_b32 v72, v8
	v_dual_mov_b32 v73, v8 :: v_dual_mov_b32 v74, v8
	v_dual_mov_b32 v75, v8 :: v_dual_mov_b32 v76, v8
	v_dual_mov_b32 v77, v8 :: v_dual_mov_b32 v78, v8
	v_dual_mov_b32 v79, v8 :: v_dual_mov_b32 v80, v8
	v_dual_mov_b32 v81, v8 :: v_dual_mov_b32 v82, v8
	v_dual_mov_b32 v83, v8 :: v_dual_mov_b32 v84, v8
	v_dual_mov_b32 v85, v8 :: v_dual_mov_b32 v86, v8
	v_dual_mov_b32 v87, v8 :: v_dual_mov_b32 v104, v8
	v_dual_mov_b32 v105, v8 :: v_dual_mov_b32 v106, v8
	v_dual_mov_b32 v107, v8 :: v_dual_mov_b32 v108, v8
	v_dual_mov_b32 v109, v8 :: v_dual_mov_b32 v110, v8
	v_dual_mov_b32 v111, v8 :: v_dual_mov_b32 v88, v8
	v_dual_mov_b32 v89, v8 :: v_dual_mov_b32 v90, v8
	v_dual_mov_b32 v91, v8 :: v_dual_mov_b32 v92, v8
	v_dual_mov_b32 v93, v8 :: v_dual_mov_b32 v94, v8
	v_dual_mov_b32 v95, v8 :: v_dual_mov_b32 v96, v8
	v_dual_mov_b32 v97, v8 :: v_dual_mov_b32 v98, v8
	v_dual_mov_b32 v99, v8 :: v_dual_mov_b32 v100, v8
	v_dual_mov_b32 v101, v8 :: v_dual_mov_b32 v102, v8
	v_dual_mov_b32 v103, v8 :: v_dual_mov_b32 v112, v8
	v_dual_mov_b32 v113, v8 :: v_dual_mov_b32 v114, v8
	v_dual_mov_b32 v115, v8 :: v_dual_mov_b32 v116, v8
	v_dual_mov_b32 v117, v8 :: v_dual_mov_b32 v118, v8
	v_dual_mov_b32 v119, v8 :: v_dual_mov_b32 v120, v8
	v_dual_mov_b32 v121, v8 :: v_dual_mov_b32 v122, v8
	v_dual_mov_b32 v123, v8 :: v_dual_mov_b32 v124, v8
	v_dual_mov_b32 v125, v8 :: v_dual_mov_b32 v126, v8
	v_dual_mov_b32 v127, v8 :: v_dual_mov_b32 v0, v8
	v_dual_mov_b32 v1, v8 :: v_dual_mov_b32 v2, v8
	v_dual_mov_b32 v3, v8 :: v_dual_mov_b32 v4, v8
	v_dual_mov_b32 v5, v8 :: v_dual_mov_b32 v6, v8
	v_dual_mov_b32 v7, v8 :: v_dual_mov_b32 v16, v8
	v_dual_mov_b32 v17, v8 :: v_dual_mov_b32 v18, v8
	v_dual_mov_b32 v19, v8 :: v_dual_mov_b32 v20, v8
	v_dual_mov_b32 v21, v8 :: v_dual_mov_b32 v22, v8
	v_dual_mov_b32 v23, v8 :: v_dual_mov_b32 v24, v8
	v_dual_mov_b32 v25, v8 :: v_dual_mov_b32 v26, v8
	v_dual_mov_b32 v27, v8 :: v_dual_mov_b32 v28, v8
	v_dual_mov_b32 v29, v8 :: v_dual_mov_b32 v30, v8
	v_dual_mov_b32 v31, v8 :: v_dual_mov_b32 v32, v8
	v_dual_mov_b32 v33, v8 :: v_dual_mov_b32 v34, v8
	v_dual_mov_b32 v35, v8 :: v_dual_mov_b32 v36, v8
	v_dual_mov_b32 v37, v8 :: v_dual_mov_b32 v38, v8
	v_mov_b32_e32 v39, v8
	s_mov_b32 s13, 0xffff0000
	s_mov_b32 s12, 0x7700000
	s_or_b32 s44, s41, 0x7fff
	s_or_b32 s45, s21, 0x1000000
	s_and_b32 s46, s20, 0xffff
	s_mov_b64 s[26:27], s[18:19]
	s_add_nc_u64 s[6:7], s[6:7], s[30:31]
	s_mov_b64 s[24:25], s[16:17]
	s_mov_b64 s[22:23], s[14:15]
	s_mov_b64 s[20:21], s[12:13]
	s_mov_b32 s22, s44
	s_mov_b32 s23, s45
	s_mov_b32 s25, s43
	s_mov_b32 s26, s46
	s_add_nc_u64 s[6:7], s[6:7], 0x100
	s_add_nc_u64 s[8:9], s[8:9], 0x100
	s_mov_b32 s1, 1
	s_branch .LBB0_9
.LBB0_8:
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[8:15], v[8:15] /*v[264:271]*/, v[56:63] /*v[312:319]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[24:31] /*v[280:287]*/, v[56:63] /*v[312:319]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[32:39] /*v[288:295]*/, v[56:63] /*v[312:319]*/, v[56:63]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[48:55] /*v[304:311]*/, v[56:63] /*v[312:319]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[48:55] /*v[304:311]*/, v[40:47] /*v[296:303]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[32:39] /*v[288:295]*/, v[40:47] /*v[296:303]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[24:31] /*v[280:287]*/, v[40:47] /*v[296:303]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[8:15] /*v[264:271]*/, v[40:47] /*v[296:303]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[8:15] /*v[264:271]*/, v[16:23] /*v[272:279]*/, v[88:95]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[24:31] /*v[280:287]*/, v[16:23] /*v[272:279]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[32:39] /*v[288:295]*/, v[16:23] /*v[272:279]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[48:55] /*v[304:311]*/, v[16:23] /*v[272:279]*/, v[120:127]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[48:55] /*v[304:311]*/, v[0:7] /*v[256:263]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[32:39] /*v[288:295]*/, v[0:7] /*v[256:263]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[24:31] /*v[280:287]*/, v[0:7] /*v[256:263]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[0:7], v[8:15] /*v[264:271]*/, v[0:7] /*v[256:263]*/, v[0:7]
	s_set_vgpr_msb 0x541
	ds_load_b128 v[0:3] /*v[256:259]*/, v78 /*v334*/ offset:192
	ds_load_b128 v[4:7] /*v[260:263]*/, v78 /*v334*/ offset:224
	ds_load_b128 v[8:11] /*v[264:267]*/, v78 /*v334*/ offset:4544
	ds_load_b128 v[12:15] /*v[268:271]*/, v78 /*v334*/ offset:4576
	ds_load_b128 v[16:19] /*v[272:275]*/, v78 /*v334*/ offset:8896
	ds_load_b128 v[20:23] /*v[276:279]*/, v78 /*v334*/ offset:8928
	ds_load_b128 v[24:27] /*v[280:283]*/, v78 /*v334*/ offset:13248
	ds_load_b128 v[28:31] /*v[284:287]*/, v78 /*v334*/ offset:13280
	ds_load_b128 v[32:35] /*v[288:291]*/, v77 /*v333*/ offset:192
	ds_load_b128 v[36:39] /*v[292:295]*/, v77 /*v333*/ offset:224
	ds_load_b128 v[40:43] /*v[296:299]*/, v77 /*v333*/ offset:4544
	ds_load_b128 v[44:47] /*v[300:303]*/, v77 /*v333*/ offset:4576
	ds_load_b128 v[48:51] /*v[304:307]*/, v77 /*v333*/ offset:8896
	ds_load_b128 v[52:55] /*v[308:311]*/, v77 /*v333*/ offset:8928
	ds_load_b128 v[56:59] /*v[312:315]*/, v77 /*v333*/ offset:13248
	ds_load_b128 v[60:63] /*v[316:319]*/, v77 /*v333*/ offset:13280
	s_set_vgpr_msb 0x4100
	s_wait_dscnt 0x26
	v_wmma_f32_16x16x32_bf16 v[8:15], v[200:207], v[248:255], v[8:15]
	s_wait_dscnt 0x20
	v_wmma_f32_16x16x32_bf16 v[40:47], v[216:223], v[248:255], v[40:47]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[224:231], v[248:255], v[56:63]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[240:247], v[248:255], v[64:71]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[240:247], v[232:239], v[104:111]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[224:231], v[232:239], v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[216:223], v[232:239], v[72:79]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[200:207], v[232:239], v[48:55]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[200:207], v[208:215], v[88:95]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[216:223], v[208:215], v[96:103]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[224:231], v[208:215], v[112:119]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[240:247], v[208:215], v[120:127]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[240:247], v[192:199], v[32:39]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[224:231], v[192:199], v[24:31]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[216:223], v[192:199], v[16:23]
	v_wmma_f32_16x16x32_bf16 v[0:7], v[200:207], v[192:199], v[0:7]
	s_wait_dscnt 0x16
	v_wmma_f32_16x16x32_bf16 v[8:15], v[136:143], v[184:191], v[8:15]
	s_wait_dscnt 0x10
	v_wmma_f32_16x16x32_bf16 v[40:47], v[152:159], v[184:191], v[40:47]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[160:167], v[184:191], v[56:63]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[176:183], v[184:191], v[64:71]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[176:183], v[168:175], v[104:111]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[160:167], v[168:175], v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[152:159], v[168:175], v[72:79]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[136:143], v[168:175], v[48:55]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[136:143], v[144:151], v[88:95]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[152:159], v[144:151], v[96:103]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[160:167], v[144:151], v[112:119]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[176:183], v[144:151], v[120:127]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[176:183], v[128:135], v[32:39]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[160:167], v[128:135], v[24:31]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[152:159], v[128:135], v[16:23]
	v_wmma_f32_16x16x32_bf16 v[0:7], v[136:143], v[128:135], v[0:7]
	s_wait_dscnt 0x0
	s_wait_tensorcnt 0x0
	s_barrier_signal -1
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[8:15], v[32:39] /*v[288:295]*/, v[0:7] /*v[256:263]*/, v[8:15]
	v_wmma_f32_16x16x32_bf16 v[40:47], v[40:47] /*v[296:303]*/, v[0:7] /*v[256:263]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[48:55] /*v[304:311]*/, v[0:7] /*v[256:263]*/, v[56:63]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[56:63] /*v[312:319]*/, v[0:7] /*v[256:263]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[56:63] /*v[312:319]*/, v[8:15] /*v[264:271]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[48:55] /*v[304:311]*/, v[8:15] /*v[264:271]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[40:47] /*v[296:303]*/, v[8:15] /*v[264:271]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[32:39] /*v[288:295]*/, v[8:15] /*v[264:271]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[32:39] /*v[288:295]*/, v[16:23] /*v[272:279]*/, v[88:95]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[40:47] /*v[296:303]*/, v[16:23] /*v[272:279]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[48:55] /*v[304:311]*/, v[16:23] /*v[272:279]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[56:63] /*v[312:319]*/, v[16:23] /*v[272:279]*/, v[120:127]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[56:63] /*v[312:319]*/, v[24:31] /*v[280:287]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[48:55] /*v[304:311]*/, v[24:31] /*v[280:287]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[40:47] /*v[296:303]*/, v[24:31] /*v[280:287]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[0:7], v[32:39] /*v[288:295]*/, v[24:31] /*v[280:287]*/, v[0:7]
	s_add_co_i32 s1, s1, 1
	s_add_nc_u64 s[6:7], s[6:7], 0x100
	v_cmp_ne_u32_e32 vcc_lo, s1, v76 /*v332*/
	s_add_nc_u64 s[8:9], s[8:9], 0x100
	s_set_vgpr_msb 0x500
	s_barrier_wait -1
	s_cbranch_vccz .LBB0_13
.LBB0_9:
	s_bitcmp1_b32 s1, 0
	s_cselect_b32 s29, 0, 0x11000
	s_cselect_b32 s36, 0x11000, 0
	s_add_co_i32 s29, s29, 0
	s_wait_alu depctr_vm_vsrc(0)
	s_set_vgpr_msb 0x45
	v_dual_add_nc_u32 v78 /*v334*/, s29, v70 /*v326*/ :: v_dual_add_nc_u32 v77 /*v333*/, s29, v71 /*v327*/
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[56:59] /*v[312:315]*/, v78 /*v334*/
	ds_load_b128 v[60:63] /*v[316:319]*/, v78 /*v334*/ offset:32
	ds_load_b128 v[40:43] /*v[296:299]*/, v78 /*v334*/ offset:4352
	ds_load_b128 v[44:47] /*v[300:303]*/, v78 /*v334*/ offset:4384
	ds_load_b128 v[16:19] /*v[272:275]*/, v78 /*v334*/ offset:8704
	ds_load_b128 v[20:23] /*v[276:279]*/, v78 /*v334*/ offset:8736
	ds_load_b128 v[0:3] /*v[256:259]*/, v78 /*v334*/ offset:13056
	ds_load_b128 v[4:7] /*v[260:263]*/, v78 /*v334*/ offset:13088
	ds_load_b128 v[8:11] /*v[264:267]*/, v77 /*v333*/
	ds_load_b128 v[12:15] /*v[268:271]*/, v77 /*v333*/ offset:32
	ds_load_b128 v[24:27] /*v[280:283]*/, v77 /*v333*/ offset:4352
	ds_load_b128 v[28:31] /*v[284:287]*/, v77 /*v333*/ offset:4384
	ds_load_b128 v[32:35] /*v[288:291]*/, v77 /*v333*/ offset:8704
	ds_load_b128 v[36:39] /*v[292:295]*/, v77 /*v333*/ offset:8736
	ds_load_b128 v[48:51] /*v[304:307]*/, v77 /*v333*/ offset:13056
	ds_load_b128 v[52:55] /*v[308:311]*/, v77 /*v333*/ offset:13088
	s_set_vgpr_msb 0x4501
	ds_load_b128 v[248:251], v78 /*v334*/ offset:64
	ds_load_b128 v[252:255], v78 /*v334*/ offset:96
	ds_load_b128 v[232:235], v78 /*v334*/ offset:4416
	ds_load_b128 v[236:239], v78 /*v334*/ offset:4448
	ds_load_b128 v[208:211], v78 /*v334*/ offset:8768
	ds_load_b128 v[212:215], v78 /*v334*/ offset:8800
	ds_load_b128 v[192:195], v78 /*v334*/ offset:13120
	ds_load_b128 v[196:199], v78 /*v334*/ offset:13152
	ds_load_b128 v[200:203], v77 /*v333*/ offset:64
	ds_load_b128 v[204:207], v77 /*v333*/ offset:96
	ds_load_b128 v[216:219], v77 /*v333*/ offset:4416
	ds_load_b128 v[220:223], v77 /*v333*/ offset:4448
	ds_load_b128 v[224:227], v77 /*v333*/ offset:8768
	ds_load_b128 v[228:231], v77 /*v333*/ offset:8800
	ds_load_b128 v[240:243], v77 /*v333*/ offset:13120
	ds_load_b128 v[244:247], v77 /*v333*/ offset:13152
	ds_load_b128 v[184:187], v78 /*v334*/ offset:128
	ds_load_b128 v[188:191], v78 /*v334*/ offset:160
	ds_load_b128 v[168:171], v78 /*v334*/ offset:4480
	ds_load_b128 v[172:175], v78 /*v334*/ offset:4512
	ds_load_b128 v[144:147], v78 /*v334*/ offset:8832
	ds_load_b128 v[148:151], v78 /*v334*/ offset:8864
	ds_load_b128 v[128:131], v78 /*v334*/ offset:13184
	ds_load_b128 v[132:135], v78 /*v334*/ offset:13216
	ds_load_b128 v[136:139], v77 /*v333*/ offset:128
	ds_load_b128 v[140:143], v77 /*v333*/ offset:160
	ds_load_b128 v[152:155], v77 /*v333*/ offset:4480
	ds_load_b128 v[156:159], v77 /*v333*/ offset:4512
	ds_load_b128 v[160:163], v77 /*v333*/ offset:8832
	ds_load_b128 v[164:167], v77 /*v333*/ offset:8864
	ds_load_b128 v[176:179], v77 /*v333*/ offset:13184
	ds_load_b128 v[180:183], v77 /*v333*/ offset:13216
	s_wait_dscnt 0x20
	s_and_b32 vcc_lo, exec_lo, s0
	s_set_vgpr_msb 0x100
	s_cbranch_vccz .LBB0_11
	s_and_not1_b32 vcc_lo, exec_lo, s39
	s_cbranch_vccnz .LBB0_8
	s_branch .LBB0_12
.LBB0_11:
	s_add_co_i32 s29, s36, 0
	s_or_b32 s31, s7, 0x80000000
	s_mov_b32 s30, s6
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[28:31], s[12:19]
	s_and_not1_b32 vcc_lo, exec_lo, s39
	s_cbranch_vccnz .LBB0_8
.LBB0_12:
	s_add_co_i32 s29, s36, 0
	s_or_b32 s31, s9, 0x80000000
	s_add_co_i32 s29, s29, 0x8800
	s_mov_b32 s30, s8
	s_delay_alu instid0(SALU_CYCLE_1)
	tensor_load_to_lds s[28:31], s[20:27]
	s_branch .LBB0_8
.LBB0_13:
	v_dual_mov_b32 v129, s41 :: v_dual_mov_b32 v130, s40
	s_set_vgpr_msb 1
	v_dual_mov_b32 v133, v75 /*v331*/ :: v_dual_mov_b32 v132, v74 /*v330*/
	v_dual_mov_b32 v131, v73 /*v329*/ :: v_dual_mov_b32 v128, v72 /*v328*/
	s_set_vgpr_msb 0x100
.LBB0_14:
	s_lshr_b32 s0, s35, 31
	s_set_vgpr_msb 1
	v_add3_u32 v134, v69 /*v325*/, s38, 16
	s_add_co_i32 s0, s35, s0
	s_mov_b32 s7, 0
	s_and_b32 s0, s0, 0xffffe
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(SALU_CYCLE_1)
	v_mul_u32_u24_e32 v134, 0x110, v134
	s_sub_co_i32 s0, s35, s0
	s_ashr_i32 s35, s34, 31
	s_mul_i32 s0, s0, 0x11000
	s_add_co_i32 s0, s0, 0
	s_set_vgpr_msb 0x140
	v_add3_u32 v63 /*v319*/, v133, v134, s0
	s_set_vgpr_msb 0x4044
	v_add_nc_u32_e32 v62 /*v318*/, s0, v70 /*v326*/
	s_set_vgpr_msb 0x4400
	v_dual_add_nc_u32 v132, s0, v132 :: v_dual_add_nc_u32 v131, s0, v131
	s_set_vgpr_msb 5
	v_add_nc_u32_e32 v170, s0, v71 /*v327*/
	s_wait_alu depctr_va_vdst(0)
	ds_load_b128 v[246:249], v63 /*v319*/ offset:4416
	ds_load_b128 v[250:253], v63 /*v319*/ offset:4448
	ds_load_b128 v[254:257], v63 /*v319*/ offset:8768
	s_set_vgpr_msb 0x541
	ds_load_b128 v[2:5] /*v[258:261]*/, v63 /*v319*/ offset:8800
	s_set_vgpr_msb 0x4140
	ds_load_b128 v[6:9] /*v[262:265]*/, v131
	ds_load_b128 v[10:13] /*v[266:269]*/, v131 offset:32
	s_set_vgpr_msb 0x4041
	ds_load_b128 v[14:17] /*v[270:273]*/, v62 /*v318*/ offset:4480
	ds_load_b128 v[18:21] /*v[274:277]*/, v62 /*v318*/ offset:4512
	s_wait_alu depctr_vm_vsrc(2)
	s_set_vgpr_msb 0x4105
	v_add_nc_u32_e32 v131, s0, v67 /*v323*/
	ds_load_b128 v[182:185], v63 /*v319*/ offset:4352
	ds_load_b128 v[186:189], v63 /*v319*/ offset:4384
	ds_load_b128 v[190:193], v63 /*v319*/ offset:8704
	ds_load_b128 v[194:197], v63 /*v319*/ offset:8736
	s_set_vgpr_msb 0x500
	ds_load_b128 v[198:201], v132
	ds_load_b128 v[202:205], v132 offset:32
	s_set_vgpr_msb 5
	ds_load_b128 v[206:209], v62 /*v318*/ offset:4416
	ds_load_b128 v[210:213], v62 /*v318*/ offset:4448
	s_wait_alu depctr_vm_vsrc(2)
	v_add_nc_u32_e32 v132, s0, v68 /*v324*/
	ds_load_b128 v[134:137], v62 /*v318*/
	ds_load_b128 v[138:141], v62 /*v318*/ offset:32
	ds_load_b128 v[142:145], v62 /*v318*/ offset:4352
	ds_load_b128 v[146:149], v62 /*v318*/ offset:4384
	ds_load_b128 v[150:153], v62 /*v318*/ offset:8704
	ds_load_b128 v[154:157], v62 /*v318*/ offset:8736
	ds_load_b128 v[158:161], v62 /*v318*/ offset:13056
	ds_load_b128 v[162:165], v62 /*v318*/ offset:13088
	s_set_vgpr_msb 0x500
	ds_load_b128 v[166:169], v170
	s_wait_alu depctr_vm_vsrc(0)
	ds_load_b128 v[170:173], v170 offset:32
	s_set_vgpr_msb 1
	ds_load_b128 v[174:177], v63 /*v319*/
	ds_load_b128 v[178:181], v63 /*v319*/ offset:32
	s_set_vgpr_msb 0x141
	ds_load_b128 v[22:25] /*v[278:281]*/, v62 /*v318*/ offset:8832
	ds_load_b128 v[26:29] /*v[282:285]*/, v62 /*v318*/ offset:8864
	ds_load_b128 v[30:33] /*v[286:289]*/, v62 /*v318*/ offset:13184
	ds_load_b128 v[34:37] /*v[290:293]*/, v62 /*v318*/ offset:13216
	s_wait_alu depctr_va_vdst(1)
	s_set_vgpr_msb 0x4140
	ds_load_b128 v[38:41] /*v[294:297]*/, v131
	ds_load_b128 v[42:45] /*v[298:301]*/, v131 offset:32
	s_set_vgpr_msb 0x4041
	ds_load_b128 v[46:49] /*v[302:305]*/, v63 /*v319*/ offset:128
	ds_load_b128 v[50:53] /*v[306:309]*/, v63 /*v319*/ offset:160
	ds_load_b128 v[54:57] /*v[310:313]*/, v63 /*v319*/ offset:4480
	ds_load_b128 v[58:61] /*v[314:317]*/, v63 /*v319*/ offset:4512
	ds_load_b128 v[68:71] /*v[324:327]*/, v63 /*v319*/ offset:8832
	ds_load_b128 v[72:75] /*v[328:331]*/, v63 /*v319*/ offset:8864
	s_set_vgpr_msb 0x4101
	ds_load_b128 v[214:217], v62 /*v318*/ offset:8768
	ds_load_b128 v[218:221], v62 /*v318*/ offset:8800
	ds_load_b128 v[222:225], v62 /*v318*/ offset:13120
	ds_load_b128 v[226:229], v62 /*v318*/ offset:13152
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x100
	ds_load_b128 v[230:233], v132
	ds_load_b128 v[234:237], v132 offset:32
	s_set_vgpr_msb 1
	ds_load_b128 v[238:241], v63 /*v319*/ offset:64
	ds_load_b128 v[242:245], v63 /*v319*/ offset:96
	s_set_vgpr_msb 0x100
	s_wait_dscnt 0x16
	v_wmma_f32_16x16x32_bf16 v[8:15], v[166:173], v[134:141], v[8:15]
	s_wait_dscnt 0x14
	v_wmma_f32_16x16x32_bf16 v[40:47], v[174:181], v[134:141], v[40:47]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[182:189], v[134:141], v[56:63]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[190:197], v[134:141], v[64:71]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[190:197], v[142:149], v[104:111]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[182:189], v[142:149], v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[174:181], v[142:149], v[72:79]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[166:173], v[142:149], v[48:55]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[166:173], v[150:157], v[88:95]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[174:181], v[150:157], v[96:103]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[182:189], v[150:157], v[112:119]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[190:197], v[150:157], v[120:127]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[190:197], v[158:165], v[32:39]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[182:189], v[158:165], v[24:31]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[174:181], v[158:165], v[16:23]
	v_wmma_f32_16x16x32_bf16 v[0:7], v[166:173], v[158:165], v[0:7]
	v_add_nc_u32_e32 v128, s0, v128
	s_wait_alu depctr_vm_vsrc(6)
	s_set_vgpr_msb 5
	v_add_nc_u32_e32 v131, s0, v66 /*v322*/
	s_wait_alu depctr_vm_vsrc(2)
	ds_load_b128 v[132:135], v62 /*v318*/ offset:4544
	ds_load_b128 v[136:139], v62 /*v318*/ offset:4576
	s_wait_alu depctr_va_vdst(0)
	s_set_vgpr_msb 0x500
	ds_load_b128 v[140:143], v128
	ds_load_b128 v[144:147], v128 offset:32
	s_set_vgpr_msb 1
	ds_load_b128 v[148:151], v62 /*v318*/ offset:8896
	ds_load_b128 v[152:155], v62 /*v318*/ offset:8928
	ds_load_b128 v[156:159], v62 /*v318*/ offset:13248
	ds_load_b128 v[160:163], v62 /*v318*/ offset:13280
	s_set_vgpr_msb 0x100
	ds_load_b128 v[164:167], v131
	ds_load_b128 v[168:171], v131 offset:32
	s_set_vgpr_msb 1
	ds_load_b128 v[172:175], v63 /*v319*/ offset:192
	ds_load_b128 v[176:179], v63 /*v319*/ offset:224
	ds_load_b128 v[180:183], v63 /*v319*/ offset:4544
	ds_load_b128 v[184:187], v63 /*v319*/ offset:4576
	ds_load_b128 v[188:191], v63 /*v319*/ offset:8896
	ds_load_b128 v[192:195], v63 /*v319*/ offset:8928
	s_set_vgpr_msb 0x100
	s_wait_dscnt 0x12
	v_wmma_f32_16x16x32_bf16 v[8:15], v[230:237], v[198:205], v[8:15]
	s_wait_dscnt 0x10
	v_wmma_f32_16x16x32_bf16 v[40:47], v[238:245], v[198:205], v[40:47]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[246:253], v[198:205], v[56:63]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[254:261], v[198:205], v[64:71]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[254:261], v[206:213], v[104:111]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[246:253], v[206:213], v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[238:245], v[206:213], v[72:79]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[230:237], v[206:213], v[48:55]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[230:237], v[214:221], v[88:95]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[238:245], v[214:221], v[96:103]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[246:253], v[214:221], v[112:119]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[254:261], v[214:221], v[120:127]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[254:261], v[222:229], v[32:39]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[246:253], v[222:229], v[24:31]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[238:245], v[222:229], v[16:23]
	v_wmma_f32_16x16x32_bf16 v[0:7], v[230:237], v[222:229], v[0:7]
	s_set_vgpr_msb 5
	v_wmma_f32_16x16x32_bf16 v[8:15], v[38:45] /*v[294:301]*/, v[6:13] /*v[262:269]*/, v[8:15]
	s_wait_dscnt 0x10
	v_wmma_f32_16x16x32_bf16 v[40:47], v[46:53] /*v[302:309]*/, v[6:13] /*v[262:269]*/, v[40:47]
	v_wmma_f32_16x16x32_bf16 v[56:63], v[54:61] /*v[310:317]*/, v[6:13] /*v[262:269]*/, v[56:63]
	v_wmma_f32_16x16x32_bf16 v[64:71], v[68:75] /*v[324:331]*/, v[6:13] /*v[262:269]*/, v[64:71]
	v_wmma_f32_16x16x32_bf16 v[104:111], v[68:75] /*v[324:331]*/, v[14:21] /*v[270:277]*/, v[104:111]
	v_wmma_f32_16x16x32_bf16 v[80:87], v[54:61] /*v[310:317]*/, v[14:21] /*v[270:277]*/, v[80:87]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[46:53] /*v[302:309]*/, v[14:21] /*v[270:277]*/, v[72:79]
	v_wmma_f32_16x16x32_bf16 v[48:55], v[38:45] /*v[294:301]*/, v[14:21] /*v[270:277]*/, v[48:55]
	v_wmma_f32_16x16x32_bf16 v[88:95], v[38:45] /*v[294:301]*/, v[22:29] /*v[278:285]*/, v[88:95]
	v_wmma_f32_16x16x32_bf16 v[96:103], v[46:53] /*v[302:309]*/, v[22:29] /*v[278:285]*/, v[96:103]
	v_wmma_f32_16x16x32_bf16 v[112:119], v[54:61] /*v[310:317]*/, v[22:29] /*v[278:285]*/, v[112:119]
	v_wmma_f32_16x16x32_bf16 v[120:127], v[68:75] /*v[324:331]*/, v[22:29] /*v[278:285]*/, v[120:127]
	v_wmma_f32_16x16x32_bf16 v[32:39], v[68:75] /*v[324:331]*/, v[30:37] /*v[286:293]*/, v[32:39]
	v_wmma_f32_16x16x32_bf16 v[24:31], v[54:61] /*v[310:317]*/, v[30:37] /*v[286:293]*/, v[24:31]
	v_wmma_f32_16x16x32_bf16 v[16:23], v[46:53] /*v[302:309]*/, v[30:37] /*v[286:293]*/, v[16:23]
	v_wmma_f32_16x16x32_bf16 v[0:7], v[38:45] /*v[294:301]*/, v[30:37] /*v[286:293]*/, v[0:7]
	s_wait_dscnt 0x0
	s_lshl_b32 s0, s38, 1
	s_wait_tensorcnt 0x0
	s_wait_alu depctr_vm_vsrc(6)
	v_lshl_or_b32 v128, v64 /*v320*/, 4, s0
	s_mul_u64 s[0:1], s[10:11], s[34:35]
	s_barrier_signal -1
	s_lshl_b64 s[0:1], s[0:1], 1
	s_lshl_b64 s[2:3], s[2:3], 1
	s_cmp_lg_u32 s34, 0x80000000
	s_set_vgpr_msb 0x500
	v_wmma_f32_16x16x32_bf16 v[8:15], v[164:171], v[140:147], v[8:15]
	s_cselect_b32 s13, s35, 0
	s_cselect_b32 s12, s34, 0x80
	s_bfe_u32 s6, ttmp8, 0x50019
	s_set_vgpr_msb 1
	v_lshl_or_b32 v128, v65 /*v321*/, 8, v128
	s_and_b32 s9, s6, 3
	s_add_nc_u64 s[0:1], s[4:5], s[0:1]
	s_lshl_b32 s4, s9, 5
	s_set_vgpr_msb 0x100
	v_wmma_f32_16x16x32_bf16 v[40:47], v[172:179], v[140:147], v[40:47]
	s_add_nc_u64 s[0:1], s[0:1], s[2:3]
	s_sub_co_i32 s2, s33, s4
	v_nop
	v_nop
	v_cvt_pk_bf16_f32 v15, v14, v15
	v_cvt_pk_bf16_f32 v14, v12, v13
	v_cvt_pk_bf16_f32 v13, v10, v11
	v_cvt_pk_bf16_f32 v12, v8, v9
	s_max_i32 s4, s2, 0
	v_wmma_f32_16x16x32_bf16 v[56:63], v[180:187], v[140:147], v[56:63]
	v_dual_mov_b32 v131, s4 :: v_dual_add_nc_u32 v128, 0, v128
	v_cvt_pk_bf16_f32 v11, v46, v47
	v_cvt_pk_bf16_f32 v10, v44, v45
	v_cvt_pk_bf16_f32 v9, v42, v43
	v_cvt_pk_bf16_f32 v8, v40, v41
	s_barrier_wait -1
	v_wmma_f32_16x16x32_bf16 v[64:71], v[188:195], v[140:147], v[64:71]
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v128, v[12:15]
	ds_store_b128 v128, v[8:11] offset:32
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v11, v62, v63
	v_cvt_pk_bf16_f32 v10, v60, v61
	v_cvt_pk_bf16_f32 v9, v58, v59
	v_cvt_pk_bf16_f32 v8, v56, v57
	s_lshl_b32 s6, s9, 6
	v_wmma_f32_16x16x32_bf16 v[104:111], v[188:195], v[132:139], v[104:111]
	v_cvt_pk_bf16_f32 v15, v70, v71
	v_cvt_pk_bf16_f32 v14, v68, v69
	v_cvt_pk_bf16_f32 v13, v66, v67
	v_cvt_pk_bf16_f32 v12, v64, v65
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v128, v[8:11] offset:64
	ds_store_b128 v128, v[12:15] offset:96
	v_wmma_f32_16x16x32_bf16 v[80:87], v[180:187], v[132:139], v[80:87]
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v11, v110, v111
	v_cvt_pk_bf16_f32 v10, v108, v109
	v_cvt_pk_bf16_f32 v9, v106, v107
	v_cvt_pk_bf16_f32 v8, v104, v105
	s_mul_u64 s[2:3], s[12:13], s[6:7]
	s_lshl_b32 s5, s9, 13
	s_add_nc_u64 s[10:11], s[2:3], s[0:1]
	v_wmma_f32_16x16x32_bf16 v[72:79], v[172:179], v[132:139], v[72:79]
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v15, v86, v87
	v_cvt_pk_bf16_f32 v14, v84, v85
	v_cvt_pk_bf16_f32 v13, v82, v83
	v_cvt_pk_bf16_f32 v12, v80, v81
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v128, v[8:11] offset:4192
	ds_store_b128 v128, v[12:15] offset:4160
	v_wmma_f32_16x16x32_bf16 v[48:55], v[164:171], v[132:139], v[48:55]
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v11, v78, v79
	v_cvt_pk_bf16_f32 v10, v76, v77
	v_cvt_pk_bf16_f32 v9, v74, v75
	v_cvt_pk_bf16_f32 v8, v72, v73
	s_lshr_b32 s0, s4, 16
	s_and_b32 s1, s13, 0xffff
	s_bitset1_b32 s0, 23
	v_wmma_f32_16x16x32_bf16 v[88:95], v[164:171], v[148:155], v[88:95]
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v15, v54, v55
	v_cvt_pk_bf16_f32 v14, v52, v53
	v_cvt_pk_bf16_f32 v13, v50, v51
	v_cvt_pk_bf16_f32 v12, v48, v49
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v128, v[8:11] offset:4128
	ds_store_b128 v128, v[12:15] offset:4096
	v_wmma_f32_16x16x32_bf16 v[96:103], v[172:179], v[148:155], v[96:103]
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v11, v94, v95
	v_cvt_pk_bf16_f32 v10, v92, v93
	v_cvt_pk_bf16_f32 v9, v90, v91
	v_cvt_pk_bf16_f32 v8, v88, v89
	s_add_co_i32 s9, s5, 0
	s_mov_b32 s8, 1
	s_bitset1_b32 s11, 31
	v_wmma_f32_16x16x32_bf16 v[112:119], v[180:187], v[148:155], v[112:119]
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v15, v102, v103
	v_cvt_pk_bf16_f32 v14, v100, v101
	v_cvt_pk_bf16_f32 v13, v98, v99
	v_cvt_pk_bf16_f32 v12, v96, v97
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v128, v[8:11] offset:8192
	ds_store_b128 v128, v[12:15] offset:8224
	v_wmma_f32_16x16x32_bf16 v[120:127], v[188:195], v[148:155], v[120:127]
	s_wait_alu depctr_vm_vsrc(1)
	v_cvt_pk_bf16_f32 v11, v118, v119
	v_cvt_pk_bf16_f32 v10, v116, v117
	v_cvt_pk_bf16_f32 v9, v114, v115
	v_cvt_pk_bf16_f32 v8, v112, v113
	s_mov_b32 s4, 32
	s_wait_alu depctr_vm_vsrc(0)
	v_cvt_pk_bf16_f32 v15, v126, v127
	v_wmma_f32_16x16x32_bf16 v[0:7], v[164:171], v[156:163], v[0:7]
	v_cvt_pk_bf16_f32 v14, v124, v125
	v_cvt_pk_bf16_f32 v13, v122, v123
	v_cvt_pk_bf16_f32 v12, v120, v121
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(SKIP_1) | instid1(TRANS32_DEP_2)
	v_cvt_pk_bf16_f32 v7, v6, v7
	v_wmma_f32_16x16x32_bf16 v[16:23], v[172:179], v[156:163], v[16:23]
	v_cvt_pk_bf16_f32 v6, v4, v5
	v_cvt_pk_bf16_f32 v5, v2, v3
	v_cvt_pk_bf16_f32 v4, v0, v1
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(SKIP_1) | instid1(TRANS32_DEP_2)
	v_cvt_pk_bf16_f32 v3, v22, v23
	v_wmma_f32_16x16x32_bf16 v[24:31], v[180:187], v[156:163], v[24:31]
	v_cvt_pk_bf16_f32 v2, v20, v21
	v_cvt_pk_bf16_f32 v1, v18, v19
	v_cvt_pk_bf16_f32 v0, v16, v17
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(SKIP_1) | instid1(TRANS32_DEP_2)
	v_cvt_pk_bf16_f32 v19, v30, v31
	v_wmma_f32_16x16x32_bf16 v[32:39], v[188:195], v[156:163], v[32:39]
	v_cvt_pk_bf16_f32 v18, v28, v29
	v_cvt_pk_bf16_f32 v17, v26, v27
	v_cvt_pk_bf16_f32 v16, v24, v25
	v_nop
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v23, v38, v39
	v_cvt_pk_bf16_f32 v22, v36, v37
	s_delay_alu instid0(TRANS32_DEP_1)
	v_cvt_pk_bf16_f32 v21, v34, v35
	v_cvt_pk_bf16_f32 v20, v32, v33
	s_wait_alu depctr_va_vdst(0)
	ds_store_b128 v128, v[8:11] offset:8256
	ds_store_b128 v128, v[12:15] offset:8288
	ds_store_b128 v128, v[4:7] offset:12288
	ds_store_b128 v128, v[0:3] offset:12320
	ds_store_b128 v128, v[16:19] offset:12352
	ds_store_b128 v128, v[20:23] offset:12384
	s_wait_dscnt 0x0
	s_barrier_signal -1
	s_wait_alu depctr_vm_vsrc(2)
	v_lshrrev_b64 v[0:1], 16, v[130:131]
	v_dual_mov_b32 v3, s0 :: v_dual_mov_b32 v5, s12
	v_mov_b32_e32 v6, s1
	v_readfirstlane_b32 s1, v129
	s_mov_b32 s0, 0x10000
	v_readfirstlane_b32 s2, v0
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
		.amdhsa_next_free_vgpr 335
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
		.amdhsa_inst_pref_size 51
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

	.set kernel_grouped_nt_0.num_vgpr, 335
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
    .vgpr_count:     335
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.target:   amdgcn-amd-amdhsa--gfx1250
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
