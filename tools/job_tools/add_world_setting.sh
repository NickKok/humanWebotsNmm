#!/bin/bash
path=$2
def="3D.wbt"
world=${3-$def}

#if [[ $1 -eq "coman" ]]
#then
#	ver=${4-"7.3.0"}
#	find $path | grep '.db$' | xargs optiextractor --override-setting=world --override-value=/home/efx/Development/PHD/Coman/Projects/ComanNMM/main/worlds/$3
#	find $path | grep '.db$' | xargs optiextractor --override-setting=webotsPath --override-value=webots7_loadlib
#else
#	find $path | grep '.db$' | xargs optiextractor --override-setting=world --override-value=/home/efx/Development/PHD/Airi/controller_current/webots/worlds/$3
	cd $path
	ls $path | grep '.db' | xargs optiextractor --override-setting=world --override-value=/home/efx/Development/PHD/AiriNew/humanWebotsNmm/controller_current/webots/worlds/$3
	ls $path | grep '.db' | xargs optiextractor --override-setting=webotsPath --override-value=/usr/local/webotsR2018b/webots
	ver=${4-"R2018b"}
#fi
#find $path | grep '.db$' | xargs optiextractor --override-setting=mode --override-value=normal
#find $path | grep '.db$' | xargs optiextractor --override-setting=webotsVersion --override-value=$ver
#find $path | grep '.db$' | xargs optiextractor --override-setting=save_for_matlab --override-value=0
#find $path | grep '.db$' | xargs optiextractor --override-setting=save_for_matlab_overwrite --override-value=0
#find $path | grep '.db$' | xargs optiextractor --override-setting=save_for_matlab_folder --override-value=session5/

#for i in `find $path | grep '.db$'`; do
#	echo $i
#	echo 'UPDATE job SET dispatcher="/usr/libexec/liboptimization-dispatchers-2.0/webots";' > /tmp/temp_sqlite.sql
#	sqlite3 $i < /tmp/temp_sqlite.sql
#	rm /tmp/temp_sqlite.sql
#done
