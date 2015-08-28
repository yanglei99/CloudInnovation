/*******************************************************************************
* Copyright (c) 2015 IBM Corp.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/

// Dependency loading
  z.load("/zeppelin/cloudant-spark.jar")

// Zeppelin creates and injects sc (SparkContext) and sqlContext (HiveContext or SqlContext)
// So you don't need create them manually

        val cloudantHost = "YOUR CLOUDANT HOST"
        val cloudantUser = "YOUR CLOUDANT USER"
        val cloudantPassword = "YOUR CLOUDANT PASSWORD"

        val df1 = sqlContext.read.format("com.cloudant.spark").option("cloudant.host",cloudantHost).option("cloudant.username", cloudantUser).option("cloudant.password",cloudantPassword).load("n_flight")
        df1.printSchema()
        df1.registerTempTable("flight1")

        val df2 = sqlContext.read.format("com.cloudant.spark").option("index", "_design/view/_search/n_flights").option("cloudant.host",cloudantHost).option("cloudant.username", cloudantUser).option("cloudant.password",cloudantPassword).load("n_flight")
        df2.printSchema()
        df2.registerTempTable("flight2")

 
// Create SQL
%sql
select flightSegmentId, count(1) value
from ${table=flight1} 
where flightSegmentId >= ${flightSegmentId="AA9"}
group by flightSegmentId 
order by flightSegmentId
 