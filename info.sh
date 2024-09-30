#you can execute the following commands to do the proccess. Execute the commands in the terminal while being in the direcory of the yaml file.
#execute commands one by one after making sure that the previous command has finished executing.
#before starting, you have to download the csv file from the following link: https://www.kaggle.com/datasets/umeradnaan/flight-delays-dataset/data
#and place it in the data folder in the same directory as the yaml file.
#start the docker containers
docker compose up -d
#connect to the hadoop container
docker exec -it hadoop bash
#create a directory to store the csv file
hdfs dfs -mkdir -p /user/test/data
#copy the csv file to the hdfs directory
hdfs dfs -put /data/flight_delays.csv /user/test/data
exit
#copy the python script to the spark container
docker compose cp data/load_flight_delays.py spark:/load_flight_delays.py
#connect to the spark-master container
docker exec -it spark-master bash
#install the pymongo library, that allows spark to connect to the mongodb database
pip install 'pymongo[srv]'
#execute the python script that loads the csv file into the mongodb database
spark-submit --master spark://spark-master:7077 --packages org.mongodb.spark:mongo-spark-connector_2.12:3.0.1 /load_flight_delays.py
exit
#connect to the mongodb container
docker exec -it mongo-db bash
#start the mongo shell
mongosh
#connect to the mongodb database
use mongodatabase
#show the collections in the database
db.flightdelays.find().pretty()
exit
exit
#stop the docker containers
docker compose down