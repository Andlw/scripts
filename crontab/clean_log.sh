#!/bin/bash
#
#clean  log scripts
#author liuwei
log_dir=/var/log
file_size=5M
sum=`find $log_dir -size +$file_size |wc -l`
for i in `seq $sum`
do
    file=`find $log_dir -size +$file_size |head -1`
    rm -rf $file
done
