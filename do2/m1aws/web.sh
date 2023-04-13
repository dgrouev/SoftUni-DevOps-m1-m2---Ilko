#!/bin/sh 
echo "* Add hosts ..."
echo "192.168.89.100 web.do1.lab web" >> /etc/hosts
echo "192.168.89.101 db.do1.lab db" >> /etc/hosts

echo "* Install Software ..."
sudo amazon-linux-extras install -y nginx1
sudo yum install -y php php-mysql git

echo "* Copy web site files to /var/www/html/ ..."
git clone https://github.com/shekeriev/bgapp
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/bgapp/web/* /usr/share/nginx/html


echo "* Start HTTP ..."
sudo systemctl start nginx
sudo systemctl enable nginx