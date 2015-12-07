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

RUN apt-get update && apt-get install -y git npm 

# Install Java and Mesos by reusing the installation script from mesos setup

WORKDIR /zeppelin

ADD script/* /zeppelin/
RUN chmod +x *.sh
RUN ./installMesos.sh
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so

# Get Spark-Cloudant and spark

RUN wget https://github.com/cloudant/spark-cloudant/releases/download/v1.4.1.1/cloudant-spark.jar
RUN wget https://s3-us-west-1.amazonaws.com/mydata.yl/spark-1.4.1-bin-custom-spark-softlayer.tgz

# Install Maven

RUN apt-get install -y wget && wget http://mirror.cogentco.com/pub/apache/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz
RUN mkdir -p /usr/local/apache-maven && mv apache-maven-3.1.1-bin.tar.gz /usr/local/apache-maven && cd /usr/local/apache-maven && tar -xzvf apache-maven-3.1.1-bin.tar.gz

RUN rm /usr/bin/mvn  && ln -s /usr/local/apache-maven/apache-maven-3.1.1/bin/mvn /usr/bin/mvn && mvn --version


# Git clone and build

RUN git clone https://github.com/apache/incubator-zeppelin.git

RUN cd incubator-zeppelin && mvn clean package -Pspark-1.4 -Dspark.version=1.4.1 -Dhadoop.version=2.6.0 -Phadoop-2.6 -DskipTests

RUN mv run.sh incubator-zeppelin 

ENV ZEPPELIN_NOTEBOOK_DIR /zeppelin/incubator-zeppelin/notebook
VOLUME /zeppelin/incubator-zeppelin/notebook

WORKDIR /zeppelin/incubator-zeppelin

ENV SPARK_EXECUTOR_URI https://s3-us-west-1.amazonaws.com/mydata.yl/spark-1.4.1-bin-custom-spark-softlayer.tgz
ENV ZEPPELIN_PORT 8080
#SPARK_DRIVER_HOST

#ENV MASTER

CMD ["./run.sh"]

