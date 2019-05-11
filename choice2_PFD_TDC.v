module choice2_PFD_TDC (
			input 	     enable_PFD_TDC ,
			input 	     select_PFD_input,
			input 	     ref_clk, 
			input 	     external1 ,
			input 	     gated_dco_clk,
			input 	     external2,
			input 	     reset,
			input 	     dco_clk,
			output 	     fine_done_pre,
			output 	     early,
			output [4:0] counter_rise,
			output [4:0] counter_fall,
			output [7:0] trip_b,
			output [7:0] cross_pin,
			output 	     tdc_ro

			);


   assign counter_rise = 0;
   assign counter_fall = 0;
   assign cross_pin  = 0;
   assign trip_b = 8'b11111111;
   assign tdc_ro = 0;
endmodule // tdc2_behaviour
