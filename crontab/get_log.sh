#!/bin/bash
# gen log from FTP_SERVER
#author liuwei
logs_path=/data/www/html/logs_bak
log_stat_dir=/data/www/log_back/stat_logs
log_www_dir=/data/www/log_back/www_logs
log_in_dir=/data/www/log_back/in_logs
back_dir=`date -d "yesterday" +"%Y/%m"`
back_log=`date -d "yesterday" +"%Y%m%d"`
gzip_file=tomcat.access.$back_log.log.gz
stat_gzip_file=stat.access.$back_log.log.gz

if [ ! -d $log_www_dir/$back_dir ];  then
  mkdir -p  $log_www_dir/$back_dir
elif [ ! -d $log_in_dir/$back_dir ];  then
  mkdir -p $log_in_dir/$back_dir
elif [ ! -d $log_stat_dir/$back_dir ];  then
  mkdir -p $log_stat_dir/$back_dir
fi

for i in  2000 2 2001 2002
do
  if [ $i -le 2000 ]; then
    mv $logs_path/$back_dir/bc$i.$gzip_file $log_www_dir/$back_dir
  else
    mv $logs_path/$back_dir/bc$i.$gzip_file $log_in_dir/$back_dir
  fi
done

mv $logs_path/$back_dir/kf2.$stat_gzip_file $log_stat_dir/$back_dir
