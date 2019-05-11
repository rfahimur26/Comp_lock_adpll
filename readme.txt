About:
*This is a verilog simulation
*Because the CMOS technology file transfer is forbidden, the circuits (DCO, PFD, TDC etc) are written in behavioral format.
*The topmost verilog file is the tesbench, tb.v . It calls the other modules. In the testbench the PLL divider ratio(N) is changed back and forth.
*There is a scan_chain for input and output. When the divider ratio(N) is changed, it is run through the scan inputs. For scanning in and out scan_input() and scan_output() taskes are called.



Modules:
*top level modules are:
--> vco_ideal(the DCO of the PLL), 
-->pll_connected(contains : the scan_shain, pll_controller)
--> top_level_mux2_1(just a mux used in the top level), 
-->choice1_PFD_TDC(the TDC for PLL),
--> choice2_PFD_backup_tdc(a backup TDC for PLL:not used ),choice3_standalone_PFD(just the PFD for bang bang PLL:not used)

* pll_connected.v instantiates of SCAN-BIST and the controller

* adpll_controller.v does TDC decoding and generates the time edges for computational locking. It also consists of the code for frequency divider with re-snap. adpll_controller.v instantiates "computational" module for comp-locking , "traditional" module for traditional DLF, "dco_decoder" for the DSM module+DCO decoding. There are 3 instantiation of "clk_count_compare". They are for on-chip frequency measurement for BIST. Ignore them.

* "computational.v" incorporates the FSM for computational locking. It also measures X (as the variable "cycle_left"), constitues the data-path for DCO computation. 


 

Instructions:
* Designed for linux environment. You need VCS and DVE to run the simulation.
* For running just write 'make pll' in the linux shell after going to the folder. 
* The PLL starts at divider ratio(N) = 24. It then goes to all the other values of N and comes back to n = 24 ( 24 ->49 ->24 ->48....24->27 24->26 24->25) . 
* The output waveform is start_24.vpd
* The file locktime24.txt stores the locktime for each of the iterations.
* If you want to measure the locktime from other values of N ( for example 30): Open the Makefile, chane initial_N=24 (to initial_N=30)  and start_24.vpd (to start_30.vpd).


How to read the waveform:
*One easy way to see whether the computational lock is completed is opening the verilog waveform . Go to tb -> pll_connected1.  select 'pll_divider2' . This is the value of N. Then  select 'status[5:0]'. status=15 means computational lock is done. "computational.v" defines what each status corresponds to, in case you need to know more. Also you can see the tdc_output(unit : 1ps, 11 means 11ps ):  by clicking the signal 'tdc_out_flopped[10:0]', also you can select "ref_clk", "dco_clk", "gated_dco_clk" to see REFCLK, DCO clock and FBCLK respectively. 
* To see the locktime:  Go to tb -> pll_connected1->bist_scan1. Select locktime. This will see the locktime in cycles.
* For more queries email me at rfahimur26@gmail.com
