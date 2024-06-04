#!/bin/bash
#
DIR=$( cd "$(dirname "$0")"; pwd )
home=$DIR/..
. $home/cute_main_param    
echo "home: $home"
$home/remote/bash_async.sh "$home/remote/_suspend_all_local.sh"
rm $home/tmp/cumulate*
exit 0

