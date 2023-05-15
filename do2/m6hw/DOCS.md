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

15. Start another ssh session to the Kafka machine and execute:
``` shell
python3 /vagrant/code/consumer-subscribe.py
```

16. Install Docker on the Kafka Machine:
``` shell
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
sudo usermod -aG docker vagrant
```

17. Exit and re-enter the ssh session to the kafka machine or execute the next command with **sudo**

18. Start Kafka Exporter as a Container:
``` shell
docker run -d -p 9308:9308 danielqsj/kafka-exporter --kafka.server=192.168.99.101:9092 --zookeeper.server=192.168.99.101:2181 --web.telemetry-path=/metrics
```

19. Monitoring machine should detect the Kafka Exporter in a bit, navigate to 192.168.99.102:9090 to check within the Prometheus interface if the target is active, and 192.168.99.102:300 where you can login with user **admin** with password **admin** and check out the dashboard.