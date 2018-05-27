#!/bin/bash
#linux不用版本间的安装wget软件的方式
if [ -e /etc/redhat-release ]; then 
#判断如果是redhat就用yum
   yum install wget -y
elif [ $(cat /etc/issue |cut -d' ' -f1) =="Ubuntu" ]; then
#判断如果是ubuntu就用apt-get
   apt-get install wget -y
else
   Operating system does not support.
   exit
fi