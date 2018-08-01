#!/bin/bash
#选择SSH连接主机
PS3="Please input number: "
HOST_FILE=host
#写一个配置文件保存被监控主机SSH连接信息，文件内容格式：主机名 IP User Port
while true; do
    select NAME in $(awk '{print $1}' $HOST_FILE) quit; do
        [ ${NAME:=empty} == "quit" ] && exit 0
        IP=$(awk -v NAME=${NAME} '$1==NAME{print $2}' $HOST_FILE)
        USER=$(awk -v NAME=${NAME} '$1==NAME{print $3}' $HOST_FILE)
        PORT=$(awk -v NAME=${NAME} '$1==NAME{print $4}' $HOST_FILE)
        if [ $IP ]; then
            echo "Name: $NAME, IP: $IP"
            ssh -o StrictHostKeyChecking=no -p $PORT -i id_rsa $USER@$IP  # 密钥登录
            break
        else
            echo "Input error, Please enter again!"
            break
        fi
    done
done
