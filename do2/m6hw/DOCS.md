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

