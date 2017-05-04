#!/bin/bash
#delete services
#author liuwei

host_name=zk1.inter.htiiot.com
ambari_url=http://admin1.inter.htiiot.com:8080
username=admin
password=admin
cluster_name=htiiot
curl -u $username:$password -H "X-Requested-By: ambari" -X GET $ambari_url/api/v1/clusters/$cluster_name/hosts/$host_name/host_components
curl -u $username:$password -H "X-Requested-By: ambari" -X GDELETE $ambari_url/api/v1/clusters/$cluster_name/hosts/$host_name/host_components
curl -u $username:$password -H "X-Requested-By: ambari" -X GDELETE $ambari_url/api/v1/clusters/$cluster_name/hosts/$host_name
curl -u $username:$password -H "X-Requested-By: ambari" -X DELETE $ambari_url/api/v1/clusters/$cluster_name/hosts/$host_name/host_components
curl -u $username:$password -H "X-Requested-By: ambari" -X DELETE $ambari_url/api/v1/clusters/$cluster_name/hosts/$host_name
