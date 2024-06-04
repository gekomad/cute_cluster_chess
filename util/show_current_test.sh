#!/bin/bash
#
DIR=$( cd "$(dirname "$0")"; pwd )
home=$DIR/..
. $home/cute_main_param    
echo "home: $home"
ps -ef|grep "$home/test/"|grep -v auto|grep -v gaunt |cut -f6 -d"/"|uniq
