from pyspark.sql import SparkSession

# Initialize a Spark session
spark = SparkSession.builder \
    .appName("Load Flight Delays") \
    .master("spark://spark-master:7077") \
    .config("spark.mongodb.output.uri", "mongodb://mongo-db:27017/mongodatabase.flightdelays") \
    .getOrCreate()

# Load CSV from HDFS
df = spark.read.csv("hdfs://hadoop:9000/user/test/data/flight_delays.csv", header=True, inferSchema=True)

# Show DataFrame contents
df.show()

# Save the DataFrame to MongoDB
df.write.format("mongo").mode("append").save()

# Save the raw DataFrame to MongoDB

# Calculate average delay per airline
avg_delay_per_airline = df.groupBy("Airline").avg("DelayMinutes").alias("average_delay")
avg_delay_per_airline.show()
avg_delay_per_airline.write.format("mongo").option("collection", "avg_delay_per_airline").mode("append").save()


# Calculate average delay per combination of origin and destination
avg_delay_per_route = df.groupBy("Origin", "Destination").avg("DelayMinutes").alias("average_delay")
avg_delay_per_route.show()

# Save the result to MongoDB
avg_delay_per_route.write.format("mongo").option("collection", "avg_delay_per_route").mode("append").save()

# Stop the Spark session
spark.stop()
