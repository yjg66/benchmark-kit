option="benchmark"
if [[ $# -gt 0 ]]
then
  option+=$1
fi

/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 1; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 10; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 11; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 12; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 14; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 16; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 17; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 18; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 19; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 20; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 22; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 3; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 5; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 6; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 7; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 8; /mnt/benchmark-kit/scripts/clean-work.sh
/mnt/bootstrap-sql/bin/spark-submit --class org.apache.spark.examples.sql.hive.SQLSuite examples/target/scala-2.10/spark-examples-1.3.0-SNAPSHOT-hadoop1.0.4.jar $option 9; /mnt/benchmark-kit/scripts/clean-work.sh
