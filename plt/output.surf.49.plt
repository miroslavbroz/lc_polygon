#!/usr/bin/gnuplot

set term x11
load "output.gnu"

set xl "x"
set yl "y"
set zl "z"
set cbl "surf [m^2]" offset 3,0

set cbr [0:0.2]

set view 90,0
set view equal xyz
set xyplane 0.0
set palette defined (\
  0.0  "black",\
  0.01 "#333333",\
  1.0  "white" \
  )
set surface hidden3d
set pm3d depthorder
set hidden3d front

set arrow from 0,0,0 to s1,s2,s3 front lc 'orange'
set arrow from 0+0.01,0,0 to o1+0.01,o2,o3 front lc 'blue'

sp \
  "<./pm3d.awk output.node.49 output.face.49 output.surf.49" u 1:2:3:5 w pm3d not,\
  "<./poly.awk output.poly5.49" u 4:5:6 w lp lw 1 lc 'green' not,\

pa -1

q


