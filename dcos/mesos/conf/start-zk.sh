#!/bin/bash

SWIFT_ACCOUNT=
SWIFT_USER=
SWIFT_APIKEY=
SWIFT_AUTH_URL=https://sjc01.objectstorage.softlayer.net/auth/v1.0
SWIFT_CONTAINER=
SWIFT_FILE=
HOST_IP=$(ip addr show eth1 | awk '/inet / {print $2}' | cut -d/ -f1)

alias jps=/usr/lib/jvm/java-7-openjdk-amd64/bin/jps

java -Djclouds.keystone.credential-type=tempAuthCredentials  -jar /root/mesos/exhibitor-1.5.6-SNAPSHOT-all.jar -c swift --hostname $HOST_IP--port 8090 --swiftbackup true --swiftidentity $SWIFT_ACCOUNT:$SWIFT_USER --swiftapikey $SWIFT_APIKEY --swiftauthurl $SWIFT_AUTH_URL --swiftconfig $SWIFT_CONTAINER:$SWIFT_FILE