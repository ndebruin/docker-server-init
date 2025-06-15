#!/bin/sh



#######################
# install docker-engine
#######################

# remove all packages
sudo apt-get remove docker docker-engine docker.io containerd runc

# update
sudo apt-get update

# install https-repo support
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# add docker repo key
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# add docker repo
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# update
sudo apt-get update

# install docker-engine
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# add docker group
sudo groupadd docker
sudo usermod -aG docker $USER


#######################
# install gVisor
#######################

# update and install all requirements
sudo apt-get update && \
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg

# add repo key
curl -fsSL https://gvisor.dev/archive.key | sudo gpg --dearmor -o /usr/share/keyrings/gvisor-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/gvisor-archive-keyring.gpg] https://storage.googleapis.com/gvisor/releases release main" | sudo tee /etc/apt/sources.list.d/gvisor.list > /dev/null

# update and install runsc
sudo apt-get update && sudo apt-get install -y runsc

