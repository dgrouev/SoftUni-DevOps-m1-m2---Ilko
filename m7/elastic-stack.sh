#!/bin/bash

echo "* Installing Elasticsearch"
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.6.2-x86_64.rpm
sudo rpm -Uvh elasticsearch-*.rpm

echo "* Remove basic elasticsearch.yml"
sudo sudo rm /etc/elasticsearch/elasticsearch.yml -f

echo "* Copying Elasticsearch Config Files"
sudo cp /vagrant/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
sudo cp /vagrant/jvm.options /etc/elasticsearch/jvm.options.d/

echo "* Start Elasticsearch service"
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

echo "* Installing Logstash"
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.6.2-x86_64.rpm
sudo rpm -Uvh elasticsearch-*.rpm
