# Homework 3: Task 1 - NGINX Container with Salt
1. Execute vagrant up and enter the server machine:
``` shell
vagrant up
vagrant ssh web
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
sudo sh bootstrap-salt.sh -P -M -X stable 3006.0
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

8. Open the salt-master config file with **sudo vi /etc/salt/minion** and uncomment line #16 to say: **master: web** then restart the salt-minion with:
``` shell
sudo systemctl restart salt-minion
```

9. Register the minion with the following command, type **y** and press enter when prompted for confimation:
``` shell
sudo salt-key -A
```

10. Open master configuration file and uncomment lines 698-700:
``` shell
sudo vi /etc/salt/master
```

11. These are the lines to uncomment:
```
file_roots:
  base:
    - /srv/salt
```

12. Restart the salt master service with:
``` shell
sudo systemctl restart salt-master
```

13. Create the srv/salt folder with:
``` shell
sudo mkdir /srv/salt
```

14. Get the state files and the resources with:
``` shell
sudo cp -R /vagrant/resources/* /srv/salt/
```

15. The top state file at /srv/salt/top.sls should be with the following content:
``` shell
base:
  'web.do2.lab':
    - nginx
```

16. The web state file at /srv/salt/web.sls should be with following content:
``` yaml
install.common.packages:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - curl
  pip.installed:
    - pkgs:
      - docker

docker-repo:
  pkgrepo.managed:
    - humanname: Docker Officia
    - name: docker-ce-stable
    - baseurl: https://download.docker.com/linux/centos/{{ grains['osmajorrelease'] }}/x86_64/stable
    - gpgkey: https://download.docker.com/linux/centos/gpg
    - gpgcheck: 1
    - enabled: 1

docker:
  pkg.installed:
    - refresh: True
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io
    - aggregate: False

run.docker:
  service.running:
    - name: docker
    - enable: True
    - require:
      - pkg: docker

nginx_container:
  docker_container.running:
    - image: nginx
    - name: mynginx
    - skip_translate: port_bindings
    - port_bindings: {80: 80}
```

17. Apply the states with:
``` shell
sudo salt '*' state.apply
```
