vagrant up

vagrant ssh jenkins

sudo wget https://pkg.jenkins.io/redhat/jenkins.repo -O /etc/yum.repos.d/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

sudo dnf makecache

sudo dnf -y install jenkins

sudo dnf -y install java-17-openjdk

sudo systemctl start jenkins

sudo systemctl enable jenkins

sudo firewall-cmd --permanent --add-port=8080/tcp

sudo firewall-cmd --permanent --add-port=80/tcp

sudo firewall-cmd --reload

sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf install -y docker-ce docker-ce-cli containerd.io

sudo systemctl enable docker

sudo systemctl start docker

sudo usermod -aG docker vagrant

sudo usermod -aG docker jenkins

sudo dnf -y install git

sudo mkdir -p /projects

sudo chown -R jenkins:jenkins /projects

sudo dnf -y install httpd

sudo systemctl start httpd

sudo systemctl enable httpd

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

<!-- // Navigate to 127.0.0.1:8080 on the Host machine

Paste the Jenkins Secret

Install Suggested Plugins

Register as doadmin

Confirm proposed URL

Start using Jenkins

// Back to the Jenkins VM-->

sudo vi /etc/passwd

/false + i

/bin/bash
:wq

sudo passwd jenkins

su - jenkins

<!-- pwd 
(/var/lib/jenkins)

ssh-keygen -t ecdsa -b 521 -m PEM

ssh-copy-id jenkins@localhost

ssh jenkins@localhost (should login without password) -->

sudo visudo
<!-- Adding jenkins to sudoers list -->

sudo systemctl restart jenkins


<!-- Logging back to Jenkins in the browser

Create Homework Dir

Create Pipeline using the Jenkinsfile

Build now

 -->



