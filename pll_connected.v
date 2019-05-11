module pll_connected
  #(parameter register_length = 30) 
   (
    input 	       scan_in,
    input 	       update,
    input 	       capture,
    input 	       phi,
    input 	       phi_bar,
    output 	       scan_out,

    output 	       ref_clk_select,
    input 	       ref_clk,
   
    input 	       tdc_ro1,
    input 	       tdc_ro2,
   
    input 	       dco_clk,
    input 	       reset,
   
    input 	       delay_gen1,
    input 	       delay_gen2,
   
    input 	       fine_done_pre1,
    input 	       fine_done_pre2,
    input 	       fine_done_pre3,


    input 	       early1,
    input 	       early2,
    input 	       early3,

   
    input [4:0]        rise_count1,
    input [4:0]        rise_count2,
    input [4:0]        fall_count1,
    input [4:0]        fall_count2,
   
   
    input [7:0]        bs_out,
    input [8:0]        vernier_out,
    input [7:0]        trip_b,
    input [7:0]        cross_pin,

    output wire        reset_bar2,
    output wire        reset2,
    output wire        enable_choice1,
    output wire        enable_choice2,
    output wire        enable_choice3,
    output wire        select_PFD_input,
    output wire        gated_dco_clk,
   
    output wire [17:0] rows1,
    output wire [17:0] rows2,
    output wire [17:0] rows1_b,
    output wire [17:0] rows2_b,
    output wire [29:0] fine,
    output wire [29:0] fine_b,

    output wire        delay_generator_enable,
    output wire        delay_generator_oscillation_mode,
   
    output wire [11:0] delay_generator1_coarse_setting,
    output wire [23:0] delay_generator1_fine_setting,
    output wire [23:0] delay_generator1_fine_bar_setting,

    output wire [11:0] delay_generator2_coarse_setting,
    output wire [23:0] delay_generator2_fine_setting,
    output wire [23:0] delay_generator2_fine_bar_setting,
   
    output wire [3:0]  ring_oscillator_coarse_setting ,
    output wire [1:0]  ring_oscillator_fine_setting,
    output wire [1:0]  selection_for_probe1,
    output wire [1:0]  selection_for_probe2,
    output wire [2:0]  ref_clk_divider_ratio,
    output wire [2:0]  dco_clk_divider_ratio,
    output wire [2:0]  tdc_ro_divider_ratio,

    output 	       OEN_probe1_pad,
    output 	       OEN_probe2_pad,
    output 	       delay_generator_input_signal,
    output 	       divided_ref_clk
    );

   
   
   wire 	       continue_traditional;
   wire 	       clk_count_start;
   
  
   wire [6:0] 	       cycle_passed_finite;
   
   wire [12:0] 	       dco_input_external;
   wire 	       tdc_ro;
   
   
   wire [14:0] 	       count_untill;
   
   wire [14:0] 	       ref_dco_counter;
   wire [14:0] 	       delay_gen_counter;
   wire [14:0] 	       ref_tdc_counter;



   
   wire [8:0] 	       coarse_res_finite  ;
   wire [6:0] 	       medium_res_finite;
   wire [5:0] 	       fine_res_finite ;
   wire [3:0] 	       fine_count_bbpll;

   

   wire [2:0] 	       computational_retimed_edge_select;
   wire [12:0] 	       dco_wire_external; 
   wire [13:0] 	       Kin1_poly_finite ;
   wire [13:0] 	       Kin2_out_finite_resetval;
   wire [13:0] 	       negative_phase_tolerance_finite;
   wire [13:0] 	       positive_phase_tolerance_finite;
   wire [13:0] 	       negative_freq_tolerance_finite;
   wire [13:0] 	       positive_freq_tolerance_finite;
   wire [13:0] 	       negative_freq_tolerance_finite2;
   wire [13:0] 	       positive_freq_tolerance_finite2;
   wire [7:0] 	       gain_finite;
   wire signed [13:0]  count_high_limit;
   wire signed [13:0]  count_low_limit;
   wire [13:0] 	       force_increment;
   wire [13:0] 	       force_decrement;

   wire [1:0] 	       traditional_retimed_edge_select; 
   wire [8:0] 	       p_finite;
   wire [8:0] 	       p_i_finite;
   wire [9:0] 	       p_i_inverse_finite;
   wire [15:0] 	       count_aggr_initial_finite;
   wire [17:0] 	       count_aggr_saturate_value;
   wire signed [12:0]  filter_output_traditional_initial_finite;
   
   
   
   wire [10:0] 	       locktime;
   wire [10:0] 	       computational_locktime;
   wire [12:0] 	       tdc_limit;
   wire 	       enable_bist;
   wire [10:0] 	       offset_input;
   wire [10:0] 	       decimator_input;
   wire 	       lowbw;
   
   
   

   wire [12:0] 	       tdc_output_flopped;
   wire [12:0] 	       dco_input;
   wire [13:0] 	       corrected_freq_error;
   wire [13:0] 	       period_change;
   wire [5:0] 	       status;
   wire [19:0] 	       count_aggr;

   
   
   
   
   
   
   wire [1:0] 	       tdc_block_select;
   wire [6:0] 	       pll_divider_input;
   wire [6:0] 	       pll_divider_input_flopped, pll_divider;
   wire [6:0] 	       pll_divider2;
   
   wire 	       new_div_ratio_given;
   


   
   
   bist_scan bist_scan1 
     (
      .scan_in(scan_in),
      .update(update),
      .capture(capture),
      .phi(phi),
      .phi_bar(phi_bar),
      .scan_out(scan_out),
      //////////////bist //////////////////////////
      .OEN_probe1_pad(OEN_probe1_pad),
      .OEN_probe2_pad(OEN_probe2_pad),
      .delay_generator_input_signal(delay_generator_input_signal),
      .reset2(reset2),
      .new_div_ratio_given(new_div_ratio_given),
      .lowbw(lowbw),
      .ref_clk_select(ref_clk_select),
      .ref_clk(ref_clk),

      .tdc_output_flopped(tdc_output_flopped),
      .early(early),
      .dco_input(dco_input),
      .corrected_freq_error(corrected_freq_error),
      .period_change(period_change),
      .status(status),
      .count_aggr(count_aggr),
      ///////////////scan input output ///////////////

      .calibration_mode(calibration_mode),
      .selection_for_probe1(selection_for_probe1),
      .selection_for_probe2(selection_for_probe2),
      .clk_count_start(clk_count_start),
      .pll_divider_input(pll_divider_input),
      .ring_oscillator_coarse_setting(ring_oscillator_coarse_setting),
      .ring_oscillator_fine_setting(ring_oscillator_fine_setting),
      .tdc_ro_divider_ratio(tdc_ro_divider_ratio),
      .ref_clk_divider_ratio(ref_clk_divider_ratio),
      .dco_clk_divider_ratio(dco_clk_divider_ratio),
      .delay_generator_enable(delay_generator_enable),
      .delay_generator_oscillation_mode(delay_generator_oscillation_mode),
      .delay_generator1_coarse_setting(delay_generator1_coarse_setting),
      .delay_generator1_fine_setting(delay_generator1_fine_setting),
      .delay_generator1_fine_bar_setting(delay_generator1_fine_bar_setting),
      .delay_generator2_coarse_setting(delay_generator2_coarse_setting),
      .delay_generator2_fine_setting(delay_generator2_fine_setting),
      .delay_generator2_fine_bar_setting(delay_generator2_fine_bar_setting),
      .dco_input_external(dco_input_external),
      .count_untill(count_untill),
      .ref_dco_counter(ref_dco_counter),
      .delay_gen_counter(delay_gen_counter),
      .ref_tdc_counter(ref_tdc_counter),
      .computational_retimed_edge_select(computational_retimed_edge_select),
      .traditional_retimed_edge_select(traditional_retimed_edge_select),
      .tdc_block_select(tdc_block_select),
      .select_PFD_input(select_PFD_input),
      .cold_start_traditional(cold_start_traditional),
      .continue_traditional(continue_traditional),
      .coarse_res_finite(coarse_res_finite),
      .medium_res_finite(medium_res_finite),
      .fine_res_finite(fine_res_finite),
      .fine_count_bbpll(fine_count_bbpll),
      .p_finite(p_finite),
      .p_i_finite(p_i_finite),
      .p_i_inverse_finite(p_i_inverse_finite),
      .filter_output_traditional_initial_finite(filter_output_traditional_initial_finite),
      .count_aggr_initial_finite(count_aggr_initial_finite),
      .count_aggr_saturate_value(count_aggr_saturate_value),
      .Kin1_poly_finite(Kin1_poly_finite),
      .Kin2_out_finite_resetval(Kin2_out_finite_resetval),
      .negative_phase_tolerance_finite(negative_phase_tolerance_finite),
      .positive_phase_tolerance_finite(positive_phase_tolerance_finite),
      .negative_freq_tolerance_finite(negative_freq_tolerance_finite),
      .positive_freq_tolerance_finite(positive_freq_tolerance_finite),
      .negative_freq_tolerance_finite2(negative_freq_tolerance_finite2),
      .positive_freq_tolerance_finite2(positive_freq_tolerance_finite2),
      .gain_finite(gain_finite),
      .count_high_limit(count_high_limit),
      .count_low_limit(count_low_limit),
      .force_increment(force_increment),
      .force_decrement(force_decrement),
      .divided_ref_clk(divided_ref_clk)
      );
   
   
   
   adpll_controller adpll_controller1
     (
      .ref_clk(ref_clk),
      .reset(reset),
      
      .calibration_mode(calibration_mode),
      
      .delay_gen1(delay_gen1),
      .delay_gen2(delay_gen2),
      .tdc_ro1(tdc_ro1),
      .tdc_ro2(tdc_ro2),

      .clk_count_start(clk_count_start),
      .count_untill(count_untill),
      .delay_gen_counter(delay_gen_counter),
      .ref_dco_counter(ref_dco_counter),
      .ref_tdc_counter(ref_tdc_counter),

      .cold_start_traditional(cold_start_traditional),
      
      .dco_input_external(dco_input_external),
      ///////////////////////////////////////////////////
      .continue_traditional(continue_traditional),
      
      .new_div_ratio_given(new_div_ratio_given),
      .pll_divider_input(pll_divider_input),
      .pll_divider(pll_divider), 
      .pll_divider2(pll_divider2),
      
      //////////////////////////////////////////////
      .computational_retimed_edge_select(computational_retimed_edge_select),
      .Kin1_poly_finite(Kin1_poly_finite) ,
      .Kin2_out_finite_resetval(Kin2_out_finite_resetval),
      .negative_phase_tolerance_finite(negative_phase_tolerance_finite),
      .positive_phase_tolerance_finite(positive_phase_tolerance_finite),
      .negative_freq_tolerance_finite(negative_freq_tolerance_finite),
      .positive_freq_tolerance_finite(positive_freq_tolerance_finite),
      .negative_freq_tolerance_finite2(negative_freq_tolerance_finite2),
      .positive_freq_tolerance_finite2(positive_freq_tolerance_finite2),
      .gain_finite(gain_finite),
      .count_high_limit(count_high_limit),
      .count_low_limit(count_low_limit),
      .force_increment(force_increment),
      .force_decrement(force_decrement),

      .traditional_retimed_edge_select(traditional_retimed_edge_select), 
      .p_finite(p_finite),
      .p_i_finite(p_i_finite),
      .p_i_inverse_finite(p_i_inverse_finite),
      .count_aggr_initial_finite(count_aggr_initial_finite),
      .count_aggr_saturate_value(count_aggr_saturate_value),
      .filter_output_traditional_initial_finite(filter_output_traditional_initial_finite),
      .lowbw1(lowbw),
      .dco_clk(dco_clk),

      .tdc_block_select(tdc_block_select),

      .fine_done_pre1(fine_done_pre1),
      .fine_done_pre2(fine_done_pre2),
      .fine_done_pre3(fine_done_pre3),

      .early1(early1),
      .early2(early2),
      .early3(early3),
      
      .rise_count1(rise_count1),
      .rise_count2(rise_count2),
      .fall_count1(fall_count1),
      .fall_count2(fall_count2),
      
      .bs_out(bs_out),
      .vernier_out(vernier_out),
      .trip_b(trip_b),
      .cross_pin(cross_pin),

      .coarse_res_finite(coarse_res_finite),
      .medium_res_finite(medium_res_finite),
      .fine_res_finite(fine_res_finite),
      
      .fine_count_bbpll(fine_count_bbpll),
      
      .early(early),
      .fine_done_pre(fine_done_pre),
      
      .filter_output_finite(dco_input),
      .status(status),
      .gated_dco_clk(gated_dco_clk),
      
      .period_change_finite(period_change),
      .corrected_freq_error(corrected_freq_error),
      
      ////////////////////////////////////////////////////
      
      .enable_choice1(enable_choice1),
      .enable_choice2(enable_choice2),
      .enable_choice3(enable_choice3),
      .tdc_ro(tdc_ro),

      .reset2(reset2),
      .reset_bar2(reset_bar2),
      
      
      ////////////////////////////////////////////////////////     
      
     
      .cycle_passed_finite(cycle_passed_finite),
      
      
      .rows1(rows1),
      .rows2(rows2),
      .rows1_b(rows1_b),
      .rows2_b(rows2_b),
      .fine(fine),
      .fine_b(fine_b),
      
      .tdc_output_flopped(tdc_output_flopped),
      .count_aggr(count_aggr)
      );


   

   


   
   

endmodule // bist


