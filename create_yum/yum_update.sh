#!/usr/bin/env bash
#!/bin/bash
datetime=`date +"%Y-%m-%d"`
exec > /var/log/centosrepo.log
reposync -d -r base -p /opt/yum/centos/7/os/
#同步镜像源
if [ $? -eq 0 ];then
    createrepo --update  /opt/yum/centos/7/os/x86_64
    #每次添加新的rpm时,必须更新索引信息
echo "SUCESS: $datetime epel update successful"
else
echo "ERROR: $datetime epel update failed"
fi