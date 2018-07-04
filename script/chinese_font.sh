#!/usr/bin/env bash



get_chinese_font() {
    test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/simhei.ttf 5b4ceb24c33f4fbfecce7bd024007876
	test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/simsun.ttc bc9c5051b849545eaecb9caeed711d79
}

install_chinese_font() {
	remove_chinese_font
	test_install fontconfig ttmkfdir
	mkdir -p /usr/share/fonts/chinese
	
	#放字体到文件夹
	get_chinese_font
	cp package/simhei.ttf /usr/shared/fonts/chinese/
	cp simsun.ttc /usr/shared/fonts/chinese/
	chmod -R 755 /usr/shared/fonts/chinese
	
	#将字体的文件夹位置写到配置文件
	
    ttmkfdir -e /usr/share/X11/fonts/encodings/encodings.dir
	sed -i '28a <dir>/usr/shared/fonts/chinese</dir>' /etc/fonts/fonts.conf
	fc-cache
	fc-list

    #完成
    clear
	echo "chinese-font" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功

fc-list 查看是否有中文字体"
	else
		echo "install ok

fc-list See if there is a Chinese font"
	fi
}

remove_chinese_font() {
	[ "$language" == "cn" ] && echo "chinese-font当前无法卸载！" || echo "Chinese-font cannot be uninstalled at this time！"
}

info_chinese_font() {
	if [ "$language" == "cn" ];then
		echo "名字：chinese-font
		
版本：0

介绍：安装中文字体
		
类型：系统管理

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：chinese-font

Version：0

Introduce：Install Chinese font

Type: System Management

Author：http://www.52wiki.cn/docs/shell"
	fi
}
