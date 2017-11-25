#！、bin/bash
#方法1：
find . -name "*.html" -maxdepth 1 -exec du -b {} \; |awk '{sum+=$1}END{print sum}'
#方法2：
for size in $(ls -l *.html |awk '{print $5}'); do
    sum=$(($sum+$size))
done
echo $sum
#递归统计：
find . -name "*.html" -exec du -k {} \; |awk '{sum+=$1}END{print sum}'
