"""
 Usage: spark-submit --jars cloudant-spark.jar DelayAvg_Cloudant_HDFS.py <cloudantHost> <cloudantUser> <cloudantPassword> <dbName> <groupBy> <targetPath>
"""
from __future__ import print_function

import sys
from pyspark.sql import SQLContext
from pyspark import SparkContext, SparkConf
import pyspark.sql.functions as func

if __name__ == "__main__":
    if len(sys.argv) != 7:
        print("Usage: DelayAvg_Cloudant_HDFS.py  <cloudantHost> <cloudantUser> <cloudantPassword> <dbName> <groupBy> <targetPath>", file=sys.stderr)
        exit(-1)

    conf = SparkConf().setAppName("Calculate average airport delays to HDFS")
    # define coudant related configuration
    conf.set("jsonstore.rdd.maxInPartition",1000)
    conf.set("spark.network.timeout",1000)

    sc = SparkContext(conf=conf)
    sqlContext = SQLContext(sc)

    cloudant_host = sys.argv[1]
    cloudant_username = sys.argv[2]
    cloudant_password = sys.argv[3]
    dbName = sys.argv[4]
    groupBy = sys.argv[5].split(',')
    targetPath = sys.argv[6]

    print("groupBy:"+str(groupBy).strip('[]'))

    df = sqlContext.read.format("com.cloudant.spark").option("cloudant.host",cloudant_host).option("cloudant.username",cloudant_username).option("cloudant.password",cloudant_password).load(dbName).cache()
    groupDf= df.groupBy(groupBy).agg({'arr_delay':'avg'}).withColumnRenamed("AVG(arr_delay)", "arr_delay").orderBy(groupBy).cache()
    groupDf.show()
    groupDf.write.format("json").mode("overwrite").save(targetPath)