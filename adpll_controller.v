
module adpll_controller
  (
   input 		     ref_clk,
   input 		     reset,
   input 		     calibration_mode,

   input 		     delay_gen1,
   input 		     delay_gen2,
   input 		     tdc_ro1,
   input 		     tdc_ro2,
  
   input 		     clk_count_start,
   input [14:0] 	     count_untill,
   output reg [14:0] 	     delay_gen_counter,
   output reg [14:0] 	     ref_dco_counter,
   output reg [14:0] 	     ref_tdc_counter,
  
  
  
   input 		     cold_start_traditional,

   input [12:0] 	     dco_input_external, 
   ////////////////////////////////////////////////
   input 		     continue_traditional,
   
   output reg 		     new_div_ratio_given,
   input [6:0] 		     pll_divider_input,
  
   output reg [6:0] 	     pll_divider, 
   output reg [6:0] 	     pll_divider2,
   /////////////////////////////////////////////// 
   input [2:0] 		     computational_retimed_edge_select,
     
   input [13:0] 	     Kin1_poly_finite ,
   input [13:0] 	     Kin2_out_finite_resetval,
   input [13:0] 	     negative_phase_tolerance_finite,
   input [13:0] 	     positive_phase_tolerance_finite,
   input [13:0] 	     negative_freq_tolerance_finite,
   input [13:0] 	     positive_freq_tolerance_finite,
   input [13:0] 	     negative_freq_tolerance_finite2,
   input [13:0] 	     positive_freq_tolerance_finite2,
   input [7:0] 		     gain_finite,
   input signed [13:0] 	     count_high_limit,
   input signed [13:0] 	     count_low_limit,
   input [13:0] 	     force_increment,
   input [13:0] 	     force_decrement,

   input [1:0] 		     traditional_retimed_edge_select, 
   input [8:0] 		     p_finite,
   input [8:0] 		     p_i_finite,
   input [9:0] 		     p_i_inverse_finite,
   input [15:0] 	     count_aggr_initial_finite,
   input [17:0] 	     count_aggr_saturate_value,
   input wire signed [12:0]  filter_output_traditional_initial_finite,
   output reg 		     lowbw1,
   input 		     dco_clk,

   input [1:0] 		     tdc_block_select,
  
   input 		     fine_done_pre1,
   input 		     fine_done_pre2,
   input 		     fine_done_pre3,

   input 		     early1,
   input 		     early2,
   input 		     early3,
  
   input [4:0] 		     rise_count1,
   input [4:0] 		     rise_count2,
   input [4:0] 		     fall_count1,
   input [4:0] 		     fall_count2,
  
  
   input [7:0] 		     bs_out,
   input [8:0] 		     vernier_out,
   input [7:0] 		     trip_b,
   input [7:0] 		     cross_pin,

   input [8:0] 		     coarse_res_finite,
   input [6:0] 		     medium_res_finite,
   input [5:0] 		     fine_res_finite,

   input [3:0] 		     fine_count_bbpll,
  
  
   output 		     early,
   output 		     fine_done_pre,
  
   output [12:0] 	     filter_output_finite,
   output wire [5:0] 	     status,
   output wire 		     gated_dco_clk,
  
   output [13:0] 	     period_change_finite,
   output wire signed [13:0] corrected_freq_error, 
  

   //////////////////////////////////////////////////////////////
   
   output wire 		     enable_choice1,
   output wire 		     enable_choice2,
   output wire 		     enable_choice3,
   output wire 		     tdc_ro,
  
   output reg 		     reset2,
   output reg 		     reset_bar2,
  
   
   ///////////////////////////////////////////////////////////////

  
  
   
   output [6:0] 	     cycle_passed_finite,
  
  
  
   output wire [17:0] 	     rows1,
   output wire [17:0] 	     rows2,
   output wire [17:0] 	     rows1_b,
   output wire [17:0] 	     rows2_b,
   output wire [29:0] 	     fine,
   output wire [29:0] 	     fine_b,
  
  

   output [12:0] 	     tdc_output_flopped,
   output [19:0] 	     count_aggr
   );
   //////////////////////////////////////////////////////////////////////////////////////////////////////////

 
   wire [5:0] 	     next_status;
   
   wire 		     dco_change_edge;
   wire 		     fine_done_with_reset;
   reg 			     logic1;
   reg 			     logic2;
   reg 			     logic3;
   
   reg 			     computational_start;
   
   wire [13:0] 		     count_finite;
   
   
   reg signed [13:0] 	     update;
   
   wire [12:0] 		     tdc_output_finite;
   wire [4:0] 		     dsm_output;
   
   
   wire 		     fine_done;
   wire 		     retimed_tdc_pre;
   
   
   reg [6:0] 		     freq_counter_pre;
   
   wire 		     lowbw, lowbw_pre;
   reg 			     lowbw0;

   wire 		     pre_zero;
   reg 			     ref_clk_pulse1;
   wire 		     ref_clk_pulse2;
   reg 			     pre_zero_gated;
   
   
   wire [12:0] 		     filter_output_traditional_finite;
   wire [12:0] 		     filter_output_computational_finite;
   // wire [12:0] 		     filter_output_finite;

   reg 			     fine_done_pre_logic0, fine_done_pre_logic0_1,fine_done_pre_logic1, fine_done_pre_logic2, fine_done_pre_logic3, fine_done_pre_logic4,fine_done_pre_logic5,fine_done_pre_logic6,fine_done_pre_logic7,fine_done_pre_logic8 , fine_done_pre_logic9, fine_done_pre_logic10,fine_done_pre_logic11, fine_done_pre_logic12 ;
   
   reg 			     computational_fine_done_retimed_pre;
   
   
   reg 			     traditional_fine_done_retimed_pre;
   wire 		     traditional_fine_done_retimed;
   
   
   reg 			     resnap_happened;

   reg 			     dco_clk_pre_logic;
   wire 		     pre_dco_start;
   
   wire 		     ref_clk_pulse;
   


   /////////////////////////////////////////controller_part: imported from pll_connected.v ////////////////////////////
   wire 		     reset_bar;
   reg 			     reset1, reset_bar1;
   
   assign reset_bar = ~reset;

   assign enable_choice1 = reset_bar2 ? 0 : (tdc_block_select == 2'b00 ) ? 1:0 ;
   assign enable_choice2 = reset_bar2 ? 0 :(tdc_block_select == 2'b01) ? 1:0 ;
   assign enable_choice3 = reset_bar2 ? 0 : (tdc_block_select == 2'b10) ? 1:0 ;

   
   
   
   assign tdc_ro =   (tdc_block_select == 2'b00) ? tdc_ro1 :tdc_ro2;
   
   always @(posedge ref_clk)  begin
      
      reset_bar1 <= reset_bar;
      reset_bar2 <= reset_bar1;
      
   end

  

   
   reg [6:0]  pll_divider_input_flopped;
   
   
   always @(posedge ref_clk)  begin
      pll_divider_input_flopped <= pll_divider_input;
      pll_divider <= pll_divider_input_flopped;
      pll_divider2 <= pll_divider;

      computational_start <= (pll_divider == pll_divider_input_flopped & pll_divider2 == pll_divider_input_flopped) ? 0 : ( (continue_traditional) ? 0: 1);
      new_div_ratio_given <= (pll_divider == pll_divider_input_flopped & pll_divider2 == pll_divider_input_flopped) ? 0 : 1;
      
   end
   
   

   ////////////////////////////////////tdc_decoder/////////////////////////////////////////

   wire [4:0] 		     rise_count;
   wire [4:0] 		     fall_count;
   assign fine_done_pre =  (tdc_block_select == 2'b00) ? fine_done_pre1 : (tdc_block_select == 2'b01 ) ? fine_done_pre2 : fine_done_pre3;
   assign early =(tdc_block_select == 2'b00) ? early1 : (tdc_block_select == 2'b01 ) ? early2 : early3  ;
   assign rise_count = (tdc_block_select == 2'b00) ? rise_count1 : (tdc_block_select == 2'b01 ) ? rise_count2 : rise_count2  ;
   assign fall_count = (tdc_block_select == 2'b00) ? fall_count1 : (tdc_block_select == 2'b01 ) ? fall_count2 : fall_count2  ;

   reg [5:0] 		     coarse_count_finite;  //4.1
   reg [3:0] 		     medium_count_finite;  //3.1
   reg [3:0] 		     fine_count_finite;    //4.0
   wire [12:0] 		     freq_locked_code;
   
   

   
   always @*  begin
      
      case (tdc_block_select[1:0]) 
	
	2'b00 : begin 
	   case (bs_out[7:0]) 
	     8'b00000001: begin
		coarse_count_finite = 0;
		medium_count_finite = 0;
		
	     end
	     8'b00000010: begin
		coarse_count_finite =  {fall_count,1'b1}  ;
		medium_count_finite = 4'b0001;
		
	     end
	     8'b00000100: begin
		coarse_count_finite = {fall_count,1'b0};
		medium_count_finite = 4'b0010;
	     end
	     8'b00001000: begin
		coarse_count_finite = {rise_count,1'b1}  ;
		medium_count_finite = 4'b0011;
	     end
	     8'b00010000: begin
		coarse_count_finite =  {fall_count,1'b0} ;
		medium_count_finite = 4'b0100;
	     end
	     8'b00100000: begin
		coarse_count_finite = {rise_count,1'b1} ;
		medium_count_finite = 4'b0101;
	     end
	     8'b01000000: begin
		coarse_count_finite = {fall_count,1'b0};
		medium_count_finite =  4'b0110;
	     end
	     8'b10000000: begin
		coarse_count_finite =  {rise_count,1'b1};
		medium_count_finite = 4'b0111;
	     end
	     default: begin
		coarse_count_finite =  {rise_count,1'b1};
		medium_count_finite = 4'b0111;
	     end
	     
	   endcase // case (bs_out[7:0])


	   casez (vernier_out[8:0]) 
	     9'b????????1: 	   fine_count_finite = 4'b0000;
	     9'b???????10: 	   fine_count_finite = 4'b0001;
	     9'b??????100: 	   fine_count_finite = 4'b0010;
	     9'b?????1000: 	   fine_count_finite = 4'b0011;
	     9'b????10000: 	   fine_count_finite = 4'b0100;
	     9'b???100000: 	   fine_count_finite = 4'b0101;
	     9'b??1000000: 	   fine_count_finite = 4'b0110;
	     9'b?10000000: 	   fine_count_finite = 4'b0111;
	     9'b100000000: 	   fine_count_finite = 4'b1000;
	     default:              fine_count_finite = 4'b1xxx;
	     
	   endcase // case (vernier_out[8:0])
	   
	end // case: 2'b00
	
	
	
	
        2'b01 : begin
	   
	   casex (trip_b[7:0]) 
	     8'b11111110: begin
		coarse_count_finite = 0;
		medium_count_finite = 0;
		
	     end
	     8'b1111110x: begin
		coarse_count_finite =  cross_pin[1] ? {rise_count,1'b1} : { fall_count,1'b0} ;
		medium_count_finite = 4'b0001;
		
	     end
	     8'b111110xx: begin
		coarse_count_finite =  cross_pin[2] ?  { fall_count,1'b0}: {rise_count,1'b1}   ;
		medium_count_finite = 4'b0010;
	     end
	     8'b11110xxx: begin
		coarse_count_finite =  cross_pin[3] ?  {rise_count,1'b1} : { fall_count,1'b0}  ;
		medium_count_finite = 4'b0011;
	     end
	     8'b1110xxxx: begin
		coarse_count_finite =  cross_pin[4] ?   { fall_count,1'b0} : {rise_count,1'b1};
		medium_count_finite = 4'b0100;
	     end
	     8'b110xxxxx: begin
		coarse_count_finite =  cross_pin[5] ?   {rise_count,1'b1} : { fall_count,1'b0} ;
		medium_count_finite = 4'b0101;
	     end
	     8'b10xxxxxx: begin
		coarse_count_finite =  cross_pin[6] ? { fall_count,1'b0} : {rise_count,1'b1} ;
		
		medium_count_finite =  4'b0110;
	     end
	     8'b0xxxxxxx: begin
		if (rise_count == 0 & fall_count == 0 & cross_pin[7] == 1) begin
		   coarse_count_finite = 0;
		   
		end
		else    coarse_count_finite =  (cross_pin[7] ?  {fall_count, 1'b0} : {rise_count,1'b1}) ;
		medium_count_finite = 4'b0000;
		

		



	     end // case: 8'b0xxxxxxx
	     
	     
	     default: begin 
	        coarse_count_finite = 0;
		medium_count_finite = 4'b0000;
	     end
	     
	   endcase // casex (trip_b[7:0])
           fine_count_finite = 4'b0010;
	   
	end // case: 2'b01



	
        default: begin
	   coarse_count_finite = 6'b0;
	   medium_count_finite = 0;
	   fine_count_finite = fine_count_bbpll;
	   
	end // case: default
	
	
	
      endcase // case (tdc_block_select)
      
      
   end // always @ *
   
   
   wire [14:0] coarse_ps_finite;
   assign coarse_ps_finite = coarse_res_finite * coarse_count_finite; //9.0 * 4.1 = 13.1

   wire [13:0] medium_ps_finite;
   assign {medium_ps_finite}  = medium_res_finite * medium_count_finite;  // 6.1 * 3.1 = 9.2

   wire [13:0] fine_ps_finite;
   assign {fine_ps_finite}  = fine_res_finite * fine_count_finite; // 4.2 * 4 = 8.2

   wire [15:0] tdc_all_finite;
   wire [15:0] tdc_all_finite2;
   assign tdc_all_finite2 = {2'b00,coarse_ps_finite[14:1]} + {4'b00,medium_ps_finite[13:2]} + {4'b00,fine_ps_finite[13:2]};

   
   
   assign tdc_all_finite = ( (coarse_res_finite * coarse_count_finite) >> 1) + (( medium_res_finite * medium_count_finite) >> 2) + ((fine_res_finite * fine_count_finite) >> 2);
   
   assign tdc_output_finite[12:0] = (|tdc_all_finite[15:13]) ? 13'b1111111111111 : tdc_all_finite[12:0];
   
   

   ////////////////////////////////////////////////tdc_decoder_finished//////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   
   
   reg 	       ref_clk1, ref_clk2,ref_clk3, ref_clk4,ref_clk5,ref_clk6,ref_clk7,ref_clk8_bar;



   

   always @(posedge dco_clk)   begin
      ref_clk1 <= ref_clk;
      ref_clk2 <= ref_clk1;
      ref_clk3 <= ref_clk2;
      ref_clk4 <= ref_clk3;
      ref_clk5 <= ref_clk4;
      ref_clk6 <= ref_clk5;
      ref_clk7 <= ref_clk6;
      ref_clk8_bar <= ~ref_clk7;
      
      
   end
   assign ref_clk_pulse  = ref_clk8_bar & ref_clk7 ;

   ////////////////////////////////////////////////////////////////////////////////////////////////////// 
   
   assign filter_output_finite  = (calibration_mode == 1) ? dco_input_external : ( (lowbw1 | cold_start_traditional) ? filter_output_traditional_finite : filter_output_computational_finite ) ;

   reg 			     reset3;
   
   
   
   always @(*)  begin
      if (~dco_clk) begin
	 ref_clk_pulse1 = ref_clk_pulse;
	 
      end 
      else ref_clk_pulse1 = ref_clk_pulse1;
      
   end


   assign ref_clk_pulse2 = ref_clk_pulse1 & dco_clk;
   
   
   //////////////////////////////////////////////////


   always @(posedge ref_clk)  begin
      reset1 <= reset;
      reset2 <= reset1;
      reset3 <= reset2;
      
   end
   
   always @(posedge dco_clk or negedge reset2)  begin
      if (reset2== 0) begin
	 freq_counter_pre <= 0;
	 
      end
      else begin
	 if ( (status ==1 | status == 2 | status == 9 | status == 10 | status == 17 | status == 18) & resnap_happened == 0) begin
	    if ( ref_clk_pulse1 == 1 & freq_counter_pre != 8) begin
	       freq_counter_pre <=  8 ;
               
	       
	       
	    end 
	    else begin
	       freq_counter_pre <= (freq_counter_pre >= pll_divider2 -1 ) ? 0 : (freq_counter_pre + 1) ;
	       
	    end
	 end
         else begin
	    freq_counter_pre <= (freq_counter_pre >= pll_divider2 -1 ) ?  0 : (freq_counter_pre + 1) ;
	 end
      end
   end // always @ (posedge dco_clk or negedge reset2)
   
   
   
   
   
   always @(posedge (ref_clk_pulse2) or negedge reset2)  begin
      if (reset2 == 0) begin
	 resnap_happened <= 0;
	 
      end
      else begin 
	 if ((status == 1 | status == 9 | status == 17) ) begin
	    resnap_happened <= 1;
	 end
	 else resnap_happened <= 0;
      end
      
   end

   
   //////////////////////////////////////////////////   
   
   
   always @(*)  begin
      if (~dco_clk) begin
	 dco_clk_pre_logic = (freq_counter_pre >= pll_divider2 -3) ;
	 
      end 
      else dco_clk_pre_logic = dco_clk_pre_logic;
      
      
   end // always @ begin
   
   
   
   assign pre_dco_start = (dco_clk_pre_logic) & dco_clk ;
   
  
   
   
   always @(posedge pre_dco_start or negedge reset2)  begin

      if (reset2 == 0) begin
	 lowbw1 <= 0;

	 
      end
      else begin
	 lowbw1<= lowbw;

	 
      end
   end

   
   
   assign pre_zero = (freq_counter_pre == 0 & reset2 == 1) ? 1: 0;
   
   
   always @(*)  begin
      if (~dco_clk) begin
	 pre_zero_gated = pre_zero;
	 
      end 
      else  pre_zero_gated = pre_zero_gated;
      
   end
   
   
   assign gated_dco_clk  = pre_zero_gated & dco_clk;
   
   
   
   
   always @(posedge dco_clk or negedge reset2)  begin
      if (reset2 == 0) begin
	 fine_done_pre_logic0 <= 0; 
	 fine_done_pre_logic1 <= 0;     
	 fine_done_pre_logic2 <= 0;
	 fine_done_pre_logic3 <= 0;
	 fine_done_pre_logic4 <= 0;
	 fine_done_pre_logic5 <= 0;
	 fine_done_pre_logic6 <= 0;
	 fine_done_pre_logic7 <= 0;
	 fine_done_pre_logic8 <= 0;
	 fine_done_pre_logic9 <= 0;
	 fine_done_pre_logic10 <= 0;
	 fine_done_pre_logic11 <= 0;
	 fine_done_pre_logic12 <= 0;
      end // if (reset2 == 0)
      else begin
	 fine_done_pre_logic0 <= fine_done_pre; 
	 fine_done_pre_logic1 <= fine_done_pre_logic0;     
	 fine_done_pre_logic2 <= fine_done_pre_logic1;
	 fine_done_pre_logic3 <= fine_done_pre_logic2;
	 fine_done_pre_logic4 <= fine_done_pre_logic3;
	 fine_done_pre_logic5 <= fine_done_pre_logic4;
	 fine_done_pre_logic6 <= fine_done_pre_logic5;
	 fine_done_pre_logic7 <= fine_done_pre_logic6;
	 fine_done_pre_logic8 <= fine_done_pre_logic7;
	 fine_done_pre_logic9 <= fine_done_pre_logic8;
	 fine_done_pre_logic10 <= fine_done_pre_logic9;
	 fine_done_pre_logic11 <= fine_done_pre_logic10;
	 fine_done_pre_logic12 <= fine_done_pre_logic11;
      end // else: !if(reset2 == 0)
      
   end
   
   

   reg phase_jolt_pre_gater1, phase_jolt_pre_gater2, phase_jolt_change_edge; 

   always @(*)  begin
      if (~dco_clk) begin
	 phase_jolt_pre_gater1 = fine_done_pre_logic2 & ~fine_done_pre_logic3 &  (status != 3 & status != 11 &  status !=  5'd4 & status != 4);
	 phase_jolt_pre_gater2 = (freq_counter_pre == pll_divider2 -3) & (status == 4 | status == 5 | status == 3 | status == 11 | status == 5'd12 | status == 23 | status ==  5'd14);  
	 
      end
      
   end // always @ begin

   assign phase_jolt_change_edge = (phase_jolt_pre_gater1 | phase_jolt_pre_gater2) & dco_clk;
   
   reg fine_done_gater_pre;

   reg logic_computational, logic_traditional, logic_pre_one;
   
   reg fine_done_gater_pre_traditional ;
   wire fine_done_traditional;
   
   assign fine_done_traditional = fine_done_gater_pre_traditional & dco_clk;
   assign fine_done = fine_done_gater_pre & dco_clk;
   
   always @*  begin
      if (~dco_clk) begin
	 fine_done_gater_pre = fine_done_pre_logic1 & ~fine_done_pre_logic2;
	 fine_done_gater_pre_traditional = fine_done_pre_logic3 & ~fine_done_pre_logic4;
	 
	 case (computational_retimed_edge_select) 
	   0: computational_fine_done_retimed_pre = fine_done_pre_logic3 & ~fine_done_pre_logic4;
	   1: computational_fine_done_retimed_pre = fine_done_pre_logic4 & ~fine_done_pre_logic5;
	   2: computational_fine_done_retimed_pre = fine_done_pre_logic5 & ~fine_done_pre_logic6;
	   3: computational_fine_done_retimed_pre = fine_done_pre_logic6 & ~fine_done_pre_logic7;
	   4: computational_fine_done_retimed_pre = fine_done_pre_logic7 & ~fine_done_pre_logic8;
	   5: computational_fine_done_retimed_pre = fine_done_pre_logic8 & ~fine_done_pre_logic9;
	   6: computational_fine_done_retimed_pre = fine_done_pre_logic9 & ~fine_done_pre_logic10;
	   7: computational_fine_done_retimed_pre = fine_done_pre_logic10 & ~fine_done_pre_logic11;
	   
	 endcase // case (computational_edge_select)

	 case (traditional_retimed_edge_select) 
	   0: traditional_fine_done_retimed_pre =  fine_done_pre_logic8 & ~fine_done_pre_logic9;
	   1: traditional_fine_done_retimed_pre =  fine_done_pre_logic9 & ~fine_done_pre_logic10;
	   2: traditional_fine_done_retimed_pre =  fine_done_pre_logic10 & ~fine_done_pre_logic11;
	   3: traditional_fine_done_retimed_pre =  fine_done_pre_logic11 & ~fine_done_pre_logic12;
	 endcase // case (traditional_retimed_edge_select)

	 
	 

      end // if (~dco_clk)

      else begin
	 fine_done_gater_pre_traditional =  fine_done_gater_pre_traditional ;
	 fine_done_gater_pre = fine_done_gater_pre;
	 computational_fine_done_retimed_pre = computational_fine_done_retimed_pre;
	 traditional_fine_done_retimed_pre = traditional_fine_done_retimed_pre;
	 
	 
      end // else: !if(~dco_clk)
      
      
   end
   
   // reg logic1, logic2, logic3;
   reg logic1_posedge, logic2_posedge, logic3_posedge;

   always @*  begin
      	 logic_pre_one = freq_counter_pre == (pll_divider2 -1)  & (status == 5'd22 | status == 5'd1 | status == 5'd2 | status == 5'd3 | status == 4 | status == 5| status == 5'd11 | status == 5'd12 | status == 5'd23 | status == 5'd13 | status ==  5'd14 ) ;

      case (computational_retimed_edge_select) 
	   0: logic_computational = fine_done_pre_logic3 & ~fine_done_pre_logic4 & ~(status == 5'd1 | status == 5'd2 | status == 5'd3 | status == 5'd4 | status == 5'd11 |  status == 5'd13 | status ==  5'd14 | status == 5'd15)  ;
	   1: logic_computational = fine_done_pre_logic4 & ~fine_done_pre_logic5 & ~(status == 5'd1 | status == 5'd2 | status == 5'd3 | status == 5'd4 | status == 5'd11 |  status == 5'd13 | status ==  5'd14 | status == 5'd15)  ;
	   2: logic_computational = fine_done_pre_logic5 & ~fine_done_pre_logic6 & ~(status == 5'd1 | status == 5'd2 | status == 5'd3 | status == 5'd4 | status == 5'd11 |  status == 5'd13 | status ==  5'd14 | status == 5'd15)  ;
	   3: logic_computational = fine_done_pre_logic6 & ~fine_done_pre_logic7 & ~(status == 5'd1 | status == 5'd2 | status == 5'd3 | status == 5'd4 | status == 5'd11 |  status == 5'd13 | status ==  5'd14 | status == 5'd15)  ;
	   4: logic_computational = fine_done_pre_logic7 & ~fine_done_pre_logic8 & ~(status == 5'd1 | status == 5'd2 | status == 5'd3 | status == 5'd4 | status == 5'd11 |  status == 5'd13 | status ==  5'd14 | status == 5'd15)  ;
	   5: logic_computational = fine_done_pre_logic8 & ~fine_done_pre_logic9 & ~(status == 5'd1 | status == 5'd2 | status == 5'd3 | status == 5'd4 | status == 5'd11 |  status == 5'd13 | status ==  5'd14 | status == 5'd15)  ;
	   6: logic_computational = fine_done_pre_logic9 & ~fine_done_pre_logic10 & ~(status == 5'd1 | status == 5'd2 | status == 5'd3 | status == 5'd4 | status == 5'd11 |  status == 5'd13 | status ==  5'd14 | status == 5'd15)  ;
	   7: logic_computational = fine_done_pre_logic10 & ~fine_done_pre_logic11 & ~(status == 5'd1 | status == 5'd2 | status == 5'd3 | status == 5'd4 | status == 5'd11 |  status == 5'd13 | status ==  5'd14 | status == 5'd15)  ;
	 endcase // case (computational_retimed_edge_select)
	 

	 
	 case (traditional_retimed_edge_select) 
	   0: logic_traditional =  fine_done_pre_logic7 & ~fine_done_pre_logic8 & (status == 15);
	   1: logic_traditional =  fine_done_pre_logic8 & ~fine_done_pre_logic9 & (status == 15);
	   2: logic_traditional =  fine_done_pre_logic9 & ~fine_done_pre_logic10 & (status == 15);
	   3: logic_traditional =  fine_done_pre_logic10 & ~fine_done_pre_logic11 & (status == 15);
	 endcase // case (traditional_retimed_edge_select)

   end
   

    
   
   

   always @(posedge dco_clk or negedge reset2)  begin
      if (reset2 == 0) begin
	 
   	 logic1 <= 0;
   	 logic2 <= 0;
   	 logic3 <= 0;
	 
      end 

      else begin
	 logic1 <= logic_pre_one;
         logic2 <= logic_computational;
	 logic3 <= logic_traditional;
	 
	 
      end // else: !if(reset2 == 0)
      
   end // always @ (posedge dco_clk or negedge reset2)
   

   
   
   
   assign traditional_fine_done_retimed  = traditional_fine_done_retimed_pre & dco_clk;
   
   wire [26:0] count_signed2_traditional;
   wire [14:0] traditional_output2;
   
   traditional traditional1
     (     
	   .output_changing_edge(traditional_fine_done_retimed), 
	   .reset2(reset2),
	   .reset3(reset3),
	   .early(early) ,
	   .pll_divider2_finite(pll_divider2[5:0]),
	   .fine_done_traditional(fine_done_traditional),
	   .fine_done(fine_done),
	   .lowbw_pre(lowbw_pre),
	   .lowbw1(lowbw1),      
	   .tdc_output_finite(tdc_output_finite[12:2]),   
	   .freq_locked_code(freq_locked_code),
	   .filter_output_traditional_finite(filter_output_traditional_finite),
	   .cold_start_traditional(cold_start_traditional),
	   .p_finite(p_finite),
	   .p_i_finite(p_i_finite),
	   .p_i_inverse_finite(p_i_inverse_finite),
	   .count_aggr_initial_finite(count_aggr_initial_finite),
	   .count_aggr_saturate_value(count_aggr_saturate_value),
	   .count_signed2(count_signed2_traditional),
	   .count_aggr2(count_aggr),
	   .filter_output_traditional_initial_finite(filter_output_traditional_initial_finite),
	   .traditional_output2(traditional_output2)
	   );

   wire        phase_jolt_given;
   wire        phase_jolt_probe, dco_change_edge_probe, fine_done_with_reset_probe;
   assign phase_jolt_probe = ~phase_jolt_given ;
   assign dco_change_edge_probe  = ~dco_change_edge;
   assign fine_done_with_reset_probe = ~fine_done_with_reset ;
   
   computational computational1
     (.ref_clk(ref_clk),
      .dco_clk(dco_clk),
      .pll_divider(pll_divider),
      .pll_divider2(pll_divider2),
      .reset(reset),
      .computational_start(computational_start),
      .calibration_mode(calibration_mode),
      
      .early(early),
      .fine_done(fine_done),
      .computational_fine_done_retimed_pre(computational_fine_done_retimed_pre),
      .tdc_output_finite(tdc_output_finite),
      .lowbw(lowbw),
      .lowbw_pre(lowbw_pre),
      .status(status),
      .freq_counter_pre(freq_counter_pre),
      .resnap_happened(resnap_happened),
      .filter_output_computational_finite(filter_output_computational_finite),
      .retimed_edge_select(computational_retimed_edge_select),
      .cold_start_traditional(cold_start_traditional),  
      .Kin1_poly_finite(Kin1_poly_finite),
      .Kin2_out_finite_resetval(Kin2_out_finite_resetval),
      .negative_phase_tolerance_finite(negative_phase_tolerance_finite),
      .positive_phase_tolerance_finite(positive_phase_tolerance_finite),
      .negative_freq_tolerance_finite(negative_freq_tolerance_finite),
      .positive_freq_tolerance_finite(positive_freq_tolerance_finite),
      .negative_freq_tolerance_finite2(negative_freq_tolerance_finite2),
      .positive_freq_tolerance_finite2(positive_freq_tolerance_finite2),
      .phase_jolt_change_edge(phase_jolt_change_edge),
      
      .period_change_finite(period_change_finite),
      .corrected_error_for_update(corrected_freq_error),
      .update(update),
      
      .cycle_passed_finite(cycle_passed_finite),
      
      .count_finite( count_finite),
      .gain_finite(gain_finite),
      .count_high_limit(count_high_limit),
      .count_low_limit(count_low_limit),
      .force_increment(force_increment),
      .force_decrement(force_decrement),
      .dco_change_edge(dco_change_edge),
      .fine_done_with_reset(fine_done_with_reset),
      
      .phase_jolt_given(phase_jolt_given),
      .next_status(next_status),
      .freq_locked_code(freq_locked_code),
      .tdc_output_reg_finite(tdc_output_flopped)
      );

   
   dco_decoder  dco_decoder1(
   			     .filter_output(filter_output_finite),
   			     .dco_clk(dco_clk),
   			     .reset2(reset2),
   			     .logic1(logic1),
   			     .logic2(logic2),
   			     .logic3 (logic3 ),
			     .logic1_pre(logic_pre_one),
   			     .logic2_pre(logic_computational),
   			     .logic3_pre(logic_traditional),	       
   			     .rows1(rows1),
   			     .rows2(rows2),
   			     .rows1_b(rows1_b),
   			     .rows2_b(rows2_b),

   			     .fine(fine),
   			     .fine_b(fine_b),
			    
			     .dsm_output(dsm_output)
   			     );

   
   clk_count_compare compare_delay_gen (
					.comparing_clk(delay_gen1),
					.compared_clk(delay_gen2),
					.clk_count_start(clk_count_start),
					.calibration_mode(calibration_mode),
					.count_untill(count_untill),
					.compared_count(delay_gen_counter)
					);

   
   clk_count_compare compare_ref_clk_tdc_ro1 (
					      .comparing_clk(ref_clk),
					      .compared_clk(tdc_ro),
					      .clk_count_start(clk_count_start),
					      .calibration_mode(calibration_mode),
					      .count_untill(count_untill),
					      .compared_count(ref_tdc_counter)
					      );

   
   clk_count_compare compare_ref_clk_gated_dco (
						.comparing_clk(ref_clk),
						.compared_clk(gated_dco_clk),
						.clk_count_start(clk_count_start),
						.calibration_mode(calibration_mode),
						.count_untill(count_untill),
						.compared_count(ref_dco_counter)
						);
   
   
endmodule // loop_filter


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

