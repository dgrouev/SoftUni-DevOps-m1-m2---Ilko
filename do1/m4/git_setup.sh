#!/bin/bash

echo "* Installing Git ..."
sudo dnf -y install git

echo "* Make Projects Demo App folder  ..."
sudo mkdir -p /projects

echo "* Make Jenkins user owner of Projects Folder ..."
sudo chown -R jenkins:jenkins /projects