#!/bin/bash
set -e

# Install dependencies
apt-get update -y && apt-get install -y apt-transport-https curl containerd

# Configure containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

# Install Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm
apt-mark hold kubelet kubeadm

# Disable swap
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# You will need to SSH into the worker and run the join command after deployment.
