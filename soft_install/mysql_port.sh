#!/usr/bin/env bash



#[使用设置]

#开启实例的端口
cluster_ip=(3307 3308)



source script/mysql.sh

get_mysql_port() {
    [ "$language" == "cn" ] && echo "不用下载" || echo "Do not download"
}

install_mysql_port() {
	remove_mysql_port
    [ -f ${install_dir}/${mysql_dir}/scripts/mysql_install_db ] || test_exit "请先安装mysql" "Please install mysql first"
 
     echo "[client]
port=3306
socket=${install_dir}/${mysql_dir}/mysql.sock

[mysqld_multi]
mysqld=${install_dir}/${mysql_dir}/bin/mysqld_safe
mysqladmin=${install_dir}/${mysql_dir}/bin/mysqladmin
log=${log_dir}/${mysql_dir}/mysqld_multi.log

[mysqld]
user=mysql
basedir=${install_dir}/${mysql_dir}
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES"  > /etc/my.cnf #基本配置

    for i in `echo ${cluster_ip[*]}`
    do
        [ -d ${install_dir}/${mysql_dir}/data${i} ] && continue
        mkdir ${install_dir}/${mysql_dir}/data${i}
        echo "[mysqld${i}]  
mysqld=mysqld  
mysqladmin=mysqladmin  
datadir=${install_dir}/${mysql_dir}/data${i}
port=${i}
server_id=${i}  
socket=${install_dir}/${mysql_dir}/mysql_${i}.sock  
log-output=file  
slow_query_log = 1  
long_query_time = 1  
slow_query_log_file =${log_dir}/${mysql_dir}/${i}_slow.log  
log-error =${log_dir}/${mysql_dir}/${i}_error.log  
binlog_format = mixed  
log-bin =${log_dir}/${mysql_dir}/${i}_bin" >> /etc/my.cnf
echo >> /etc/my.cnf
    done
    
    chown -R mysql:mysql ${install_dir}/${mysql_dir}
    
    for i in `echo ${cluster_ip}`
    do
        ${install_dir}/${mysql_dir}/scripts/mysql_install_db --basedir=${install_dir}/${mysql_dir} --datadir=${install_dir}/${mysql_dir}/data${i} --defaults-file=/etc/my.cnf &> /dev/null
    done

	clear
	echo "mysql-port" >> conf/installed.txt
	if [ "$language" == "cn" ];then
		echo "安装成功
		
安装目录：${install_dir}/${mysql_dir}/data*

日志目录：${log_dir}/${mysql_dir}

启动：mysqld_multi start

访问：mysql -S ${install_dir}/${mysql_many_dir}/mysql_${i}.sock"
	else
		echo "install ok
    
Installation manual：${install_dir}/${mysql_dir}

Log directory：${log_dir}/${mysql_dir}

Start：mysqld_multi start

Environment variable setting completed

Access：mysql -S ${install_dir}/${mysql_many_dir}/mysql_${i}.sock"
	fi
}

remove_mysql_port() {
	> /etc/my.cnf
    for i in `echo ${cluster_ip[*]}`
    do
        rm -rf ${install_dir}/${mysql_dir}/data${i}
	done
	test_remove mysql-port
	[ "$language" == "cn" ] && echo "mysql_port卸载完成！" || echo "mysql_port Uninstall completed！"
}

info_mysql_port() {
	if [ "$language" == "cn" ];then
		echo "名字：mysql-port
		
版本：mysql

介绍：配置mysql多实例
		
类型：服务

作者：http://www.52wiki.cn/docs/shell"
	else
		echo "Name：mysql-port

Version：mysql

Introduce：Configure mysql multiple instances

Type: server

Author：http://www.52wiki.cn/docs/shell"
	fi
}