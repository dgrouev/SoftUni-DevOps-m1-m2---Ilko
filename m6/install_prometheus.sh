#!/bin/bash

echo "* Docker Swarm Init"
docker swarm init --advertise-addr 192.168.99.101

echo "* Add Vagrant user to Wheel Group"
usermod -aG wheel vagrant

echo "* Copying daemon.json to /etc/docker/"
sudo cp /vagrant/daemon.json /etc/docker/daemon.json

