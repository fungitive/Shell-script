#!/usr/bin/env bash
echo -e '\e[33mInstall Environment\e[0m'
#Install Environment
yum -y install gcc gcc-c++ wget >/dev/null 2>&1
if [ $? -eq 0 ];then
echo -e '\e[32mThe Environment Install Successful!\e[0m'
else
echo -e '\e[31mThe Environment Install Failure!\e[0m'
exit 1
fi
echo -e '\e[33mInstall Apr\e[0m'
#Install Apr
wget -c http://archive.apache.org/dist/apr/apr-1.6.3.tar.gz &&\
tar -zxvf apr-1.6.3.tar.gz &&  rm -f apr-1.6.3.tar.gz &&\
cd apr-1.6.3 && ./configure --prefix=/usr/local/apr && make && make install >/dev/null 2>&1
if [ "$?" -eq "0" ];then
echo -e '\e[32mApr Install Success!\e[0m'
else
echo -e '\e[31mApr Install Failure!\e[0m'
exit 1
fi
echo -e '\e[33mInstall Apr-util\e[0m'
#Install Apr-util
wget -c http://archive.apache.org/dist/apr/apr-util-1.6.1.tar.gz &&\
tar -zxvf apr-util-1.6.1.tar.gz &&  rm -f apr-util-1.6.1.tar.gz &&\
cd apr-util-1.6.1 && ./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr/ && make && make install >/dev/null 2>&1
if [ "$?" -eq "0" ];then
echo -e '\e[32mApr-util Install Success!\e[0m'
else
echo -e '\e[31mApr-util Install Failure!\e[0m'
exit 1
fi
echo -e '\e[33mInstall Apr-util\e[0m'
#Install Apr
wget -c https://sourceforge.net/projects/pcre/files/pcre/8.42/pcre-8.42.tar.gz &&\
tar -zxvf pcre-8.42.tar.gz &&  rm -f pcre-8.42.tar.gz &&\
cd pcre-8.42 && ./configure --prefix=/usr/local/pcre && make && make install >/dev/null 2>&1
if [ "$?" -eq "0" ];then
echo -e '\e[32mApr-util Install Success!\e[0m'
else
echo -e '\e[31mApr-util Install Failure!\e[0m'
exit 1
fi

echo -e '\e[33mInstall Apache\e[0m'
#Install Apache
wget -c http://mirror.bit.edu.cn/apache/httpd/httpd-2.4.29.tar.gz && tar -zxvf httpd-2.4.29.tar.gz && cd httpd-2.4.29 &&\
./configure --prefix=/usr/local/apache --with-apr=/usr/local/apr/ --with-apr-util=/usr/local/apr-util/ --with-pcre=/usr/local/pcre && make && make install
if [ "$?" -eq "0" ];then
echo -e '\e[32mApache Server Install Success!\e[0m'
else
echo -e '\e[31mApache Server Install Failure!\e[0m'
exit 1
fi
###########################################################################################
echo -e '\e[33mStart and enable Apache \e[0m'
  systemctl start httpd && systemctl enable httpd >/dev/null 2>&1
if [ "$?" -eq "0" ];then
echo -e '\e[32mApache Server Install Success!\e[0m'
else
echo -e '\e[31mApache Server Install Failure!\e[0m'
exit 1
fi