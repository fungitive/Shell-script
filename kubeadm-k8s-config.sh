#!/bin/bash
echo -e "\033[31;40m#################Set Hosts#################\033[0m" 
cat <<EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.0.8 master
192.168.0.9 node01
192.168.0.10 node02
EOF

echo -e "\033[31;40m#################Edit Hostname#################\033[0m"
ipaddr=`ip addr|grep "inet 192"|awk '{print $2}'|awk -F '.' '{print $4}'|awk -F '/' '{print $1}'`
echo "$ipaddr"
if [ $ipaddr == "8" ] ; then
    hostnamectl set-hostname master
elif [ $ipaddr == "9" ] ; then
    hostnamectl set-hostname node01
elif [ $ipaddr == "10" ] ; then
    hostnamectl set-hostname node02
fi
echo -e "\033[31;40m#################Shutoff Selinux、firewall、Swap##################\033[0m" 
sed -i "s/^SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
sed -i 's/.*swap.*/#&/' /etc/fstab
systemctl stop firewalld && systemctl disable firewalld
echo -e "\033[31;40m#################Set yum repo##################\033[0m" 
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum makecache
echo -e "\033[31;40m#################Set kubernetes yum repo##################\033[0m" 
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
echo -e "\033[31;40m#################Set bridge##################\033[0m" 
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
###########################Set kenreal########################
#echo "* soft nofile 65536" >> /etc/security/limits.conf
#echo "* hard nofile 65536" >> /etc/security/limits.conf
#echo "* soft nproc 65536"  >> /etc/security/limits.conf
#echo "* hard nproc 65536"  >> /etc/security/limits.conf
#echo "* soft  memlock  unlimited"  >> /etc/security/limits.conf
#echo "* hard memlock  unlimited"  >> /etc/security/limits.conf

echo -e "\033[31;40m#################Installed Basic Software##################\033[0m" 
yum install -y epel-release yum-utils device-mapper-persistent-data lvm2 net-tools conntrack-tools wget vim  ntpdate libseccomp libtool-ltdl >> /dev/null
systemctl enable ntpdate.service
echo '*/30 * * * * /usr/sbin/ntpdate time7.aliyun.com >/dev/null 2>&1' > /tmp/crontab2.tmp
crontab /tmp/crontab2.tmp
systemctl start ntpdate.service
