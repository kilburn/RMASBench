#!/bin/bash
. config_single.sh

filename="results/test/RSLBench_AAMAS12_$alg.dat";
for (( i=2; i<=16; i++ ))
do
touch plot.gps;
echo "set terminal png" > plot.gps;
echo "set output '$i.png'" >> plot.gps;
echo "set key autotitle columnhead" >> plot.gps;
#echo "set xrange [0:5]" >> plot.gps;
#echo "set xtics 10" >> plot.gps;
echo "set style data lines" >> plot.gps;
echo "plot \"$filename\" using 1:$i w lines lw 2" >> plot.gps
gnuplot plot.gps;
rm plot.gps
display "$i.png" &
done
