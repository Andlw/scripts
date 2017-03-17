#!/bin/bash
#nginx deploy scripts
#author liuwei
nginx_name=nginx-1.10.0.tar.gz
nginx_dir=nginx-1.10.0
epel_repo=/etc/yum.repos.d/epel.repo
datadir=/data
nginx_repo_url=http://172.17.60.200/repo
mirrors_url=http://mirrors.aliyun.com/epel/7/x86_64/

if [ ! -d $datadir ]; then
  mkdir -p  $datadir
fi
if id nginx > /dev/null;  then
  echo  "nginx  is  created"
else
  useradd -r  nginx
fi

if [ -d $datadir/$nginx_dir ]; then
  echo  "$nginx_dir is  Existing"
else
  cd  $datadir  &&  wget  $nginx_repo_url/$nginx_name && tar xvf $nginx_name
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

for i in { gcc gcc-c++ pcre-devel zlib-devel openssl-devel }
do
  if rpm -qa |grep $i;  then
    echo "$i is install success"
  else
    yum install -y  $i
  fi
done

cd $datadir/$nginx_dir &&  ./configure \
--prefix=/usr/local/nginx \
--sbin-path=/usr/sbin/nginx  \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--user=nginx  \
--group=nginx \
--with-http_ssl_module  \
--with-http_v2_module \
--with-http_dav_module  \
--with-http_stub_status_module  \
--with-threads  \
--with-file-aio &&  make  &&  make  install &&  nginx
