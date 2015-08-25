#!/bin/bash

MESOS_ZK='zk://198.23.98.115:2181,198.23.85.80:2181,198.23.85.94:2181/mesos'
MESOS_QUORUM=2
HOST_IP=$(ip addr show eth1 | awk '/inet / {print $2}' | cut -d/ -f1)

echo $MESOS_ZK >/etc/mesos/zk
echo $MESOS_QUORUM > /etc/mesos-master/quorum
echo $HOST_IP > /etc/mesos-master/ip

cp /etc/mesos-master/ip /etc/mesos-master/hostname

service mesos-master restart