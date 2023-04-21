#!/bin/bash

echo "* Add SaltStack repository key ..."
sudo rpm --import https://repo.saltproject.io/salt/py3/redhat/9/x86_64/latest/SALT-PROJECT-GPG-PUBKEY-2023.pub

echo "* Add SaltStack repository ..."
curl -fsSL https://repo.saltproject.io/salt/py3/redhat/9/x86_64/latest.repo | sudo tee /etc/yum.repos.d/salt.repo

echo "* Downloading Bootstrap Script ..."
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com

echo "* Installing latest available version of Salt ..."
sudo sh bootstrap-salt.sh -M -N -X

echo "* Opening ports and reloading firewalld ..."
sudo firewall-cmd --permanent --add-port=4505-4506/tcp
sudo firewall-cmd --reload 

echo "* Starting Salt ..."
sudo systemctl enable salt-master
sudo systemctl start salt-master