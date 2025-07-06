#!/bin/bash

exec > /tmp/user_data.log 2>&1

# Update system
sudo apt-get update -y
hostnamectl set-hostname jenkins-master

${setup-jenkins}

${node_exporter_sh}