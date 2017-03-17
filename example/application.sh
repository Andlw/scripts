#!/bin/bash
#api deploy scripts
#author liuwei
api_pid=`lsof -i :7020 |awk '{print $2}' |tail -1`
jenkins_ip=172.17.60.112
api_remote_dir=/mnt/mercury_app_release/latest
api_name=api-1.0.0-SNAPSHOT.tar
api_dir=api-1.0.0-SNAPSHOT
jenkins_password=1234.asd
jenkins_user=root
datadir=/data
api_conf_file=$datadir/$api_dir/conf/application.properties
server_port=8090
zookeeper=172.17.60.108:2181
mysql_data_url=jdbc:mysql://172.17.60.108:3306/mercury
spring_jpa_naming=org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
if [ ! -d $datadir ]; then
    mkdir -p $datadir
  elif rpm -qa |grep expect;  then
    echo  "expect is install success"
  else
    yum install -y expect
fi
    /usr/bin/expect <<  EOF
    spawn	scp $jenkins_user@$jenkins_ip:$api_remote_dir/$api_name $datadir
  	expect {
  		"password:" { send "$jenkins_password\r" }
  	}
  	expect eof
EOF
cd $datadir && tar xvf $api_name
if [ ! -d $datadir/$api_dir/conf ]
  then
    mkdir -p $datadir/$api_dir/conf
fi

if [ -f $api_conf_file ]; then
  echo  "$api_conf_file is  Existing"
else
  echo "logging.level.*=WARN" >> $api_conf_file
  echo  "logging.file=logs/api.log" >> $api_conf_file
  echo  "server.port=$server_port"  >>  $api_conf_file
  echo  "yunlu.zookeeper=$zookeeper"  >>  $api_conf_file
  echo  "spring.datasource.url=$mysql_data_url" >>  $api_conf_file
  echo  "spring.datasource.username=root" >>  $api_conf_file
  echo  "spring.datasource.password=123456" >>  $api_conf_file
  echo  "spring.datasource.driver-class-name=com.mysql.jdbc.Driver" >> $api_conf_file
  echo  "spring.jpa.database=MYSQL" >>  $api_conf_file
  echo  "spring.jpa.show-sql=true"  >>  $api_conf_file
  echo  "spring.jpa.generate-ddl=true"  >>  $api_conf_file
  echo  "spring.jpa.hibernate.ddl-auto=update"  >>  $api_conf_file
  echo  "spring.jpa.hibernate.naming.physical-strategy=$spring_jpa_naming"  >>  $api_conf_file
  echo  "spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL5Dialect" >>  $api_conf_file
fi

if lsof -i :7020; then
  kill $api_pid
fi
  nohup $datadir/$api_dir/bin/api -c  $api_conf_file &
echo "=======================================FINESHED SUCCESS====================================================="
