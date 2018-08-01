#!/bin/bash
#检查apache是否安装
if rpm -q httpd &>/dev/null; then #检查apache的httpd服务是否在rpm安装列表里
    echo "Apache 已经安装."
else
    echo "Apache 还未安装!"
fi
