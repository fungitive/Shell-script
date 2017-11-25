#！/bin/bash
#获取8位随机字符串的方法
#方法1：
echo $RANDOM |md5sum |cut -c 1-8
#471b94f2
#方法2：
openssl rand -base64 4
#vg3BEg==
#方法3：
cat /proc/sys/kernel/random/uuid |cut -c 1-8
#ed9e032c
#获取8位随机数的方法
#方法1：
echo $RANDOM |cksum |cut -c 1-8
#23648321
#方法2：
openssl rand -base64 4 |cksum |cut -c 1-8
#38571131
#方法3：
date +%N |cut -c 1-8
#69024815
