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
	user=${arr[2]}
 
	echo "--------------------------- ssh -p $port $user@$ip "$1"------------------------"
	ssh -p $port $user@$ip "$1"
	echo
done
exit 0
