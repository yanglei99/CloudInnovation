#!/bin/bash

if [[ "$SPARK_USE_DOCKER_HOST" == "true" ]]; then 
	echo calculate Spark Driver Host
	export SPARK_DRIVER_HOST=$(ip addr show eth1 | awk '/inet / {print $2}' | cut -d/ -f1)
fi

if [[ ! -z $SPARK_DRIVER_HOST ]]; then 
	export SPARK_PUBLIC_DNS=$SPARK_DRIVER_HOST
	export SPARK_LOCAL_IP=$SPARK_DRIVER_HOST
	export SPARK_LOCAL_HOSTNAME=$SPARK_DRIVER_HOST
fi

env | grep SPARK
env | grep MESOS
env | grep MASTER

if [[ ! -z $SPARK_EXECUTOR_URI ]]; then 
    mycmd="$SPARK_HOME/bin/spark-submit --master=$MASTER --conf spark.driver.host=$SPARK_DRIVER_HOST --conf spark.mesos.coarse=$SPARK_MESOS_COARSE --conf spark.cores.max=$SPARK_CORES_MAX --conf spark.executor.uri=$SPARK_EXECUTOR_URI $SPARK_ADDITIONAL_CONFIG $SPARK_ADDITIONAL_JARS $SPARK_JOB"
elif [[ ! -z $SPARK_MESOS_EXECUTOR_HOME ]]; then  
    mycmd="$SPARK_HOME/bin/spark-submit --master=$MASTER  --conf spark.driver.host=$SPARK_DRIVER_HOST --conf spark.mesos.coarse=$SPARK_MESOS_COARSE --conf spark.cores.max=$SPARK_CORES_MAX --conf spark.mesos.executor.home=$SPARK_MESOS_EXECUTOR_HOME $SPARK_ADDITIONAL_CONFIG $SPARK_ADDITIONAL_JARS $SPARK_JOB"
else
    mycmd="$SPARK_HOME/bin/spark-submit --master=$MASTER $SPARK_ADDITIONAL_CONFIG $SPARK_ADDITIONAL_JARS $SPARK_JOB"
fi

echo $mycmd

cd $SPARKLING_WATER_HOME

eval $mycmd 

echo end of application > end.log

tail -F end.log

