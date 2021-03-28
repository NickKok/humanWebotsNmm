#!/bin/bash
if [ $HOSTNAME == *biorob* ]
then
	folder='/home/dzeladin/Development/sml'
else
	folder='/home/efx/Development/PHD/Airi'
fi
/usr/local/webots644/webots $folder/current/webots/worlds/base644_$1.wbt

