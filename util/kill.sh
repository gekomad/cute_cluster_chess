#!/bin/bash
#

home=$( cd "$(dirname "$0")"; pwd )/..
 
. $home/cute_main_param    
 
touch $home/STOP_CUTE

killall -s 9 cute.sh cutechess-cli  2>/dev/null
if [[ "$repo" =~ ^git@github.com:.+/(.+).git ]]; then
     engine=${BASH_REMATCH[1]}
     killall -s9 $engine  
fi
rm $tmp_folder/.cutelock
 
exit 0



