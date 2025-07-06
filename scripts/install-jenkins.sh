#!/bin/bash

# Update system
sudo apt update -y

# Install Git
sudo apt install git -y

# Install Java (required by Jenkins)
sudo apt install fontconfig openjdk-21-jre -y

# Add Jenkins key and repository
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update again to recognize Jenkins repo
sudo apt-get update -y

# Install Jenkins
sudo apt-get install jenkins -y

# Enable and start Jenkins service
sudo systemctl daemon-reexec
sudo systemctl enable jenkins
sudo systemctl start jenkins