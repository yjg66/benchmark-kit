#!/bin/bash

cd /mnt/bootstrap-sql

for blksz in 32k 128k 512k 2048k
do
	echo "REMARK: set block size to $blksz tuples per block..."

	./bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite \
		examples/target/scala-2.10/spark-examples-1.3.1-hadoop1.0.4.jar \
		drop

	./bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite \
		examples/target/scala-2.10/spark-examples-1.3.1-hadoop1.0.4.jar \
		create-parquet parquet-$blksz

	for option in run-0 run-1
	do
		for j in 1 2
		do
			for q in 1 10 11 12 14 16 17 18 19 20 22 3 5 6 7 8 9
			do
				./bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite \
					examples/target/scala-2.10/spark-examples-1.3.1-hadoop1.0.4.jar \
					$option $q 1
				../benchmark-kit/scripts/clean-work.sh
			done
		done
	done
done
