
#*******************************************************************************
# Copyright (c) 2015 IBM Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#******************************************************************************/

# Reference to https://apache.googlesource.com/spark/+/master/examples/src/main/python/streaming/mqtt_wordcount.py

# To submit
#    spark-submit --packages org.apache.spark:spark-streaming-mqtt_2.10:1.6.1 --jars cloudant-spark.jar mqtt_ingest.py

import pprint
import os
import sys

from pyspark.sql import SQLContext
from pyspark import SparkContext, SparkConf
from pyspark.sql.types import *

from pyspark.streaming import StreamingContext
from pyspark.streaming.mqtt import MQTTUtils


# Source configuration

# broker URI

brokerHost=os.getenv("MQTT_HOST","")
brokerPort=os.getenv("MQTT_PORT","1883")

if (brokerHost == ""):
    brokerUrl = "tcp://iot.eclipse.org"
else:
    brokerUrl = "tcp://"+brokerHost+":"+brokerPort


# topic or topic pattern where temperature data is being sent

topic=os.getenv("MQTT_TOPIC","mytopic")

print "MQTT broker url:", brokerUrl,",topic:", topic

# Target configuration

format=os.getenv("FORMAT","")
datastore=os.getenv("DATASTORE","")
sample=float(os.getenv("SAMPLE_RATIO","1"))
seperator=os.getenv("LINE_SEPERATOR",",")

datastore_names = datastore.split(":")

schema_field=os.getenv("SCHEMA_FIELD","")
if (schema_field!=""):
    schema_field = schema_field.split(seperator)
else:
    schema_field = []

schema_type=os.getenv("SCHEMA_TYPE","")
if (schema_type!=""):
    schema_type = schema_type.split(seperator)
else:
    schema_type = []

conf = SparkConf().setAppName("Python from MQTT to "+datastore +" in "+format+" with sample " +str(sample))

sc = SparkContext(conf=conf)
sqlContext = SQLContext(sc)
ssc = StreamingContext(sc, 1)

def getFieldType(idx):
    type = schema_type[idx]
    if type == 'TimestampType':
        return TimestampType()
    elif type == 'LongType':
        return LongType()
    elif type == 'BooleanType':
        return BooleanType()
    elif type == 'DoubleType':
        return DoubleType
    elif type == 'StringType':
        return StringType()
    else:
        print 'unknown type: ',type, ' will be treat as String'
        return StringType()

def loadSchema():
    if (len(schema_field)>0):
        print 'about to calculate schema:', schema_field  ,' of type', schema_type
        fields = []
        for idx, val in enumerate(schema_field):
            fields.append(StructField(val, getFieldType(idx),True))
        schema = StructType(fields)
        print 'calculated schema:', schema
        return schema
    print 'about to load schema:', datastore  ," in ", format
    try:
        if (len(datastore_names) == 1 ):
            df = sqlContext.read.format(format).load(datastore_names[0])
        else:
            df = sqlContext.read.format(format).option("table",datastore_names[1]).option("keyspace",datastore_names[0]).load()
        df.printSchema()
        return df.schema
    except:
        print "Unexpected error:", sys.exc_info()[0]
        pass
        return None

spark_schema_type = loadSchema()

lines = MQTTUtils.createStream(ssc, brokerUrl, topic)

def convert(v, type):
    import datetime
    if type == 'TimestampType':
        return datetime.datetime.strptime(v, "%d/%m/%Y %h:%m:%s")
    elif type == 'LongType':
        return long(v)
    elif type == 'BooleanType':
        return v == "true"
    elif type == 'DoubleType':
        return float(v)
    elif type == 'StringType':
        return v
    else:
        print 'unknown type: ',type, ' will be treat as String'
        return v
    
    
def transform(line):
    line_array = line.split(seperator)
    if (spark_schema_type != None):
        parsed = []
        for i, v in enumerate(line_array):
            parsed.append(convert(v,str(spark_schema_type.fields[i].dataType)))
    else:
        parsed = line_array
    return parsed
    

lines = lines.map(lambda l:transform(l))

def saveRDD(rdd):
    print 'about to save'
    if not rdd.isEmpty():
        try:
            df = sqlContext.createDataFrame(rdd,spark_schema_type)
            df.show()
            if (datastore_names[0] == "" or format=="" ):
                print "need configuration for DATASTORE and FORMAT"
                return
            if (len(datastore_names) == 1 ):
                print 'saving to ', datastore_names[0] , 'of format ', format
                df.write.mode('append').format(format).save(datastore_names[0])
            elif (len(datastore_names) == 2):
                print 'saving to ', datastore_names[0],':', datastore_names[1],'of format ', format
                df.write.mode('append').format(format).option("table",datastore_names[1]).option("keyspace",datastore_names[0]).save()
        except:
            import sys
            print "Unexpected error:", sys.exc_info()
            pass

lines.foreachRDD(saveRDD)

ssc.start()
ssc.awaitTermination()
    
