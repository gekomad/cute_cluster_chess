#!/bin/bash
#
DIR=$( cd "$(dirname "$0")"; pwd )
$DIR/bash_async.sh "rm cute_cluster_chess_node/tmp/.cutelock;rm cute_cluster_chess_node/STOP_CUTE"
 
exit 0

