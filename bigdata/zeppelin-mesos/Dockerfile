# reference: https://github.com/apache/incubator-zeppelin

FROM       ubuntu:14.04
MAINTAINER Yang Lei <yanglei@us.ibm.com>

# Folder structure:
#        Dockerfile
#        script/
#				the .sh for installation and start zeppline
#
# To build image once:
#
#        docker build -t spark/zeppelin .
#
#
# To run container:
#
#		with minimum setting
#			docker run -d --net=host spark/zeppelin
#
#		check ENV for other possible changes


# Installation Prereq

RUN apt-get update && apt-get install -y wget curl

# Install JDK 8 and Mesos

ADD script/installMesos.sh ./
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

# Install Zeppelin Prereq

RUN apt-get update && apt-get install -y git npm libfontconfig
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN node --version

# Install Maven

RUN wget http://www.eu.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
RUN tar -zxf apache-maven-3.3.3-bin.tar.gz -C /usr/local/
RUN ln -s /usr/local/apache-maven-3.3.3/bin/mvn /usr/local/bin/mvn
RUN mvn --version


# Install Zeppelin

WORKDIR /zeppelin

# Git clone and build

RUN git clone https://github.com/apache/incubator-zeppelin.git

RUN cd incubator-zeppelin && mvn clean package -Pspark-1.6 -Dspark.version=1.6.1 -Phadoop-2.6 -Dhadoop.version=2.6.0  -Ppyspark -DskipTests

WORKDIR /zeppelin/incubator-zeppelin


# Add run script

ADD script/run.sh /zeppelin/incubator-zeppelin/
RUN chmod +x run.sh

ENV ZEPPELIN_NOTEBOOK_DIR /zeppelin/incubator-zeppelin/notebook
VOLUME /zeppelin/incubator-zeppelin/notebook
VOLUME /zeppelin/incubator-zeppelin/jars

ENV MARATHON_HOST http://marathon.mesos:8080
ENV SPARK_MESOS_COARSE true
#ENV MASTER mesos://zk://leader.mesos:2181/mesos
#ENV SPARK_SUBMIT_OPTIONS --conf spark.mesos.executor.docker.image=yanglei99/spark_meso

#ENV SPARK_MASTER_ID spark/master
#ENV SPARK_MASTER_HOST

EXPOSE 8080

CMD ["./run.sh"]



