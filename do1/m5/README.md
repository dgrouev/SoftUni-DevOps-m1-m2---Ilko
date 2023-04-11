# Homework M5: Jenkins Advanced

## Assignment

You are expected to create the following

## 1. A setup with two virtual machines – one with <strong>Jenkins</strong> and another with <strong>Docker</strong> installed just like on the practice

* <italic>You can adjust their parameters in order to fit within your available resources</italic>

## 2. On the Docker machine you must deploy Gitea (as we did during the practice)

1. Create a repository to host your version of the BGApp application

2. Enable Webhooks

3. On the Jenkins machine create a pipeline to build the BGApp application. There should be steps for:

1. Downloading the project from your Gitea repository

2. Using one Docker Compose file to

- Build the images

- Create a common network

- Run the containers (the web container to publish port on 8080)

## 3. Testing the application for reachability and that (after a short wait) one of cities (for example Sofia) is displayed

4. Stopping the application and removing the containers

5. Publishing the images to Docker Hub

6. Using another Docker Compose file to

- Create a common network

- Run the containers (the web container to publish port on 80)

As usual, try to do the infrastructure part as automated as possible. Of course, using Vagrant

For the Jenkins part, try to automate it as much as possible. Ideally, there should be a Jenkinsfile hosted in the repository from which you create the pipeline (try to use the CLI to automate this as well