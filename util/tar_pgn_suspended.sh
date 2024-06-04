#!/bin/bash
#
DIR=$( cd "$(dirname "$0")"; pwd )
home=$DIR/..
. $home/cute_main_param    
echo "home: $home"
tmp_folder="$home/tmp"
rm -fr $tmp_folder/cute_pgn $tmp_folder/cute_pgn_$id.ok $tmp_folder/cute_pgn_??????.tar
mkdir $tmp_folder/cute_pgn
$home/util/suspend_get.sh
 
find $home -name "*.pgn" | grep -f $tmp_folder/suspended.txt |xargs -I {} cp {}  $tmp_folder/cute_pgn/
find $home -name "cute_$id.log" | grep -f $tmp_folder/suspended.txt |xargs -I {} cp {}  $tmp_folder/cute_pgn/
find $home -name "cute_$id.err" | grep -f $tmp_folder/suspended.txt |xargs -I {} cp {}  $tmp_folder/cute_pgn/
tar -cf $tmp_folder/cute_pgn_$id.tar $tmp_folder/cute_pgn 2>/dev/null
touch $tmp_folder/cute_pgn_${id}_tar.ok
touch $tmp_folder/cute_pgn_${id}_download.ok
exit 0

