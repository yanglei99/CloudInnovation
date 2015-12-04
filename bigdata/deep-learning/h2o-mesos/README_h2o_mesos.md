## H2O on Mesos 

[H2O](https://github.com/h2oai/h2o-3)

![Image of H2O on Mesos](../../../doc/images/h2o_mesos.jpg)


### Build Docker Image 

[Dockerfile](https://github.com/h2oai/h2o-3/blob/master/Dockerfile)

	git clone https://github.com/h2oai/h2o-3.git
	cd h2o-3
	docker build -t ml/h20 .

### Start on Marathon:
	
	curl -i -H 'Content-Type: application/json' -d@marathon/marathon.json $marathonIp:8080/v2/apps
	
* [revise job](marathon/marathon.json). The h2o console is at http://$HOST_IP:54321

