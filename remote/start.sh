#!/bin/bash
#
DIR=$( cd "$(dirname "$0")"; pwd )
home=$DIR/..
. $home/cute_main_param    
echo "home: $home" 
address="$1"
port="$2"
user="$3"
if [ "$address" == "" ];then 
 rm /tmp/.cutelock
 $home/remote/bash_async.sh "rm cute_cluster_chess_node/tmp/.cutelock;rm cute_cluster_chess_node/STOP_CUTE"
 exit 0
fi

ssh -p $port $user@$address -o ConnectTimeout=10 "rm cute_cluster_chess_node/tmp/.cutelock;rm cute_cluster_chess_node/STOP_CUTE"
exit 0


