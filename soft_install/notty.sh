#!/usr/bin/env bash



get_notty() {
    [ "$language" == "cn" ] && echo "不用下载" || echo "Do not download"
}

install_notty() {
	remove_notty
    test_bin notty

    clear
	echo "notty" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功

安装目录：/usr/local/bin/notty

启动：notty

修改：修改失败次数请编辑脚本文件

建议：建议将脚本加入crontab"
	else
		echo "install ok

Start：notty

Modify: modify the number of failures, please edit the soft_install file

Recommendation: It is recommended to add the soft_install to the crontab"
	fi
}

remove_notty() {
	rm -rf /usr/local/bin/notty
	test_remove notty
	[ "$language" == "cn" ] && echo "notty卸载完成！" || echo "notty Uninstall completed！"
}

info_notty() {
	if [ "$language" == "cn" ];then
		echo "名字：notty
		
版本：1.2

介绍：防弱密码爆破脚本，5次登陆系统失败的ip会被禁止
		
类型：系统管理

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：notty

Version：1.2

Introduce：Anti-weak password cracking script, 5 failed login ip will be forbidden

Type: System Management

Author：http://www.52wiki.cn/docs/shell"
	fi
}
