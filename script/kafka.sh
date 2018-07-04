#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志目录
#log_dir=

#服务目录名
kafka_dir=kafka



get_kafka() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/kafka_2.12-0.10.2.1.tgz" "fab4b35ba536938144489105cb0091e0"
}

install_kafka() {
	remove_kafka
    test_dir $kafka_dir
	test_rely jdk
    
    #安装依赖和包
    get_kafka
    tar -xf package/kafka_2.12-0.10.2.1.tgz
    mv kafka_2.12-0.10.2.1 ${install_dir}/${kafka_dir}

    #完成
    clear
	echo "kafka" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${kafka_dir}"
	else
		echo "install ok
    
Installation manual：${install_dir}/${jenkins_dir}"
	fi
}

remove_kafka() {
	rm -rf ${install_dir}/${kafka_dir}
	test_remove kafka
	[ "$language" == "cn" ] && echo "kafka卸载完成！" || echo "kafka Uninstall completed！"
}

info_kafka() {
	if [ "$language" == "cn" ];then
		echo "名字：kafka
		
版本：2.12

介绍：Kafka是由Apache软件基金会开发的一个开源流处理平台
		
类型：服务

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：kafka

Version：2.12

Introduce：Kafka is an open source stream processing platform developed by the Apache Software Foundation

Type: server

Author：http://www.52wiki.cn/docs/shell"
	fi
}