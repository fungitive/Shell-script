#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#服务目录名
modejs_dir=nodejs



get_nodejs() {
    test_package "http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/node-v8.9.3-linux-x64.tar.xz" "32948a8ca5e6a7b69c03ec1a23b16cd2"
}

install_nodejs() {
    #检测目录
    remove_nodejs
    test_dir $nodejs_dir

    get_nodejs
    tar -xf package/node-v8.9.3-linux-x64.tar.xz
    mv node-v8.9.3-linux-x64 ${install_dir}/${nodejs_dir}
    
    #链接
	rm -rf /usr/local/bin/node
    rm -rf /usr/local/bin/npm
    ln -s ${install_dir}/${nodejs_dir}/bin/node /usr/local/bin/node
    ln -s ${install_dir}/${nodejs_dir}/bin/npm /usr/local/bin/npm

    #对结果进行测试
    node -v
    [ $? -eq 0 ] || test_exit "Installation failed, please check the installation script"
    
    clear
	echo "nodejs" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${nodejs_dir}

环境变量设置完成"
	else
		echo "install ok
    
Installation manual：${install_dir}/${nodejs_dir}

Environment variable setting completed"
	fi
}

remove_nodejs() {
    rm -rf /usr/local/bin/node
    rm -rf /usr/local/bin/npm
	rm -rf ${install_dir}/${nodejs_dir}
	test_remove nodejs
	[ "$language" == "cn" ] && echo "nodejs卸载完成！" || echo "nodejs Uninstall completed！"
}

info_nodejs() {
	if [ "$language" == "cn" ];then
		echo "名字：nodejs
		
版本：8.9.3

介绍： Node.js 就是运行在服务端的 JavaScript。
		
类型：语言

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：nodejs

Version：8.9.3

Introduce：Node.js is JavaScript that runs on the server.

Type: Language

Author：http://www.52wiki.cn/docs/shell"
	fi
}
