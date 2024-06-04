#!/bin/bash
#
if [ "" ==	 "$1" ] ; then
    echo "parameter not found"
	exit 1
fi
home=$( cd "$(dirname "$0")"; pwd )/..

. $home/cute_main_param    
echo "home: $home"

$home/remote/bash_async.sh "rm cute_cluster_chess_node/test/$1/suspend"
rm $home/tmp/cumulate*
exit 0

