Homework M6: Prometheus and Grafana

Assignment

You are expected to create the following

- A setup with one virtual machine with Docker installed just like on the practice

* You can separate the workload on two machines. Either way, adjust the parameters in order to fit within your available resources

- On the machine(s) run the following

o Prometheus as container. One instance

o Grafana as container. One instance

o The application (goprom) used during the practice. Two instances

- In terms of measurement, do the following

o Make Docker to provide metrics, which to be consumed by Prometheus. This should result in one job. For this one, you should research Docker documentation

o Capture the metrics of the two application instances. This should result in one job with two targets

- In terms of visualization, create a simple dashboard that has

o A panel which shows how many containers are on the host (in all states)

o A panel which shows how many jobs are processed by each goprom application (all result types)

As usual, try to do the infrastructure part as automated as possible. Of course, using Vagrant

For the rest (Docker, Prometheus, Grafana), try to automate it as much as possible