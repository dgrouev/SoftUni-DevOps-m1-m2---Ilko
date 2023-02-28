#!/bin/bash

echo "* Installing Apache ..."
sudo dnf -y install httpd

echo "* Starting Apache server ..."
sudo systemctl start httpd
sudo systemctl enable httpd