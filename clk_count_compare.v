module clk_count_compare (
                input 		  comparing_clk,
		input 		  compared_clk,
		input 		  calibration_mode,
		input 		  clk_count_start,
		input [14:0] 	  count_untill,
		output reg [14:0] compared_count);


   reg [14:0] 			   comparing_clk_count;
   
   always @(posedge comparing_clk)  begin
      comparing_clk_count <= (clk_count_start == 0 | calibration_mode == 0) ? 0 :  ( ( comparing_clk_count == count_untill) ? comparing_clk_count : comparing_clk_count + 1);
      
   end

   always @(posedge compared_clk)  begin
      compared_count <= (clk_count_start == 0 | calibration_mode == 0 ) ? 0 : ( ( comparing_clk_count == count_untill) ? compared_count : compared_count + 1 ) ;
      
   end

   
   
endmodule
