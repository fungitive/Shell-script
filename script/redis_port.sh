#!/usr/bin/env bash
#启动多个端口


#[使用设置]

#将安装如下端口实例
port=(6379)

#监听ip
listen=0.0.0.0



#加载依赖
source script/redis.sh

get_redis_port() {
    [ "$language" == "cn" ] && echo "不用下载" || echo "Do not download"
}

install_redis_port() {
	remove_redis_port
    [ -d ${install_dir}/${redis_dir} ] || test_exit "请先安装redis"

    get_redis_port
    for i in `echo ${port[*]}`
    do
        command=/usr/local/bin/man-redis${i} #创建单独管理脚本
        if [ ! -f $command ];then
            cp material/man-redis $command
        
            sed -i "2a port=${i}" $command
            sed -i "3a install_dir=${install_dir}" $command
            sed -i "4a log_dir=${log_dir}" $command
            sed -i "5a redis_dir=${redis_dir}" $command
        
            chmod +x $command
        else
            continue #如果管理脚本存在，则跳过这个端口
        fi

        conf=${install_dir}/${redis_dir}/cluster/${i}/${i}.conf
        
        mkdir -p ${install_dir}/${redis_dir}/cluster/${i}
        cp material/redis_7000.conf $conf
        
        sed -i "s/^bind 127.0.0.1/bind ${listen}/g" $conf
        sed -i "/^port/cport ${i}" $conf
        sed -i "/^cluster-config-file/ccluster-config-file nodes_${i}.conf" $conf
        sed -i "/^pidfile/cpidfile redis_${i}.pid" $conf
        sed -i "/^dir/cdir ${install_dir}/${redis_dir}/cluster/${i}" $conf 
    done

    #创建总管理脚本
    echo '#!/bin/bash

for i in `ls /usr/local/bin/man-redis*`
do  
    [ "$i" == "/usr/local/bin/man-redis" ] && continue || $i $1
done' >> /usr/local/bin/man-redis
    chmod +x /usr/local/bin/man-redis

    clear
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${redis_dir}

日志目录：${log_dir}/${redis_dir}

启动：man-redis start"
	else
		echo "install ok
    
Installation manual：${install_dir}/${redis_dir}

Log directory：${log_dir}/${redis_dir}

Start：man-redis start"
	fi
}

remove_redis_port() {
	rm -rf /usr/local/bin/man-redis
	for i in `echo ${port[*]}`
    do
		rm -rf /usr/local/bin/man-redis${i}
		rm -rf ${install_dir}/${redis_dir}/cluster/${i}
		[ "$language" == "cn" ] && echo "节点${i}卸载完成！" || echo "node${i} Uninstall completed！"
	done
}

info_redis_port() {
	if [ "$language" == "cn" ];then
		echo "名字：redis-port
		
版本：redis

介绍：配置redis多实例
		
类型：服务

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：redis-port

Version：redis

Introduce：Configure redis multi-instance

Type: server

Author：http://www.52wiki.cn/docs/shell"
	fi
}
