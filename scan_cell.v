module scan_cell
  (
   input      scan_in,
   input      phi,
   input      phi_bar,
   input      capture,
   input      update,
   input      chip_data_out,
   output reg chip_data_in,
   output reg scan_out
   );
   
   reg 	      int_data;
   
   always @*  begin
      if (update) begin
	 chip_data_in=int_data;
      end
      else begin
	 chip_data_in = chip_data_in;
      end
   end
   
   always @* begin
      if (phi) begin
	 int_data=scan_in;
      end
      else begin
	 int_data = int_data;
      end
   end

   always @*  begin      
      if (phi_bar) begin
	 scan_out=(capture)? chip_data_out:int_data;
      end
      else begin
	 scan_out = scan_out;

      end
   end
   

endmodule // scan_cell
