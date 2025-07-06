#!/bin/bash

exec > /tmp/user_data.log 2>&1

# Update system and set hostname
sudo apt-get update -y
hostnamectl set-hostname worker-node${index}

${node_exporter_sh}

${install-kubernetes}