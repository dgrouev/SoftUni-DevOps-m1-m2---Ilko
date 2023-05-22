# M8: Exam Preparation (Practice)

This document is based on a real practice exam from previous instance of the course

This means, that you may expect similar structure, content, and complexity level on the actual practice exam

## Main Goal
You are expected to utilize all or most of the studied products and technologies and create an infrastructure with
three hosts. Their parameters and distributions are up to you to decide (considering your free resources and the
actual distribution of components)
The emphasis should be on features usage demonstration versus optimal solution
The goal is to have the whole infrastructure as a file or set of files
Your solution should look and follow this structure:
Rules and Guidelines
Be sure to follow the naming conventions specified in the checklist and in project source files
The tasks execution order should not be derived from the order in which they are listed below. Please note that
there are tasks that depend on the successful completion of one or more other tasks

## Tasks

### Infrastructure as Code (19 pts)
You are expected to demonstrate knowledge working with Terraform, Vagrant and VirtualBox
#### Level #1 (3 pts)
Depending on the platform you use you are expected to create the following:
* (T101, 3 pts) Create a set of three machines (the distribution is up to you). Most of the provisioning is
expected to be done with the help of configuration management tools (there is a separate set of tasks)
Level #2 (16 pts)
Using Terraform (either on the host or inside the Containers machine) you are expected to implement the following:
* (T102, 4 pts) Spin up an Apache Kafka or RabbitMQ (it is up to you to decide) single-node cluster
* (T103, 2 pts) Enable the monitoring of the single-node cluster (either by enabling a plugin or by running
additional container)
* (T104, 2 pts) Spin up a producer container for the prep topic/exchange by using the appropriate repository
o for Apache Kafka – https://hub.docker.com/repository/docker/shekeriev/kafka-prod
o for RabbitMQ – https://hub.docker.com/repository/docker/shekeriev/rabbit-prod
* (T105, 2 pts) Spin up a consumer container for the prep topic/exchange by using the appropriate repository
o for Apache Kafka – https://hub.docker.com/repository/docker/shekeriev/kafka-cons
o for RabbitMQ – https://hub.docker.com/repository/docker/shekeriev/rabbit-cons
* (T106, 3 pts) Spin up a Prometheus instance and set it to collect data from the single-node cluster
* (T107, 3 pts) Spin up a Grafana instance and set it to use the Prometheus instance as a data source
The number and structure of the configurations to spin up the above is up to you to determine
Configuration Management (27 pts)
You are expected to demonstrate knowledge working with two of the studied configuration management solutions.
It is up to you to select which two
Configuration Management #1 (4 pts)
* (T201, 3 pts) Do a basic (installed and running) installation of Docker on VM1
* (T202, 1 pts) The user in use (vagrant or another one) must be a member of the docker group
Configuration Management #2 (23 pts)
* (T203, 4 pts) Do a basic (installed and running) installation of Apache (+PHP +libraries) on VM2
* (T204, 3 pts) Add two virtual hosts by port – 8081 (for app1) and 8082 (for app2)
* (T205, 4 pts) Deploy both applications (app1 and app2) files to the corresponding folders of the virtual hosts
* (T206, 3 pts) Do a basic (installed and running) installation of MariaDB on VM3
* (T208, 3 pts) Make sure the service is listening on all interfaces (should be accessible from VM2)
* (T207, 4 pts) Deploy applications' databases
* (T209, 2 pts) Make sure that VM2 and VM3 can reach each other by name
Applications (app1 and app2) can be found here: https://github.com/shekeriev/do2-app-pack
Deploy them not as containers but following the classical approach
Monitoring (3 pts)
You are expected to demonstrate basic knowledge working with both Prometheus and Grafana
* (T301, 3 pts) Create a simple visualization of a metric of the selected middleware
Applications (11 pts)
You are expected to manage to do a successful deployment of the three applications
* (T401, 5 pts) Working pair of producer and consumer
This means that there should be a working flow of messages/events between them
* (T402, 3 pts) Working web application #1
This means that there should be connection to the DB and results displayed on the screen
* (T403, 3 pts) Working web application #2
This means that there should be connection to the DB and results displayed on the screen
Proof
Prepare a compressed archive with the files of your solution and any supporting files and upload it on the site
Make sure that you include at least all configuration files, a brief description of the workflow and pictures of
important moments/achievements (at least the state of the applications). If there are any manual steps, you must
describe them in free form (including commands if any) in an additional document
Make sure that all temporary and hidden (created by applications like vagrant, terraform, etc.) files are not included
In general, any hint (in written and/or with pictures) on what you do and why will be more than welcome