#!/bin/bash

echo "Installing and starting NTP client"
sudo dnf install -y chrony
sudo systemctl enable chronyd
sudo systemctl start chronyd

echo "Setting SELinux in permissive mode"
sudo setenforce permissive
sudo sed -i 's\=enforcing\=permissive\g' /etc/sysconfig/selinux

echo "Installing Chef Workstation"
wget -P /tmp wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/el/8/chef-workstation-21.10.640-1.el8.x86_64.rpm
sudo rpm -Uvh /tmp/chef-workstation-21.10.640-1.el8.x86_64.rpm
sudo dnf install -y git

echo "Using Ruby provided by Chef"
echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
echo 'export PATH="/opt/chef-workstation/embedded/bin:$PATH"' >> ~/.bash_profile && source ~/.bash_profile

echo "Configuring Git client"
git config --global user.email "ilkothetiger@gmail.com"
git config --global user.name "Ilia Dimchev"



