#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
zookeeper_dir=zookeeper



get_zookeeper() {
    test_package http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/zookeeper-3.5.2-alpha.tar.gz adc27d412f283c0dc6ec9d08e30f4ec0
}

install_zookeeper() {
    #检测目录
	remove_zookeeper
    test_dir $zookeeper_dir
    test_rely jdk

    get_zookeeper
    tar -xf   package/zookeeper-3.5.2-alpha.tar.gz
    mv zookeeper-3.5.2-alpha ${install_dir}/${zookeeper_dir}

    #测试
    
    clear
	echo "zookeeper" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${zookeeper_dir}

日志目录：${log_dir}/${zookeeper_dir}"
	else
		echo "install ok
    
Installation manual：${install_dir}/${zookeeper_dir}

Log directory：${log_dir}/${zookeeper_dir}"
	fi
}

remove_zookeeper() {
	rm -rf ${install_dir}/${zookeeper_dir}
	test_remove zookeeper
	[ "$language" == "cn" ] && echo "zookeeper卸载完成！" || echo "zookeeper Uninstall completed！"
}

info_zookeeper() {
	if [ "$language" == "cn" ];then
		echo "名字：zookeeper
		
版本：3.5.2

介绍：ZooKeeper是一个分布式的，开放源码的分布式应用程序协调服务
		
类型：服务

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：zookeeper

Version：3.5.2

Introduce：ZooKeeper is a distributed, open source distributed application coordination service

Type: server

Author：http://www.52wiki.cn/docs/shell"
	fi
}