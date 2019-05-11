#!/usr/bin/python

import re
import sys



out_file = "input.txt";

######################################################################

fw = open(out_file,'w')

#############################################################


j = 1;
for i in range(29,-1,-1):
    fw.write("assign early_scan" + str(i) + " = " + "early_reg_[" + str(i)  + "];\n" ) ;
fw.write("\n");

j = 13;
for i in range(29,-1,-1):
    fw.write("assign tdc_output_scan" + str(i) + " = " + "tdc_output_reg["  + str(i)  + "];\n" ) ;
fw.write("\n");

j = 20;
for i in range(29,-1,-1):
    fw.write("assign count_aggr_scan" + str(i) + " = " + "count_aggr_reg["  + str(i)  + "];\n" ) ;
fw.write("\n");

j = 14;
for i in range(29,-1,-1):
    fw.write("assign period_change_scan" + str(i) + " = " + "period_change_reg["  + str(i)  + "];\n" ) ;
fw.write("\n");


j = 14;
for i in range(29,-1,-1):
    fw.write("assign corrected_freq_error_scan" + str(i) + " = " + "corrected_freq_error_reg[" + str(i)  + "];\n" ) ;
fw.write("\n");

j = 13;
for i in range(29,-1,-1):
    fw.write("assign dco_input_scan" + str(i) + " = " + "dco_input_reg[" + str(i)  + "];\n" ) ;
fw.write("\n");


j = 6;
for i in range(29,-1,-1):
    fw.write("assign status_scan" + str(i) + " = " + "status_reg["  + str(i)  + "];\n" ) ;
fw.write("\n");


fw.write(".enddata\n");
fw.close()
