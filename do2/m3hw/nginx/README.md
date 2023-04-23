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

8. Create roster file:
```
sudo vi /etc/salt/roster
```
it should have the following content
