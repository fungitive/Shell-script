#!/usr/bin/env bash



get_ruby() {
    [ "$language" == "cn" ] && echo "不用下载" || echo "Do not download"
}

install_ruby() {
    remove_ruby

    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
	\curl -sSL https://get.rvm.io | bash -s stable
    
	[ -f /etc/profile.d/rvm.sh ] || test_exit "rvm下载失败，请重新安装ruby" "Rvm download failed, please re-install ruby"
    
	#设置环境变量
    echo source /etc/profile.d/rvm.sh >> ~/.bashrc
    source ~/.bashrc
    echo "ruby_url=https://cache.ruby-china.org/pub/ruby" > ~/.rvm/user/db

    #安装
    rvm install 2.4.1
    rvm use 2.4.1 --default
	
	#测试
	rvm use 2.4.1 --default
	[ $? -eq 0 ] || test_exit "ruby安装失败，请检查脚本" "Ruby installation failed, please check the script"
    
    clear
	echo "ruby" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：/usr/local/rvm

环境变量设置完成"
	else
		echo "install ok
    
Installation manual：/usr/local/rvm

Environment variable setting completed"
	fi
}

remove_ruby() {
	[ "$language" == "cn" ] && echo "当前不支持卸载" || echo "Does not currently support uninstallation"
}

info_ruby() {
	if [ "$language" == "cn" ];then
		echo "名字：ruby
		
版本：2.4.1

介绍：Ruby，一种简单快捷的面向对象（面向对象程序设计）脚本语言
		
类型：语言

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：ruby

Version：2.4.1

Introduce：Ruby, a simple and fast object-oriented (object-oriented programming) scripting language

Type: Language

Author：http://www.52wiki.cn/docs/shell"
	fi
}
