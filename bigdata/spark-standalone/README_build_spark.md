## Build Spark 1.4.1 with Hadoop 2.6 for Softlayer Object Storage

[reference](https://www.ibm.com/developerworks/community/blogs/e90753c6-a6f1-4ae2-81d4-86eb33cf313c/entry/apache_spark_integrartion_with_softlayer_object_store?lang=en)

### Download Source Code

* [Download Spark 1.4.1 souce code](http://apache.cs.utah.edu/spark/spark-1.4.1/spark-1.4.1.tgz) and unzip
* [Download hadoop-2.6.0 source code](https://archive.apache.org/dist/hadoop/core/hadoop-2.6.0/hadoop-2.6.0-src.tar.gz) and unzip

### Build Hadoop with SoftLayer Object Storage


* [download HADOOP-10420-007.patch](https://issues.apache.org/jira/secure/attachment/12662347/HADOOP-10420-007.patch) and save under hadoop-2.6.0-src/hadoop-tools

	wget https://issues.apache.org/jira/secure/attachment/12662347/HADOOP-10420-007.patch
	
* Check that changes are visible and apply changes
	
	git apply --stat HADOOP-10420-007.patch
	git apply --check HADOOP-10420-007.patch
	git apply HADOOP-10420-007.patch
	
* build hadoop-tools/hadoop-openstack

	mvn -DskipTests package
	
* install the jar to mvn

	mvn -DskipTests install
	
### Build Spark

[reference](https://spark.apache.org/docs/latest/building-spark.html#building-with-buildmvn)

#### Prepare the Build

* make sure that main pom.xml has this dependency
	
      <dependency>
          <groupId>org.apache.hadoop</groupId>
          <artifactId>hadoop-openstack</artifactId>
          <version>${hadoop.version}</version>
          <scope>${hadoop.deps.scope}</scope>
      </dependency>
 
* make sure core/pom.xml has this dependency

    <dependency>
        <groupId>org.apache.hadoop</groupId>
        <artifactId>hadoop-openstack</artifactId>
     <exclusions>
        <exclusion>
          <groupId>javax.servlet</groupId>
          <artifactId>servlet-api</artifactId>
        </exclusion>
        <exclusion>
          <groupId>org.codehaus.jackson</groupId>
          <artifactId>jackson-mapper-asl</artifactId>
        </exclusion>
		<exclusion>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-all</artifactId>
        </exclusion>
      </exclusions>
    </dependency>
    
* increase Maven memory

	export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m"
    
#### Build

	build/mvn -Pyarn -Phadoop-2.6 -Dhadoop.version=2.6.0 -DskipTests clean package
	
#### Create runtime distribution

	./make-distribution.sh --name custom-spark-softlayer --tgz -Phadoop-2.6 -Pyarn

spark-1.4.1-bin-custom-spark-softlayer.tgz will be created.


### Verify Spark with SL Object Storage

* unzip spark-1.4.1-bin-custom-spark-softlayer.tgz

* Copy [core-site-template.xml](conf/core-site-template.xml) to spark's conf directory as core-site.xml and modify with your API Key, account, user name

* [Revise then submit SwiftApp.py](SwiftApp.py). The test is to analyze a preload airline_delay_causes data on Softlayer Object Storage

	./bin/spark-submit  --master local[4]  SwiftApp.py
	
	