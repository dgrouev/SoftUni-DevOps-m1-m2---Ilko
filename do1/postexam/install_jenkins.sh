#!/bin/bash

echo "* Add and import the repository key"
wget https://pkg.jenkins.io/redhat/jenkins.repo -O /etc/yum.repos.d/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

echo "* Update repositories and install components"
dnf install -y java-17-openjdk jenkins git

echo "* Start the service"
systemctl enable --now jenkins

echo "* Add Jenkins and adjust the group membership"
echo -e 'Password1\nPassword1' | sudo passwd jenkins
sudo usermod -s /bin/bash jenkins
echo "jenkins  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jenkins

echo "* Setup node exporter"
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xzvf node_exporter-1.5.0.linux-amd64.tar.gz
cd node_exporter-1.5.0.linux-amd64/
./node_exporter &> /tmp/node-exporter.log &

echo "* Adjust the firewall"
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-port=9100/tcp
firewall-cmd --reload

echo "* admin password is:"
cat /var/lib/jenkins/secrets/initialAdminPassword