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

# Stop the Spark session
spark.stop()
