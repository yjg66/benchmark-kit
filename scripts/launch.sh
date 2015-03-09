# launch cluster
~/bootstrap-sql/ec2/spark-ec2 \
-k amplab-east \
-i ~/amplab-east.pem \
-s 5 \
--instance-type=r3.2xlarge \
--ebs-vol-size=80 \
# --ebs-vol-type=gp2 \
launch gola
