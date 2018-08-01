#!/usr/bin/env bash



get_tetris() {
    [ "$language" == "cn" ] && echo "不用下载" || echo "Do not download"
}

install_tetris() {
	remove_tetris
    test_bin tetris

    clear
	echo "tetris" >> conf/installed.txt
    if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：/usr/local/bin/tetris

启动：tetris"
	else
		echo "install ok
    
Installation manual：/usr/local/bin/tetris

Start：tetris"
	fi
}

remove_tetris() {
	rm -rf /usr/local/bin/tetris
	test_remove tetris
	[ "$language" == "cn" ] && echo "tetris卸载完成！" || echo "tetris Uninstall completed！"
}

info_tetris() {
	if [ "$language" == "cn" ];then
		echo "名字：tetris
		
版本：1.0

介绍：俄罗斯方块小游戏
		
类型：休闲游戏

作者：未知"
	else
		echo "Name：tetris

Version：1.0

Introduce：Tetris Games

Type: casual games

Author：unknown"
	fi
}