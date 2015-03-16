while read line
do
  ssh $line 'pkill -SIGKILL java' < /dev/null
done < ~/spark/conf/slaves

pkill -SIGKILL java
