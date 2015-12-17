## Mesos DNS

[Reference](https://mesosphere.github.io/mesos-dns/docs/)

### Start DNS on Marathon

####  Use Docker:
	
	curl -i -H 'Content-Type: application/json' -d@marathon/marathon-docker.json $marathonIp:8080/v2/apps
	
* Revise [config.json](config.json) with your configuration and upload

* Revise [marathon-docker.json](marathon/marathon-docker.json) with your config.json location


#### Verification

	dig $appName.marathon.mesos @$HOST_IP
	
	
### Enable the $HOST_IP on the mesos slave /etc/resolv.conf

	curl -i -H 'Content-Type: application/json' -d@marathon/marathon-resolv.json $marathonIp:8080/v2/apps


* Upload [mesos-dns-resolv-run.sh](mesos-dns-resolv-run.sh)

* Revise [marathon-resolv.json](marathon/marathon-resolv.json) with your mesos-dns-resolv-run.sh location


#### Verification

	dig $appName.marathon.mesos

### Known Issue
