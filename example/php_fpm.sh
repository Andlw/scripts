#!/bin/bash
#php-fpm  deploy  scripts
#CentOS 6.7
#author liuwei
php_name=php-5.6.29.tar.gz
php_repo_url=http://172.17.60.200/repo
php_dir=php-5.6.29
epel_repo=/etc/yum.repos.d/epel.repo
datadir=/data
php_install_dir=/usr/local/php
mirrors_url=http://mirrors.aliyun.com/epel/7/x86_64/

if [ ! -d $datadir ];then
  mkdir -p  $datadir
fi

if [ -d $datadir/$php_dir ];  then
  echo  "$php_dir is  Existing"
else
  cd  $datadir  && wget $php_repo_url/$php_name && tar  xvf $php_name
fi

if [ -f $epel_repo ]; then
  echo  "$epel_repo is  Existing"
else
  echo  "[epel]"  >> $epel_repo
  echo  "name=epel_repo"  >>  $epel_repo
  echo  "baseurl=$mirrors_url"  >>  $epel_repo
  echo  "gpgcheck=0"  >>  $epel_repo
  yum clean all
fi

for i in { gcc gcc-c++ php-mysql libxml2-devel gd-devel freetype-devel libmcrypt-devel }
do
  if rpm -qa |grep $i;  then
    echo  "$i is install  success"
  else
    yum install -y  $i
  fi
done

cd $datadir/$php_dir  &&  ./configure \
--prefix=$php_install_dir \
--with-mysql=/usr/local/mysql \
#--with-openssl  \
--with-mysqli=/usr/local/mysql/bin/mysql_config \
--enable-mbstring \
--enable-xml  \
--enable-sockets  \
--enable-fpm  \
--with-freetype-dir \
--with-gd \
--with-libxml-dir=/usr  \
--with-zlib \
--with-jpeg-dir \
--with-png-dir  \
--with-mcrypt \
--with-config-file-path=/etc/php.ini  \
--with-config-file-scan-dir=/etc/php.d
make -j 4  &&  make install

cp $datadir/$php_dir/php.ini-production /etc/php.ini
cd $php_install_dir/etc && mv php-fpm.conf.default  php-fpm.conf
cp $datadir/$php_dir/sapi/fpm/init.d.php-fpm /etc/rc.d/init.d/php-fpm
/etc/rc.d/init.d/php-fpm start
