#!/bin/bash
echo -n "Input the zabbix_server ip: "
read -a SERVER
HOST=`ifconfig  | grep Bcast | awk '{print $2}' | awk -F":" '{print $2}'`
cd /data/soft/
wget http://jaist.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.4.7/zabbix-2.4.7.tar.gz
useradd zabbix -s /sbin/nologin -M
yum -y install curl curl-devel net-snmp net-snmp-devel perl-DBI php-gd php-xml php-bcmath
tar zxvf zabbix-2.4.7.tar.gz
cd zabbix-2.4.7
./configure --prefix=/data/zabbix  --enable-agent && make && make install
cp misc/init.d/fedora/core5/zabbix_agentd /etc/init.d/
chmod +x /etc/init.d/zabbix_agentd
sed -i 's/ZABBIX_BIN="\/usr\/local\/sbin\/zabbix_agentd"/ZABBIX_BIN="\/data\/zabbix\/sbin\/zabbix_agentd"/g' /etc/init.d/zabbix_agentd
sed -i 's/Server=127.0.0.1/Server='$SERVER'/g' /data/zabbix/etc/zabbix_agentd.conf
#被动模式，允许哪台zabbix服务器连接，如有DNS解析可填主机名
sed -i 's/ServerActive=127.0.0.1/ServerActive='${SERVER}:10051'/g' /data/zabbix/etc/zabbix_agentd.conf
#主动模式，允许向哪台zabbix服务器上报，如有DNS解析可填主机名
sed -i 's/Hostname=Zabbix server/Hostname='$HOST'/g' /data/zabbix/etc/zabbix_agentd.conf
#客户端本机IP，如有DNS解析可填主机名
sed -i 's/# UnsafeUserParameters=0/UnsafeUserParameters=1/g' /data/zabbix/etc/zabbix_agentd.conf
#允许用户自定义参数
sed -i 's/# EnableRemoteCommands=0/EnableRemoteCommands=1/g' /data/zabbix/etc/zabbix_agentd.conf
#允许执行远程命令
cat >>/etc/services<<EOF
zabbix-agent 10050/tcp Zabbix Agent
zabbix-agent 10050/udp Zabbix Agent
zabbix-trapper 10051/tcp Zabbix Trapper
zabbix-trapper 10051/udp Zabbix Trapper
EOF
/etc/init.d/zabbix_agentd start
chkconfig --add zabbix_agentd
chkconfig zabbix_agentd on
lsof -i:10050 && echo "zabbix_agentd install successful!!!"