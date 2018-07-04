#!/usr/bin/env bash



get_hit_boss() {
    [ "$language" == "cn" ] && echo "不用下载" || echo "Do not download"
}

install_hit_boss() {
	remove_hit_boss
    test_bin hit-boss

    clear
	echo "hit-boss" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功

安装目录：/usr/local/bin/hit-boss

启动：hit-boss"
	else
		echo "install ok
    
Start：hit-boss"
	fi
}

remove_hit_boss() {
	rm -rf /usr/local/bin/hit-boss
	test_remove hit-boss
	[ "$language" == "cn" ] && echo "hit-boss卸载完成！" || echo "hit-boss Uninstall completed！"
}

info_hit_boss() {
	if [ "$language" == "cn" ];then
		echo "名字：hit-boss
		
版本：1.2

介绍：打boss小游戏，你将挑战大法师安东尼
		
类型：字符游戏

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：hit-boss

Version：1.2

Introduce：Play boss game and you will challenge Archmage Anthony

Type: Character game

Author：http://www.52wiki.cn/docs/shell"
	fi
}
