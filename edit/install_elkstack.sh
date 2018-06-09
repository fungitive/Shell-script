#!/usr/bin/env bash
#安装elasticsearch的yum源的密钥（这个需要在所有服务器上都配置）
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
#配置elasticsearch的yum源
cat>>/etc/yum.repos.d/elasticsearch.repo<<EOF
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
#安装java
wget http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm
rpm -ivh jdk-8u131-linux-x64.rpm
#安装elasticsearch
yum install -y elasticsearch
mkdir -p /data/es-data
#(自定义用于存放data数据的目录)
chown -R elasticsearch:elasticsearch /data/es-data
#修改elasticsearch的日志属主属组
chown -R elasticsearch:elasticsearch /var/log/elasticsearch/
#修改elasticsearch的配置文件
vim /etc/elasticsearch/elasticsearch.yml
#找到配置文件中的cluster.name，打开该配置并设置集群名称
cluster.name: demon
#找到配置文件中的node.name，打开该配置并设置节点名称
node.name: elk-1
#修改data存放的路径
path.data: /data/es-data
#修改logs日志的路径
path.logs: /var/log/elasticsearch/
#配置内存使用用交换分区
bootstrap.memory_lock: true
#监听的网络地址
network.host: 0.0.0.0
#开启监听的端口
http.port: 9200
#增加新的参数，这样head插件可以访问es (5.x版本，如果没有可以自己手动加)
http.cors.enabled: true
http.cors.allow-origin: "*"
#启动elasticsearch服务

firewall-cmd --zone=public --permanent --add-port=9200/tcp && firewall-cmd --reload

/etc/init.d/elasticsearch start
#修改参数：
vim /etc/elasticsearch/jvm.options
-Xms512m
-Xmx512m
