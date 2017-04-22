#!/bin/bash
#
docker run --detach \
    --hostname git.xiaohuruwei.com \
    --publish 8443:443 --publish 8080:80 --publish 2222:22 \
    --name gitlab \
    --restart always \
    --volume /mnt/volumes/gitlab/config:/etc/gitlab \
    --volume /mnt/volumes/gitlab/logs:/var/log/gitlab \
    --volume /mnt/volumes/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
