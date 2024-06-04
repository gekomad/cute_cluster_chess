#! /bin/bash
#
home=$( cd "$(dirname "$0")"; pwd )/..

. $home/cute_main_param    
echo "home: $home" 

if [ "" ==	 "$1" ] ; then
    echo "parameter not found"
	exit 1
fi

$home/remote/bash_async.sh "cute_cluster_chess_node/util/failed_test.sh $1"
rm $home/tmp/cumulate*
exit 0

