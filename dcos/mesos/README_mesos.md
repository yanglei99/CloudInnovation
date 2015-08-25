## Mesos HA Cluster

* [Reference Mesos Cluster](http://mesos.apache.org/gettingstarted/)
* [Reference Mesosphere Download](https://mesosphere.com/downloads/)

![Image of Mesoss](../../doc/images/mesos.jpg)


### Install 3 Masters Cluster

* You can either provision all 3 master VM first and run the list of installations on each VM; or
* You can provision and install 1 VM first, create Softlayer Image Template, then use the template to create other master VMs. 

#### Installations

Installation | Script | Node Type | Details
--- | --- | --- | ---
Mesos | [installMesos.sh](conf/installMesos.sh) | Master, Slave |
ZK and Netflix Exhibitor | [installZK.sh](conf/installZK.sh) | Master | [Build Exhibitor](https://github.com/yanglei99/exhibitor/blob/master/swift/README_swift.md)
Marathon | [installMarathon.sh](conf/installMarathon.sh) | Master |
Docker | [installDocker.sh](conf/installDocker.sh) | Slave |

Image templates can be saved for reuse.


### Start and Verification

Start | Script | Node Type | Console
--- | --- | --- | ---
Mesos |[revise start-mesos-master.sh](conf/start-mesos-master.sh)| Master | http://master-ip:5050
Mesos |[revise start-mesos-slave.sh](conf/start-mesos-master.sh)| Slave | http://slave-ip:5051
ZK and Neflix Exhibotor | [revise start-zk.sh](conf/start-zk.sh)| Master |  http://zk-ip:8090/exhibitor/v1/ui/index.html |[Upload a default configuration](https://github.com/yanglei99/exhibitor/blob/master/swift/sample_config.properties) to swift object storage and make sure "Automatic Server List Add/Remove" is enabled. 
Marathon |[revise start-marathon.sh](conf/start-marathon.sh)| Master | http://marathon-ip:8080


### Make process run on startup

#### Master Nodes

	cp start-zk.sh /etc/init.d/
	update-rc.d start-zk.sh defaults 

	cp start-mesos-master.sh /etc/init.d/
	update-rc.d start-mesos-master.sh defaults 

	cp start-marathon.sh /etc/init.d/
	update-rc.d start-marathon.sh defaults 

#### Slave Nodes. Image saved for creeating Slave VMs

	cp start-mesos-slave.sh /etc/init.d/
	update-rc.d start-mesos-slave.sh defaults 



### Create Slave cluster Using Softlayer Auto Scale Group

[reference](http://knowledgelayer.softlayer.com/learning/introduction-softlayer-auto-scale)

* Use the saved slave image template

* To scale the auto scale group manually

	curl https://$username:$apikey@api.softlayer.com/rest/v3/SoftLayer_Scale_Group/$groupId/scaleTo/1


### Known Issue and Limitations

