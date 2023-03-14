# Homework 6: Monitoring with Prometheus and Grafana

## Build the virtual machine
* Navigate to the Vagrantfile folder and execute
1. vagrant up

## Setting-up Docker Swarm
* Apparently, receiving Docker metrics requires Docker Swarm mode

1. docker swarm init
2. vi sudo /etc/docker/daemon.json
``` json
{
  "metrics-addr" : "192.168.99.101:9323",
  "experimental" : true
}
```
3. :wq

