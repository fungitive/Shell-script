#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
mysql_dir=mysql



get_mysql() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/mysql-5.6.39-linux-glibc2.12-x86_64.tar.gz" "1bc406d2fe18dd877182a0bd603e7bd4"
}

install_mysql() {
	remove_mysql
    test_dir $mysql_dir

    #清理mariadb的东西
    for i in `rpm -qa | grep mariadb`; do rpm -e --nodeps $i; done
    
    test_install autoconf libaio bison ncurses-devel
    groupadd mysql
    useradd -g mysql -s /sbin/nologin mysql
    
    get_mysql
    tar -xf package/mysql-5.6.39-linux-glibc2.12-x86_64.tar.gz
    mv mysql-5.6.39-linux-glibc2.12-x86_64 ${install_dir}/${mysql_dir}
    chown -R mysql:mysql ${install_dir}/${mysql_dir}
    chown -R mysql:mysql ${log_dir}/${mysql_dir}

    echo 'PATH=$PATH':${install_dir}/${mysql_dir}/bin >> /etc/profile

    clear
	echo "mysql" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${mysql_dir}

日志目录：${log_dir}/${mysql_dir}

环境变量设置完成"
	else
		echo "install ok
    
Installation manual：${install_dir}/${mysql_dir}

Log directory：${log_dir}/${mysql_dir}

Environment variable setting completed"
	fi
}

remove_mysql() {
	rm -rf ${install_dir}/${mysql_dir}
	hang=`grep -n 'PATH=$PATH':${install_dir}/${mysql_dir}/bin /etc/profile | awk -F':' '{print $1}'`
	[ ! $hang ] || sed -i "${hang} d" /etc/profile
	test_remove mysql
	[ "$language" == "cn" ] && echo "mysql卸载完成！" || echo "mysql Uninstall completed！"
}

info_mysql() {
	if [ "$language" == "cn" ];then
		echo "名字：mysql
		
版本：6.39

介绍：数据库，支持多种存储引擎
		
类型：服务

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：mysql

Version：6.39

Introduce：Database, supports multiple storage engines

Type: server

Author：http://www.52wiki.cn/docs/shell"
	fi
}
