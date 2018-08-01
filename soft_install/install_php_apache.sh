#!/usr/bin/env bash
#Install Php
wget -c http://cn2.php.net/distributions/php-5.6.36.tar.gz &&\
tar -xzvf php-5.6.36.tar.gz && cd php-5.6.36 && ./configure --prefix=/usr/local/php  --with-config-file-path=/usr/local/php/etc  --with-apxs2=/usr/local/apache/bin/apxs --with-mysql=/usr/local/mysql &&\
make && make install
if [ $? -eq 0 ];then
echo -e '\e[32mPhp Install Success!\e[0m'
else
echo -e '\e[31mPhp Install Failure!\e[0m'
exit 1
fi
###########################################################################################
# Integrate Php and Mysql
sed -i '311a AddType     application/x-httpd-php .php' /usr/local/apache/conf/httpd.conf &&
sed -i 's/index.html/index.php index.html/' /usr/local/apache/conf/httpd.conf
if [ $? -eq 0 ];then
echo -e '\e[32mIntegrate is Success!\e[0m'
/usr/local/apache/bin/apachectl start >/dev/null 2>&1
else
echo -e '\e[31mIntegrate is Failure!\e[0m'
exit 1
fi