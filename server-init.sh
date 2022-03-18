#!/bin/bash

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


