#!/bin/bash
#co file
userpasswd=12345678
for i in `seq 1 3`
	do
		ping -c 3 -w 3 192.168.122.1$i > /dev/null
	if
		[ $? -eq 0 ]
	then
		echo "192.168.122.1$i" >> /data/uphost.txt
	fi
/usr/bin/expect << EOF
	spawn ssh 192.168.122.1$i "mkdir -pv /data/web/"
expect {
	"*assword:" { send "$userpasswd\r" }
}
	spawn scp /data/passwd 192.168.122.1$i:/data/web/
expect {
	"*assword:" { send "$userpasswd\r" }
}
expect enf
EOF
	done	
