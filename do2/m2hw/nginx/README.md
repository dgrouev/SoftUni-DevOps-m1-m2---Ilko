## Execute
``` shell
vagrant up ans web1
```

Enter the Ansible machine with
``` shell
vagrant ssh ans
```

Install the Docker module with:
```
ansible-galaxy collection install community.docker
```

Create the files with the following contents:
1. inventory
```
web1 ansible_host=192.168.99.100

[webservers]
web1

[webservers:vars]
ansible_user=vagrant
ansible_ssh_pass=vagrant
```

2. ansible.cfg
```
[defaults]
host_key_checking = False
inventory = inventory
```

3. playbook.yml
``` yaml
---
- name: install Docker
  hosts: all
  become: true
  tasks:
    - name: set mydistribution
      ansible.builtin.set_fact:
        mydistribution: "{{ 'rhel' if (ansible_distribution == 'Red Hat Enterprise Linux') else (ansible_distribution | lower) }}"

    - name: Add signing key
      ansible.builtin.rpm_key:
        key: "https://download.docker.com/linux/{{ mydistribution }}/gpg"
        state: present

    - name: Add repository into repo.d list
      ansible.builtin.yum_repository:
        name: docker
        description: docker repository
        baseurl: "https://download.docker.com/linux/{{ mydistribution }}/$releasever/$basearch/stable"
        enabled: true
        gpgcheck: true
        gpgkey: "https://download.docker.com/linux/{{ mydistribution }}/gpg"

    - name: Install Docker
      ansible.builtin.yum:
        name:
          - docker-ce
          - docker-ce-cli
          - containerd.io
          - python3-requests
        state: latest
        update_cache: true

    - name: Start Docker
      ansible.builtin.service:
        name: "docker"
        enabled: true
        state: started

    - name: Start NGINX container
      docker_container:
        name: web
        image: nginx
        state: started
        recreate: yes
        ports:
          - "80:80"
```

Execute the playbook with the following command:
``` shell
ansible-playbook playbook.yml
```