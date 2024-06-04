#!/bin/bash
#
address="$1"
port="$2"
user="$3"
if [ "$user" == "" ];then echo "error address not found";exit 1;fi
res=$(ssh -p $port $user@$address -o ConnectTimeout=1 "ls -l cute.sh |wc -l")
echo $res
if [ "$res" == "1" ];then 
	echo "ok";
	exit 1
fi
echo "ko"
exit 0

