#!/bin/bash

exec > /tmp/user_data.log 2>&1

# Update system
sudo apt-get update -y
hostnamectl set-hostname build-server

${build_server}

${install_ansible}

${node_exporter_sh}