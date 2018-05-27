#!/usr/bin/env bash
#准备环境和依赖
yum install epel-release gcc wget make cmake -y && \yum groupinstall "Development tools" -y
yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel zx-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel
#下载安装
wget --no-check-certificate https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tgz && \
tar -xzvf Python-3.6.5.tgz && cd Python-3.6.5 && \
./configure --prefix=/usr/local/python3 && \
make && make install

#创建软连接
ln -s /usr/local/python3/bin/python3 /usr/bin/python3
ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3