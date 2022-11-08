#!/usr/bin/gnuplot

set term x11

set xl "i"
set yl "V0 [mag]"

set yr [:] reverse
set key bottom

set arrow from 50,graph 0 rto 0,graph 1 nohead lt 0

p \
  "lc.dat" u 1:2 w lp,\

pa -1

set term png small
set out "lc.png"
rep

q

  "../../lc_triangle15_thermal/test_2spheres/lc.dat" u 1:2 w lp


