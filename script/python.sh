#!/usr/bin/env bash



#主目录
#install_dir=

#服务目录
#python_dir=python3.6



get_python() {
	test_package https://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/Python-3.6.0.tgz 3f7062ccf8be76491884d0e47ac8b251
}

install_python() {
	remove_python
	test_dir $python_dir
	test_install gcc make cmake openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-devel
	tar -xf package/Python-3.6.0.tgz
	cd Python-3.6.0
	./configure --prefix=${install_dir}/${python_dir}
	make
	make altinstall
	
	#备份python2的连接命令
	mv /usr/bin/python /usr/bin/python.back
	
	#将3的连接默认
	ln -s /usr/local/python3.6/bin/python3.6 /usr/local/bin/python
	ln -s /usr/local/python3.6/bin/python3.6 /usr/local/bin/python3
	
	#修改yum的默认解释器
	sed -i 's,#!/usr/bin/python,#!/usr/bin/python2,g' /usr/bin/yum
	#修改gnome-tweak-tool
	[ -f /usr/bin/gnome-tweak-tool ] && sed -i 's,#!/usr/bin/python,#!/usr/bin/python2,g' /usr/bin/gnome-tweak-tool
	#修改urlgrabber
	[ -f /usr/libexec/urlgrabber-ext-down ] && ed -i 's,#!/usr/bin/python,#!/usr/bin/python2,g' /usr/libexec/urlgrabber-ext-down

	#测试
	python --version |grep 3.6.0
	[ $? -eq 0 ] || test_exit "安装失败，请查看脚本" "Installation failed, please check the script"
	
    #完成
    clear
	echo "python" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功

安装目录：${install}/${python_dir}

python2的默认链接存放/usr/bin/python.back

当前默认python解释器为python3的"
	else
		echo "install ok

Installation directory: ${install}/${python_dir}

The default link for python2 is /usr/bin/python.back

The current default python interpreter is python3"
	fi
}

remove_python() {
	rm -rf ${install_dir}/${python_dir}
	rm -rf /usr/bin/python
	rm -rf /usr/bin/python3
	mv /usr/bin/python.back /usr/bin/python
	test_remove python
	[ "$language" == "cn" ] && echo "python卸载完成！" || echo "Python uninstall complete"
}

info_python() {
	if [ "$language" == "cn" ];then
		echo "名字：python
		
版本：3.6

介绍：安装python3.6
		
类型：语言

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：python

Version：3.6

Introduce：Install python3.6

Type: Language

Author：http://www.52wiki.cn/docs/shell"
	fi
}
