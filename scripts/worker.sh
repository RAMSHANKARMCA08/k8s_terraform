#!/bin/bash
sudo apt update && apt install -y docker.io apt-transport-https curl

sudo mkdir -p /etc/apt/keyrings
# Download the GPG key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key \
  | gpg --dearmor \
  | sudo tee /etc/apt/keyrings/kubernetes-apt-keyring.gpg > /dev/null

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list


sudo apt update && sudo apt upgrade -y
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo ssh-keygen -t rsa -b 2048 -f ~/.ssh