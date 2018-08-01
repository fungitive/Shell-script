#!/usr/bin/env bash
clear
if [[ $# -eq 0 ]]
then
#
reset_terminal=$(tput sgr0)

#Check OS Type
        os=$(uname -o)
        echo "OS Type:" $reset_terminal $os
#Check OS Release Version and Name
        os_name=$(cat /etc/redhat-release)
        echo "Check OS Release Version and Name is:" $reset_terminal $os_name
#Check Architecture
        architecture=$(uname -m)
        echo "Architecture:" $reset_terminal $architecture
#Check Kernel Release
        kernel=$(uname -r)
        echo "Kernel Release:" $reset_terminal $kernel
#Check Hostname $HOSTNAME
        echo "Hostname:" $reset_terminal $HOSTNAME
        hostname=$(uname -n)
#Check Internal IP
        internalip=$(hostname -I |awk '{ print $1}')
        echo "Internal ip:" $reset_terminal $internalip
#Check External IP
        externalip=$(curl -s ipecho.net/plain)
        echo "External IP:" $reset_terminal $externalip
#Check DNS
        nameserver=$(cat /etc/resolv.conf |grep -E "\<nameserver[ ]+"|awk '{print $NF}')
        echo "DNS:"  $reset_terminal $nameserver
#Check if connected to Internet or not
        ping -c 2 baidu.com &>/dev/null && echo "Internal:Connected" ||echo "Internal:Disconnected"

#Check Logged In Users
        who >/tmp/who
        echo "Logged in" && cat /tmp/who
        rm -f  /tmp/who
# Check CPU Usage 系统占用cpu
        system_cpu_usage=$(awk '/MemTotal/{total=$2}/MemFree/{free=$2}END{print (total-free)/1024}' /proc/meminfo)
        echo "CPU Usage:" $reset_terminal $system_cpu_usage
#Check App CPU usage 应用占用cpu
        app_cpu_usage=$(awk '/MemTotal/{total=$2}/MemFree/{free=$2}/^Cached/{cached=$2}/Buffers/{buffers=$2}END{print (total-free-cached-buffers)/1024}' /proc/meminfo)
        echo "App CPU usage:" $reset_terminal $app_cpu_usage
#Check CPU Load average
        loadaverage=$(top -n 1 -b|grep "load average:"|awk '{print $12 $13 $14}')
        echo "CPU Load average:" $reset_terminal $loadaverage
#check Disk average
        diskaverage=$(df -hP |grep -vE 'Filesystem|tmpfs|shm'|awk '{print $1 " "$5}')
fi
