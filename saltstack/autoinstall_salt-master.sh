#!/usr/bin/env bash
yum install -y wget
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all && yum makecache
yum install -y salt-master salt-minion
cat >>/etc/services<<EOF
file_roots:
  base:
    - /srv/salt
pillar_roots:
  base:
    - /srv/pillar
EOF
systemctl enable salt-master && systemctl start master
sed -i 's/^#master: salt/master: 192.168.0.23/g' /etc/salt/minion
sed -i 's/^#id:/id: python/g' /etc/salt/minion
systemctl enable salt-minion && systemctl start salt-minion
