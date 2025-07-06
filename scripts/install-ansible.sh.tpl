#!/bin/bash

# official document - https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu

# Installing Ansible on Ubuntu (official method)
sudo apt-get update -y
sudo apt-get install software-properties-common -y 
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible -y

# Add User in Ansible Controller : 
useradd devopsadmin -s /bin/bash -m -d /home/devopsadmin

# Set password
echo "devopsadmin:${devopsadmin_pass}" | chpasswd

# Docker access
sudo usermod -aG docker devopsadmin

# Create SSH key for the user (non-interactive)
sudo -u devopsadmin ssh-keygen -t ecdsa -b 521 -f /home/devopsadmin/.ssh/id_ecdsa -N ""
