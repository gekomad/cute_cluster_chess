#!/bin/bash
#
if [ -z "$1" ] || [ ! -f "$1" ]; then
    echo "pgn file not found"
    exit 1
fi
DIR=$( cd "$(dirname "$0")"; pwd )
arch=$(uname -i)
for var in "$@"
do
    echo "$var"
    pgn_out="$var"
    params=/tmp/beparams
    echo "readpgn" $pgn_out >$params
    echo "elo" >>$params
    echo "mm" >>$params
    echo "exactdist" >>$params
    echo "ratings >/tmp/pgn_out.ratings" >>$params
    echo "los >/tmp/pgn_out.los" >>$params
    echo "x" >>$params
    echo "x" >>$params
    $DIR/bayeselo_linux_$arch <$params >/dev/null 2>/dev/null
    printf "\nratings\n"
    cat /tmp/pgn_out.ratings
    printf "\nlos\n"
    cat /tmp/pgn_out.los
done
exit 0
