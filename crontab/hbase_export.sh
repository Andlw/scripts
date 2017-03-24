#!/bin/bash
#
#author liuwei
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

hbase_export="hbase org.apache.hadoop.hbase.mapreduce.Export"
back_dir=/user/hbase/backup

for sum in 0 `seq 11`
do
        $hbase_export ${web_grps[$sum]} $back_dir/${web_grps[$sum]}
        for i in 0 `seq 4` 6
        do
           if [ $sum -le 3 ];  then
             $hbase_export ${analyze_grps[$sum]}.$i $back_dir/${analyze_grps[$sum]}.$i
           fi
      done
done
