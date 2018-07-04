#!/usr/bin/env bash



get_batch() {
    [ "$language" == "cn" ] && echo "不用下载" || echo "Do not download"
}

install_batch() {
	remove_batch
    test_bin batch

    clear
	echo "batch" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功

安装目录：/usr/local/bin/batch

启动：batch

使用说明：根据/etc/hosts文件和免密登陆来进行批量ssh操作
支持对/etc/hosts中的主机分组，需要修改脚本
支持对rm等命令进行禁用，防止批量操作产生影响，需要修改脚本"
	else
		echo "install ok
    
Start：batch

Instructions for use: batch ssh operations based on the /etc/hosts file and free login
Support for grouping hosts in /etc/hosts, need to modify the script
Supports the disablement of commands such as rm to prevent batch operations from affecting the script. You need to modify the script."
	fi
}

remove_batch() {
	rm -rf /usr/local/bin/batch
	test_remove batch
	[ "$language" == "cn" ] && echo "batch卸载完成！" || echo "batch Uninstall completed！"
}

info_batch() {
	if [ "$language" == "cn" ];then
		echo "名字：batch
		
版本：1.2

介绍：跳板机批量操作脚本
		
类型：系统管理

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：batch

Version：1.2

Introduce：Springboard batch operation script

Type: System Management

Author：http://www.52wiki.cn/docs/shell"
	fi
}
