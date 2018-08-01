#!/bin/bash
#一键安装discuz
###########################################################################################
#Httpd define path variable
H_FILES=httpd-2.2.29.tar.gz
H_FILES_DIR=httpd-2.2.29
H_URL='http://mirror.bit.edu.cn/apache/httpd/'
H_PREFIX='/usr/local/apache'
###########################################################################################
#Mysql define path variable
M_FILES='mysql-5.1.63.tar.gz'
M_FILES_DIR='mysql-5.1.63'
M_URL='http://downloads.mysql.com/archives/mysql-5.1/'
M_PREFIX='/usr/local/mysql'
###########################################################################################
#Php define path variable
P_FILES='php-5.3.28.tar.bz2'
P_FILES_DIR='php-5.3.28'
P_URL='http://mirrors.sohu.com/php/'
P_PREFIX='/usr/local/php5'
###########################################################################################
#Discuz define path variable
D_FILES='Discuz_X3.2_SC_UTF8.zip'
D_URL='http://download.comsenz.com/DiscuzX/3.2/'
D_DIR='/var/www/html'
MYSQL_PASSWD=mysqlpassword
###########################################################################################
#Only for super user to execute!
if [ $UID -ne 0 ];then
echo 'Error,Just for Super user.'
exit 2
fi
###########################################################################################
###########################################################################################
#Install Environment
function ENVIRONMENT (){
yum -y install apr-devel apr-util-devel gcc ncurses-devel gcc-c++ libxml2 libxml2-devel
if [ $? -eq 0 ];then
echo -e '\e[32mThe Environment Install Successful!\e[0m'
else
echo -e '\e[31mThe Environment Install Failure!\e[0m'
exit 2
fi
}
###########################################################################################
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
#Configure Discuz
function CONFIGURE_DISCUZ() {
wget -c $D_URL$D_FILES && unzip $D_FILES -d $H_PREFIX/htdocs/ && cd $H_PREFIX/htdocs/ && \mv upload/* . && chmod -R o+w data/ config/ uc_server/ uc_client/
if [ $? -eq 0 ];then
echo -e '\e[32mConfigure Discuz Success!\e[0m' &&
#Create discuz database
$M_PREFIX/bin/mysql -uroot -p$MYSQL_PASSWD -e 'create database discuz' &&
#Grant user password
$M_PREFIX/bin/mysql -uroot -p$MYSQL_PASSWD -e "grant all on *.* to discuz@'localhost' identified by 'discuz'" &&
#Flush privileges
$M_PREFIX/bin/mysql -uroot -e 'flush privileges' 
if [ $? -eq 0 ];then
echo -e '\e[32mDiscuz Mysql Configure Success!\e[0m'
#Start Apache Server
$H_PREFIX/bin/apachectl start>/dev/null 2>&1 && 
#Start Mysql Server
$M_PREFIX/bin/mysqld_safe --user=mysql&>/dev/null 2>&1
if [ $? -eq 0 ];then
echo -e '\e[32mApache and Mysql Start Success!\e[0m'
else
echo -e '\e[31mApache and Mysql Start Failure!\e[0m'
exit 2
fi
else
echo -e '\e[31mDiscuz Mysql configure Failure!\e[0m'
exit 2
fi
else
echo -e '\e[31mConfigure Discuz Failure!\e[0m'
exit 2
fi
}
###########################################################################################
###########################################################################################
###########################################################################################
#Define PS3
PS3="Please Enter Your choose: "
select i in'Yum install Environment' 'Install Apache' 'Install Mysql' 'Configure Mysql' 'Install Php' 'Integrate Php and Mysql' 'Automatic Install LAMP' 'Configure Discuz' 'Automatic Install ALL' 'Exit'
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
CONFIGURE_DISCUZ 
if [ $? -eq 0 ];then
echo -e  '\e[32mConfigure Discuz Successful!\e[0m'
else
echo -e '\e[31mConfigure Discuz Failure!\e[0m'
exit 2
fi
;;
###########################################################################################
9)
ENVIRONMENT &&
INSTALL_APACHE && 
INSTALL_MYSQL  &&
CONFIGURE_MYSQL &&
INSTALL_PHP &&
INTEGRATE_PHP_MYSQL &&
CONFIGURE_DISCUZ 
if [ $? -eq 0 ];then
echo -e '\e[32mEverything is ok!\e[0m'
exit 0
else
echo -e '\e[31mWrong,Please Check. exit....\e[0m'
exit 2
fi
;;
###########################################################################################
10)
echo -e '\e[32mExit....\e[0m'
exit 0
;;
###########################################################################################
*)
echo -e '\e[31mIncorect Number,Please Enter Again!\e[0m';;
esac
done