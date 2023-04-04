#!/bin/bash

echo "* Install Additional Packages ..."
docker stack deploy -c demo-app/docker-compose.yml bgapp