## Elastic Search on Mesos 

[Elastic Search on Mesos](http://mesos-elasticsearch.readthedocs.org/en/latest/)

![Image of Elastic on Mesos](../../doc/images/es_mesos.jpg)


### Start on Marathon:
	
	curl -i -H 'Content-Type: application/json' -d@marathon/marathon.json $marathonIp:8080/v2/apps
	
* 3 nodes executor cluster will be created. [Revise the elastic search definition](marathon/marathon.json). 

* The console at: http://$HOST_IP:31100

### Known Issue
