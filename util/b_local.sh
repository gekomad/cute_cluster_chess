DIR=$( cd "$(dirname "$0")"; pwd )
home=$DIR/..
. $home/cute_main_param    
echo "home: $home"
tmp_folder="$home/tmp"
for a in $(find $home/test/ -name "*.pgn"); do
    echo " ----------- $a ------------ "
    pgn-extract -Tr0-1 $a >$tmp_folder/xxb  2>/dev/null
    pgn-extract -Tr1-0 $a >>$tmp_folder/xxb 2>/dev/null
    pgn-extract -Tr1/2-1/2 $a >>$tmp_folder/xxb 2>/dev/null
    ordo -q $tmp_folder/xxb |grep -v advantage |grep -v "^Draw rate"
done
rm $tmp_folder/xxb 2>/dev/null


