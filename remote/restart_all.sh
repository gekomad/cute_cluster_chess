#!/bin/bash
#
DIR=$( cd "$(dirname "$0")"; pwd )
. $DIR/../cute_main_param    

$home/remote/kill.sh
sleep 2
$home/remote/start.sh
touch /tmp/restart_all
exit 0

