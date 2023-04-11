#!/bin/bash

echo "* Downloading and Installing Metricbeat"
wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.6.2-amd64.deb
sudo dpkg -i metricbeat-8.6.2-amd64.deb

echo "* Remove basic Metricbeat.yml"
sudo rm /etc/metricbeat/metricbeat.yml -f

echo "* Copy configured Metricbeat.yml"
sudo cp /vagrant/metricbeat.yml /etc/metricbeat/metricbeat.yml

echo "* Start Metricbeat service"
sudo service metricbeat start

