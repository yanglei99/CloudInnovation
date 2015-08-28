#!/bin/bash

if [[ -n "$SPARK_DRIVER_HOST" ]]; then 
	export SPARK_PUBLIC_DNS=$SPARK_DRIVER_HOST
	export SPARK_LOCAL_IP=$SPARK_DRIVER_HOST
	export SPARK_LOCAL_HOSTNAME=$SPARK_DRIVER_HOST
fi


export ZEPPELIN_JAVA_OPTS="-Dspark.executor.uri=$SPARK_EXECUTOR_URI" 

env | grep SPARK
env | grep ZEPPELIN

./bin/zeppelin-daemon.sh start 

tail -f ./logs/*