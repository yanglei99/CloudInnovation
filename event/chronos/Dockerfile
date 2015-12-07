# reference: http://mesos.github.io/chronos/docs/

FROM       ubuntu:14.04
MAINTAINER Yang Lei <yanglei@us.ibm.com>

# Folder structure:
#        Dockerfile
#        script/
#				the .sh for installation and start zeppline
#
# To build image once:
#
#        docker build -t dcos/chronos .
#
#
# To run container:
#
#		with minimum setting
#			docker run -d -P -e MASTER=$MASTER -e ZK_HOSTS=$ZK_HOSTS dcos/chronos
#
#		check ENV for other possible changes


WORKDIR /chronos

# Install Java and Mesos by reusing the installation script from mesos setup

WORKDIR /chronos

ADD script/* /chronos/
RUN chmod +x *.sh
RUN ./installMesos.sh
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so

# Install Maven

RUN apt-get install -y wget && wget http://mirror.cogentco.com/pub/apache/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz
RUN mkdir -p /usr/local/apache-maven && mv apache-maven-3.1.1-bin.tar.gz /usr/local/apache-maven && cd /usr/local/apache-maven && tar -xzvf apache-maven-3.1.1-bin.tar.gz

RUN rm /usr/bin/mvn  && ln -s /usr/local/apache-maven/apache-maven-3.1.1/bin/mvn /usr/bin/mvn && mvn --version

# Install Chronos

RUN apt-get install -y git node npm && git clone https://github.com/mesos/chronos.git
WORKDIR /chronos/chronos
RUN mvn clean package -DskipTests=true && mv target/chronos-*.jar chronos.jar

RUN mv ../run.sh .

#ENV MASTER 
#ENV ZK_HOSTS 
#ENV CASSANDRA_CP
ENV ZK_PATH /chronos/state

EXPOSE 8080 

CMD ["./run.sh"]
