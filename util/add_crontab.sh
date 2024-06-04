#!/bin/bash
 
user=$1
function add_crontab_entry() {
 
  ( crontab -l ; echo "$1" ) | crontab -

  echo "Cron entry added successfully!"
}

DIR=$( cd "$(dirname "$0")"; pwd )
. $DIR/../cute_main_param  
a=$(crontab -l|grep /home/$user/cute_cluster_chess_node/cute.sh|grep -v -c "^#")

if [ "$a" == "0" ];then 
	add_crontab_entry "*/1 * * * * /home/$user/cute_cluster_chess_node/cute.sh >> /home/$user/cute_cluster_chess_node/ccc.log 2>&1"
fi
exit 0

