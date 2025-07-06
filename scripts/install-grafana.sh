#!/bin/bash

set -e

# Update and install dependencies
sudo apt-get update -y
sudo apt-get install -y adduser libfontconfig1 musl

# Download Grafana (Enterprise edition)
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_12.0.2_amd64.deb

# Install Grafana
sudo dpkg -i grafana-enterprise_12.0.2_amd64.deb

# Enable and start service
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

