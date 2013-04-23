#! /bin/bash

. functions.sh

processArgs $*

makeClasspath $BASEDIR/lib $BASEDIR/jars

java -Xmx1024m -cp $CP rescuecore2.LaunchComponents sample.SampleFireBrigade*n sample.SampleAmbulanceTeam*n sample.SamplePoliceForce*n sample.SampleCentre*n -c $DIR/config/astar.cfg 2>&1 | tee $LOGDIR/ex2_as-out.log
