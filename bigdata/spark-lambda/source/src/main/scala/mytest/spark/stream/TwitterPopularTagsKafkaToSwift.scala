/*
 * This is a combination of Spark Swift and 
 *  https://github.com/apache/spark/blob/master/examples/src/main/scala/org/apache/spark/examples/streaming/TwitterPopularTags.scala
 *  https://github.com/apache/spark/blob/master/examples/scala-2.10/src/main/scala/org/apache/spark/examples/streaming/KafkaWordCount.scala
 *    spark-submit --class "mytest.spark.stream.TwitterPopularTagsKafkaToSwift" --packages org.apache.kafka:kafka_2.10:0.8.2.1,org.apache.hadoop:hadoop-openstack:2.6.0 target/scala-2.10/spark_stream_test_2.10-0.1-SNAPSHOT.jar  
 *      <zkQuorum> <group> <topics> <numThreads> <swift://container.PROVIDER/path>
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

object TwitterPopularTagsKafkaToSwift {
  def main(args: Array[String]) {

    if (args.length < 4) {
      System.err.println("Usage: TwitterPopularTagsKafkaToSwift <zkQuorum> <group> <topics> <numThreads> <swift://container.PROVIDER/path>")
      System.exit(1)
    }

    val Array(zkQuorum, group, topics, numThreads, swiftPath) = args
    
    val sparkConf = new SparkConf().setAppName("TwitterPopularTagsKafkaToSwift")

    val ssc =  new StreamingContext(sparkConf, Seconds(30))
    ssc.checkpoint("checkpoint")

    val topicMap = topics.split(",").map((_,numThreads.toInt)).toMap
    val lines = KafkaUtils.createStream(ssc, zkQuorum, group, topicMap).map(_._2)

    val sc = ssc.sparkContext
    val sqlContext = new SQLContext(sc)
    import sqlContext._

    lines.foreachRDD(rdd => {
      	val timestamp: Long = System.currentTimeMillis 
        val fileName= s"$swiftPath/$timestamp"
        println(s"save to $fileName")
        val df = sqlContext.read.json(rdd)
        df.write.format("json").save(fileName)
    })

    ssc.start()
    ssc.awaitTermination()
  }
}
