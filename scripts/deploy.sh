# deploy bootstrap-sql

cd /mnt/bootstrap-sql && \
mkdir -p conf && \
cp -f ~/spark/conf/* conf/ && \
build/sbt -DskipTests -Phive -Phive-thriftserver assembly && \
rsync -r --delete . ~/spark && \
~/spark/sbin/stop-all.sh && \
~/spark-ec2/copy-dir --delete ~/spark && \
~/spark/sbin/start-all.sh
