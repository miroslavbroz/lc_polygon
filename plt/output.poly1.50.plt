#!/usr/bin/gnuplot

set term x11

set xl "x"
set yl "y"
set zl "z"
set cbl "-"

set cbr [0:]

set view 0,0
set view equal xyz
set xyplane 0.0
set palette gray

sp \
  "<./poly.awk output.poly1.50" u 4:5:6 w lp not,\
  "<./poly.awk output.poly1.50 | awk '($1==44) || (NF==0)'" u 4:5:6 w l lw 3 lc 'black',\

pa -1

set term png small size 1024,1024
set out "output.poly1.50.png"
rep

q

