#!/bin/bash
# try to import logs to hdfs
#

# GLOABLE config
#HDFS_SERVER=10.163.106.49	#hd0.molitv.cn
HDFS_SERVER=10.174.196.15  #bc0.molitv.cn
TARGET_DIR=/hdp/logs/parser
TABLE_NAME=parser
FILTER_TABLE_NAME=filter_parser

notify_msg(){
	echo -e "\033[0;32;1m$*\033[0m"
}

alert_msg() {
	echo -e "\033[0;31;1m$*\033[0m"
}

####################Start###################
#check log path

log_path=$1
if [[ "$log_path" == "" ]]; then
	alert_msg no file to upload
	exit
fi

file_name=`basename $log_path`
#find date
file_str=${file_name//./ }
file_str_array=($file_str)
tmp_date_str=${file_str_array[2]}
date_str=$(date -d "$tmp_date_str" +"%Y-%m-%d")
year_str=$(date -d "$tmp_date_str" +"%Y")
month_str=$(date -d "$tmp_date_str" +"%m")

dest_dir="$TARGET_DIR/logdate=$date_str"
dest_path=$dest_dir/$file_name

notify_msg begin upload to hdfs $dest_path

ssh root@$HDFS_SERVER "(su hdfs -c 'hadoop fs -mkdir -p $dest_dir ')"

notify_msg mkdir complete.

cat $log_path | ssh root@$HDFS_SERVER "(su hdfs -c 'hadoop fs -put - $dest_path ')"

notify_msg begin add partition
ssh -tt root@$HDFS_SERVER "/data/sbin/alter_partition.sh $date_str $TABLE_NAME"

notify_msg begin load data into filter table
ssh -tt root@$HDFS_SERVER <<EOF
pushd /data/sbin
sudo -u hdfs /data/sbin/load_data.sh $date_str $TABLE_NAME $FILTER_TABLE_NAME
popd
exit
EOF
notify_msg upload complete!!!
