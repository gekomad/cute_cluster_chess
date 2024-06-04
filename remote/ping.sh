#!/bin/bash
#

no_print=$1
function print(){
    if [ -z "$no_print" ]; then
        printf "$1"
    fi
}
DIR=$( cd "$(dirname "$0")"; pwd )
. $DIR/../cute_main_param    

array=( $ips )
let count=0
IFS=':'
for ip_port in "${array[@]}"
do
	read -ra newarr <<< $ip_port
	ip=${newarr[0]}
	port=${newarr[1]}
 
    print "$ip"
    timeout 0.2 ping -c1 $ip >/dev/null
    if [[ $? -ne 0 ]]; then
        print " *** KO ***\n"
    else
    	let count="count+1"
        print " ok\n"
    fi
done
exit $count

