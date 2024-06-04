#!/bin/bash
#
address="$1"
user="$2"
port="$3"
cpus="$4"
if [ "$cpus" == "" ];then echo "error address user port cpus not found";exit 1;fi

DIR=$( cd "$(dirname "$0")"; pwd )
home=$DIR/..
. $home/cute_main_param    
echo "home: $home"
home_node="cute_cluster_chess_node"
ssh -o ConnectTimeout=5 -p $port $user@$address "mkdir -p $home_node/tmp "

#rsync -r -e "ssh -p $port" $home/util $home/cute.sh $home/epd $home/cute_main_param $user@$address:$home_node
timeout -s9 20  scp -P $port -r $home/util $home/cute.sh $home/epd $home/cute_main_param $user@$address:$home_node
if [ "$?" != "0" ];then echo "ERROR COMMAND(b): timeout -s9 20  scp -P $port -r $home/util $home/cute.sh $home/epd $home/cute_main_param $user@$address:$home_node ";exit 0;fi
ssh -o ConnectTimeout=5 -p $port $user@$address "echo $cpus > $home_node/max_cpu;chmod +x $home_node/util/* $home_node/cute.sh;touch $home_node/STOP_CUTE; $home_node/util/add_crontab.sh $user"
if [ "$?" != "0" ];then echo  "ERROR COMMAND(c): ssh -o ConnectTimeout=5 -p $port $user@$address 'chmod +x $home_node/util/* $home_node/cute.sh;touch $home_node/STOP_CUTE; $home_node/util/add_crontab.sh $user'  ";exit 0;fi
id=$(ssh -o ConnectTimeout=5 -p $port $user@$address "cat /sys/class/net/*/address|sort|md5sum |cut -c1-6")
echo "OKK|$id"
exit 0


