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
import pprint
import os
from pyspark.sql import SQLContext
from pyspark import SparkContext, SparkConf

conf = SparkConf().setAppName("Cloudant Spark SQL External Datasource in Python")

sc = SparkContext(conf=conf)
sqlContext = SQLContext(sc)

df = sqlContext.load("n_airportcodemapping", "com.cloudant.spark")

df.cache() 

df.printSchema()

df.filter(df.airportName >= 'Moscow').select("_id",'airportName').show()
df.filter(df._id >= 'CAA').select("_id",'airportName').show()
df.filter(df._id >= 'CAA').select("_id",'airportName').save("airportcodemapping_df", "com.cloudant.spark")

df = sqlContext.load(source="com.cloudant.spark", database="n_flight")
df.printSchema()

total = df.filter(df.flightSegmentId >'AA9').select("flightSegmentId", "scheduledDepartureTime").orderBy(df.flightSegmentId).count()
print "Total", total, "flights from table"

df = sqlContext.load(source="com.cloudant.spark", database="n_flight", index="_design/view/_search/n_flights")
df.printSchema()

total = df.filter(df.flightSegmentId >'AA9').select("flightSegmentId", "scheduledDepartureTime").orderBy(df.flightSegmentId).count()
print "Total", total, "flights from index"

sc.stop()
