#!/bin/bash
ssh-keygen -t rsa -b 4096 -C "ramshankar.mca08@gmail.com"
apt update && apt install -y docker.io apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

apt update && apt install -y kubelet kubeadm kubectl

kubeadm init --pod-network-cidr=192.168.0.0/16

mkdir -p $HOME/.kube
cp /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
