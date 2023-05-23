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

1. Start a session to rabbitmq-1 container:
``` shell
docker container exec -it rabbitmq-1 bash
```

2. Creating policy thah makes all queues highly available:
``` shell
rabbitmqctl set_policy ha-fed ".*" '{"federation-upstream-set":"all", "ha-sync-mode":"automatic", "ha-mode":"nodes", "ha-params":["rabbit@rabbit-1","rabbit@rabbit2","rabbit@rabbit-3"]}' --priority 1 --apply-to queues
```

3. While inside the container execute the following commands:
``` shell
apt update
apt install -y python3-pip nano
python3 -m pip install pika
mkdir /home/code
cd /home/code
```

4. Create new file called **emit.py** with nano that has the following content:
``` python
#!/usr/bin/env python
import pika
from time import sleep
from random import randrange

print(' [*] Logs topics emitter started. Press Ctrl+C to stop.')

try:
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
    channel = connection.channel()

    channel.exchange_declare(exchange='topic_logs', exchange_type='topic')

    while True:
        # determine resource type
        res = randrange(0,100)
        rtype = 'cpu'
        if res % 2 == 0:
            rtype = 'ram'
        # determine resource load
        res = randrange(0,100)
        ltype = 'info'
        if res > 50:
            ltype = 'warn'
        if res > 80:
            ltype = 'crit'
        msg = ltype + ': ' + rtype + ' load is ' + str(res)
        routing_key = rtype + '.' + ltype
        channel.basic_publish(exchange='topic_logs', routing_key=routing_key, body=msg)
        print(" [x] Sent %r" % msg)
        slp = randrange(5,20)
        print(' [x] Sleep for ' + str(slp) + ' second(s).')
        sleep(slp)
except Exception as ex:
    print(str(ex))
except KeyboardInterrupt:
    pass
finally:
    if connection is not None:
        connection.close()
```

5. Create new file called **emit.py** with nano that has the following content:
``` python
#!/usr/bin/env python
import pika
import sys

binding_keys = sys.argv[1:]
if not binding_keys:
    sys.stderr.write("Usage: %s [binding_key]...\n" % sys.argv[0])
    sys.exit(1)

connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()

channel.exchange_declare(exchange='topic_logs', exchange_type='topic')

result = channel.queue_declare('', exclusive=True)
queue_name = result.method.queue

for binding_key in binding_keys:
    channel.queue_bind(exchange='topic_logs', queue=queue_name, routing_key=binding_key)

print(' [*] Waiting for logs ' + str(binding_keys) + '. To exit press CTRL+C')

def callback(ch, method, properties, body):
    print(" [x] %r:%r" % (method.routing_key, body))

channel.basic_consume(queue=queue_name, on_message_callback=callback, auto_ack=True)

channel.start_consuming()
```


6. Start another session to the docker machine and enter inside the rabbitmq-1 container again:
``` shell
docker container exec -it rabbitmq-1 bash
cd /home/code
python3 recv.py "*.warn" "*.crit"
```

7. Repeat the previous step and execute the following commands:
``` shell
docker container exec -it rabbitmq-1 bash
cd /home/code
python3 recv.py "ram.*"
```


## Monitoring Setup

1. Start a fresh session on the Docker machine