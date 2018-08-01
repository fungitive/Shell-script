#!/usr/bin/env bash



#[使用设置]

#当前只支持使用sqlite3数据库安装，若使用mysql请手动安装

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
mindoc_dir=mindoc

#端口
port=8181



get_mindoc() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/mindoc.tar.gz 3edf05c97977f71f8b052818fd5a5412
}

install_mindoc() {
    #检测目录
	remove_mindoc
    test_dir $mindoc_dir
    
    #安装服务
    get_mindoc
    tar -xf package/mindoc.tar.gz
    mv mindoc ${install_dir}/${mindoc_dir}
    
    conf=${install_dir}/${mindoc_dir}/conf/app.conf
    sed -i "s/httpport = 8181/httpport = ${port}/g" $conf
	
	chmod +x ${install_dir}/${mindoc_dir}/mindoc_linux_amd64
	${install_dir}/${mindoc_dir}/mindoc_linux_amd64 install
    
    sqlite3 -version
    [ $? -eq 0 ] || bash sai.sh install sqlite
    
    strings /lib64/libc.so.6 |grep ^GLIBC_2.14
    [ $? -eq 0 ] || bash sai.sh install glibc

    test_bin man-mindoc
    sed -i "2a install_dir=${install_dir}" $command
    sed -i "3a log_dir=${log_dir}" $command
    sed -i "4a mindoc_dir=${mindoc_dir}" $command

    clear
	echo "mindoc" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${mindoc_dir}

日志目录：${log_dir}/${mindoc_dir}

启动：man-mindoc start

访问：curl http://127.0.0.1:${port}

管理员账号：admin

管理员密码：123456"
	else
		echo "install ok
    
Installation manual：${install_dir}/${mindoc_dir}

Log directory：${log_dir}/${mindoc_dir}

Start：man-mindoc start

Access：curl http://127.0.0.1:${port}

Administrator account: admin

Administrator password: 123456"
	fi
}

remove_mindoc() {
	rm -rf /usr/local/bin/man-mindoc
	rm -rf ${install_dir}/${mindoc_dir}
	test_remove mindoc
	[ "$language" == "cn" ] && echo "mindoc卸载完成！" || echo "mindoc Uninstall completed！"
}

info_mindoc() {
	if [ "$language" == "cn" ];then
		echo "名字：mindoc
		
版本：0.9

介绍：MinDoc 是一款针对IT团队开发的简单好用的文档管理系统。
		
类型：服务

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：mindoc

Version：0.9

Introduce：MinDoc is a simple and easy-to-use document management system developed for the IT team.

Type: server

Author：http://www.52wiki.cn/docs/shell"
	fi
}