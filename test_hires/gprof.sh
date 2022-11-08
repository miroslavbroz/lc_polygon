#!/bin/sh

gprof ./lc_polygon gmon.out > gprof.out
less gprof.out

