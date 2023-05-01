#!/bin/bash

echo "Installing and starting NTP client"
sudo dnf install -y chrony
sudo systemctl enable chronyd
sudo systemctl start chronyd

echo "Setting SELinux in permissive mode"
sudo setenforce permissive
sudo sed -i 's\=enforcing\=permissive\g' /etc/sysconfig/selinux

echo "Installing Chef Workstation and Git"
wget -P /tmp https://packages.chef.io/files/stable/chef-workstation/23.4.1032/el/8/chef-workstation-23.4.1032-1.el8.x86_64.rpm
sudo rpm -Uvh /tmp/chef-workstation-23.4.1032-1.el8.x86_64.rpm
sudo dnf install -y git

echo "Creating Chef Organization and Opening Firewall Ports 80 & 443"
sudo chef-server-ctl user-create chefadmin Chef Admin chefadmin@do2.lab 'Password1' --filename /home/vagrant/chefadmin.pem
sudo chef-server-ctl org-create demo-org 'Demo Org.' --association_user chefadmin --filename /home/vagrant/demoorg-validator.pem
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --add-port=443/tcp --permanent
sudo firewall-cmd --reload


