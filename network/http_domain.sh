#!/bin/bash
#检查多个域名是否能访问
URL="www.baidu.com www.sina.comwww.jd.com"
for url in $URL; do
   HTTP_CODE=$(curl -o /dev/null -s -w %{http_code} http://$url)
   if [ $HTTP_CODE -eq 200 -o $HTTP_CODE -eq 301 ]; then
       echo "$url OK."
   else
       echo "$url NO!"
   fi
done