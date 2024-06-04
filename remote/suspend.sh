#! /bin/bash
#
branch="$1"
if [ "" ==	 "$branch" ] ; then
    echo "parameter not found branch"
	exit 1
fi
home=$( cd "$(dirname "$0")"; pwd )/..
 
. $home/cute_main_param    
echo "home: $home"

$home/remote/bash_async.sh "cute_cluster_chess_node/util/suspend_test.sh $branch"
rm $home/tmp/cumulate*
exit 0

