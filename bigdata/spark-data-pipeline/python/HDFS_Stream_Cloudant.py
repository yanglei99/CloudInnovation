#The code is based Spark Streaming Sample


"""
 Download data from http://www.transtats.bts.gov/OT_Delay/OT_DelayCause1.asp?pn=1
 Usage: spark-submit --jars cloudant-spark.jar HDFS_Stream_Cloudant.py <source directory> <cloudantHost> <cloudantUser> <cloudantPassword> <dbName>
   <source directory> is the directory that Spark Streaming will use to find and read new text files.
"""
from __future__ import print_function

import sys
from time import time

from pyspark import SparkContext
from pyspark.streaming import StreamingContext
from pyspark.sql import SQLContext, Row

def string_or_number(s):
    try:
        z = int(s)
        return z
    except ValueError:
        try:
            z = int(float(s))
            return z
        except ValueError:
            return 0
	   
if __name__ == "__main__":
    if len(sys.argv) != 6:
        print("Usage: HDSF_Stream.py <source directory> <cloudantHost> <cloudantUser> <cloudantPassword> <dbName>", file=sys.stderr)
        exit(-1)

    sc = SparkContext(appName="HDFS Stream to Cloudant")
    ssc = StreamingContext(sc, 10)
    sqlContext = SQLContext(sc)

    lines = ssc.textFileStream(sys.argv[1])
    
    def createRow(p):
        listSize = len(p) - 1
        return Row(year=int(p[0]), month=int(p[1]),carrier=p[2],airport=p[4],arr_flights=string_or_number(p[listSize-15]), arr_delay=string_or_number(p[listSize-6]), \
                        carrier_delay=string_or_number(p[listSize-5]), weather_delay=string_or_number(p[listSize-4]),	nas_delay=string_or_number(p[listSize-3]),	security_delay=string_or_number(p[listSize-2]),	\
                        late_aircraft_delay=string_or_number(p[listSize-1]) )
                        
    airlineDelay = lines.map(lambda l: l.split(","))\
                  .filter(lambda x: len(x) >=21 and x[0]!=r'"year"')\
                  .map(lambda p: createRow(p))
    airlineDelay.pprint()
    
    def process(rdd, cloudantHost, cloudantUser, cloudantPass, dbName):
        if not rdd.isEmpty():
            sqlContext.createDataFrame(rdd).write.format("com.cloudant.spark").option("cloudant.host",cloudantHost).option("cloudant.username",cloudantUser).option("cloudant.password",cloudantPass).save(dbName)
            
    airlineDelay.foreachRDD(lambda rdd: process(rdd,sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]))
    
    ssc.start()
    ssc.awaitTermination()
    
