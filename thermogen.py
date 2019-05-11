#!/usr/bin/python

import re
import sys



out_file = "input.txt";

######################################################################

fw = open(out_file,'w')

#############################################################
i= 0;


for i in range(0,16,1):
    fw.write(str(i) + " : column_decoded[14:0] = 15'b");
    j = 1;
    for j in range(1,16,1):
        if(j <= 15-i):
            fw.write("0");
        else :
            fw.write("1");
    fw.write(";\n");




fw.write(".enddata\n");
fw.close()
