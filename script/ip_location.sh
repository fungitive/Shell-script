#!/usr/bin/env bash



get_ip_location() {
    [ "$language" == "cn" ] && echo "不用下载" || echo "Do not download"
}

install_ip_location() {
	remove_ip_location
    test_bin ip-location

    clear
	echo "ip-location" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功

安装目录：/usr/local/bin/ip-location

启动：ip-location"
	else
		echo "install ok
    
Start：ip-location"
	fi
}

remove_ip_location() {
	rm -rf /usr/local/bin/ip-location
	test_remove ip-location
	[ "$language" == "cn" ] && echo "ip-location卸载完成！" || echo "ip-location Uninstall completed！"
}

info_ip_location() {
	if [ "$language" == "cn" ];then
		echo "名字：ip-location
		
版本：1.2

介绍：查询ip地址所在地
		
类型：系统管理

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：ip-location

Version：1.2

Introduce：Query ip address location

Type: System Management

Author：http://www.52wiki.cn/docs/shell"
	fi
}
