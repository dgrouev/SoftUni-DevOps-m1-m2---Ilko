#!/bin/bash

echo "* Installing Elasticsearch"
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.6.2-x86_64.rpm
sudo rpm -Uvh elasticsearch-*.rpm

echo "* Installing Elasticsearch"
