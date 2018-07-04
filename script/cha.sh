#!/usr/bin/env bash



get_cha() {
    [ "$language" == "cn" ] && echo "不用下载" || echo "Do not download"
}

install_cha() {
	remove_cha	
    test_bin cha

    clear
	echo "cha" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：/usr/local/bin/cha

启动：cha -c"
	else
		echo "install ok
    
Installation manual：/usr/local/bin/cha

Start：cha"
	fi
}

remove_cha() {
	rm -rf /usr/local/bin/cha
	test_remove cha
	[ "$language" == "cn" ] && echo "cha卸载完成！" || echo "cha Uninstall completed！"
}

info_cha() {
	if [ "$language" == "cn" ];then
		echo "名字：cha
		
版本：1.0

介绍：查看系统信息
		
类型：系统管理

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：cha

Version：1.0

Introduce：Check system information

Type: System Management

Author：http://www.52wiki.cn/docs/shell"
	fi
}