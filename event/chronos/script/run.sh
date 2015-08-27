#!/bin/bash

if [ [ -z $CASSANDRA_CP ] ]; then
	java -cp chronos.jar org.apache.mesos.chronos.scheduler.Main --master $MASTER --zk_hosts $ZK_HOSTS --zk_path $ZK_PATH
else
	java -cp chronos.jar org.apache.mesos.chronos.scheduler.Main --master $MASTER --zk_hosts $ZK_HOSTS --zk_path $ZK_PATH --cassandra_contact_points $CASSANDRA_CP
fi