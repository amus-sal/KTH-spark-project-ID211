from pyspark.sql import SparkSession

# Initialize a Spark session
spark = SparkSession.builder \
    .appName("Load Flight Delays") \
    .master("spark://spark-master:7077") \
    .getOrCreate()

# Load CSV from HDFS
df = spark.read.csv("hdfs://hadoop:9000/user/test/data/flight_delays.csv", header=True, inferSchema=True)

# Show DataFrame contents
df.show()

# Stop the Spark session
spark.stop()
