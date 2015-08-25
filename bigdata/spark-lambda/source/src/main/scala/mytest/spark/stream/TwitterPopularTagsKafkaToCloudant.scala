/*
 * This is a combination of Spark SQL Cloudant and 
 *  https://github.com/apache/spark/blob/master/examples/src/main/scala/org/apache/spark/examples/streaming/TwitterPopularTags.scala
 *  https://github.com/apache/spark/blob/master/examples/scala-2.10/src/main/scala/org/apache/spark/examples/streaming/KafkaWordCount.scala
 *    spark-submit --class "mytest.spark.stream.TwitterPopularTagsKafkaToCloudant" --packages org.apache.kafka:kafka_2.10:0.8.2.1 --jars cloudant-spark.jar target/scala-2.10/spark_lambda_2.10-0.1-SNAPSHOT.jar  
 *      <zkQuorum> <group> <topics> <numThreads>  <cloudantHost> <cloudantUser> <cloudantPassword>
 *
 */
package mytest.spark.stream

import org.apache.spark.streaming.{Seconds, StreamingContext}
import org.apache.spark.SparkContext._
import org.apache.spark.streaming.twitter._
import org.apache.spark.SparkConf
import java.text.SimpleDateFormat
import java.util.HashMap
import org.apache.spark.SparkContext
import org.apache.spark.sql.SQLContext
import org.apache.spark.streaming.kafka.KafkaUtils
import org.apache.spark.streaming.Minutes

object TwitterPopularTagsKafkaToCloudant {
  def main(args: Array[String]) {

    if (args.length < 4) {
      System.err.println("Usage: TwitterPopularTagsKafkaToCloudant <zkQuorum> <group> <topics> <numThreads> <cloudantHost> <cloudantUser> <cloudantPassword>")
      System.exit(1)
    }

    val Array(zkQuorum, group, topics, numThreads,cloudantHost,cloudantUser,cloudantPassword) = args
    
    val sparkConf = new SparkConf().setAppName("TwitterPopularTagsKafkaToCloudant")
    sparkConf.set("cloudant.host",cloudantHost)
    sparkConf.set("cloudant.username", cloudantUser)
    sparkConf.set("cloudant.password",cloudantPassword)

    val ssc =  new StreamingContext(sparkConf, Seconds(20))
    ssc.checkpoint("checkpoint")

    val topicMap = topics.split(",").map((_,numThreads.toInt)).toMap
    val lines = KafkaUtils.createStream(ssc, zkQuorum, group, topicMap).map(_._2)

    val sc = ssc.sparkContext
    val sqlContext = new SQLContext(sc)
    import sqlContext._

      lines.foreachRDD(rdd => {
        val df = sqlContext.read.json(rdd)
        
        df.write.format("com.cloudant.spark").save("tweets_kafka")
    })

    ssc.start()
    ssc.awaitTermination()
  }
}
