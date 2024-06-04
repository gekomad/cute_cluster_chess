kill -9 $(ps ax | grep server.py | fgrep -v grep | awk '{ print $1 }')
rm nohup.out 2>/dev/null
nohup ./server.py &
exit 0
