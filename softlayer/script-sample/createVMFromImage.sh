#!/bin/bash

sudo slcli vs create --datacenter=sjc01 --hostname=$1 --image=$2 --domain=ci.softlayer.com --cpu=2 --memory=2048 --key=$3 --billing=hourly --network=1000 
