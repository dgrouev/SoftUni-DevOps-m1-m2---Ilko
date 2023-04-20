# BGApp Deployment

1. Execute vagrant up and enter SSH session to ansible mashine:
```
vagrant up
vagrant ssh ans
```

2. Copy Needed Files on Ansible machine:
```
cp -r /vagrant /home
```

3. Create ansible.cfg file with following content:
```
[defaults]
host_key_checking = False
inventory = inventory
```

4. Create inventory file with following content:
```
web ansible_host=192.168.99.100
db ansible_host=192.168.99.101

[webserver]
web

[dbserver]
db

[servers:children]
webserver
dbserver

[servers:vars]
ansible_user=vagrant
ansible_ssh_pass=vagrant
```

5. Create redhat.yml playbook with following content:
``` yaml
---
- hosts: webserver
  become: true

  tasks:
  - name: “Installing HTTPD Software”
    package:
       name: httpd
       state: present
  - name: "Install PHP"
    package:
      name: php
      state: present

  - name: "Install MySQL"
    package:
      name: php-mysqlnd
      state: present

  - name: “Copy Files”
    copy:
       dest: /var/www/html/
       src: html/
       directory_mode: true
    notify: “web_restart”

  - name: "Add HTTP as exclusion in SELinux"
    shell: setsebool -P httpd_can_network_connect=1

  - name: “Starting Web Server”
    service:
       name: httpd
       state: started
  - name: "Open HTTP Port"
    firewalld:
      service: http
      state: enabled
      permanent: yes
      immediate: yes

  handlers:
  - name: “web_restart”
    service:
       name: httpd
       state: restarted
```

5. Create debian.yml playbook with following content:
``` yaml
---
- hosts: dbserver
  become: true

  tasks:

  - name: Install Utility software
    apt: name={{item}} state=latest update_cache=yes
    with_items:
      - software-properties-common
      - mariadb-server

  - name: “Copy Files”
    copy:
       dest: /home/vagrant/db/
       src: db/
       directory_mode: true
    notify: “db_restart”

  - name: Open external ports
    shell: sed -i.bak s/127.0.0.1/0.0.0.0/g /etc/mysql/mariadb.conf.d/50-server.cnf

  - name: Create and Load Database
    shell: mysql -u root < /home/vagrant/db/db_setup.sql || true

  handlers:
  - name: “db_restart”
    service:
       name: mariadb
       state: restarted
```

6. Execute the playbooks with following commands:
```
ansible-playbook redhat.yml
ansible-playbook debian.yml
```

7. The Application should be deployed successfully on following address:
```
http://192.168.99.100/
```