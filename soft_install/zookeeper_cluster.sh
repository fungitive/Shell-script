#!/usr/bin/env bash
#设置完毕后，再每个节点上安装此脚本


#[使用设置]

#集群所有节点的ip
cluster_ip=(192.168.2.108 192.168.2.109)

#端口
port=2181



source script/zookeeper.sh

get_zookeeper_cluster() {
    [ "$language" == "cn" ] && echo "不用下载" || echo "Do not download"
}

install_zookeeper_cluster() {
	remove_zookeeper_cluster
    [ -f ${install_dir}/${zookeeper_dir}/conf/zoo.cfg.dynamic ] || test_exit "请先安装zookeeper"

    #配置文件
    echo "clientPort=${port}
dataDir=${install_dir}/${zookeeper_dir}/data
syncLimit=5
tickTime=2000
initLimit=10
dataLogDir=${install_dir}/${zookeeper_dir}
dynamicConfigFile=${install_dir}/${zookeeper_dir}/conf/zoo.cfg.dynamic" > ${install_dir}/${zookeeper_dir}/conf/zoo.cfg

    #输出配置
    rm -rf  ${install_dir}/${zookeeper_dir}/conf/zoo.cfg.dynamic
    d=1
    for i in `echo ${cluster_ip[*]}`
    do
        echo "server.${d}=${i}:2888:3888" >> ${install_dir}/${zookeeper_dir}/conf/zoo.cfg.dynamic
        let d++
    done
    
    #id号
    mkdir ${install_dir}/${zookeeper_dir}/data
    id=`process_id`
    echo "$id" > ${install_dir}/${zookeeper_dir}/data/myid
    
    #监听ipv4，默认ipv6
    sed -i '150c "-Dzookeeper.log.file=${ZOO_LOG_FILE}" "-Djava.net.preferIPv4Stack=true"  "-Dzookeeper.root.logger=${ZOO_LOG4J_PROP}" \/' ${install_dir}/${zookeeper_dir}/bin/zkServer.sh

    #脚本
    command=/usr/local/bin/man-zookeeper-cluster
    rm -rf $command
    echo "#!/bin/bash
${install_dir}/${zookeeper_dir}/bin/zkServer.sh" '$1' > $command
    chmod +x $command

    clear
	echo "zookeeper-cluster" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${zookeeper_dir}

日志目录：${log_dir}/${zookeeper_dir}

启动：man-zookeeper-cluster start"
	else
		echo "install ok
    
Installation manual：${install_dir}/${zookeeper_dir}

Log directory：${log_dir}/${zookeeper_dir}

Start：man-zookeeper-cluster start"
	fi
}

remove_zookeeper_cluster() {
	man-zookeeper-cluster stop
	rm -rf /usr/local/bin/man-zookeeper-cluster
	test_remove zookeeper-cluster
	[ "$language" == "cn" ] && echo "zookeeper_cluster卸载完成！" || echo "zookeeper_cluster Uninstall completed！"
}

info_zookeeper_cluster() {
	if [ "$language" == "cn" ];then
		echo "名字：zookeeper_cluster
		
版本：zookeeper

介绍：配置zookeeper集群
		
类型：服务

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：zookeeper_cluster

Version：zookeeper

Introduce：Configure the zookeeper cluster

Type: server

Author：http://www.52wiki.cn/docs/shell"
	fi
}
