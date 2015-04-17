sync && echo 3 > /proc/sys/vm/drop_caches

while read line
do
  ssh $line 'sync && echo 3 > /proc/sys/vm/drop_caches' < /dev/null
done < ~/spark/conf/slaves