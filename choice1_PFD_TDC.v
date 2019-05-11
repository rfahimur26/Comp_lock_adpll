module choice1_PFD_TDC (
		       input 	    enable_PFD_TDC ,
		       input 	    select_PFD_input,
		       input 	    ref_clk, 
		       input 	    external1 ,
		       input 	    gated_dco_clk,
		       input 	    external2,
		       input 	    reset,
		       input 	    dco_clk,
		       output reg   fine_done_pre,
		       output reg   early,
		       output [4:0] counter_rise,
		       output [4:0] counter_fall,
		       output reg [7:0] bs,
		       output [8:0] vernier,
		       output tdc_ro 
		       );

   reg 				    dco_delayed;
   
   reg 				    start_count,  early_f,early_unflopped;
   real 			    count1,count, count2;
   
   wire 			    PFD_edge1, PFD_edge2;

   reg 				    both_edge_captured, both_edge_captured1, both_edge_captured2, both_edge_captured3;
  
   real 			    tref = 1/10000.00000000000001;

   assign tdc_ro = 0;
  




   
    always @*  begin
      dco_delayed = #(0.005) dco_clk;
   end
   assign PFD_edge1 = select_PFD_input ? external1 : ref_clk;
   assign PFD_edge2 = select_PFD_input ? external2 : gated_dco_clk;

   initial begin
      start_count <= 0;
      count <= 0;
      count1 <= 0;
      count2 <= 0;
      fine_done_pre <= 0;
      both_edge_captured <= 0;
      both_edge_captured1 <= 0;
      both_edge_captured2 <= 0;
      both_edge_captured3 <= 0;
      // vernier <= 0;
      
   end
   
   always @(posedge PFD_edge1)  begin
      if (start_count == 0) begin
	 start_count <= 1;
	 early_unflopped <= 1;
	 early_f <= early_f;
	 both_edge_captured <= 0 ;          
      end
      
      if (start_count == 1 & early_unflopped ==0 	) begin
	 start_count <= 0;
	 count1 <= (count + 0.001)/tref;
	 count <= 0;
	 early_f <= early_unflopped;
	 both_edge_captured <= 1 & ~(both_edge_captured3);
      end

      if (start_count == 1 & early_unflopped == 1) begin
	 count1 <= count/tref;
	 count <=0;
         early_f <= early_unflopped;   
         both_edge_captured <= both_edge_captured & ~(both_edge_captured3);
	 
      end 
      

   end // always @ (posedge PFD_edge1)
   
  
   
   
   
   always @(posedge PFD_edge2 )  begin
      if (start_count == 0) begin
	 start_count <= 1;
	 early_unflopped <= 0;
	 early_f <= early_f;
	 both_edge_captured <= 0 ;       
      end
      if (start_count == 1 & early_unflopped ==1
	  ) begin
	 start_count <= 0;
	 count1 <= (count + 0.001)/tref;
	 count <=0;
	 early_f <= early_unflopped;
         both_edge_captured <= 1 & ~(both_edge_captured3);
      end
      
      if (start_count == 1 & early_unflopped == 0) begin
	 count1 <= count/tref;
	 early_f <= early_unflopped;
	 both_edge_captured <= both_edge_captured & ~(both_edge_captured3);
	 // count <=0;
	 
      end     
      
   end // always @ (posedge PFD_edge2 )
   
 
   always @(posedge both_edge_captured3)  begin
      both_edge_captured <= 0;
      
   end
   
   
   real rise_count_real, fall_count_real;
   real medium_initial;
   int 	fine_count_real;
   

   always @*  begin
      rise_count_real = (count2 - 73)/280;
      fall_count_real = (count2 + 83  ) / 280;
      
   end

   assign counter_rise = rise_count_real <0 ? 0 : $floor(rise_count_real);
   assign counter_fall = fall_count_real < 0 ? 0 : $floor(fall_count_real);

   real      medium_count_real;
   int 	     medium_int;
   
   always @*  begin
      medium_initial = $rtoi(count2) % 280 ;
      medium_count_real = medium_initial /$itor(280) * 14;
      // medium_count_real = medium_initial /281.0000000001 * 7;
      medium_int = $floor(medium_count_real);
      
   end

   // reg [7:0] bs;
   
   
   always @*  begin
      case (medium_int) 
	0: bs =  count2 < 280 ? 8'b00000001 : 8'b10000000;
	1: bs =  count2 < 280 ? 8'b00000001 : 8'b10000000;
	2: bs =  8'b00000100;
	3: bs =  8'b00000100;
	4: bs =  8'b00010000;
	5: bs =  8'b00010000;
	6: bs =  8'b01000000;
	7: bs =  8'b01000000;
	8: bs =  8'b00000010;
	9: bs =  8'b00000010;
	10: bs = 8'b00001000;
	11: bs = 8'b00001000;
	12: bs = 8'b00100000;
	13: bs = 8'b00100000;


	
      endcase
      
      // if (medium_count_real < 40) begin
      // 	 if (count2 < 271) begin
      // 	    bs = 8'b00000001;
      // 	 end 
      // 	 else begin bs = 8'b10000000;
      // 	 end
      
      // end
      // else if (medium_count_real < 40 * 2) begin
      // 	 bs = 8'b00000010;
      // end
      // else if (medium_count_real < 40 * 3) begin
      // 	 bs = 8'b00000100;
      // end
      // else if (medium_count_real < 40 * 4) begin
      // 	 bs = 8'b00001000 ;
      // end
      // else if (medium_count_real < 40 * 5) begin
      // 	 bs = 8'b00010000;
      // end
      // else if (medium_count_real < 40 * 6) begin
      // 	 bs = 8'b00100000;
      // end
      // else begin
      // 	 bs = 8'b01000000;
      // end


      
      
   end // always @ *

   real fine_count2;
   
   always @*  begin
      fine_count2 = medium_initial / $itor(40);
      
      fine_count_real =( medium_initial - $rtoi(fine_count2) * 40 ) / 6;
      
   end
   
   // always @*  begin
   //    case (fine_count_real) 
   // 	0: vernier = 9'b000000111;
   // 	1: vernier = 9'b111111110;
   // 	2: vernier = 9'b111111100;
   // 	3: vernier = 9'b111111000;
   // 	4: vernier = 9'b111110000;
   // 	5: vernier = 9'b111100000;
   // 	6: vernier = 9'b111000000;
   // 	7: vernier = 9'b110000000;
   // 	8: vernier = 9'b100000000;

   // 	default:vernier = 9'b100000000;
   //    endcase
      
      
      
   // end // always @ *
   
   assign vernier = (fine_count_real == 0) ? 9'b000000111: (fine_count_real == 1) ? 9'b111111110 : (fine_count_real == 2) ? 9'b111111100 : (fine_count_real == 3) ? 9'b111111000 : (fine_count_real == 4) ? 9'b111110000: (fine_count_real == 5) ? 9'b111100000 : (fine_count_real == 6) ?  9'b111000000 :  (fine_count_real == 7) ?  9'b110000000 : (fine_count_real == 8) ?  9'b100000000 :  9'b100000000  ;
   
   
   always #0.001  begin
      if (start_count == 1) begin
 	 count <=  count + 0.001;
      end // if (start_count == 1)
   end // always begin


   always @(posedge dco_delayed)  begin
      both_edge_captured1 <= both_edge_captured;
      both_edge_captured2 <= both_edge_captured1;
      both_edge_captured3 <= both_edge_captured2;
      
      fine_done_pre <= both_edge_captured ;
      
   end // always @ (posedge dco_clk)
   
   

   always @*  begin
     
      count2 <= (count1 > 8190) ? 8190 : count1;
      early <=  early_f;
   end
   
endmodule // tdc1_behaviour




