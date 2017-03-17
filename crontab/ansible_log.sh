#!/bin/bash
remote_dir=/data/sbin
src_dir=/data/scripts/clean_log.sh
hosts_dir=/data/scripts
server_host=all
cd $hosts_dir
ansible $server_host -i hosts -u root -m file -a "name=$remote_dir state=directory"
ansible $server_host -i hosts -u root -m copy -a "src=$src_dir dest=$remote_dir mode=a+x"
ansible $server_host -i hosts -u root -m shell -a "$remote_dir/clean_log.sh"
