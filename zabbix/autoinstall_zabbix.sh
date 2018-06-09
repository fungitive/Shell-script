#!/usr/bin/env bash
#############################defined variable#######################################################
package_path=`pwd`
wait_second=10
mysql_pwd="root"
nginx_conf="nginx.conf" #nginxy主配置文件
nginx_zabbix_conf="zabbix.conf" #zabbix的vhost配置文件
install_report="${package_path}/install_report.log"

#############################install nginx php zabbix Package by yum#######################################
function yum_install_zabbix()
{
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
    curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo 2>>${install_report}
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo 2>>${install_report}
    rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm 2>>${install_report}
    yum clean all  2>>${install_report}
    yum makecache  2>>${install_report}
    yum -y install wget gzip nginx php php-fpm php-cli php-common php-gd php-mbstring php-mcrypt php-mysql
 php-pdo php-devel php-xmlrpc php-xml php-bcmath php-dba php-enchant mariadb-server zabbix-server
 zabbix-get zabbix-agent zabbix-server-mysql zabbix-web-mysql 2>>${install_report}
}

##########################check files exists#########################################################
function check_files(){
if [ -e ${install_report} ]
then
  rm -fr ${install_report}
fi
}

#########################config nginx###############################################################
function config_nginx(){
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
    cp ${nginx_conf} /etc/nginx/nginx.conf
    cp ${nginx_zabbix_conf} /etc/nginx/conf.d/zabbix.conf
}

########################config mysql################################################################
function config_mysql(){
    gzip -d /usr/share/doc/zabbix-server-mysql-3.4.8/create.sql.gz
    systemctl start mariadb
    mysqladmin -uroot password ${mysql_pwd}
    mysql -uroot -p${mysql_pwd}<<EOF
    create database zabbix character set utf8 collate utf8_bin;
    grant all privileges on zabbix.* to zabbix@localhost identified by "zabbix";
    flush privileges;
EOF
    mysql -uroot -p${mysql_pwd} zabbix</usr/share/doc/zabbix-server-mysql-3.4.8/create.sql
}

######################config php####################################################################
function config_php(){
    sed -i 's/post_max_size = 8M/post_max_size = 16M/g' /etc/php.ini
    sed -i 's/;default_charset = "UTF-8"/default_charset = "UTF-8"/g' /etc/php.ini
    sed -i 's/expose_php = On/expose_php = off/g' /etc/php.ini
    sed -i 's/max_execution_time = 30$/max_execution_time = 300/g' /etc/php.ini
    sed -i 's/max_input_time = 60/max_input_time = 300/g' /etc/php.ini
    sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php.ini
    sed -i 's/^;date.timezone =/date.timezone = Asia\/Shanghai/g' /etc/php.ini
}

######################config zabbix####################################################################
function config_zabbix(){
    sed -i 's/# DBPassword=/DBPassword=zabbix/g' /etc/zabbix/zabbix_server.conf
    sed -i 's/# DBSocket=\/tmp\/mysql.sock/DBSocket=\/var\/lib\/mysql\/mysql.sock/g' /etc/zabbix/zabbix_server.conf
}

######################start service###################################################################
function start_service(){
    systemctl start nginx.service
    systemctl start php-fpm
    systemctl start zabbix-server
    systemctl start zabbix-agent
    systemctl stop firewalld
}

#########################config service##############################################################
function config_service(){
    config_nginx
    config_mysql
    config_php
    config_zabbix
}

#########################Health Check###############################################################
check_health(){
    success_info=$1
    error_num=`egrep '(error|Failed)' ${install_report} |wc -l`
    if [ $error_num == "0" ]
    then
        tput bold
        echo "----------------------------------------------------------------------------------------"
        echo ${success_info}
        echo "----------------------------------------------------------------------------------------"
        tput sgr0
    else
        tput bold
        echo "----------------------------------------------------------------------------------------"
        echo "Notice:Abnormal exit,Please Check ${install_report}!"
        echo "----------------------------------------------------------------------------------------"
        tput sgr0
        sleep ${wait_second}
        exit 2
    fi
}

##########################main#######################################################################
check_files
yum_install_zabbix
check_health "Zabbix Install Success"
config_service
start_service
check_health "Service start Success!"