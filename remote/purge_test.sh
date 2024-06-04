#!/bin/bash
#
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
DIR=$( cd "$(dirname "$0")"; pwd )
home=$DIR/..
. $home/cute_main_param    
echo "home: $home"

for var in "$@"
do
    $home/remote/bash_async.sh "rm -rf $home/cute_cluster_chess_node/test/$var"
done
exit 0


