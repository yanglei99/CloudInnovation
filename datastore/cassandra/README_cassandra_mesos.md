## Cassandra on Mesos 

### Cassandra Node in Docker run on Marathon

[reference](https://hub.docker.com/_/cassandra/)

#### Start on Marathon:
	
	curl -i -H 'Content-Type: application/json' -d@marathon/marathon-docker.json $marathonIp:8080/v2/apps
	curl -i -H 'Content-Type: application/json' -d@marathon/marathon-docker2.json $marathonIp:8080/v2/apps
	
* revise [first node](marathon/marathon-docker.json) and [second node and scale with marathon](marathon/marathon-docker2.json) 

* Support Cassandra v3.0. You can revise the above json for other version of Cassandra

#### Verification

	cqlsh $HOST_IP:9042


#### Known Issue

* node restart hit node already exists issue, "Use cassandra.replace_address if you want to replace this node". Need to restart the seed node.



### Cassandra as Framework

[Cassandra on Mesos](https://github.com/mesosphere/cassandra-mesos)

![Image of Cassandra on Mesos](../../doc/images/cassandra_mesos.jpg)


#### Start Framework on Marathon:
	
	curl -i -H 'Content-Type: application/json' -d@marathon/marathon-framework.json $marathonIp:8080/v2/apps
	
* [revise the downloaded Cassandra on Mesos](marathon/marathon-framework.json). 


#### Verification

[Cassandra on Mesos REST API](http://mesosphere.github.io/cassandra-mesos/docs/rest-api.html)

	curl -i -H 'Content-Type: application/json' http://$HOST_IP:$CPORT/live-nodes
	
	cqlsh $liveNodeIP 9042

* Note you can get the above host and port from marathon application console

#### Known Issue

* Destroy marathon job will not stop the exectors and schedulers. 