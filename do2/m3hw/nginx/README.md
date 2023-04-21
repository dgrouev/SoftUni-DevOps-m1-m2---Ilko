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
sudo sh bootstrap-salt.sh -M -N -X
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

8. Exit the server machine

## Switch to the Web machine
1. Enter ssh Session
``` shell
vagrant ssh web
```

2. Download Bootstrap Script
``` shell
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
```
3. Install latest available version of Salt on the minion
``` shell
sudo sh bootstrap-salt.sh
```

4. Point the minion to the master
``` shell
sudo vi /etc/salt/minion
```

5. Edit row 16 by uncommenting the line and pointing the server machine:
```
master: server
```

6. Make sure the server machine is inside the hosts file:
```
sudo vi /etc/hosts
```
there should be a line:
```
192.168.99.99 server.do2.lab server
```
if not add it manually then save and quit


7. Restart Salt
``` shell
sudo systemctl restart salt-minion
```

8. Exit Web Machine

## Switch back to Server machine
1. Enter ssh session
``` shell
vagrant ssh server
```

2. Accept the minion key:
``` shell
sudo salt-key -A
```

3. Type "y" and press enter

4. Initialize the Salt State Tree by uncommenting lines 698-700:
``` shell
sudo vi /etc/salt/master
```

5. Restart Salt Master:
``` shell
sudo systemctl restart salt-master
```

6. Make the root folder:
``` shell
sudo mkdir /srv/salt
```

7. Create the top.sls in /srv/salt with the following contents - sudo vi /srv/salt/top.sls:
```
base:
  '*':
    - nginx
```

8. Create the nginx state with the following contents - sudo vi /srv/salt/nginx.sls:
```
install.common.packages:
  pkg.installed:
    - pkgs:
      - containerd.io
      - docker-ce
      - docker-ce
      - vim
```

9. Add the Docker Repo on Minion Machine:
``` shell
sudo salt '*' cmd.run 'dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo'
```

10. Start the NGINX Container
``` shell
salt-call --local dockerng.sls_build test base=nginx mods=vim
```