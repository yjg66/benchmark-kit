while read line
do
  ssh $line 'mkdir /mnt3 && mkfs.ext4 /dev/xvdh && mount /dev/xvdh /mnt3 -t ext4 && df -h' < /dev/null
done < ~/spark/conf/slaves
