# cat ./service_monitor.sh 
#!/bin/bash
#description: monitor user defined service, if service is running then echo running, else echo stoped and start service 
#chkconfig: 2345 98 1
# 每3秒运行一次，检测指定服务是否启动，如没有启动则将服务启动，如启动则不做任何操作，记录操作日志信息
# 此监控脚本运行状态记录日志

# this shell log
monitor_log="/var/log/service_monitor/monitor_$(date +%F).log"   ##此监控脚本运行记录日志

# service info
srv_name=nginx
srv_port=80
srv_start="/sbin/service nginx start" 
srv_log="/var/log/service_monitor/service_status_$(date +%F).log"  ##被监控服务运行状态及处理结果日志

# check service status frequncy
time=3  ##服务检测频率

# mkdir for log files
if [ ! -d /var/log/service_monitor ];then
	/bin/mkdir -m 777 /var/log/service_monitor &>/dev/null
fi


# service monitor 
case $1 in
start)
	line=`/bin/ps aux | grep "service_monitor.sh" | wc -l`  ##检测当前脚本运行状态，如已运行则不再运行，如未运行则运行该脚本
	if [ $line -le 3 ];then
		# monitor service
		echo "service_monitor.sh start Succeed" && echo "$(date +%F_%T) service_monitor.sh start Succeed" >> $monitor_log  ##记录监控脚本运行状态
		while true ;do
			/usr/sbin/ss -tunlp | grep :$srv_port &>/dev/null  ##检测被监控测服务状态
			if [ $? == 0 ];then
				echo "$(date +%F_%T) $srv_name running" >> $srv_log  ##服务正常，记录服务状态日志
			else
				$srv_start &>/dev/null && echo "$(date +%F_%T) $srv_name stoped, start Succeed" >> $srv_log || echo "$(date +%F_%T) $srv_name stoped, start Failed" >> $srv_log  ##服务异常，则启动服务，记录启动结果到日志
			fi
			sleep $time  ##服务检测间隔
		done
	else
		echo "service_monitor.sh running"
	fi
	;;

stop)
	line=`/bin/ps aux | grep "service_monitor.sh" |wc -l`  ##检测当前脚本运行状态，如已运行则停止
	if [ $line -le 3 ];then
		echo "service_monitor.sh stoped"
	else
		pid=`/bin/ps aux | grep "service_monitor.sh" | head -1 | awk '{print $2}'`   ##获取当前脚本pid
		kill $pid
		echo "service_monitor.sh stop Succeed"  && echo "$(date +%F_%T) service_monitor.sh stop Succeed" >> $monitor_log  ##记录监控脚本运行状态
	fi	
	;;
status)
	# this shell status
	line=`/bin/ps aux | grep "service_monitor.sh" | wc -l`   ##检测当前脚本运行状态
	if [ $line -le 3 ];then
		echo "service_monitor.sh stoped"
	else
		echo "service_monitor.sh running"
	fi	
	;;
*)
	echo "usage $basename $0 start|stop|status"
	;;
esac