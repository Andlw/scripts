#!/bin/bash
#
back_name=zbox-`date +%F`.tar.gz
dest_path=/mnt/backup/zbox
dest_host=172.17.60.112
zbox_dir=/opt/zbox
$zbox_dir/zbox stop
cd /opt && tar zcf $back_name zbox
/etc/init.d/mysql stop
$zbox_dir/zbox  start

ssh $dest_host "rm  -rf  $dest_path/*"
scp /opt/$back_name $dest_host:$dest_path
rm  -rf /opt/$back_name
