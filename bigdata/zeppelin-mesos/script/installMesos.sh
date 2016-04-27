#!/bin/bash

# Install JDK 8

apt-get install -y software-properties-common
add-apt-repository ppa:openjdk-r/ppa
apt-get update 
apt-get install -y openjdk-8-jdk

java -version
ls -l /usr/lib/jvm/java-8-openjdk-amd64/

# Install Mesos reference https://mesosphere.com/downloads/

# Setup
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)

# Add the repository
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | \
  sudo tee /etc/apt/sources.list.d/mesosphere.list
sudo apt-get -y update

sudo apt-get -y install mesos

