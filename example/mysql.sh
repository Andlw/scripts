#!/bin/bash
mysql_name=mysql-5.7.14-linux-glibc2.5-x86_64.tar.gz
mysql_repo_url=http://172.17.60.200/repo
mysql_data=/data/mysql
mysql_dir=mysql-5.7.14-linux-glibc2.5-x86_64
mysql_install_dir=/usr/local/mysql
mysql_config=/etc/my.cnf
mysql_sock=/var/lib/mysql/mysql.sock

if id mysql > /dev/null;  then
  echo  "mysql  is  created"
else
  useradd -r  mysql
fi

if [ ! -d $mysql_data ];  then
  mkdir -p  $mysql_data
  chown -R  mysql.mysql $mysql_data
fi
if [ ! -d $mysql_install_dir ]; then
  mkdir -p  $mysql_install_dir
  chown -R  mysql.mysql $mysql_install_dir
fi
if rpm -qa |grep libaio;  then
  echo  "libaio is  installed"
else
  yum install -y  libaio
fi

if [ -d /opt/$mysql_dir ];  then
  cp -r /opt/$mysql_dir/* $mysql_install_dir
else
  cd /opt && wget $mysql_repo_url/$mysql_name &&  tar xvf $mysql_name
  cp  -r /opt/$mysql_dir/* $mysql_install_dir
fi

cd $mysql_install_dir &&  ./bin/mysqld  \
--initialize  \
--user=mysql  \
--datadir=$mysql_data \
--basedir=$mysql_install_dir  \
--socket=$mysql_sock
cp $mysql_install_dir/support-files/mysql.server /etc/init.d/mysql

rm  -rf $mysql_config > /dev/null
echo  "[client]"  >>  $mysql_config
echo  "port=3306" >>  $mysql_config
echo  "default-character-set=utf8"  >>  $mysql_config
echo  "socket=$mysql_sock"  >>  $mysql_config
echo  "[mysqld]"  >>  $mysql_config
echo  "basedir=$mysql_install_dir"  >>  $mysql_config
echo  "datadir=$mysql_data" >>  $mysql_config
echo  "socket=$mysql_sock"  >>  $mysql_config
echo  "user=mysql"  >>  $mysql_config
echo  "innodb_file_per_table=1" >>  $mysql_config
echo  "skip-grant-tables" >>  $mysql_config
echo  "[mysqld_safe]" >>  $mysql_config
echo  "log-error=/var/log/mysqld.log" >>  $mysql_config
echo  "pid-file=/var/run/mysqld/mysqld.pid" >>  $mysql_config
echo  "export PATH=$mysql_install_dir/bin:$PATH" > /etc/profile.d/mysql.sh

source  /etc/profile.d/mysql.sh
/etc/init.d/mysql start
