#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
nginx_dir=nginx



get_nginx() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/nginx-1.8.0.tar.gz 3ca4a37931e9fa301964b8ce889da8cb
}

install_nginx() {
    #检测目录
	remove_nginx
    test_dir $nginx_dir
	test_install gcc gcc-c++ automake pcre pcre-devel zlip zlib-devel openssl openssl-devel 
	
	useradd -s /sbin/nologin nginx
	get_nginx
    tar -xf package/nginx-1.8.0.tar.gz
	cd nginx-1.8.0
	#这里指定模块，请按需求添加
	./configure --prefix=${install_dir}/${nginx_dir} --user=nginx --group=nginx --with-http_ssl_module --error-log-path=${log_dir}/${nginx_dir}/error.log --http-log-path=${log_dir}/${nginx_dir}/access.log
	make && make install

	ln -s ${install_dir}/${nginx_dir}/sbin/nginx /usr/local/bin/nginx
	nginx -v
	[ $? -eq 0 ] || test_exit "安装失败，请检查脚本" "Installation failed, please check the script"

    clear
	echo "nginx" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${nginx_dir}

日志目录：${log_dir}/${nginx_dir}

启动：nginx

关闭：nginx -s stop

访问：curl http://127.0.0.1:80"
	else
		echo "install ok
    
Installation manual：${install_dir}/${nginx_dir}

Log directory：${log_dir}/${nginx_dir}

Start：nginx

Stop：nginx -s stop

Access：curl http://127.0.0.1:80"
	fi
}

remove_nginx() {
	userdel -r nginx
	rm -rf ${install_dir}/${nginx_dir}
	test_remove nginx
	[ "$language" == "cn" ] && echo "nginx卸载完成！" || echo "nginx Uninstall completed！"
}

info_nginx() {
	if [ "$language" == "cn" ];then
		echo "名字：nginx
		
版本：1.8.0

介绍：Nginx是一款轻量的web服务器
		
类型：服务

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：nginx

Version：1.8.0

Introduce：Nginx is a lightweight web server

Type: server

Author：http://www.52wiki.cn/docs/shell"
	fi
}
