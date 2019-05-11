#!/usr/bin/python

import re
import sys
import numpy 
import matplotlib.pyplot as plt
import pylab

i = 7;

for i in range(4,46):
    j = (2048/i);
    print  i, ": " " cycle_left_inverse = 12'b", format(j, "012b"), ";";
    # print "\n";
    i = i+1;



