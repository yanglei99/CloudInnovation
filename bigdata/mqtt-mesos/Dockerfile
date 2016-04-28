FROM       ubuntu:14.04
MAINTAINER Yang Lei <yanglei@us.ibm.com>

# The MQTT Docker Image
#
# Folder structure:
#        Dockerfile
#
# To build image once:
#
#        docker build -t mqtt . 
#
#


# Installation Prereq

RUN apt-get update && apt-get install -y wget curl

# Install MQTT

RUN apt-get install -y python-software-properties software-properties-common
RUN apt-add-repository -y ppa:mosquitto-dev/mosquitto-ppa
RUN apt-get update
RUN apt-get install -y mosquitto mosquitto-clients python-mosquitto

EXPOSE 1883 8883


CMD ["mosquitto","--verbose"]

