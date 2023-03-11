# Homework M6: Prometheus and Grafana

## Assignment

You are expected to create the following

1. A setup with one virtual machine with Docker installed just like on the practice

<italic>* You can separate the workload on two machines. Either way, adjust the parameters in order to fit within your available resources
</italic>

2. On the machine(s) run the following

    - <strong>Prometheus</strong> as container. One instance
    - <strong>Grafana</strong> as container. One instance
    - The application <strong>(goprom)</strong> used during the practice. Two instances

3. In terms of measurement, do the following

    - Make <strong>Docker</strong> to provide metrics, which to be consumed by <strong>Prometheus</strong>. This should result in one job. <italic>For this one, you should research <strong>Docker</strong> documentation</italic>
    - Capture the metrics of the two application instances. This should result in one job with two targets

4. In terms of visualization, create a simple dashboard that has

    - A panel which shows how many containers are on the host (in all states)
    - A panel which shows how many jobs are processed by each <strong>goprom</strong> application (all result types)

As usual, try to do the infrastructure part as automated as possible. Of course, using Vagrant

For the rest (Docker, Prometheus, Grafana), try to automate it as much as possible