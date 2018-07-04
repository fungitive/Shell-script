#!/usr/bin/env bash



#[使用设置]

#默认端口
port=3306



source script/mysql.sh

get_mysql_single() {
    [ "$language" == "cn" ] && echo "不用下载" || echo "Do not download"
}

install_mysql_single() {
	remove_mysql_single
    [ -f ${install_dir}/${mysql_dir}/scripts/mysql_install_db ] || test_exit "请先安装mysql" "Please install mysql first"
    
    echo "[mysql]
default-character-set=utf8
socket=${install_dir}/${mysql_dir}/mysql.sock
[mysqld]
skip-name-resolve
port = ${port}
socket=${install_dir}/${mysql_dir}/mysql.sock
basedir=${install_dir}/${mysql_dir}
datadir=${install_dir}/${mysql_dir}/data
max_connection=200
character-set-server=utf8
default-storage-engine=INNODB
lower_case_table_name=1
max_allowed_packet=16M
log-error=${log_dir}/${mysql_dir}/mysql.log
pid-file=${log_dir}/${mysql_dir}/mysql.pid
bind-address = 0.0.0.0" > /etc/my.cnf #这里改需要的配置
    chown mysql:mysql /etc/my.cnf
    
    #初始化脚本
    cd ${install_dir}/${mysql_dir}
    ./scripts/mysql_install_db --user=mysql --basedir=${install_dir}/${mysql_dir} --datadir=${install_dir}/${mysql_dir}/data &> /dev/null
    
    #加入systemctl
    rm -rf /usr/lib/systemd/system/mysql.service
    echo "[Unit]
Description=mysql
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
ExecStart=${install_dir}/${mysql_dir}/support-files/mysql.server start
ExecReload=${install_dir}/${mysql_dir}/support-files/mysql.server restart
ExecStop=${install_dir}/${mysql_dir}/support-files/mysql.server stop
PrivateTmp=true

[Install]
WantedBy=multi-user.target" > /usr/lib/systemd/system/mysql.service

    systemctl daemon-reload

    clear
	echo "caed-single" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${mysql_dir}

日志目录：${log_dir}/${mysql_dir}

启动：systemctl start mysql"
	else
		echo "install ok
    
Installation manual：${install_dir}/${mysql_dir}

Log directory：${log_dir}/${mysql_dir}

Start：systemctl start mysql"
	fi
}

remove_mysql_single() {
	rm -rf rm -rf /usr/lib/systemd/system/mysql.service
	> /etc/my.cnf
	test_remove mysql-single
	[ "$language" == "cn" ] && echo "mysql-single卸载完成！" || echo "mysql-single Uninstall completed！"
}

info_mysql_single() {
	if [ "$language" == "cn" ];then
		echo "名字：mysql-single
		
版本：mysql

介绍：配置mysql单点
		
类型：服务

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：mysql-single

Version：mysql

Introduce：Configure mysql single point

Type: server

Author：http://www.52wiki.cn/docs/shell"
	fi
}
