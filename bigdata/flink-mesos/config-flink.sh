#!/bin/bash

################################################################################
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

env | grep FLINK

text=$(curl -s $MARATHON_HOST/v2/apps/$FLINK_JOBMANAGER_ID | jq .app.tasks[].host | sed -e 's/"/''/g'| sed -n -e 1p)
echo calculate Flink Job Manager Host from $MARATHON_HOST/v2/app/$FLINK_JOBMANAGER_ID : $text

if [ "$text" == "" ]; then
	text=$(ip addr show eth1 | awk '/inet / {print $2}' | cut -d/ -f1)
	echo calculate Flink Job Manager Host from current host: $text
fi

if [ "$text" != "" ]; then
	export FLINK_JOBMANAGER_HOST=$text
	env | grep FLINK_JOBMANAGER_HOST
fi


CONF=$FLINK_HOME/conf
EXEC=$FLINK_HOME/bin

echo replace $CONF/flink-conf.yaml

sed -i -e "s/%jobmanager_heap%/$FLINK_JOBMANAGER_HEAP/g" $CONF/flink-conf.yaml
sed -i -e "s/%taskmanager_heap%/$FLINK_TASKMANAGER_HEAP/g" $CONF/flink-conf.yaml
sed -i -e "s/%nb_slots%/$FLINK_NUMBER_TASK_SLOT/g" $CONF/flink-conf.yaml
sed -i -e "s/%parallelism%/$FLINK_PARALLELISM/g" $CONF/flink-conf.yaml
sed -i -e "s/%jobmanager%/$FLINK_JOBMANAGER_HOST/g" $CONF/flink-conf.yaml

echo "config file: " && cat $CONF/flink-conf.yaml

if [ "$FLINK_PROCESS_NAME" = "jobmanager" ]; then
    echo "Configuring Job Manager on this node"
    $EXEC/jobmanager.sh start cluster
    $EXEC/start-webclient.sh > $FLINK_HOME/log/start.log
elif [ "$FLINK_PROCESS_NAME" = "taskmanager" ]; then
    echo "Configuring Task Manager on this node"
    $EXEC/taskmanager.sh start > $FLINK_HOME/log/start.log
elif  [ "$FLINK_PROCESS_NAME" = "application" ]; then
	if [ "$FLINK_APP_JOB" != "" ]; then
		echo "Run flink application: $FLINK_APP_JOB"
		$EXEC/flink run -m $FLINK_JOBMANAGER_HOST:6123 $FLINK_APP_JOB
		echo "End of job" >  $FLINK_HOME/log/end.log
	else
		echo "No application defined " >  $FLINK_HOME/log/end.log
	fi
else
		echo "No valid process defined: $FLINK_PROCESS_NAME" >  $FLINK_HOME/log/end.log
fi

#add ENV variable to shell for ssh login
echo "export JAVA_HOME=$JAVA_HOME;" >> ~/.profile
echo "export PATH=$PATH:$JAVA_HOME/bin;" >> ~/.profile
echo "export FLINK_HOME=$FLINK_HOME;" >> ~/.profile
echo "export PATH=$PATH:$FLINK_HOME/bin;" >> ~/.profile
#echo "export F=$FLINK_HOME/;" >> ~/.profile

#run ssh server and supervisor
/usr/sbin/sshd &
supervisord -c /etc/supervisor/supervisor.conf &

# Tail the logs to keep container running

tail -F $FLINK_HOME/log/*.*


