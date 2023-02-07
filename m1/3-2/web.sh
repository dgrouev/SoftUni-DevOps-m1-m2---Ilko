#!/bin/bash

echo "* Add hosts ..."
echo "192.168.89.100 web.do1.lab web" >> /etc/hosts
echo "192.168.89.101 db.do1.lab db" >> /etc/hosts

echo "* Install Software ..."
apt update -y
apt upgrade -y
apt install -y apache2 php php-mysql git


echo "* Start HTTP ..."
systemctl enable apache2
systemctl start apache2

echo "* Copy web site files to /var/www/html/ ..."
cp /vagrant/* /var/www/html
rm /var/www/html/index.html

echo "* Allow HTTPD to make netork connections ..."
# setsebool -P httpd_can_network_connect=1
