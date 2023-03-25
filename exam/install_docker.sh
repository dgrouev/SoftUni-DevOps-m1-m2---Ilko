#!/bin/bash

echo "* Add the Docker repository"
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "* Install the packages (Java, git, Docker)"
dnf install -y java-17-openjdk git docker-ce docker-ce-cli containerd.io

echo "* Start the Docker service"
systemctl enable --now docker

echo "* Add Jenkins and adjust the group membership"
sudo usermod -aG docker vagrant

echo "* Adjust the firewall"
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-port=9100/tcp
firewall-cmd --reload

echo "* Setup node exporter"
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xzvf node_exporter-1.5.0.linux-amd64.tar.gz
cd node_exporter-1.5.0.linux-amd64/
./node_exporter &> /tmp/node-exporter.log &