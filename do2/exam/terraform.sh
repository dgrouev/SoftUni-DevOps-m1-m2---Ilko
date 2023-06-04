#!/bin/bash

cd /vagrant/tfm-1-kafka/
terraform init
terraform apply --auto-approve

cd /vagrant/tfm-2-exporter/
terraform init
terraform apply --auto-approve

cd /vagrant/tfm-3-app/
terraform init
terraform apply --auto-approve

cd /vagrant/tfm-4-mon/
terraform init
terraform apply --auto-approve