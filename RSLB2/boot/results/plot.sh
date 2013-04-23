#!/bin/bash
rm advanced_*;
. config_plot.sh
for alg in $alg_values
do
if [[ "$variable_parameter" == "$alg""_"* ]]; then
alg_values=("$alg");
fi
done
if [ "$variable_parameter" == "k" ]; then
	for value in "${parameter_values[@]}"
	do
	all_patterns=("");
	temp=();
		for par in "${additional_parameters[@]}"
		do
		var_name="${par}_values[@]";
		declare -a var_content=( "${!var_name}" )
			for p_value in "${all_patterns[@]}"
				do
				for par_value in "${var_content[@]}"
					do
					all_patterns_value=$p_value;
					if [ $par == "alg" ]; then
						alg=$par_value;
						all_patterns_value=$all_patterns_value"_"$par_value;

					else
						all_patterns_value=$all_patterns_value"_"$par$par_value;
					fi
					temp=( "${temp[@]}" "$all_patterns_value");		
				done	
			done
			all_patterns=( "${temp[@]}" );
			temp=();
		
		done
		dir_arr=();
		for pattern in "${all_patterns[@]}"
		do
			dir_string=$(find *"$pattern"* -maxdepth 0);
			while IFS=' ' read -ra temp_arr;
			do
      				for dir in "${temp_arr[@]}";
				do
         				dir_arr=( "${dir_arr[@]}" "$dir");
      				done
 			done <<< "$dir_string"
		done
		for dir in "${dir_arr[@]}"
			do
			if [[ "$dir" == *"$variable_parameter$value"* ]]; then
				new_dir_arr=( "${new_dir_arr[@]}" "$dir" );
			fi
			done
		for dir in "${new_dir_arr[@]}"
		do
			cd $dir/config;
			alg=$(echo $dir | cut -d'_' -f2);
			first="false";
			second="false";
			third="false";
			for line in `cat $alg.cfg`
			do
				if [ $first == "true" ]; then
					first="false";
					part_one=$line;
				fi
				if [ $second == "true" ]; then
					second="false";
					part_two=$line;
				fi
				if [ $third == "true" ]; then
					third="false";
					part_three=$line;
				fi
				if [[ $line == "base_package"* ]]; then
					first="true";
				fi	
				if [[ $line == "assignment_group"* ]]; then
					second="true";
				fi
				if [[ $line == "assignment_class"* ]]; then
					third="true";
				fi
			done
			cd ..;
			filename=$part_one"_"$part_two"_"$part_three".dat";
			if [ -a $filename ]; then
			touch temp;
			awk -F" " '{if (NR > 2 ) {	extinguishtime=$1
							burning_counter+=$3;
							onceburned=$4;
							destroyed=$5;
							destroyedarea=$6;
							violatedconstraints_counter+=$7;
							computationtime_counter+=$9
							messages_counter+=$11;
							bytemessages_counter+=$12;
							nccc_counter+=$14;
							factor_counter+=$16;
						}
					} END {	
							burning_average=burning_counter/(NR-2);
							violatedconstraints_average=violatedconstraints_counter/(NR-2);
							computationtime_average=computationtime_counter/(NR-2);
							messages_average=messages_counter/(NR-2);
							bytemessages_average=bytemessages_counter/(NR-2);
							nccc_average=nccc_counter/(NR-2);
							factor_average=factor_counter/(NR-2);
						print burning_average " " onceburned " " destroyed " " destroyedarea " " violatedconstraints_average " " computationtime_average " " messages_average " " bytemessages_average " " nccc_average " " factor_average " " extinguishtime}' $filename >> temp;
			
			statline=$value" "$(cat temp);
			echo $statline >> ../advanced_stats_$alg.dat
			statline="";
			rm temp;
			fi
			cd ..;
			
		done	
	for alg in "${alg_values[@]}"
	do
	touch advanced_stats_avg_$alg.dat;
	awk -F" " '{{					burning_counter+=$2;
							burning_array[NR]=$2;
							onceburned_counter+=$3;
							onceburned_array[NR]=$3;
							destroyed_counter+=$4;
							destroyed_array[NR]=$4;
							destroyedarea_counter+=$5;
							destroyedarea_array[NR]=$5;
							violatedconstraints_counter+=$6;
							violatedconstraints_array[NR]=$6;
							computationtime_counter+=$7;
							computationtime_array[NR]=$7;
							messages_counter+=$8;
							messages_array[NR]=$8;
							bytemessages_counter+=$9;
							bytemessages_array[NR]=$9;
							nccc_counter+=$10;
							nccc_array[NR]=$10;
							factor_counter+=$11;
							factor_array[NR]=$11;
							time_counter+=$12;
							time_array[NR]=$12;
						}
					} END {	
							burning_average=burning_counter/NR;
							for(x=1;x<=NR;x++) {burning_variance+=((burning_array[x]-burning_average)^2);}
							burning_deviation=sqrt(burning_variance/NR);
							onceburned_average=onceburned_counter/NR;
							for(x=1;x<=NR;x++) {onceburned_variance+=((onceburned_array[x]-onceburned_average)^2);}
							onceburned_deviation=sqrt(onceburned_variance/NR);
							destroyed_average=destroyed_counter/NR;
							for(x=1;x<=NR;x++) {destroyed_variance+=((destroyed_array[x]-destroyed_average)^2);}
							destroyed_deviation=sqrt(destroyed_variance/NR);
							destroyedarea_average=destroyedarea_counter/NR;
							for(x=1;x<=NR;x++) {destroyedarea_variance+=((destroyedarea_array[x]-destroyedarea_average)^2);}
							destroyedarea_deviation=sqrt(destroyedarea_variance/NR);
							violatedconstraints_average=violatedconstraints_counter/NR;
							for(x=1;x<=NR;x++) {violatedconstraints_variance+=((violatedconstraints_array[x]-violatedconstraints_average)^2);}
							violatedconstraints_deviation=sqrt(violatedconstraints_variance/NR);
							computationtime_average=computationtime_counter/NR;
							for(x=1;x<=NR;x++) {computationtime_variance+=((computationtime_array[x]-computationtime_average)^2);}
							computationtime_deviation=sqrt(computationtime_variance/NR);
							messages_average=messages_counter/NR;
							for(x=1;x<=NR;x++) {messages_variance+=((messages_array[x]-essages_average)^2);}
							messages_deviation=sqrt(messages_variance/NR);
							bytemessages_average=bytemessages_counter/NR;
							for(x=1;x<=NR;x++) {bytemessages_variance+=((bytemessages_array[x]-bytemessages_average)^2);}
							bytemessages_deviation=sqrt(bytemessages_variance/NR);
							nccc_average=nccc_counter/NR;
							for(x=1;x<=NR;x++) {nccc_variance+=((nccc_array[x]-nccc_average)^2);}
							nccc_deviation=sqrt(nccc_variance/NR);
							factor_average=factor_counter/NR;
							for(x=1;x<=NR;x++) {factor_variance+=((factor_array[x]-factor_average)^2);}
							factor_deviation=sqrt(factor_variance/NR);
							time_average=time_counter/NR;
							for(x=1;x<=NR;x++) {time_variance+=((time_array[x]-time_average)^2);}
							time_deviation=sqrt(time_variance/NR);
						print time_average " " time_deviation " " burning_average " " burning_deviation " " onceburned_average " " onceburned_deviation " " destroyed_average " " destroyed_deviation " " destroyedarea_average " " destroyedarea_deviation " " violatedconstraints_average " " violatedconstraints_deviation " " computationtime_average " " computationtime_deviation " " messages_average " " messages_deviation " " bytemessages_average " " bytemessages_deviation " " nccc_average " " nccc_deviation " " factor_average " " factor_deviation}' advanced_stats_$alg.dat >> temp;
	statline=$value" "$(cat temp);
	echo $statline >> advanced_stats_avg_$alg.dat
	statline="";
	rm temp;
	rm advanced_stats_$alg.dat;
	done
done
for alg in "${alg_values[@]}"
do
sed -i '1i K ExtinguishTime  NumBurning BurningDeviation NumOnceBurned OnceBurnedDeviation NumDestroyed DestroyedDeviation TotalAreaDestroyed DestroyedAreaDeviation ViolatedConstraints ViolatedConstraintDeviation ComputationTime ComputationTimeDeviation NumberOfMessages NumberOfMessagesDeviation MessagesInBytes MessagesDeviation AverageNCCC NCCCDeviation FactorgraphMessages FGMessagesDeviation' advanced_stats_avg_$alg.dat
done
for (( i=2; i<22; i++ ))
do
touch plot.gps;
echo "set terminal png" > plot.gps;
echo "set output '$i.png'" >> plot.gps;
#echo "set key autotitle columnhead" >> plot.gps;
echo "set xrange [0:5]" >> plot.gps;
#echo "set xtics 10" >> plot.gps;
echo "set style data errorbars" >> plot.gps;
plot="false";
for alg in "${alg_values[@]}"
do
if [ $alg == "MaxSum2" ]; then
alg_formal="MaxSum";
elif [ $alg == "DSAFactorgraph" ]; then
alg_formal="DSA-R";
else
alg_formal=$alg;
fi
if [ $plot == "true" ]; then
echo -n ", \"advanced_stats_avg_$alg.dat\" using 1:$i:"$(($i+1))" title \"$alg_formal\" w errorbars lw 2" >> plot.gps
else
echo -n "plot \"advanced_stats_avg_$alg.dat\" using 1:$i:"$(($i+1))" title \"$alg_formal\" w errorbars lw 2" >> plot.gps
plot="true";
fi
done
gnuplot plot.gps;
rm plot.gps;
i=$i+1;
done
fi
