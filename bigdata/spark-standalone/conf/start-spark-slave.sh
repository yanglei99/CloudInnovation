#!/bin/bash

cd /root/spark/spark-1.4.1-bin

dev=eth0
host_ip=$(ip addr show $dev | awk '/inet / {print $2}' | cut -d/ -f1)
spark_master_url=spark://10.90.81.56:7077

./sbin/start-slave.sh $spark_master_url -h $host_ip