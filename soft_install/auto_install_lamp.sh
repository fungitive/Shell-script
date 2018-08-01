#!/usr/bin/env bash
###########################################################################################
#Httpd define path variable
H_FILES='httpd-2.4.29.tar.gz'
H_FILES_DIR='httpd-2.4.29'
H_URL='http://mirror.bit.edu.cn/apache/httpd/'
H_PREFIX='/usr/local/apache'
###########################################################################################
#Mysql define path variable
M_FILES='mysql-test-5.7.22-el7-x86_64.tar.gz'
M_FILES_DIR='mysql-test-5.7.22-el7-x86_64'
M_URL='https://dev.mysql.com/get/Downloads/MySQL-5.7/'
M_PREFIX='/usr/local/mysql'
###########################################################################################
#Php define path variable
P_FILES='php-7.2.4.tar.bz2'
P_FILES_DIR='php-7.2.4'
P_URL='http://mirrors.sohu.com/php/'
P_PREFIX='/usr/local/php7'
###########################################################################################
#Only for super user to execute!
if [ $UID -ne 0 ];then
echo 'Error,Just for Super user.'
exit 2
fi
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
#Install Mysql DB
function INSTALL_MYSQL (){
  wget -c $M_URL$M_FILES && tar -zxf $M_FILES && cd $M_FILES_DIR && ./configure --prefix=$M_PREFIX --enable-assembler && make && make install
if [ "$?" -eq "0" ];then
echo -e  '\e[32mMysql Server Install Success!\e[0m'
else
echo -e '\e[31mMysql Server Install Failure!\e[0m'
exit 2
fi
}
###########################################################################################
#Configure Mysql
function CONFIGURE_MYSQL(){
\cp ${M_PREFIX}/share/mysql/my-medium.cnf  /etc/my.cnf && \cp ${M_PREFIX}/share/mysql/mysql.server /etc/init.d/mysqld &&  chkconfig --add mysqld && chkconfig --level 345 mysqld on || echo -e '\e[31mMysql Server Configuue Failure!\e[0m' exit 2
#Useradd mysql user
id mysql>/dev/null 2>&1 || useradd mysql
cd $M_PREFIX
chown -R mysql.mysql $M_PREFIX && ${M_PREFIX}/bin/mysql_install_db --user=mysql > /dev/null 2>&1 &&
chown -R mysql var && /usr/local/mysql/bin/mysqld_safe --user=mysql& > /dev/null 2>&1 &&
if [ $? -eq 0 ];then
echo -e '\e[32mMysql Server Configure Success!\e[0m'
else
echo -e '\e[31mMysql Server Configuue Failure!\e[0m'
exit 2
fi
}
###########################################################################################
###########################################################################################
#Install Php
function INSTALL_PHP(){
wget -c $P_URL$P_FILES && tar -jxf $P_FILES && cd $P_FILES_DIR && ./configure  --prefix=$P_PREFIX  --with-config-file-path=${P_PREFIX}/etc  --with-apxs2=${H_PREFIX}/bin/apxs --with-mysql=$M_PREFIX && make && make install
if [ $? -eq 0 ];then
echo -e '\e[32mPhp Install Success!\e[0m'
else
echo -e '\e[31mPhp Install Failure!\e[0m'
exit 2
fi
}
###########################################################################################
# Integrate Php and Mysql
function INTEGRATE_PHP_MYSQL(){
sed -i '311a AddType     application/x-httpd-php .php' $H_PREFIX/conf/httpd.conf &&
sed -i 's/index.html/index.php index.html/' $H_PREFIX/conf/httpd.conf
if [ $? -eq 0 ];then
echo -e '\e[32mIntegrate is Success!\e[0m'
$H_PREFIX/bin/apachectl start >/dev/null 2>&1
else
echo -e '\e[31mIntegrate is Failure!\e[0m'
exit 2
fi
}
###########################################################################################
###########################################################################################
#Define PS3
PS3="Please Enter Your choose: "
select i in 'Yum install Environment' 'Install Apache' 'Install Mysql' 'Configure Mysql' 'Install Php' 'Integrate Php and Mysql' 'Automatic Install LAMP' 'Configure Discuz' 'Automatic Install ALL' 'Exit'
do
CHOOSE=$REPLY
case $CHOOSE in
1)
ENVIRONMENT
if [ $? -eq 0 ];then
echo -e '\e[32mYum Install Environment Successful!\e[0m'
else
echo -e '\e[31mYum Install Environment Failure!\e[0m'
exit 2
fi
;;
###########################################################################################
2)
INSTALL_APACHE
if [ $? -eq 0 ];then
echo -e  '\e[32mApache Install Successful!\e[0m'
else
echo -e '\e[31mApache Install Failure!\e[0m'
exit 2
fi
;;
###########################################################################################
3)
INSTALL_MYSQL
if [ $? -eq 0 ];then
echo -e  '\e[32mMysql Install Successful!\e[0m'
else
echo -e '\e[31mMysql Install Failure!\e[0m'
exit 2
fi
;;
###########################################################################################
4)
CONFIGURE_MYSQL
if [ $? -eq 0 ];then
echo -e  '\e[32mConfigure Mysql  Successful!\e[0m'
else
echo -e '\e[31mConfigure Mysql Failure!\e[0m'
exit 2
fi
;;
###########################################################################################
5)
INSTALL_PHP
if [ $? -eq 0 ];then
echo -e  '\e[32mPhp Install Successful!\e[0m'
else
echo -e '\e[31mPhp Install Failure!\e[0m'
exit 2
fi
;;
###########################################################################################
6)
INTEGRATE_PHP_MYSQL
if [ $? -eq 0 ];then
echo -e  '\e[32mIntegrate php and mysql Successful!\e[0m'
else
echo -e '\e[31mIntegrate Failure!\e[0m'
exit 2
fi
;;
###########################################################################################
7)
ENVIRONMENT &&
INSTALL_APACHE &&
INSTALL_MYSQL  &&
CONFIGURE_MYSQL &&
INSTALL_PHP &&
INTEGRATE_PHP_MYSQL
if [ $? -eq 0 ];then
 echo -e '\e[32mLamp is ok!\e[0m'
 exit 0
else
 echo -e '\e[31mLamp Error,Please Check. exit....\e[0m'
 exit 2
fi
;;
###########################################################################################
8)
echo -e '\e[32mExit....\e[0m'
exit 0
;;
###########################################################################################
*)
echo -e '\e[31mIncorect Number,Please Enter Again!\e[0m';;
esac
done