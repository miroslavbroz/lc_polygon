#!/bin/sh

export OMP_NUM_THREADS=4

rm lc.dat
./lc_polygon && ./lc.plt

#./output.poly1.plt
#./output.poly2.plt
#./output.poly3.plt
#./output.poly4.plt
#./output.poly5.01.plt

