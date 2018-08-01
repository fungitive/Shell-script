#!/bin/bash
if rpm -qa wget &>/dev/null;then
    echo -e '\e[32mThe wget Is already installed\e[0m'
else
    yum install -y wget
fi
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
yum makecache && yum update && \
rpm -Uvh http://mirrors.ustc.edu.cn/epel/epel-release-latest-7.noarch.rpm &&yum install -y cobbler cobbler_web
if [ $? -eq 0 ];then
    echo -e '\e[32mThe Cobbler Install Successful!\e[0m'
else
    echo -e '\e[31mThe Cobbler Install Failure!\e[0m'
exit 2
fi
systemctl enable  cobblerd && systemctl start  cobblerd &&\
systemctl enable  tftp && systemctl start  tftp &&\
systemctl enable  httpd && systemctl start  httpd

yum install -y dhcp
if [ $? -eq 0 ];then
    echo -e '\e[32mThe DHCP Install Successful!\e[0m'
    systemctl enable dhcp && systemctl start dhcp
else
    echo -e '\e[31mThe DHCP Install Failure!\e[0m'
    exit 2
fi

sed -i 's/^server: 127.0.0.1/server: 192.168.0.115/' /etc/cobbler/settings
sed -i 's/^next_server: 127.0.0.1/next_server: 192.168.0.115/' /etc/cobbler/settings
sed -i 's/^disable    = yes/disable    = no/'  /etc/xinetd.d/tftp
sed -i 's/^manage_dhcp：0/manage_dhcp：1/' /etc/cobbler/settings
sed -i 's/^manage_tftpd：0/manage_tftpd：1/' /etc/cobbler/settings
sed -i 's/^pxe_just_once：0/pxe_just_once：1/' /etc/cobbler/settings
sed -i 's/^default_password_crypted: "$1$mF86/UHC$WvcIcX2t6crBz2onWxyac./default_password_crypted: "$1$random-p$mzxQ/Sx848sXgvfwJCoZM0/' /etc/cobbler/settings
cobbler get-loaders
openssl passwd -1 -salt 'random-phrase-here' '123456'