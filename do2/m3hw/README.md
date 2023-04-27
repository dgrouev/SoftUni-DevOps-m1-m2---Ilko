# Homework M3: **Salt**
## Assignment

You must execute **either** one of the following set of tasks or both:
1. With the help of **Salt** and **Vagrant** create **Docker** host and run a **nginx** container in it
2. With the help of **Salt** and **Vagrant** create a two-host setup (**Salt** could be installed on one of the machines):
    * One of the hosts should be based on **Debian/Ubuntu** and the other one – on **CentOS**
    * Both hosts should see each other in terms of network communication. Their names should be **web** and db
    * One of the hosts should play the role of **WEB** server with **web** solution of your choice and PHP installed and the other one – **DB** server with **MySQL/MariaDB** installed
    * On the **WEB** host deploy the content of the **web** folder in M3-Homework-Challenge-**Salt** (files).zip
archive and on the other – the content of the **db** folder from the same archive

Please note that the two tasks are two separate environments

Even though we should try to automate repetitive tasks as much as possible, the emphasis here is to have a working
solution and not a fully automated one. Functionality over automation 