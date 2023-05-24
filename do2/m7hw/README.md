# Module 7 Assignment


## Cluster Setup (Automate)

1. Start an SSH session to the Docker Machine
2. Create common network for the cluster with:
``` shell
docker network create rabbitmq-net
```
3. Create directory for each node with:
``` shell
mkdir -p rabbitmq/node-{1..3}
```
4. Execute the following inline script:
``` shell
cat <<EOF | tee rabbitmq/node-{1..3}/rabbitmq
cluster_formation.peer_discovery_backend = rabbit_peer_discovery_classic_config
cluster_formation.classic_config.nodes.1 = rabbit@rabbitmq-1
cluster_formation.classic_config.nodes.2 = rabbit@rabbitmq-2
cluster_formation.classic_config.nodes.3 = rabbit@rabbitmq-3
EOF
```
5. Start node 1 with:
``` shell
docker run -d --rm --name rabbitmq-1 --hostname rabbitmq-1 --net rabbitmq-net -p 8081:15672 -p 9101:15692 -p 5672:5672 -v ${PWD}/rabbitmq/node-1/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP rabbitmq:3.11-management
```

6. Start node 2 with:
``` shell
docker run -d --rm --name rabbitmq-2 --hostname rabbitmq-2 --net rabbitmq-net -p 8082:15672 -p 9102:15692 -v ${PWD}/rabbitmq/node-2/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP rabbitmq:3.11-management
```

7. Start node 3 with:
``` shell
docker run -d --rm --name rabbitmq-3 --hostname rabbitmq-3 --net rabbitmq-net -p 8083:15672 -p 9103:15692 -v ${PWD}/rabbitmq/node-3/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP rabbitmq:3.11-management
```


## Environment setup (Automated)

1. Start a session to rabbitmq-1 container:
``` shell
docker container exec -it rabbitmq-1 bash
```

2. Creating policy thah makes all queues highly available:
``` shell
rabbitmqctl set_policy ha-fed ".*" '{"federation-upstream-set":"all", "ha-sync-mode":"automatic", "ha-mode":"nodes", "ha-params":["rabbit@rabbit-1","rabbit@rabbit-2","rabbit@rabbit-3"]}' --priority 1 --apply-to queues
```

3. Install needed prerequisites with:
``` shell
sudo dnf install python3 python3-pip
```

4. Update python alternatives to point to python3:
``` shell
sudo update-alternatives --config python
```

5. Install Pika:
``` shell
python -m pip install pika --upgrade 
```

## Manual Steps

1. Start a SSH session to the Docker Machine and execute the following commands one by one:
``` shell
docker container exec -it rabbitmq-1 rabbitmq-plugins enable rabbitmq_federation
docker container exec -it rabbitmq-2 rabbitmq-plugins enable rabbitmq_federation
docker container exec -it rabbitmq-3 rabbitmq-plugins enable rabbitmq_federation
```

2. Create High-Availability policy with
``` shell
echo "# Creating High-Availability policy"
docker container exec -it rabbitmq-1 rabbitmqctl set_policy ha-fed ".*" '{"federation-upstream-set":"all", "ha-sync-mode":"automatic", "ha-mode":"nodes", "ha-params":["rabbit@docker:8081","rabbit@docker:8082","rabbit@docker:8083"]}' --priority 1 --apply-to queues
```

2. Enable the Prometheus plugin in each of the nodes with:
``` shell
docker container exec -it rabbitmq-1 rabbitmq-plugins enable rabbitmq_prometheus
docker container exec -it rabbitmq-2 rabbitmq-plugins enable rabbitmq_prometheus
docker container exec -it rabbitmq-3 rabbitmq-plugins enable rabbitmq_prometheus
```

## Startint the Scripts:

6. Start the Emitter with:
``` shell
python3 /vagrant/code/emit_log_topic.py
```

7. Start another session to the Docker machine and start receiver to listen for all Warn and Crit Messages:
``` shell
python3 /vagrant/code/recv_log_topic.py "*.warn" "*.crit"
```

7. Start another session to the Docker machine and start receiver to listen for all Ram Messages:
``` shell
python3 /vagrant/code/recv_log_topic.py "ram.*"
```