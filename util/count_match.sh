#!/bin/bash
#
DIR=$( cd "$(dirname "$0")"; pwd )
home=$DIR/..
. $home/cute_main_param    
echo "home: $home"
 
find $home/test/  -name "*.pgn"  -exec echo {} \; -exec grep -c Result {} \; 2>/dev/null

