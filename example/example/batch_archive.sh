#!/bin/bash
#
# The script try to archive log file to ftp server
# 
for f in $(ls /data/openresty/nginx/logs1/2015/10/log.access*.log); do
    ./archive.sh $f
done
