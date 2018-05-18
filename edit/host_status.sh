#!/bin/bash
#检查192.168.1.1的主机是否存活
if ping -c 1 192.168.1.1 >/dev/null;then 
        echo "OK."
else 
        echo "NO!"
fi