#!/bin/bash
HELM_VERSION="3.4.1-1"
KOMPOSE_VERSION="v1.22.0"

# Initialize Kubernetes
echo "[***TASK 1***] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=172.42.42.100 --pod-network-cidr=192.168.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Copy Kube admin config
echo "[***TASK 2***] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy flannel network
echo "[***TASK 3***] Deploy Calico network"
su - vagrant -c "kubectl create -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml"

# Generate Cluster join command
echo "[***TASK 4***] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh

# Start and run docker registry
echo "[***TASK 4 START REGISTRY***]"
docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name my_registry \
  -v /mnt/registry:/var/lib/registry \
  registry:2

# Install helm
echo "[***TASK 5 INSTALL HELM***]"
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update
apt-get install helm=$HELM_VERSION

# Install kompose
echo "[***TASK 6 INSTALL KOMPOSE]"
curl -L https://github.com/kubernetes/kompose/releases/download/$KOMPOSE_VERSION/kompose-linux-amd64 -o kompose
chmod +x kompose
sudo mv ./kompose /usr/local/bin/kompose

