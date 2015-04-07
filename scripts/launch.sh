# launch cluster
if [[ $# -ne 3 ]]
then
	echo "Usage: lauch [cluster name] [number of slaves] [ebs volume size in GB]"
else
	~/bootstrap-sql/ec2/spark-ec2 \
	-k amplab-east \
	-i ~/amplab-east.pem \
	-s $2 \
	--instance-type=r3.2xlarge \
	--ebs-vol-size=$3 \
	launch $1

	# --ebs-vol-type=gp2 \
fi


