# Deployment of BGApp with Salt

1. Download the boostrap script:
``` shell
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
```

2. Install Salt Master with:
``` shell
sudo sh bootstrap-salt.sh -M -X stable 3006.0
```

3. Open firewall ports and enable Salt Master:
``` shell
sudo firewall-cmd --permanent --add-port=4505-4506/tcp

sudo firewall-cmd --reload 

sudo systemctl enable salt-master

sudo systemctl start salt-master
```

4. Open another ssh session to the db machine to add is a a minion with the following commands:
``` shell
vagrant ssh db
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
sudo sh bootstrap-salt.sh
```

5. Open the salt minion file:
``` shell
sudo nano /etc/salt/minion
```

6. Uncomment line #16 and type **master: web** then save and quit

7. Restart the service with:
``` shell
sudo systemctl restart salt-minion
```

8. Switch back to the Web machine session to register the minion with the following command:
``` shell
sudo salt-key -A
```

9. When prompted for confirmation type Y and press enter

10. Check to make sure the minion was accepted:
``` shell
sudo salt-key -L
```

11. Do the same for the web machine:
``` shell
sudo vi /etc/salt/minion
```

12. Uncomment line #16 and type **master: web**

13. Restart the salt-minion service on the web machine:
``` shell
sudo systemctl restart salt-minion
```

15. Accept the web machine as minion:
``` shell
sudo salt-key -A
```

16. Type y and press enter when prompted for confirmation

17. Open master configuration file and uncomment lines 698-700:
``` shell
sudo vi /etc/salt/master
```

18. Thos are the lines to uncomment:
```
file_roots:
  base:
    - /srv/salt
```

19. Restart the salt master service with:
``` shell
sudo systemctl restart salt-master
```

20. Create the srv/salt folder with:
``` shell
sudo mkdir /srv/salt
```

21. Create /srv/salt/top.sls file with the following content:
``` shell
base:
  'web.do2.lab':
    - web
  'db.do2.lab':
    - db
```

22. Create salt source for web and db files with the following commands:
``` shell
sudo mkdir /srv/salt/var
sudo mkdir /srv/salt/var/www
sudo cp -R /vagrant/html /srv/salt/var/www
sudo cp -R /vagrant/db /srv/salt
```