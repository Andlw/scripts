#!/bin/bash
dir=/data/passwd
sql_bak=/data/`date +%F`
if [ ! -d $sql_bak ]; then
		mkdir -p $sql_bak
	elif rpm -qa |grep expect;	then
		echo	"expect is install success"
	else
		yum install -y expect
fi
cat $dir |
while read line
do
	user=`echo $line |awk -F '[:]' '{print $1}'`
	pass=`echo $line |awk -F '[:]' '{print $3}'`
	serv=`echo $line |awk -F '[:]' '{print $4}'`
	/usr/bin/expect <<EOF
	spawn	scp $user@$serv:/var/log/boot.log $sql_bak/$serv
	expect {
		"password:" { send "$pass\r" }
	}
	expect eof
EOF
done
