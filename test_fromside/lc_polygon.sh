#!/bin/sh

export OMP_NUM_THREADS=4

rm lc.dat
#./lc_polygon
./lc_polygon && ./lc.plt

#./output.poly1.01.plt
#./output.poly2.01.plt
#./output.poly3.01.plt
#./output.poly4.01.plt
#./output.poly5.01.plt

#./output.I_lambda.01.plt

