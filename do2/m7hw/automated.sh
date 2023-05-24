#!/bin/bash

echo "# Creating Bridge Docker Newtork"
docker network create rabbitmq-net

echo "# Creating directories for each node and adding config files"
mkdir -p rabbitmq/node-{1..3}
cat <<EOF | tee rabbitmq/node-{1..3}/rabbitmq
cluster_formation.peer_discovery_backend = rabbit_peer_discovery_classic_config
cluster_formation.classic_config.nodes.1 = rabbit@rabbitmq-1
cluster_formation.classic_config.nodes.2 = rabbit@rabbitmq-2
cluster_formation.classic_config.nodes.3 = rabbit@rabbitmq-3
EOF

echo "# Starting Nodes"
docker run -d --rm --name rabbitmq-1 --hostname rabbitmq-1 --net rabbitmq-net -p 8081:15672 -p 9101:15692 -p 5672:5672 -v ${PWD}/rabbitmq/node-1/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP rabbitmq:3.11-management
docker run -d --rm --name rabbitmq-2 --hostname rabbitmq-2 --net rabbitmq-net -p 8082:15672 -p 9102:15692 -v ${PWD}/rabbitmq/node-2/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP rabbitmq:3.11-management
docker run -d --rm --name rabbitmq-3 --hostname rabbitmq-3 --net rabbitmq-net -p 8083:15672 -p 9103:15692 -v ${PWD}/rabbitmq/node-3/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP rabbitmq:3.11-management

echo "# Enabling Federation and Prometheus plugins"
docker container exec -it rabbitmq-1 rabbitmq-plugins enable rabbitmq_federation rabbitmq_prometheus
docker container exec -it rabbitmq-2 rabbitmq-plugins enable rabbitmq_federation rabbitmq_prometheus
docker container exec -it rabbitmq-3 rabbitmq-plugins enable rabbitmq_federation rabbitmq_prometheus

echo "# Creating High-Availability policy"
docker container exec -it rabbitmq-1 rabbitmqctl set_policy ha-fed ".*" '{"federation-upstream-set":"all", "ha-sync-mode":"automatic", "ha-mode":"nodes", "ha-params":["rabbit@rabbit-1","rabbit@rabbit2","rabbit@rabbit-3"]}' --priority 1 --apply-to queues

echo "# Installing Python and Pip"
sudo dnf install python3 python3-pip

echo "* Updating Python alternatives to point to Python3"
sudo update-alternatives --config python

echo "* Starting Prometheus"
python -m pip install pika --upgrade 