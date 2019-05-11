
module tb;
   
`define initial_N 24
   
   reg ref_clk_external, dco_clk,divided_dco_clk,reset;
   real Kin;
   
   reg 	early;
   reg 	phi, phi_bar, capture, update, scan_in, scan_out;
   
   
   
   real per;
   
   real tref;
   
   real tref5,tref500,tref50,tref200,tref20,tref10;
   
   wire divided_ref_clk;
   
   
   reg [1:0] tdc_block_select;    //00 = awesome TDC;   //01 = backup TDC;   //10 = PFD
   wire      select_PFD_input;
   wire      external1;
   wire      external2;
   reg 	     enable_vco;

   wire      ref_clk_external_bist;
   
   wire      reset_bar2;
   wire      reset2;
   
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

   wire        ref_clk_select;
   
   wire        delay_generator_enable;
   wire        delay_generator_oscillation_mode;
   
   wire [11:0] delay_generator1_coarse_setting;
   wire [23:0] delay_generator1_fine_setting;
   wire [23:0] delay_generator1_fine_bar_setting;

   wire [11:0] delay_generator2_coarse_setting;
   wire [23:0] delay_generator2_fine_setting;
   wire [23:0] delay_generator2_fine_bar_setting;
   
   wire [3:0]  ring_oscillator_coarse_setting;
   wire [1:0]  ring_oscillator_fine_setting;
   wire [2:0]  ref_clk_divider_ratio;
   wire [2:0]  dco_clk_divider_ratio;
   
   wire [1:0]  selection_for_probe1;
   wire [1:0]  selection_for_probe2;
   wire [2:0]  tdc_ro_divider_ratio;
   
   wire        tdc_ro1, tdc_ro2, divided_tdc_ro1, divided_tdc_ro2;
   

   wire [4:0]  rise_count1;
   wire [4:0]  rise_count2;
   wire [4:0]  fall_count1;
   wire [4:0]  fall_count2;
   
   
   wire [7:0]  bs_out;
   wire [8:0]  vernier_out;
   wire [7:0]  trip_b;
   wire [7:0]  cross_pin;
   
   reg 	       OEN_probe1_pad;
   reg 	       OEN_probe2_pad;
   reg 	       delay_generator_input_signal;

   ////////////////////////////////scan_inputs/////////////////////////////////////////
   reg 	       OEN_probe1_pad_scan;
   reg 	       OEN_probe2_pad_scan;
   reg 	       delay_generator_input_signal_scan;
   
   reg 	       enable_bist_scan;
   reg 	       calibration_mode_scan;
   reg 	       ref_clk_select_scan;
   
   reg [1:0]   selection_for_probe1_scan;
   reg [1:0]   selection_for_probe2_scan;

   reg 	       clk_count_start_scan;
   reg [6:0]   pll_divider_input_scan;

   reg [3:0]   ring_oscillator_coarse_setting_scan;
   reg [1:0]   ring_oscillator_fine_setting_scan;
   reg [2:0]   tdc_ro_divider_ratio_scan;
   
   reg [2:0]   ref_clk_divider_ratio_scan;
   reg [2:0]   dco_clk_divider_ratio_scan;
   

   reg 	       delay_generator_enable_scan;
   reg 	       delay_generator_oscillation_mode_scan;

   reg [11:0]  delay_generator1_coarse_setting_scan;
   reg [23:0]  delay_generator1_fine_setting_scan;

   reg [11:0]  delay_generator2_coarse_setting_scan;
   reg [23:0]  delay_generator2_fine_setting_scan;

   reg [12:0]  dco_input_external_scan;
   reg [14:0]  count_untill_scan;

   reg [2:0]   computational_retimed_edge_select_scan;
   reg [1:0]   traditional_retimed_edge_select_scan;
   reg [1:0]   tdc_block_select_scan;

   reg 	       select_PFD_input_scan;
   reg 	       cold_start_traditional_scan;
   reg 	       continue_traditional_scan;

   reg [8:0]   coarse_res_finite_scan;
   reg [6:0]   medium_res_finite_scan;
   reg [5:0]   fine_res_finite_scan;
   reg [3:0]   fine_count_bbpll_scan;

   reg [8:0]   p_finite_scan;
   reg [8:0]   p_i_finite_scan;
   reg [9:0]   p_i_inverse_finite_scan;
   reg [12:0]  filter_output_traditional_initial_finite_scan;
   reg [15:0]  count_aggr_initial_finite_scan;
   reg [17:0]  count_aggr_saturate_value_scan;

   reg [13:0]  Kin1_poly_finite_scan;
   reg [13:0]  Kin2_out_finite_resetval_scan;
   reg [13:0]  negative_phase_tolerance_finite_scan;
   reg [13:0]  positive_phase_tolerance_finite_scan;
   reg [13:0]  negative_freq_tolerance_finite_scan;
   reg [13:0]  positive_freq_tolerance_finite_scan;
   reg [13:0]  negative_freq_tolerance_finite2_scan;
   reg [13:0]  positive_freq_tolerance_finite2_scan;
   reg [7:0]   gain_finite_scan;
   reg [13:0]  count_high_limit_scan;
   reg [13:0]  count_low_limit_scan;
   reg [13:0]  force_increment_scan;
   reg [13:0]  force_decrement_scan;

   reg [12:0]  tdc_limit_scan;
   reg [10:0]  offset_input_scan;
   reg [10:0]  decimator_input_scan;

   ////////////////////////////////////////////////////////////////////////////////////////////
   
`include "scan_tasks.v"
   
   assign external1 = 0;
   assign external2  = 0;

   assign ref_clk_external_bist = ref_clk_external ;

   
   
   
   reg [12:0]  dco_input_external;
   reg 	       clk_count_start;
   

   
   
    wire [18:0] Kin1_poly_finite_full;
   
    assign Kin1_poly_finite_full = pll_divider_input_scan[5:0] * pll_divider_input_scan[5:0] * 9'b000011101 + 13'b0110111001101 * pll_divider_input_scan[5:0] - 18'b010010110101010001;
   
   
   initial begin
      ref_clk_external=0;
      
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
      pll_divider_input_scan=7'd23;
      Kin1_poly_finite_scan = 14'h0645;
      
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
      #per;
      
      
      reset = 0;
      
      #tref;
      #tref;
      
      enable_vco = 1;
      #tref;
      
      reset = 1;
      
      

      #tref;
      
      
      #tref;
      
      
      
      
      #tref;
      
      
      #per;
      
      
      #per;
      
      #tref;
      #tref;  
      #tref;
      #tref;
      
      
      
      #tref;
      
      
      #tref;
      
      #tref10;

      
      #tref20;

        #tref10; 
      #tref20;

      computational_retimed_edge_select_scan=3'd3;
      
      pll_divider_input_scan=7'd49;
      // Kin1_poly_finite_scan = 14'h2358;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();    
      report_results();
      
      #tref;
      #tref10;
      #tref20;
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd48;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      
      pll_divider_input_scan=7'd47;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd46;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;



      pll_divider_input_scan=7'd45;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd44;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd43;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;
      
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd42;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd41;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd40;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      
      pll_divider_input_scan=7'd39;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd38;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd37;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd36;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd35;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd34;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd33;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd32;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;    
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd31;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd30;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd29;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd28;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd27;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd26;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd25;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      pll_divider_input_scan=7'd24;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;

      
      pll_divider_input_scan=`initial_N;
      // Kin1_poly_finite_scan = 14'h0645;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;


      pll_divider_input_scan=7'd23;
      // Kin1_poly_finite_scan = 14'h1f21;
      #tref;
      Kin1_poly_finite_scan = Kin1_poly_finite_full[17:4];
      
      scan_inputs();
      scan_outputs();      
      #tref;
      #tref10;
      #tref20;
      
     
      
      
      $finish;
   end
   

   
   always begin
      #per ref_clk_external = ~ref_clk_external;
      
      
   end

   
   
   top_level_mux2_1 mux1(
			 .choice0(ref_clk_internal),
			 .choice1(ref_clk_external),
			 .selection_bit(ref_clk_select),
			 .selected_output(ref_clk)
			 );

   



   choice1_PFD_TDC choice1_PFD_TDC_instance( 
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
					     .vernier(vernier_out),
					     .tdc_ro(tdc_ro1)
					     );

   choice2_PFD_backup_TDC choice2_PFD_backup_TDC_instance(
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
							  .cross_pin(cross_pin),
							  .tdc_ro(tdc_ro2)
							  );


   choice3_standalone_PFD choice3_standalone_PFD_instance(
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


   vco_ideal vco2( 
		   .v_row(rows1),
		   .v_b_row(rows1_b),
		   .v_row1(rows2),
		   .v_b_row1(rows2_b),
		   .fine(fine),
		   .fine_b(fine_b),
		   .vout(dco_clk),
	           .enable_vco(enable_vco)
		   );
   



   pll_connected pll_connected1
     (
      .scan_in(scan_in),
      .update(update),
      .capture(capture),
      .phi(phi),
      .phi_bar(phi_bar),
      .scan_out(scan_out),

      .ref_clk_select(ref_clk_select),
      .ref_clk(ref_clk),      

      .tdc_ro1(divided_tdc_ro1),
      .tdc_ro2(divided_tdc_ro2),

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
      .reset2(reset2),
      .enable_choice1(enable_choice1),
      .enable_choice2(enable_choice2),
      .enable_choice3(enable_choice3),
      .select_PFD_input(select_PFD_input),
      .gated_dco_clk(gated_dco_clk),

      .rows1(rows1),
      .rows2(rows2),
      .rows1_b(rows1_b),
      .rows2_b(rows2_b),
      .fine(fine),
      .fine_b(fine_b),

      .delay_generator_enable(delay_generator_enable),
      .delay_generator_oscillation_mode(delay_generator_oscillation_mode),

      .delay_generator1_coarse_setting(delay_generator1_coarse_setting),
      .delay_generator1_fine_setting(delay_generator1_fine_setting),
      .delay_generator1_fine_bar_setting(delay_generator1_fine_bar_setting),

      .delay_generator2_coarse_setting(delay_generator2_coarse_setting),
      .delay_generator2_fine_setting(delay_generator2_fine_setting),
      .delay_generator2_fine_bar_setting(delay_generator2_fine_bar_setting),

      .ring_oscillator_coarse_setting(ring_oscillator_coarse_setting),
      .ring_oscillator_fine_setting(ring_oscillator_fine_setting),

      .ref_clk_divider_ratio(ref_clk_divider_ratio),
      .dco_clk_divider_ratio(dco_clk_divider_ratio),
      
      .selection_for_probe1(selection_for_probe1),
      .selection_for_probe2(selection_for_probe2),
      .tdc_ro_divider_ratio(tdc_ro_divider_ratio),
      .OEN_probe1_pad(OEN_probe1_pad),
      .OEN_probe2_pad(OEN_probe2_pad),
      .delay_generator_input_signal(delay_generator_input_signal),
      .divided_ref_clk(divided_ref_clk)
      );



   

   
   //  adpll2 adpll(ref_clk,reset,dco_clk,divided_dco_clk,Kin,tref,count,early,pll_divider, pll_divider2,computational_start,status);   

endmodule
