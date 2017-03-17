#!/bin/bash
#hdfs balancer scripts
cd /home/hdfs
nohup hdfs  balancer -threshold 3 &
