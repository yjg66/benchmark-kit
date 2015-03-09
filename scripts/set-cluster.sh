if [[ $# -ne 2 ]]
then
  echo "Please specify the block size in MB and memory in GB"
else    
  if [ -d '/vol0/persistent-hdfs' ]
  then
    while read line
    do
      ssh $line 'chmod go-w `find /vol0 -type d`' < /dev/null
    done < ~/persistent-hdfs/conf/masters
    while read line
    do
      ssh $line 'chmod go-w `find /vol0 -type d`' < /dev/null
    done < ~/persistent-hdfs/conf/slaves
  else
    mkdir /vol0/persistent-hdfs
    ~/spar-ec2/copy-dir --delete /vol0/persistent-hdfs
    ~/persistent-hdfs/bin/hadoop namenode -format
  fi    
  
  BLOCKSIZE=$(($1 * 1024 * 1024))
  sed -i 's/vol/vol0/g' ~/persistent-hdfs/conf/core-site.xml
  sed -i "s/134217728/$BLOCKSIZE/g" ~/persistent-hdfs/conf/hdfs-site.xml
  ~/spark-ec2/copy-dir --delete ~/persistent-hdfs/conf
  
  ~/ephemeral-hdfs/bin/stop-dfs.sh
  ~/persistent-hdfs/bin/start-dfs.sh
  
  sed -i 's/ephemeral/persistent/g' ~/spark/conf/spark-env.sh
  sed -i 's/,\/mnt2\/spark//g' ~/spark/conf/spark-env.sh
  sed -i 's/ephemeral/persistent/g' ~/spark/conf/spark-defaults.conf
  sed -i "s/55047m/$2g/g" ~/spark/conf/spark-defaults.conf
  echo "spark.number.executors `cat ~/spark/conf/slaves | wc -l`" >> ~/spark/conf/spark-defaults.conf
  echo "export SPARK_WORKER_DIR=/mnt/spark/work" >> ~/spark/conf/spark-env.sh

  ~/spark/sbin/stop-all.sh
  sleep 3
  ~/spark/sbin/start-all.sh
fi    
