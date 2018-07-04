#!/usr/bin/env bash



get_sqlite() {
    test_package http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/sqlite-snapshot-201803072139.tar.gz b2447f8009fba42eabaeef6fcf208e2c
}

install_sqlite() {
    #检测目录
	remove_sqlite
    test_dir $sqlite_dir
    test_install gcc cmake
    
    #安装服务
    get_sqlite
    tar -xf package/sqlite-snapshot-201803072139.tar.gz
    cd sqlite-snapshot-201803072139
    ./configure
    make && make install
    
    #测试
    sqlite3 -version
    [ $? -eq 0 ] || test_exit "安装错误，请检查脚本" "Installation error, please check the script"

    clear
    echo "sqlite" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${sqlite_dir}

环境变量设置完成"
	else
		echo "install ok
    
Installation manual：${install_dir}/${sqlite_dir}

Environment variable setting completed"
	fi
}

remove_sqlite() {
	[ "$language" == "cn" ] && echo "当前不支持卸载" || echo "Does not currently support uninstallation"
}

info_sqlite() {
	if [ "$language" == "cn" ];then
		echo "名字：sqlite
		
版本：3.23.0

介绍：SQLite，是一款轻型的数据库，是遵守ACID的关系型数据库管理系统
		
类型：服务

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：sqlite

Version：6.39

Introduce：SQLite, a lightweight database, is a relational database management system that adheres to ACID

Type: server

Author：http://www.52wiki.cn/docs/shell"
	fi
}