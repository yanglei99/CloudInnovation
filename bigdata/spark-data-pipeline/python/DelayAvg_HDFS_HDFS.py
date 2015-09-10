"""
 Usage: spark-submit --jars cloudant-spark.jar DelayAvg_HDFS_HDFS.py <path> <groupBy> <targetPath>
"""
from __future__ import print_function

import sys
from pyspark.sql import SQLContext
from pyspark import SparkContext, SparkConf
import pyspark.sql.functions as func

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: DelayAvg_HDFS_HDFS.py <path> <groupBy> <targetPath>", file=sys.stderr)
        exit(-1)

    conf = SparkConf().setAppName("Calculate average airport delays view from HDFS to HDFS")
    conf.set("spark.network.timeout",1000)

    sc = SparkContext(conf=conf)
    sqlContext = SQLContext(sc)

    path = sys.argv[1]
    groupBy = sys.argv[2].split(',')
    targetPath = sys.argv[3]

    print("groupBy:"+str(groupBy).strip('[]'))

    df = sqlContext.read.format("json").load(path).cache()
    groupDf = df.groupBy(groupBy).agg({'arr_delay':'avg'}).withColumnRenamed("AVG(arr_delay)", "arr_delay").orderBy(groupBy).cache()
    groupDf.show()
    groupDf.write.format("json").mode("overwrite").save(targetPath)