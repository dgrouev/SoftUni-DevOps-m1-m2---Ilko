#!/bin/bash

echo "* Add the Docker repository"
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "* Install the packages (Docker)"
dnf install -y docker-ce docker-ce-cli containerd.io

echo "* Start the Docker service"
sudo systemctl enable --now docker

echo "* Add Jenkins and adjust the group membership"
sudo usermod -aG docker vagrant

echo "* Docker Swarm Init"
docker swarm init --advertise-addr 192.168.99.203

echo "* Add Vagrant user to Wheel Group"
sudo usermod -aG wheel vagrant

echo "* Copying daemon.json to /etc/docker/"
sudo cp /vagrant/daemon.json /etc/docker/daemon.json

echo "* Restarting docker to detect changes in daemon.json"
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "* Copying prometheus.yml to /tmp/"
sudo cp /vagrant/prom/prometheus.yml /tmp/prometheus.yml

echo "* Starting Prometheus"
cd /vagrant/prom
docker compose up -d

echo "* Adjust the firewall"
firewall-cmd --permanent --add-port=3000/tcp
firewall-cmd --permanent --add-port=9090/tcp
firewall-cmd --permanent --add-port=9323/tcp
firewall-cmd --reload