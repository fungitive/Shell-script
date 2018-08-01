#!/bin/bash
#lvs管理器配置，lvs之DR模式
# vim /usr/local/sbin/lvs_nat.sh
echo 1 > /proc/sys/net/ipv4/ip_forward
ipv=/sbin/ipvsadm
vip=192.168.0.108
rs1=192.168.0.133
rs2=192.168.0.34
#添加vip网卡之eth0:0
ifconfig eth0:0 down
ifconfig eth0:0 $vip broadcast $vip netmask 255.255.255.255 up
route add -host $vip dev eth0:0
ipvsadm -C
ipvsadm -A -t 192.168.0.108 -s rr
ipvsadm -a -t 192.168.0.108:80 -r 192.168.0.133 -g
ipvsadm -a -t 192.168.0.108:80 -r 192.168.0.134 -g
#关闭VIP ARP响应
echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce