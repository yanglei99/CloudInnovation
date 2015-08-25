# Kafka on Mesos

## Mesos Framework - Kafka 

[Reference here](https://github.com/mesos/kafka)

Kafka Scheduler is built in Docker and run on Mesos through Marathon.


### TO Build and Run 

[reference Dockerfile](Dockerfile)


#### To Run on Marathon

[revise marathon.json](marathon/marathon.json) 

	curl -i -H 'Content-Type: application/json' -d@marathon/marathon.json $marathonIp:8080/v2/apps


### Manage Brokers using REST API

     curl http://$HOST_IP:7000/api/brokers/add?id=0..2&cpus=1&mem=1024
     curl http://$HOST_IP:7000/api/brokers/start?id=0..2

     curl http://$HOST_IP:7000/api/brokers/status?id=0..2

     curl http://$HOST_IP:7000/api/brokers/stop?id=0..2

	 curl http://$HOST_IP:7000/api/brokers/remove?id=0..2


### To verify

#### About Topic 

Topic will be automatically created by the broker, you can also do the following

	bin/kafka-topics.sh --create --zookeeper $KAFKA_ZK --replication-factor 1 --partitions 1 --topic mytopic
	bin/kafka-topics.sh --list --zookeeper $KAFKA_ZK
	bin/kafka-topics.sh --describe --zookeeper $KAFKA_ZK/kafka --topic mytopic
	bin/kafka-topics.sh --zookeeper $KAFKA_ZK/kafka --delete --topic mytopic


#### Produce message

Get the broker endpoints

	curl http://$HOST_IP:7000/api/brokers/status

Produce Message

	kafka-console-producer.sh --broker-list $brokerList --topic mytopic


#### Consume message with Kafka Console Consumer

	kafka-console-consumer.sh --zookeeper $KAFKA_ZK --topic mytopic --from-beginning


#### Consume with Spark Stream over Kafka - run locally

[revise kafka_wordcount.py](python/kafka_wordcount.py) 

	spark-submit --packages org.apache.spark:spark-streaming-kafka_2.10:1.3.1 kafka_wordcount.py $KAFKA_ZK mytopic

## Other use cases

[Lambda Architecture with Spark](../spark-lambda/README_spark_lambda.md)

## Kwown Issues and Future Improvements
