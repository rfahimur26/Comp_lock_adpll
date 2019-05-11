module traditional ( 
		    		    
		    input wire 		     output_changing_edge,
		    input wire 		     reset2,
		    input wire 		     reset3,
		    input wire 		     early,
		    input wire [5:0] 	     pll_divider2_finite,
		    input wire 		     fine_done_traditional,
		    input wire 		     fine_done,
		    input wire 		     lowbw,
		    input wire 		     lowbw_pre,
		    input wire 		     lowbw1,
		    input wire [10:0] 	     tdc_output_finite,
		    input wire [12:0] 	     freq_locked_code,
		    output wire [12:0] 	     filter_output_traditional_finite ,
		    input wire 		     cold_start_traditional ,
		    input wire [8:0] 	     p_finite,
		    input wire [8:0] 	     p_i_finite,
		    input wire [9:0] 	     p_i_inverse_finite,
		    input wire [15:0] 	     count_aggr_initial_finite,
		    input wire [17:0] 	     count_aggr_saturate_value,
		   
		    output reg signed [26:0] count_signed2,
		    output reg [19:0] 	     count_aggr2,
		    input wire signed [12:0] filter_output_traditional_initial_finite,
		    output wire [14:0] 	     traditional_output2
		  
		   );




   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////######Finite bit ##############///////////////////////////////////

   
   // wire [8:0]  p_finite;   //4.5 // can cover from 15 to 0.9 with step = 0.031 format = 4.5
   // wire [8:0]  p_i_finite; //can cover from 7 to 0.089 with step = 0.015 format = 3.6
   
   // wire [9:0]  p_i_inverse_finite;  //1.9 format

   // wire [5:0]  pll_divider2_finite;
   wire signed [10:0] 			    p_finite_extended;
   wire signed [9:0] 			    p_i_finite_extended;

 
   
   wire [18:0] 				    count_finite_full; 
   wire [12:0] 				    count_finite;
   // reg  signed [26:0] 			    count_signed2; //4.8
   
   wire [15:0] 				    computational_output_transfer_finite; //take 12.4 from 10.13
   
   wire signed [26:0] 			    count_aggr2_extended; //21.6
   
   // wire signed [12:0]  filter_output_traditional_initial_finite;
   // wire [15:0]   count_aggr_initial_finite;
   // wire [17:0]  count_aggr_saturate_value;
   
   wire signed [17:0] 			    count_aggr2_new;
   // wire [14:0] 				    traditional_output2; //9.6
   wire [26:0] 				    traditional_output2_full; //15.10

   
   wire signed 				    fine_done_with_reset;
   
 
   reg [22:0] 				    computational_output_transfer_finite_full; // 9.4 * 1.9 = 10.13
   
   reg signed [12:0] 			    filter_output_traditional_sampled_finite;

   
   
   // assign filter_output_traditional_initial_finite = 13'h0222;
   // assign count_aggr_initial_finite = 16'h0150;
   // assign count_aggr_saturate_value  = {1'b0, {17{1'b1}} };
   // assign p_finite =   9'b011010111;   //   8 * .8192 = 6.722   =  0110.10111
   // assign p_i_finite = 9'b001010110;   // 1.64112 * .8192 = 1.3444 =  001.010110
   
   // assign p_i_inverse_finite = 10'b0101111101;   //0.101111101
   
   // assign pll_divider2_finite = pll_divider2;
   reg 	[10:0]				    tdc_flopped;
   
   always @(posedge fine_done)  begin
      tdc_flopped <= tdc_output_finite[10:0];
      
   end
   
   assign count_finite_full = (reset2 & reset3) ? (lowbw_pre ?  {2'b00,tdc_flopped} * pll_divider2_finite : 0 ) : 0;
   assign count_finite = |count_finite_full[18:16] ? 13'b0111111111111 : {1'b0,count_finite_full[15:4]}; //5.8f

  
   
   wire signed [26:0] 			    test1;
   
   wire 				    unsigned [26:0]       test2;

   
   assign test1 = $signed( $signed(count_signed2) * ({1'b0,p_finite,1'b0}) ) ;
   assign test2 = count_aggr2_extended * p_i_finite_extended;
   
   assign p_finite_extended = $signed( {1'b0,p_finite,1'b0}); //5.6
   assign p_i_finite_extended = $signed( {1'b0,p_i_finite});
   assign count_aggr2_extended = {7'b0,count_aggr2};

   
   assign traditional_output2_full =    (count_signed2 * p_finite_extended )  +  (count_aggr2_extended * p_i_finite_extended); //10.6 * 5.6 + 12.6 * 3.6
   

   // wire [26:0] 				    traditional_output2_full3; //15.10   
   // assign traditional_output2_full3 = test1 + test2; //15.12   //(4.6 * 5.6) + (12.6 * 3.6)

   
   assign traditional_output2 = traditional_output2_full[20:6]; //9.6


   assign fine_done_with_reset = fine_done_traditional | ~reset3;
  
      
   always @(posedge lowbw_pre)  begin
      computational_output_transfer_finite_full <= freq_locked_code * p_i_inverse_finite; //take 10.4
   end

   assign computational_output_transfer_finite = {2'b0,computational_output_transfer_finite_full[22:9]} ;
   
   assign count_aggr2_new = $signed(count_aggr2) + $signed(count_signed2) ;

   
   
   always @(posedge fine_done_with_reset)  begin
      count_signed2 <= early ? {14'b0,count_finite[12:0]} : -{14'b0,count_finite[12:0]};
     
      
      count_aggr2 <= (reset2 == 0 | reset3 == 0) ? {count_aggr_initial_finite,4'b0} : ( cold_start_traditional ? {2'b0,count_aggr2_new} :   ( (lowbw_pre == 1) ? ((lowbw1 == 0) ? {computational_output_transfer_finite,4'b0} :((count_aggr2_new > count_aggr_saturate_value) ? count_aggr_saturate_value : {2'b0,count_aggr2_new} )  ) :  {count_aggr_initial_finite,4'b0} )  ) ;  //load intial value/transfer value from computational result of accumulation 
   end

   
   always @(posedge output_changing_edge) begin
      
      filter_output_traditional_sampled_finite <= (reset2== 0 | reset3 == 0) ? filter_output_traditional_initial_finite : (traditional_output2_full[26] ? 13'b0 :(traditional_output2_full[22:10] > 13'd4800 ? 13'd4800 : traditional_output2_full[22:10]) );
      
   end
   
   wire  [12:0] filter_output_traditional_cont_finite;

   assign   filter_output_traditional_cont_finite = (reset2== 0 | reset3 == 0) ? filter_output_traditional_initial_finite : (traditional_output2_full[26] ? 13'b0 :(traditional_output2_full[22:10] > 13'd4800 ? 13'd4800 : traditional_output2_full[22:10]) );
   
   assign filter_output_traditional_finite = (reset2 == 0 | reset3 == 0) ? filter_output_traditional_initial_finite : filter_output_traditional_cont_finite;

   //////////////////////////////////////////////////////########Finite bit completed#############///////////////////////////////////////////////////////////////////
   
   
endmodule // traditional
