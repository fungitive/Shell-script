#!/bin/bash
# Description: Only CentOS6
traffic_unit_conv() {
    local traffic=$1
    if [ $traffic -gt 1024000 ]; then
        printf "%.1f%s" "$(($traffic/1024/1024))" "MB/s"
    elif [ $traffic -lt 1024000 ]; then
        printf "%.1f%s" "$(($traffic/1024))" "KB/s"
    fi
}
NIC=$1
echo -e " In ------ Out"
while true; do
    OLD_IN=$(awk -F'[: ]+' '$0~"'$NIC'"{print $3}' /proc/net/dev)
    OLD_OUT=$(awk -F'[: ]+' '$0~"'$NIC'"{print $11}' /proc/net/dev)
    sleep 1
    NEW_IN=$(awk -F'[: ]+' '$0~"'$NIC'"{print $3}' /proc/net/dev)
    NEW_OUT=$(awk -F'[: ]+' '$0~"'$NIC'"{print $11}' /proc/net/dev)
    IN=$(($NEW_IN-$OLD_IN))
    OUT=$(($NEW_OUT-$OLD_OUT))
    echo "$(traffic_unit_conv $IN) $(traffic_unit_conv $OUT)"
    sleep 1
done
# 也可以通过ficonfig命令获取收发流量
while true; do
    OLD_IN=$(ifconfig $NIC |awk -F'[: ]+' '/bytes/{print $4}')  
    OLD_OUT=$(ifconfig $NIC |awk -F'[: ]+' '/bytes/{print $9}')
    sleep 1
    NEW_IN=$(ifconfig $NIC |awk -F'[: ]+' '/bytes/{print $4}')
    NEW_OUT=$(ifconfig $NIC |awk -F'[: ]+' '/bytes/{print $9}')
    IN=$(($NEW_IN-$OLD_IN))
    OUT=$(($NEW_OUT-$OLD_OUT))
    echo "$(traffic_unit_conv $IN) $(traffic_unit_conv $OUT)"
    sleep 1
done
