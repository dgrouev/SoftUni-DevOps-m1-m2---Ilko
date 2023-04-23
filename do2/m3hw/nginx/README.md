# Homework 3: Task 1 - NGINX Container with Salt
1. Execute vagrant up and enter the server machine:
``` shell
vagrant up
vagrant ssh server
```

2. Add SaltStack repository key
``` shell
sudo rpm --import https://repo.saltproject.io/salt/py3/redhat/9/x86_64/latest/SALT-PROJECT-GPG-PUBKEY-2023.pub
```

3. Add SaltStack repository
``` shell
curl -fsSL https://repo.saltproject.io/salt/py3/redhat/9/x86_64/latest.repo | sudo tee /etc/yum.repos.d/salt.repo
```

4. Download Bootstrap Script
``` shell
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
```

5. Install latest available version of Salt
``` shell
sudo sh bootstrap-salt.sh -P -M -N -X stable 3006.0
```

6. Open ports and reloading firewalld
``` shell
sudo firewall-cmd --permanent --add-port=4505-4506/tcp
sudo firewall-cmd --reload 
```

7. Start Salt
``` shell
sudo systemctl enable salt-master
sudo systemctl start salt-master
```

8. Install salt-ssh with **sudo dnf install salt-ssh**

9. Create roster file:
``` shell
sudo vi /etc/salt/roster
```
it should have the following content
```
web:
 host: 192.168.99.100
 user: vagrant
 passwd: vagrant
 sudo: True
```

10. Add Docker Repo with:
``` shell
sudo salt-ssh -i 'web' cmd.run 'dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo'
```

11. Install Docker-ce, docker-cli and containerd.io with:
``` shell
sudo salt-ssh -i 'web' cmd.run 'dnf install -y docker-ce docker-ce-cli containerd.io'
```

12. Enable docker with:
``` shell
sudo salt-ssh -i 'web' cmd.run 'systemctl enable --now docker'
```

13. Start NGINX container:
``` shell
sudo salt-ssh -i 'web' cmd.run 'docker run --name mynginx1 -p 80:80 -d nginx'
```
