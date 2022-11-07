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
  "output.poly1" u 4:5:6 w lp not,\

pa -1

q

  "<awk '(NR>1)' output.centre" u 2:3:4:1 w labels tc 'brown' not,\

