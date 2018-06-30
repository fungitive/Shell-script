#!/usr/bin/env bash
##环境准备##
echo -e '\e[33mInstall httpd\e[0m'
yum install -y httpd

echo -e '\e[33mInstall mariadb\e[0m'
yum install -y httpd php php-fpm php-cli php-common php-gd php-mbstring php-mcrypt php-mysql php-pdo php-devel php-xmlrpc php-xml php-bcmath php-dba php-enchant mariadb-server

sed -i 's/post_max_size = 8M/post_max_size = 16M/g' /etc/php.ini
    sed -i 's/;default_charset = "UTF-8"/default_charset = "UTF-8"/g' /etc/php.ini
    sed -i 's/expose_php = On/expose_php = off/g' /etc/php.ini
    sed -i 's/max_execution_time = 30$/max_execution_time = 300/g' /etc/php.ini
    sed -i 's/max_input_time = 60/max_input_time = 300/g' /etc/php.ini
    sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php.ini
    sed -i 's/^;date.timezone =/date.timezone = Asia\/Shanghai/g' /etc/php.ini