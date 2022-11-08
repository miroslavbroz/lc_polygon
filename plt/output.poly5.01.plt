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

set arrow from 0,0,0 to s1__,s2__,s3__ front lc 'orange'
set arrow from 0+0.01,0,0 to o1__+0.01,o2__,o3__ front lc 'blue'

sp \
  "<./poly.awk output.poly5.01" u 4:5:6 w lp not,\
  "<./poly.awk output.poly5.01 | awk '($1==88) || (NF==0)'" u 4:5:6 w l lw 3 lc 'black',\

pa -1

set term png small size 1024,1024
set out "output.poly5.01.png"
rep

q

  "<./poly.awk output.poly5.49" u 4:5:6 w lp not,\
  "<./poly.awk output.poly5.50" u 4:5:6 w lp not,\
  "<./poly.awk output.poly5.99" u 4:5:6 w lp not,\
  "<./poly.awk output.poly5.49 | awk '($1==88) || (NF==0)'" u 4:5:6 w l lw 3 lc 'black',\
  "<awk '(NR>1)' output.centre.49" u 2:3:4:1 w labels tc 'brown' not,\


