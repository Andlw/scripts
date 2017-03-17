#!/bin/bash
# mount nfs
#
nfs_server=admin2.inter.htyunwang.com
umount /data/hortal
mount -v -o nfsvers=3 $nfs_server:/data/nfs /data/hortal
