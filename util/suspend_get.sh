#!/bin/bash
#
home=$( cd "$(dirname "$0")"; pwd )/..
 
tmp_folder="$home/tmp"
rm $tmp_folder/suspended.txt
find ~/cute_cluster_chess_node/test/ -name suspend|sort|cut -f6 -d"/"
find ~/cute_cluster_chess_node/test/ -name suspend|sort|cut -f6 -d"/" |  sed  -e 's/^/\//' | sed  -e 's/$/\//' >  $tmp_folder/suspended.txt
exit 0

