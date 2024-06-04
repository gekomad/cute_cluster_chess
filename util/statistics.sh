#!/bin/bash
#
home=$( cd "$(dirname "$0")"; pwd )/..

. $home/cute_main_param    
echo "home: $home"
tmp_folder="$home/tmp"
rm $tmp_folder/cutstats_$id
load=$(uptime |cut -d" " -f12)
if test -f $home/STOP_CUTE; then
  stopped=true
else
  stopped=false
fi

max_cpu=0
if test -f $home/max_cpu; then
    max_cpu=$(cat $home/max_cpu)
fi

tot_match=$(find  $home/test/  -name "*.pgn" -exec grep -c Result {} \; |awk '{ sum += $1 } END { print sum }')
test=$(ps -ef|grep "$home/test/"|grep round|grep -v color|grep  cutechess|awk -F "$home/test/" '{print $2}' |grep -v "print $2"|uniq|cut -f1 -d"/")
#command=$(ps -ef|grep "$home/test/"|grep round|grep -v color|grep  cutechess|awk -F "cutechess-cli -repeat" '{print "cutechess-cli -repeat "$2}')
command=$(ps -ef|grep "cute_cluster_chess_node/util/cutechess-cli"|grep round|grep -v color)
ip=$(hostname -I)
echo "$id|$ip|$load|$stopped|$tot_match|$test|$max_cpu|$command" |tee $tmp_folder/cutstats_$id
touch $tmp_folder/cutstats_$id.ok
exit 0

