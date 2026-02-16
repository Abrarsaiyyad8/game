#!/bin/bash


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
usermod -aG docker ubuntu

# install aws-cliv2

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