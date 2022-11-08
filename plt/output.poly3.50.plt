#!/usr/bin/gnuplot

set term x11
load "output.gnu"

set xl "x"
set yl "y"
set zl "z"
set cbl "-"

set cbr [0:]

set view 0,0
set view equal xyz
set xyplane 0.0
set palette gray

set arrow from 0,0,0 to s1_,s2_,s3_ front lc 'orange'
set arrow from 0+0.01,0,0 to o1_+0.01,o2_,o3_ front lc 'blue'

sp \
  "<./poly.awk output.poly3.50" u 4:5:6 w lp not,\
  "<./poly.awk output.poly3.50 | awk '($1==7) || (NF==0)'" u 4:5:6 w l lw 3 lc 'black',\
  "<./poly.awk output.poly3.50 | awk '($1==7) || (NF==0)'" u 4:5:6:(sprintf(" %s", stringcolumn(3))) w labels left,\

pa -1

q


