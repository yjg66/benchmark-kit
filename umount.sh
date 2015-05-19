while read line
do
  ssh $line 'rmdir /vol0' < /dev/null
done < ~/spark/conf/slaves
