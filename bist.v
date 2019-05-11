module bist
  #(parameter register_length = 30) 
   (
    input 	      ref_clk_bist,
    input 	      enable_bist,
    
    input 	      reset,
    
    input [10:0]      offset_input,
    input [10:0]      decimator_input,

    input 	      new_div_ratio_given,
    input 	      lowbw,
    input wire [12:0] tdc_limit,
   
    input [12:0]      tdc_output,
    input 	      early,
    input [12:0]      dco_input,
    input [13:0]      corrected_freq_error,
    input [13:0]      period_change,
    input [5:0]       status,
    input [19:0]      count_aggr,
   
    // output reg 	      new_div_ratio_latched,
    output reg [12:0] tdc_output_reg [register_length - 1:0],
    output reg 	      early_reg [register_length - 1:0],
    output reg [12:0] dco_input_reg [register_length - 1:0],
    output reg [13:0] corrected_freq_error_reg [register_length - 1:0],
   
    output reg [13:0] period_change_reg [register_length - 1:0],
    output reg [5:0]  status_reg [register_length - 1:0],
    output reg [19:0] count_aggr_reg [register_length - 1:0],
   
    output reg [10:0] locktime,
    output reg [10:0] computational_locktime
   
    );

   wire 	      sampling_clk;
   
   reg [10:0] 	      decimator_count;
   reg [10:0] 	      offset_count;
   reg 		      decimator_clk;

   reg 		      storing_clk_pre; // determines whether to increment the storing clock count & shift the register value at clock edge
   reg [6:0] 	      storing_clk_count; // keep counts on how many shifter has been occcupied
   wire 	      storing_clk; 
   
   reg 		      new_div_ratio_latched;  

   
   reg [12:0] 	      locktime_sampling_clk_count;
   reg [12:0] 	      computational_locktime_sampling_clk_count;
   reg 		      phase_locked;
   
   reg [10:0] 	      locktime_pre;   
   reg [10:0] 	      computational_locktime_pre;
   
   reg [12:0] 	      tdc_output_latched;

   
   assign sampling_clk = ref_clk_bist & enable_bist ;
   

   always @(*)  begin
      if (!sampling_clk) begin
	 new_div_ratio_latched <= new_div_ratio_given;
	 
      end 
      else new_div_ratio_latched <= new_div_ratio_latched;
	 
   end

   
   always @(*)  begin
      
      if (!sampling_clk) begin
	 tdc_output_latched <= tdc_output;
	 
      end
      else tdc_output_latched <= tdc_output_latched;
	 
      
   end
   
   
   always @(*)  begin
      
      if (!sampling_clk) begin
	 
         if (new_div_ratio_latched | reset == 0) begin
	    storing_clk_pre <= 0;
	    
	 end
	 else begin
	    storing_clk_pre <= (decimator_count == decimator_input & offset_count == offset_input) ? 1:0;
	 end
	 
      end // if (!sampling_clk)

      else begin
	 storing_clk_pre <= storing_clk_pre;
      end // else: !if(!sampling_clk)
      
      
   end // always @ (sampling_clk or storing_clk_pre)


   


   
   always @(posedge sampling_clk )  begin
      if (new_div_ratio_latched | reset == 0) begin
	 
	 decimator_count <= 0;
	 
	 offset_count <= 0;
      end

      else begin
	 decimator_count <= (offset_count == offset_input) ?  (   (decimator_count == decimator_input) ? 0:  (decimator_count + 11'd1)  ) :0 ;
	 
	 offset_count <= (offset_count == offset_input) ?  offset_count : (offset_count + 11'b00000000001) ;
      end
      
   end // always @ (posedge sampling_clk )
   

   
   // assign storing_clk = storing_clk_pre & sampling_clk;
   

   always @(posedge sampling_clk )  begin
      
      if (new_div_ratio_latched | reset == 0) begin
	 storing_clk_count <= 0;
	 
      end

      else begin
	 if ( (storing_clk_count < register_length ) & storing_clk_pre == 1) begin
	    storing_clk_count <= storing_clk_count + 6'b000001;
	    
	 end
         else begin
	    storing_clk_count <= storing_clk_count;
	 end
	 
      end // else: !if(new_div_ratio_latched)

   end // always @ (posedge sampling_clk )
   

   
   
   
   // storing_clk_count <=   new_div_ratio_latched ? 0 : ( (storing_clk_count <= register_length) & storing_clk_pre) ? storing_clk_count + 7'b01 :  storing_clk_count ;

   always @(posedge sampling_clk )  begin 
      if ((storing_clk_count < register_length) & storing_clk_pre ) begin
	 
	 early_reg[register_length - 1:1] <= early_reg[register_length - 2:0];
	 tdc_output_reg[register_length - 1:1] <= tdc_output_reg[register_length - 2:0];
	 dco_input_reg[register_length - 1:1] <= dco_input_reg[register_length - 2:0];
	 corrected_freq_error_reg[register_length - 1:1] <= corrected_freq_error_reg[register_length - 2:0];
	 period_change_reg[register_length - 1:1] <= period_change_reg[register_length - 2:0];
	 status_reg[register_length - 1:1] <= status_reg[register_length - 2:0];
	 count_aggr_reg[register_length - 1:1] <= count_aggr_reg[register_length - 2:0];
	 
	 early_reg[0] <= early;
	 tdc_output_reg[0] <= tdc_output;
	 dco_input_reg[0] <= dco_input;
	 corrected_freq_error_reg[0] <= corrected_freq_error;
	 period_change_reg[0] <= period_change;
	 status_reg[0] <= status;
	 count_aggr_reg[0] <= count_aggr;
	 
      end // if (storing_clk_count <= register_length & storing_clk_pre )
      

      else begin
	 early_reg[register_length - 1:0] <= early_reg[register_length - 1:0];
	 tdc_output_reg[register_length - 1:0] <= tdc_output_reg[register_length - 1:0];
	 dco_input_reg[register_length - 1:0] <= dco_input_reg[register_length - 1:0];
	 corrected_freq_error_reg[register_length - 1:0] <= corrected_freq_error_reg[register_length - 1:0];
	 period_change_reg[register_length - 1:0] <= period_change_reg[register_length - 1:0];
	 status_reg[register_length - 1:0] <= status_reg[register_length - 1:0];
	 count_aggr_reg[register_length - 1:0] <= count_aggr_reg[register_length - 1:0];
      end // else: !if(storing_clk_count <= register_length & storing_clk_pre )
      
      
   end // always @ (posedge sampling_clk )

   
   
   
   
   always @(posedge sampling_clk)  begin
      if (new_div_ratio_latched | reset == 0
	  ) begin
	 locktime_pre <= 0;
	 phase_locked <= 0;
	 
      end

      else begin
	 if (locktime_pre < 20) begin
	    phase_locked <= 0;
	    
	    if (tdc_output_latched < tdc_limit) begin
	       locktime_pre <= locktime_pre + 1;	   
	    end
	    else begin
	       locktime_pre <= 0;
	    end
	 end

	 else begin
	    phase_locked <= 1;
	    locktime_pre <= locktime_pre;
	    
	 end // else: !if(locktime_pre < 20)
	 
      end // else: !if(new_div_ratio_latched...
      
      

      
   end // always @ (posedge sampling_clk)

   always @(posedge sampling_clk)  begin
      
      if (new_div_ratio_latched | reset == 0) begin
	 locktime_sampling_clk_count <= 0;
	 computational_locktime_sampling_clk_count <= 0;
      end

      else begin
	 locktime_sampling_clk_count <= (&locktime_sampling_clk_count) ? locktime_sampling_clk_count :( phase_locked ? locktime_sampling_clk_count:  locktime_sampling_clk_count + 1) ;
	 computational_locktime_sampling_clk_count <= (&computational_locktime_sampling_clk_count) ? computational_locktime_sampling_clk_count :( lowbw ? computational_locktime_sampling_clk_count:  computational_locktime_sampling_clk_count + 1) ;
      end
      
   end
   

   always @(posedge sampling_clk)  begin
      if (new_div_ratio_latched | reset == 0) begin
	 locktime <= 0;
	 
      end
      else begin
	 if (phase_locked == 1
	     ) begin
	    locktime <= locktime_sampling_clk_count - 20;
	    
	 end
	 else begin
	    locktime <= locktime;
	 end
	 
      end // else: !if(new_div_ratio_latched)
      
   end // always @ (posedge sampling_clk)

   

   always @(posedge sampling_clk)  begin
      if (new_div_ratio_latched | reset == 0) begin
	 computational_locktime <= 0;
	 
      end
      else begin
	 if (lowbw == 1
	     ) begin
	    computational_locktime <= computational_locktime_sampling_clk_count;
	    
	 end
	 else begin
	    computational_locktime <= computational_locktime;
	 end
	 
      end // else: !if(new_div_ratio_latched)
      
      
   end // always @ (posedge sampling_clk)
   
   

endmodule // bist
