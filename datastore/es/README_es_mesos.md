## Elastic Search on Mesos 

### Elastic Serach in Docker run on Marathon

[Elastic Search Dockerfile](https://github.com/docker-library/elasticsearch/tree/master/2.1)

#### Start on Marathon:

	
	curl -i -H 'Content-Type: application/json' -d@marathon/marathon-docker.json $marathonIp:8080/v2/apps
	curl -i -H 'Content-Type: application/json' -d@marathon/marathon-docker2.json $marathonIp:8080/v2/apps
	
* Depends on Mesos-DNS. Revise [first node](marathon/marathon-docker.json) and [all other nodes, using marathon to scale](marathon/marathon-docker2.json)

* Port at 9200, 9300

#### Known Issue



### Elastic Search Mesos Framework

[Elastic Search Framework on Mesos](http://mesos-elasticsearch.readthedocs.org/en/latest/)

![Image of Elastic on Mesos](../../doc/images/es_mesos.jpg)


#### Start on Marathon:
	
	curl -i -H 'Content-Type: application/json' -d@marathon/marathon-framework.json $marathonIp:8080/v2/apps
	
* 3 nodes executor cluster will be created. [Revise the elastic search definition](marathon/marathon-framework.json). 

* The console at: http://$HOST_IP:31100


#### Known Issue

* Executor hit "java.net.NoRouteToHostException: No route to host", due to mesos slave is using IP address?"Attempting to resolve hostname: "

