#!/bin/bash


export SPARK_PUBLIC_DNS=$SPARK_DRIVER_HOST
export SPARK_LOCAL_IP=$SPARK_DRIVER_HOST
export SPARK_LOCAL_HOSTNAME=$SPARK_DRIVER_HOST

env | grep SPARK

if [[ -z $SPARK_MESOS_EXECUTOR_HOME ]]; then 
    mycmd="spark-submit --master $SPARK_MASTER --conf spark.driver.host=$SPARK_DRIVER_HOST --conf spark.mesos.coarse=$SPARK_MESOS_COARSE --conf spark.cores.max=$SPARK_CORES_MAX --conf spark.executor.uri=$SPARK_EXECUTOR_URI $SPARK_ADDITIONAL_CONFIG $SPARK_ADDITIONAL_JARS $SPARK_JOB_LOCATION"
else
    mycmd="spark-submit --master $SPARK_MASTER --conf spark.driver.host=$SPARK_DRIVER_HOST --conf spark.mesos.coarse=$SPARK_MESOS_COARSE --conf spark.cores.max=$SPARK_CORES_MAX --conf spark.mesos.executor.home=$SPARK_MESOS_EXECUTOR_HOME $SPARK_ADDITIONAL_CONFIG $SPARK_ADDITIONAL_JARS $SPARK_JOB_LOCATION"
fi

echo $mycmd

eval $mycmd
