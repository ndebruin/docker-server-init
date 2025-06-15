#!/bin/bash

path=$1
git=$2
nfs=$3

# harden and reconfigure sshd
printf "Configuring sshd.\n"
sed -i -e 's/PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i -e 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config


# create ssh key
printf "Generating SSH key for config backups.\n"
ssh-keygen -t ed25519 -q -f "$HOME/.ssh/id_ed25519" -N ""


# get user to configure ssh key
printf "Please enter this SSH key into the git server.\n"
cat "$HOME/.ssh/id_ed25519.pub"


# update system and install necessary packages
printf "Updating system.\n"
apt-get update 
apt-get full-upgrade -y
apt-get install ca-certificates curl gnupg lsb-release nfs-common -y 


# add docker repo
printf "Adding Docker Repository.\n"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


# install docker 
printf "Installing Docker.\n"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io -y
groupadd docker


# install 'docker compose'
printf "Installing 'docker compose'\n"
mkdir /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose


# make 'docker' user
printf "Creating unprivileged 'docker' user.\n"
# create home directory
mkdir $path
# create user
useradd docker -d $path
#own home directory
chmod 750 $path
# set shell to bash
chsh docker -s $(which bash)
# add user to the 'docker' group
usermod -aG docker docker


# create folder structure
printf "Creating folder structure.\n"
cd $path


# make data directory
mkdir $path/data
# mount data directory off of NFS server
printf "$3 $path/data nfs _netdev,rw,hard,intr 0 0" >> /etc/fstab
mount -a


# create config directory
git clone $git 
