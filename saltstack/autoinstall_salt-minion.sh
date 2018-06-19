#!/usr/bin/env bash
yum install -y wget
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all && yum makecache
sed -i 's/^#master: salt/master: 192.168.0.23/g' /etc/salt/minion
sed -i 's/^#id:/id: command/g' /etc/salt/minion
systemctl enable salt-minion && systemctl start salt-minion
