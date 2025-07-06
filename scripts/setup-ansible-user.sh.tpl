#!/bin/bash

# Update system
apt update -y

# Create user
useradd ansibleadmin -s /bin/bash -m -d /home/ansibleadmin

# Set password for user
echo "ansibleadmin:${ansibleadmin_pass}" | chpasswd

# Enable password authentication for SSH
sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Reload SSH service to apply changes
service ssh reload

# Add sudo access without password for ansibleadmin
echo "ansibleadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ansibleadmin
chmod 440 /etc/sudoers.d/ansibleadmin

