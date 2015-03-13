while read line
do
  ssh $line 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4E+/a2EfcwolyMCZDoj6cLMJjs1VKBLybnsdO7OAVWNzan8j3CYQuyjGw3ozz6riy2nAmqXzSytAEqLYRF8Mci+Y2nLtqNy/xPW7tkaO/yq9wGIfP2z9tDzlGNQTuG+GQ+0/Ia8dqHnXLXnd7l6pFKuotqUpmIvNmXMIchTLKFOpIipGQFJwF7dqoFS71q+4YO8KB0/NyB1tMuwz2gSTBX+pIb3NJ89HRMiLSHZ56D/7yMCbSH0g0Y639YNPvJ+RQgPA7lkuHiWN3t63lLfgZnmmfYjYq8Hbke8gkSkuFxjgMU+oUswHYZd5/W9DqY2i1kmYuvX5CWnOQ4rdmhygX Kai@Lenovo-PC" >> ~/.ssh/authorized_keys' < /dev/null
done < ~/persistent-hdfs/conf/masters
while read line
do
  ssh $line 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4E+/a2EfcwolyMCZDoj6cLMJjs1VKBLybnsdO7OAVWNzan8j3CYQuyjGw3ozz6riy2nAmqXzSytAEqLYRF8Mci+Y2nLtqNy/xPW7tkaO/yq9wGIfP2z9tDzlGNQTuG+GQ+0/Ia8dqHnXLXnd7l6pFKuotqUpmIvNmXMIchTLKFOpIipGQFJwF7dqoFS71q+4YO8KB0/NyB1tMuwz2gSTBX+pIb3NJ89HRMiLSHZ56D/7yMCbSH0g0Y639YNPvJ+RQgPA7lkuHiWN3t63lLfgZnmmfYjYq8Hbke8gkSkuFxjgMU+oUswHYZd5/W9DqY2i1kmYuvX5CWnOQ4rdmhygX Kai@Lenovo-PC" >> ~/.ssh/authorized_keys' < /dev/null
done < ~/persistent-hdfs/conf/slaves
