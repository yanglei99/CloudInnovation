## Zeppelin on Mesos 

[Zeppelin](http://zeppelin.incubator.apache.org/docs/install/install.html)
[Zeppelin Tutorial](http://zeppelin.incubator.apache.org/docs/tutorial/tutorial.html)

![Image of Zeppelin on Mesos](../../doc/images/zeppelin_mesos.jpg)


### Build Docker Image 

[The image details](Dockerfile)

* Spark 1.4.1 with Hadoop 2.6 supporting SL Object Storage
* Download Spark SQL Cloudant 1.4.1.1

### Start on Marathon:
	
	curl -i -H 'Content-Type: application/json' -d@marathon/$marathonFile.json $marathonIp:8080/v2/apps
	
* [revise Zeppelin run local job](marathon/marathon-local.json). The zeppelin console is at http://$HOST_IP:8080

* [revise Zeppelin run on mesos job](marathon/marathon-mesos.json). The zeppelin console is at http://$HOST_IP:8080


### Verification

* [Notebook for Cloudant](notebook/CloudantDFOption.scala)


### Known Issue

* Mesos not working.  [all "/" in ZEPPELIN_JAVA_OPTS are converted to "." when content wrapped in ""](https://issues.apache.org/jira/browse/ZEPPELIN-266)
* Mesos not working. [ Executor Spark home `spark.mesos.executor.home` is not set! when ZEPPELIN_JAVA_OPTS not wrapped with ""](https://issues.apache.org/jira/browse/ZEPPELIN-120)

