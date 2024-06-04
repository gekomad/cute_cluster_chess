#!/bin/bash
#
 
branch=$1
if [ "" ==	 "$branch" ] ; then
    	echo "parameters not found branch"
    	exit 1
fi
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
a=$(ssh -p $port $user@$ip "cute_cluster_chess_node/util/get_last_git_commit.sh $branch")
echo $a
exit 0
