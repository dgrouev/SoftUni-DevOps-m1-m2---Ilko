#!/bin/bash

echo "* Docker Swarm Init"
docker swarm init --advertise-addr 192.168.99.101

echo "* Add Vagrant user to Wheel Group"
usermod -aG wheel vagrant

echo "* Copying daemon.json to /etc/docker/"
sudo cp /vagrant/daemon.json /etc/docker/daemon.json

echo "* Restarting docker to detect changes in daemon.json"
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "* Copying prometheus.yml to /tmp/"
sudo cp /vagrant/prometheus.yml /tmp/prometheus.yml

echo "* Starting Prometheus as a Service in the Swarm"
cd /vagrant
docker compose up -d

echo "* Starting 2 containers from goprom image"
docker container run -d --name worker1 -p 8081:8080 shekeriev/goprom
docker container run -d --name worker2 -p 8082:8080 shekeriev/goprom

echo "* Starting runner scripts for goprom containers"
/vagrant/goprom/runner.sh http://192.168.99.101:8081 &> /tmp/runner8081.log &
/vagrant/goprom/runner.sh http://192.168.99.101:8082 &> /tmp/runner8082.log &
