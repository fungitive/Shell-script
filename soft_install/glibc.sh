#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#服务目录名
glibc_dir=glibc-2.14



get_glibc() {
    test_package http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/glibc-2.14.tar.gz 4657de6717293806442f4fdf72be821b
}

install_glibc() {
    #检测目录
	remove_glibc
    test_dir $glibc_dir
    test_install gcc cmake
    
    #安装服务
    get_glibc
    tar -xf package/glibc-2.14.tar.gz
    cd glibc-2.14
    mkdir build
    cd build
    ../configure --prefix=${install_dir}/${glibc_dir}
    make && make install
    cd ..
    cd ..
    rm -rf glibc-2.14
    
    #清除软连接
    rm -rf /lib64/libc.so.6
    ln -s ${install_dir}/${glibc_dir}/lib/libc-2.14.so /lib64/libc.so.6

    clear
	echo "glibc" >> conf/installed.txt
    if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${glibc_dir}"
	else
		echo "install ok
    
Installation manual：${install_dir}/${glibc_dir}"
	fi
}

remove_glibc() {
	[ "$language" == "cn" ] && echo "暂时无法卸载！" || echo "Unable to uninstall now!"
}

info_glibc() {
	if [ "$language" == "cn" ];then
		echo "名字：glibc
		
版本：2.14

介绍：glibc是GNU发布的libc库，即c运行库
		
类型：系统文件

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：glibc

Version：2.14

Introduce：Glibc is the libc library released by GNU, ie the c runtime library

Type: System Files

Author：http://www.52wiki.cn/docs/shell"
	fi
}