#!/bin/bash
ngx_root="/data/openresty/nginx"
logs_path="${ngx_root}/logs/"
dest_path="${ngx_root}/logs1/"
logs_names=(log.access log.error cache.access other.access ipinfo.access ipinfo.error nosource.access apierr.access perr.access)
echo current nginx log path is ${logs_path}

mkdir -p ${dest_path}$(date -d "yesterday" +"%Y/%m") > /dev/null 2>&1

num=${#logs_names[@]}
for((i=0;i<num;i++));do
	if [ -f "${logs_path}${logs_names[i]}.log" ]
	then
        mv ${logs_path}${logs_names[i]}.log ${dest_path}$(date -d "yesterday" +"%Y/%m")/${logs_names[i]}.$(date -d "yesterday" +"%Y%m%d").log
	fi
done

#reopen nginx log files
${ngx_root}/sbin/nginx -s reload

for((i=0;i<num;i++));do
		/data/sbin/archive.sh ${dest_path}$(date -d "yesterday" +"%Y/%m")/${logs_names[i]}.$(date -d "yesterday" +"%Y%m%d").log
done

#analysis fail log url
analyze_script=/data/sbin/redis_url.sh
analyze_file=${dest_path}$(date -d "yesterday" +"%Y/%m")/log.access.$(date -d "yesterday" +"%Y%m%d").log

$analyze_script $analyze_file

/data/sbin/parsecount.sh
/data/sbin/nosourcecount.sh

/data/sbin/importdfs.sh ${dest_path}$(date -d "yesterday" +"%Y/%m")/log.access.$(date -d "yesterday" +"%Y%m%d").log
