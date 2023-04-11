vagrant up

<!-- Creating the Vagrantbox with Docker, Jenkins, Apache and Git -->

vagrant ssh jenkins

sudo wget https://pkg.jenkins.io/redhat/jenkins.repo -O /etc/yum.repos.d/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

sudo dnf makecache

sudo dnf -y install jenkins

sudo dnf -y install java-17-openjdk

sudo systemctl start jenkins

sudo systemctl enable jenkins

echo "jenkins  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jenkins

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

<!-- // Get the initial jenkins Admin Password  -->

vagrant ssh jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

<!-- Navigate to 127.0.0.1:8080 on the Host machine

Paste the Jenkins Secret

Install Suggested Plugins

Register as doadmin

Confirm proposed URL

Start using Jenkins

Create Homework Dir

Create Pipeline using the Jenkinsfile

Build now

 -->



