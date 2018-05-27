#!/usr/bin/env bash
echo -e '\e[31mInstallation tools and dependencies\e[0m'
yum install -y wget make cmake gcc gcc-c++ && \
pcre-devel lib zlib-devel && \
openssl openssl-devel
if [ $? -eq 0 ];then
    echo -e '\e[32mSuccessful!\e[0m'
else
    echo -e '\e[31mFailed\e[0m'
    exit 0
fi
echo -e '\e[31mInstallation nginx\e[0m'
wget http://nginx.org/download/nginx-1.12.2.tar.gz && \
tar -xzvf  nginx-1.12.2.tar.gz && rm -f nginx-1.12.2.tar.gz && cd nginx-1.12.2 &&\
./configure --prefix=/usr/local/nginx && \
make && make install
if [ $? -eq 0 ];then
    echo -e '\e[32mSuccessful!\e[0m'
else
    echo -e '\e[31mFailed\e[0m'
    exit 0
fi
echo -e '\e[31mStart nginx\e[0m'
/usr/local/nginx/sbin/nginx
echo -e '\e[32mSuccessful!\e[0m'