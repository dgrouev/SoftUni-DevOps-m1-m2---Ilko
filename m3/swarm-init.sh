#!/bin/bash

echo "* Swarm Init ..."
docker swarm init --advertise-addr 192.168.99.101

echo "* Saving Join Token ..."
docker swarm join-token -q worker | sudo tee /vagrant/token.swarm

echo "* Setting ..."
echo '12345' | docker secret create db_root_password -

echo "* Cloning App Repo ..."
git clone https://github.com/ilkothetiger/demo-app.git