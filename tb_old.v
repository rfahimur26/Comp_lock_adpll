
module tb;
   
`define initial_N 24
   
   reg ref_clk, dco_clk,divided_dco_clk,reset;
   real Kin;
   
   reg 	early;
   reg 	phi, phi_bar, capture, update, scan_in, scan_out;
   
   
   
   real per;
   
   real tref;
   
   real tref5,tref500,tref50,tref200,tref20,tref10;
   

   
   reg [1:0] tdc_block_select;    //00 = awesome TDC;   //01 = backup TDC;   //10 = PFD
   wire      select_PFD_input_out;
   wire      external1;
   wire      external2;
   reg 	     enable_vco;

   wire      ref_clk_bist;
   
   wire      reset_bar2;
   
   wire      enable_choice1;
   wire      enable_choice2;
   wire      enable_choice3;
   
   wire      gated_dco_clk;
   
   wire [17:0] rows1;
   wire [17:0] rows2;
   wire [17:0] rows1_b;
   wire [17:0] rows2_b;
   wire [29:0] fine;
   wire [29:0] fine_b;
   

   wire        early1;
   wire        early2;
   wire        early3;

   wire        fine_done_pre1;
   wire        fine_done_pre2;
   wire        fine_done_pre3;
   
   wire        delay_generator_enable_out;
   wire        delay_generator_oscillation_mode_out;
   
   wire [11:0] delay_generator1_coarse_setting_out;
   wire [23:0] delay_generator1_fine_setting_out;
   wire [23:0] delay_generator1_fine_bar_setting_out;

   wire [11:0] delay_generator2_coarse_setting_out;
   wire [23:0] delay_generator2_fine_setting_out;
   wire [23:0] delay_generator2_fine_bar_setting_out;
   
   wire [3:0]  ring_oscillator_coarse_setting_out;
   wire [1:0]  ring_oscillator_fine_setting_out;

   wire [10:0] divider_for_ring_oscillator_out;
   wire [1:0] selection_for_probe1_out;
   wire [1:0] selection_for_probe2_out;
  
   

   wire [4:0]  rise_count1;
   wire [4:0]  rise_count2;
   wire [4:0]  fall_count1;
   wire [4:0]  fall_count2;
   
   
   wire [7:0]  bs_out;
   wire [8:0]  vernier_out;
   wire [7:0]  trip_b;
   wire [7:0]  cross_pin;
   


   reg [11:0]  decimator_input;
   reg [11:0]  offset_input;
   reg [13:0]  tdc_limit;
   reg [14:0]  force_decrement;
   reg [14:0]  force_increment;
   reg [14:0]  count_low_limit;
   reg [14:0]  count_high_limit;
   reg [8:0]   gain_finite;
   reg [14:0]  positive_freq_tolerance_finite2;
   reg [14:0]  negative_freq_tolerance_finite2;
   reg [14:0]  positive_freq_tolerance_finite;
   reg [14:0]  negative_freq_tolerance_finite;
   reg [14:0]  positive_phase_tolerance_finite;
   reg [14:0]  negative_phase_tolerance_finite;
   reg [14:0]  Kin2_out_finite_resetval;
   reg [14:0]  Kin1_poly_finite;
   reg [18:0]  count_aggr_saturate_value;
   reg [16:0]  count_aggr_initial_finite;
   reg [13:0]  filter_output_traditional_initial_finite;
   reg [10:0]  p_i_inverse_finite;
   reg [9:0]   p_i_finite;
   reg [9:0]   p_finite;
   reg [4:0]   fine_count_bbpll;
   reg [6:0]   fine_res_finite;
   reg [7:0]   medium_res_finite;
   reg [9:0]   coarse_res_finite;
   reg 	       continue_traditional;
   reg 	       cold_start_traditional;
   reg 	       select_PFD_input;
   reg [2:0]   tdc_block_select;
   reg [2:0]   traditional_retimed_edge_select;
   reg [3:0]   computational_retimed_edge_select;
   reg [15:0]  count_untill;
   reg [13:0]  dco_input_external;
   reg [24:0]  delay_generator2_fine_setting;
   reg [12:0]  delay_generator2_coarse_setting;
   reg [24:0]  delay_generator1_fine_setting;
   reg [12:0]  delay_generator1_coarse_setting;
   reg 	       delay_generator_oscillation_mode;
   reg 	       delay_generator_enable;
   reg [11:0]  divider_for_ring_oscillator;
   reg [2:0]   ring_oscillator_fine_setting;
   reg [3:0]   ring_oscillator_coarse_setting;
   reg [7:0]   pll_divider_input;
   reg 	       clk_count_start;
   reg [1:0]   selection_for_probe2;
   reg [1:0]   selection_for_probe1; 
   reg 	       calibration_mode;
   reg 	       enable_bist;


   
`include "/home/fahimr/scan_chain_reborn/scan_test/scan_tasks.v"
   
   assign external1 = 0;
   assign external2  = 0;

   assign ref_clk_bist = ref_clk ;

   
   
   
   reg [12:0]  dco_input_external;
   reg 	       clk_count_start;
   reg 	       calibration_mode;

   
   
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
      // set_default_test_variables();
      phi = 0;
      phi_bar = 0;
      scan_in = 0;
      capture = 0;
      update = 0;
      
      scan_inputs();
      scan_outputs();
      
      
      
      
      // $sdf_annotate("./traditional.sdf", adpll.traditional1);
      // $sdf_annotate("./computational.sdf", adpll.computational1);
      
      
      #tref;
      
      report_results();
      
      #per;
      
     
      
      
      
      
      
      
      
      
      
      
      $finish;
   end
   

   
   always begin
      #per ref_clk = ~ref_clk;
      
      
   end

   
   
   
   



   choice1_PFD_TDC_ckt choice1_PFD_TDC_instance( 
						 .enable_PFD_TDC(enable_choice1) ,
						 .select_PFD_input(select_PFD_input),
						 .ref_clk(ref_clk),
						 .external1(external1) ,
						 .gated_dco_clk(gated_dco_clk),
						 .external2(external2),
						 .reset(reset_bar2),
						 .dco_clk(dco_clk),
						 .fine_done_pre(fine_done_pre1),
						 .early(early1),
						 .counter_rise(rise_count1),
						 .counter_fall(fall_count1),
						 .bs(bs_out),
						 .vernier(vernier_out)   );

   choice2_PFD_backup_TDC_ckt choice2_PFD_backup_TDC_instance(
							      .enable_PFD_TDC(enable_choice2) ,
							      .select_PFD_input(select_PFD_input),
							      .ref_clk(ref_clk),
							      .external1(external1) ,
							      .gated_dco_clk(gated_dco_clk),
							      .external2(external2),
							      .reset(reset_bar2),
							      .dco_clk(dco_clk),
							      .fine_done_pre(fine_done_pre2),
							      .early(early2),
							      .counter_rise(rise_count2),
							      .counter_fall(fall_count2),
							      .trip_b(trip_b),
							      .cross_pin(cross_pin));


   choice3_standalone_PFD_ckt choice3_standalone_PFD_instance(
							      .enable_PFD(enable_choice3) ,
							      .select_PFD_input(select_PFD_input),
							      .ref_clk(ref_clk),
							      .external1(external1) ,
							      .gated_dco_clk(gated_dco_clk),
							      .external2(external2),
							      .reset(reset_bar2),
							      .dco_clk(dco_clk),
							      .fine_done_pre(fine_done_pre3),
							      .early(early3) );


   vco_ideal vco2( .rows(rows1),
		   .fine(fine),
		   .vout(dco_clk),
		   .reset(reset),
      
		   .enable_vco(enable_vco) );



   pll_connected pll_connected1
     (
      .scan_in(scan_in),
      .update(update),
      .capture(capture),
      .phi(phi),
      .phi_bar(phi_bar),
      .scan_out(scan_out),

      .ref_clk(ref_clk),
      .ref_clk_bist(ref_clk_bist),
      

      .tdc_ro1(tdc_ro1),
      .tdc_ro2(tdc_ro2),

      .dco_clk(dco_clk),
      .reset(reset),

      .delay_gen1(delay_gen1),
      .delay_gen2(delay_gen2),

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

      .reset_bar2(reset_bar2),
      .enable_choice1(enable_choice1),
      .enable_choice2(enable_choice2),
      .enable_choice3(enable_choice3),
      .select_PFD_input(select_PFD_input_out),
      .gated_dco_clk(gated_dco_clk),

      .rows1(rows1),
      .rows2(rows2),
      .rows1_b(rows1_b),
      .rows2_b(rows2_b),
      .fine(fine),
      .fine_b(fine_b),

      .delay_generator_enable(delay_generator_enable_out),
      .delay_generator_oscillation_mode(delay_generator_oscillation_mode_out),

      .delay_generator1_coarse_setting(delay_generator1_coarse_setting_out),
      .delay_generator1_fine_setting(delay_generator1_fine_setting_out),
      .delay_generator1_fine_bar_setting(delay_generator1_fine_bar_setting_out),

      .delay_generator2_coarse_setting(delay_generator2_coarse_setting_out),
      .delay_generator2_fine_setting(delay_generator2_fine_setting_out),
      .delay_generator2_fine_bar_setting(delay_generator2_fine_bar_setting_out),

      .ring_oscillator_coarse_setting(ring_oscillator_coarse_setting_out),
      .ring_oscillator_fine_setting(ring_oscillator_fine_setting_out),

      .divider_for_ring_oscillator(divider_for_ring_oscillator_out),
      .selection_for_probe1(selection_for_probe1_out),
      .selection_for_probe2(selection_for_probe2_out)
      
      );



   

   
   //  adpll2 adpll(ref_clk,reset,dco_clk,divided_dco_clk,Kin,tref,count,early,pll_divider, pll_divider2,computational_start,status);   

endmodule
