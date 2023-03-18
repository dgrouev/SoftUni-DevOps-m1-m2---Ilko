#!/bin/bash

echo "* Downloading and Installing Metricbeat"
wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.6.2-x86_64.rpm
sudo rpm -Uvh metricbeat-8.6.2-x86_64.rpm

echo "* Remove basic Metricbeat.yml"
sudo sudo rm /etc/metricbeat/metricbeat.yml -f

echo "* Copy configured Metricbeat.yml"
sudo sudo cp /vagrant/metricbeat.yml /etc/metricbeat/metricbeat.yml

echo "* Create Index Pattern via REST API"
curl -XPOST -u elastic http://192.168.99.104:5601/api/index_patterns/index_pattern -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "index_pattern": {
    "name":"Metricbeat",
    "title":"metricbeat-8.6.2-*",
    "timeFieldName":"@timestamp"
  }
}'

echo "* Start Metricbeat service"
sudo systemctl daemon-reload
sudo systemctl enable metricbeat
sudo systemctl start metricbeat