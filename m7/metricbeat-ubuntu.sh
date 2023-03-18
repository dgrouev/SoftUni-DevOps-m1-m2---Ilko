#!/bin/bash

echo "* Downloading and Installing Metricbeat"
wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.6.2-amd64.deb
sudo vi /etc/metricbeat/metricbeat.yml

echo "* Remove basic Metricbeat.yml"
sudo rm /etc/metricbeat/metricbeat.yml -f

echo "* Copy configured Metricbeat.yml"
sudo rm /etc/metricbeat/metricbeat.yml -f

