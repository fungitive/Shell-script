#!/usr/bin/env bash



get_clocks() {
    [ "$language" == "cn" ] && echo "不用下载" || echo "Do not download"
}

install_clocks() {
	remove_clocks
    test_bin clocks

    clear
	echo "clocks" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功

安装目录：/usr/local/bin/clocks

启动：clocks"
	else
		echo "install ok
    
Installation manual：/usr/local/bin/clocks

Start：clocks"
	fi
}

remove_clocks() {
	rm -rf /usr/local/bin/clocks
	test_remove clocks
	[ "$language" == "cn" ] && echo "clocks卸载完成！" || echo "clocks Uninstall completed！"
}

info_clocks() {
	if [ "$language" == "cn" ];then
		echo "名字：clocks
		
版本：1.0

介绍：显示字符时间
		
类型：字符游戏

作者：liungkejin@gmail.com"
	else
		echo "Name：clocks

Version：1.0

Introduce：Display character time

Type: Character game

Author：liungkejin@gmail.com"
	fi
}
