## HyperLedger 

[Reference](https://github.com/hyperledger/hyperledger)
[Fabric](https://github.com/hyperledger/fabric)


![Image of HyperLedger on Mesos](../../doc/images/hyperledger_mesos.jpg)

### Build the Docker Image

[Reference](https://github.com/hyperledger/fabric/blob/master/docs/dev-setup/install.md)

### Run on Mesosphere DCOS

	curl -i -H 'Content-Type: application/json' -d@marathon/marathon.json $marathonIp:8080/v2/apps
	
* [revise peer node vp0 start](marathon/marathon_vp0.json)
* [revise peer node vp1 start](marathon/marathon_vp1.json)
* [revise chain code deploy](marathon/marathon_chaincode_deploy.json)
* [revise chain code invoke with deployed chaincode name](marathon/marathon_chaincode_invoke.json)
* [revise chain code query with deployed chaincode name](marathon/marathon_chaincode_query.json)


### Known issues and Workaround

* On Mesos DCOS (CoreOS), make sure to [enable docker remote API](https://coreos.com/os/docs/latest/customizing-docker.html)

* Uploaded a built fabric-peer image to docker hub.

* Chain code deployment depends on hyperledger/fabric-baseimage which is not on docker.io . Worked around the issue by downloading a built image to the Mesos Agent(Slave)