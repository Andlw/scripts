#!/bin/bash
#thor liuwei
epel_repo=/etc/yum.repos.d/epel.repo
mirrors_url=http://mirrors.aliyun.com/epel/7/x86_64/
interface=/etc/sysconfig/network-scripts/ifcfg-eno1
bridge=/etc/sysconfig/network-scripts/ifcfg-br0
ip_addr=172.17.60.216
gateway=172.17.60.1
netmask=255.255.192.0
dns=172.17.60.100

if  cat /proc/cpuinfo |grep -i -E '(vmx|svm)';  then
  modprobe  kvm
else
  echo  "kvm is not installed"
fi

if [ ! -f $eple_repo ]; then
  echo  "[epel]"  >> $epel_repo
  echo  "name=epel_repo"  >>  $epel_repo
  echo  "baseurl=$mirrors_url"  >>  $epel_repo
  echo  "gpgcheck=0"  >>  $epel_repo
  yum clean all
fi

yum upgrade device-mapper-libs

##
for pke in { qemu-kvm libvirt libvirt-daemon virt-manager virt-viewer virt-install }
do
  if rpm -qa |grep $pke;  then
    echo  "$pke is install success"
  else
    yum install -y $pke
  fi
done
systemctl start libvirtd
systemctl enable  libvirtd

if [ -f $interface ]; then
  echo  "TYPE=Ethernet" > $interface
  echo  "NAME=eno1" >>  $interface
  echo  "DEVICE=eno1" >>  $interface
  echo  "ONBOOT=yes"  >>  $interface
  echo  "BRIDGE=br0"  >>  $interface
  echo  "NM_CONTROLLED=no"  >>  $interface
fi

if [ ! -f $bridge ];  then
  echo  "TYPE=Bridge" > $bridge
  echo  "BOOTPROTO=static"  >>  $bridge
  echo  "NAME=br0"  >>  $bridge
  echo  "DEVICE=br0"  >>  $bridge
  echo  "ONBOOT=yes"  >>  $bridge
  echo  "NM_CONTROLLED=no"  >>  $bridge
  echo  "IPADDR=$ip_addr" >>  $bridge
  echo  "NETMASK=$netmask"  >>  $bridge
  echo  "GATEWAY=$gateway"  >>  $bridge
  echo  "DNS1=$dns" >>  $bridge
fi
systemctl restart network

kvm_qcow=/home/data/libvirt/images/kvm_01.qcow2
kvm_iso=/home/data/ios/CentOS-7_x86.iso
vnc_port=5900
vnclisten=0.0.0.0

qemu-img create -o preallocation=metadata -f qcow2 $kvm_qcow 20G
virt-install  --hvm   \
--name kvm_01 \
--ram 1024  \
--vcpus=1 \
-f $kvm_qcow \
--network bridge=br0,model=virtio \
--location  $kvm_iso \
--vnc --vncport=$vnc_port  \
--vnclisten=$vnclisten
