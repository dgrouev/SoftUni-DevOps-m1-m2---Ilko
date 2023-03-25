#!/bin/bash

echo "* Add the Docker repository"
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "* Install the packages (Docker)"
dnf install -y docker-ce docker-ce-cli containerd.io

echo "* Start the Docker service"
systemctl enable --now docker

echo "* Add Jenkins and adjust the group membership"
sudo usermod -aG docker vagrant

echo "* Copying prometheus.yml to /tmp/"
sudo cp /vagrant/prometheus.yml /tmp/prometheus.yml

echo "* Starting Prometheus"
cd /vagrant/prom
docker compose up -d

echo "* Adjust the firewall"
firewall-cmd --permanent --add-port=3000/tcp
firewall-cmd --permanent --add-port=9090/tcp
firewall-cmd --reload