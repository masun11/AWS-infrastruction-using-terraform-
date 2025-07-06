#!/bin/bash

set -e

# Update packages
apt-get update -y

# Download and extract Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v3.5.0-rc.0/prometheus-3.5.0-rc.0.linux-amd64.tar.gz
tar -zxvf prometheus-3.5.0-rc.0.linux-amd64.tar.gz

# Move to /opt and link binary
mv prometheus-3.5.0-rc.0.linux-amd64 /opt/prometheus
ln -s /opt/prometheus/prometheus /usr/local/bin/prometheus
ln -s /opt/prometheus/promtool /usr/local/bin/promtool

# Update prometheus.yml to add node_exporter target BEFORE starting
cat > /opt/prometheus/prometheus.yml <<EOT
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'build_server'
    static_configs:
      - targets: ['${private_ips.build_server}:9100']

  - job_name: 'jenkins_master'
    static_configs:
      - targets: ['${private_ips.jenkins_master}:9100']

  - job_name: 'kubernetes_master'
    static_configs:
      - targets: ['${private_ips.kubernetes_master}:9100']

  - job_name: 'worker_nodes'
    static_configs:
      - targets: [
%{ for ip in private_ips.worker_nodes ~}
        "${ip}:9100",
%{ endfor ~}
      ]
EOT

# Create systemd service file
cat > /etc/systemd/system/prometheus.service <<EOT
[Unit]
Description=Prometheus Server
Documentation=https://prometheus.io/docs/introduction/overview/
After=network-online.target

[Service]
User=root
Restart=on-failure
ExecStart=/opt/prometheus/prometheus --config.file=/opt/prometheus/prometheus.yml

[Install]
WantedBy=multi-user.target
EOT

# Start Prometheus service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus
