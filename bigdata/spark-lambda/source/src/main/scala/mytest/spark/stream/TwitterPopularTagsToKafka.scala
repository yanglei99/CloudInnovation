/*
 * This is a combination of 
 *  https://github.com/apache/spark/blob/master/examples/src/main/scala/org/apache/spark/examples/streaming/TwitterPopularTags.scala
 *  https://github.com/apache/spark/blob/master/examples/scala-2.10/src/main/scala/org/apache/spark/examples/streaming/KafkaWordCount.scala
 *    spark-submit --class "mytest.spark.stream.TwitterPopularTagsToKafka" --packages org.apache.spark:spark-streaming-twitter_2.10:1.3.1,org.apache.kafka:kafka_2.10:0.8.2.1 target/scala-2.10/spark_stream_test_2.10-0.1-SNAPSHOT.jar  
 *    <consumerKey> <consumerSecret> <access token> <access token secret> <brokers> <topic> [<filters>]
 */
package mytest.spark.stream

import org.apache.spark.streaming.{Seconds, StreamingContext}
import org.apache.spark.SparkContext._
import org.apache.spark.streaming.twitter._
import org.apache.spark.SparkConf
import java.text.SimpleDateFormat
import java.util.HashMap
import org.apache.spark.streaming.kafka._
import org.apache.kafka.clients.producer.{ProducerConfig, KafkaProducer, ProducerRecord}

/**
 * Calculates popular hashtags (topics) over sliding 10 and 60 second windows from a Twitter
 * stream. The stream is instantiated with credentials and optionally filters supplied by the
 * command line arguments.
 *
 * Run this on your local machine as
 *
 */
object TwitterPopularTagsToKafka {
  def main(args: Array[String]) {
    if (args.length < 4) {
      System.err.println("Usage: TwitterPopularTagsToKafka <consumer key> <consumer secret> " +
        "<access token> <access token secret>  <brokers> <topic> [<filters>]")
      System.exit(1)
    }

    val Array(consumerKey, consumerSecret, accessToken, accessTokenSecret,brokers, topic) = args.take(6)
    
    val filters = args.takeRight(args.length - 6)

    // Set the system properties so that Twitter4j library used by twitter stream
    // can use them to generat OAuth credentials
    System.setProperty("twitter4j.oauth.consumerKey", consumerKey)
    System.setProperty("twitter4j.oauth.consumerSecret", consumerSecret)
    System.setProperty("twitter4j.oauth.accessToken", accessToken)
    System.setProperty("twitter4j.oauth.accessTokenSecret", accessTokenSecret)

    val sparkConf = new SparkConf().setAppName("TwitterPopularTagsToKafka")
    val ssc = new StreamingContext(sparkConf, Seconds(20))
    val stream = TwitterUtils.createStream(ssc, None, filters)

    val hashTags = stream.flatMap(status => status.getText.split(" ").filter(_.startsWith("#")))

    val topCounts60 = hashTags.map((_, 1)).reduceByKeyAndWindow(_ + _, Seconds(60))
                     .map{case (topic, count) => (count, topic)}
                     .transform(_.sortByKey(false))


    val props = new HashMap[String, Object]()
    props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, brokers)
    props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG,
      "org.apache.kafka.common.serialization.StringSerializer")
    props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG,
      "org.apache.kafka.common.serialization.StringSerializer")

    val producer = new KafkaProducer[String, String](props)

    // Print popular hashtags

      topCounts60.foreachRDD(rdd => {
      val topList = rdd.take(10)
      val timestamp: Long = System.currentTimeMillis
      val simpleDateFormat = new SimpleDateFormat("MM/dd/yyyy' 'HH:mm:ss:S")
      val ts =simpleDateFormat.format(timestamp)
      println("\n[%s]Popular topics in last 20 seconds (%s total):".format(ts,rdd.count()))
      topList.foreach{
        case (count, tag) => {
          val json = """{"ts:":"%s","tag":"%s","tweets":%s}""".format(ts, tag, count)
          println(json)
          val message = new ProducerRecord[String, String](topic, null, json)
          producer.send(message)
        }
      }
    })

    ssc.start()
    ssc.awaitTermination()
  }
}
