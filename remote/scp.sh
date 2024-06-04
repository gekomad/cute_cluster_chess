#!/bin/bash
#
if [ "" == "$1" ] ; then
    echo "destination not found"
	exit 1
fi
DIR=$( cd "$(dirname "$0")"; pwd )
. $DIR/../cute_main_param    

array=( $ips )
IFS=':' 
myip=$(echo $(hostname -I) | tr -d ' ')
for ip_port in "${array[@]}"
do
	read -ra arr <<< $ip_port
	ip=${arr[0]}
	port=${arr[1]}
	if [ "$port" == "" ];then port=22;fi
 	if [ "$ip" != "$myip" ]; then
		echo "scp -P $port -r $1  $HOME@$ip:$1"
		scp -P $port -r $1 $HOME@$ip:$1
 	fi
done
exit 0
