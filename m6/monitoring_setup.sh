#!/bin/bash

echo "* Docker Swarm Init"
docker swarm init --advertise-addr 192.168.99.101

echo "* Add Vagrant user to Wheel Group"
usermod -aG wheel vagrant

echo "* Copying daemon.json to /etc/docker/"
sudo cp /vagrant/daemon.json /etc/docker/daemon.json

echo "* Starting 2 containers from goprom image"
docker container run -d --name worker1 -p 8081:8080 shekeriev/goprom
docker container run -d --name worker2 -p 8082:8080 shekeriev/goprom

echo "* Starting Grafana 8.2.0 as container on port 3000"
docker run -d -p 3000:3000 --name grafana grafana/grafana-oss:8.2.0