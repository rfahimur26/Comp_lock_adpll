
module vco_ideal (
   input [17:0] v_row,
   input [17:0] v_b_row,
   input [17:0] v_row1,
   input [17:0] v_b_row1,
   input [29:0] fine,
   input [29:0] fine_b,
   output reg	vout,
   input 	enable_vco);


   reg [7:0] rows_added;
   reg [7:0]  dsm_added;
   real  Kin4;
   wire [17:0] rows;

   assign rows = v_row;
   initial begin
      Kin4 = 20;
      rows_added = 20;
      dsm_added = 0;
   end
   
   always @*  begin
      
      rows_added = {7'b0,rows[0] } + {7'b0,rows[1] } + {7'b0,rows[2] } + {7'b0,rows[3] } + {7'b0,rows[4] } + {7'b0,rows[5] } + {7'b0,rows[6] } + {7'b0,rows[7] } + {7'b0,rows[8] } + {7'b0,rows[9] } + {7'b0,rows[10] } + {7'b0,rows[11] } + {7'b0,rows[12] } + {7'b0,rows[13] } + {7'b0,rows[14] } + {7'b0,rows[15] } + {7'b0,rows[16] } + {7'b0,rows[17] };
      
      dsm_added = {7'b0,fine[0] } + {7'b0,fine[1] } + {7'b0,fine[2] } + {7'b0,fine[3] } + {7'b0,fine[4] } + {7'b0,fine[5] } + {7'b0,fine[6] } + {7'b0,fine[7] } + {7'b0,fine[8] } + {7'b0,fine[9] } + {7'b0,fine[10] } + {7'b0,fine[11] } + {7'b0,fine[12] } + {7'b0,fine[13] } + {7'b0,fine[14] } + {7'b0,fine[15] } + {7'b0,fine[16] } + {7'b0,fine[17] } + {7'b0,fine[18] } + {7'b0,fine[19] } + {7'b0,fine[20] } + {7'b0,fine[21] } + {7'b0,fine[22] } + {7'b0,fine[23] } + {7'b0,fine[24] } + {7'b0,fine[25] } + {7'b0,fine[26] } + {7'b0,fine[27] } + {7'b0,fine[28] } + {7'b0,fine[29] }  ;
      
      Kin4 = (rows_added) * 15 + (dsm_added);
      
   end
   
   

   
   
   real finished, counter, counter_max;
   real time_period;
   
   always @*  begin
      if (Kin4 > 301) begin
	 time_period =  3.9941e-010;
      end
      else if (Kin4 <= 0) begin
	 time_period = 0.000000001;
      end
      else begin
	 case (Kin4) 
	   1 : time_period = 0.000000001;
	   2 : time_period = 0.000000001;
	   3 : time_period = 9.4878e-010;
	   4 : time_period = 9.4395e-010;
	   5 : time_period = 9.3959e-010;
	   6 : time_period = 9.3541e-010;
	   7 : time_period = 9.2952e-010;
	   8 : time_period = 9.2422e-010;
	   9 : time_period = 9.1898e-010;
	   10 : time_period = 9.1466e-010;
	   11 : time_period = 9.1097e-010;
	   12 : time_period = 9.0519e-010;
	   13 : time_period = 9.0177e-010;
	   14 : time_period = 8.9669e-010;
	   15 : time_period = 8.9178e-010;
	   16 : time_period = 8.8657e-010;
	   17 : time_period = 8.8201e-010;
	   18 : time_period = 8.7874e-010;
	   19 : time_period = 8.7472e-010;
	   20 : time_period = 8.7008e-010;
	   21 : time_period = 8.6691e-010;
	   22 : time_period = 8.6323e-010;
	   23 : time_period = 8.5876e-010;
	   24 : time_period = 8.5409e-010;
	   25 : time_period = 8.4889e-010;
	   26 : time_period = 8.4482e-010;
	   27 : time_period = 8.4071e-010;
	   28 : time_period = 8.374e-010;
	   29 : time_period = 8.3306e-010;
	   30 : time_period = 8.2962e-010;
	   31 : time_period = 8.2619e-010;
	   32 : time_period = 8.2238e-010;
	   33 : time_period = 8.1733e-010;
	   34 : time_period = 8.145e-010;
	   35 : time_period = 8.1127e-010;
	   36 : time_period = 8.0812e-010;
	   37 : time_period = 8.0408e-010;
	   38 : time_period = 8.0014e-010;
	   39 : time_period = 7.9724e-010;
	   40 : time_period = 7.919e-010;
	   41 : time_period = 7.9091e-010;
	   42 : time_period = 7.8738e-010;
	   43 : time_period = 7.826e-010;
	   44 : time_period = 7.8042e-010;
	   45 : time_period = 7.759e-010;
	   46 : time_period = 7.7267e-010;
	   47 : time_period = 7.6932e-010;
	   48 : time_period = 7.6713e-010;
	   49 : time_period = 7.6333e-010;
	   50 : time_period = 7.606e-010;
	   51 : time_period = 7.5874e-010;
	   52 : time_period = 7.5513e-010;
	   53 : time_period = 7.5081e-010;
	   54 : time_period = 7.4861e-010;
	   55 : time_period = 7.4681e-010;
	   56 : time_period = 7.4138e-010;
	   57 : time_period = 7.3941e-010;
	   58 : time_period = 7.3607e-010;
	   59 : time_period = 7.338e-010;
	   60 : time_period = 7.3006e-010;
	   61 : time_period = 7.2701e-010;
	   62 : time_period = 7.2411e-010;
	   63 : time_period = 7.2161e-010;
	   64 : time_period = 7.2006e-010;
	   65 : time_period = 7.1696e-010;
	   66 : time_period = 7.1391e-010;
	   67 : time_period = 7.1111e-010;
	   68 : time_period = 7.0815e-010;
	   69 : time_period = 7.0543e-010;
	   70 : time_period = 7.0233e-010;
	   71 : time_period = 7.0008e-010;
	   72 : time_period = 6.9736e-010;
	   73 : time_period = 6.9532e-010;
	   74 : time_period = 6.9333e-010;
	   75 : time_period = 6.8975e-010;
	   76 : time_period = 6.8726e-010;
	   77 : time_period = 6.8486e-010;
	   78 : time_period = 6.8244e-010;
	   79 : time_period = 6.7982e-010;
	   80 : time_period = 6.7821e-010;
	   81 : time_period = 6.7575e-010;
	   82 : time_period = 6.7314e-010;
	   83 : time_period = 6.7104e-010;
	   84 : time_period = 6.6872e-010;
	   85 : time_period = 6.6609e-010;
	   86 : time_period = 6.6446e-010;
	   87 : time_period = 6.6115e-010;
	   88 : time_period = 6.5929e-010;
	   89 : time_period = 6.569e-010;
	   90 : time_period = 6.5428e-010;
	   91 : time_period = 6.5189e-010;
	   92 : time_period = 6.4969e-010;
	   93 : time_period = 6.473e-010;
	   94 : time_period = 6.4558e-010;
	   95 : time_period = 6.4475e-010;
	   96 : time_period = 6.4161e-010;
	   97 : time_period = 6.3952e-010;
	   98 : time_period = 6.3833e-010;
	   99 : time_period = 6.3594e-010;
	   100 : time_period = 6.3327e-010;
	   101 : time_period = 6.3194e-010;
	   102 : time_period = 6.2883e-010;
	   103 : time_period = 6.2698e-010;
	   104 : time_period = 6.2487e-010;
	   105 : time_period = 6.2271e-010;
	   106 : time_period = 6.2087e-010;
	   107 : time_period = 6.1886e-010;
	   108 : time_period = 6.1704e-010;
	   109 : time_period = 6.1511e-010;
	   110 : time_period = 6.1344e-010;
	   111 : time_period = 6.1147e-010;
	   112 : time_period = 6.1001e-010;
	   113 : time_period = 6.0776e-010;
	   114 : time_period = 6.0566e-010;
	   115 : time_period = 6.0378e-010;
	   116 : time_period = 6.0162e-010;
	   117 : time_period = 5.9998e-010;
	   118 : time_period = 5.9837e-010;
	   119 : time_period = 5.9663e-010;
	   120 : time_period = 5.9469e-010;
	   121 : time_period = 5.9275e-010;
	   122 : time_period = 5.9097e-010;
	   123 : time_period = 5.8938e-010;
	   124 : time_period = 5.8762e-010;
	   125 : time_period = 5.8602e-010;
	   126 : time_period = 5.8447e-010;
	   127 : time_period = 5.8266e-010;
	   128 : time_period = 5.8195e-010;
	   129 : time_period = 5.7935e-010;
	   130 : time_period = 5.7791e-010;
	   131 : time_period = 5.7585e-010;
	   132 : time_period = 5.7414e-010;
	   133 : time_period = 5.7292e-010;
	   134 : time_period = 5.7089e-010;
	   135 : time_period = 5.6941e-010;
	   136 : time_period = 5.6749e-010;
	   137 : time_period = 5.6597e-010;
	   138 : time_period = 5.6456e-010;
	   139 : time_period = 5.6306e-010;
	   140 : time_period = 5.619e-010;
	   141 : time_period = 5.6035e-010;
	   142 : time_period = 5.5857e-010;
	   143 : time_period = 5.575e-010;
	   144 : time_period = 5.5641e-010;
	   145 : time_period = 5.5402e-010;
	   146 : time_period = 5.5241e-010;
	   147 : time_period = 5.5127e-010;
	   148 : time_period = 5.4955e-010;
	   149 : time_period = 5.4814e-010;
	   150 : time_period = 5.4644e-010;
	   151 : time_period = 5.4507e-010;
	   152 : time_period = 5.4361e-010;
	   153 : time_period = 5.4213e-010;
	   154 : time_period = 5.4076e-010;
	   155 : time_period = 5.3947e-010;
	   156 : time_period = 5.3795e-010;
	   157 : time_period = 5.3733e-010;
	   158 : time_period = 5.3566e-010;
	   159 : time_period = 5.342e-010;
	   160 : time_period = 5.3333e-010;
	   161 : time_period = 5.319e-010;
	   162 : time_period = 5.3009e-010;
	   163 : time_period = 5.2892e-010;
	   164 : time_period = 5.2776e-010;
	   165 : time_period = 5.2608e-010;
	   166 : time_period = 5.2449e-010;
	   167 : time_period = 5.234e-010;
	   168 : time_period = 5.2189e-010;
	   169 : time_period = 5.2063e-010;
	   170 : time_period = 5.1939e-010;
	   171 : time_period = 5.1827e-010;
	   172 : time_period = 5.1701e-010;
	   173 : time_period = 5.1599e-010;
	   174 : time_period = 5.1452e-010;
	   175 : time_period = 5.1339e-010;
	   176 : time_period = 5.1199e-010;
	   177 : time_period = 5.1102e-010;
	   178 : time_period = 5.0971e-010;
	   179 : time_period = 5.0819e-010;
	   180 : time_period = 5.0687e-010;
	   181 : time_period = 5.0583e-010;
	   182 : time_period = 5.0498e-010;
	   183 : time_period = 5.0362e-010;
	   184 : time_period = 5.0216e-010;
	   185 : time_period = 5.0097e-010;
	   186 : time_period = 5.0009e-010;
	   187 : time_period = 4.9895e-010;
	   188 : time_period = 4.9806e-010;
	   189 : time_period = 4.9643e-010;
	   190 : time_period = 4.9523e-010;
	   191 : time_period = 4.9406e-010;
	   192 : time_period = 4.9319e-010;
	   193 : time_period = 4.919e-010;
	   194 : time_period = 4.9123e-010;
	   195 : time_period = 4.8994e-010;
	   196 : time_period = 4.8831e-010;
	   197 : time_period = 4.876e-010;
	   198 : time_period = 4.8633e-010;
	   199 : time_period = 4.8522e-010;
	   200 : time_period = 4.8425e-010;
	   201 : time_period = 4.8316e-010;
	   202 : time_period = 4.8228e-010;
	   203 : time_period = 4.8119e-010;
	   204 : time_period = 4.8026e-010;
	   205 : time_period = 4.789e-010;
	   206 : time_period = 4.7825e-010;
	   207 : time_period = 4.7669e-010;
	   208 : time_period = 4.7597e-010;
	   209 : time_period = 4.7508e-010;
	   210 : time_period = 4.741e-010;
	   211 : time_period = 4.7297e-010;
	   212 : time_period = 4.7184e-010;
	   213 : time_period = 4.7077e-010;
	   214 : time_period = 4.6966e-010;
	   215 : time_period = 4.6861e-010;
	   216 : time_period = 4.6792e-010;
	   217 : time_period = 4.6677e-010;
	   218 : time_period = 4.6589e-010;
	   219 : time_period = 4.6502e-010;
	   220 : time_period = 4.6365e-010;
	   221 : time_period = 4.6312e-010;
	   222 : time_period = 4.6181e-010;
	   223 : time_period = 4.6082e-010;
	   224 : time_period = 4.602e-010;
	   225 : time_period = 4.5933e-010;
	   226 : time_period = 4.5826e-010;
	   227 : time_period = 4.5715e-010;
	   228 : time_period = 4.5625e-010;
	   229 : time_period = 4.5533e-010;
	   230 : time_period = 4.5453e-010;
	   231 : time_period = 4.5358e-010;
	   232 : time_period = 4.5271e-010;
	   233 : time_period = 4.5181e-010;
	   234 : time_period = 4.5094e-010;
	   235 : time_period = 4.5e-010;
	   236 : time_period = 4.4915e-010;
	   237 : time_period = 4.4812e-010;
	   238 : time_period = 4.4724e-010;
	   239 : time_period = 4.4638e-010;
	   240 : time_period = 4.4546e-010;
	   241 : time_period = 4.4459e-010;
	   242 : time_period = 4.4386e-010;
	   243 : time_period = 4.4294e-010;
	   244 : time_period = 4.4214e-010;
	   245 : time_period = 4.4119e-010;
	   246 : time_period = 4.4051e-010;
	   247 : time_period = 4.3968e-010;
	   248 : time_period = 4.3868e-010;
	   249 : time_period = 4.3784e-010;
	   250 : time_period = 4.3707e-010;
	   251 : time_period = 4.362e-010;
	   252 : time_period = 4.3528e-010;
	   253 : time_period = 4.3448e-010;
	   254 : time_period = 4.3372e-010;
	   255 : time_period = 4.3283e-010;
	   256 : time_period = 4.3202e-010;
	   257 : time_period = 4.3114e-010;
	   258 : time_period = 4.3032e-010;
	   259 : time_period = 4.2969e-010;
	   260 : time_period = 4.2874e-010;
	   261 : time_period = 4.2797e-010;
	   262 : time_period = 4.2734e-010;
	   263 : time_period = 4.264e-010;
	   264 : time_period = 4.2579e-010;
	   265 : time_period = 4.2499e-010;
	   266 : time_period = 4.2416e-010;
	   267 : time_period = 4.2342e-010;
	   268 : time_period = 4.2245e-010;
	   269 : time_period = 4.2161e-010;
	   270 : time_period = 4.2084e-010;
	   271 : time_period = 4.2021e-010;
	   272 : time_period = 4.1947e-010;
	   273 : time_period = 4.1876e-010;
	   274 : time_period = 4.1806e-010;
	   275 : time_period = 4.1744e-010;
	   276 : time_period = 4.1669e-010;
	   277 : time_period = 4.1587e-010;
	   278 : time_period = 4.1527e-010;
	   279 : time_period = 4.1451e-010;
	   280 : time_period = 4.1387e-010;
	   281 : time_period = 4.13e-010;
	   282 : time_period = 4.1224e-010;
	   283 : time_period = 4.1157e-010;
	   284 : time_period = 4.1081e-010;
	   285 : time_period = 4.1011e-010;
	   286 : time_period = 4.0944e-010;
	   287 : time_period = 4.0855e-010;
	   288 : time_period = 4.079e-010;
	   289 : time_period = 4.0752e-010;
	   290 : time_period = 4.0691e-010;
	   291 : time_period = 4.0618e-010;
	   292 : time_period = 4.052e-010;
	   293 : time_period = 4.0444e-010;
	   294 : time_period = 4.0406e-010;
	   295 : time_period = 4.0331e-010;
	   296 : time_period = 4.0257e-010;
	   297 : time_period = 4.0169e-010;
	   298 : time_period = 4.0122e-010;
	   299 : time_period = 4.0043e-010;
	   300 : time_period = 4.0006e-010;
	   301 : time_period = 3.9941e-010;
	   default: time_period = 3.9941e-010;
	   
	 endcase
      end // else: !if(Kin4 <= 0)
      
   end // always @ *
   
   
   assign counter_max = time_period / 20e-9;
   

   ////////////////////////////////////////////////////////////////////////////////////

   
   
   
   always  begin
      
      #0.00001;
      

      if (enable_vco  == 0   ) begin
	 vout <= 1;
	 
      end
      else begin
	 if (finished == 1) begin
	    finished <= 0;
	    counter <= counter +0.00001;
            
	 end
	 if (finished == 0) begin
	    
	    
	    if (counter >= counter_max) begin
	       vout <= ~(vout & enable_vco);
	       finished <= 1;
	       counter <=0.00001 ;
	    end
	    else counter <= counter +0.00001;
	 end
      end // else: !if(reset   )
      
   end // always begin
   
   
   
   
endmodule

