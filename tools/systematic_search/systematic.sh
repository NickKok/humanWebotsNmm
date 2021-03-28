#!/bin/bash
A=0
while true; do
	A=`tail -n 1 ../../v2.02/log/systematic_control_rule_${1}.txt.log | perl -pi -e 's/falled at line //'`
	find ../../v2.02/webots/worlds/base_${1}.wbt | xargs perl -pi -e 's/controllerArgs "settings_serie1.xml \d+/controllerArgs "settings_serie'${1}'.xml '$A'/g'
	find ../../v2.02/webots/worlds/base_${1}.wbt | xargs perl -pi -e  's|controllerArgs "settings_serie1.xml "|controllerArgs "settings_serie1.xml 0"|'
	find ../../v2.02/webots/worlds/base_${1}.wbt | xargs perl -pi -e  's|controllerArgs "settings_serie1.xml -1"|controllerArgs "settings_serie1.xml 0"|'
	DISPLAY=:0 webots ../../v2.02/webots/worlds/base_${1}.wbt
	#A=`tail -n 1 ../../v2.02/log/systematic_control_rule_${1}.txt.log | perl -pi -e 's/falled at line //'`
	if( ($A == "") || ($A == "-1")); then
		break;
	fi
	echo A is $A
done

