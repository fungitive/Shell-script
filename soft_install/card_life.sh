#!/usr/bin/env bash



get_card_life() {
    [ "$language" == "cn" ] && echo "不用下载" || echo "Do not download"
}

install_card_life() {
	remove_card_life
    test_bin card-life

    clear
	echo "card-life" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功

安装目录：/usr/local/bin/card-life

启动：card-life"
	else
		echo "install ok
    
Installation manual：/usr/local/bin/card-life

Start：card-life"
	fi
}

remove_card_life() {
	rm -rf /usr/local/bin/card-life
	test_remove card-life
	[ "$language" == "cn" ] && echo "card-life卸载完成！" || echo "card-life Uninstall completed！"
}

info_card_life() {
	if [ "$language" == "cn" ];then
		echo "名字：card-life
		
版本：1.4

介绍：抽卡人生shell版本
		
类型：卡牌游戏

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：card-life

Version：1.4

Introduce：Draw card life shell version

Type: card game

Author：http://www.52wiki.cn/docs/shell"
	fi
}