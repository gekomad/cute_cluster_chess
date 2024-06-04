kill -9 $(ps ax | grep server.py | fgrep -v grep | awk '{ print $1 }')

