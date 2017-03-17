#!/bin/bash
# expose port dynamic to sandbox hdp
#

sandbox_ip=172.18.0.2
iptables -t nat -A  DOCKER -p tcp --dport 6667 -j DNAT --to-destination ${sandbox_ip}:6667
iptables -t nat -A  DOCKER -p tcp --dport 60010 -j DNAT --to-destination ${sandbox_ip}:60010
iptables -t nat -A  DOCKER -p tcp --dport 16020 -j DNAT --to-destination ${sandbox_ip}:16020
iptables -t nat -A  DOCKER -p tcp --dport 50010 -j DNAT --to-destination ${sandbox_ip}:50010
iptables -A DOCKER -d ${sandbox_ip} -p tcp --dport 50010 -j ACCEPT -i '!docker0' -o docker0
