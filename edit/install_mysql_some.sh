#!/bin/sh
MYSQL_CMD_DOR=/etc
DATA=/data
MYSQL_DATA=/usr/local/mysql
MYSQL_BIN=/usr/local/mysql/bin
for PORT in 3306 3307
    do
    mkdir -p $DATA/$PORT$DATA
    chown -R mysql:mysql $DATA
    \cp ${MYSQL_CMD_DOR}/my.cnf  $DATA/$PORT/

    sed -i "s/3306/${PORT}/g" $DATA/$PORT/my.cnf
    sed -i  s#${MYSQL_DATA}#$DATA/$PORT#g  $DATA/$PORT/my.cnf
    sed -i "s/^server-id = 1/server-id=`echo $PORT|cut -c 4-`/g" $DATA/$PORT/my.cnf
    chown -R mysql:mysql $DATA
    $MYSQL_DATA/scripts/mysql_install_db --basedir=$MYSQL_DATA --datadir=$DATA/$PORT$DATA --user=mysql
        chown -R mysql:mysql $DATA
    sleep 2
    $MYSQL_BIN/mysqld_safe --defaults-file=$DATA/$PORT/my.cnf &
    sleep 5
     netstat -ntlp|grep "$PORT"
    echo
    echo "---------step 2:chaneg mysql passwd--------------"
    sleep 5
    mysqladmin -uroot password '123456' -S  $DATA/$PORT/mysql.sock
    done
    netstat -nltp|grep ${PORT}