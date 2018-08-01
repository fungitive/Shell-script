#!/bin/bash
#用法：./ping IP段    例如：./ping 192.168.0
NETWORK=$1
for HOST in $(seq 1 254)
do
        ping -c 1 -w 1 $NETWORK.$HOST &>/dev/null && result=0 || result=1
                if [ "$result" == 0 ];then
                        echo -e "\033[32;1m$NETWORK.$HOST is up! \033[0m"
                else
                        echo -e "\033[;31m$NETWORK.$HOST is down!\033[0m"
                fi
done