#!/bin/bash

echo "* Adding the Docker repository"
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "* Install the packages (Java, Docker and Python)"
dnf install -y java-17-openjdk docker-ce docker-ce-cli containerd.io python3 python3-pip

echo "* Installing Kafka-Python module"
pip3 install kafka-python

echo "* Starting the Docker service"
systemctl enable --now docker

echo "* Adding Vagrant to Docker Group"
sudo usermod -aG docker vagrant

echo "* Disabling Firewalld"
sudo systemctl disable --now firewalld

echo "* Downloading and Unpacking Apache Kafka"
wget https://archive.apache.org/dist/kafka/3.3.1/kafka_2.13-3.3.1.tgz
tar xzvf kafka_2.13-3.3.1.tgz

echo "* Starting Apache Zookeper and Server"
mv kafka_2.13-3.3.1 kafka && cd kafka
bin/zookeeper-server-start.sh config/zookeeper.properties &> /tmp/kafka-zookeper.log &
bin/kafka-server-start.sh config/server.properties &> /tmp/kafka-server.log &

echo "* Creating Kafka Topic"
bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 3 --topic homework

echo "* Starting Python Producer and Consumer"
python3 /vagrant/code/producer.py &> /tmp/python-producer.log &
python3 /vagrant/code/consumer-subscribe.py &> /tmp/python-consumer.log &

echo "* Restarting FirewallD and Opening port 9308 for Kafka Exporter"
sudo systemctl enable --now firewalld
sudo firewall-cmd --permanent --add-port=9308/tcp
sudo firewall-cmd --reload

echo "* Running Kafka Exporter as a Container"
docker run -d -p 9308:9308 danielqsj/kafka-exporter --kafka.server=192.168.99.101:9092

echo "* Waiting a bit adn Disabling Firewalld again"
sleep 10s
sudo systemctl disable --now firewalld