#!/bin/bash
#
home=$( cd "$(dirname "$0")"; pwd )/..
 
. $home/cute_main_param
$home/remote/scp_async.sh $home/cute_main_param cute_cluster_chess_node

array=( $ips )
IFS=':' 
for ip_port in "${array[@]}"
do
	read -ra arr <<< $ip_port
	ip=${arr[0]}
	port=${arr[1]}
	user=${arr[2]}
	echo "$ip $port $user"
	echo "ssh -p $port $home/epd $user@$ip:cute_cluster_chess_node &"
	ssh -p $port $home/epd $user@$ip:cute_cluster_chess_node &
done

exit 0

