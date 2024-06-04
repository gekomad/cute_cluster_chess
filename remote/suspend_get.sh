#!/bin/bash
#
 

home=$( cd "$(dirname "$0")"; pwd )/..
. $home/cute_main_param    

array=( $ips )
first=$array[0]
IFS=':' 
read -ra arr <<< $first
ip=${arr[0]}
port=${arr[1]}
user=${arr[2]}
unset IFS
a=$(ssh -p $port $user@$ip "cute_cluster_chess_node/util/suspend_get.sh")
echo $a
exit 0
