# Proof of implementation

## Spinning-up the infrastructure
1. Start with 'vagrant up' once inside the folder with provided Vagrantfile and scripts, see [Proof 1.1]
2. Once completed [Proof 1.2] go inside the jenkins machine with 'vagrant ssh jenkins'
3. Make sure the machines of our infrastructure are inside the /etc/hosts [Proof 1.3] - this is achieved with the add_hosts.sh
``` shell
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
127.0.1.1 vm101.do1.exam vm101
192.168.99.100 jenkins.vm100.do1.exam jenkins
192.168.99.101 docker.vm101.do1.exam docker
192.168.99.102 monitor.vm102.do1.exam monitor
```
4. Enter session with user 'jenkins' to make ssh key and copy it inside the 'jenkins user' to all of the machines [Proof 1.4, Proof 1.5] - this is achieved executing the following commands inline (if prompted for password enter: 'Password1', yes to add the fingerprints and default values when creating the key):
``` shell
su - jenkins
ssh-keygen -t ecdsa -b 521 -m PEM
ssh-copy-id jenkins@jenkins.vm100.do1.exam
ssh-copy-id jenkins@docker.vm101.do1.exam
```
5. We need to add the jenkins user to the sudoers file on the Docker machine **manually**, as it's read-only and we have to override it with :wq! [Proof 1.6] execute the following:
``` shell
ssh jenkins@docker.vm101.do1.exam
sudo vi /etc/sudoers/
```
<!-- 6. Then we have to add the docker group to the jenkins machine
6. We will have to Restart Jenkins for the changes to take effect, go to Manage Jenkins -> Reload Configuration from Disk -> OK -->

## Jenkins setup
1. Navigate to http://127.0.0.1:8080/ on the host machine
2. Get the password from the jenkins machine paste into Administrator password field, then Continue [Proof 2.1], use the following command to get the password:
``` shell
cat /var/lib/jenkins/secrets/initialAdminPassword
```
3. Install recommended plugins, [Proof 2.2]
4. Register with following details, [Proof*2.3]:
    * Username: doadmin
    * Password: Password1
    * Full name: DevOps Admin
    * E-mail address: doadmin@do1.exam
5. Use default address and press **Save and Continue**, [Proof 2.4], then press **Start using Jenkins**.
6. Go to Manage Jenkins -> Plugins -> Available Plugins and SSH - with download now and install after restart option
7. Restart Jenkins
8. On the jenkins machine, get the ssh key using the following commands, [Proof 2.5, Proof 2.6, Proof 2.7]:
``` shell
cd
cd .ssh
cat id_ecdsa
```
9. Copy the private SSH key, [Proof 2.8]
10. On the Jenkins web interface, Manage Jenkins > Manage Credentials > Global > Add Credentials > Select **Username with password**, enter the following data and Create [Proof 2.9]
    * Scope: gloval
    * Username: vagrant
    * Password: vagrant (same as vagrant user)
    * Description: Local user with password
11. Then again click on Add Credentials > Select **SSH Username with private key** [Proof 2.10, Proof 2.11]
    * Scope: gloval
    * Username: jenkins
    * Private key: Enter directly (Check step 8)
    * Description: Credentials from file
12. Then Manage Jenkins > System > SSH remote hosts > Add, [Proof 2.12]
    * hostname: jenkins.vm100.do1.exam
    * port: 22
    * credentials: Credentials from File
13. Then Manage Jenkins > Security > SSH Server, [Proof 2.13]
    * SSH Port Fixed: 2222
    * Save
14. Back on the Jenkins machine, exit the Jenkins session going back to the **vagrant user** and exectute the following commands, (initialize ssh key with default values), [Proof 2.14]:
``` shell
ssh-keygen
cat ~/.ssh/id_rsa.pub
```
15. Copy the key and then Manage Jenkins > Users > doadmin > Configure, [Proof 2.15]
    * SSH Public Keys: Paste the Vagrant SSH key we just created
    * Save
16. Add Docker machine as a slave node in Jenkins, go to Manage Jenkins > Nodes and Clouds > New Node then, [Proof 2.16]
    * Node name: docker-node
    * Select Permanent Agent option
17. Click Create and enter the following data, [Proof 2.17, Proof 2.18]:
    * Description: Docker machine
    * Number of Executors: 4
    * Remote root directory: /home/jenkins
    * Labels: docker-node
    * Usage: Only build jobs with label expression matching this node
    * Launch agents via SSH
    * Host: docker.vm101.do1.exam
    * Credentials: jenkins (Credentials from file)
    * Host Key Verification Strategy: Known hosts file
    * Save
18. Click on the newly added docker machine, then log to monitor the process and make sure it's completed before running jobs on the machine, [Proof 2.19]
19. Go https://hub.docker.com/ then Sign In > Account Settings > Security > New Access Token with Read, Write and Delete [Proof 2.20]
20. Put jenkins in description copy and close
21. Back to Jenkins > Manage Jenkins > Manage Credentials > System > Global Credentials > Add Credentials and enter the following data: [Proof 2.21]
    * Kind: Username and password
    * Username: *Your Docker Hub username*
    * Password: *Your Docker Access Token*
    * ID: docker-hub
    * Description: Docker Access Token

## Gitea Setup
1. Open session to the docker machine in a new terminal with:
``` shell
vagrant ssh docker
```
2. Copy the docker-compose.yml locally and docker compose with the following commands, [Proof 3.1, Proof 3.2]:
``` shell
cp /vagrant/docker-compose.yml .
docker compose up -d
```
3. Navigate to http://192.168.99.101:3000 on the host and do the following. [Proof 3.3]:
    * Change Server domain to: 192.168.99.101
    * Change Gitea Base URL to: http://192.168.99.101:3000/
    * Click Install Gitea (it may take a while to install)
4. Once installed, create an account by clicking **Need an account? Registor now.** under the Sign In form, [Proof 3.4]
5. Enter the following details, [Proof 3.5]
    * Username: ilia
    * Email Address: doadmin@do1.exam
    * Password: Password1
    * Re-type and Create
6. You should see account was successfully created, click on the plus on the right of Repositories: 0 to add New Repository, [Proof 3.6]
7. Create repository 'exam' with default values for all the other fields, [Proof 3.7]
8. Go back on the Jenkins machine and execute the following commands, [Proof 3.8]:
``` shell
cd
git init
git checkout -b main
git remote add origin http://192.168.99.101:3000/ilia/exam.git
git clone https://github.com/shekeriev/dob-2021-04-exam-re.git
cd dob-2021-04-exam-re
git push http://192.168.99.101:3000/ilia/exam.git
```
9. When promted for password after the last command, enter following credentials. [Proof 3.9]:
    * Username: ilia
    * Password: Password1
10. Back to Gitea Web Interface, we should see our cloned repo, [Proof 3.10]
11. Click on Settings -> Select Webhooks -> Add Webhook -> Gitea [Proof 3.11]
12. Add Gitea webhook with target URL http://192.168.99.100:8080/gitea-webhook/post
, [Proof 3.12]:
13. Go back to Jenkins Web Interface and install the Gitea plugin (Manage Jenkins -> Plugins -> Available Plugins: Gitea), [Proof 3.13]
14. Click on **Download now and install after restart** option and wait (sometimes Jenkins doesn't restart on it's own, so you might have to manually refresh the browser tab)[Proof 3.14]
15. Go back to Gitea Web interface and click on our webhook, scroll down and click **Test Delivery**, you should see tick[Proof 3.15]
16. If the delivery fails, double-check our url is the Jenkins machine ip at port 8080 on endpoint /gitea-webhook/post, then make sure we have the environment variable GITEA__webhook__ALLOWED_HOST_LIST present in the configuration file of Gitea, which should be configured to allow other hosts to invoke webhooks, it should be configured like this (check the docker-compose.yml)[Proof 3.16]
``` yml
      - GITEA__webhook__ALLOWED_HOST_LIST=192.168.99.0/24
```

## Creating the pipeline
1. Inside the cloned repo folder, create docker-compose.yml file with the following content:
``` yml
```

2. Create Jenkisfile with the following content:
``` groovy
...
```

3. Create folder deploy and inside it create another docker-compose.yml file with the following content:
``` yml
```

4. Publish the changes to the Gitea repository with the following commands:
``` shell
cd ..
git add .
git status .
git commit -m'Pipeline files'
git push http://192.168.99.101:3000/ilia/exam.git
ilia
Password1
```

5. Go to Jenkins Web Interface Dashboard and click on New Item, select Pipeline and name it Pipeline-exam [Proof 4.1]
6. Create the pipeline with following settings: [Proof 4.1, Proof 4.2, Proof 4.3]
    * Description: Pipeline for exam
    * 
    * Built Triggers: **Check GitHub hook trigger for GIT** and **Scm polling and Poll SCM**
    * Pipeline Definition:
        - Pipeline script from SCM
        - SCM: Git
        - Repository URL: http://192.168.99.101:3000/ilia/exam.git
        - Credentials: -none-
        - Branch Specifier: */main
        - Repository browser: auto
        - Script Path: Jenkinsfile
        - Lightweight checkout: checked
9. Save and Build now

## Elastic Stack setup
1. Start a session on the monitor machine and make sure the Elasticsearch, Logstash and Kibana services are running by executing the following command: [Proof*5.1]:
``` shell
systemctl status elasticsearch logstash kibana
```
2. Ctrl + C and press Enter, **if any of the services is down**, make sure to import the corelating .yml file from the provided scripts:
    * Elasticsearch: elasticsearch.yml (/etc/elasticsearch/) and jvm.options (/etc/elasticsearch/jvm.options.d/)
    * Logstash: beats.conf (/etc/logstash/conf.d/)
    * Kibana: kibana.yml (/etc/kibana/)
Copy-paste its contents to /etc/*service*/*service.yml* then execute the following commands:
``` shell
sudo systemctl daemon-reload
sudo systemctl enable *service*
sudo systemctl start *service*
```
3. Once we got all of the 3 active and running, we can go to our jenkins machine and execute this command: [Proof 5.2]
``` shell
sudo metricbeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["192.168.99.102:9200"]'
```
4. Execute the following command to create the Data View with the REST API, [Proof 5.3]
``` shell
curl -X POST http://192.168.99.102:5601/api/data_views/data_view -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "data_view": {
    "name":"Metricbeat",
    "title":"metricbeat-8.6.2-*",
    "timeFieldName":"@timestamp"
  }
}'
```
5. Navigate to http://192.168.99.102:5601/ on the host machine, click on the drop-down menu and scroll all the way down then click on Stack Management, check if we got the Index and the Data View added successfully:
    * Under Data click on Index Management, there should be something like *metricbeat-8.6.2-2023.03.24* [Proof*5.4]
    * Under Kibana click on Data Views, there should be our **Metricbeat** [Proof 5.5]
6. If the Metricbeat is missing, add it manually with the following instructions: [Proof*5.6]
    * Name: Metricbeat
    * Index Pattern: metricbeat-8.6.2-*
    * Timestamp field: @timestamp
7. From the drop-down menu go to Dashboard, click on Create Dashboard, click on Add Visualization, create one visualization with the following details: [Proof*5.7]
    * Horizontal axis: @timestamp
    * Vertical axis: host.cpu.usage
    * Breakdown: agent.name.keyword
8. Click on **Save and Return** then click on **Create Visualization** again to add one more with: [Proof*5.8]
    * Horizontal axis: @timestamp
    * Vertical axis: system.memory.used.pct
    * Breakdown: agent.name.keyword
9. Click again on **Save and Return**, we should see our Dashboard with 2 visualizations, click on **Save** [Proof*5.9]

![sample result](https://github.com/shekeriev/dob-2021-04-exam-re/blob/main/result.png?raw=true)