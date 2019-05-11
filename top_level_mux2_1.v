module top_level_mux2_1 ( input choice0,
			  input  choice1,
			  input  selection_bit,
			  output selected_output);


   assign selected_output = selection_bit ? choice1 : choice0;

endmodule // top_level_mux2_1


