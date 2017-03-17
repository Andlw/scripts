#!/bin/bash
#current nginx log scripts
#author	liuwei
ngx_root="/data/openresty/nginx"
logs_path="${ngx_root}/logs"
dest_path="${ngx_root}/logs"
host=`hostname	|awk -F '[.]' '{print $1}'`
back_dir=`date -d "yesterday" +"%Y/%m"`
back_log=`date -d "yesterday" +"%Y%m%d"`
logs_name=tomcat.access
file_name=`basename ${dest_path}/${back_dir}/${host}.${logs_name}.${back_log}.log`

echo current nginx log path is ${logs_path}
mkdir -p ${dest_path}/${back_dir} > /dev/null 2>&1
if [ -s "${logs_path}/${host}.${logs_name}.log" ]
	then
    mv ${logs_path}/${host}.${logs_name}.log ${dest_path}/${back_dir}/${host}.${logs_name}.${back_log}.log
fi

#reopen nginx log files
${ngx_root}/sbin/nginx -s reload

gzip_file=$file_name.gz
if [ -f ${dest_path}/${back_dir}/${host}.${logs_name}.${back_log}.log ];	then
	gzip -c ${dest_path}/${back_dir}/${host}.${logs_name}.${back_log}.log > $gzip_file
else
	echo	"can not upload, file not exists!!!"
fi

echo --begin upload file to ftp server
if rpm -qa |grep ftp;	then
	echo	"ftp	is install success"
else
	yum install -y ftp
fi
FTP_SERVER="10.17.4.205 4521"
FTP_USER=ftpuser
FTP_PASSWD=1234.asd
TARGET_DIR=log_back
IN_DIR=in_logs
year_str=`date -d "yesterday" +"%Y"`
month_str=`date -d "yesterday" +"%m"`

ftp	-n<<!
open $FTP_SERVER
user $FTP_USER $FTP_PASSWD
binary
bash
mkdir $TARGET_DIR
cd $TARGET_DIR
mkdir $IN_DIR
cd $IN_DIR
mkdir $year_str
cd $year_str
mkdir $month_str
cd $month_str
prompt
put $gzip_file
close
bye
!

rm -rf $gzip_file
#rm -rf ${dest_path}/${back_dir}/${host}.${logs_name}.${back_log}.log
echo	"-- upload file $gzip_file success --"
