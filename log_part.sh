#!/bin/bash
file01_size=`ls -l /data/logs/tmct_12_01 |awk '{print $5}'`
file02_size=`ls -l /data/logs/tmct_12_02 |awk '{print $5}'`
file03_size=`ls -l /data/logs/tmct_12_03 |awk '{print $5}'`
count=`echo 1024*1024*500 |bc`
log_server=`cat /data/passwd |tail -1 |awk -F '[:]' '{print $3}'`
log_passwd=`cat /data/passwd |tail -1 |awk -F '[:]' '{print $2}'`
if [ $file01_size -gt $count ];then
	/usr/bin/expect <<EOF
	spawn scp /data/logs/tmct_12_01 $log_server:/data/log
	expect {
		"password:" { send "$log_passwd\r" }
}
	expect eof
EOF
	echo " " > /data/logs/tmct_12_01
elif [ $file02_size -gt $count ];then
	/usr/bin/expect <<EOF
	spawn scp /data/logs/tmct_12_02 $log_server:/data/log
	expect {
		"password:" { send "$log_passwd\r" }
}
	expect eof
EOF
	echo " " > /data/logs/tmct_12_02
elif [ $file03_size -gt $count ];then
	/usr/bin/expect <<EOF
	spawn scp /data/logs/tmct_12_03 $log_server:/data/log
	expect {
		"password:" { send "$log_passwd\r" }
}
	expect eof
EOF
	echo " " > /data/logs/tmct_12_03
fi
