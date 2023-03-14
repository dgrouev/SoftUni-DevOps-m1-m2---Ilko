# Homework 6: Monitoring with Prometheus and Grafana

## Build the virtual machine
* Navigate to the Vagrantfile folder and execute
1. vagrant up

## Setting-up Docker Swarm
* Apparently, receiving Docker metrics requires Docker Swarm mode

1. docker swarm init --advertise-addr 192.168.99.101
2. sudo usermod -aG wheel vagrant
3. vi sudo /etc/docker/daemon.json
``` json
{
  "metrics-addr" : "192.168.99.101:9323",
  "experimental" : true
}
```
4. :wq

## Configure and run Prometheus
* Prometheus runs as a Docker service on a Docker swarm

1. sudo vi /tmp/prometheus.yml
``` yml
# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
      monitor: 'codelab-monitor'

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first.rules"
  # - "second.rules"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'docker'
         # metrics_path defaults to '/metrics'
         # scheme defaults to 'http'.

    static_configs:
      - targets: ['localhost:9323']
```
2. Start Prometheus Service as a container
``` shell
docker service create --replicas 1 --name my-prometheus \
    --mount type=bind,source=/tmp/prometheus.yml,destination=/etc/prometheus/prometheus.yml \
    --publish published=9090,target=9090,protocol=tcp \
    prom/prometheus
```

## Start two instances of goprom app
1. docker container run -d --name worker1 -p 8081:8080 shekeriev/goprom
2. docker container run -d --name worker2 -p 8082:8080 shekeriev/goprom
3. We also need to adjust the prometheus.yml as follow:
``` yml
global:
  scrape_interval:     15s 
  evaluation_interval: 15s 
  external_labels:
      monitor: 'codelab-monitor'

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['192.168.99.101:9090']
      - targets: ['192.168.99.101:9323']
      - targets: ['192.168.99.101:8081']
      - targets: ['192.168.99.101:8082']

```


## Metrics for monitoring
1. Count of containers in all states
    - engine_daemon_container_states_containers
