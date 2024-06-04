#!/bin/bash
#
(
  flock -n -x 200 || exit 1
DIR=$( cd "$(dirname "$0")"; pwd )
home=$DIR/..
. $home/cute_main_param    
echo "home: $home"
export PATH=$home/remote:$PATH
tmp_folder="$home/tmp"
ping.sh no_print
count=$?
if [ "$count" == "0" ];then
	echo "zero nodes, exit."
	exit 0
fi
killall -s9 scp 2>/dev/null
bash.sh "rm $tmp_folder/*ok" 
if [[ "$1" == "failed" ]]
then
    cumulate="$tmp_folder/cumulate_failed"
    bash_async.sh "cute_cluster_chess_node/util/tar_pgn_failed.sh"
elif [[ "$1" == "suspended" ]]
then
    cumulate="$tmp_folder/cumulate_suspended"
    bash_async.sh "cute_cluster_chess_node/util/tar_pgn_suspended.sh"
else
    cumulate="$tmp_folder/cumulate"
    bash_async.sh "cute_cluster_chess_node/util/tar_pgn_active.sh"
fi
 
tmp_cute_pgn2="$tmp_folder/cute_pgn2"
rm -fr $tmp_cute_pgn2 $cumulate "${cumulate}_fe"
mkdir -p $tmp_cute_pgn2
while :
do
	scp_get_async.sh "cute_cluster_chess_node/tmp/cute_pgn_??????_tar.ok" $tmp_cute_pgn2
    sleep 0.4
	c=$(find $tmp_cute_pgn2 -type f -name 'cute_pgn_??????_tar.ok' -printf x | wc -c)
    printf " ok: $c... "
	if [ $c == $count ];then break;fi
done
echo
scp_get_async.sh "cute_cluster_chess_node/tmp/{cute_pgn_??????.tar,cute_pgn_??????_download.ok}" $tmp_cute_pgn2
while :
do
   sleep 0.4
   c=$(find $tmp_cute_pgn2 -type f -name 'cute_pgn_??????_download.ok' -printf x | wc -c)
   printf " downloaded: $c... "
   if [ $c == $count ];then break;fi
done

echo "download ok"
cd $tmp_cute_pgn2
for f in *.tar; do tar -xf "$f" ; done
 
cd $tmp_cute_pgn2/tmp/cute_pgn/
rm $tmp_folder/res1 2>/dev/null
a=$(find ./ -type f -size +40c -printf "%f\n" | grep "\.pgn" | rev | cut -f2,3,4,5,6,7,8,9,10 -d"-" | rev | sort -u)
touch $cumulate
mkdir $tmp_folder/pgn 2>/dev/null
for branch in $a; do
    echo " ----------- _test_/$branch ------------ " |tee -a $cumulate
    pwd
    cat $branch-??????.pgn >$tmp_folder/pgn/$branch.pgn
    $home/util/bayeselo.sh $tmp_folder/pgn/$branch.pgn |tee -a $cumulate
    gzip -f $tmp_folder/pgn/$branch.pgn
    err="ERROR:false:"
    if [ -s $home/test/$branch/cute_??????.err ]; then
           a=$(grep Illegal $home/test/$branch/cute_??????.err)
           if [ "$a" != "0" ];then
                   err="ERROR:true:"
           fi
    fi
    echo $err |tee -a $cumulate
done

date
exit 0
) 200>/tmp/.bcutelock

