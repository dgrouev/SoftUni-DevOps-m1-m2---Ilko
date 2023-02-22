#!/bin/bash

echo "* Joining the Swarm ..."
docker swarm join \
--token "$(</vagrant/token.swarm)" \
--advertise-addr 192.168.99.103 192.168.99.101:2377

echo "* Cloning App Repo ..."
git clone https://github.com/ilkothetiger/demo-app.git
