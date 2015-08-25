#!/bin/bash

MARATHON_ZK='zk://198.23.98.115:2181,198.23.85.80:2181,198.23.85.94:2181/marathon'

mkdir -p /etc/marathon/conf
cp /etc/mesos-master/hostname /etc/marathon/conf 
cp /etc/mesos/zk /etc/marathon/conf/master

echo $MARATHON_ZK >/etc/marathon/conf/zk

service marathon restart