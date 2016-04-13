#!/bin/bash

if [ "$SPARK_MASTER_ID" != "" ]; then
	text=$(curl -s $MARATHON_HOST/v2/apps/$SPARK_MASTER_ID | jq .app.tasks[].host | sed -e 's/"/''/g'| sed -n -e 1p)
	echo calculate Spark Master from $MARATHON_HOST/v2/app/$SPARK_MASTER_ID : $text
	if [ "$text" == "" ]; then
		text=$(ip addr show eth1 | awk '/inet / {print $2}' | cut -d/ -f1)
		echo calculate Spark Master from current host: $text
	fi
	if [ "$text" != "" ]; then
		export SPARK_MASTER_HOST=$text
	fi
fi

if [ "$SPARK_MASTER_HOST" != "" ]; then
	export SPARK_MASTER=spark://$SPARK_MASTER_HOST:7077
fi

echo calculate Spark Driver Host
export SPARK_DRIVER_HOST=$(ip addr show eth1 | awk '/inet / {print $2}' | cut -d/ -f1)

if [[ ! -z $SPARK_DRIVER_HOST ]]; then 
	export LIBPROCESS_IP=$SPARK_DRIVER_HOST
	export SPARK_PUBLIC_DNS=$SPARK_DRIVER_HOST
	export SPARK_LOCAL_IP=$SPARK_DRIVER_HOST
fi

env | grep SPARK
env | grep MESOS
env | grep MARATHON

mkdir -p $SPARK_HOME/logs

if [ "$SPARK_PROCESS_NAME" == "master" ]; then
    echo "Start spark master on the node"
    $SPARK_HOME/sbin/start-master.sh -h $SPARK_DRIVER_HOST > $SPARK_HOME/logs/start.log
elif [ "$SPARK_PROCESS_NAME" == "slave" ]; then
    echo "Start spark slave on the node"
    $SPARK_HOME/sbin/start-slave.sh $SPARK_MASTER -h $SPARK_DRIVER_HOST> $SPARK_HOME/logs/start.log
elif  [ "$SPARK_PROCESS_NAME" == "application" ]; then
	if [ "$SPARK_JOB" != "" ]; then
		echo "Run Spark application: $SPARK_JOB"
		mycmd="$SPARK_HOME/bin/spark-submit --master $SPARK_MASTER  --conf spark.driver.host=$SPARK_DRIVER_HOST --conf spark.mesos.coarse=$SPARK_MESOS_COARSE $SPARK_ADDITIONAL_CONFIG $SPARK_ADDITIONAL_JARS $SPARK_JOB"
		echo $mycmd
		eval $mycmd 
		echo "End of job" >  $SPARK_HOME/logs/end.log
	else
		echo "No application defined " >  $SPARK_HOME/logs/end.log
	fi
else
		echo "No valid process defined: $SPARK_PROCESS_NAME" >  $SPARK_HOME/logs/end.log
fi

tail -F $SPARK_HOME/logs/*