#!/bin/bash

env | grep KAFKA
env | grep MESOS
env | grep HOST_IP

./kafka-mesos.sh scheduler --master=$MESOS_MASTER --storage=$KAFKA_STORAGE --zk=$KAFKA_ZK --api=http://$HOST_IP:7000 