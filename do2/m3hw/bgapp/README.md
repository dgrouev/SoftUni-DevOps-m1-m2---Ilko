# Deployment of BGApp with Salt

1. Download the boostrap script:
``` shell
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
```

2. Install Salt Master with:
``` shell
sudo sh bootstrap-salt.sh -M -X stable 3006.0
```

3. Open firewall ports and enable Salt Master and open Salt Minion config on the web machine:
``` shell
sudo firewall-cmd --permanent --add-port=4505-4506/tcp

sudo firewall-cmd --reload 

sudo systemctl enable salt-master

sudo systemctl start salt-master

sudo vi /etc/salt/minion
```

4. Uncomment line #16 and type **master: web**

5. Restart the salt-minion service on the web machine:
``` shell
sudo systemctl restart salt-minion
```

6. Open another ssh session to the db machine to add is a a minion with the following commands:
``` shell
vagrant ssh db
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
sudo sh bootstrap-salt.sh stable 3006.0
```

7. Open the salt minion file:
``` shell
sudo nano /etc/salt/minion
```

8. Uncomment line #16 and type **master: web** then save and quit

9. Restart the service with:
``` shell
sudo systemctl restart salt-minion
```

10. Switch back to the Web machine session to register the minions with the following command:
``` shell
sudo salt-key -A
```

11. When prompted for confirmation type Y and press enter

12. Check to make sure the minions were accepted:
``` shell
sudo salt-key -L
```

13. Type y and press enter when prompted for confirmation

14. Open master configuration file and uncomment lines 698-700:
``` shell
sudo vi /etc/salt/master
```

15. Thos are the lines to uncomment:
```
file_roots:
  base:
    - /srv/salt
```

16. Restart the salt master service with:
``` shell
sudo systemctl restart salt-master
```

17. Create the srv/salt folder with:
``` shell
sudo mkdir /srv/salt
```

19. Get the state files and the resources with:
``` shell
sudo cp -R /vagrant/resources/* /srv/salt/
```

18. The top state file at /srv/salt/top.sls should be with the following content:
``` shell
base:
  'web.do2.lab':
    - web
  'db.do2.lab':
    - db
```

19. The web state file at /srv/salt/web.sls should be with following content:
``` yaml
install.web.packages:
  pkg.installed:
    - pkgs:
      - php
      - php-mysqlnd

install.apache.redhat:
  pkg:
    - name: httpd
    - installed

copy_web_files:
  file.recurse:
    - name: /var/www/html
    - source: salt://html

publicc:
  firewalld.present:
    - name: public
    - services:
      - http

firewalld:
  service.running:
    - watch:
      - firewalld: public

httpd_can_network_connect:
  selinux.boolean:
    - value: True
    - persist: True

run.apache.redhat:
  service.running:
    - name: httpd
    - enable: True
    - reload: True
    - require:
      - pkg: httpd
```

20. The db state file at /srv/salt/db.sls should be with following content:
``` yaml
install.mariadb.debian:
  pkg:
    - name: mariadb-server
    - installed

run.mariadb.debian:
  service.running:
    - name: mariadb
    - require:
      - pkg: mariadb-server
    - watch:
      - pkg: mariadb-server

copy_db_files:
  file.recurse:
    - name: /home/vagrant/
    - source: salt://db

open_external_ports:
  cmd.run:
    - name: sed -i.bak s/127.0.0.1/0.0.0.0/g /etc/mysql/mariadb.conf.d/50-server.cnf

create_db:
  cmd.run:
    - name: mysql -u root < /home/vagrant/db_setup.sql || true
    - env:
      - LC_ALL: bg_BG.UTF-8

restart_db:
  cmd.run:
    - name: sudo systemctl restart mariadb
```

21. Apply the states with:
``` shell
sudo salt '*' state.apply
```