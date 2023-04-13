# Homework M1: Infrastructure as Code
Main goal is to build further on what was demonstrated during the practice
## Tasks
We have a project used to build a set of two container images:
- Project: https://github.com/shekeriev/bgapp
- Image 1: https://hub.docker.com/repository/docker/shekeriev/bgapp-web
- Image 2: https://hub.docker.com/repository/docker/shekeriev/bgapp-db
## Utilizing what was discussed and shown during the lecture, try to do the following:
1. Create a Terraform configuration to build a small containerized application in Docker by using the two
images. You must provide the containers with connectivity and depending on the approach to mount the
web folder. For details, check the information in the repository
2. Using the files (SQL and PHP) from the project, create a Terraform configuration for building a small
infrastructure with two VMs (one for the DB part, and another for the WEB part) either in a cloud platform
(for example, AWS, Azure, GCP, etc.) or in on-premises hypervisor (for example, Hyper-V, KVM, etc.)
**(1)** Please note that you can do either one of the tasks or all of them. Whichever you choose, your submission will be
accepted, and you will be eligible to receive the corresponding amount of homework points
**(2)** The "official" solution will contain solutions to both tasks. For task 2, the solution will contain information for
AWS and KVM
## Proof
Prepare a document that show what you accomplished and how you did it. It can include (not limited to):
1. The commands you used to achieve the above tasks
2. Any configuration files produced while solving the tasks
3. A few pictures showing intermediary steps or results