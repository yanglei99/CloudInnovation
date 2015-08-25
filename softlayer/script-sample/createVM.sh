#!/bin/bash

sudo slcli vs create --datacenter=sjc01 --hostname=$1 --os=REDHAT_6_64  --domain=ci.softlayer.com --cpu=2 --memory=4096 --key=$2 --billing=hourly --network=1000 
