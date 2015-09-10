
FROM ubuntu:14.04

MAINTAINER Yang Lei <yanglei@us.ibm.com>

# Folder structure:On one of the LSF master nodes
#        Dockerfile
#        python/
#				the .py applications
#        script/
#				the .sh for installation and run application
#		 lib/
#				core-site.xml
#
# To build image once:
#
#        docker build -t spark/data-pipeline .
#
#

WORKDIR /spark-cloudant

# Install Java and Mesos by reusing the installation script from mesos setup

ADD script/* /spark-cloudant/
RUN chmod +x *.sh
RUN ./installMesos.sh
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so

# Download prebuild Spark 1.4.1 with Hadoop 2.6 and Softlayer Object Storage support

RUN wget https://s3-us-west-1.amazonaws.com/mydata.yl/spark-1.4.1-bin-softlayer.tgz
RUN mkdir -p /usr/local
RUN tar -xvzf spark-1.4.1-bin-softlayer.tgz -C /usr/local
ENV SPARK_HOME /usr/local/spark-1.4.1-bin-softlayer
ENV PATH $SPARK_HOME/bin:$PATH

# Add Swift configuration

ADD lib/core-site.xml $SPARK_HOME/conf/

# Install Spark-Cloudant 

RUN wget https://github.com/cloudant/spark-cloudant/releases/download/v1.4.1.3/cloudant-spark.jar

# Add python jobs

RUN mkdir -p  /spark-cloudant/python/
ADD python/* /spark-cloudant/python/

ENV SPARK_MASTER mesos://zk:/mesos
#ENV SPARK_JOB_LOCATION python/file.py
ENV SPARK_DRIVER_HOST localhost
ENV SPARK_MESOS_COARSE true
ENV SPARK_CORES_MAX 6
ENV SPARK_EXECUTOR_URI https://s3-us-west-1.amazonaws.com/mydata.yl/spark-1.4.1-bin-softlayer.tgz
#ENV SPARK_MESOS_EXECUTOR_HOME
#ENV SPARK_ADDITIONAL_CONFIG 
ENV SPARK_ADDITIONAL_JARS --jars cloudant-spark.jar

CMD ["./run.sh"]
