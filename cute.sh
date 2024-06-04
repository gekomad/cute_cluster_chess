#!/bin/bash
#
home=$( cd "$(dirname "$0")"; pwd )
 
mkdir $home/tmp/ 2>/dev/null
. $home/cute_main_param    
 
export PATH=$home/remote:$PATH
(
  flock -n -x 200 || exit 1


	function get_concurrency() {
		let all=$(nproc)
		max_cpu=$(cat $home/max_cpu)
 		
 		if [ "$max_cpu" == "All-1" ]; then  		 
  			let concurrency=$all-1
  			export concurrency
  			return
		fi
		if [ "$max_cpu" == "All" ]; then  		 
  			let concurrency=$all
  			export concurrency
  			return
		fi
		 
    	if (( $max_cpu < $concurrency )); then  		 
  			concurrency=$max_cpu
		fi
 
		if (( $all < $concurrency )); then	
			concurrency=$all
		fi
		export concurrency
   }

  function git_pull() {
    echo "START git_pull SCRIPT $repo ---------------------------------------"
	cd $home/
    git clone $repo 
   
    cd $home/$repo_name  
    git pull --prune 2>/dev/null
	clone_base
    for br in $(git branch --all | grep remote|grep "_test_"); do
      branch_name=$(echo $br | cut -f4 -d"/")
      clone_branch $branch_name
    done
    echo "END git_pull SCRIPT"
  }

  function clone_branch() {
  	branch_name=$1
  
    echo "START clone_branch SCRIPT $branch_name --------------------------------"
    
    echo "branch: $branch_name exe: $test_dir/$branch_name/$path_exe"
    if [ -d "$test_dir/$branch_name/$path_exe" ]; then
      printf " exists!\n"
      return 0
    fi
 
	echo "cp -r $home/$repo_name  $test_dir/$branch_name"
    cp -r $home/$repo_name  $test_dir/$branch_name
    echo "cd $test_dir/$branch_name"
    cd $test_dir/$branch_name
    git checkout "_test_/$branch_name"
    cd $path_src
    pwd
    echo "make_command1 $make_command1"
    $make_command1

  }

  function clone_base() {
  	branch_name="base"
    echo "START clone_branch SCRIPT $branch_name --------------------------------"
    if [ ! -d "$home/base" ]; then
    	mkdir $home/base
  		cp -r $home/$repo_name $home/base
	fi
	cd $home/base/$repo_name
	git checkout base
	git fetch --all;git pull --prune
    cd $path_src

    pwd
    echo "make_command1: $make_command1"
    $make_command1

  }

  function get_last_git_commit() {
	cd "$1"
	echo $(git log -n 1  --oneline |awk -F " " '{print $1}')
  }

  function match() {
  	echo "match func $1"
    dir=$(echo $1 | sed 's/[/]//g')
    pgn_file=$dir-$id.pgn

    cd "$test_dir/$dir"

    echo "START MATCH $test_dir/$dir"

    if [ -f $test_dir/$dir/suspend ]; then
      echo "suspend exists. Exit from MATCH script"
      return 0
    fi
    if [ -f $test_dir/$dir/failed ]; then
      echo "failed exists. Exit from MATCH script"
      return 0
    fi


 	current_games=$(grep Result $pgn_file | grep -v -c "*")
    if [ $current_games -ge $(($tot_match / $n_server)) ]; then
      echo "Played $current_games matches (>= $tot_match/$n_server). Exit from MATCH script"
      return 0
    fi

    # load main cute_main_param from branch
    . $home/cute_main_param
    # override main cute_main_param
    . $repo_name/cute_main_param 2>/dev/null

    write_log=0
    if test -f "$home/ENABLE_DEBUG"; then
      echo " ENABLE_DEBUG"
      write_log=1
    fi
    get_concurrency

	echo "concurrency: $concurrency"

    cutechess_cli="$home/util/cutechess-cli_linux_$arch"


    first=$home/base/$repo_name/$path_exe
    second=$home/test/$dir/$path_exe
    first_commit=$(get_last_git_commit $home/base/$repo_name/$path_src)
    second_commit=$(get_last_git_commit $home/test/$dir/$path_src)
   	echo "first_commit: $first_commit"
   	echo "second_commit: $second_commit"

    opening=""
    if [ "$opening_epd" != "" ];then
    	opening="file=$home/epd/$opening_epd format=epd order=random plies=16"
    fi
    echo "first engine: $first"
    echo "second engine: $second"
    killall -s9 cutechess_cli 2>/dev/null
    parameters=" -repeat -rounds 200 -games 2 -tournament gauntlet \
                $resign $draw $variant \
                -concurrency $concurrency -openings $opening \
                -engine cmd=$first $first_param name="base_$first_commit"\
                -engine cmd=$second $second_param name="${dir}_${second_commit}" \
                -ratinginterval 1 -each option.Hash=$hash_size proto=uci tc=$tc -pgnout $pgn_file "

   date
    echo "$cutechess_cli $parameters"
    if [ $write_log -eq 1 ]; then
      $cutechess_cli $parameters -debug >$home/test/$dir/cute_$id.log 2>$home/test/$dir/cute_$id.err
    else
      $cutechess_cli $parameters >/dev/null 2>/dev/null
    fi

    echo "END MATCH SCRIPT"
  }

  ########### main ################


  . $home/cute_main_param
  export arch=$(uname -i)

  if [ "$arch" == "aarch64" ];then

  	export make_command1="$make_command_aarch64"
  else

  	export make_command1="$make_command_x86_64"
  fi

while true
  do
  if [ -f $home/STOP_CUTE ]; then
    echo "$home/STOP_CUTE exists. Exit!"
    exit 0
  fi


  if [[ "$repo" =~ ^git@github.com:.+/(.+).git ]]; then
    repo_name=${BASH_REMATCH[1]}
    export repo_name=$(echo $repo_name| tr '[:upper:]' '[:lower:]')
    echo "repo_name: $repo_name"
  else
    echo "Invalid URL $url"
    exit 1
  fi
  export test_dir="$home/test"
  echo "test_dir: $test_dir"
  #array=($ips)
  export n_server=1 #"${#array[@]}"
  killall -s 9 cutechess-cli $repo_name 2>/dev/null
  mkdir $test_dir 2>/dev/null
  git_pull

  cd $test_dir
  find $home/test/ -name suspend|sort|cut -f6 -d"/"  >$home/tmp/a
  find $home/test/ -name failed|sort|cut -f6 -d"/"  >>$home/tmp/a
  find $home/test/ -name terminated|sort|cut -f6 -d"/"  >>$home/tmp/a
  sort $home/tmp/a >$home/tmp/susp

  find */ -maxdepth 0  -type d |sed -e "s/\///g" >$home/tmp/a
  sort $home/tmp/a >$home/tmp/all
  cd $home/tmp
  rm a
  comm -23 $home/tmp/all $home/tmp/susp >$home/tmp/active
  dir=$(cat $home/tmp/active |sed -e "s/$/\//g" |sort -R |head -n 1)

  match $dir
  sleep 5
done
) 200>$home/tmp/.cutelock