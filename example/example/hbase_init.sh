#!/bin/bash
# create hbase table using hbase shell
#
HSHELL="hbase shell -n"
pushd $WORKDIR
echo -e "create 'SrcCompany', 'f'" | $HSHELL
echo -e "create 'analyze.company.0', 'f'" | $HSHELL
echo -e "create 'analyze.company.1', 'f'" | $HSHELL
echo -e "create 'analyze.company.2', 'f'" | $HSHELL
echo -e "create 'analyze.company.3', 'f'" | $HSHELL
echo -e "create 'analyze.company.4', 'f'" | $HSHELL
echo -e "create 'analyze.company.6', 'f'" | $HSHELL
echo -e "create 'analyze.companycategory.0', 'f'" | $HSHELL
echo -e "create 'analyze.companycategory.1', 'f'" | $HSHELL
echo -e "create 'analyze.companycategory.2', 'f'" | $HSHELL
echo -e "create 'analyze.companycategory.3', 'f'" | $HSHELL
echo -e "create 'analyze.companycategory.4', 'f'" | $HSHELL
echo -e "create 'analyze.companycategory.6', 'f'" | $HSHELL
echo -e "create 'analyze.companycert.0', 'f'" | $HSHELL
echo -e "create 'analyze.companycert.1', 'f'" | $HSHELL
echo -e "create 'analyze.companycert.2', 'f'" | $HSHELL
echo -e "create 'analyze.companycert.3', 'f'" | $HSHELL
echo -e "create 'analyze.companycert.4', 'f'" | $HSHELL
echo -e "create 'analyze.companycert.6', 'f'" | $HSHELL
echo -e "create 'analyze.product.0', 'f'" | $HSHELL
echo -e "create 'analyze.product.1', 'f'" | $HSHELL
echo -e "create 'analyze.product.2', 'f'" | $HSHELL
echo -e "create 'analyze.product.3', 'f'" | $HSHELL
echo -e "create 'analyze.product.4', 'f'" | $HSHELL
echo -e "create 'analyze.product.6', 'f'" | $HSHELL
echo -e "create 'crawler.source', 'f'" | $HSHELL
echo -e "create 'web.capability', 'f'" | $HSHELL
echo -e "create 'web.capabilitydesc', 'f'" | $HSHELL
echo -e "create 'web.company', 'f'" | $HSHELL
echo -e "create 'web.companycategory', 'f'" | $HSHELL
echo -e "create 'web.companycertification', 'f'" | $HSHELL
echo -e "create 'web.companycontact', 'f'" | $HSHELL
echo -e "create 'web.product', 'f'" | $HSHELL
echo -e "create 'web.productdesc', 'f'" | $HSHELL
echo -e "create 'web.productfeature', 'f'" | $HSHELL
echo -e "create 'web.productsku', 'f'" | $HSHELL
echo -e "create 'web.inquirement', 'f'" | $HSHELL
popd
