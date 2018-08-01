#!/bin/sh
#卸载MariaDB
yum remove mariadb-libs -y
# install Environment with yum
yum -y install make cmake bison-devel ncurses-devel gcc gcc-c++ kernel-devel &&\
yum install -y readline-devel pcre-devel openssl-devel openssl zlib zlib-devel pcre-devel  perl perl-devel wget
#install boost_1_59_0
wget -c https://dl.bintray.com/boostorg/release/1.59.0/source/boost_1_59_0.tar.gz
tar -xzvf boost_1_59_0.tar.gz && cp boost_1_59_0 /usr/local/
#install mysql
wget -c https://cdn.mysql.com/archives/mysql-5.7/mysql-5.7.22.tar.gz &&\
tar -zxvf mysql-5.7.22.tar.gz && rm -f mysql-5.7.22.tar.gz && cd mysql-5.7.22 &&\
#make datadir ,homedir and backupdir
mkdir -p /home/mysql/data  /usr/local/mysql /backup
# add groupuser and user of mysql
groupadd mysql && useradd -g mysql mysql
chown -R mysql:mysql /home/mysql/data /backup
# cmake
cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_DATADIR=/var/lib/mysql -DSYSCONFDIR=/etc \
-DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 -DMYSQL_UNIX_ADDR=/tmp/mysqld.sock \
-DENABLED_LOCAL_INFILE=1 -DWITH_EXTRA_CHARSETS=all \
-DMYSQL_USER=mysql -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/boost_1_59_0
make && make install
#Configure Mysql
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
mkdir /var/lib/mysql && chown mysql. /var/lib/mysql
echo -e '[mysqld] \nbasedir = /usr/local/mysql \ndatadir = /var/lib/mysql \nport = 3306 \nsocket = /tmp/mysqld.sock' > /etc/my.cnf
#mysql_install_db 被废弃了，取而代之的是 mysqld –initialize
/usr/local/mysql/bin/mysqld --defaults-file=/etc/my.cnf --initialize  --datadir=/var/lib/mysql --basedir=/usr/local/mysql --user=mysql
systemctl start mysql
sed i 's/^PATH=$PATH:$HOME/bin/PATH=$PATH:$HOME/bin:/usr/local/mysql/bin/'  ~/.bash_profile
ln -s /usr/local/mysql/bin/mysql /usr/bin
#start mysql
chkconfig --add mysqld &&systemctl start mysql
chkconfig mysql on

# change the user of database
#/usr/local/mysql/bin/mysql -e"grant all on *.* to 'root'@'%' identified by '123456';"
#/usr/local/mysql/bin/mysql -e"grant all on *.* to 'root'@localhost identified by '123456';"
#/usr/local/mysql/bin/mysql -uroot -p123456 -e"delete from mysql.user where password='';"
# default my.cnf /usr/local/mysql/my.cnf


