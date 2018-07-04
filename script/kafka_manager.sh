#!/usr/bin/env bash
#kafka-manager，可以用来监控kafka



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
kafka_manager_dir=kafka-manager

#zookeeper集群地址用,分隔
cluster_ip="192.168.2.108:2181,192.168.2.109:2181"

#启动端口
port=9000



get_kafka_manager() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/kafka-manager-1.3.3.14.zip" "297da17fa75969bc66207e991118b35d"
}

install_kafka_manager() {
	remove_kafka_manager
    test_install unzip
    test_dir ${kafka_manager_dir}
	
    #安装包
    get_kafka_manager
    unzip package/kafka-manager-1.3.3.14.zip
    mv kafka-manager-1.3.3.14 ${install_dir}/${kafka_manager_dir}

    #修改配置文件
    conf=${install_dir}/${kafka_manager_dir}/conf/application.conf
    a=kafka-manager.zkhosts='"'${cluster_ip}'"'
    sed -i "23c $a" $conf

    #创建管理脚本
    test_bin man-kafka-manager

    sed -i "2a port=${port}" $command
    sed -i "3a dir=${install_dir}/${kafka_manager_dir}" $command
    sed -i "4a log=${log_dir}/${kafka_manager_dir}" $command
    
    #完成
    clear
	echo "kafka-manager" >> conf/installed.txt
    if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${kafka_manager_dir}

日志目录：${log_dir}/${kafka_manager_dir}

启动：man-kafka-manager start

访问：curl http://127.0.0.1:${port}"
	else
		echo "install ok
    
Installation manual：${install_dir}/${kafka_manager_dir}

Log directory：${log_dir}/${kafka_manager_dir}

Start：man-kafka-manager start

Access：curl http://127.0.0.1:${port}"
	fi
}

remove_kafka_manager() {
	rm -rf ${install_dir}/${kafka_manager_dir}
	rm -rf /usr/local/bin/man-kafka-manager
	test_remove kafka-manager
	[ "$language" == "cn" ] && echo "kafka_manager卸载完成！" || echo "kafka_manager Uninstall completed！"
}

info_kafka_manager() {
	if [ "$language" == "cn" ];then
		echo "名字：kafka_manager
		
版本：1.3.3.14

介绍：kafka的web端管理工具
		
类型：服务

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：kafka_manager

Version：1.3.3.14

Introduce：Kafka web-side management tool

Type: server

Author：http://www.52wiki.cn/docs/shell"
	fi
}