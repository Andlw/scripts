#!/bin/bash
echo -- begin get openresty from official web site
pushd /data/app
VERSION=1.11.2.2
if [ ! -d ngx_openresty-${VERSION} ]; then
    wget http://openresty.org/download/openresty-${VERSION}.tar.gz
    tar xzvf openresty-${VERSION}.tar.gz
fi

pushd openresty-${VERSION}/
yum install -y readline-devel pcre-devel openssl-devel
./configure --prefix=/data/openresty \
--with-pcre-jit \
--with-cc-opt="-I/usr/local/include" \
--with-ld-opt="-L/usr/local/lib" \
--with-http_stub_status_module
make && make install
popd
popd
