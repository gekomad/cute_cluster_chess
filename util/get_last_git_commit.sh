#!/bin/bash
#

branch=$1
if [ "" ==	 "$branch" ] ; then
    	echo "parameters not found branch"
    	exit 1
fi
home=$( cd "$(dirname "$0")"; pwd )/..
. $home/cute_main_param
[[ "$repo" =~ ^git@github.com:.+/(.+).git ]]
engine=${BASH_REMATCH[1]}
cd $home/test/$branch/
git_and_desc=$(git log -n 1  --oneline |awk -F " " '{print $1"§"$2" "$3" "$4" "$5" "$6" "$7}')
cd $home/base/$engine
base=$(git log -n 1  --oneline |awk -F " " '{print $1}')
echo "$git_and_desc§$base§$repo"

exit 0

