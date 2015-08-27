#!/bin/bash

# Prep the environment

apt-get update && apt-get install -y autoconf libtool build-essential python-dev python-boto libcurl4-nss-dev libsasl2-dev maven libapr1-dev libsvn-dev wget curl

# Install JDK

apt-get install -y openjdk-7-jdk 

# Install Mesos

cd /root

wget http://downloads.mesosphere.io/master/ubuntu/14.04/mesos_0.23.0-1.0.ubuntu1404_amd64.deb

dpkg -i mesos_0.23.0-1.0.ubuntu1404_amd64.deb &&  apt-get install -y -f 

