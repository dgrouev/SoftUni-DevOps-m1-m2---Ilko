# Homework 5 - Automated Pipeline with Jenkins

## Setting up the VMS and the SSH keys

vagrant up

vagrant ssh jenkins

su - jenkins

ssh-keygen -t ecdsa -b 521 -m PEM

ssh-copy-id jenkins@jenkins.do1.lab

ssh-copy-id jenkins@docker.do1.lab

// On the host machine, open http://127.0.0.1:8080/

Enter initialPassword

Install Recommended plugins

Register admin user

Accept proposed url

Enter Jenkins

Go to Plugins and download SSH

Restart Jenkins

In jenkins machine, jenkins user
cd
cd .ssh
cat id_ecdsa
copy the private SSH key

Manage Jenkins > Manage Credentials > Global > Add Credentials > SSH Username with private key
username: jenkins
Private key: Enter directly


Then Manage Jenkins > Configure System > SSH remote hosts > Add
hostname: jenkins.do1.lab
port: 22
credentials: Credentials from File


Then Manage Jenkins > Configure Global Security > SSH Server
SSHD Port Fixed: 2222
Save

Exit Jenkins user
When back to the vagrant on the jenkins machine

ssh-keygen

cat ~/.ssh/id_rsa.pub

Copy the key and then Manage Jenkins > Manage Users > admin > Configure
SSH Public Keys: Paste the Vagrant SSH key we just created
Save

ssh -l admin -p 2222 localhost help

// to add teh fingerprint
yes


Importing the pipeline

cp /vagrant/bgapp.xml .

ssh -l admin -p 2222 localhost create-job Pipeline-BGApp < bgapp.xml

Setting Up Gitea

cp /vagrant/docker-compose.yml .

docker compose up -d

When it's done, navigate to http://192.168.99.102:3000
Change Server domain to: 192.168.99.102
Change Gitea Base URL to: http://192.168.99.102:3000/
Register
New Repository with default settings, repo name is bgapp

Back on the Jenkins machine

cd
git init
git checkout -b main
git remote add origin http://192.168.99.102:3000/ilia/bgapp.git
git clone -b m5 https://github.com/ilkoTheTiger/demo-app
cd demo-app
git branch main
git branch checkout main
git push http://192.168.99.102:3000/ilia/bgapp.git

Go to Gitea Repo > Settings > Webhooks
Target URL: http://192.168.99.101:8080/gitea-webhook/post

One more plugin we need to install in Jenkins
Manage Jenkins > Manage Plugins > Available Plugins > Gitea
Restart Jenkins when installation is complete

Go to Docker hub
Login > Account Settings > Security > New Access Token
Put jenkins in description copy and close

Back to Jenkins > Manage Jenkins > Manage Credentials > System > Global Credentials
Click Add Credentials
username: Docker Hub username
password: Docker Access Token
ID: docker-hub
description: Docker Access Token


In the jenkins machine
ssh -l admin -p 2222 localhost build Pipeline-BGApp -f -v


Installing Gitea plugin
Manage Jenkins > Manage Plugins



