#!/bin/bash

env | grep MESOS

if [[ ! -z $MESOS_DNS_MARATHON ]]; then 
	echo calculate MESOS DNS IP
    text=$(curl -s $MESOS_DNS_MARATHON | ./jq .app.tasks[].host | sed -e 's/"/''/g'| sed -n -e 1p)
	echo "    $text"
	if [ "$text" != "" ]; then
		sed -i '1s/^/nameserver '$text' \n /' /etc/resolv.conf
		cat /etc/resolv.conf
	fi
fi

echo "end of change" > end.log

tail -F end.log