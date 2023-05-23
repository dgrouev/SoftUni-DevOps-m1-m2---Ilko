# Module 7 Assignment

## Cluster Setup

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
docker run -d --rm --name rabbitmq-1 --hostname rabbitmq-1 --net rabbitmq-net -p 8081:15672 -v ${PWD}/rabbitmq/node-1/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP rabbitmq:3.11-management
```

6. Start node 2 with:
``` shell
docker run -d --rm --name rabbitmq-2 --hostname rabbitmq-2 --net rabbitmq-net -p 8082:15672 -v ${PWD}/rabbitmq/node-2/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP rabbitmq:3.11-management
```

7. Start node 3 with:
``` shell
docker run -d --rm --name rabbitmq-3 --hostname rabbitmq-3 --net rabbitmq-net -p 8083:15672 -v ${PWD}/rabbitmq/node-3/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq -e RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP rabbitmq:3.11-management
```

8. Enable the Federation plugin in each of the nodes with:
``` shell
docker container exec -it rabbitmq-1 rabbitmq-plugins enable rabbitmq_federation
docker container exec -it rabbitmq-2 rabbitmq-plugins enable rabbitmq_federation
docker container exec -it rabbitmq-3 rabbitmq-plugins enable rabbitmq_federation
```


## Setup RabbitMQ admin:

1. Install RabiitMQadmin with:
``` shell
curl http://$(hostname -s):8081/cli/rabbitmqadmin > rabbitmqadmin
```

2. Move it to system PATH:
``` shell
sudo mv rabbitmqadmin /usr/local/bin/
```

3. Make it executable:
``` shell
sudo chmod +x /usr/local/bin/rabbitmqadmin
```


## Creating High-Availability Policy

1. Navigate to **http://192.168.99.100:8081/#/policies**

2. Click on Add / Update operator policy and add the following:
    * Name: ha-fed
    * Patterns: .*
    * Apply to: Queues
    * Priority: 1
    * Definition:
        * ha-mode: exactly (String)
        * ha-params: 2 (Number)
        * ha-sync-mode:	automatic (String)

3. Add the policy

## Working with the Cluster

1. Start a session to rabbitmq-1 container:
``` shell
docker container exec -it rabbitmq-1 bash
```

2. Creating policy thah makes all queues highly available:
``` shell
sudo rabbitmqctl set_policy ha-fed ".*" '{"federation-upstream-set":"all", "ha-syncmode":"automatic", "ha-mode":"nodes", "ha-params":["rabbit@rabbit-1","rabbit@rabbit2","rabbit@rabbit-3"]}' --priority 1 --apply-to queues
```

3. Declare exchange with:
``` shell
rabbitmqadmin declare exchange name=ha-exchange type=fanout
```