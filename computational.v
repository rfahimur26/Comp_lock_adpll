module computational(
		     input wire 	       ref_clk,
		     input wire 	       dco_clk,
		     input [6:0] 	       pll_divider,
		     input [6:0] 	       pll_divider2,
		     input reg 		       reset,
		     input reg 		       computational_start,
		     input 		       calibration_mode,
		     
		     input reg 		       early,
		     input 		       fine_done,
		     input reg 		       computational_fine_done_retimed_pre,
		     input wire [12:0] 	       tdc_output_finite,
		     output wire 	       lowbw,
		     output wire 	       lowbw_pre,
		     output reg [5:0] 	       status,
		     input [6:0] 	       freq_counter_pre,
		     input wire 	       resnap_happened,
		     output wire signed [12:0] 	       filter_output_computational_finite,
		     input wire [2:0] 	       retimed_edge_select,
		     input 		       cold_start_traditional,
		     input [13:0] 	       Kin1_poly_finite ,
		     input [13:0] 	       Kin2_out_finite_resetval,
		     input [13:0] 	       negative_phase_tolerance_finite,
		     input [13:0] 	       positive_phase_tolerance_finite,
		     input [13:0] 	       negative_freq_tolerance_finite,
		     input [13:0] 	       positive_freq_tolerance_finite,
		     input [13:0] 	       negative_freq_tolerance_finite2,
		     input [13:0] 	       positive_freq_tolerance_finite2,
		     input 		       phase_jolt_change_edge,
		     
		     output wire signed [13:0] period_change_finite,
		     output wire signed [13:0] corrected_error_for_update, 
		     output reg signed [13:0]  update,

		     output wire [6:0] 	       cycle_passed_finite,

		     output wire signed [13:0] count_finite,
		     input [7:0] 	       gain_finite,
		     input [13:0] 	       count_high_limit,
		     input [13:0] 	       count_low_limit,
		     input [13:0] 	       force_increment,
		     input [13:0] 	       force_decrement,
		     output 		       dco_change_edge,
		     output 		       fine_done_with_reset, 
		    
		    	    
			    
		     output reg 	       phase_jolt_given,
		     output reg [5:0] 	       next_status,
		     output reg [12:0] 	       freq_locked_code,
		     output reg [12:0] 	       tdc_output_reg_finite
		     );
   
   
   // reg [5:0] 				       status;
   // reg [5:0] 				       next_status;
   reg 					       retimed_tdc_pre;
   reg [6:0] 				       cycle_at_fine_done;
   reg [6:0] 				       cycle_at_fine_done_old;
   reg signed [3:0] 			       dco_edge_delay;
   
   reg signed [13:0] 			       count_finite_old;
   
   assign filter_output_computational = 0;
   /////////////////////////////////////////////////////////////

   localparam start = 5'd0;
   localparam resnap_initial = 5'd1;           //resnapping for cold start 
   localparam resnap_initial_again = 5'd2;     //backup resnapping
   localparam wait_after_resnap = 5'd3;             //two cycles for frequency measurement after resnapping
   localparam wait_init1 = 5'd4;
   localparam wait_init2 = 5'd5;
   localparam measure_update_freq_first = 5'd6; // may be frequency locked in the beginning. this is different than measure_update_freq since it doesn't use frequency correction

   localparam measure_update_freq = 5'd7;  //frequency lock measurement
   localparam check_effect1 = 5'd8;     // applyign the frequency change needed
   localparam resnap = 5'd9;   //resnapping after phase_lock
   localparam resnap_again = 5'd10;  // sometimes first resnap doesn't happened
   localparam phase_wait1 = 5'd11;   // after resnapping , wait for the correct PFD output again
   localparam measure_update_phase = 5'd12;   // measuring phase difference
   
   localparam phase_locked1 = 5'd14;    //done
   localparam phase_locked = 5'd15;     //used for handing over the traditional mode
   localparam measure_update_freq_second = 5'd16; //setting up the chain of frequency_error_estimation
   
   // the following states are defined incase the tdc goes out of range after the frequency estimation
   localparam resnap_wrong_estimation = 5'd17;
   localparam resnap_wrong_estimation_again = 5'd18;
   localparam wait_after_resnap_wrong_estimation = 5'd19;
   localparam wait_wrong_estimation1 = 5'd20;
   localparam wait_wrong_estimation2 = 5'd21;
   localparam wait_init0 = 5'd22;
   localparam measure_update_phase1 = 5'd23;
   
   
   //////////////////////////////////////////////////////////////////   

   

   ////////////////////
   
   
   //////////////////////////////////
   
   reg 					       vout_pre_logic; // when to update at the 0th dco cycle
   // reg 	     retimed_tdc_pre;
   // wire 				       dco_change_edge;

   reg 					       reset1 , reset2,reset3;
   
   
   assign lowbw_pre = (status == measure_update_phase | status == measure_update_phase1 | status == phase_locked1 | status == phase_locked | status == wait_init1) ? 1: 0;
   assign lowbw = (status == phase_locked ) ? 1: 0;     //flopped value of lowbw determines whether the pll is in traditional or computational mode

   
   
   
   


   //////////////////////////////////////////////////////////////***Finite Bit****///////////////////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////***Finite Bit****///////////////////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////***Finite Bit****///////////////////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////***Finite Bit****///////////////////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////***Finite Bit****///////////////////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////***Finite Bit****///////////////////////////////////////////////////////////////////////

   
   
   
   wire signed [14:0] 			       gain_times_N_full; //6.2 * 7 = 13.2, taked 12
   wire signed [11:0] 			       gain_times_N_original;
   wire signed [11:0] 			       gain_times_N_reduced;
   reg signed [11:0] 			       gain_times_N;     /////////for_switch_cases //////////////////////
   
   
   reg signed [11:0] 			       correction_scaling_factor;           /////////for_switch_cases //////////////////////
   
   
   
   reg signed [13:0] 			       correction_input1;           /////////for_switch_cases //////////////////////
   reg signed [13:0] 			       correction_input2;           /////////for_switch_cases //////////////////////
   wire signed [13:0] 			       correction_input;
   reg signed [13:0] 			       correction_input_old;  // actual reg
   wire signed [24:0] 			       correction_term;

   
   
   reg signed [13:0] 			       error_for_update;               /////////for_switch_cases //////////////////////

   wire signed [24:0] 			       corrected_error_for_update_full;
   // wire signed [13:0] 			       corrected_error_for_update;
   

   wire signed [24:0] 			       corrected_error_for_update2_full;
   wire signed [13:0] 			       corrected_error_for_update2;

   // reg signed [13:0] 			       update;              /////////for_switch_cases //////////////////////
   reg signed [13:0] 			       update_old; // actual reg
   
   wire signed [23:0] 			       code_change_full;
   wire signed [13:0] 			       code_change;  //take 9.5 
   reg signed [13:0] 			       code_initial; // 9.5 bit
   
   wire signed [15:0] 			       Kin3_finite_full;
   wire signed [13:0] 			       Kin3_finite;   //9.5 bit.
   
   
   reg [13:0] 				       Kin2_out_finite;   //9.4 bit
   // wire signed [12:0] 			       filter_output_computational_finite;
   

   // reg 					       phase_jolt_given;
   reg signed [13:0] 			       phase_lock_frequency_finite;
   reg signed [13:0] 			       freq_error_phase_lock_finite;

   
   
   reg [12:0] 				       filter_output_computational_sampled_finite;
   reg 					       oscillation_detected, oscillation_detected_old, oscillation_detected_old2;
   

   /////////////////////////////////////////////////////////////////////////////////////////////////
   
   wire [6:0] 				       cycle_left;
   reg [11:0] 				       cycle_left_inverse; //1.11 format.
   wire [15:0] 				       cycle_passed_added_term_full;
   wire [11:0] 				       cycle_passed_added_term; //2.9
   wire [15:0] 				       cycle_passed_added_term2_full;
   wire [11:0] 				       cycle_passed_added_term2; //3.9

   
   // wire signed [13:0] 			       period_change_finite;
   reg signed [13:0] 			       period_change_finite_old;
   // reg  signed [3:0] 			       dco_edge_delay;
  
   reg [6:0] 				       freq_counter_latched;
   

   
   
   //////////////////////////////////////////////////////////////////////////////////////////////////

   //  real      cycle_passed;   //indicates how many dco cycles have passed when I apply the new code.
   // int 	     cycle_passed_int;
   // assign cycle_passed_int = $floor(cycle_passed) ;
   

   // reg signed [10:0]  cycle_passed_added_term_actual_finite;      //2.9 format
   // reg signed [10:0]  cycle_passed_added_term2_actual_finite;    //2.9 format
   // real 	      pll_divider_real;
   // real 	      cycle_passed_int_real;

   // assign pll_divider_real = pll_divider;
   // assign cycle_passed_int_real = cycle_passed_int;
   // real 	      cycle_passed_added_term_actual;
   // assign cycle_passed_added_term_actual = cycle_passed_int_real/ (pll_divider_real - cycle_passed_int_real) * 512;
   // int 		      cycle_passed_added_term_actual_int;

   // assign cycle_passed_added_term_actual_int = $floor(cycle_passed_added_term_actual);
   
   // assign cycle_passed_added_term_actual_finite = cycle_passed_added_term_actual_int;


   // real 	      cycle_passed_added_term2_actual;
   // assign cycle_passed_added_term2_actual = pll_divider_real/ (pll_divider_real - cycle_passed_int_real) * 512;
   
   // int 		      cycle_passed_added_term2_actual_int;

   // assign cycle_passed_added_term2_actual_int = $floor(cycle_passed_added_term2_actual);
   
   // assign cycle_passed_added_term2_actual_finite = cycle_passed_added_term2_actual_int;
   //////////////////////////////////////////////////////////////////////////////////////////////////   
   
   assign cycle_left = pll_divider - cycle_passed_finite ;
   
   
   always @*  begin
      case (cycle_left)
	4 :  cycle_left_inverse = 12'b001000000000 ;
	5 :  cycle_left_inverse = 12'b000110011001 ;
	6 :  cycle_left_inverse = 12'b000101010101 ;
	7 :  cycle_left_inverse = 12'b000100100100 ;
	8 :  cycle_left_inverse = 12'b000100000000 ;
	9 :  cycle_left_inverse = 12'b000011100011 ;
	10 :  cycle_left_inverse = 12'b000011001100 ;
	11 :  cycle_left_inverse = 12'b000010111010 ;
	12 :  cycle_left_inverse = 12'b000010101010 ;
	13 :  cycle_left_inverse = 12'b000010011101 ;
	14 :  cycle_left_inverse = 12'b000010010010 ;
	15 :  cycle_left_inverse = 12'b000010001000 ;
	16 :  cycle_left_inverse = 12'b000010000000 ;
	17 :  cycle_left_inverse = 12'b000001111000 ;
	18 :  cycle_left_inverse = 12'b000001110001 ;
	19 :  cycle_left_inverse = 12'b000001101011 ;
	20 :  cycle_left_inverse = 12'b000001100110 ;
	21 :  cycle_left_inverse = 12'b000001100001 ;
	22 :  cycle_left_inverse = 12'b000001011101 ;
	23 :  cycle_left_inverse = 12'b000001011001 ;
	24 :  cycle_left_inverse = 12'b000001010101 ;
	25 :  cycle_left_inverse = 12'b000001010001 ;
	26 :  cycle_left_inverse = 12'b000001001110 ;
	27 :  cycle_left_inverse = 12'b000001001011 ;
	28 :  cycle_left_inverse = 12'b000001001001 ;
	29 :  cycle_left_inverse = 12'b000001000110 ;
	30 :  cycle_left_inverse = 12'b000001000100 ;
	31 :  cycle_left_inverse = 12'b000001000010 ;
	32 :  cycle_left_inverse = 12'b000001000000 ;
	33 :  cycle_left_inverse = 12'b000000111110 ;
	34 :  cycle_left_inverse = 12'b000000111100 ;
	35 :  cycle_left_inverse = 12'b000000111010 ;
	36 :  cycle_left_inverse = 12'b000000111000 ;
	37 :  cycle_left_inverse = 12'b000000110111 ;
	38 :  cycle_left_inverse = 12'b000000110101 ;
	39 :  cycle_left_inverse = 12'b000000110100 ;
	40 :  cycle_left_inverse = 12'b000000110011 ;
	41 :  cycle_left_inverse = 12'b000000110001 ;
	42 :  cycle_left_inverse = 12'b000000110000 ;
	43 :  cycle_left_inverse = 12'b000000101111 ;
	44 :  cycle_left_inverse = 12'b000000101110 ;
	45 :  cycle_left_inverse = 12'b000000101101 ;
	default :  cycle_left_inverse = 12'bxxxxxxxxxxxx ;
      endcase // case (cycle_left)
   end // always @ *
   
   
   assign cycle_passed_added_term_full = cycle_left_inverse * cycle_passed_finite; //7.0 * 1.11 = 8.11 take 5.11
   
   
   assign cycle_passed_added_term = {cycle_passed_added_term_full[13:2]};

   assign cycle_passed_added_term2_full = cycle_left_inverse * pll_divider; //7.0 * 1.13 = 8.13 take 5.13
   
   assign cycle_passed_added_term2 = {cycle_passed_added_term2_full[13:2]}; //2.11
   


   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   //tdc_output_finite = 0 to 2048 ps. 2^14 = 16384. So we assume there is a decimal point 2^14 bit right of tdc_output_finite;

   
   
   
   

   

   

   
   
   assign period_change_finite  = count_finite - count_finite_old;

   
   
   //  10.257 * .8192 = 8.4025 = 001000.01//6.2
   
   //assign gain_finite = 8'b00011111 ;
   //9.703 * .8192 = 7.9486 = 000111.11

   
   
   assign gain_times_N_full = gain_finite * pll_divider;
   
   
   
   assign gain_times_N_original = gain_times_N_full[13:2] ;
   assign gain_times_N_reduced = {1'b0,gain_times_N_full[13:3]} ;

   assign correction_input = correction_input1 - correction_input2;
   
   // assign correction_term = $signed(correction_input) * $signed(correction_scaling_factor); // 14 * 2.9 =16.9 
   // assign corrected_error_for_update_full = $signed({error_for_update}) + $signed(correction_term[22:9]); // 12.0 + 12.0 = 12.0 
   // assign corrected_error_for_update= corrected_error_for_update_full[13:0];
   
   assign corrected_error_for_update_full = $signed({error_for_update,9'b0}) +  (  { {11{correction_input[13]}} ,correction_input } * {13'b0,correction_scaling_factor})  ; 
   assign corrected_error_for_update= corrected_error_for_update_full[22:9];

   
   
   
   
   assign code_change_full = update * gain_times_N; // = 10.11 format . take 9.5
   
   assign code_change = code_change_full[22:9];
   assign Kin3_finite_full = $signed(code_change) + {3'b0, code_initial} ;

   assign Kin3_finite = Kin3_finite_full[15] ? 0 : (  (Kin3_finite_full[13:5] > 300 ) ? {9'd300,5'd0} : Kin3_finite_full[13:0] );
   
   
   // assign Kin3_finite_full = ((update * gain_times_N) >>> 9) + code_initial; //12.0 * 12 + 1|14|9
   
   // assign Kin3_finite2 = ( Kin3_finite_full[23] ? 0 :  ( (Kin3_finite_full[13:0] > 13'd4800)  ? 13'd4800 :  Kin3_finite_full[13:0])   );
   
   
   always @*  begin
      case (retimed_edge_select) 
	0: dco_edge_delay = 3;
	1: dco_edge_delay = 4;
	2: dco_edge_delay = 5;
	3: dco_edge_delay = 6;
	4: dco_edge_delay = 7;
	5: dco_edge_delay = 8;
	6: dco_edge_delay = 9;
	7: dco_edge_delay = 10;
	default : dco_edge_delay = 10;
	
      endcase
      
   end // always @ *
   
   
   always @(posedge ref_clk)  begin
      reset1 <= reset;
      reset2 <= reset1;
      reset3 <= reset2;
      
   end
   

   
   
   assign count_finite =  early ? {1'b0,tdc_output_reg_finite} : -{1'b0,tdc_output_reg_finite};
   
   assign fine_done_with_reset = fine_done | ~reset3;
   
   always @(posedge fine_done_with_reset )  begin
      if ((reset2 == 0)
	  ) begin
	 status <= cold_start_traditional ? phase_locked : start;
	 // cycle_passed <= 0;
	 cycle_at_fine_done <= 0;
	 cycle_at_fine_done_old <= 0;
	 
	 oscillation_detected_old <= 0;
	 oscillation_detected_old2 <= 0;
	 
	 period_change_finite_old <= 0;
	 tdc_output_reg_finite <= 0;
	 
	 count_finite_old <= 0;
	 Kin2_out_finite <= Kin2_out_finite_resetval; //000011000.0000

	 phase_lock_frequency_finite <= 0;   //storing the ouput that gave frequency lock
	 freq_locked_code <= 0;
	 freq_error_phase_lock_finite <= 0; 
	 
      end 
      else begin
	 
	 status <= (calibration_mode == 1) ? start :  (cold_start_traditional ? phase_locked : next_status);
	 
	 count_finite_old <= count_finite;
	 update_old<= update;
	 oscillation_detected_old <= oscillation_detected;
	 oscillation_detected_old2 <= oscillation_detected_old;

	 Kin2_out_finite <= $unsigned(Kin3_finite);
	 // cycle_passed <= freq_counter_pre + dco_edge_delay; 
	 cycle_at_fine_done <= freq_counter_latched;
	 cycle_at_fine_done_old <= cycle_at_fine_done;
	 tdc_output_reg_finite <= tdc_output_finite;
	 
	 period_change_finite_old <= period_change_finite;

	 if (next_status == resnap) begin //frequency lock achieved, store the frequency settings
	    phase_lock_frequency_finite <= Kin2_out_finite;   //storing the ouput that gave frequency lock
	    freq_locked_code <= Kin2_out_finite[13:1];
	    freq_error_phase_lock_finite <= period_change_finite; //storing the error at that time
	 end 
	 else begin
	    phase_lock_frequency_finite <= phase_lock_frequency_finite ;         //storing the ouput that gave frequency lock
	    freq_error_phase_lock_finite <= freq_error_phase_lock_finite ;//
	    freq_locked_code <= freq_locked_code;
	    
	 end
	 
	 
      end 
   end // always @ (posedge fine_done_with_reset )
   


   
   

   
   assign cycle_passed_finite = cycle_at_fine_done_old + dco_edge_delay;
   ///////////////////////////////////////switch cade for finite bit///////////////////////////////////////////////////

   always @*  begin
      
      if (reset2 == 0 ) begin
	 code_initial = Kin1_poly_finite;
	 gain_times_N = 0;
	 correction_input1 = 0;
	 correction_input2 = 0;
	 correction_scaling_factor = 0;
	 error_for_update = 0;
	 update = 0;
	 oscillation_detected = 0;
	 next_status = start;
      end
      
      else begin
	 case (status)	
           start: begin 	     
	      code_initial = Kin1_poly_finite;
	      gain_times_N = 0;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      update = 0;
	      oscillation_detected = 0;
	      next_status = wait_init0;
	      
	   end
	   wait_init0: begin
	      code_initial = Kin1_poly_finite;
	      gain_times_N = 0;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      update = 0;
	      oscillation_detected = 0;
	      next_status = resnap_initial; 
	   end

	   resnap_initial: begin
	      code_initial = Kin1_poly_finite;
	      gain_times_N = 0;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      update = 0;
	      oscillation_detected = 0;
	      
	      if (resnap_happened == 1) begin
		 next_status = wait_after_resnap;
	      end 
              else next_status = resnap_initial_again;
	      
	   end


	   resnap_initial_again: begin
     	      code_initial = Kin1_poly_finite;
	      gain_times_N = 0;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      update = 0;
	      oscillation_detected = 0;
	      next_status =wait_after_resnap;
	   end
	   
	   wait_after_resnap: begin     
	      code_initial = Kin1_poly_finite;
	      gain_times_N = 0;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      update = 0;
	      oscillation_detected = 0;
	      
	      next_status = wait_init2; 
	      
	   end

	   
	   
	   wait_init1: begin
	      code_initial = Kin1_poly_finite;
	      gain_times_N = 0;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      update = 0;
	      oscillation_detected = 0;
	      next_status = wait_init2;
	   end

	   wait_init2: begin
	      code_initial = Kin1_poly_finite;
	      gain_times_N = 0;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      update = 0;
	      oscillation_detected = 0;
	      next_status = measure_update_freq_first;
	      
	   end

	   measure_update_freq_first: begin
	      code_initial = Kin2_out_finite;
	      gain_times_N = gain_times_N_original;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = cycle_passed_added_term;
	      error_for_update = period_change_finite;
	      oscillation_detected = 0;
	      
	      if ($signed(count_finite) >= $signed(count_high_limit)) begin
		 next_status = resnap_wrong_estimation;
		 update = force_increment;
		 
		 
		 
	      end
	      else if ($signed(count_finite) <= $signed(count_low_limit)) begin
		 next_status = resnap_wrong_estimation;
		 update = force_decrement; 
		 
	      end
	      
	      
	      else begin
		 if (corrected_error_for_update >= $signed(negative_freq_tolerance_finite) & corrected_error_for_update <= $signed(positive_freq_tolerance_finite)) begin
		    next_status = check_effect1;
		    update = 0;
		    
		 end
		 else begin
		    next_status = measure_update_freq_second;
		    update =  corrected_error_for_update;
		    
		 end
	      end // else: !if(count <= -0.2)
	      
	   end // case: measure_update_freq_first
	   
	   resnap_wrong_estimation: begin
	      code_initial = Kin2_out_finite;	      
	      gain_times_N = 0;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      update = 0;
	      oscillation_detected = 0;
	      if (resnap_happened == 1) begin
   		 next_status = wait_after_resnap_wrong_estimation;
   	      end 
              else next_status = resnap_wrong_estimation_again;
	      
	      
	   end


	   resnap_wrong_estimation_again: begin
	      
	      code_initial = Kin2_out_finite;	
	      gain_times_N = 0;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      update = 0;
	      oscillation_detected = 0;
	      next_status =wait_after_resnap_wrong_estimation;

	      
	   end
	   
	   wait_after_resnap_wrong_estimation: begin     
	      
	      code_initial = Kin2_out_finite;
	      gain_times_N = 0;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      update = 0;
	      oscillation_detected = 0;
	      next_status = wait_wrong_estimation2;
	      
	   end

	   wait_wrong_estimation1: begin
	      
	      
	      code_initial = Kin2_out_finite ;
	      gain_times_N = 0;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      update = 0;
	      oscillation_detected = 0;
	      next_status = wait_wrong_estimation2;
	   end

	   wait_wrong_estimation2: begin
	      
	      code_initial = Kin2_out_finite;
	      gain_times_N = 0;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      update = 0;
	      oscillation_detected = 0;
	      next_status = measure_update_freq_first;   
	      
	   end
	   

	   measure_update_freq_second: begin
	      code_initial = Kin2_out_finite;
	      correction_input1 = period_change_finite;
	      correction_input2 = update_old;
	      correction_scaling_factor = cycle_passed_added_term;
	      error_for_update = period_change_finite;
	      gain_times_N = gain_times_N_original;
	      oscillation_detected = 0;
	      
	      if (count_finite >= $signed(count_high_limit)) begin
		 next_status = resnap_wrong_estimation;
		 update = 0;
	      end
	      
	      else if (count_finite <= $signed(count_low_limit)) begin
		 next_status = resnap_wrong_estimation;
		 update = 0; 
	      end 
              else if (cycle_passed_finite >= pll_divider - 2) begin
		 next_status = resnap_wrong_estimation;
		 update = 0;
		 
              end 
	      
	      else begin
		 if (corrected_error_for_update >= $signed(negative_freq_tolerance_finite) & corrected_error_for_update <= $signed(positive_freq_tolerance_finite) ) begin
		    next_status = check_effect1;
		    update = 0;
		 end

		 else begin
		    next_status = measure_update_freq;
		    update =  corrected_error_for_update;
		 end

	      end // else: !if(count_finite <= $signed(count_low_limit))
	      
	   end // case: measure_update_freq_second
	   
	   
	   measure_update_freq: begin
	      code_initial = Kin2_out_finite;
	      correction_input1 = period_change_finite;
	      correction_input2 = update_old;
	      correction_scaling_factor = cycle_passed_added_term;
	      error_for_update = period_change_finite;
	      
	      if ($signed(count_finite) >= $signed(count_high_limit)) begin
		 next_status = resnap_wrong_estimation;
		 update = 0;
		 gain_times_N = gain_times_N_original;
		 oscillation_detected = 0;
		 
	      end
	      else if ($signed(count_finite) <= $signed(count_low_limit)) begin
		 next_status = resnap_wrong_estimation;
		 update = 0; 
		 gain_times_N = gain_times_N_original;
		 oscillation_detected = 0;
		 
	      end
	      else if (cycle_passed_finite >= pll_divider - 2) begin
		 next_status = resnap_wrong_estimation;
		 update = 0;
		 gain_times_N = 0;
		 oscillation_detected = 0;
		 
              end
	      
	      else if (cycle_passed_added_term[11] | &cycle_passed_added_term[10:9]  ) begin
		 next_status = resnap_wrong_estimation;
		 update = 0;
		 gain_times_N = gain_times_N_original;
		 oscillation_detected = 0;
	      end
	      
	      else begin
		 if (corrected_error_for_update >= $signed(negative_freq_tolerance_finite) & corrected_error_for_update <= $signed(positive_freq_tolerance_finite)) begin
		    next_status = check_effect1;
		    update = 0;
		    gain_times_N = gain_times_N_original;
		    oscillation_detected = 0;
		 end
		 else begin
		    
		    update = (oscillation_detected & oscillation_detected_old ) ? 0 : ( ( corrected_error_for_update[13] ^ update_old[13] ) ? (corrected_error_for_update >>> 1) : corrected_error_for_update ) ;
		    gain_times_N = gain_times_N_original;
		    oscillation_detected = ( corrected_error_for_update[13] ^ update_old[13] ) ?  1 : 0;
		    next_status = (oscillation_detected & oscillation_detected_old ) ? check_effect1 : measure_update_freq;
		 end
	      end // else: !if(count_finite <= $signed(count_low_limit))
	      
	      
	   end // case: measure_update_freq
	   
	   
	   

	   check_effect1: begin
	      
	      code_initial = Kin2_out_finite;
	      
	      update = 0;
	      oscillation_detected = 0;
	      gain_times_N = gain_times_N_original;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = cycle_passed_added_term;
	      error_for_update = period_change_finite;
	      
	      if (corrected_error_for_update  >= $signed(negative_freq_tolerance_finite2)  & corrected_error_for_update <= $signed(positive_freq_tolerance_finite2) ) begin
		 next_status = resnap;
		 
	      end
              else begin 
		 next_status = measure_update_freq_first;
		 
	      end
	   end
	   
	   
	   
	   resnap: begin
	      code_initial = Kin2_out_finite;   
	      gain_times_N = 0;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      update = 0 ;
	      oscillation_detected = 0;
	      if (resnap_happened == 1) begin
		 next_status = phase_wait1;
	      end 
              else next_status = resnap_again;
	      
	   end
	   

	   resnap_again: begin
	      code_initial = phase_lock_frequency_finite;   
	      gain_times_N = gain_times_N_original;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      update = 0;
	      oscillation_detected = 0;
	      next_status = phase_wait1;
	      
	   end

	   
	   phase_wait1: begin
	      
	      code_initial = phase_lock_frequency_finite;  
	      gain_times_N = gain_times_N_original;
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      update = 0;
	      oscillation_detected = 0;
              next_status = measure_update_phase;
	   end


	   measure_update_phase: begin
	      
	      code_initial = phase_lock_frequency_finite;
	      gain_times_N = gain_times_N_original;
	      error_for_update = 0;
	      oscillation_detected = 0;
	      if (count_finite> $signed(negative_phase_tolerance_finite) & (count_finite < $signed(positive_phase_tolerance_finite) )  ) begin
		 correction_input1 = 0;
		 correction_input2 = 0;
		 correction_scaling_factor = 0;
		 update = freq_error_phase_lock_finite;
		 next_status = phase_locked1;
	      end
	      
              else begin
		 correction_input1 = count_finite;
		 correction_input2 = 0;
		 correction_scaling_factor = cycle_passed_added_term2;
		 update =  corrected_error_for_update ;
		 next_status = measure_update_phase1;
	      end
	      
	   end // case: measure_update_phase
	   

	   measure_update_phase1: begin
	      code_initial = phase_lock_frequency_finite;
	      error_for_update = 0;
	      oscillation_detected = 0;
	      if ( count_finite> $signed(negative_phase_tolerance_finite) & (count_finite < $signed(positive_phase_tolerance_finite) )  ) begin
		 
		 correction_input1 = 0;
		 correction_input2 = 0;
		 correction_scaling_factor = 0;
		 gain_times_N = gain_times_N_original;
		 update = freq_error_phase_lock_finite;
		 next_status = phase_locked1;
		 
	      end
	      
              else begin
		 next_status = measure_update_phase1;
		 correction_input1 = count_finite;
		 correction_input2 = 0;
		 correction_scaling_factor = cycle_passed_added_term2;
		 update =  ( (count_finite[13] ^ count_finite_old[13]) ? corrected_error_for_update >>> 1 :  corrected_error_for_update) ;
		 
		 gain_times_N =  gain_times_N_original; 
	      end	      
	   end // case: measure_update_phase
	   
	   
	   
 	   
	   phase_locked1: begin
	      code_initial = phase_lock_frequency_finite;
	      next_status = phase_locked ;  
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      gain_times_N = gain_times_N_original;
	      update = freq_error_phase_lock_finite;
	      oscillation_detected = 0;
	   end

	   
	   phase_locked: begin
	      code_initial = phase_lock_frequency_finite;
	      next_status = computational_start ? wait_init1 : phase_locked ;  
	      correction_input1 = 0;
	      correction_input2 = 0;
	      correction_scaling_factor = 0;
	      error_for_update = 0;
	      gain_times_N = gain_times_N_original;
	      update = freq_error_phase_lock_finite;
	      oscillation_detected = 0;
           end

	   default: begin
	      code_initial = 14'hxxx;
	      next_status = 6'hxx ;  
	      correction_input1 = 14'hxxx;
	      correction_input2 = 14'hxxx;
	      correction_scaling_factor = 12'hxxx;
	      error_for_update = 14'hxxx;
	      gain_times_N = 12'hxxx ;
	      update = 14'hxxx;
	      oscillation_detected = 1'bx;
	   end


	 endcase // case (status)
	 
      end // else: !if(reset2 == 0 )
      
      

   end // always @ *
   

   /////////////////////////////////////
   always @*  begin
      
      if (~dco_clk) begin
	 
   	 vout_pre_logic <= (freq_counter_pre == pll_divider2 -2) & (status == 4 | status == 5 | status == wait_after_resnap | status == phase_wait1 | status == measure_update_phase | status == measure_update_phase1 | status ==  phase_locked1);  
   	 //clock pre logic for clock gating. during phase-acquisition the changing edge should be the 0th dco clock rising edge.
	 
   	 retimed_tdc_pre <= computational_fine_done_retimed_pre & (status != wait_after_resnap & status != phase_wait1 &  status !=  phase_locked1 & status != 4);
   	 //clock pre logic for clock gating. during all other cases the changing edge should be the retimed fine_done
   	 freq_counter_latched <= freq_counter_pre;
	 
      end
      
      else begin
   	 vout_pre_logic <= vout_pre_logic;
   	 retimed_tdc_pre <= retimed_tdc_pre;
   	 freq_counter_latched <= freq_counter_latched;	 
	 
      end // else: !if(~dco_clk)
      
   end // always @ *
   
   

   
   
   
   assign dco_change_edge =  ((vout_pre_logic | retimed_tdc_pre ) & (dco_clk)) | ~reset2 ;
   


   always @(posedge phase_jolt_change_edge)  begin
      phase_jolt_given <= reset2 ? (  ((status == measure_update_phase | status == measure_update_phase1) & phase_jolt_given == 0) ? 1: 0 ) : 0;
    
   end
   
     
   
   //////////////////////////////////////////////////////////////////////////////////////////////////   
   
   always @(posedge dco_change_edge )  begin
      
      filter_output_computational_sampled_finite <= reset2 ? (Kin3_finite[13:1]  ): Kin1_poly_finite[13:1];
   
      
   end // always @ (posedge dco_change_edge or negedge reset2)

   wire [12:0] filter_output_computational_cont_finite;
   
   
   assign filter_output_computational_cont_finite = reset2 ? (Kin3_finite[13:1]  ): Kin1_poly_finite[13:1];
   
   assign filter_output_computational_finite =  (status == measure_update_phase | status == measure_update_phase1 )   ? ( phase_jolt_given == 0 ? freq_locked_code : filter_output_computational_cont_finite) : filter_output_computational_cont_finite   ;

   
   //////////////////////////////////////////////////////////////////*******Comparing finite_bit_conversion***********/////////////////////////////////
   //////////////////////////////////////////////////////////////////*******Comparing finite_bit_conversion***********/////////////////////////////////
   //////////////////////////////////////////////////////////////////*******Comparing finite_bit_conversion***********/////////////////////////////////
   //////////////////////////////////////////////////////////////////*******Comparing finite_bit_conversion***********/////////////////////////////////
   //////////////////////////////////////////////////////////////////*******Comparing finite_bit_conversion***********/////////////////////////////////

   
   
endmodule // computational

