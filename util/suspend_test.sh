#!/bin/bash
#

branch="$1"
if [ "" == "$branch" ] ; then
    	echo "parameters not found branch"
    	exit 1
fi
home=$( cd "$(dirname "$0")"; pwd )/..
. $home/cute_main_param    
echo "home: $home"
 
touch $home/test/$branch/suspend
a=$(ps -ef|grep cutech|grep -c " name=$test ")
if [ "$a" == "1" ]
then
	remove_stop="1"
  	if [ -e $home/STOP_CUTE ]
	then
		remove_stop="0"
	fi
    	$home/kill.sh
	if [ "$remove_stop" == "1" ]
   	then
		rm  $home/STOP_CUTE
	fi
fi
exit 0

