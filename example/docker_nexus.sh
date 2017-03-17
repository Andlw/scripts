#!/bin/bash
# create repo manager with nexus3
#
# default admin admin123
mkdir -p /data/nexus3
CN_NAME=yunlu_nexus3
docker rm -f $CN_NAME
docker run -d \
        -p 8081:8081 \
        --name $CN_NAME \
        -v /data/nexus3:/nexus-data \
        -e JAVA_MAX_HEAP=1500m \
        sonatype/nexus3
