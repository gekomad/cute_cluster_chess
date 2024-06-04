#!/bin/bash
#
DIR=$( cd "$(dirname "$0")"; pwd )
. $DIR/../cute_main_param    

array=( $ips )
IFS=':' 
for ip_port in "${array[@]}"
do
	read -ra arr <<< $ip_port
	ip=${arr[0]}
	port=${arr[1]}
	user=${arr[1]}
	if [ "$port" == "" ];then port=22;fi
	timeout -s9 20  scp -P $port $user@$ip:$1 $2
done
exit 0
