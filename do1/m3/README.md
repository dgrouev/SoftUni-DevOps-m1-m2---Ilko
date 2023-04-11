# Homework M3: Advanced Docker

# Assignment

You must execute the following set of tasks:

1. Try to create a Vagrantfile which creates a Docker Swarm cluster with 3 nodes. The whole process should be automated as much as possible. Ideally, the whole cluster should be created with executing just the vagrant up command

2. Create own docker-compose.yml file with:

- Combination of two containers, based on own images: web (php+nginx) and db (mysql/mariadb)

- The application should connect to the database and display a table's content which could be anything, for example, the top 10 cities by population in Bulgaria (reuse the one shown during the practice)

- Replicate the web container with factor 3

- Deploy the solution on the swarm cluster created in the first part

It is not required both tasks to be automated and executed together. Instead, at first, prepare the Vagrantfile and spin up the environment. Then create the docker-compose.yml file, upload it on the cluster and execute it

Note that the compose file may be named either <strong>docker-compose.yml</strong> or <strong>docker-compose.yaml</strong>