#!/bin/bash

echo "# Install prerequisites"
apt-get update && sudo apt-get install -y ca-certificates curl gnupg lsb-release

echo "# Install the key"
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "# Add the repository"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "# Install the packages"
apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io

echo "# Add vagrant user to the docker group"
usermod -aG docker vagrant
