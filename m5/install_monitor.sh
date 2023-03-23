#!/bin/bash

echo "* Add Jenkins and adjust the group membership"
echo -e 'Password1\nPassword1' | sudo passwd jenkins
echo "jenkins  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jenkins
sudo usermod -aG docker jenkins
sudo usermod -aG docker vagrant

echo "* Adjust the firewall"
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --reload