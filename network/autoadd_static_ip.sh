#!/bin/bash
shopt -s -o nounset
#Define Variable
ETHCONFIG='/etc/sysconfig/network-scripts/ifcfg-eth1'
HOSTS='/etc/hosts'
NETWORK='/etc/sysconfig/network'
BAKDIR="/data/backup/`date +%Y%m%d`"
NETMASK='255.255.255.0'
GATEWAY='192.168.1.254'
DNS1='8.8.8.8'
################################################################################
####################################Define Function#############################
################################################################################
function CHANGE_IP(){
#Create Directory
if [ ! -d $BAKDIR ];then
mkdir -p $BAKDIR
fi
#Prompt Information
#Backup Network File
cp $ETHCONFIG $BAKDIR/`date +%Y%m%d`.${ETHCONFIG:37}$$ && 
echo -e "\e[32mNow Change Ip Address, Backup Interface ${ETHCONFIG:37} to $BAKDIR Done\e[0m"
#Judge Get Ip Mode
if `grep -q  -i  'dhcp' $ETHCONFIG` ;then
#Change Get Ip Mode
sed -i 's/dhcp/static/Ig' $ETHCONFIG 
sed -i 's/^DNS/#DNS/Ig'  $ETHCONFIG
echo -e "IPADDR=$IPADDR\nNETMASK=$NETMASK\nGATEWAY=$GATEWAY\nDNS1=$DNS1" >> $ETHCONFIG 
        echo -e '\e[32mIP Change Success!\e[0m'
else
#Warning Information
echo -e "\e[31mThe Network alreday is static,Please ensure YES or NO: " 
read i
                #Again Confirm
if [ "$i" == "y" -o "$i" == "yes" -o "$i" == "YES" ];then
#Comment Old Configure 
sed -i -e 's/^IPADDR/#IPADDR/g' -e 's/^NETMASK/#NETMASK/g' -e 's/^GATEWAY/#GATEWAY/g' -e 's/^DNS/#DNS/g' $ETHCONFIG
echo -e "IPADDR=$IPADDR\nNETMASK=$NETMASK\nGATEWAY=$GATEWAY\nDNS1=$DNS1" >> $ETHCONFIG 
echo -e "\e[32mThe Ip Address is $IPADDR ,Change Success!\e[0m"
else
#Exit
echo -e "\e[31mThis $ETHCONFIG static exist, exiting...\e[0m"
fi
fi
}
################################################################################
#Check Ip Address
function CHECK_IP(){
read -p "Please Input Ip address: " IPADDR
#Test IP Format
echo $IPADDR|grep "^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$" > /dev/null 2>&1
num=$?
if [ $num -ne 0 ];then
echo -e "\e[31mPlease Check IP Format exiting....\e[0m"
exit 2
else
#Get Part Of Ip 
a=`echo $IPADDR|awk -F. '{print $1}'`
b=`echo $IPADDR|awk -F. '{print $2}'`
c=`echo $IPADDR|awk -F. '{print $3}'`
d=`echo $IPADDR|awk -F. '{print $4}'`
if [ $a -gt 255 ] ||  [ $a -le 0 ];then
echo -e "\e[31mPlease Check IP Format exiting...\e[0m"
exit 2
fi
if [ $b -gt 255 ] || [ $b -lt 0 ];then
echo -e "\e[31mPlease Check IP Format exiting...\e[0m"
exit 2
fi
if [ $c -gt 255 ] || [ $c -lt 0 ];then
echo -e "\e[31mPlease Check IP Format exiting...\e[0m"
exit 2
fi
if [ $d -ge 255 ] || [ $d -le 0 ];then
echo -e "\e[31mPlease Check IP Format exiting...\e[0m"
exit 2
fi
export $IPADDR
fi
}
#Define PS3
PS3="Please Select Your Choose:"
select i in "Change IP And DNS For ${ETHCONFIG:37}" "Show ${ETHCONFIG:37} Config File"  "Restart Device ${ETHCONFIG:37}" "Show ${ETHCONFIG:37} Status"  "Exit" 
do 
CHOOSE=$REPLY
case $CHOOSE in 
1)
CHECK_IP
CHANGE_IP
;;
2)
cat $ETHCONFIG
;;
3)
ifdown ${ETHCONFIG:37} > /dev/null 2>&1 && ifup ${ETHCONFIG:37} > /dev/null 2>&1
if [ $? -eq 0 ];then 
echo -e "\e[32mRestart Device ${ETHCONFIG:37} Success.\e[0m"
else
echo -e "\e[31mRestart Device ${ETHCONFIG:37} Failure.\e[0m"
fi
;;
4)
ifconfig ${ETHCONFIG:37}
;;
5)
echo -e '\e[32mByeBye!\e[0m'
exit
;;
*)
echo -e '\e[31mError Number,Please Input Again!'
esac
done