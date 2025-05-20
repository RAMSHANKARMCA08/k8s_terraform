#!/bin/bash
set -e

# Install dependencies
apt-get update -y && apt-get install -y apt-transport-https curl containerd jq

# Configure containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

# Install Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Disable swap
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Init cluster
kubeadm init --pod-network-cidr=10.244.0.0/16 > /root/kubeadm-init.log

# Configure kubectl
mkdir -p /root/.kube
cp /etc/kubernetes/admin.conf /root/.kube/config

# Install Flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Get join command
kubeadm token create --print-join-command > /join.sh
chmod +x /join.sh
