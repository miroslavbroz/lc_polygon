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
set palette gray
set surface hidden3d
set pm3d depthorder
set hidden3d front

set arrow from 0,0,0 to s1,s2,s3 front lc 'orange'
set arrow from 0+0.01,0,0 to o1+0.01,o2,o3 front lc 'blue'

sp \
  "<./pm3d.awk output.node.01 output.face.01 output.surf.01" u 1:2:3:5 w pm3d not,\
  "<./poly.awk output.poly5.01" u 4:5:6 w lp lw 1 lc 'green' not,\

pa -1

q

  "<awk '(NR>1)' output.centre" u 2:3:4 w p pt 1 lc 'green' t 'centres',\
  "<awk '(NR>1)' output.centre" u 2:3:4:1 w labels tc 'brown' not,\
  "<awk '(ARGIND==1){ s[$1]=$0; }(ARGIND==2) && (FNR>1){ print s[$1],$0; }' output.centre output.normal" u 2:3:4:6:7:8 w vectors lc 'green' t 'normals'
