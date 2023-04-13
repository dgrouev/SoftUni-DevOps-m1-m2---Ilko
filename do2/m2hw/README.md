# Homework M2: Ansible
## Assignment
You must execute the following set of tasks:
1. With the help of Ansible and Vagrant create Docker host and run a nginx container in it
You can use a role downloaded from Ansible Galaxy, or create the playbook all by yourself
2. With the help of Ansible and Vagrant create a two-host setup:
- One of the hosts should be based on Debian/Ubuntu and the other one – on CentOS
- Both hosts should see each other in terms of network communication. Their names should be web
and db
- One of the hosts should play the role of WEB server with web solution of your choice and PHP
installed and the other one – DB server with MySQL/MariaDB installed
- On the WEB host deploy the content of the web folder in M2-Homework-Challenge-Ansible
(files).zip archive and on the other – the content of the db folder from the same archive
**Please note that the two tasks are two separate environments**
Even though we should try to automate repetitive tasks as much as possible, the emphasis here is to have a working
solution and not a fully automated one. Functionality over automation 