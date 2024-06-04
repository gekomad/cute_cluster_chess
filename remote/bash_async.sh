#!/bin/bash
#
if [ "" ==	 "$1" ] ; then
    	echo "parameter not found"
    	exit 1
fi
user="$2"
if [ "$user" == "" ];then user=$USER;fi
 
DIR=$( cd "$(dirname "$0")"; pwd )
home=$DIR/..
. $home/cute_main_param    
PATH=$PATH:$home/remote
echo "ping..."
ping.sh
count=$?
array=( $ips )
tot="${#array[@]}"
if [[ $count -ne $tot ]]; then
	echo "ping error ************* no changes made ***************"
    if [ "" ==	 "$2" ] ; then
    	exit 1
    fi

fi

IFS=':' 
for ip_port in "${array[@]}"
do
	read -ra newarr <<< $ip_port
	ip=${newarr[0]}
	port=${newarr[1]}
	user=${newarr[2]}
	echo "ssh $user@$ip -p $port "$1""
	nohup ssh -p $port $user@$ip "$1" >/dev/null 2>/dev/null &
done
exit 0
