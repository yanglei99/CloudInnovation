#!/bin/bash

cd /root

wget http://mirrors.ibiblio.org/apache/zookeeper/stable/zookeeper-3.4.6.tar.gz
tar xvf zookeeper-3.4.6.tar.gz 
rm *.gz

mkdir -p /var/zookeeper/
echo '0' > /var/zookeeper/myid

# upload exhibitor to  /root/mesos/exhibitor-1.5.6-SNAPSHOT-all.jar