

# STDLIB := /home/lab.apps/vlsiapps/kits/tsmc/N65RF/1.0c_cdb/digital/Front_End/verilog/tcbn65gplus_140b/tcbn65gplus.v

clean:
	- rm -rf simv.daidir csrc *.vpd *.log



pll :  tb.v
	-make clean
	-rm  *.txt
	-vcs tb.v  pll_connected.v dco_decoder.v scan_module_adpll.v bist_scan.v scan_cell.v  clk_count_compare.v ./vco.v  adpll_controller.v computational.v traditional.v choice1_PFD_TDC.v top_level_mux2_1.v bist.v choice2_PFD_backup_TDC.v choice3_standalone_PFD.v -R +memcbk -l comp.log -debug_pp -o simv +v2k +lint -sverilog +define+initial_N=24 -full64 -timescale=10ns/100fs 
	-./simv +vpdfile+start_24.vpd +COMPARE -l sim.log
