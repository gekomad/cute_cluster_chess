#!/bin/bash
#
DIR=$( cd "$(dirname "$0")"; pwd )
home=$DIR/..
. $home/cute_main_param    
echo "home: $home"

$home/remote/bash_async.sh "find $home/cute_cluster_chess_node/test/ -name suspend -delete"
rm $home/tmp/cumulate*
exit 0

