#!/bin/bash
#
#author liuwei
back_dir=/data/back/`date -d "yesterday" +"%Y/%m"`
host=172.26.223.109
password=*HTdata#109
dst_dir=/appdata/mysql_bck
auto_copy_mysql() {
	expect -c "set timeout -1;
		spawn scp ${back_dir}/"htiiot-`date -d "yesterday" +"%Y%m%d"`.tar.gz" $host:${dst_dir};
		expect {
			*(yes/no)* {send -- yes\r;exp_continue;}
			*password:* {send -- $password\r;exp_continue;}
			eof	   {exit 0;}
		}"
}

if [ ! -d ${back_dir} ]; then
	mkdir -pv ${back_dir}
fi
	/usr/local/mysql/bin/mysqldump --lock-all-tables -uroot -paaaaaaa htiiot > ${back_dir}/htiiot.sql
pushd ${back_dir}
if [ -f htiiot.sql ]; then
	tar zcvf "htiiot-`date -d "yesterday" +"%Y%m%d"`.tar.gz"  htiiot.sql
	rm -rf htiiot.sql

fi
popd
auto_copy_mysql
