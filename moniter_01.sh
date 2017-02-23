#!/bin/bash
port_01=`ss -tnl |grep 8080 |awk '{print $4}' |awk -F '[:]' '{print $4}'`
port_02=`ss -tnl |grep 8081 |awk '{print $4}' |awk -F '[:]' '{print $4}'`
port_03=`ss -tnl |grep 8082 |awk '{print $4}' |awk -F '[:]' '{print $4}'`
lsof -i :8080 > /dev/null  && echo "$port_01 is up"  || /usr/local/tmct_01/bin/catalina.sh start
	sleep 3
lsof -i :8081 > /dev/null  && echo "$port_02 is up"  || /usr/local/tmct_02/bin/catalina.sh start
	sleep 3
lsof -i :8082 > /dev/null  && echo "$port_03 is up"  || /usr/local/tmct_03/bin/catalina.sh start

