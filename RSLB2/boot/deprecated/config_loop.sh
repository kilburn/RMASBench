#!/bin/bash
#this parameter specifies the algorithm you want to test (DSA and MaxSum are provided by the framework, so if you want you can freely add them fo the array)
algorithms=("DSA")

#this parameter specifies the number of times each single test has to be repeated for every algorithm
repeat=10
#this parameter specifies the communication ranges between agents
ranges=("500000")
#this parameter specifies the time in which the agents start their computation
starts=("20")
#this parameter influences the value distance has in calculating the local utility of the agent for each target (the greater the value, the more distance is considered)
costfac=100.0
#this parameter is the probability that a DSA agent decides to change his assignment
dsa_change_params=("0.7")
#this is the maximum number of edges that there are between a variable and a function in the factorgraph (MaxSum, DSA-R)
number_of_neighbours=("4")
# for example if you put DSA and MaxSum as the algorithm, 2 repetitions, 500, 5000, 50000 as ranges and 20, 30 as start times, the benchmark will execute 12 computations, 2 for each combination of ranges and start times for DSA and 12 computation, 2 for each combination of ranges and start times for MaxSum
