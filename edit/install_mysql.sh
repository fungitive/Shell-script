#!/bin/sh
# install Environment with yum
yum -y install make cmake bison-devel ncurses-devel gcc gcc-c++ kernel-devel &&\
yum install -y readline-devel pcre-devel openssl-devel openssl zlib zlib-devel pcre-devel  perl perl-devel wget
wget -c https://cdn.mysql.com/archives/mysql-5.7/mysql-boost-5.7.21.tar.gz &&\
tar -zxvf mysql-boost-5.7.21.tar.gz && rm -f mysql-boost-5.7.21.tar.gz && cd mysql-boost-5.7.21 &&\
#make datadir ,homedir and backupdir
mkdir -p /home/mysql/data  /usr/local/mysql /backup
# add groupuser and user of mysql
groupadd mysql && useradd -g mysql mysql
chown -R mysql:mysql /home/mysql/data /backup
# cmake
cmake \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_DATADIR=/mysql/data \
-DSYSCONFDIR=/etc \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DMYSQL_UNIX_ADDR=/var/lib/mysql/mysql.sock \
-DMYSQL_TCP_PORT=3306 \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DLOWER_CASE_TABLE_NAMES=1
make && make install
#mv /etc/my.cnf if exists it will be failure
mv /etc/my.cnf /etc/my.cnfbk
#install mysqldb and start mysql server
/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/home/mysql/data --user=mysql
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
chkconfig mysql on
service mysql start
# change the user of database
/usr/local/mysql/bin/mysql -e"grant all on *.* to 'root'@'%' identified by '123456';"
/usr/local/mysql/bin/mysql -e"grant all on *.* to 'root'@localhost identified by '123456';"
/usr/local/mysql/bin/mysql -uroot -p123456 -e"delete from mysql.user where password='';"
# default my.cnf /usr/local/mysql/my.cnf


#Configure Mysql
\cp /usr/local/mysql/share/mysql/my-medium.cnf  /etc/my.cnf && \cp /usr/local/mysql/share/mysql/mysql.server /etc/init.d/mysqld &&  chkconfig --add mysqld && chkconfig --level 345 mysqld on || echo -e '\e[31mMysql Server Configuue Failure!\e[0m' exit 2
#Useradd mysql user
id mysql>/dev/null 2>&1 || useradd mysql
cd /usr/local/mysql
chown -R mysql.mysql /usr/local/mysql && /usr/local/mysql/bin/mysql_install_db --user=mysql > /dev/null 2>&1 &&
chown -R mysql var && /usr/local/mysql/bin/mysqld_safe --user=mysql& > /dev/null 2>&1 &&
if [ $? -eq 0 ];then
echo -e '\e[32mMysql Server Configure Success!\e[0m'
else
echo -e '\e[31mMysql Server Configuue Failure!\e[0m'
exit 1
fi
