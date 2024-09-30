#you can execute the following commands to do the proccess. Execute the commands in the terminal while being in the direcory of the yaml file.
#execute commands one by one after making sure that the previous command has finished executing.
#before starting, you have to download the csv file from the following link: https://www.kaggle.com/datasets/umeradnaan/flight-delays-dataset/data
#and place it in the data folder in the same directory as the yaml file.
#start the docker containers
docker compose up -d
#connect to the hadoop container
docker exec hadoop hdfs dfs -mkdir -p /user/test/data
docker exec hadoop hdfs dfs -put /data/flight_delays.csv /user/test/data

# Copy the python script to the spark container
docker compose cp data/load_flight_delays.py spark-master:/load_flight_delays.py

# Connect to the spark-master container and install pymongo
docker exec spark-master pip install 'pymongo[srv]'

# Execute the python script that loads the csv file into the mongodb database using spark-submit
docker exec spark-master spark-submit --master spark://spark-master:7077 --packages org.mongodb.spark:mongo-spark-connector_2.12:3.0.1 /load_flight_delays.py

# Connect to the mongo-db container and run the mongo shell commands
docker exec mongo-db mongosh --eval "
  use mongodatabase;
  db.flightdelays.find().pretty();
"

# Stop the docker containers
#docker compose down