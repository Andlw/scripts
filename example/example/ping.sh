#!/bin/bash
dir=/data/web/passwd
cat $dir |
while read line
do
	serv=`echo $line |awk -F '[:]' '{print $3}'`
	if ping -c3 -w3 $serv > /dev/null;then
		echo "$serv is up" >> /data/up.txt
	else
		echo "$serv is down" >> /data/down.txt
	fi
done
