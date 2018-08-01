#!/bin/bash
#mysql数据库备份
DATE=$(date +%F_%H-%M-%S)
HOST=192.168.1.120  #MySQL的主机ip
DB=test	#数据库名
USER=bak  #数据库用户名
PASS=123456	#数据库密码
MAIL="zhangsan@example.com lisi@example.com"  #收取邮箱的地址
BACKUP_DIR=/data/db_backup
SQL_FILE=${DB}_full_$DATE.sql
BAK_FILE=${DB}_full_$DATE.zip
cd $BACKUP_DIR
if mysqldump -h$HOST -u$USER -p$PASS --single-transaction --routines --triggers -B $DB > $SQL_FILE; then
    zip $BAK_FILE $SQL_FILE && rm -f $SQL_FILE
    if [ ! -s $BAK_FILE ]; then
            echo "$DATE 内容" | mail -s "主题" $MAIL
    fi
else
    echo "$DATE 内容" | mail -s "主题" $MAIL
fi
find $BACKUP_DIR -name '*.zip' -ctime +14 -exec rm {} \;
