#!/bin/bash
#
DIR=$( cd "$(dirname "$0")"; pwd )
home=$DIR/..
. $home/cute_main_param    
echo "home: $home"
PATH=$home/remote/:$PATH
ping.sh no_print
count=$?
 
rm -fr $home/tmp/stat $home/tmp/cute_statistics 
mkdir $home/tmp/stat
bash_async.sh "cute_cluster_chess_node/util/statistics.sh"
sleep 1
while :
do
	scp_get_async.sh "cute_cluster_chess_node/tmp/cutstats_??????.ok" $home/tmp/stat
    sleep 0.4
	c=$(find $home/tmp/stat -type f -name 'cutstats_??????.ok' -printf x | wc -c)
    printf " ok: $c... "
	if [ $c == $count ];then break;fi
done
echo
sleep 2
rm $home/tmp/stat/*ok
scp_get_async.sh "cute_cluster_chess_node/tmp/{cutstats_??????,cutstats_??????.ok}" $home/tmp/stat
while :
do
   sleep 0.4
   c=$(find $home/tmp/stat -type f -name 'cutstats_??????.ok' -printf x | wc -c)
   printf " downloaded: $c... "
   if [ $c == $count ];then break;fi
done

 
cat $home/tmp/stat/* >$home/tmp/cute_statistics
cat $home/tmp/cute_statistics
exit 0


