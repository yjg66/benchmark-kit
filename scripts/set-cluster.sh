if [[ $# -ne 3 ]]
then
  echo "Usage: set-cluster [block size in MB] [memory in GB] [dataset scale]"
else
  # stop all
  /mnt/benchmark-kit/scripts/kill-all.sh

  # set up hdfs
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
  fi
  
  BLOCKSIZE=$(($1 * 1024 * 1024))
  sed -i 's/vol/vol0/g' ~/persistent-hdfs/conf/core-site.xml
  sed -i "s/134217728/$BLOCKSIZE/g" ~/persistent-hdfs/conf/hdfs-site.xml

  ~/spark-ec2/copy-dir --delete ~/persistent-hdfs/conf

  cp ~/persistent-hdfs/conf/* ~/mapreduce/conf/
  ~/spark-ec2/copy-dir --delete ~/mapreduce/conf

  if [ ! "$(ls -A /vol0/persistent-hdfs)" ]
  then
    ~/persistent-hdfs/bin/hadoop namenode -format
  fi
  
  # set up spark
  sed -i 's/ephemeral/persistent/g' ~/spark/conf/spark-env.sh
  sed -i 's/,\/mnt2\/spark//g' ~/spark/conf/spark-env.sh
  echo "export SPARK_WORKER_DIR=/mnt/spark/work" >> ~/spark/conf/spark-env.sh

  cp ~/persistent-hdfs/conf/core-site.xml ~/spark/conf/core-site.xml

  sed -i 's/ephemeral/persistent/g' ~/spark/conf/spark-defaults.conf
  sed -i "s/spark.executor.memory[ \t].*$/spark.executor.memory $2g/g" ~/spark/conf/spark-defaults.conf
  echo "spark.number.executors `cat ~/spark/conf/slaves | wc -l`" >> ~/spark/conf/spark-defaults.conf
  echo "spark.shuffle.consolidateFiles true" >> ~/spark/conf/spark-defaults.conf
  echo "spark.driver.memory $(($2 / 2))g" >> ~/spark/conf/spark-defaults.conf
  echo "spark.sql.autoBroadcastJoinThreshold 52428800" >> ~/spark/conf/spark-defaults.conf
  echo "spark.sql.online.test.scale $3" >> ~/spark/conf/spark-defaults.conf
  echo "spark.sql.broadcastTimeout 1200" >> ~/spark/conf/spark-defaults.conf

  ~/spark-ec2/copy-dir --delete ~/spark/conf

  # restart
  /mnt/benchmark-kit/scripts/start-all.sh
fi    
