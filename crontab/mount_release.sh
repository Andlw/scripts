#!/bin/bash
#
#
samba_serv=//172.17.60.104

mount -t cifs $samba_serv/casicloud_release /mnt/casicloud_release -o username=builder,password=1234.asd,uid=jenkins,gid=jenkins
mount -t cifs $samba_serv/mercury_app_release /mnt/mercury_app_release -o username=builder,password=1234.asd,uid=jenkins,gid=jenkins
mount -t cifs $samba_serv/mercury_portal_release /mnt/mercury_portal_release -o username=builder,password=1234.asd,uid=jenkins,gid=jenkins
mount -t cifs $samba_serv/mercury_portal_hotfix /mnt/mercury_portal_hotfix -o username=builder,password=1234.asd,uid=jenkins,gid=jenkins
mount -t cifs $samba_serv/mercury_admin /mnt/mercury_admin -o username=builder,password=1234.asd,uid=jenkins,gid=jenkins
mount -t cifs $samba_serv/mercury_mimas_release /mnt/mimas -o username=builder,password=1234.asd,uid=jenkins,gid=jenkins
mount -t cifs $samba_serv/mercury_image /mnt/mercury_image -o username=builder,password=1234.asd,uid=jenkins,gid=jenkins
