#!/bin/bash
# vim /usr/local/sbin/lvs_dr_rs.sh
vip=192.168.0.108
#添加lo:1
ifconfig lo:1 $vip broadcast $vip netmask 255.255.255.255 up
route add -host $vip lo:1
#关闭VIP ARP响应
echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce