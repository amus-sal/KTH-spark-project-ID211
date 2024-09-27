docker compose up -d
docker exec -it hadoop bash
hdfs dfs -mkdir -p /user/test/data
hdfs dfs -put /data/yourfile.csv /user/test/data
docker compose cp data/load_flight_delays.py spark:/load_flight_delays.py
docker exec -it spark-master bash
spark-submit --master spark://spark-master:7077 /load_flight_delays.py
