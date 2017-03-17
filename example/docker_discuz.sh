#!/bin/bash
#docker deploy  discuz
#author liuwei
mysql_password=asd.1234
if rpm -qa |grep docker;  then
  echo  "docker is installed"
else
  yum install -y docker
  systemctl start docker
  systemctl enable docker
fi

docker  pull  mysql
docker run --name mysql -e MYSQL_ROOT_PASSWORD=$mysql_password -d mysql
docker  pull  skyzhou/docker-discuz
docker run --name discuz --link mysql:mysql -p 80:80 -d skyzhou/docker-discuz
