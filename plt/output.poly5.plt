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
  "<./poly.awk output.poly5" u 4:5:6 w lp not,\
  "<./poly.awk output.poly5 | awk '($1==45) || (NF==0)'" u 4:5:6 w l lw 3 lc 'black',\

pa -1

set term png small size 1024,1024
set out "output.poly5.png"
rep

q

  "<./face.awk output.node output.face | awk '($1==45)'" u 2:3:4 w l lw 1,\
  "<./face.awk output.node output.face | awk '($1==124)'" u 2:3:4 w l lw 1,\
  "<awk '(NR>1)' output.centre" u 2:3:4:1 w labels tc 'brown' not,\

