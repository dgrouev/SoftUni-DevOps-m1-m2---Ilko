#!/bin/bash

echo "* Docker Swarm Init"
docker swarm init --advertise-addr 192.168.99.101
usermod -aG wheel vagrant