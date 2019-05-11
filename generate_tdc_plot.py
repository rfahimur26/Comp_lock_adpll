#!/usr/bin/python

import re
import sys
import numpy 
import matplotlib.pyplot as plt
import pylab



#write like ./ro_resolution_post.py ro_pll_redefined_all_nand.mt0 ro_pll_redefined.txt index freq period
######################################################################
fr = open("phase_error.txt",'r')


#############################################################



s2  = fr.readlines()
len1 = len(s2)
i=0
main1 = []
p2 = []
p3 = []
p4 = []

num1 = int(sys.argv[1]);
num2 = int(sys.argv[2]);
while(i <= len1-1):
    p1 = re.match(r'.*pll_divider\D*(\d+).*cycle\D*(\d+).*tdc_error\D*\s+(\S+).*',s2[i],re.M|re.I)
    # p1 = re.match(r'(\d+)', s2[i], re.M|re.I)
    if p1:
        # print "match found: ", p1.group()
        # print "match found 1: ", p1.group(1)
        # print "match found 2: ", p1.group(2)
        # print "match found 3: ", p1.group(3)
        p2.append(int(p1.group(1) ) );
        p3.append(int(p1.group(2) ) );
        p4.append(float(p1.group(3) ) );
    else:
        print "no match\n"
    i = i+1
    # print p4;
       
fr.close()



i = 0;
j = 0;
while (i < len(p2) -1):
    # print "i is" , i, "\n";
    if (p2[i] == num1 and p2[i+1] == num2):
        j = i +1;
    i = i + 1;
print "done";
tdc_error = []
k1 = j;
while (p2[k1] == num2):
    tdc_error.append(p4[k1]);
    k1 = k1+1;

print tdc_error

fig = plt.figure(figsize = (10,10))
ax = fig.add_subplot(1,1,1)
pl1 = ax.plot(tdc_error,marker = 'o',color = 'red');
ax.set_xlabel('Code', fontsize = 16, fontweight = 'bold');
ax.set_ylabel('tdc_reading', fontsize = 16, fontweight = 'bold');
plt.show();
#######################################################################


