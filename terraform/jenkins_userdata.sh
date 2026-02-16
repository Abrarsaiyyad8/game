#!/bin/bash

# install java 
sudo apt update -y
sudo apt install fontconfig openjdk-21-jre -y 
java -version

# install jenkins in server 
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y 
sudo apt install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

# install docker 
# Install required dependencies
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Add Docker GPG Key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o \
/usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker Repository
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list again
sudo apt update -y

# Install Docker Engine
sudo apt install docker-ce docker-ce-cli containerd.io -y

echo "Starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Adding current user to Docker group..."
sudo usermod -aG docker ubuntu
usermod -aG docker jenkins
echo "Docker installation completed!"
echo "Please logout and login again to use Docker without sudo."


# install aws cli 

echo "===== Updating System ====="
apt-get update -y

echo "===== Installing Required Packages ====="
apt-get install -y curl unzip

cd /tmp

echo "===== Downloading AWS CLI v2 ====="
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

echo "===== Unzipping Package ====="
unzip -o awscliv2.zip

echo "===== Installing AWS CLI ====="
./aws/install

echo "===== Verifying Installation ====="
/usr/local/bin/aws --version

echo "===== Cleaning Up ====="
rm -rf aws awscliv2.zip

echo "===== AWS CLI Installed Successfully ====="

# install git 

sudo apt update -y 
sudo apt install git -y

