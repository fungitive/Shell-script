#!/usr/bin/env bash
#此脚本将创建集群，需要设置端口


#[使用设置]

#所有要加入集群的节点，前一半节点皆为主
cluster_ip="127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005"

#默认1主1从，设置2就是1主2从
node=1



source script/redis.sh

get_redis_cluster() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/redis-4.0.1.gem" "a4b74c19159531d0aa4c3bf4539b1743"
}

install_redis_cluster() {  
	remove_redis_cluster
    [ -f ${install_dir}/${redis_dir}/src/redis-trib.rb ] || test_exit "请先安装redis"

    get_redis_cluster
    test_install ruby-devel rubygems rpm-build
    test_rely ruby
    gem install package/redis-4.0.1.gem
    
    #启动
    ${install_dir}/${redis_dir}/src/redis-trib.rb create --replicas ${node} ${cluster_ip}
}

remove_redis_cluster() {
	[ "$language" == "cn" ] && echo "redis-cluster无法卸载，需要每个节点删除存储文件再重新创建集群！" || echo "Redis-cluster cannot be unloaded. Each node needs to delete the storage file and re-create the cluster!"
}

info_redis_cluster() {
	if [ "$language" == "cn" ];then
		echo "名字：redis-cluster
		
版本：redis

介绍：配置redis集群，需要先创建多个节点
		
类型：服务

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：redis-cluster

Version：redis

Introduce：Configure a redis cluster, you need to create multiple nodes first

Type: server

Author：http://www.52wiki.cn/docs/shell"
	fi
}
