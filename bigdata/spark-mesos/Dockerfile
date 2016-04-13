FROM       ubuntu:14.04
MAINTAINER Yang Lei <yanglei@us.ibm.com>

# The generic Spark Mesos Docker image
#
# Folder structure:
#        Dockerfile
#        installMesos.sh
#              	the script to install java and mesos
#        run.sh
#		 		the script that can start Spark Standalone Master/Slave, and also can submit spark job against all kinds of Spark Master
#
# To build image once:
#
#        docker build -t spark_mesos . 
#
#


# Installation Prereq

RUN apt-get update && apt-get install -y wget curl

# Install JDK 8 and Mesos

ADD installMesos.sh ./
RUN chmod +x installMesos.sh
RUN ./installMesos.sh
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Download prebuild Spark 1.6.1 with Hadoop 2.6+

RUN wget http://apache.claz.org/spark/spark-1.6.1/spark-1.6.1-bin-hadoop2.6.tgz
RUN mkdir -p /usr/local
RUN tar -xvzf spark-1.6.1-bin-hadoop2.6.tgz -C /usr/local
ENV SPARK_HOME /usr/local/spark-1.6.1-bin-hadoop2.6
ENV PATH $SPARK_HOME/bin:$PATH

# Install JQ for processing JSON when needed

RUN apt-get install -y jq

# Install pip

RUN apt-get -y install python-pip
RUN pip -v

# Add run script

WORKDIR /spark

ADD run.sh /spark/
RUN chmod +x run.sh

VOLUME /spark/job

WORKDIR /spark/job

ENV MARATHON_HOST http://marathon.mesos:8080
ENV SPARK_PROCESS_NAME application

ENV SPARK_MASTER mesos://zk://leader.mesos:2181/mesos
ENV SPARK_MESOS_COARSE true

#ENV SPARK_ADDITIONAL_CONFIG --conf spark.mesos.executor.docker.image=yanglei99/spark_meso
#ENV SPARK_ADDITIONAL_JARS --packages --jars
#ENV SPARK_JOB CloudantApp.py

#ENV SPARK_MASTER_ID spark/master
#ENV SPARK_MASTER_HOST

CMD ["/spark/run.sh"]

