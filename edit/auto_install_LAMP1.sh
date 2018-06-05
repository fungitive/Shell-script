#!/usr/bin/env bash
#定义资源下载
###########################################################################################
#Httpd define path variable
H_FILES=httpd-2.4.29.tar.gz
H_FILES_DIR=httpd-2.4.29
H_URL='http://mirror.bit.edu.cn/apache/httpd/'
H_PREFIX='/usr/local/apache'
###########################################################################################
#Mysql define path variable
M_FILES='mysql-cluster-gpl-7.2.27.tar.gz'
M_FILES_DIR='mysql-cluster-gpl-7.2.27'
M_URL='http://mirrors.sohu.com/mysql/MySQL-Cluster-7.2/'
M_PREFIX='/usr/local/mysql'
###########################################################################################
#Php define path variable
P_FILES='php-7.2.4.tar.bz2'
P_FILES_DIR='php-7.2.4'
P_URL='http://mirrors.sohu.com/php/'
P_PREFIX='/usr/local/php7'
###########################################################################################
#Install Environment
function ENVIRONMENT (){
yum -y install apr-devel apr-util-devel gcc ncurses-devel gcc-c++ libxml2 libxml2-devel wget
if [ $? -eq 0 ];then
echo -e '\e[32mThe Environment Install Successful!\e[0m'
else
echo -e '\e[31mThe Environment Install Failure!\e[0m'
exit 2
fi
}
###########################################################################################
echo -e '\e[33Install Apache\e[0m'
#Install Apache
function INSTALL_APACHE(){
  wget -c $H_URL$H_FILES && tar -zxf $H_FILES && cd $H_FILES_DIR && ./configure --prefix=$H_PREFIX && make && make install
if [ "$?" -eq "0" ];then
echo -e '\e[32mApache Server Install Success!\e[0m'
else
echo -e '\e[31mApache Server Install Failure!\e[0m'
exit 2
fi
}
###########################################################################################
