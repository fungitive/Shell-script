#!/usr/bin/env bash



get_calibre() {
	[ "$language" == "cn" ] && echo "不用下载" || echo "Do not download"
}

install_calibre() {
	remove_calibre
	test_rely chinese-font
	test_install libGL.so.1 mesa-libGL Mesa-libGL-devel libXcomposit qt5-qtquickcontrols qt5-qtdeclarative-devel

	#安装包
	wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
	
	#测试
	ebook-convert --version
	[ $? -eq 0 ] || test_exit "安装失败，请检查脚本" "Installation failed, please check the script"
	ebook-convert conf/installed.txt installed.pdf
	[ -f installed.pdf ] || test_exit "生成pdf失败，请检查脚本" "Failed to generate pdf, please check the script"
	
    #完成
    clear
	echo "calibre" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功

ebook-convert a.txt a.pdf 方式生成pdf文件"
	else
		echo "install ok

Ebook-convert a.txt a.pdf method to generate pdf file"
	fi
}

remove_calibre() {
	[ "$language" == "cn" ] && echo "calibre当前无法卸载！" || echo "calibre cannot be uninstalled at this time！"
}

info_calibre() {
	if [ "$language" == "cn" ];then
		echo "名字：calibre
		
版本：3.18.0

介绍：Calibre是基于python的电子书制作软件，可导出PDF、EPUB、MOBI、Word格式电子书。
		
类型：系统管理

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：calibre

Version：0

Introduce：Calibre is a python-based e-book making software that exports PDF, EPUB, MOBI, and Word format e-books.

Type: System Management

Author：http://www.52wiki.cn/docs/shell"
	fi
}
