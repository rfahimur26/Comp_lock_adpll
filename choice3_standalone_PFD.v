module choice3_standalone_PFD(
			input 	    enable_PFD ,
			input 	    select_PFD_input,
			input 	    ref_clk, 
			input 	    external1 ,
			input 	    gated_dco_clk,
			input 	    external2,
			input 	    reset,
			input 	    dco_clk,
			output 	    fine_done_pre,
			output 	    early		 
			);

   assign early = 0;
   assign fine_done_pre = 0;
   

   
endmodule // tdc3_behaviour
