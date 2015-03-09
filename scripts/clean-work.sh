while read line
do
  ssh $line 'rm -r -f /mnt/spark/work/* /tmp/*' < /dev/null
done < ~/spark/conf/slaves

rm -r -f /tmp/*
