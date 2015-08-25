#!/bin/bash

cd /root/spark/spark-1.4.1-bin

dev=eth0
host_ip=$(ip addr show $dev | awk '/inet / {print $2}' | cut -d/ -f1)

./sbin/start-master.sh -h $host_ip