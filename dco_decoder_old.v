module dco_decoder (
		    input [12:0]      filter_output,
		    input 	      dco_clk,
		    input 	      reset2,
		    input 	      logic1,
		    input 	      logic2,
		    input 	      logic3,
		    input 	      logic1_posedge,
		    input 	      logic2_posedge,
		    input 	      logic3_posedge, 


		    output reg [17:0] rows1,
		    output reg [17:0] rows2,
		    output reg [17:0] rows1_b,
		    output reg [17:0] rows2_b,

		    output reg [29:0] fine,
		    output reg [29:0] fine_b,
		    output 	      vco_flopping_edge,
		    output reg [4:0]      dsm_output

		    );


   reg [18:0] 			      rows_unflopped;
   wire [29:0] 			      fine_unflopped;
   
   wire [4:0] 			      code_for_rows;
   wire [5:0] 			      code_for_column;
   wire [4:0] 			      code_for_column2;
   wire 			      select_fine_row;
   wire 			      dsm_bit;
   
   assign code_for_rows = filter_output[12:8] + ((code_for_column[5] | &code_for_column[4:1]) ? 2'd2 : ( code_for_column[4] | &code_for_column[3:0] ) ? 2'd1: 0 ) ;
   
   assign code_for_column = {1'b0,filter_output[12:8]} + {2'b0,filter_output[7:4]};
   assign code_for_column2 = code_for_column[3:0] + code_for_column[4];

   
   
   reg [29:0] 			      column_decoded;
   
   assign column_decoded[29:15] = rows_unflopped[18] ? 15'b111111111111111 : 0;
   
   always @*  begin

      casex (code_for_rows) 
	
	0 : rows_unflopped =  19'b0000000000000000000;
	1 : rows_unflopped =  19'b0000000000000000001;
	2 : rows_unflopped =  19'b0000000000000000011;
	3 : rows_unflopped =  19'b0000000000000000111;
	4 : rows_unflopped =  19'b0000000000000001111;
	5 : rows_unflopped =  19'b0000000000000011111;
	6 : rows_unflopped =  19'b0000000000000111111;
	7 : rows_unflopped =  19'b0000000000001111111;
	8 : rows_unflopped =  19'b0000000000011111111;
	9 : rows_unflopped =  19'b0000000000111111111;
	10 : rows_unflopped = 19'b0000000001111111111;
	11 : rows_unflopped = 19'b0000000011111111111;
	12 : rows_unflopped = 19'b0000000111111111111;
	13 : rows_unflopped = 19'b0000001111111111111;
	14 : rows_unflopped = 19'b0000011111111111111;
	15 : rows_unflopped = 19'b0000111111111111111;
	16 : rows_unflopped = 19'b0001111111111111111;
	17 : rows_unflopped = 19'b0011111111111111111;
	18 : rows_unflopped = 19'b0111111111111111111;
	19 : rows_unflopped = 19'b1111111111111111111;
	20 : rows_unflopped = 19'b1111111111111111111;
	21 : rows_unflopped = 19'b1111111111111111111;
	
	default: rows_unflopped = 19'bxxxxxxxxxxxxxxxxxx;

      endcase // case (code_for_rows)
      
      
      case (code_for_column2[4:0])
	0 : column_decoded[14:0] = code_for_column[5] ? 15'b000000000000011 : 15'b000000000000000;
	1 : column_decoded[14:0] = 15'b000000000000001;
	2 : column_decoded[14:0] = 15'b000000000000011;
	3 : column_decoded[14:0] = 15'b000000000000111;
	4 : column_decoded[14:0] = 15'b000000000001111;
	5 : column_decoded[14:0] = 15'b000000000011111;
	6 : column_decoded[14:0] = 15'b000000000111111;
	7 : column_decoded[14:0] = 15'b000000001111111;
	8 : column_decoded[14:0] = 15'b000000011111111;
	9 : column_decoded[14:0] = 15'b000000111111111;
	10 : column_decoded[14:0] = 15'b000001111111111;
	11 : column_decoded[14:0] = 15'b000011111111111;
	12 : column_decoded[14:0] = 15'b000111111111111;
	13 : column_decoded[14:0] = 15'b001111111111111;
	14 : column_decoded[14:0] = 15'b011111111111111;
	15 : column_decoded[14:0] =(filter_output[12] & filter_output[9]) ? 15'b111111111111111 : 0;
	16 : column_decoded[14:0] = 15'b000000000000001;
	
        default :  column_decoded[14:0] = 15'bxxxxxxxxxxxxxxx;
      endcase // case (code_for_column)
      
      
   end // always @ *
   
   assign fine_unflopped[14] = column_decoded[14] | dsm_bit ;
   assign fine_unflopped[29:15] = column_decoded[29:15];
   assign fine_unflopped[13:0] = column_decoded[13:0];
   

   // wire logic1, logic2,logic3;
   wire  vco_flopping_edge_pre;
   assign vco_flopping_edge = ( (logic1 | logic2 | logic3) & dco_clk) | ~reset2;
   
   
   // reg [4:0] dsm_output;
   reg [3:0] dsm_flopped_input; 
   reg [3:0] dsm_flopped_input_pre; 
   
   assign dsm_bit = dsm_output[4];

   
   always @(posedge dco_clk)  begin
      dsm_output <= (reset2 == 0) ? {1'b0, filter_output[3:0]} : ( (logic1_posedge | logic2_posedge | logic3_posedge) ? {1'b0, filter_output[3:0] } : {1'b0, dsm_flopped_input}  + {1'b0, dsm_output[3:0]} );
      
   end
   
   always @(posedge vco_flopping_edge)  begin
      rows1 <= rows_unflopped[18:0];
      rows2 <= rows_unflopped[18:0];
      rows1_b <= ~rows_unflopped[18:0];
      rows2_b <= ~rows_unflopped[18:0];
      fine[29:15] <= fine_unflopped[29:15] ;
      fine_b[29:15] <= ~fine_unflopped[29:15];
      fine[13:0] <= fine_unflopped[13:0] ;
      fine_b[13:0] <= ~fine_unflopped[13:0];
      
      dsm_flopped_input <= filter_output[3:0] ;
      
   end // always @ (posedge vco_flopping_edge)

   
   

   always @(posedge dco_clk)  begin
          
      fine[14] <= fine_unflopped[14] ; 
      fine_b[14] <= ~fine_unflopped[14];
      
   end
   
   
   
endmodule // dco_decoder
