#!/usr/bin/env bash
rpm -Uvh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-1.el7.centos.noarch.rpm
yum clean all && yum makecache
yum install zabbix-agent -y
#修改配置文件
#Server=[zabbix server ip]
#ServerActive=[zabbix server ip]
#Hostname=[ Hostname of client system ]
sed -i 's/Server=127.0.0.1/Server=192.168.0.126/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/ServerActive=127.0.0.1/ServerActive=127.0.0.1/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/Hostname=Zabbix server/Hostname=Apache/' /etc/zabbix/zabbix_agentd.conf

firewall-cmd --zone=public --permanent --add-port=10050-10051/tcp && firewall-cmd --reload

systemctl start zabbix-agent && systemctl enable zabbix-agent