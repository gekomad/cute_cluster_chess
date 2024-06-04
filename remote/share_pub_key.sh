#!/bin/bash
#
user="$1"
address="$2"
password="$3"
port="$4"

if [ "$port" == "" ];then echo "error user address password port not found";exit 1;fi
 
a=$(ssh -p $port  $user@$address -o ConnectTimeout=5 -o PasswordAuthentication=no exit)
if [ "$a" != "0" ]; then
	sshpass -p $password ssh -o ConnectTimeout=15 -p $port $user@$address "mkdir /home/$user/.ssh"   
	if ! test -f /home/$user/.ssh/id_rsa.pub; then
		ssh-keygen -t rsa -b 4096 -f /home/$user/.ssh/id_rsa -N ''
	fi
	cat /home/$USER/.ssh/id_rsa.pub | sshpass -p $password ssh -o ConnectTimeout=5 -T -p $port $user@$address  "cat >> /home/$user/.ssh/authorized_keys"
	if [ "$?" != "0" ];then echo "ERROR COMMAND(a): cat /home/$user/.ssh/id_rsa.pub | sshpass -p **pass** ssh -o ConnectTimeout=5 -T -p $port $user@$address  \"cat >> /home/$user/.ssh/authorized_keys\"";exit 0;fi
fi

echo "OKK"
exit 0


