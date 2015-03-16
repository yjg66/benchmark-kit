# deploy bootstrap-sql

cd /mnt/bootstrap-sql && \
~/spark/sbin/stop-all.sh && \
cp -f conf/* ~/spark/conf/ && \
~/spark-ec2/copy-dir --delete ~/spark/conf && \
~/spark/sbin/start-all.sh
