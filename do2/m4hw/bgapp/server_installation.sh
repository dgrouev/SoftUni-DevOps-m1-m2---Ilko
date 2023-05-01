#!/bin/bash

echo "Installing and starting NTP client"
sudo dnf install -y chrony
sudo systemctl enable chronyd
sudo systemctl start chronyd

echo "Setting SELinux in permissive mode"
sudo setenforce permissive
sudo sed -i 's\=enforcing\=permissive\g' /etc/sysconfig/selinux

echo "Installing Chef Server"
wget -P /tmp https://packages.chef.io/files/stable/chef-server/15.6.2/el/8/chef-server-core-15.6.2-1.el8.x86_64.rpm
sudo rpm -Uvh /tmp/chef-server-core-15.6.2-1.el8.x86_64.rpm
sudo chef-server-ctl reconfigure --chef-license accept



