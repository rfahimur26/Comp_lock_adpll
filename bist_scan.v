module bist_scan
  #(parameter register_length = 30) 
   (
    input 	  scan_in,
    input 	  update,
    input 	  capture,
    input 	  phi,
    input 	  phi_bar,
    output 	  scan_out,
    /////////////////////////////
    input 	  reset2,
    input 	  new_div_ratio_given,
    input 	  lowbw,
    output wire   ref_clk_select,
    input 	  ref_clk,
   
    input [12:0]  tdc_output_flopped,
    input 	  early,
    input [12:0]  dco_input,
    input [13:0]  corrected_freq_error,
    input [13:0]  period_change,
    input [5:0]   status,
    input [19:0]  count_aggr,
    //////////////////////////////
    output 	  OEN_probe1_pad,
    output 	  OEN_probe2_pad,
    output 	  delay_generator_input_signal,
    output 	  calibration_mode,
    output [1:0]  selection_for_probe1,
    output [1:0]  selection_for_probe2,
    output 	  clk_count_start,
    output [6:0]  pll_divider_input,
    output [3:0]  ring_oscillator_coarse_setting,
    output [1:0]  ring_oscillator_fine_setting,
    output [2:0]  tdc_ro_divider_ratio,
    output [2:0]  ref_clk_divider_ratio,
    output [2:0]  dco_clk_divider_ratio,
    output 	  delay_generator_enable,
    output 	  delay_generator_oscillation_mode,
    output [11:0] delay_generator1_coarse_setting,
    output [23:0] delay_generator1_fine_setting,
    output [23:0] delay_generator1_fine_bar_setting,
    output [11:0] delay_generator2_coarse_setting,
    output [23:0] delay_generator2_fine_setting,
    output [23:0] delay_generator2_fine_bar_setting,
    output [12:0] dco_input_external,
    output [14:0] count_untill,
    input [14:0]  ref_dco_counter,
    input [14:0]  delay_gen_counter,
    input [14:0]  ref_tdc_counter,
    output [2:0]  computational_retimed_edge_select,
    output [1:0]  traditional_retimed_edge_select,
    output [1:0]  tdc_block_select,
    output 	  select_PFD_input,
    output 	  cold_start_traditional,
    output 	  continue_traditional,
    output [8:0]  coarse_res_finite,
    output [6:0]  medium_res_finite,
    output [5:0]  fine_res_finite,
    output [3:0]  fine_count_bbpll,
    output [8:0]  p_finite,
    output [8:0]  p_i_finite,
    output [9:0]  p_i_inverse_finite,
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
    output [7:0]  gain_finite,
    output [13:0] count_high_limit,
    output [13:0] count_low_limit,
    output [13:0] force_increment,
    output [13:0] force_decrement,
    output reg 	  divided_ref_clk
    );

   assign  delay_generator1_fine_bar_setting = ~delay_generator1_fine_setting ;
   assign  delay_generator2_fine_bar_setting = ~delay_generator2_fine_setting ;

   wire [10:0] 	  offset_input;
   wire [10:0] 	  decimator_input;
   wire [12:0] 	  tdc_limit;
   wire 	  enable_bist;
   wire [10:0] 	  locktime;
   wire [10:0] 	  computational_locktime;
   

   wire [12:0] 	  tdc_output_reg [register_length - 1:0];
   wire 	  early_reg [register_length - 1:0];
   wire [12:0] 	  dco_input_reg [register_length - 1:0];
   wire [13:0] 	  corrected_freq_error_reg [register_length - 1:0];
   
   wire [13:0] 	  period_change_reg [register_length - 1:0];
   wire [5:0] 	  status_reg [register_length - 1:0];
   wire [19:0] 	  count_aggr_reg [register_length - 1:0];

   
   
   wire 	  early_scan0;
   wire 	  early_scan1;
   wire 	  early_scan2;
   wire 	  early_scan3;
   wire 	  early_scan4;
   wire 	  early_scan5;
   wire 	  early_scan6;
   wire 	  early_scan7;
   wire 	  early_scan8;
   wire 	  early_scan9;
   wire 	  early_scan10;
   wire 	  early_scan11;
   wire 	  early_scan12;
   wire 	  early_scan13;
   wire 	  early_scan14;
   wire 	  early_scan15;
   wire 	  early_scan16;
   wire 	  early_scan17;
   wire 	  early_scan18;
   wire 	  early_scan19;
   wire 	  early_scan20;
   wire 	  early_scan21;
   wire 	  early_scan22;
   wire 	  early_scan23;
   wire 	  early_scan24;
   wire 	  early_scan25;
   wire 	  early_scan26;
   wire 	  early_scan27;
   wire 	  early_scan28;
   wire 	  early_scan29;
   
   
   wire [12:0] 	  tdc_output_scan0;
   wire [12:0] 	  tdc_output_scan1;
   wire [12:0] 	  tdc_output_scan2;
   wire [12:0] 	  tdc_output_scan3;
   wire [12:0] 	  tdc_output_scan4;
   wire [12:0] 	  tdc_output_scan5;
   wire [12:0] 	  tdc_output_scan6;
   wire [12:0] 	  tdc_output_scan7;
   wire [12:0] 	  tdc_output_scan8;
   wire [12:0] 	  tdc_output_scan9;
   wire [12:0] 	  tdc_output_scan10;
   wire [12:0] 	  tdc_output_scan11;
   wire [12:0] 	  tdc_output_scan12;
   wire [12:0] 	  tdc_output_scan13;
   wire [12:0] 	  tdc_output_scan14;
   wire [12:0] 	  tdc_output_scan15;
   wire [12:0] 	  tdc_output_scan16;
   wire [12:0] 	  tdc_output_scan17;
   wire [12:0] 	  tdc_output_scan18;
   wire [12:0] 	  tdc_output_scan19;
   wire [12:0] 	  tdc_output_scan20;
   wire [12:0] 	  tdc_output_scan21;
   wire [12:0] 	  tdc_output_scan22;
   wire [12:0] 	  tdc_output_scan23;
   wire [12:0] 	  tdc_output_scan24;
   wire [12:0] 	  tdc_output_scan25;
   wire [12:0] 	  tdc_output_scan26;
   wire [12:0] 	  tdc_output_scan27;
   wire [12:0] 	  tdc_output_scan28;
   wire [12:0] 	  tdc_output_scan29;


   wire [19:0] 	  count_aggr_scan0;
   wire [19:0] 	  count_aggr_scan1;
   wire [19:0] 	  count_aggr_scan2;
   wire [19:0] 	  count_aggr_scan3;
   wire [19:0] 	  count_aggr_scan4;
   wire [19:0] 	  count_aggr_scan5;
   wire [19:0] 	  count_aggr_scan6;
   wire [19:0] 	  count_aggr_scan7;
   wire [19:0] 	  count_aggr_scan8;
   wire [19:0] 	  count_aggr_scan9;
   wire [19:0] 	  count_aggr_scan10;
   wire [19:0] 	  count_aggr_scan11;
   wire [19:0] 	  count_aggr_scan12;
   wire [19:0] 	  count_aggr_scan13;
   wire [19:0] 	  count_aggr_scan14;
   wire [19:0] 	  count_aggr_scan15;
   wire [19:0] 	  count_aggr_scan16;
   wire [19:0] 	  count_aggr_scan17;
   wire [19:0] 	  count_aggr_scan18;
   wire [19:0] 	  count_aggr_scan19;
   wire [19:0] 	  count_aggr_scan20;
   wire [19:0] 	  count_aggr_scan21;
   wire [19:0] 	  count_aggr_scan22;
   wire [19:0] 	  count_aggr_scan23;
   wire [19:0] 	  count_aggr_scan24;
   wire [19:0] 	  count_aggr_scan25;
   wire [19:0] 	  count_aggr_scan26;
   wire [19:0] 	  count_aggr_scan27;
   wire [19:0] 	  count_aggr_scan28;
   wire [19:0] 	  count_aggr_scan29;
   
   
   wire [13:0] 	  period_change_scan0;
   wire [13:0] 	  period_change_scan1;
   wire [13:0] 	  period_change_scan2;
   wire [13:0] 	  period_change_scan3;
   wire [13:0] 	  period_change_scan4;
   wire [13:0] 	  period_change_scan5;
   wire [13:0] 	  period_change_scan6;
   wire [13:0] 	  period_change_scan7;
   wire [13:0] 	  period_change_scan8;
   wire [13:0] 	  period_change_scan9;
   wire [13:0] 	  period_change_scan10;
   wire [13:0] 	  period_change_scan11;
   wire [13:0] 	  period_change_scan12;
   wire [13:0] 	  period_change_scan13;
   wire [13:0] 	  period_change_scan14;
   wire [13:0] 	  period_change_scan15;
   wire [13:0] 	  period_change_scan16;
   wire [13:0] 	  period_change_scan17;
   wire [13:0] 	  period_change_scan18;
   wire [13:0] 	  period_change_scan19;
   wire [13:0] 	  period_change_scan20;
   wire [13:0] 	  period_change_scan21;
   wire [13:0] 	  period_change_scan22;
   wire [13:0] 	  period_change_scan23;
   wire [13:0] 	  period_change_scan24;
   wire [13:0] 	  period_change_scan25;
   wire [13:0] 	  period_change_scan26;
   wire [13:0] 	  period_change_scan27;
   wire [13:0] 	  period_change_scan28;
   wire [13:0] 	  period_change_scan29;
   
   
   wire [13:0] 	  corrected_freq_error_scan0;
   wire [13:0] 	  corrected_freq_error_scan1;
   wire [13:0] 	  corrected_freq_error_scan2;
   wire [13:0] 	  corrected_freq_error_scan3;
   wire [13:0] 	  corrected_freq_error_scan4;
   wire [13:0] 	  corrected_freq_error_scan5;
   wire [13:0] 	  corrected_freq_error_scan6;
   wire [13:0] 	  corrected_freq_error_scan7;
   wire [13:0] 	  corrected_freq_error_scan8;
   wire [13:0] 	  corrected_freq_error_scan9;
   wire [13:0] 	  corrected_freq_error_scan10;
   wire [13:0] 	  corrected_freq_error_scan11;
   wire [13:0] 	  corrected_freq_error_scan12;
   wire [13:0] 	  corrected_freq_error_scan13;
   wire [13:0] 	  corrected_freq_error_scan14;
   wire [13:0] 	  corrected_freq_error_scan15;
   wire [13:0] 	  corrected_freq_error_scan16;
   wire [13:0] 	  corrected_freq_error_scan17;
   wire [13:0] 	  corrected_freq_error_scan18;
   wire [13:0] 	  corrected_freq_error_scan19;
   wire [13:0] 	  corrected_freq_error_scan20;
   wire [13:0] 	  corrected_freq_error_scan21;
   wire [13:0] 	  corrected_freq_error_scan22;
   wire [13:0] 	  corrected_freq_error_scan23;
   wire [13:0] 	  corrected_freq_error_scan24;
   wire [13:0] 	  corrected_freq_error_scan25;
   wire [13:0] 	  corrected_freq_error_scan26;
   wire [13:0] 	  corrected_freq_error_scan27;
   wire [13:0] 	  corrected_freq_error_scan28;
   wire [13:0] 	  corrected_freq_error_scan29;


   wire [12:0] 	  dco_input_scan0;
   wire [12:0] 	  dco_input_scan1;
   wire [12:0] 	  dco_input_scan2;
   wire [12:0] 	  dco_input_scan3;
   wire [12:0] 	  dco_input_scan4;
   wire [12:0] 	  dco_input_scan5;
   wire [12:0] 	  dco_input_scan6;
   wire [12:0] 	  dco_input_scan7;
   wire [12:0] 	  dco_input_scan8;
   wire [12:0] 	  dco_input_scan9;
   wire [12:0] 	  dco_input_scan10;
   wire [12:0] 	  dco_input_scan11;
   wire [12:0] 	  dco_input_scan12;
   wire [12:0] 	  dco_input_scan13;
   wire [12:0] 	  dco_input_scan14;
   wire [12:0] 	  dco_input_scan15;
   wire [12:0] 	  dco_input_scan16;
   wire [12:0] 	  dco_input_scan17;
   wire [12:0] 	  dco_input_scan18;
   wire [12:0] 	  dco_input_scan19;
   wire [12:0] 	  dco_input_scan20;
   wire [12:0] 	  dco_input_scan21;
   wire [12:0] 	  dco_input_scan22;
   wire [12:0] 	  dco_input_scan23;
   wire [12:0] 	  dco_input_scan24;
   wire [12:0] 	  dco_input_scan25;
   wire [12:0] 	  dco_input_scan26;
   wire [12:0] 	  dco_input_scan27;
   wire [12:0] 	  dco_input_scan28;
   wire [12:0] 	  dco_input_scan29;


   wire [5:0] 	  status_scan0;
   wire [5:0] 	  status_scan1;
   wire [5:0] 	  status_scan2;
   wire [5:0] 	  status_scan3;
   wire [5:0] 	  status_scan4;
   wire [5:0] 	  status_scan5;
   wire [5:0] 	  status_scan6;
   wire [5:0] 	  status_scan7;
   wire [5:0] 	  status_scan8;
   wire [5:0] 	  status_scan9;
   wire [5:0] 	  status_scan10;
   wire [5:0] 	  status_scan11;
   wire [5:0] 	  status_scan12;
   wire [5:0] 	  status_scan13;
   wire [5:0] 	  status_scan14;
   wire [5:0] 	  status_scan15;
   wire [5:0] 	  status_scan16;
   wire [5:0] 	  status_scan17;
   wire [5:0] 	  status_scan18;
   wire [5:0] 	  status_scan19;
   wire [5:0] 	  status_scan20;
   wire [5:0] 	  status_scan21;
   wire [5:0] 	  status_scan22;
   wire [5:0] 	  status_scan23;
   wire [5:0] 	  status_scan24;
   wire [5:0] 	  status_scan25;
   wire [5:0] 	  status_scan26;
   wire [5:0] 	  status_scan27;
   wire [5:0] 	  status_scan28;
   wire [5:0] 	  status_scan29 ;

   assign early_scan29 = early_reg[29];
   assign early_scan28 = early_reg[28];
   assign early_scan27 = early_reg[27];
   assign early_scan26 = early_reg[26];
   assign early_scan25 = early_reg[25];
   assign early_scan24 = early_reg[24];
   assign early_scan23 = early_reg[23];
   assign early_scan22 = early_reg[22];
   assign early_scan21 = early_reg[21];
   assign early_scan20 = early_reg[20];
   assign early_scan19 = early_reg[19];
   assign early_scan18 = early_reg[18];
   assign early_scan17 = early_reg[17];
   assign early_scan16 = early_reg[16];
   assign early_scan15 = early_reg[15];
   assign early_scan14 = early_reg[14];
   assign early_scan13 = early_reg[13];
   assign early_scan12 = early_reg[12];
   assign early_scan11 = early_reg[11];
   assign early_scan10 = early_reg[10];
   assign early_scan9 = early_reg[9];
   assign early_scan8 = early_reg[8];
   assign early_scan7 = early_reg[7];
   assign early_scan6 = early_reg[6];
   assign early_scan5 = early_reg[5];
   assign early_scan4 = early_reg[4];
   assign early_scan3 = early_reg[3];
   assign early_scan2 = early_reg[2];
   assign early_scan1 = early_reg[1];
   assign early_scan0 = early_reg[0];

   assign tdc_output_scan29 = tdc_output_reg[29];
   assign tdc_output_scan28 = tdc_output_reg[28];
   assign tdc_output_scan27 = tdc_output_reg[27];
   assign tdc_output_scan26 = tdc_output_reg[26];
   assign tdc_output_scan25 = tdc_output_reg[25];
   assign tdc_output_scan24 = tdc_output_reg[24];
   assign tdc_output_scan23 = tdc_output_reg[23];
   assign tdc_output_scan22 = tdc_output_reg[22];
   assign tdc_output_scan21 = tdc_output_reg[21];
   assign tdc_output_scan20 = tdc_output_reg[20];
   assign tdc_output_scan19 = tdc_output_reg[19];
   assign tdc_output_scan18 = tdc_output_reg[18];
   assign tdc_output_scan17 = tdc_output_reg[17];
   assign tdc_output_scan16 = tdc_output_reg[16];
   assign tdc_output_scan15 = tdc_output_reg[15];
   assign tdc_output_scan14 = tdc_output_reg[14];
   assign tdc_output_scan13 = tdc_output_reg[13];
   assign tdc_output_scan12 = tdc_output_reg[12];
   assign tdc_output_scan11 = tdc_output_reg[11];
   assign tdc_output_scan10 = tdc_output_reg[10];
   assign tdc_output_scan9 = tdc_output_reg[9];
   assign tdc_output_scan8 = tdc_output_reg[8];
   assign tdc_output_scan7 = tdc_output_reg[7];
   assign tdc_output_scan6 = tdc_output_reg[6];
   assign tdc_output_scan5 = tdc_output_reg[5];
   assign tdc_output_scan4 = tdc_output_reg[4];
   assign tdc_output_scan3 = tdc_output_reg[3];
   assign tdc_output_scan2 = tdc_output_reg[2];
   assign tdc_output_scan1 = tdc_output_reg[1];
   assign tdc_output_scan0 = tdc_output_reg[0];

   assign count_aggr_scan29 = count_aggr_reg[29];
   assign count_aggr_scan28 = count_aggr_reg[28];
   assign count_aggr_scan27 = count_aggr_reg[27];
   assign count_aggr_scan26 = count_aggr_reg[26];
   assign count_aggr_scan25 = count_aggr_reg[25];
   assign count_aggr_scan24 = count_aggr_reg[24];
   assign count_aggr_scan23 = count_aggr_reg[23];
   assign count_aggr_scan22 = count_aggr_reg[22];
   assign count_aggr_scan21 = count_aggr_reg[21];
   assign count_aggr_scan20 = count_aggr_reg[20];
   assign count_aggr_scan19 = count_aggr_reg[19];
   assign count_aggr_scan18 = count_aggr_reg[18];
   assign count_aggr_scan17 = count_aggr_reg[17];
   assign count_aggr_scan16 = count_aggr_reg[16];
   assign count_aggr_scan15 = count_aggr_reg[15];
   assign count_aggr_scan14 = count_aggr_reg[14];
   assign count_aggr_scan13 = count_aggr_reg[13];
   assign count_aggr_scan12 = count_aggr_reg[12];
   assign count_aggr_scan11 = count_aggr_reg[11];
   assign count_aggr_scan10 = count_aggr_reg[10];
   assign count_aggr_scan9 = count_aggr_reg[9];
   assign count_aggr_scan8 = count_aggr_reg[8];
   assign count_aggr_scan7 = count_aggr_reg[7];
   assign count_aggr_scan6 = count_aggr_reg[6];
   assign count_aggr_scan5 = count_aggr_reg[5];
   assign count_aggr_scan4 = count_aggr_reg[4];
   assign count_aggr_scan3 = count_aggr_reg[3];
   assign count_aggr_scan2 = count_aggr_reg[2];
   assign count_aggr_scan1 = count_aggr_reg[1];
   assign count_aggr_scan0 = count_aggr_reg[0];

   assign period_change_scan29 = period_change_reg[29];
   assign period_change_scan28 = period_change_reg[28];
   assign period_change_scan27 = period_change_reg[27];
   assign period_change_scan26 = period_change_reg[26];
   assign period_change_scan25 = period_change_reg[25];
   assign period_change_scan24 = period_change_reg[24];
   assign period_change_scan23 = period_change_reg[23];
   assign period_change_scan22 = period_change_reg[22];
   assign period_change_scan21 = period_change_reg[21];
   assign period_change_scan20 = period_change_reg[20];
   assign period_change_scan19 = period_change_reg[19];
   assign period_change_scan18 = period_change_reg[18];
   assign period_change_scan17 = period_change_reg[17];
   assign period_change_scan16 = period_change_reg[16];
   assign period_change_scan15 = period_change_reg[15];
   assign period_change_scan14 = period_change_reg[14];
   assign period_change_scan13 = period_change_reg[13];
   assign period_change_scan12 = period_change_reg[12];
   assign period_change_scan11 = period_change_reg[11];
   assign period_change_scan10 = period_change_reg[10];
   assign period_change_scan9 = period_change_reg[9];
   assign period_change_scan8 = period_change_reg[8];
   assign period_change_scan7 = period_change_reg[7];
   assign period_change_scan6 = period_change_reg[6];
   assign period_change_scan5 = period_change_reg[5];
   assign period_change_scan4 = period_change_reg[4];
   assign period_change_scan3 = period_change_reg[3];
   assign period_change_scan2 = period_change_reg[2];
   assign period_change_scan1 = period_change_reg[1];
   assign period_change_scan0 = period_change_reg[0];

   assign corrected_freq_error_scan29 = corrected_freq_error_reg[29];
   assign corrected_freq_error_scan28 = corrected_freq_error_reg[28];
   assign corrected_freq_error_scan27 = corrected_freq_error_reg[27];
   assign corrected_freq_error_scan26 = corrected_freq_error_reg[26];
   assign corrected_freq_error_scan25 = corrected_freq_error_reg[25];
   assign corrected_freq_error_scan24 = corrected_freq_error_reg[24];
   assign corrected_freq_error_scan23 = corrected_freq_error_reg[23];
   assign corrected_freq_error_scan22 = corrected_freq_error_reg[22];
   assign corrected_freq_error_scan21 = corrected_freq_error_reg[21];
   assign corrected_freq_error_scan20 = corrected_freq_error_reg[20];
   assign corrected_freq_error_scan19 = corrected_freq_error_reg[19];
   assign corrected_freq_error_scan18 = corrected_freq_error_reg[18];
   assign corrected_freq_error_scan17 = corrected_freq_error_reg[17];
   assign corrected_freq_error_scan16 = corrected_freq_error_reg[16];
   assign corrected_freq_error_scan15 = corrected_freq_error_reg[15];
   assign corrected_freq_error_scan14 = corrected_freq_error_reg[14];
   assign corrected_freq_error_scan13 = corrected_freq_error_reg[13];
   assign corrected_freq_error_scan12 = corrected_freq_error_reg[12];
   assign corrected_freq_error_scan11 = corrected_freq_error_reg[11];
   assign corrected_freq_error_scan10 = corrected_freq_error_reg[10];
   assign corrected_freq_error_scan9 = corrected_freq_error_reg[9];
   assign corrected_freq_error_scan8 = corrected_freq_error_reg[8];
   assign corrected_freq_error_scan7 = corrected_freq_error_reg[7];
   assign corrected_freq_error_scan6 = corrected_freq_error_reg[6];
   assign corrected_freq_error_scan5 = corrected_freq_error_reg[5];
   assign corrected_freq_error_scan4 = corrected_freq_error_reg[4];
   assign corrected_freq_error_scan3 = corrected_freq_error_reg[3];
   assign corrected_freq_error_scan2 = corrected_freq_error_reg[2];
   assign corrected_freq_error_scan1 = corrected_freq_error_reg[1];
   assign corrected_freq_error_scan0 = corrected_freq_error_reg[0];

   assign dco_input_scan29 = dco_input_reg[29];
   assign dco_input_scan28 = dco_input_reg[28];
   assign dco_input_scan27 = dco_input_reg[27];
   assign dco_input_scan26 = dco_input_reg[26];
   assign dco_input_scan25 = dco_input_reg[25];
   assign dco_input_scan24 = dco_input_reg[24];
   assign dco_input_scan23 = dco_input_reg[23];
   assign dco_input_scan22 = dco_input_reg[22];
   assign dco_input_scan21 = dco_input_reg[21];
   assign dco_input_scan20 = dco_input_reg[20];
   assign dco_input_scan19 = dco_input_reg[19];
   assign dco_input_scan18 = dco_input_reg[18];
   assign dco_input_scan17 = dco_input_reg[17];
   assign dco_input_scan16 = dco_input_reg[16];
   assign dco_input_scan15 = dco_input_reg[15];
   assign dco_input_scan14 = dco_input_reg[14];
   assign dco_input_scan13 = dco_input_reg[13];
   assign dco_input_scan12 = dco_input_reg[12];
   assign dco_input_scan11 = dco_input_reg[11];
   assign dco_input_scan10 = dco_input_reg[10];
   assign dco_input_scan9 = dco_input_reg[9];
   assign dco_input_scan8 = dco_input_reg[8];
   assign dco_input_scan7 = dco_input_reg[7];
   assign dco_input_scan6 = dco_input_reg[6];
   assign dco_input_scan5 = dco_input_reg[5];
   assign dco_input_scan4 = dco_input_reg[4];
   assign dco_input_scan3 = dco_input_reg[3];
   assign dco_input_scan2 = dco_input_reg[2];
   assign dco_input_scan1 = dco_input_reg[1];
   assign dco_input_scan0 = dco_input_reg[0];

   assign status_scan29 = status_reg[29];
   assign status_scan28 = status_reg[28];
   assign status_scan27 = status_reg[27];
   assign status_scan26 = status_reg[26];
   assign status_scan25 = status_reg[25];
   assign status_scan24 = status_reg[24];
   assign status_scan23 = status_reg[23];
   assign status_scan22 = status_reg[22];
   assign status_scan21 = status_reg[21];
   assign status_scan20 = status_reg[20];
   assign status_scan19 = status_reg[19];
   assign status_scan18 = status_reg[18];
   assign status_scan17 = status_reg[17];
   assign status_scan16 = status_reg[16];
   assign status_scan15 = status_reg[15];
   assign status_scan14 = status_reg[14];
   assign status_scan13 = status_reg[13];
   assign status_scan12 = status_reg[12];
   assign status_scan11 = status_reg[11];
   assign status_scan10 = status_reg[10];
   assign status_scan9 = status_reg[9];
   assign status_scan8 = status_reg[8];
   assign status_scan7 = status_reg[7];
   assign status_scan6 = status_reg[6];
   assign status_scan5 = status_reg[5];
   assign status_scan4 = status_reg[4];
   assign status_scan3 = status_reg[3];
   assign status_scan2 = status_reg[2];
   assign status_scan1 = status_reg[1];
   assign status_scan0 = status_reg[0];

   
   reg [7:0] 	  ref_clk_divider_count;
   always @(posedge ref_clk or negedge reset2) begin
      if (~reset2) begin
	 ref_clk_divider_count <= 0;
	 
      end
      else ref_clk_divider_count <= ref_clk_divider_count + 1;
      
   end


   always @*  begin
      case (ref_clk_divider_ratio) 
	3'b000: divided_ref_clk = ref_clk_divider_count[0];
	3'b001: divided_ref_clk = ref_clk_divider_count[1];
	3'b010: divided_ref_clk = ref_clk_divider_count[2];
	3'b011: divided_ref_clk = ref_clk_divider_count[3];
	3'b100: divided_ref_clk = ref_clk_divider_count[4];
	3'b101: divided_ref_clk = ref_clk_divider_count[5];
	3'b110: divided_ref_clk = ref_clk_divider_count[6];
	3'b111: divided_ref_clk = ref_clk_divider_count[7];
      endcase
	  
   end

      
   
   scan_module_adpll sm0 (
			  .scan_in(scan_in),
			  .scan_out(scan_out),
			  .update(update),
			  .capture(capture),
			  .phi(phi),
			  .phi_bar(phi_bar),
			  .OEN_probe1_pad(OEN_probe1_pad),
			  .OEN_probe2_pad(OEN_probe2_pad),
			  .enable_bist(enable_bist),
			  .calibration_mode(calibration_mode),
			  .delay_generator_input_signal(delay_generator_input_signal),
			  .ref_clk_select(ref_clk_select),
			  .selection_for_probe1(selection_for_probe1),
			  .selection_for_probe2(selection_for_probe2),
			  .clk_count_start(clk_count_start),
			  .pll_divider_input(pll_divider_input),
			  .ring_oscillator_coarse_setting(ring_oscillator_coarse_setting),
			  .ring_oscillator_fine_setting(ring_oscillator_fine_setting),
			  .ref_clk_divider_ratio(ref_clk_divider_ratio),
			  .dco_clk_divider_ratio(dco_clk_divider_ratio),
			  .tdc_ro_divider_ratio(tdc_ro_divider_ratio),
			  .delay_generator_enable(delay_generator_enable),
			  .delay_generator_oscillation_mode(delay_generator_oscillation_mode),
			  .delay_generator1_coarse_setting(delay_generator1_coarse_setting),
			  .delay_generator1_fine_setting(delay_generator1_fine_setting),
			  .delay_generator2_coarse_setting(delay_generator2_coarse_setting),
			  .delay_generator2_fine_setting(delay_generator2_fine_setting),
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
			  .locktime(locktime),
			  .computational_locktime(computational_locktime),
			  .tdc_limit(tdc_limit),
			  .offset_input(offset_input),
			  .decimator_input(decimator_input),
      
			  .instant_early(early),
			  .instant_tdc_output(tdc_output_flopped),
			  .instant_count_aggr(count_aggr),
			  .instant_dco_input(dco_input),
			  .instant_status(status),
      
			  .early_scan0(early_scan0),
			  .early_scan1(early_scan1),
			  .early_scan2(early_scan2),
			  .early_scan3(early_scan3),
			  .early_scan4(early_scan4),
			  .early_scan5(early_scan5),
			  .early_scan6(early_scan6),
			  .early_scan7(early_scan7),
			  .early_scan8(early_scan8),
			  .early_scan9(early_scan9),
			  .early_scan10(early_scan10),
			  .early_scan11(early_scan11),
			  .early_scan12(early_scan12),
			  .early_scan13(early_scan13),
			  .early_scan14(early_scan14),
			  .early_scan15(early_scan15),
			  .early_scan16(early_scan16),
			  .early_scan17(early_scan17),
			  .early_scan18(early_scan18),
			  .early_scan19(early_scan19),
			  .early_scan20(early_scan20),
			  .early_scan21(early_scan21),
			  .early_scan22(early_scan22),
			  .early_scan23(early_scan23),
			  .early_scan24(early_scan24),
			  .early_scan25(early_scan25),
			  .early_scan26(early_scan26),
			  .early_scan27(early_scan27),
			  .early_scan28(early_scan28),
			  .early_scan29(early_scan29),
			  .tdc_output_scan0(tdc_output_scan0),
			  .tdc_output_scan1(tdc_output_scan1),
			  .tdc_output_scan2(tdc_output_scan2),
			  .tdc_output_scan3(tdc_output_scan3),
			  .tdc_output_scan4(tdc_output_scan4),
			  .tdc_output_scan5(tdc_output_scan5),
			  .tdc_output_scan6(tdc_output_scan6),
			  .tdc_output_scan7(tdc_output_scan7),
			  .tdc_output_scan8(tdc_output_scan8),
			  .tdc_output_scan9(tdc_output_scan9),
			  .tdc_output_scan10(tdc_output_scan10),
			  .tdc_output_scan11(tdc_output_scan11),
			  .tdc_output_scan12(tdc_output_scan12),
			  .tdc_output_scan13(tdc_output_scan13),
			  .tdc_output_scan14(tdc_output_scan14),
			  .tdc_output_scan15(tdc_output_scan15),
			  .tdc_output_scan16(tdc_output_scan16),
			  .tdc_output_scan17(tdc_output_scan17),
			  .tdc_output_scan18(tdc_output_scan18),
			  .tdc_output_scan19(tdc_output_scan19),
			  .tdc_output_scan20(tdc_output_scan20),
			  .tdc_output_scan21(tdc_output_scan21),
			  .tdc_output_scan22(tdc_output_scan22),
			  .tdc_output_scan23(tdc_output_scan23),
			  .tdc_output_scan24(tdc_output_scan24),
			  .tdc_output_scan25(tdc_output_scan25),
			  .tdc_output_scan26(tdc_output_scan26),
			  .tdc_output_scan27(tdc_output_scan27),
			  .tdc_output_scan28(tdc_output_scan28),
			  .tdc_output_scan29(tdc_output_scan29),
			  .count_aggr_scan0(count_aggr_scan0),
			  .count_aggr_scan1(count_aggr_scan1),
			  .count_aggr_scan2(count_aggr_scan2),
			  .count_aggr_scan3(count_aggr_scan3),
			  .count_aggr_scan4(count_aggr_scan4),
			  .count_aggr_scan5(count_aggr_scan5),
			  .count_aggr_scan6(count_aggr_scan6),
			  .count_aggr_scan7(count_aggr_scan7),
			  .count_aggr_scan8(count_aggr_scan8),
			  .count_aggr_scan9(count_aggr_scan9),
			  .count_aggr_scan10(count_aggr_scan10),
			  .count_aggr_scan11(count_aggr_scan11),
			  .count_aggr_scan12(count_aggr_scan12),
			  .count_aggr_scan13(count_aggr_scan13),
			  .count_aggr_scan14(count_aggr_scan14),
			  .count_aggr_scan15(count_aggr_scan15),
			  .count_aggr_scan16(count_aggr_scan16),
			  .count_aggr_scan17(count_aggr_scan17),
			  .count_aggr_scan18(count_aggr_scan18),
			  .count_aggr_scan19(count_aggr_scan19),
			  .count_aggr_scan20(count_aggr_scan20),
			  .count_aggr_scan21(count_aggr_scan21),
			  .count_aggr_scan22(count_aggr_scan22),
			  .count_aggr_scan23(count_aggr_scan23),
			  .count_aggr_scan24(count_aggr_scan24),
			  .count_aggr_scan25(count_aggr_scan25),
			  .count_aggr_scan26(count_aggr_scan26),
			  .count_aggr_scan27(count_aggr_scan27),
			  .count_aggr_scan28(count_aggr_scan28),
			  .count_aggr_scan29(count_aggr_scan29),
			  .period_change_scan0(period_change_scan0),
			  .period_change_scan1(period_change_scan1),
			  .period_change_scan2(period_change_scan2),
			  .period_change_scan3(period_change_scan3),
			  .period_change_scan4(period_change_scan4),
			  .period_change_scan5(period_change_scan5),
			  .period_change_scan6(period_change_scan6),
			  .period_change_scan7(period_change_scan7),
			  .period_change_scan8(period_change_scan8),
			  .period_change_scan9(period_change_scan9),
			  .period_change_scan10(period_change_scan10),
			  .period_change_scan11(period_change_scan11),
			  .period_change_scan12(period_change_scan12),
			  .period_change_scan13(period_change_scan13),
			  .period_change_scan14(period_change_scan14),
			  .period_change_scan15(period_change_scan15),
			  .period_change_scan16(period_change_scan16),
			  .period_change_scan17(period_change_scan17),
			  .period_change_scan18(period_change_scan18),
			  .period_change_scan19(period_change_scan19),
			  .period_change_scan20(period_change_scan20),
			  .period_change_scan21(period_change_scan21),
			  .period_change_scan22(period_change_scan22),
			  .period_change_scan23(period_change_scan23),
			  .period_change_scan24(period_change_scan24),
			  .period_change_scan25(period_change_scan25),
			  .period_change_scan26(period_change_scan26),
			  .period_change_scan27(period_change_scan27),
			  .period_change_scan28(period_change_scan28),
			  .period_change_scan29(period_change_scan29),
			  .corrected_freq_error_scan0(corrected_freq_error_scan0),
			  .corrected_freq_error_scan1(corrected_freq_error_scan1),
			  .corrected_freq_error_scan2(corrected_freq_error_scan2),
			  .corrected_freq_error_scan3(corrected_freq_error_scan3),
			  .corrected_freq_error_scan4(corrected_freq_error_scan4),
			  .corrected_freq_error_scan5(corrected_freq_error_scan5),
			  .corrected_freq_error_scan6(corrected_freq_error_scan6),
			  .corrected_freq_error_scan7(corrected_freq_error_scan7),
			  .corrected_freq_error_scan8(corrected_freq_error_scan8),
			  .corrected_freq_error_scan9(corrected_freq_error_scan9),
			  .corrected_freq_error_scan10(corrected_freq_error_scan10),
			  .corrected_freq_error_scan11(corrected_freq_error_scan11),
			  .corrected_freq_error_scan12(corrected_freq_error_scan12),
			  .corrected_freq_error_scan13(corrected_freq_error_scan13),
			  .corrected_freq_error_scan14(corrected_freq_error_scan14),
			  .corrected_freq_error_scan15(corrected_freq_error_scan15),
			  .corrected_freq_error_scan16(corrected_freq_error_scan16),
			  .corrected_freq_error_scan17(corrected_freq_error_scan17),
			  .corrected_freq_error_scan18(corrected_freq_error_scan18),
			  .corrected_freq_error_scan19(corrected_freq_error_scan19),
			  .corrected_freq_error_scan20(corrected_freq_error_scan20),
			  .corrected_freq_error_scan21(corrected_freq_error_scan21),
			  .corrected_freq_error_scan22(corrected_freq_error_scan22),
			  .corrected_freq_error_scan23(corrected_freq_error_scan23),
			  .corrected_freq_error_scan24(corrected_freq_error_scan24),
			  .corrected_freq_error_scan25(corrected_freq_error_scan25),
			  .corrected_freq_error_scan26(corrected_freq_error_scan26),
			  .corrected_freq_error_scan27(corrected_freq_error_scan27),
			  .corrected_freq_error_scan28(corrected_freq_error_scan28),
			  .corrected_freq_error_scan29(corrected_freq_error_scan29),
			  .dco_input_scan0(dco_input_scan0),
			  .dco_input_scan1(dco_input_scan1),
			  .dco_input_scan2(dco_input_scan2),
			  .dco_input_scan3(dco_input_scan3),
			  .dco_input_scan4(dco_input_scan4),
			  .dco_input_scan5(dco_input_scan5),
			  .dco_input_scan6(dco_input_scan6),
			  .dco_input_scan7(dco_input_scan7),
			  .dco_input_scan8(dco_input_scan8),
			  .dco_input_scan9(dco_input_scan9),
			  .dco_input_scan10(dco_input_scan10),
			  .dco_input_scan11(dco_input_scan11),
			  .dco_input_scan12(dco_input_scan12),
			  .dco_input_scan13(dco_input_scan13),
			  .dco_input_scan14(dco_input_scan14),
			  .dco_input_scan15(dco_input_scan15),
			  .dco_input_scan16(dco_input_scan16),
			  .dco_input_scan17(dco_input_scan17),
			  .dco_input_scan18(dco_input_scan18),
			  .dco_input_scan19(dco_input_scan19),
			  .dco_input_scan20(dco_input_scan20),
			  .dco_input_scan21(dco_input_scan21),
			  .dco_input_scan22(dco_input_scan22),
			  .dco_input_scan23(dco_input_scan23),
			  .dco_input_scan24(dco_input_scan24),
			  .dco_input_scan25(dco_input_scan25),
			  .dco_input_scan26(dco_input_scan26),
			  .dco_input_scan27(dco_input_scan27),
			  .dco_input_scan28(dco_input_scan28),
			  .dco_input_scan29(dco_input_scan29),
			  .status_scan0(status_scan0),
			  .status_scan1(status_scan1),
			  .status_scan2(status_scan2),
			  .status_scan3(status_scan3),
			  .status_scan4(status_scan4),
			  .status_scan5(status_scan5),
			  .status_scan6(status_scan6),
			  .status_scan7(status_scan7),
			  .status_scan8(status_scan8),
			  .status_scan9(status_scan9),
			  .status_scan10(status_scan10),
			  .status_scan11(status_scan11),
			  .status_scan12(status_scan12),
			  .status_scan13(status_scan13),
			  .status_scan14(status_scan14),
			  .status_scan15(status_scan15),
			  .status_scan16(status_scan16),
			  .status_scan17(status_scan17),
			  .status_scan18(status_scan18),
			  .status_scan19(status_scan19),
			  .status_scan20(status_scan20),
			  .status_scan21(status_scan21),
			  .status_scan22(status_scan22),
			  .status_scan23(status_scan23),
			  .status_scan24(status_scan24),
			  .status_scan25(status_scan25),
			  .status_scan26(status_scan26),
			  .status_scan27(status_scan27),
			  .status_scan28(status_scan28),
			  .status_scan29(status_scan29)
			  );  
   

   bist bist1
     (
      .ref_clk_bist(ref_clk),
      .enable_bist(enable_bist),

      .reset(reset2),

      .offset_input(offset_input),
      .decimator_input(decimator_input),

      .new_div_ratio_given(new_div_ratio_given),
      .lowbw(lowbw),
      .tdc_limit(tdc_limit),

      .tdc_output(tdc_output_flopped),
      .early(early),
      .dco_input(dco_input),
      .corrected_freq_error(corrected_freq_error),
      .period_change(period_change),
      .status(status),
      .count_aggr(count_aggr),
      
      .tdc_output_reg(tdc_output_reg),
      .early_reg(early_reg),
      .dco_input_reg(dco_input_reg),
      .corrected_freq_error_reg(corrected_freq_error_reg),
      
      .period_change_reg(period_change_reg),
      .status_reg(status_reg),
      .count_aggr_reg(count_aggr_reg),

      .locktime(locktime),
      .computational_locktime(computational_locktime)
      
      );

   

endmodule // bist


