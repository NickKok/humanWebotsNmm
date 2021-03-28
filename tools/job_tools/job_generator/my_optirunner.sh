#!/bin/bash
speed=$1
name="temp$speed"
filepath="./jobs/$name.xml"
nl=$'\n'
if [ -f $filepath ]
then
rm $filepath
fi
#./job_manager.py -e IP -s $speed 644 > $filepath
./job_manager.py -e FBL -l $speed -s $speed 644 > $filepath

screename="temp$2$speed"
screen -AdmS $screename bash
screen -S $screename -p 0 -X stuff $"optirunner ./jobs/temp$speed.xml${nl}"
echo "Optirunner started on screen temp$speed with file $name located in $filepath"
