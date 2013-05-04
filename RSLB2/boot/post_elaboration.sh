#!/bin/bash
rdir="results/$1";
echo "Moving results to $rdir";
if [ -e $rdir ]; then
rm -r $rdir;
fi
mkdir $rdir;
mkdir $rdir/config
mv logs/*.dat $rdir/
echo "Copying config files to $rdir";
mv config/$2.cfg $rdir/config/
cp config/common.cfg $rdir/config/
