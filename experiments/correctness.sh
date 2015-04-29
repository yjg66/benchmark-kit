#!/bin/bash

cd /mnt/bootstrap-sql

for option in test
do
	for j in 1
	do
		for q in 1 10 11 12 14 16 17 18 19 20 22 3 5 6 7 8 9
		do
			./bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite \
				examples/target/scala-2.10/spark-examples-1.3.1-hadoop1.0.4.jar \
				$option $q
		done
	done
done
