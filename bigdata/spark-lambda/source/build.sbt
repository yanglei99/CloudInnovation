organization  := "spark-lambda"

name :=  "spark_lambda"

version       := "0.1-SNAPSHOT"

scalaVersion  := "2.10.5"

fork in run := true

resolvers ++= Seq(
  "spray repo" at "http://repo.spray.io/",
  "typesafe repo" at "http://repo.typesafe.com/typesafe/releases/"
)

libraryDependencies ++= {
  val sparkV =  "1.4.1"
  val hadoopV = "2.6.0"
  val kafkaV =  "0.8.2.1"
  Seq(
    "org.apache.spark"    %%  "spark-core"	  %  sparkV % "provided",
    "org.apache.spark"    %%  "spark-sql"	  %  sparkV % "provided",
    "org.apache.hadoop"   %   "hadoop-client" %  hadoopV % "provided",
    "org.apache.hadoop"   %   "hadoop-openstack" %  hadoopV % "provided",
    "org.apache.spark" 	  % "spark-streaming_2.10" % sparkV % "provided",
    "org.apache.spark" 	  % "spark-streaming-twitter_2.10" % sparkV,
    "org.apache.spark" 	  % "spark-streaming-kafka_2.10" % sparkV,
    "org.apache.kafka"    % "kafka_2.10" % kafkaV
  )
}