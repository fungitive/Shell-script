#!/usr/bin/env bash
#jenkins基本环境


#[使用设置]
#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
jenkins_dir=jenkins

#开启的端口号
port=8080

#默认监听所有
listen=0.0.0.0



get_jenkins() {
    test_package http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/jenkins.war 08386ff41dbf7dd069c750f3484cc140
}

install_jenkins() {
	remove_jenkins
    test_dir $jenkins_dir
    
    #安装依赖和包
    test_rely jdk
    get_jenkins
    mkdir ${install_dir}/${jenkins_dir}
    cp package/jenkins.war ${install_dir}/${jenkins_dir}/
    
    #配置启动脚本
    test_bin man-jenkins

    sed -i "2a port=$port" $command
    sed -i "3a listen=$listen" $command
    sed -i "4a install_dir=$install_dir" $command
    sed -i "5a log_dir=$log_dir" $command
    sed -i "6a jenkins_dir=$jenkins_dir" $command

    #完成
    clear
	echo "jenkins" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${jenkins_dir}

日志目录：${log_dir}/${jenkins_dir}

启动：man-jenkins start

访问：curl http://127.0.0.1:${port}"
	else
		echo "install ok
    
Installation manual：${install_dir}/${jenkins_dir}

Log directory：${log_dir}/${jenkins_dir}

Start：man-jenkins start

Access：curl http://127.0.0.1:${port}"
	fi
}

remove_jenkins() {
	rm -rf /usr/local/bin/man-jenkins
	rm -rf ${install_dir}/${jenkins_dir}
	test_remove jenkins
	[ "$language" == "cn" ] && echo "jenkins卸载完成！" || echo "jenkins Uninstall completed！"
}

info_jenkins() {
	if [ "$language" == "cn" ];then
		echo "名字：jenkins
		
版本：2.104

介绍：持续与集成工具
		
类型：服务

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：jenkins

Version：2.104

Introduce：Continuous and integrated tools

Type: server

Author：http://www.52wiki.cn/docs/shell"
	fi
}