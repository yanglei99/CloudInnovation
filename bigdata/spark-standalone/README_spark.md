## Spark Standalone Cluster

[Reference Spark Standlone](http://spark.apache.org/docs/latest/spark-standalone.html#installing-spark-standalone-to-a-cluster)


### Build 

* [Build Spark with SL Object Storage](README_build_spark.md)

### Preparation

* install java

	apt-get upate
	apt-get install -y openjdk-7-jdk


### Install and Verification

Save the base image in the end.

####  Upload and Install Spark

	cd /root/spark
	mkdir spark-1.4.1-bin
	tar -xvzf spark-1.4.1-bin-custom-spark-softlayer.tgz -C spark-1.4.1-bin --strip-components=1

#### Verification

*  copy [core-site-template.xml](conf/core-site-template.xml) to spark's conf directory as core-site.xml and modify with your API Key, account, user name

* [Revise SwiftApp.py](conf/SwiftApp.py). The test is to analyze a preload airline_delay_causes data on Softlayer Object Storage

*  verify with local master

	cd spark-1.4.1-bin
	./bin/spark-submit  --master local[4]  ../SwiftApp.py

*  verify with spark master and slave

	chmod +x */sh
	./start-spark-master.sh
	./start-spark-slave.sh
	
	./bin/spark-submit  --master spark://10.90.81.56:7077  ../SwiftApp.py
	

### Make Spark Master and Slave process run on startup

	Spark Cluster Console at http://spark master:8080


####  Master Node. 

	cp start-spark-master.sh /etc/init.d/
	update-rc.d start-spark-master.sh defaults 
	
####  Slave Node. Image saved for creeating Slave VMs

	cp start-spark-slave.sh /etc/init.d/
	update-rc.d start-spark-slave.sh defaults 


### Create Slave cluster Using Softlayer Auto Scale Group

[reference](http://knowledgelayer.softlayer.com/learning/introduction-softlayer-auto-scale)

* Use the saved slave image template

* To scale the auto scale group manually

	curl https://$username:$apikey@api.softlayer.com/rest/v3/SoftLayer_Scale_Group/$groupId/scaleTo/1



### Known Issue and Improvements

* Network security. Currently all spark communications are on private network. 