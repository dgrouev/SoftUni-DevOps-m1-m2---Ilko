#!/bin/bash

echo "* Adding Jenkins Repo ..."
sudo wget https://pkg.jenkins.io/redhat/jenkins.repo -O /etc/yum.repos.d/jenkins.repo

echo "* Importing Jenkins Key ..."
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

echo "* Downloading Makecache ..."
sudo dnf makecache

echo "* Installing Jenkins ..."
sudo dnf -y install jenkins

echo "* Installing Java-17 ..."
sudo dnf -y install java-17-openjdk

echo "* Starting Jenkins service ..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "* Adding exclusion to the Firewall and reloading ..."
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --reload