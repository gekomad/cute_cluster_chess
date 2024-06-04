#!/bin/bash
#
home=$( cd "$(dirname "$0")"; pwd )/..
epds=`ls $home/epd/*.epd`
 
for eachfile in $epds
do
   a=$(basename $eachfile)
   printf "$a,"
done
 
exit 0
