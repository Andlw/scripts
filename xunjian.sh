#!/bin/bash
dir=/data/passwd
cat $dir |
while read line
do
	user=`echo $line |awk -F '[:]' '{print $1}'`
	pass=`echo $line |awk -F '[:]' '{print $3}'`
	server=`echo $line |awk -F '[:]' '{print $4}'`
	ping -c 3 -w -3 $server > /dev/null
	if
		[ $? -eq 0 ]
	then
		echo "$server" >> /data/pp.txt
	fi
	/usr/bin/expect <<EOF
	spawn ssh $server "mkdir -p /ddd"
	expect {
		"password:" { send "$pass\r" }
	}
	spawn scp /data/aa $user@$server:/data/web/
	expect {
		"password:" { send "$pass\r" }
	}
	expect eof
EOF
done
