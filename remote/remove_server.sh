#!/bin/bash
#
 
address="$1"
port="$2"
user="$3"
if [ "$user" == "" ];then 
	echo "parameters not found"
	exit 2
fi
ssh -p $port $user@$address -o ConnectTimeout=10 "rm -fr cute_cluster_chess_node"
exit 0


