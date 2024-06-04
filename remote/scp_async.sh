#!/bin/bash
#
if [ "" ==	 "$2" ] ; then
    	echo "parameters not found from to"
    	exit 1
fi
DIR=$( cd "$(dirname "$0")"; pwd )
home=$DIR/..
. $home/cute_main_param    

$DIR/ping.sh
count=$?
array=( $ips )
tot="${#array[@]}"
IFS=':' 
if [[ $tot -ne $count ]]; then
	echo "ping error"
    exit 1
fi

for ip_port in "${array[@]}"
do
	read -ra arr <<< $ip_port
	ip=${arr[0]}
	port=${arr[1]}
	user=${arr[2]}
	timeout -s9 20 scp -r -P $port $1 $user@$ip:$2 &
done
exit 0
