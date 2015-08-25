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
from pyspark.sql import SQLContext
from pyspark import SparkContext, SparkConf

conf = SparkConf().setAppName("Cloudant Spark SQL External Datasource in Python")
# define coudant related configuration
conf.set("cloudant.host","yanglei.cloudant.com")
conf.set("cloudant.username", "ntledesewstarkalkedirsee")
conf.set("cloudant.password","b0VbcAS7davOYC0f4umPC2BR")
conf.set("jsonstore.rdd.maxInPartition",1000)

sc = SparkContext(conf=conf)
sqlContext = SQLContext(sc)

df = sqlContext.load("airportcodemapping", "com.cloudant.spark")
df.printSchema()

df.filter(df.airportCode >= 'CAA').select("airportCode",'airportName').show()
df.filter(df.airportCode >= 'CAA').select("airportCode",'airportName').save("airportcodemapping_df", "com.cloudant.spark")

df = sqlContext.load(source="com.cloudant.spark", database="n_flight")
df.printSchema()

total = df.filter(df.flightSegmentId >'AA9').select("flightSegmentId", "scheduledDepartureTime").orderBy(df.flightSegmentId).count()
print "Total", total, "flights from table"

df = sqlContext.load(source="com.cloudant.spark", database="n_flight", index="_design/view/_search/n_flights")
df.printSchema()

total = df.filter(df.flightSegmentId >'AA9').select("flightSegmentId", "scheduledDepartureTime").orderBy(df.flightSegmentId).count()
print "Total", total, "flights from index"
