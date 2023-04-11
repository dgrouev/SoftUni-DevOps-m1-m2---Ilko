# Documentation

## Jenkins setup

1. After the provisioning of jenkins machine go to 192.168.99.201:8080 and paste the password from the console, if lost start ssh session to jenkins machine and get it with:
``` shell
cat /var/lib/jenkins/secrets/initialAdminPassword
```
2. Install recommended plugins and continue with default ip address
3. Install Gitea and SSH plugins from Available plugins and Restart Jenkins (See proof 1.2)
3. Register admin user (See proof 1.3)
4. Add Vagrant user and Docker Hub Credentials from Manage Jenkins > Manage Credentials > Global > Add Credentials (See proof 1.4, 1.5, 1.6)
5. On the jenkins machine execute the following commands:
``` shell
ssh-keygen
cat ~/.ssh/id_rsa.pub
```
6. Copy-Paste the SSH Key to the Jenkins user - Manage Jenkins > Users > Admin (Configure) > SSH Public Keys & Save (See proof 1.7)
7. Open port 2222 for Jenkins CLI - Manage Jenkins > Security > SSH Server (See proof 1.8)
8. Start session with jenkins user on the jenkins machine and start another ssh session to vagrant user on containers machine:
``` shell
su - jenkins
Password1
ssh vagrant@containers.do1.exam
```
9. (Enter to all and exit the session (See proof 1.9)
10. Let's create docker node - Manage Jenkins > Nodes and Clouds > New Node:
    * docker-node
    * permanent agent
11. Create docker-node with the following: (See proof 1.10, 1.11, 1.12)
    * name: docker-node
    * desc: Docker Remote Node
    * executors: 2
    * remote root dir: /home/vagrant
    * labels: docker-node
    * usage: Only build jobs..
    * Launch via SSH
    * Creds: vagrant user
    * strategy: Known hosts
    * Save
12. Exit jenkins session on the jenkins machine and execute the following commands as vagrant user, yes to add fingerprint: (See proof 1.13)
``` shell
cd /vagrant
ssh -l admin -p 2222 localhost help
ssh -l admin -p 2222 localhost create-job < exam.xml exam
```
13. We should have our pipeline **exam** in Jenkins, select it and click Build now
14. We should have the working application on 192.168.99.202 (See proof 1.14, 1.15)
15. Pipeline is in Jenkinsfile as well

## Test the containers and gitea
1. Enter the containers machine via ssh and stop the containers with, then run for test (See proof 2.1):
``` shell
docker container rm con-client con-generator con-storage -f
docker container run -d --name con-storage --net exam-net -e MYSQL_ROOT_PASSWORD='ExamPa$$w0r
d' ilkothetiger/exam-storage
docker container run -d --name con-generator --net exam-net ilkothetiger/exam-generator
docker container rm con-client con-generator con-storage -f
```
2. Now let's commit a change to Gitea, go to 192.168.99.202:3000, login with user **exam** and password **Password1** and go to exam/exam repo, open client/code/app.dat, edit the date and commit the changes, and then once again to double-check (See proof 2.2, 2.3)
3. Gitea webhook adding is automated, so is the repo cloning but here's some proof they are matching the required one (See proof 2.4, 2.5)


## Monitoring
1. RAM and CPU load imported with the dashboard (See proof 3.1, 3.2)
4. To export metrics from Docker machine we need to enter it and execute the following commands (See proof 3.3, 3.4)
``` shell
docker swarm init --advertise-addr 192.168.99.202
sudo usermod -aG wheel vagrant
sudo vi  /etc/docker/daemon.json
sudo vi  /etc/docker/daemon.json
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo firewall-cmd --permanent --add-port=9323/tcp
sudo firewall-cmd --reload
```
5. We should see our Docker metrics, and the panel in Grafana will receive them (See proof 3.5, 3.6)
6. Here's our Dashboard (See proof 3.7)
7. These steps were added at the end of the install_docker.sh to automate the process of exporting Docker Metrics