# Homework 6: Monitoring with Prometheus and Grafana

## Build the virtual machine
* Navigate to the Vagrantfile folder and execute
1. vagrant up

## Setting-up Docker Swarm
* Apparently, receiving Docker metrics requires Docker Swarm mode

1. docker swarm init
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
