#!/bin/bash
#
repo="$1"
if [ "" ==	 "$repo" ] ; then
    	echo "parameter not found repo"
    	exit 1
fi
if [[ "$repo" =~ ^git@github.com:.+/(.+).git ]]; then
  echo "repo ok"
else
  echo "Invalid URL must start with git@github.com:"
  exit 2
fi
dir="/tmp/df00daba-d6a7-4d08-a46e-7b39efb4f85b"
rm -fr $dir
mkdir $dir
cd $dir

git clone $repo 
cd *
git branch --all | grep remote|grep "/base$"
res=$?
 
rm -fr $dir
if [ "$res" == "0" ];then
	echo "OK"
	exit 0
fi
echo "KO"
exit 1

