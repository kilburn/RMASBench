#!/bin/bash
. config_single.sh

filename="results/test/RSLBench_AAMAS12_$alg.dat";
touch plot.gps;
echo "set terminal png" > plot.gps;
echo "set output '$alg.png'" >> plot.gps;
echo "set key autotitle columnhead" >> plot.gps;
echo "set style data lines" >> plot.gps;
echo "set xlabel '# time steps'" >> plot.gps;
echo "plot \"$filename\" using 1:3 w lines lw 2 title '$alg # burning building', \"$filename\" using 1:4 w lines lw 2 title '$alg once burned'" >> plot.gps;
gnuplot plot.gps;
#rm plot.gps
display "$alg.png"
