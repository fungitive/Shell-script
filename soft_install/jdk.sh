#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#服务目录名
jdk_dir=jdk-1.8



get_jdk() {
    test_package http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/jdk-8u152-linux-x64.tar.gz adfb92ae19a18b64d96fcd9a3e7bfb47
}

install_jdk() {
    remove_jdk
    test_dir $jdk_dir
    yum -y remove java-1.8.0-openjdk
    
    #安装服务
    get_jdk
    tar -xf package/jdk-8u152-linux-x64.tar.gz
    mv jdk1.8.0_152 ${install_dir}/${jdk_dir}
    
    #环境变量
    echo "export JAVA_HOME=${install_dir}/${jdk_dir}" >> /etc/profile
    echo "export JRE_HOME=${install_dir}/${jdk_dir}/jre" >> /etc/profile
    echo 'export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib' >> /etc/profile
    echo 'export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH' >> /etc/profile
    
    source /etc/profile
    
    #测试
    java -version
    [ $? -eq 0 ] || test_exit "安装失败，请检查脚本" "Installation failed, please check the soft_install"

    clear
	echo "jdk" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${jdk_dir}

环境变量设置完成"
	else
		echo "install ok
    
Installation manual：${install_dir}/${jdk_dir}

Environment variable setting completed"
	fi
}

remove_jdk() {
	rm -rf ${install_dir}/${jdk_dir}
	sed -i '/^export JAVA_HOME=/d' /etc/profile
    sed -i '/^export JRE_HOME=/d'  /etc/profile
    sed -i '/^export CLASSPATH=/d' /etc/profile
    sed -i '/^export PATH=$JAVA_HOME/d'  /etc/profile

	[ "$language" == "cn" ] && echo "卸载完成" || echo "Uninstall completed"
}

info_jdk() {
	if [ "$language" == "cn" ];then
		echo "名字：jdk
		
版本：1.8

介绍：JDK是 Java 语言的软件开发工具包
		
类型：语言

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：jdk

Version：1.8

Introduce：JDK is a Java language software development kit

Type: Language

Author：http://www.52wiki.cn/docs/shell"
	fi
}
