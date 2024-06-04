#!/bin/bash
#
DIR=$( cd "$(dirname "$0")"; pwd )
home=$DIR/..
. $home/cute_main_param    
echo "home: $home" 
address="$1"
port="$2"
user="$3"
if [ "$user" != "" ];then 
 rm /tmp/.cutelock
 $home/remote/bash_async.sh "cute_cluster_chess_node/util/kill.sh"
 exit 0
fi

ssh -p $port $user@$address -o ConnectTimeout=10 "$home/util/kill.sh"
exit 0

