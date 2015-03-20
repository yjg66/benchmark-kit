# deploy bootstrap-sql

cd /mnt/bootstrap-sql && \
/mnt/benchmark-kit/scripts/kill-all.sh && \
cp -f conf/* ~/spark/conf/ && \
~/spark-ec2/copy-dir --delete ~/spark/conf && \
~/persistent-hdfs/bin/start-dfs.sh && \
~/spark/sbin/start-all.sh
