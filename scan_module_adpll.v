
module scan_module_adpll 
  (
   input 	 scan_in,
   input 	 update,
   input 	 capture,
   input 	 phi,
   input 	 phi_bar,
   output 	 scan_out,
   output OEN_probe1_pad,
output OEN_probe2_pad,
output enable_bist,
output calibration_mode,
output delay_generator_input_signal,
output ref_clk_select,
output [1:0] selection_for_probe1,
output [1:0] selection_for_probe2,
output clk_count_start,
output [6:0] pll_divider_input,
output [3:0] ring_oscillator_coarse_setting,
output [1:0] ring_oscillator_fine_setting,
output [2:0] ref_clk_divider_ratio,
output [2:0] dco_clk_divider_ratio,
output [2:0] tdc_ro_divider_ratio,
output delay_generator_enable,
output delay_generator_oscillation_mode,
output [11:0] delay_generator1_coarse_setting,
output [23:0] delay_generator1_fine_setting,
output [11:0] delay_generator2_coarse_setting,
output [23:0] delay_generator2_fine_setting,
output [12:0] dco_input_external,
output [14:0] count_untill,
input [14:0] ref_dco_counter,
input [14:0] delay_gen_counter,
input [14:0] ref_tdc_counter,
output [2:0] computational_retimed_edge_select,
output [1:0] traditional_retimed_edge_select,
output [1:0] tdc_block_select,
output select_PFD_input,
output cold_start_traditional,
output continue_traditional,
output [8:0] coarse_res_finite,
output [6:0] medium_res_finite,
output [5:0] fine_res_finite,
output [3:0] fine_count_bbpll,
output [8:0] p_finite,
output [8:0] p_i_finite,
output [9:0] p_i_inverse_finite,
output [12:0] filter_output_traditional_initial_finite,
output [15:0] count_aggr_initial_finite,
output [17:0] count_aggr_saturate_value,
output [13:0] Kin1_poly_finite,
output [13:0] Kin2_out_finite_resetval,
output [13:0] negative_phase_tolerance_finite,
output [13:0] positive_phase_tolerance_finite,
output [13:0] negative_freq_tolerance_finite,
output [13:0] positive_freq_tolerance_finite,
output [13:0] negative_freq_tolerance_finite2,
output [13:0] positive_freq_tolerance_finite2,
output [7:0] gain_finite,
output [13:0] count_high_limit,
output [13:0] count_low_limit,
output [13:0] force_increment,
output [13:0] force_decrement,
input [10:0] locktime,
input [10:0] computational_locktime,
output [12:0] tdc_limit,
output [10:0] offset_input,
output [10:0] decimator_input,
input instant_early,
input [12:0] instant_tdc_output,
input [19:0] instant_count_aggr,
input [12:0] instant_dco_input,
input [5:0] instant_status,
input early_scan0,
input early_scan1,
input early_scan2,
input early_scan3,
input early_scan4,
input early_scan5,
input early_scan6,
input early_scan7,
input early_scan8,
input early_scan9,
input early_scan10,
input early_scan11,
input early_scan12,
input early_scan13,
input early_scan14,
input early_scan15,
input early_scan16,
input early_scan17,
input early_scan18,
input early_scan19,
input early_scan20,
input early_scan21,
input early_scan22,
input early_scan23,
input early_scan24,
input early_scan25,
input early_scan26,
input early_scan27,
input early_scan28,
input early_scan29,
input [12:0] tdc_output_scan0,
input [12:0] tdc_output_scan1,
input [12:0] tdc_output_scan2,
input [12:0] tdc_output_scan3,
input [12:0] tdc_output_scan4,
input [12:0] tdc_output_scan5,
input [12:0] tdc_output_scan6,
input [12:0] tdc_output_scan7,
input [12:0] tdc_output_scan8,
input [12:0] tdc_output_scan9,
input [12:0] tdc_output_scan10,
input [12:0] tdc_output_scan11,
input [12:0] tdc_output_scan12,
input [12:0] tdc_output_scan13,
input [12:0] tdc_output_scan14,
input [12:0] tdc_output_scan15,
input [12:0] tdc_output_scan16,
input [12:0] tdc_output_scan17,
input [12:0] tdc_output_scan18,
input [12:0] tdc_output_scan19,
input [12:0] tdc_output_scan20,
input [12:0] tdc_output_scan21,
input [12:0] tdc_output_scan22,
input [12:0] tdc_output_scan23,
input [12:0] tdc_output_scan24,
input [12:0] tdc_output_scan25,
input [12:0] tdc_output_scan26,
input [12:0] tdc_output_scan27,
input [12:0] tdc_output_scan28,
input [12:0] tdc_output_scan29,
input [19:0] count_aggr_scan0,
input [19:0] count_aggr_scan1,
input [19:0] count_aggr_scan2,
input [19:0] count_aggr_scan3,
input [19:0] count_aggr_scan4,
input [19:0] count_aggr_scan5,
input [19:0] count_aggr_scan6,
input [19:0] count_aggr_scan7,
input [19:0] count_aggr_scan8,
input [19:0] count_aggr_scan9,
input [19:0] count_aggr_scan10,
input [19:0] count_aggr_scan11,
input [19:0] count_aggr_scan12,
input [19:0] count_aggr_scan13,
input [19:0] count_aggr_scan14,
input [19:0] count_aggr_scan15,
input [19:0] count_aggr_scan16,
input [19:0] count_aggr_scan17,
input [19:0] count_aggr_scan18,
input [19:0] count_aggr_scan19,
input [19:0] count_aggr_scan20,
input [19:0] count_aggr_scan21,
input [19:0] count_aggr_scan22,
input [19:0] count_aggr_scan23,
input [19:0] count_aggr_scan24,
input [19:0] count_aggr_scan25,
input [19:0] count_aggr_scan26,
input [19:0] count_aggr_scan27,
input [19:0] count_aggr_scan28,
input [19:0] count_aggr_scan29,
input [13:0] period_change_scan0,
input [13:0] period_change_scan1,
input [13:0] period_change_scan2,
input [13:0] period_change_scan3,
input [13:0] period_change_scan4,
input [13:0] period_change_scan5,
input [13:0] period_change_scan6,
input [13:0] period_change_scan7,
input [13:0] period_change_scan8,
input [13:0] period_change_scan9,
input [13:0] period_change_scan10,
input [13:0] period_change_scan11,
input [13:0] period_change_scan12,
input [13:0] period_change_scan13,
input [13:0] period_change_scan14,
input [13:0] period_change_scan15,
input [13:0] period_change_scan16,
input [13:0] period_change_scan17,
input [13:0] period_change_scan18,
input [13:0] period_change_scan19,
input [13:0] period_change_scan20,
input [13:0] period_change_scan21,
input [13:0] period_change_scan22,
input [13:0] period_change_scan23,
input [13:0] period_change_scan24,
input [13:0] period_change_scan25,
input [13:0] period_change_scan26,
input [13:0] period_change_scan27,
input [13:0] period_change_scan28,
input [13:0] period_change_scan29,
input [13:0] corrected_freq_error_scan0,
input [13:0] corrected_freq_error_scan1,
input [13:0] corrected_freq_error_scan2,
input [13:0] corrected_freq_error_scan3,
input [13:0] corrected_freq_error_scan4,
input [13:0] corrected_freq_error_scan5,
input [13:0] corrected_freq_error_scan6,
input [13:0] corrected_freq_error_scan7,
input [13:0] corrected_freq_error_scan8,
input [13:0] corrected_freq_error_scan9,
input [13:0] corrected_freq_error_scan10,
input [13:0] corrected_freq_error_scan11,
input [13:0] corrected_freq_error_scan12,
input [13:0] corrected_freq_error_scan13,
input [13:0] corrected_freq_error_scan14,
input [13:0] corrected_freq_error_scan15,
input [13:0] corrected_freq_error_scan16,
input [13:0] corrected_freq_error_scan17,
input [13:0] corrected_freq_error_scan18,
input [13:0] corrected_freq_error_scan19,
input [13:0] corrected_freq_error_scan20,
input [13:0] corrected_freq_error_scan21,
input [13:0] corrected_freq_error_scan22,
input [13:0] corrected_freq_error_scan23,
input [13:0] corrected_freq_error_scan24,
input [13:0] corrected_freq_error_scan25,
input [13:0] corrected_freq_error_scan26,
input [13:0] corrected_freq_error_scan27,
input [13:0] corrected_freq_error_scan28,
input [13:0] corrected_freq_error_scan29,
input [12:0] dco_input_scan0,
input [12:0] dco_input_scan1,
input [12:0] dco_input_scan2,
input [12:0] dco_input_scan3,
input [12:0] dco_input_scan4,
input [12:0] dco_input_scan5,
input [12:0] dco_input_scan6,
input [12:0] dco_input_scan7,
input [12:0] dco_input_scan8,
input [12:0] dco_input_scan9,
input [12:0] dco_input_scan10,
input [12:0] dco_input_scan11,
input [12:0] dco_input_scan12,
input [12:0] dco_input_scan13,
input [12:0] dco_input_scan14,
input [12:0] dco_input_scan15,
input [12:0] dco_input_scan16,
input [12:0] dco_input_scan17,
input [12:0] dco_input_scan18,
input [12:0] dco_input_scan19,
input [12:0] dco_input_scan20,
input [12:0] dco_input_scan21,
input [12:0] dco_input_scan22,
input [12:0] dco_input_scan23,
input [12:0] dco_input_scan24,
input [12:0] dco_input_scan25,
input [12:0] dco_input_scan26,
input [12:0] dco_input_scan27,
input [12:0] dco_input_scan28,
input [12:0] dco_input_scan29,
input [5:0] status_scan0,
input [5:0] status_scan1,
input [5:0] status_scan2,
input [5:0] status_scan3,
input [5:0] status_scan4,
input [5:0] status_scan5,
input [5:0] status_scan6,
input [5:0] status_scan7,
input [5:0] status_scan8,
input [5:0] status_scan9,
input [5:0] status_scan10,
input [5:0] status_scan11,
input [5:0] status_scan12,
input [5:0] status_scan13,
input [5:0] status_scan14,
input [5:0] status_scan15,
input [5:0] status_scan16,
input [5:0] status_scan17,
input [5:0] status_scan18,
input [5:0] status_scan19,
input [5:0] status_scan20,
input [5:0] status_scan21,
input [5:0] status_scan22,
input [5:0] status_scan23,
input [5:0] status_scan24,
input [5:0] status_scan25,
input [5:0] status_scan26,
input [5:0] status_scan27,
input [5:0] status_scan28,
input [5:0] status_scan29

   );
   wire [3006:0] scan_cell_out;
   wire [3006:0] chip_data_out;
   wire [3006:0] chip_data_in;
   
   scan_cell sc[3006:0] (
		       .scan_in({scan_in,scan_cell_out[3006:1]}),
		       .scan_out(scan_cell_out[3006:0]),
		       .phi(phi),
		       .phi_bar(phi_bar),
		       .capture(capture),
		       .update(update),
		       .chip_data_out(chip_data_out),
		       .chip_data_in(chip_data_in)
		       );
   assign scan_out = scan_cell_out[0];
   //Autogen all these assignments.
   //Make assignments for chip_data_in
assign OEN_probe1_pad = chip_data_in[0:0];
assign OEN_probe2_pad = chip_data_in[1:1];
assign enable_bist = chip_data_in[2:2];
assign calibration_mode = chip_data_in[3:3];
assign delay_generator_input_signal = chip_data_in[4:4];
assign ref_clk_select = chip_data_in[5:5];
assign selection_for_probe1 = chip_data_in[7:6];
assign selection_for_probe2 = chip_data_in[9:8];
assign clk_count_start = chip_data_in[10:10];
assign pll_divider_input = chip_data_in[17:11];
assign ring_oscillator_coarse_setting = chip_data_in[21:18];
assign ring_oscillator_fine_setting = chip_data_in[23:22];
assign ref_clk_divider_ratio = chip_data_in[26:24];
assign dco_clk_divider_ratio = chip_data_in[29:27];
assign tdc_ro_divider_ratio = chip_data_in[32:30];
assign delay_generator_enable = chip_data_in[33:33];
assign delay_generator_oscillation_mode = chip_data_in[34:34];
assign delay_generator1_coarse_setting = chip_data_in[46:35];
assign delay_generator1_fine_setting = chip_data_in[70:47];
assign delay_generator2_coarse_setting = chip_data_in[82:71];
assign delay_generator2_fine_setting = chip_data_in[106:83];
assign dco_input_external = chip_data_in[119:107];
assign count_untill = chip_data_in[134:120];
assign computational_retimed_edge_select = chip_data_in[182:180];
assign traditional_retimed_edge_select = chip_data_in[184:183];
assign tdc_block_select = chip_data_in[186:185];
assign select_PFD_input = chip_data_in[187:187];
assign cold_start_traditional = chip_data_in[188:188];
assign continue_traditional = chip_data_in[189:189];
assign coarse_res_finite = chip_data_in[198:190];
assign medium_res_finite = chip_data_in[205:199];
assign fine_res_finite = chip_data_in[211:206];
assign fine_count_bbpll = chip_data_in[215:212];
assign p_finite = chip_data_in[224:216];
assign p_i_finite = chip_data_in[233:225];
assign p_i_inverse_finite = chip_data_in[243:234];
assign filter_output_traditional_initial_finite = chip_data_in[256:244];
assign count_aggr_initial_finite = chip_data_in[272:257];
assign count_aggr_saturate_value = chip_data_in[290:273];
assign Kin1_poly_finite = chip_data_in[304:291];
assign Kin2_out_finite_resetval = chip_data_in[318:305];
assign negative_phase_tolerance_finite = chip_data_in[332:319];
assign positive_phase_tolerance_finite = chip_data_in[346:333];
assign negative_freq_tolerance_finite = chip_data_in[360:347];
assign positive_freq_tolerance_finite = chip_data_in[374:361];
assign negative_freq_tolerance_finite2 = chip_data_in[388:375];
assign positive_freq_tolerance_finite2 = chip_data_in[402:389];
assign gain_finite = chip_data_in[410:403];
assign count_high_limit = chip_data_in[424:411];
assign count_low_limit = chip_data_in[438:425];
assign force_increment = chip_data_in[452:439];
assign force_decrement = chip_data_in[466:453];
assign tdc_limit = chip_data_in[501:489];
assign offset_input = chip_data_in[512:502];
assign decimator_input = chip_data_in[523:513];

   //Make assignments for chip_data_out
assign chip_data_out[0:0] = OEN_probe1_pad;
assign chip_data_out[1:1] = OEN_probe2_pad;
assign chip_data_out[2:2] = enable_bist;
assign chip_data_out[3:3] = calibration_mode;
assign chip_data_out[4:4] = delay_generator_input_signal;
assign chip_data_out[5:5] = ref_clk_select;
assign chip_data_out[7:6] = selection_for_probe1;
assign chip_data_out[9:8] = selection_for_probe2;
assign chip_data_out[10:10] = clk_count_start;
assign chip_data_out[17:11] = pll_divider_input;
assign chip_data_out[21:18] = ring_oscillator_coarse_setting;
assign chip_data_out[23:22] = ring_oscillator_fine_setting;
assign chip_data_out[26:24] = ref_clk_divider_ratio;
assign chip_data_out[29:27] = dco_clk_divider_ratio;
assign chip_data_out[32:30] = tdc_ro_divider_ratio;
assign chip_data_out[33:33] = delay_generator_enable;
assign chip_data_out[34:34] = delay_generator_oscillation_mode;
assign chip_data_out[46:35] = delay_generator1_coarse_setting;
assign chip_data_out[70:47] = delay_generator1_fine_setting;
assign chip_data_out[82:71] = delay_generator2_coarse_setting;
assign chip_data_out[106:83] = delay_generator2_fine_setting;
assign chip_data_out[119:107] = dco_input_external;
assign chip_data_out[134:120] = count_untill;
assign chip_data_out[149:135] = ref_dco_counter;
assign chip_data_out[164:150] = delay_gen_counter;
assign chip_data_out[179:165] = ref_tdc_counter;
assign chip_data_out[182:180] = computational_retimed_edge_select;
assign chip_data_out[184:183] = traditional_retimed_edge_select;
assign chip_data_out[186:185] = tdc_block_select;
assign chip_data_out[187:187] = select_PFD_input;
assign chip_data_out[188:188] = cold_start_traditional;
assign chip_data_out[189:189] = continue_traditional;
assign chip_data_out[198:190] = coarse_res_finite;
assign chip_data_out[205:199] = medium_res_finite;
assign chip_data_out[211:206] = fine_res_finite;
assign chip_data_out[215:212] = fine_count_bbpll;
assign chip_data_out[224:216] = p_finite;
assign chip_data_out[233:225] = p_i_finite;
assign chip_data_out[243:234] = p_i_inverse_finite;
assign chip_data_out[256:244] = filter_output_traditional_initial_finite;
assign chip_data_out[272:257] = count_aggr_initial_finite;
assign chip_data_out[290:273] = count_aggr_saturate_value;
assign chip_data_out[304:291] = Kin1_poly_finite;
assign chip_data_out[318:305] = Kin2_out_finite_resetval;
assign chip_data_out[332:319] = negative_phase_tolerance_finite;
assign chip_data_out[346:333] = positive_phase_tolerance_finite;
assign chip_data_out[360:347] = negative_freq_tolerance_finite;
assign chip_data_out[374:361] = positive_freq_tolerance_finite;
assign chip_data_out[388:375] = negative_freq_tolerance_finite2;
assign chip_data_out[402:389] = positive_freq_tolerance_finite2;
assign chip_data_out[410:403] = gain_finite;
assign chip_data_out[424:411] = count_high_limit;
assign chip_data_out[438:425] = count_low_limit;
assign chip_data_out[452:439] = force_increment;
assign chip_data_out[466:453] = force_decrement;
assign chip_data_out[477:467] = locktime;
assign chip_data_out[488:478] = computational_locktime;
assign chip_data_out[501:489] = tdc_limit;
assign chip_data_out[512:502] = offset_input;
assign chip_data_out[523:513] = decimator_input;
assign chip_data_out[524:524] = instant_early;
assign chip_data_out[537:525] = instant_tdc_output;
assign chip_data_out[557:538] = instant_count_aggr;
assign chip_data_out[570:558] = instant_dco_input;
assign chip_data_out[576:571] = instant_status;
assign chip_data_out[577:577] = early_scan0;
assign chip_data_out[578:578] = early_scan1;
assign chip_data_out[579:579] = early_scan2;
assign chip_data_out[580:580] = early_scan3;
assign chip_data_out[581:581] = early_scan4;
assign chip_data_out[582:582] = early_scan5;
assign chip_data_out[583:583] = early_scan6;
assign chip_data_out[584:584] = early_scan7;
assign chip_data_out[585:585] = early_scan8;
assign chip_data_out[586:586] = early_scan9;
assign chip_data_out[587:587] = early_scan10;
assign chip_data_out[588:588] = early_scan11;
assign chip_data_out[589:589] = early_scan12;
assign chip_data_out[590:590] = early_scan13;
assign chip_data_out[591:591] = early_scan14;
assign chip_data_out[592:592] = early_scan15;
assign chip_data_out[593:593] = early_scan16;
assign chip_data_out[594:594] = early_scan17;
assign chip_data_out[595:595] = early_scan18;
assign chip_data_out[596:596] = early_scan19;
assign chip_data_out[597:597] = early_scan20;
assign chip_data_out[598:598] = early_scan21;
assign chip_data_out[599:599] = early_scan22;
assign chip_data_out[600:600] = early_scan23;
assign chip_data_out[601:601] = early_scan24;
assign chip_data_out[602:602] = early_scan25;
assign chip_data_out[603:603] = early_scan26;
assign chip_data_out[604:604] = early_scan27;
assign chip_data_out[605:605] = early_scan28;
assign chip_data_out[606:606] = early_scan29;
assign chip_data_out[619:607] = tdc_output_scan0;
assign chip_data_out[632:620] = tdc_output_scan1;
assign chip_data_out[645:633] = tdc_output_scan2;
assign chip_data_out[658:646] = tdc_output_scan3;
assign chip_data_out[671:659] = tdc_output_scan4;
assign chip_data_out[684:672] = tdc_output_scan5;
assign chip_data_out[697:685] = tdc_output_scan6;
assign chip_data_out[710:698] = tdc_output_scan7;
assign chip_data_out[723:711] = tdc_output_scan8;
assign chip_data_out[736:724] = tdc_output_scan9;
assign chip_data_out[749:737] = tdc_output_scan10;
assign chip_data_out[762:750] = tdc_output_scan11;
assign chip_data_out[775:763] = tdc_output_scan12;
assign chip_data_out[788:776] = tdc_output_scan13;
assign chip_data_out[801:789] = tdc_output_scan14;
assign chip_data_out[814:802] = tdc_output_scan15;
assign chip_data_out[827:815] = tdc_output_scan16;
assign chip_data_out[840:828] = tdc_output_scan17;
assign chip_data_out[853:841] = tdc_output_scan18;
assign chip_data_out[866:854] = tdc_output_scan19;
assign chip_data_out[879:867] = tdc_output_scan20;
assign chip_data_out[892:880] = tdc_output_scan21;
assign chip_data_out[905:893] = tdc_output_scan22;
assign chip_data_out[918:906] = tdc_output_scan23;
assign chip_data_out[931:919] = tdc_output_scan24;
assign chip_data_out[944:932] = tdc_output_scan25;
assign chip_data_out[957:945] = tdc_output_scan26;
assign chip_data_out[970:958] = tdc_output_scan27;
assign chip_data_out[983:971] = tdc_output_scan28;
assign chip_data_out[996:984] = tdc_output_scan29;
assign chip_data_out[1016:997] = count_aggr_scan0;
assign chip_data_out[1036:1017] = count_aggr_scan1;
assign chip_data_out[1056:1037] = count_aggr_scan2;
assign chip_data_out[1076:1057] = count_aggr_scan3;
assign chip_data_out[1096:1077] = count_aggr_scan4;
assign chip_data_out[1116:1097] = count_aggr_scan5;
assign chip_data_out[1136:1117] = count_aggr_scan6;
assign chip_data_out[1156:1137] = count_aggr_scan7;
assign chip_data_out[1176:1157] = count_aggr_scan8;
assign chip_data_out[1196:1177] = count_aggr_scan9;
assign chip_data_out[1216:1197] = count_aggr_scan10;
assign chip_data_out[1236:1217] = count_aggr_scan11;
assign chip_data_out[1256:1237] = count_aggr_scan12;
assign chip_data_out[1276:1257] = count_aggr_scan13;
assign chip_data_out[1296:1277] = count_aggr_scan14;
assign chip_data_out[1316:1297] = count_aggr_scan15;
assign chip_data_out[1336:1317] = count_aggr_scan16;
assign chip_data_out[1356:1337] = count_aggr_scan17;
assign chip_data_out[1376:1357] = count_aggr_scan18;
assign chip_data_out[1396:1377] = count_aggr_scan19;
assign chip_data_out[1416:1397] = count_aggr_scan20;
assign chip_data_out[1436:1417] = count_aggr_scan21;
assign chip_data_out[1456:1437] = count_aggr_scan22;
assign chip_data_out[1476:1457] = count_aggr_scan23;
assign chip_data_out[1496:1477] = count_aggr_scan24;
assign chip_data_out[1516:1497] = count_aggr_scan25;
assign chip_data_out[1536:1517] = count_aggr_scan26;
assign chip_data_out[1556:1537] = count_aggr_scan27;
assign chip_data_out[1576:1557] = count_aggr_scan28;
assign chip_data_out[1596:1577] = count_aggr_scan29;
assign chip_data_out[1610:1597] = period_change_scan0;
assign chip_data_out[1624:1611] = period_change_scan1;
assign chip_data_out[1638:1625] = period_change_scan2;
assign chip_data_out[1652:1639] = period_change_scan3;
assign chip_data_out[1666:1653] = period_change_scan4;
assign chip_data_out[1680:1667] = period_change_scan5;
assign chip_data_out[1694:1681] = period_change_scan6;
assign chip_data_out[1708:1695] = period_change_scan7;
assign chip_data_out[1722:1709] = period_change_scan8;
assign chip_data_out[1736:1723] = period_change_scan9;
assign chip_data_out[1750:1737] = period_change_scan10;
assign chip_data_out[1764:1751] = period_change_scan11;
assign chip_data_out[1778:1765] = period_change_scan12;
assign chip_data_out[1792:1779] = period_change_scan13;
assign chip_data_out[1806:1793] = period_change_scan14;
assign chip_data_out[1820:1807] = period_change_scan15;
assign chip_data_out[1834:1821] = period_change_scan16;
assign chip_data_out[1848:1835] = period_change_scan17;
assign chip_data_out[1862:1849] = period_change_scan18;
assign chip_data_out[1876:1863] = period_change_scan19;
assign chip_data_out[1890:1877] = period_change_scan20;
assign chip_data_out[1904:1891] = period_change_scan21;
assign chip_data_out[1918:1905] = period_change_scan22;
assign chip_data_out[1932:1919] = period_change_scan23;
assign chip_data_out[1946:1933] = period_change_scan24;
assign chip_data_out[1960:1947] = period_change_scan25;
assign chip_data_out[1974:1961] = period_change_scan26;
assign chip_data_out[1988:1975] = period_change_scan27;
assign chip_data_out[2002:1989] = period_change_scan28;
assign chip_data_out[2016:2003] = period_change_scan29;
assign chip_data_out[2030:2017] = corrected_freq_error_scan0;
assign chip_data_out[2044:2031] = corrected_freq_error_scan1;
assign chip_data_out[2058:2045] = corrected_freq_error_scan2;
assign chip_data_out[2072:2059] = corrected_freq_error_scan3;
assign chip_data_out[2086:2073] = corrected_freq_error_scan4;
assign chip_data_out[2100:2087] = corrected_freq_error_scan5;
assign chip_data_out[2114:2101] = corrected_freq_error_scan6;
assign chip_data_out[2128:2115] = corrected_freq_error_scan7;
assign chip_data_out[2142:2129] = corrected_freq_error_scan8;
assign chip_data_out[2156:2143] = corrected_freq_error_scan9;
assign chip_data_out[2170:2157] = corrected_freq_error_scan10;
assign chip_data_out[2184:2171] = corrected_freq_error_scan11;
assign chip_data_out[2198:2185] = corrected_freq_error_scan12;
assign chip_data_out[2212:2199] = corrected_freq_error_scan13;
assign chip_data_out[2226:2213] = corrected_freq_error_scan14;
assign chip_data_out[2240:2227] = corrected_freq_error_scan15;
assign chip_data_out[2254:2241] = corrected_freq_error_scan16;
assign chip_data_out[2268:2255] = corrected_freq_error_scan17;
assign chip_data_out[2282:2269] = corrected_freq_error_scan18;
assign chip_data_out[2296:2283] = corrected_freq_error_scan19;
assign chip_data_out[2310:2297] = corrected_freq_error_scan20;
assign chip_data_out[2324:2311] = corrected_freq_error_scan21;
assign chip_data_out[2338:2325] = corrected_freq_error_scan22;
assign chip_data_out[2352:2339] = corrected_freq_error_scan23;
assign chip_data_out[2366:2353] = corrected_freq_error_scan24;
assign chip_data_out[2380:2367] = corrected_freq_error_scan25;
assign chip_data_out[2394:2381] = corrected_freq_error_scan26;
assign chip_data_out[2408:2395] = corrected_freq_error_scan27;
assign chip_data_out[2422:2409] = corrected_freq_error_scan28;
assign chip_data_out[2436:2423] = corrected_freq_error_scan29;
assign chip_data_out[2449:2437] = dco_input_scan0;
assign chip_data_out[2462:2450] = dco_input_scan1;
assign chip_data_out[2475:2463] = dco_input_scan2;
assign chip_data_out[2488:2476] = dco_input_scan3;
assign chip_data_out[2501:2489] = dco_input_scan4;
assign chip_data_out[2514:2502] = dco_input_scan5;
assign chip_data_out[2527:2515] = dco_input_scan6;
assign chip_data_out[2540:2528] = dco_input_scan7;
assign chip_data_out[2553:2541] = dco_input_scan8;
assign chip_data_out[2566:2554] = dco_input_scan9;
assign chip_data_out[2579:2567] = dco_input_scan10;
assign chip_data_out[2592:2580] = dco_input_scan11;
assign chip_data_out[2605:2593] = dco_input_scan12;
assign chip_data_out[2618:2606] = dco_input_scan13;
assign chip_data_out[2631:2619] = dco_input_scan14;
assign chip_data_out[2644:2632] = dco_input_scan15;
assign chip_data_out[2657:2645] = dco_input_scan16;
assign chip_data_out[2670:2658] = dco_input_scan17;
assign chip_data_out[2683:2671] = dco_input_scan18;
assign chip_data_out[2696:2684] = dco_input_scan19;
assign chip_data_out[2709:2697] = dco_input_scan20;
assign chip_data_out[2722:2710] = dco_input_scan21;
assign chip_data_out[2735:2723] = dco_input_scan22;
assign chip_data_out[2748:2736] = dco_input_scan23;
assign chip_data_out[2761:2749] = dco_input_scan24;
assign chip_data_out[2774:2762] = dco_input_scan25;
assign chip_data_out[2787:2775] = dco_input_scan26;
assign chip_data_out[2800:2788] = dco_input_scan27;
assign chip_data_out[2813:2801] = dco_input_scan28;
assign chip_data_out[2826:2814] = dco_input_scan29;
assign chip_data_out[2832:2827] = status_scan0;
assign chip_data_out[2838:2833] = status_scan1;
assign chip_data_out[2844:2839] = status_scan2;
assign chip_data_out[2850:2845] = status_scan3;
assign chip_data_out[2856:2851] = status_scan4;
assign chip_data_out[2862:2857] = status_scan5;
assign chip_data_out[2868:2863] = status_scan6;
assign chip_data_out[2874:2869] = status_scan7;
assign chip_data_out[2880:2875] = status_scan8;
assign chip_data_out[2886:2881] = status_scan9;
assign chip_data_out[2892:2887] = status_scan10;
assign chip_data_out[2898:2893] = status_scan11;
assign chip_data_out[2904:2899] = status_scan12;
assign chip_data_out[2910:2905] = status_scan13;
assign chip_data_out[2916:2911] = status_scan14;
assign chip_data_out[2922:2917] = status_scan15;
assign chip_data_out[2928:2923] = status_scan16;
assign chip_data_out[2934:2929] = status_scan17;
assign chip_data_out[2940:2935] = status_scan18;
assign chip_data_out[2946:2941] = status_scan19;
assign chip_data_out[2952:2947] = status_scan20;
assign chip_data_out[2958:2953] = status_scan21;
assign chip_data_out[2964:2959] = status_scan22;
assign chip_data_out[2970:2965] = status_scan23;
assign chip_data_out[2976:2971] = status_scan24;
assign chip_data_out[2982:2977] = status_scan25;
assign chip_data_out[2988:2983] = status_scan26;
assign chip_data_out[2994:2989] = status_scan27;
assign chip_data_out[3000:2995] = status_scan28;
assign chip_data_out[3006:3001] = status_scan29;

endmodule // scan_module_adpll
