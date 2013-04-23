#!/bin/bash
RSL_SIM_PATH=../..
. config_loop.sh
. functions.sh
makeClasspath ../bin/ $RSL_SIM_PATH/lib $RSL_SIM_PATH/jars

for alg in "${algorithms[@]}"
do
algorithm="java -Xmx1024m -javaagent:$RSL_SIM_PATH/jars/SizeOf.jar -cp $CP RSLBench.Launcher -c $DIR/config/$alg.cfg"

killall java;
killall xterm;
 
echo "Compiling the code ....";
cd  ../;
ant clean;
ant;
cd -;
echo "... done.";

echo "Running $alg...";
if [ "$alg" == "DSAFactorgraph" -o "$alg" == "DSA" ]; then
for ((i=0; i<repeat; i+=1))
do
    for neighbours in "${number_of_neighbours[@]}"
	do
	for param in "${dsa_change_params[@]}"
	do
	touch "$alg.cfg"
	echo "!include common.cfg" >>  "$alg.cfg"
	echo "base_package: RSLBench" >>  "$alg.cfg"
	echo "assignment_group: AAMAS12" >>  "$alg.cfg"
	echo "assignment_class: $alg" >>  "$alg.cfg"
	echo "number_of_neighbours: $neighbours" >> "$alg.cfg"
	echo "dsa_change_value_probability: $param" >>  "$alg.cfg"
	if [ "$alg" == "DSAFactorgraph" ]; then
	echo "number_of_targets: all" >> "$alg.cfg"
	else
	echo "number_of_targets: all" >> "$alg.cfg"
	fi
	echo "number_of_cycles: 500" >> "$alg.cfg"
	mv "$alg.cfg" config/ 
        for range in "${ranges[@]}"
        do
                for start in "${starts[@]}"
                do
                params="-ra $range -st $start -cf $costfac"
                echo "Starting episode $i with $params";
                cd ${RSL_SIM_PATH}/boot;
                xterm -T Simulator -e "./benchmark.sh" & 
                sleep 10;
                cd -;
                $algorithm $params;
                killall java;
                killall xterm;
                rdir="results/loop_"$alg"_epi"$i"_range"$range"_k"$neighbours"_param"$param"_start"$start;
                echo "Moving results to $rdir";
                mkdir $rdir;
                mv logs/*.dat $rdir/
		mv assignment.txt $rdir/
                echo "Copying config files to $rdir";
                cp -r config $rdir/
		sleep 10;
		#cd $rdir/config;
		#for line in `cat $alg.cfg`
		#do
		#	if [[ $line == "base_package"* ]]; then
		#		first=`echo $line | cut -d':' -f2`
		#	fi
		#	if [[ $line == "assignment_group"* ]]; then
		#		second=`echo $line | cut -d':' -f2`
		#	fi
		#	if [[ $line == "assignment_class"* ]]; then
		#		third=`echo $line | cut -d':' -f2`
		#	fi
		#done
		#filename=${first}"_"${second}"_"${third}".dat";
		#cd ../../..;
		#for ((j=0; j<11; j+=1))
		#do
		#echo "set terminal png" >> plot.gps;
		#echo "set output \"pic$j.png\"" >> plot.gps;				 
		#echo "plot \"$rdir/RSLBench_AAMAS12_DSA.dat\" using 1:"$(( $j+3 ))" title column("$(( $j+3 ))") w l" >> plot.gps;
		#gnuplot plot.gps;
		#rm plot.gps
		#done
		#mv *.png $rdir/;		
                done
        done
done
done
rm config/$alg.cfg
done
else
for ((i=0; i<repeat; i+=1))
do
for neighbours in "${number_of_neighbours[@]}"
do
	touch "$alg.cfg"
	echo "!include common.cfg" >>  "$alg.cfg"
	echo "base_package: RSLBench" >>  "$alg.cfg"
	echo "assignment_group: AAMAS12" >>  "$alg.cfg"
	echo "assignment_class: $alg" >>  "$alg.cfg"
	echo "number_of_neighbours: $neighbours" >> "$alg.cfg"
	echo "number_of_targets: all" >> "$alg.cfg"
	echo "number_of_cycles: 30" >> "$alg.cfg"
	mv "$alg.cfg" config/ 
                for start in "${starts[@]}"
                do
                params="-st $start -cf $costfac"
                echo "Starting episode $i with $params";
                cd ${RSL_SIM_PATH}/boot;
                xterm -T Simulator -e "./benchmark.sh" & 
                sleep 10;
                cd -;
                $algorithm $params;
                killall java;
                killall xterm;
                rdir="results/loop_"$alg"_epi"$i"_k"$neighbours"_start"$start;
                echo "Moving results to $rdir";
                mkdir $rdir;
                mv logs/*.dat $rdir/
		mv assignment.txt $rdir/
		mv factor_graph.txt $rdir/
		mv tuples_dim.txt $rdir/
                echo "Copying config files to $rdir";
                cp -r config $rdir/
		sleep 10;
		#cd $rdir/config;
		#for line in `cat $alg.cfg`
		#do
		#	if [[ $line == "base_package"* ]]; then
		#		first=`echo $line | cut -d':' -f2`
		#	fi
		#	if [[ $line == "assignment_group"* ]]; then
		#		second=`echo $line | cut -d':' -f2`
		#	fi
		#	if [[ $line == "assignment_class"* ]]; then
		#		third=`echo $line | cut -d':' -f2`
		#	fi
		#done
		#filename=${first}"_"${second}"_"${third}".dat";
		#cd ../../..;
		#for ((j=0; j<11; j+=1))
		#do
		#echo "set terminal png" >> plot.gps;
		#echo "set output \"pic$j.png\"" >> plot.gps;				 
		#echo "plot \"$rdir/RSLBench_AAMAS12_DSA.dat\" using 1:"$(( $j+3 ))" title column("$(( $j+3 ))") w l" >> plot.gps;
		#gnuplot plot.gps;
		#rm plot.gps
		#done
		#mv *.png $rdir/;		
                done
done
done
fi
done
