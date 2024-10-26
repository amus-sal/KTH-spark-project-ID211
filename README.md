
# Flight Delays Data Analysis

This README provides instructions for executing the flight delays data analysis project using Docker, HDFS, Spark, and MongoDB.

## Prerequisites

Before starting, download the CSV file from the following link and place it in the `data` folder in the same directory as the YAML file:

- [Flight Delays Dataset](https://www.kaggle.com/datasets/umeradnaan/flight-delays-dataset/data)

## Steps to Execute

1. Execute the following commands in the terminal while being in the directory of the YAML file. Make sure to execute the commands one by one after ensuring that the previous command has finished executing.

2. **Start the Docker Containers**

   ```bash
   docker compose up -d
   ```

3. **Connect to the Hadoop Container**

   ```bash
   docker exec -it hadoop bash
   ```

4. **Create a Directory to Store the CSV File in HDFS**

   ```bash
   hdfs dfs -mkdir -p /user/test/data
   ```

5. **Copy the CSV File to the HDFS Directory**

   ```bash
   hdfs dfs -put /data/flight_delays.csv /user/test/data
   ```

6. **Exit the Hadoop Container**

   ```bash
   exit
   ```

7. **Copy the Python Script to the Spark Container**

   ```bash
   docker compose cp data/load_flight_delays.py spark-master:/load_flight_delays.py
   ```

8. **Connect to the Spark Master Container**

   ```bash
   docker exec -it spark-master bash
   ```

9. **Install the PyMongo Library**

   This library allows Spark to connect to the MongoDB database.

   ```bash
   pip install 'pymongo[srv]'
   ```

10. **Execute the Python Script to Load the CSV File into MongoDB**

    ```bash
    spark-submit --master spark://spark-master:7077 --packages org.mongodb.spark:mongo-spark-connector_2.12:3.0.1 /load_flight_delays.py
    ```

11. **Exit the Spark Master Container**

    ```bash
    exit
    ```

12. **Connect to the MongoDB Container**

    ```bash
    docker exec -it mongo-db bash
    ```

13. **Start the Mongo Shell**

    ```bash
    mongosh
    ```

14. **Connect to the MongoDB Database**

    ```bash
    use mongodatabase
    ```

15. **Show the Collections in the Database**

    ```bash
    db.flightdelays.find().pretty()
    ```

16. **Exit the Mongo Shell and MongoDB Container**

    ```bash
    exit
    exit
    ```

17. **Stop the Docker Containers**

    ```bash
    docker compose down
    ```

## Conclusion

This process demonstrates how to analyze flight delay data using Spark and store the results in MongoDB. Make sure all steps are executed in the correct order to ensure successful data processing.
