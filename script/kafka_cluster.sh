#!/usr/bin/env bash



#[使用设置]

#zookeeper集群的ip，包括他自己
cluster_ip=(192.168.2.108:2181 192.168.2.109:2181)

#端口
port=9092

#监听地址，如果填写localhost，则监听本地
listen=localhost



#如果非sai安装的，修改被加载脚本
source script/kafka.sh

get_kafka_cluster() {
    [ "$language" == "cn" ] && echo "不用下载" || echo "Do not download"
}

install_kafka_cluster() {
    #检测依赖
	remove_kafka_cluster
	conf=${install_dir}/${kafka_dir}/config/server.properties
    [ -f $conf ] || test_exit "请先安装kakfa" "Please install kafka first"

    #修改配置
    rm -rf $conf
    cp material/server.properties $conf
    
    id=`process_id`
    ip=`process_ip`
    
    #算出地址字符串
    for i in `echo ${cluster_ip[*]}` 
    do
        if [ "$i" == "${cluster_ip[0]}" ];then #刨去第一个，不然最前面会多个,
            cluster_dizhi=`echo $i`
        else
            cluster_dizhi=`echo ${cluster_dizhi},$i`
        fi
    done

    sed -i "21s/broker.id=1/broker.id=${id}/g" $conf
    sed -i "35s/port=9092/port=${port}/g" $conf
    if [ "$listen" == "localhost" ];then
        sed -i "36s/advertised.host.name=192.168.100.11/advertised.host.name=${ip}/g" $conf
    else
        sed -i "36s/advertised.host.name=192.168.100.11/advertised.host.name=${listen}/g" $conf
    fi
    sed -i "64s,log.dirs=/ops/log/kafka,log.dirs=${log_dir}/${kafka_dir},g" $conf
    sed -i "120s/zookeeper.connect=B-S-01:2181/zookeeper.connect=${cluster_dizhi}/g" $conf

    #创建脚本
    test_bin man-kafka-cluster
    sed -i "2a port=${port}" $command
    sed -i "3a dir=${install_dir}/${kafka_dir}" $command
   
	clear
	echo "kafka-cluster" >> conf/installed.txt
    if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${kafka_dir}

日志目录：${log_dir}/${kafka_dir}

启动：man-kafka-cluster start"
	else
		echo "install ok
    
Installation manual：${install_dir}/${kafka_dir}

Log directory：${log_dir}/${kafka_dir}

Start：man-kafka-cluster start"
	fi
}

remove_kafka_cluster() {
	rm -rf /usr/local/bin/man-kafka-cluster
	test_remove kafka-cluster
	[ "$language" == "cn" ] && echo "kafka-cluster卸载完成！" || echo "kafka-cluster Uninstall completed！"
}

info_kafka_cluster() {
	if [ "$language" == "cn" ];then
		echo "名字：kafka-cluster
		
版本：kafka

介绍：配置kafka集群
		
类型：服务

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：kafka-cluster

Version：kafka

Introduce：Configure kafka cluster

Type: server

Author：http://www.52wiki.cn/docs/shell"
	fi
}