#!/usr/bin/env bash
yum install -y net-tools
ifconfig eth0 192.168.0.100 netmask 255.255.255.0
ifconfig eth0 192.168.5.40 netmask 255.255.255.0
#设置网关
route add default gw 192.168.0.1

sed -i 's/^BOOTPROTO="dhcp"/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-eth0
cat>>/etc/sysconfig/network-scripts/ifcfg-eth0<<EOF
IPADDR=192.168.0.114
NETMASK=255.255.255.0
GATEWAY=192.168.0.1
DNS1=202.96.128.86
DNS2=8.8.8.8
EOF

cat>>/etc/sysconfig/network-scripts/ifcfg-ens33<<EOF
IPADDR=192.168.0.114
NETMASK=255.255.255.0
GATEWAY=192.168.0.1
DNS1=202.96.128.86
DNS2=8.8.8.8
EOF