#!/bin/bash
#LAMP
#CentOS 7
#author liuwei
discuz=Discuz_X3.3_SC_GBK.zip
epel_repo=/etc/yum.repos.d/epel.repo
discuz_url_repo=http://172.17.60.200/repo

if [ -f $epel_repo ]; then
  echo  "$eple_repo is Existing"
else
  echo  "[epel]"  >>  $epel_repo
  echo  "name=epelrepo" >>  $epel_repo
  echo  "baseurl=http://mirrors.aliyun.com/epel/7/x86_64/"  >>  $epel_repo
  echo  "gpgcheck=0"  >>  $epel_repo
fi

for i in { httpd mariadb mariadb-server mariadb-devel php php-mysql php-gd php-xml php-mbstring }
do
  if rpm -qa |grep $i;  then
    echo  "$i is  install success"
  else
    yum install -y $i
  fi
done
sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf
if lsof -i :80; then
  systemctl restart httpd
else
  systemctl start httpd
  systemctl enable httpd
fi

if lsof -i :3306; then
  echo  "MYSQL is started"
else
  systemctl start mariadb
  systemctl enable mariadb
fi
#set root password
#created discuz database
cd /opt && wget $discuz_url_repo/$discuz && unzip $discuz
cp -r /opt/upload/* /var/www/html
cd /var/www/html && chmod -R 777 *
systemctl stop  firewalld
setenforce  0
