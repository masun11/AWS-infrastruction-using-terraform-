#!/bin/bash

set -e
exec > /var/log/setup-kubernetes-master.log 2>&1

echo "[STEP 1] Initialize Kubernetes master"
sudo kubeadm config images pull
sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --ignore-preflight-errors=NumCPU,Mem \
  | tee /var/log/kubeadm-init-output.log

echo "[STEP 2] Create devopsadmin user"
USERNAME="devopsadmin"
useradd $USERNAME -s /bin/bash -m -d /home/$USERNAME || true
echo "$USERNAME:${devopsuser_pass}" | chpasswd
usermod -aG sudo $USERNAME
usermod -aG docker $USERNAME
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/$USERNAME
chmod 440 /etc/sudoers.d/$USERNAME

echo "[STEP 3] Setup kubeconfig for devopsadmin"
mkdir -p /home/$USERNAME/.kube
cp -i /etc/kubernetes/admin.conf /home/$USERNAME/.kube/config
chown $USERNAME:$USERNAME /home/$USERNAME/.kube/config

echo "[STEP 4] Apply Flannel CNI"
sudo -u $USERNAME kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
