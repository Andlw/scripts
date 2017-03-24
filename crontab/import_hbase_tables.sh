#!/bin/bash
#
hdp_dir="/user/root/backup"
gzip_name="backup-`date -d "yesterday" +%F`.tar.gz"
HOST="172.17.60.104:4521"
USER="liuwei"
PASS="123456"
LCD="/data/backup"
RCD="hdp/hbase"
lftp -c "set ftp:list-options -a;
open ftp://$USER:$PASS@$HOST;
lcd $LCD;
cd $RCD;
get $gzip_name"

repo_dir=/data/repo
cd $LCD
if [ -e $gzip_name ]; then
   tar xvf $gzip_name
   mv $gzip_name $repo_dir
   hadoop fs -copyFromLocal $LCD/* $hdp_dir
else
   echo "$gzip_name is not exists"
fi

rm -rf $LCD/*


web_grps=(
web.capability
web.capabilitydesc
web.company
web.companycategory
web.companycertification
web.companycontact
web.inquirement
web.product
web.imagefile
web.productdesc
web.productfeature
web.productsku
)

analyze_grps=(
analyze.company
analyze.companycategory
analyze.companycert
analyze.product
)

hbase_import="hbase org.apache.hadoop.hbase.mapreduce.Import"

for sum in 0 `seq 11`
do
	hadoop fs -test -d $hdp_dir/${web_grps[$sum]}
	if [ $? -eq 0 ];  then
       		$hbase_import ${web_grps[$sum]} $hdp_dir/${web_grps[$sum]}
     	else
       		echo "${web_grps[$sum]} is not exists"
	fi
        for i in 0 `seq 4` 6
        do
           hadoop fs -test -d $hdp_dir/${analyze_grps[$sum]}.$i
           if [ $? -eq 0 ];  then
             	$hbase_export ${analyze_grps[$sum]}.$i $hdp_dir/${analyze_grps[$sum]}.$i
	           elif [ $sum -gt 3 ];	then
		            continue
	           else
		            echo "${analyze_grps[$sum]}.$i is not exists"
           fi
      done
done

hadoop fs -rm -f -r $hdp_dir/*
