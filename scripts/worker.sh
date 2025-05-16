#!/bin/bash
apt update && apt install -y docker.io apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

apt update && apt install -y kubelet kubeadm kubectl

ssh-keygen -t rsa -b 2048 -f ~/.ssh