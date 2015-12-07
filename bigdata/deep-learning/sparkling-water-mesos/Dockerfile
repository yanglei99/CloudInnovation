# reference https://github.com/h2oai/sparkling-water/blob/master/docker/sparkling-test/base/Dockerfile

FROM ubuntu:14.04

MAINTAINER Yang Lei <yanglei@us.ibm.com>

# Folder structure:
#        Dockerfile
#        script/
#				the .sh for installation and run application
#
# To build image once:
#
#        docker build -t ml/sparkling-h20 .
#
#

WORKDIR /sparkling-water

# Installation Prereq

RUN apt-get update && apt-get install -y git 

# Install Java and Mesos by reusing the installation script from mesos setup

ADD script/*.sh /sparkling-water/
RUN chmod +x *.sh
RUN ./installMesos.sh
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so

# Download prebuild Spark 1.5.1 with Hadoop 2.6 . 

RUN wget http://apache.cs.utah.edu/spark/spark-1.5.1/spark-1.5.1-bin-hadoop2.6.tgz
RUN mkdir -p /usr/local
RUN tar -xvzf spark-1.5.1-bin-hadoop2.6.tgz -C /usr/local
ENV SPARK_HOME /usr/local/spark-1.5.1-bin-hadoop2.6
ENV PATH $SPARK_HOME/bin:$PATH

# Get Spark-Cloudant 

RUN wget https://github.com/yanglei99/spark-cloudant/releases/download/v1.5.1.0/cloudant-spark.jar

# Install Sparkling-Water for Spark 1.5.1

RUN curl -s http://h2o-release.s3.amazonaws.com/sparkling-water/rel-1.5/6/sparkling-water-1.5.6.zip --output sw.zip && \
  unzip sw.zip  && \
  ln -s ./sparkling-water-1.5.6/examples ./examples && \
  rm -f sw.zip

ENV SPARKLING_WATER_HOME /sparkling-water/sparkling-water-1.5.6

# Add a prebuild sample jar with the changed AirlinesWithWeatherDemo to load sample data files from $SPARKLING_WATER_HOME/examples...

RUN wget https://s3-us-west-1.amazonaws.com/mydata.yl/sparkling-water-examples_2.10-0.2.17-SNAPSHOT.jar

ENV MASTER local[2]
ENV SPARK_MESOS_COARSE true
ENV SPARK_CORES_MAX 6
#ENV SPARK_EXECUTOR_URI http://apache.cs.utah.edu/spark/spark-1.5.1/spark-1.5.1-bin-hadoop2.6.tgz
#ENV SPARK_ADDITIONAL_JARS --jars /sparkling-water/cloudant-spark.jar
ENV SPARK_ADDITIONAL_CONFIG --conf spark.executor.memory=2g
ENV SPARK_JOB --packages ai.h2o:sparkling-water-core_2.10:1.5.1,ai.h2o:sparkling-water-examples_2.10:1.5.1 --class org.apache.spark.examples.h2o.AirlinesWithWeatherDemo /dev/null

CMD ["./run.sh"]
