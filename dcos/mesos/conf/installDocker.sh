#!/bin/bash

echo https://docs.docker.com/installation/ubuntulinux/

uname -r 

apt-get update

apt-get install -y wget

wget -qO- https://get.docker.com/ | sh

# usermod -aG docker ubuntu

docker run hello-world

