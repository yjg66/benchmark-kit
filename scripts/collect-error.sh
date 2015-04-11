while read line
do
  ssh $line 'grep "Integrity" /mnt/spark/work/*/*/stderr' < /dev/null
done < ~/spark/conf/slaves

rm -r -f /tmp/*
