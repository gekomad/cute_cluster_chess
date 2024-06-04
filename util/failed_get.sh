#!/bin/bash
#
home=$( cd "$(dirname "$0")"; pwd )/..

. $home/cute_main_param    

tmp_folder="$home/tmp"
rm $tmp_folder/failed.txt
find ~/cute_cluster_chess_node/test/ -name failed|sort|cut -f6 -d"/"
find ~/cute_cluster_chess_node/test/ -name failed|sort|cut -f6 -d"/" |  sed  -e 's/^/\//' | sed  -e 's/$/\//' >  $tmp_folder/failed.txt
exit 0

