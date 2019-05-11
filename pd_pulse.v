module pd_pulse (
		 input 	ref_clk,
		 input 	dco_clk,
		 output wire ref_clk_pulse 
		 );



   reg 			ref_clk1, ref_clk2,ref_clk3, ref_clk4,ref_clk5,ref_clk6,ref_clk7,ref_clk8_bar;
   

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

endmodule
