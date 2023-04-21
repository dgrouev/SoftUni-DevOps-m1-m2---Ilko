#!/bin/bash

echo "* Downloading Bootstrap Script ..."
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com

echo "* Installing latest available version of Salt on the minion ..."
sudo sh bootstrap-salt.sh

echo "* Point the minion to the master ..."
sudo vi /etc/salt/minion

echo "* Starting Salt ..."
sudo systemctl enable salt-master
sudo systemctl start salt-master