#!/bin/sh

export OMP_NUM_THREADS=4

rm lc.dat
./lc_polygon

#./lc_polygon && ./lc.plt

