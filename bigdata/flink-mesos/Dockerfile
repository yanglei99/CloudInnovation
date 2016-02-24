FROM       ubuntu:14.04
MAINTAINER Yang Lei <yanglei@us.ibm.com>

# The Fink Docker Image
#
# A revision from https://github.com/apache/flink/tree/master/flink-contrib/docker-flink
#
# Folder structure:
#        Dockerfile
#        config-flink..sh
#               config and start flink node. Include logic to calculate jobmanager master node from marathon or current host
#        conf
#		 		the flink config and supervisor config
#
# To build image once:
#
#        docker build -t flink . 
#
#


# Installation Prereq

RUN apt-get update && apt-get install -y wget curl

# Install supervisor and ssh

RUN apt-get install -y supervisor openssh-server openssh-client nano
RUN mkdir /var/run/sshd

RUN echo 'root:secret' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

## supervisor base configuration
ADD conf/supervisor.conf /etc/supervisor/

## add passless key to ssh
RUN ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/*

# Install JDK 8 

RUN apt-get install -y software-properties-common && add-apt-repository ppa:openjdk-r/ppa && apt-get update 
RUN apt-get install -y openjdk-8-jdk && java -version
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Download prebuild Flink 0.10.2 with Hadoop 2.6

RUN wget http://mirror.nexcess.net/apache/flink/flink-0.10.2/flink-0.10.2-bin-hadoop26.tgz
RUN mkdir -p /usr/local
RUN tar -xvzf flink-0.10.2-bin-hadoop26.tgz -C /usr/local
ENV FLINK_HOME /usr/local/flink-0.10.2
ENV PATH $FLINK_HOME/bin:$PATH

# Install JQ for processing JSON when needed

RUN apt-get install -y jq

# Config Flink

## config files (template)
ADD conf/flink-conf.yaml $FLINK_HOME/conf/
ADD config-flink.sh $FLINK_HOME/bin/
RUN chmod +x $FLINK_HOME/bin/config-flink.sh

EXPOSE 8081 8080
EXPOSE 6123 6121 6122
EXPOSE 22

#ENV FLINK_JOBMANAGER_HOST
ENV FLINK_JOBMANAGER_ID flink/jobmanager
ENV MARATHON_HOST http://marathon.mesos:8080
ENV FLINK_NUMBER_TASK_SLOT nproc
ENV FLINK_PARALLELISM 1
ENV FLINK_JOBMANAGER_HEAP 1024
ENV FLINK_TASKMANAGER_HEAP 1024
ENV FLINK_PROCESS_NAME jobmanager
#ENV FLINK_APP_JOB

VOLUME /flink/job

CMD ["config-flink.sh"]

