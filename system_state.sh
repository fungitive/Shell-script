#借助vmstat工具来分析CPU统计信息。
#!/bin/bash
DATE=$(date +%F" "%H:%M)
IP=$(ifconfig eth0 |awk -F '[ :]+' '/inet addr/{print $4}')  # 只支持CentOS6
MAIL="example@mail.com"
if ! which vmstat &>/dev/null; then
    echo "vmstat command no found, Please install procps package." 
    exit 1
fi
US=$(vmstat |awk 'NR==3{print $13}')
SY=$(vmstat |awk 'NR==3{print $14}')
IDLE=$(vmstat |awk 'NR==3{print $15}')
WAIT=$(vmstat |awk 'NR==3{print $16}')
USE=$(($US+$SY))
if [ $USE -ge 50 ]; then
    echo "
    Date: $DATE
    Host: $IP
    Problem: CPU utilization $USE
    " | mail -s "CPU Monitor" $MAIL
fi
#内存
#!/bin/bash
DATE=$(date +%F" "%H:%M)
IP=$(ifconfig eth0 |awk -F '[ :]+' '/inet addr/{print $4}')  
MAIL="example@mail.com"
TOTAL=$(free -m |awk '/Mem/{print $2}')
USE=$(free -m |awk '/Mem/{print $3-$6-$7}')
FREE=$(($TOTAL-$USE))
# 内存小于1G发送报警邮件
if [ $FREE -lt 1024 ]; then
    echo "
    Date: $DATE
    Host: $IP
    Problem: Total=$TOTAL,Use=$USE,Free=$FREE
    " | mail -s "Memory Monitor" $MAIL
fi
#硬盘
#!/bin/bash
DATE=$(date +%F" "%H:%M)
IP=$(ifconfig eth0 |awk -F '[ :]+' '/inet addr/{print $4}')  
MAIL="example@mail.com"
TOTAL=$(fdisk -l |awk -F'[: ]+' 'BEGIN{OFS="="}/^Disk \/dev/{printf "%s=%sG,",$2,$3}')
PART_USE=$(df -h |awk 'BEGIN{OFS="="}/^\/dev/{print $1,int($5),$6}')
for i in $PART_USE; do
    PART=$(echo $i |cut -d"=" -f1)
    USE=$(echo $i |cut -d"=" -f2)
    MOUNT=$(echo $i |cut -d"=" -f3)
    if [ $USE -gt 80 ]; then
        echo "
        Date: $DATE
        Host: $IP
        Total: $TOTAL
        Problem: $PART=$USE($MOUNT)
        " | mail -s "Disk Monitor" $MAIL
    fi
done
