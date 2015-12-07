
FROM ubuntu:14.04

MAINTAINER Yang Lei <yanglei@us.ibm.com>

# Folder structure:
#        Dockerfile
#        python/
#				the .py test applications
#        script/
#				the .sh for installation and run application
#		 lib/
#				the built spark distribution spark-1.4.1-bin-custom-spark-softlayer.tgz and core-site.xml
#		 source/
#				the lambda application in scala
#
# To build image once:
#
#        docker build -t spark/lambda .
#
#
# To run container:
#
#		with minimum setting
#			docker run -d -e SPARK_DRIVER_HOST=$HOST_IP spark/lambda 
#			docker run -d -e SPARK_DRIVER_HOST=$HOST_IP -e SPARK_JOB_LOCATION="--class mytest.spark.CloudantDFOption"  spark/lambda 
#
#		check ENV for other possible changes

WORKDIR /spark-cloudant

# Install Java and Mesos by reusing the installation script from mesos setup

ADD script/* /spark-cloudant/
RUN chmod +x *.sh
RUN ./installMesos.sh
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so

# Add prebuild Spark 1.4.1 with Hadoop 2.6 and Softlayer Object Storage support

COPY lib/* /spark-cloudant/
RUN mkdir -p /usr/local
RUN tar -xvzf spark-1.4.1-bin-custom-spark-softlayer.tgz -C /usr/local
ENV SPARK_HOME /usr/local/spark-1.4.1-bin-custom-spark-softlayer 
ENV PATH $SPARK_HOME/bin:$PATH

RUN mv core-site.xml  $SPARK_HOME/conf

# Install Spark-Cloudant 

RUN wget https://github.com/cloudant/spark-cloudant/releases/download/v1.4.1.1/cloudant-spark.jar

# Add python jobs

RUN mkdir -p  /spark-cloudant/python/
ADD python/* /spark-cloudant/python/

# Sniff test
RUN spark-submit  --master local[4] --jars cloudant-spark.jar python/CloudantDFOption.py
RUN spark-submit  --master local[4] --jars cloudant-spark.jar python/SwiftApp.py

# Install sbt
RUN echo "deb http://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-get update &&  apt-get install -y --fix-missing --force-yes sbt

# Build the Lambda Project

RUN mkdir -p  /spark-cloudant/source/
ADD source/ /spark-cloudant/source/
RUN cd /spark-cloudant/source  && sbt package && cp ./target/scala-2.10/spark_lambda_2.10-0.1-SNAPSHOT.jar ../spark_lambda.jar && cd .. && ls *.jar

ENV SPARK_MASTER mesos://zk:/mesos
ENV SPARK_JOB_LOCATION python/CloudantDFOption.py
ENV SPARK_DRIVER_HOST localhost
ENV SPARK_MESOS_COARSE true
ENV SPARK_CORES_MAX 6
ENV SPARK_EXECUTOR_URI http://www.apache.org/dyn/closer.cgi/spark/spark-1.4.1/spark-1.4.1-bin-hadoop2.6.tgz
#ENV SPARK_MESOS_EXECUTOR_HOME
#ENV SPARK_ADDITIONAL_CONFIG 
ENV SPARK_ADDITIONAL_JARS --jars cloudant-spark.jar

CMD ["./run.sh"]
