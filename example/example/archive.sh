#!/bin/bash
#
# The script try to archive log file to ftp server
# 
FTP_SERVER=10.173.251.156
FTP_USER=ftpuser
FTP_PASSWD=1234.asd
TARGET_DIR=log1

log_path=$1
if [[ "$log_path" == "" ]]; then
	echo no file to upload
	exit 1
fi

if [ ! -f $log_path ]; then
	echo can not upload, file not exists!!!
	exit 1
fi

file_name=`basename $log_path`
#find date
file_str=${file_name//./ }
file_str_array=($file_str)
tmp_date_str=${file_str_array[2]}
date_str=$(date -d "$tmp_date_str" +"%Y-%m-%d")
year_str=$(date -d "$tmp_date_str" +"%Y")
month_str=$(date -d "$tmp_date_str" +"%m")

gzip_file=$file_name.gz
echo --begin gzip file $gzip_file

gzip -c $log_path > $gzip_file

echo --begin upload file to ftp server
ftp -n<<!
open $FTP_SERVER
user $FTP_USER $FTP_PASSWD
binary
hash
mkdir $TARGET_DIR
cd $TARGET_DIR
mkdir $year_str
cd $year_str
mkdir $month_str
cd $month_str
prompt
put $gzip_file
close
bye
!

rm -f $gzip_file
echo -- upload file $gzip_file success.