# Documentation for Apache Kafka Assignment

1. Vagrant up and ssh into **kafka** machine

2. Install Java:
``` shell
sudo dnf install java-17-openjdk
```

3. Disable firewalld:
``` shell
sudo systemctl disable --now firewalld
```

3. Download Apache Kafka:
``` shell
wget https://archive.apache.org/dist/kafka/3.3.1/kafka_2.13-3.3.1.tgz
```

4. Extract the archive:
``` shell
tar xzvf kafka_2.13-3.3.1.tgz
```

5. Rename Kafka folder:
``` shell
mv kafka_2.13-3.3.1 kafka
```

6. Enter Kafka Folder:
```
cd kafka
```

9. Start Zookeper:
``` shell
bin/zookeeper-server-start.sh config/zookeeper.properties
```

9. Start a new session to the Kafka machine and execute:
``` shell
cd kafka && bin/kafka-server-start.sh config/server.properties
```

11. Start yet another session to the Kafka machine and execute:
``` shell
cd kafka && bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 3 --topic homework
```

12. Install Python:
``` shell
sudo dnf -y install python3 python3-pip
```

13. Install Kafka-Python module:
``` shell
sudo pip3 install kafka-python
```

14. Start the producer:
``` shell
python3 /vagrant/code/producer.py
```