from pyspark import SparkContext,SparkConf
from pyspark.sql import SQLContext, Row

logFile = "swift://ylspark.sjc01/660655311_122014_5120_airline_delay_causes.csv"

conf = SparkConf().setAppName("Swift App")
sc = SparkContext(conf=conf)
sqlContext = SQLContext(sc)

lines = sc.textFile(logFile).cache()

numAs = lines.filter(lambda s: 'a' in s).count()
numBs = lines.filter(lambda s: 'b' in s).count()

print "Lines with a: %i, lines with b: %i" % (numAs, numBs)

firstRow = lines.take(1)[0]
rows = lines.filter(lambda line: line != firstRow)

data = rows.map(lambda l: l.split(","))

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

# TODO using firstRow(header) to create Row
airlineData = data.map(lambda p: Row(year=int(p[0]), month=int(p[1]),carrier=p[2],airport=p[4],arr_flights=string_or_number(p[7]),arr_del15=string_or_number(p[8])))

# Infer the schema, and register the SchemaRDD as a table.
schemaDelay = sqlContext.inferSchema(airlineData)
schemaDelay.registerTempTable("airlineDelay")

# SQL can be run over SchemaRDDs that have been registered as a table.
delay = sqlContext.sql("SELECT year, month, carrier, airport, arr_flights, arr_del15 FROM airlineDelay WHERE arr_del15 > 100")

delay.printSchema()

for line in delay.collect():
	print line.year, line.month, line.carrier , line.airport, line.arr_flights, line.arr_del15

delayFile = "swift://ylspark.sjc01/delay.json"
delay.write.format("json").mode("overwrite").save(delayFile)


    


