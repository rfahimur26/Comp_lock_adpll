
module tb;
   
`define initial_N 24
   
   reg ref_clk, dco_clk,divided_dco_clk,reset;
   real Kin;
   
   reg 	early;
   reg 	phi, phi_bar, capture, update, scan_in, scan_out;
   
   
   
   real per;
   
   real tref;
   
   real tref5,tref500,tref50,tref200,tref20,tref10;
   

   


   reg 	enable_bist;
   reg 	calibration_mode;

   reg [1:0] selection_for_probe1;
   reg [1:0] selection_for_probe2;

   reg 	     clk_count_start;
   reg [6:0] pll_divider_input;

   reg [3:0] ring_oscillator_coarse_setting;
   reg [1:0] ring_oscillator_fine_setting;
   reg [10:0] divider_for_ring_oscillator;

   reg 	      delay_generator_enable;
   reg 	      delay_generator_oscillation_mode;

   reg [11:0] delay_generator1_coarse_setting;
   reg [23:0] delay_generator1_fine_setting;

   reg [11:0] delay_generator2_coarse_setting;
   reg [23:0] delay_generator2_fine_setting;

   reg [12:0] dco_input_external;
   reg [14:0] count_untill;

   reg [2:0]  computational_retimed_edge_select;
   reg [1:0]  traditional_retimed_edge_select;
   reg [1:0]  tdc_block_select;

   reg 	      select_PFD_input;
   reg 	      cold_start_traditional;
   reg 	      continue_traditional;

   reg [8:0]  coarse_res_finite ;
   reg [6:0]  medium_res_finite;
   reg [5:0]  fine_res_finite;
   reg [3:0]  fine_count_bbpll;

   reg [8:0]  p_finite;
   reg [8:0]  p_i_finite;
   reg [9:0]  p_i_inverse_finite;
   reg [12:0] filter_output_traditional_initial_finite;
   reg [15:0] count_aggr_initial_finite;
   reg [17:0] count_aggr_saturate_value;

   reg [13:0] Kin1_poly_finite;
   reg [13:0] Kin2_out_finite_resetval;
   reg [13:0] negative_phase_tolerance_finite;
   reg [13:0] positive_phase_tolerance_finite;
   reg [13:0] negative_freq_tolerance_finite;
   reg [13:0] positive_freq_tolerance_finite;
   reg [13:0] negative_freq_tolerance_finite2;
   reg [13:0] positive_freq_tolerance_finite2;
   reg [7:0]  gain_finite;
   reg [13:0] count_high_limit;
   reg [13:0] count_low_limit;
   reg [13:0] force_increment;
   reg [13:0] force_decrement;

   reg [12:0] tdc_limit;
   reg [10:0] offset_input;
   reg [10:0] decimator_input;

   
`include "/home/fahimr/scan_chain_reborn/scan_test/scan_tasks.v"
   
   assign external1 = 0;
   assign external2  = 0;

   assign ref_clk_bist = ref_clk ;

   
   
   
   reg [12:0] dco_input_external;
   reg 	      clk_count_start;
   reg 	      calibration_mode;

   reg 	      reset, enable_vco;
   
   
   //    wire [18:0] Kin1_finite_full;
   
   // assign Kin1_poly_finite_full = pll_divider_finite[5:0] * pll_divider_finite[5:0] * 9'b000011101 + 13'b0110111001101 * pll_divider[5:0] - 18'b010010110101010001;
   
   
   initial begin
      ref_clk=0;
      
      reset=1;
      
      enable_vco = 0;
      $vcdpluson;
      
      per = 1;
      tref = per*2;
      tref500 = tref* 500;
      tref50 = tref* 50;
      tref200 = tref* 200;
      
      tref20 = tref * 20;
      tref10 = tref * 10;
      tref5 = tref * 5;

      #tref;
      set_default_test_variables();
      phi = 0;
      phi_bar = 0;
      scan_in = 0;
      capture = 0;
      update = 0;
      
      scan_inputs();
      scan_outputs();
      
      
      
      report_results();
      
      #per;
      
      
      $finish;
   end
   
   
   
   always begin
      #per ref_clk = ~ref_clk;
      
      
   end

   
   
   scan_module_adpll sm 
     (
      .scan_in(scan_in),
      .update(update),
      .capture(capture),
      .phi(phi),
      .phi_bar(phi_bar),
      .scan_out(scan_out),
      .enable_bist(enable_bist_scanned),
      .calibration_mode(calibration_mode_scanned),
      .selection_for_probe1(selection_for_probe1_scanned),
      .selection_for_probe2(selection_for_probe2_scanned),
      .clk_count_start(clk_count_start_scanned),
      .pll_divider_input(pll_divider_input_scanned),
      .ring_oscillator_coarse_setting(ring_oscillator_coarse_setting_scanned),
      .ring_oscillator_fine_setting(ring_oscillator_fine_setting_scanned),
      .divider_for_ring_oscillator(divider_for_ring_oscillator_scanned),
      .delay_generator_enable(delay_generator_enable_scanned),
      .delay_generator_oscillation_mode(delay_generator_oscillation_mode_scanned),
      .delay_generator1_coarse_setting(delay_generator1_coarse_setting_scanned),
      .delay_generator1_fine_setting(delay_generator1_fine_setting_scanned),
      .delay_generator2_coarse_setting(delay_generator2_coarse_setting_scanned),
      .delay_generator2_fine_setting(delay_generator2_fine_setting_scanned),
      .dco_input_external(dco_input_external_scanned),
      .count_untill(count_untill_scanned),
      .ref_dco_counter(ref_dco_counter_scanned),
      .delay_gen_counter(delay_gen_counter_scanned),
      .ref_tdc_counter(ref_tdc_counter_scanned),
      .computational_retimed_edge_select(computational_retimed_edge_select_scanned),
      .traditional_retimed_edge_select(traditional_retimed_edge_select_scanned),
      .tdc_block_select(tdc_block_select_scanned),
      .select_PFD_input(select_PFD_input_scanned),
      .cold_start_traditional(cold_start_traditional_scanned),
      .continue_traditional(continue_traditional_scanned),
      .coarse_res_finite(coarse_res_finite_scanned),
      .medium_res_finite(medium_res_finite_scanned),
      .fine_res_finite(fine_res_finite_scanned),
      .fine_count_bbpll(fine_count_bbpll_scanned),
      .p_finite(p_finite_scanned),
      .p_i_finite(p_i_finite_scanned),
      .p_i_inverse_finite(p_i_inverse_finite_scanned),
      .filter_output_traditional_initial_finite(filter_output_traditional_initial_finite_scanned),
      .count_aggr_initial_finite(count_aggr_initial_finite_scanned),
      .count_aggr_saturate_value(count_aggr_saturate_value_scanned),
      .Kin1_poly_finite(Kin1_poly_finite_scanned),
      .Kin2_out_finite_resetval(Kin2_out_finite_resetval_scanned),
      .negative_phase_tolerance_finite(negative_phase_tolerance_finite_scanned),
      .positive_phase_tolerance_finite(positive_phase_tolerance_finite_scanned),
      .negative_freq_tolerance_finite(negative_freq_tolerance_finite_scanned),
      .positive_freq_tolerance_finite(positive_freq_tolerance_finite_scanned),
      .negative_freq_tolerance_finite2(negative_freq_tolerance_finite2_scanned),
      .positive_freq_tolerance_finite2(positive_freq_tolerance_finite2_scanned),
      .gain_finite(gain_finite_scanned),
      .count_high_limit(count_high_limit_scanned),
      .count_low_limit(count_low_limit_scanned),
      .force_increment(force_increment_scanned),
      .force_decrement(force_decrement_scanned),
      .locktime(locktime_scanned),
      .computational_locktime(computational_locktime_scanned),
      .tdc_limit(tdc_limit_scanned),
      .offset_input(offset_input_scanned),
      .decimator_input(decimator_input_scanned),
      .early_scan0(early_scan0_scanned),
      .early_scan1(early_scan1_scanned),
      .early_scan2(early_scan2_scanned),
      .early_scan3(early_scan3_scanned),
      .early_scan4(early_scan4_scanned),
      .early_scan5(early_scan5_scanned),
      .early_scan6(early_scan6_scanned),
      .early_scan7(early_scan7_scanned),
      .early_scan8(early_scan8_scanned),
      .early_scan9(early_scan9_scanned),
      .early_scan10(early_scan10_scanned),
      .early_scan11(early_scan11_scanned),
      .early_scan12(early_scan12_scanned),
      .early_scan13(early_scan13_scanned),
      .early_scan14(early_scan14_scanned),
      .early_scan15(early_scan15_scanned),
      .early_scan16(early_scan16_scanned),
      .early_scan17(early_scan17_scanned),
      .early_scan18(early_scan18_scanned),
      .early_scan19(early_scan19_scanned),
      .early_scan20(early_scan20_scanned),
      .early_scan21(early_scan21_scanned),
      .early_scan22(early_scan22_scanned),
      .early_scan23(early_scan23_scanned),
      .early_scan24(early_scan24_scanned),
      .early_scan25(early_scan25_scanned),
      .early_scan26(early_scan26_scanned),
      .early_scan27(early_scan27_scanned),
      .early_scan28(early_scan28_scanned),
      .early_scan29(early_scan29_scanned),
      .tdc_output_scan0(tdc_output_scan0_scanned),
      .tdc_output_scan1(tdc_output_scan1_scanned),
      .tdc_output_scan2(tdc_output_scan2_scanned),
      .tdc_output_scan3(tdc_output_scan3_scanned),
      .tdc_output_scan4(tdc_output_scan4_scanned),
      .tdc_output_scan5(tdc_output_scan5_scanned),
      .tdc_output_scan6(tdc_output_scan6_scanned),
      .tdc_output_scan7(tdc_output_scan7_scanned),
      .tdc_output_scan8(tdc_output_scan8_scanned),
      .tdc_output_scan9(tdc_output_scan9_scanned),
      .tdc_output_scan10(tdc_output_scan10_scanned),
      .tdc_output_scan11(tdc_output_scan11_scanned),
      .tdc_output_scan12(tdc_output_scan12_scanned),
      .tdc_output_scan13(tdc_output_scan13_scanned),
      .tdc_output_scan14(tdc_output_scan14_scanned),
      .tdc_output_scan15(tdc_output_scan15_scanned),
      .tdc_output_scan16(tdc_output_scan16_scanned),
      .tdc_output_scan17(tdc_output_scan17_scanned),
      .tdc_output_scan18(tdc_output_scan18_scanned),
      .tdc_output_scan19(tdc_output_scan19_scanned),
      .tdc_output_scan20(tdc_output_scan20_scanned),
      .tdc_output_scan21(tdc_output_scan21_scanned),
      .tdc_output_scan22(tdc_output_scan22_scanned),
      .tdc_output_scan23(tdc_output_scan23_scanned),
      .tdc_output_scan24(tdc_output_scan24_scanned),
      .tdc_output_scan25(tdc_output_scan25_scanned),
      .tdc_output_scan26(tdc_output_scan26_scanned),
      .tdc_output_scan27(tdc_output_scan27_scanned),
      .tdc_output_scan28(tdc_output_scan28_scanned),
      .tdc_output_scan29(tdc_output_scan29_scanned),
      .count_aggr_scan0(count_aggr_scan0_scanned),
      .count_aggr_scan1(count_aggr_scan1_scanned),
      .count_aggr_scan2(count_aggr_scan2_scanned),
      .count_aggr_scan3(count_aggr_scan3_scanned),
      .count_aggr_scan4(count_aggr_scan4_scanned),
      .count_aggr_scan5(count_aggr_scan5_scanned),
      .count_aggr_scan6(count_aggr_scan6_scanned),
      .count_aggr_scan7(count_aggr_scan7_scanned),
      .count_aggr_scan8(count_aggr_scan8_scanned),
      .count_aggr_scan9(count_aggr_scan9_scanned),
      .count_aggr_scan10(count_aggr_scan10_scanned),
      .count_aggr_scan11(count_aggr_scan11_scanned),
      .count_aggr_scan12(count_aggr_scan12_scanned),
      .count_aggr_scan13(count_aggr_scan13_scanned),
      .count_aggr_scan14(count_aggr_scan14_scanned),
      .count_aggr_scan15(count_aggr_scan15_scanned),
      .count_aggr_scan16(count_aggr_scan16_scanned),
      .count_aggr_scan17(count_aggr_scan17_scanned),
      .count_aggr_scan18(count_aggr_scan18_scanned),
      .count_aggr_scan19(count_aggr_scan19_scanned),
      .count_aggr_scan20(count_aggr_scan20_scanned),
      .count_aggr_scan21(count_aggr_scan21_scanned),
      .count_aggr_scan22(count_aggr_scan22_scanned),
      .count_aggr_scan23(count_aggr_scan23_scanned),
      .count_aggr_scan24(count_aggr_scan24_scanned),
      .count_aggr_scan25(count_aggr_scan25_scanned),
      .count_aggr_scan26(count_aggr_scan26_scanned),
      .count_aggr_scan27(count_aggr_scan27_scanned),
      .count_aggr_scan28(count_aggr_scan28_scanned),
      .count_aggr_scan29(count_aggr_scan29_scanned),
      .period_change_scan0(period_change_scan0_scanned),
      .period_change_scan1(period_change_scan1_scanned),
      .period_change_scan2(period_change_scan2_scanned),
      .period_change_scan3(period_change_scan3_scanned),
      .period_change_scan4(period_change_scan4_scanned),
      .period_change_scan5(period_change_scan5_scanned),
      .period_change_scan6(period_change_scan6_scanned),
      .period_change_scan7(period_change_scan7_scanned),
      .period_change_scan8(period_change_scan8_scanned),
      .period_change_scan9(period_change_scan9_scanned),
      .period_change_scan10(period_change_scan10_scanned),
      .period_change_scan11(period_change_scan11_scanned),
      .period_change_scan12(period_change_scan12_scanned),
      .period_change_scan13(period_change_scan13_scanned),
      .period_change_scan14(period_change_scan14_scanned),
      .period_change_scan15(period_change_scan15_scanned),
      .period_change_scan16(period_change_scan16_scanned),
      .period_change_scan17(period_change_scan17_scanned),
      .period_change_scan18(period_change_scan18_scanned),
      .period_change_scan19(period_change_scan19_scanned),
      .period_change_scan20(period_change_scan20_scanned),
      .period_change_scan21(period_change_scan21_scanned),
      .period_change_scan22(period_change_scan22_scanned),
      .period_change_scan23(period_change_scan23_scanned),
      .period_change_scan24(period_change_scan24_scanned),
      .period_change_scan25(period_change_scan25_scanned),
      .period_change_scan26(period_change_scan26_scanned),
      .period_change_scan27(period_change_scan27_scanned),
      .period_change_scan28(period_change_scan28_scanned),
      .period_change_scan29(period_change_scan29_scanned),
      .corrected_freq_error_scan0(corrected_freq_error_scan0_scanned),
      .corrected_freq_error_scan1(corrected_freq_error_scan1_scanned),
      .corrected_freq_error_scan2(corrected_freq_error_scan2_scanned),
      .corrected_freq_error_scan3(corrected_freq_error_scan3_scanned),
      .corrected_freq_error_scan4(corrected_freq_error_scan4_scanned),
      .corrected_freq_error_scan5(corrected_freq_error_scan5_scanned),
      .corrected_freq_error_scan6(corrected_freq_error_scan6_scanned),
      .corrected_freq_error_scan7(corrected_freq_error_scan7_scanned),
      .corrected_freq_error_scan8(corrected_freq_error_scan8_scanned),
      .corrected_freq_error_scan9(corrected_freq_error_scan9_scanned),
      .corrected_freq_error_scan10(corrected_freq_error_scan10_scanned),
      .corrected_freq_error_scan11(corrected_freq_error_scan11_scanned),
      .corrected_freq_error_scan12(corrected_freq_error_scan12_scanned),
      .corrected_freq_error_scan13(corrected_freq_error_scan13_scanned),
      .corrected_freq_error_scan14(corrected_freq_error_scan14_scanned),
      .corrected_freq_error_scan15(corrected_freq_error_scan15_scanned),
      .corrected_freq_error_scan16(corrected_freq_error_scan16_scanned),
      .corrected_freq_error_scan17(corrected_freq_error_scan17_scanned),
      .corrected_freq_error_scan18(corrected_freq_error_scan18_scanned),
      .corrected_freq_error_scan19(corrected_freq_error_scan19_scanned),
      .corrected_freq_error_scan20(corrected_freq_error_scan20_scanned),
      .corrected_freq_error_scan21(corrected_freq_error_scan21_scanned),
      .corrected_freq_error_scan22(corrected_freq_error_scan22_scanned),
      .corrected_freq_error_scan23(corrected_freq_error_scan23_scanned),
      .corrected_freq_error_scan24(corrected_freq_error_scan24_scanned),
      .corrected_freq_error_scan25(corrected_freq_error_scan25_scanned),
      .corrected_freq_error_scan26(corrected_freq_error_scan26_scanned),
      .corrected_freq_error_scan27(corrected_freq_error_scan27_scanned),
      .corrected_freq_error_scan28(corrected_freq_error_scan28_scanned),
      .corrected_freq_error_scan29(corrected_freq_error_scan29_scanned),
      .dco_input_scan0(dco_input_scan0_scanned),
      .dco_input_scan1(dco_input_scan1_scanned),
      .dco_input_scan2(dco_input_scan2_scanned),
      .dco_input_scan3(dco_input_scan3_scanned),
      .dco_input_scan4(dco_input_scan4_scanned),
      .dco_input_scan5(dco_input_scan5_scanned),
      .dco_input_scan6(dco_input_scan6_scanned),
      .dco_input_scan7(dco_input_scan7_scanned),
      .dco_input_scan8(dco_input_scan8_scanned),
      .dco_input_scan9(dco_input_scan9_scanned),
      .dco_input_scan10(dco_input_scan10_scanned),
      .dco_input_scan11(dco_input_scan11_scanned),
      .dco_input_scan12(dco_input_scan12_scanned),
      .dco_input_scan13(dco_input_scan13_scanned),
      .dco_input_scan14(dco_input_scan14_scanned),
      .dco_input_scan15(dco_input_scan15_scanned),
      .dco_input_scan16(dco_input_scan16_scanned),
      .dco_input_scan17(dco_input_scan17_scanned),
      .dco_input_scan18(dco_input_scan18_scanned),
      .dco_input_scan19(dco_input_scan19_scanned),
      .dco_input_scan20(dco_input_scan20_scanned),
      .dco_input_scan21(dco_input_scan21_scanned),
      .dco_input_scan22(dco_input_scan22_scanned),
      .dco_input_scan23(dco_input_scan23_scanned),
      .dco_input_scan24(dco_input_scan24_scanned),
      .dco_input_scan25(dco_input_scan25_scanned),
      .dco_input_scan26(dco_input_scan26_scanned),
      .dco_input_scan27(dco_input_scan27_scanned),
      .dco_input_scan28(dco_input_scan28_scanned),
      .dco_input_scan29(dco_input_scan29_scanned),
      .status_scan0(status_scan0_scanned),
      .status_scan1(status_scan1_scanned),
      .status_scan2(status_scan2_scanned),
      .status_scan3(status_scan3_scanned),
      .status_scan4(status_scan4_scanned),
      .status_scan5(status_scan5_scanned),
      .status_scan6(status_scan6_scanned),
      .status_scan7(status_scan7_scanned),
      .status_scan8(status_scan8_scanned),
      .status_scan9(status_scan9_scanned),
      .status_scan10(status_scan10_scanned),
      .status_scan11(status_scan11_scanned),
      .status_scan12(status_scan12_scanned),
      .status_scan13(status_scan13_scanned),
      .status_scan14(status_scan14_scanned),
      .status_scan15(status_scan15_scanned),
      .status_scan16(status_scan16_scanned),
      .status_scan17(status_scan17_scanned),
      .status_scan18(status_scan18_scanned),
      .status_scan19(status_scan19_scanned),
      .status_scan20(status_scan20_scanned),
      .status_scan21(status_scan21_scanned),
      .status_scan22(status_scan22_scanned),
      .status_scan23(status_scan23_scanned),
      .status_scan24(status_scan24_scanned),
      .status_scan25(status_scan25_scanned),
      .status_scan26(status_scan26_scanned),
      .status_scan27(status_scan27_scanned),
      .status_scan28(status_scan28_scanned),
      .status_scan29(status_scan29_scanned)

      );
   



   
   

   
   //  adpll2 adpll(ref_clk,reset,dco_clk,divided_dco_clk,Kin,tref,count,early,pll_divider, pll_divider2,computational_start,status);   

endmodule
