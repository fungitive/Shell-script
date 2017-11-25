#!/bin/bash
#方法1：
if [[ $1 =~ ^[0-9]+$ ]]; then
    echo "Is Number."
else
    echo "No Number."
fi
#方法2：
if [ $1 -gt 0 ] 2>/dev/null; then
    echo "Is Number."
else
    echo "No Number."
fi
#方法3
echo $1 |awk '{print $0~/^[0-9]+$/?"Is Number.":"No Number."}'  #三目运算符
12.14 找出包含关键字的文件
DIR=$1
KEY=$2
for FILE in $(find $DIR -type f); do
    if grep $KEY $FILE &>/dev/null; then
        echo "--> $FILE"
    fi
done
