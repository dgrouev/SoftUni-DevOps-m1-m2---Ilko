#!/bin/bash

sudo dnf install -y chrony
sudo systemctl enable chronyd
sudo systemctl start chronyd
sudo setenforce permissive
sudo sed -i 's\=enforcing\=permissive\g' /etc/sysconfig/selinux