#!/bin/sh 
sudo amazon-linux-extras install -y nginx1
sudo systemctl start nginx
sudo systemctl enable nginx 
echo '<h1>Hello from NGINX running on AWS EC2 instance</h1>' > /usr/share/nginx/html/index.html

echo "* Add hosts ..."
echo "192.168.89.100 web.do1.lab web" >> /etc/hosts
echo "192.168.89.101 db.do1.lab db" >> /etc/hosts

echo "* Install Software ..."
apt update -y
apt install -y mariadb-server

echo "* Start HTTP ..."
systemctl enable mariadb
systemctl start mariadb

echo "* Firewall - open port 3306 ..."
sudo sed -i.bak s/127.0.0.1/0.0.0.0/g /etc/mysql/mariadb.conf.d/50-server.cnf

echo "* Create and load the database ..."
sudo apt install -y git
git clone https://github.com/shekeriev/bgapp
sudo mysql -u root < /home/vagrant/bgapp/db/db_setup.sql
sudo systemctl restart mariadb