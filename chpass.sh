#!/bin/bash
dir=/data/passwd
cat $dir |
while read line
do 
	user=`echo $line | awk -F '[:]' '{print $1}'`
	pword=`echo $line | awk -F '[:]' '{print $2}'`
	server=`echo $line | awk -F '[:]' '{print $4}'`
	newpass=`echo $line | awk -F '[:]' '{print $3}'`
	/usr/bin/expect << EOF
	spawn ssh $server "echo $newpass |passwd --stdin $user"
	expect {
		"*assword:" { send "$pword\r" }
	} 
	expect eof
EOF
done

