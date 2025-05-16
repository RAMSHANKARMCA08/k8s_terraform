#!/bin/bash
sudo apt update && apt install -y docker.io apt-transport-https curl

sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update && apt install -y kubelet kubeadm kubectl

sudo ssh-keygen -t rsa -b 2048 -f ~/.ssh