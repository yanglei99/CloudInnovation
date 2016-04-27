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

if [[ "$MASTER" == *"mesos"* ]]; then
	export LIBPROCESS_IP=$SPARK_DRIVER_HOST
	export SPARK_PUBLIC_DNS=$SPARK_DRIVER_HOST
	export SPARK_LOCAL_IP=$SPARK_DRIVER_HOST
    echo export ZEPPELIN_JAVA_OPTS=\""-Dspark.driver.host=$SPARK_DRIVER_HOST -Dspark.mesos.coarse=$SPARK_MESOS_COARSE "\" > ./conf/zeppelin-env.sh
    echo ./conf/zeppelin-env.sh content
    cat ./conf/zeppelin-env.sh
    chmod +x ./conf/zeppelin-env.sh
fi

env | grep SPARK
env | grep ZEPPELIN
env | grep MESOS
env | grep MARATHON
env | grep MASTER

./bin/zeppelin-daemon.sh start 

tail -f ./logs/*