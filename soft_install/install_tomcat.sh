#!/usr/bin/env bash
yum install java-1.8.0-openjdk.x86_64
groupadd tomcat && mkdir /usr/local/tomcat &&\
useradd -s /bin/nologin -g tomcat -d /usr/local/tomcat tomcat
wget -c http://mirrors.shu.edu.cn/apache/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.tar.gz &&\
tar -zxvf apache-tomcat-8.5.31.tar.gz -C /usr/local/ && cd /usr/local/ &&\
mv apache-tomcat-8.5.31 tomcat && cd tomcat &&\
chown -R tomcat . && chgrp -R tomcat conf && chmod g+rwx conf && chmod g+r conf/*
touch /etc/systemd/system/tomcat.service
#将一下代码添加到tomcat.service上去
cat>>/etc/systemd/system/tomcat.service<<EOF
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID

User=tomcat
Group=tomcat

[Install]
WantedBy=multi-user.target
EOF
yum install haveged && systemctl start haveged.service &&systemctl enable haveged.service
firewall-cmd --zone=public --permanent --add-port=8080/tcp && firewall-cmd --reload
systemctl start tomcat.service &&systemctl enable tomcat.service