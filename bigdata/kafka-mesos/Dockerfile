# Reference https://github.com/mesos/kafka
# 
# To build image:
#
#	docker build -t kafka/scheduler .
#
# To run container
#
#   [not working]docker run -d -p 7000:7000 -e MESOS_MASTER=$MESOS_MASTER -e KAFKA_ZK=$KAFKA_ZK -e HOST_IP=$HOST_IP -h $(hostname) kafka/scheduler
#
#   docker run -d -e MESOS_MASTER=$MESOS_MASTER -e KAFKA_ZK=$KAFKA_ZK -e HOST_IP=$HOST_IP --net=host kafka/scheduler
#  

FROM ubuntu:14.04

MAINTAINER Yang Lei yanglei@us.ibm.com

# Prep the environment

RUN apt-get update && apt-get install -y autoconf libtool build-essential python-dev python-boto libcurl4-nss-dev libsasl2-dev maven libapr1-dev libsvn-dev wget curl git

# Install JDK

RUN apt-get install -y openjdk-7-jdk 

# Install Mesos to get Mesos Native Java Library

RUN wget http://downloads.mesosphere.io/master/ubuntu/14.04/mesos_0.23.0-1.0.ubuntu1404_amd64.deb
RUN dpkg -i mesos_0.23.0-1.0.ubuntu1404_amd64.deb &&  apt-get install -y -f 

# Install gradle

RUN wget https://services.gradle.org/distributions/gradle-2.6-bin.zip
RUN unzip gradle-2.6-bin.zip
RUN mv gradle-2.6 /opt/
RUN rm gradle-2.6-bin.zip

# Download and build mesos/kafka

RUN cd /root && git clone https://github.com/mesos/kafka && cd kafka && ./gradlew jar

WORKDIR /root/kafka

RUN wget https://archive.apache.org/dist/kafka/0.8.2.1/kafka_2.10-0.8.2.1.tgz

ADD run.sh /root/kafka/
RUN chmod +x *.sh
RUN mv kafka-mesos.properties kafka-mesos.properties.orig && ls

ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so
ENV KAFKA_STORAGE zk:/kafka-mesos

ENV MESOS_MASTER zk://master1:2181,master2:2181,master3:2181/mesos
ENV KAFKA_ZK master1:2181,master2:2181,master3:2181
ENV HOST_IP localhost

EXPOSE 7000


CMD ["./run.sh"]