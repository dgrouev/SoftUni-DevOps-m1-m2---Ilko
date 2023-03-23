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

## Jenkins setup
1. Navigate to http://127.0.0.1:8080/ on the host machine
2. Get the password from the jenkins machine paste into Administrator password field, then Continue [Proof 2.1], use the following command to get the password:
``` shell
cat /var/lib/jenkins/secrets/initialAdminPassword
```
3. Install recommended plugins, [Proof 2.2]
4. Register with following details, [Proof 2.3]:
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

## Gitea Setup
1. Open session to the docker machine in a new terminal with:
``` shell
vagrant ssh docker
```
2. 



![sample result](https://github.com/shekeriev/dob-2021-04-exam-re/blob/main/result.png?raw=true)