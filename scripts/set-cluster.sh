if [[ $# -lt 2 ]]
then
  echo "Usage: set-cluster [dataset] [dataset scale] [memory in GB]"
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

    # set up rmate
    sudo wget -O /usr/local/bin/rsub https://raw.github.com/aurora/rmate/master/rmate
    chmod a+x /usr/local/bin/rsub
  fi
  
  sed -i 's/vol/vol0/g' ~/persistent-hdfs/conf/core-site.xml

  ~/spark-ec2/copy-dir --delete ~/persistent-hdfs/conf

  cp ~/persistent-hdfs/conf/* ~/mapreduce/conf/
  ~/spark-ec2/copy-dir --delete ~/mapreduce/conf

  if [ ! "$(ls -A /vol0/persistent-hdfs)" ]
  then
    ~/persistent-hdfs/bin/hadoop namenode -format
  fi
  
  DATASET=$1
  DATASCALE=$2
  MEMSIZE=56
  if [[ $# -eq 3 ]]
  then
    MEMSIZE=$3
  fi

  # set up spark
  # pointing to persistent hdfs
  sed -i 's/ephemeral/persistent/g' ~/spark/conf/spark-env.sh
  sed -i 's/ephemeral/persistent/g' ~/spark/conf/spark-defaults.conf
  cp ~/persistent-hdfs/conf/core-site.xml ~/spark/conf/core-site.xml
  # turn off /mnt2
  sed -i 's/,\/mnt2\/spark//g' ~/spark/conf/spark-env.sh
  # redirect log folder
  echo "export SPARK_WORKER_DIR=/mnt/spark/work" >> ~/spark/conf/spark-env.sh
  # mem size
  sed -i "s/spark.executor.memory[ \t].*$/spark.executor.memory $(($MEMSIZE))g/g" ~/spark/conf/spark-defaults.conf
  echo "spark.driver.memory $(($MEMSIZE / 2))g" >> ~/spark/conf/spark-defaults.conf
  # num of executors
  echo "spark.number.executors `cat ~/spark/conf/slaves | wc -l`" >> ~/spark/conf/spark-defaults.conf
  # consolidate files
  echo "spark.shuffle.consolidateFiles true" >> ~/spark/conf/spark-defaults.conf
  # other configs
  cat /mnt/benchmark-kit/$DATASET/conf/$DATASCALE/conf >> ~/spark/conf/spark-defaults.conf

  ~/spark-ec2/copy-dir --delete ~/spark/conf

  # restart all
  /mnt/benchmark-kit/scripts/start-all.sh
fi    
