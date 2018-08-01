#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
redis_dir=redis



get_redis() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/redis-3.2.9.tar.gz" "0969f42d1675a44d137f0a2e05f9ebd2"
}

install_redis() {
    #检测目录
	remove_redis
    test_dir $redis_dir
    
    #安装服务
    get_redis
    tar -xf package/redis-3.2.9.tar.gz
    mv redis ${install_dir}/${redis_dir}
    
    #环境变量
    echo 'PATH=$PATH':${install_dir}/${redis_dir}/bin >> /etc/profile
    
    #测试
    source /etc/profile
    which redis-cli
    [ $? -eq 0 ] || test_exit "Installation failed, please check the soft_install"

    clear
	echo "redis" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${redis_dir}

日志目录：${log_dir}/${redis_dir}

环境变量设置完成"
	else
		echo "install ok
    
Installation manual：${install_dir}/${redis_dir}

Log directory：${log_dir}/${redis_dir}

Environment variable setting completed"
	fi
}

remove_redis() {
	rm -rf ${install_dir}/${redis_dir}
	hang=`grep -n 'PATH=$PATH':${install_dir}/${redis_dir}/bin /etc/profile | awk -F':' '{print $1}'`
	[ ! $hang ] || sed -i "${hang} d" /etc/profile
	test_remove redis
	[ "$language" == "cn" ] && echo "redis卸载完成！" || echo "redis Uninstall completed！"
}

info_redis() {
	if [ "$language" == "cn" ];then
		echo "名字：redis
		
版本：3.2.9

介绍：开源的内存数据库，常用作缓存或者消息队列。
		
类型：服务

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：redis

Version：3.2.9

Introduce：Open source memory database, often used as a cache or message queue.

Type: server

Author：http://www.52wiki.cn/docs/shell"
	fi
}
