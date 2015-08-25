#!/bin/bash

MESOS_ZK='zk://198.23.98.115:2181,198.23.85.80:2181,198.23.85.94:2181/mesos'
HOST_IP=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f1)
SLAVE_CONTAINERIZERS='docker,mesos'
SLAVE_ATTRIBUTES='size:m'
SLAVE_RESOURCES='ports:[31000-32000,7000-7001,7199-7199,9042-9042,9160-9160]'
SLAVE_EXECUTOR_REGISTRATION_TIMEOUT='5mins'
SLAVE_STRICT='false'


echo $MESOS_ZK >/etc/mesos/zk
echo $HOST_IP > /etc/mesos-slave/ip
cp /etc/mesos-slave/ip /etc/mesos-slave/hostname

echo $SLAVE_CONTAINERIZERS > /etc/mesos-slave/containerizers
echo $SLAVE_EXECUTOR_REGISTRATION_TIMEOUT > /etc/mesos-slave/executor_registration_timeout
echo $SLAVE_ATTRIBUTES >/etc/mesos-slave/attributes
echo $SLAVE_RESOURCES > /etc/mesos-slave/resources
echo $SLAVE_STRICT > /etc/mesos-slave/strict

rm -f /tmp/mesos/meta/slaves/latest

service mesos-slave restart