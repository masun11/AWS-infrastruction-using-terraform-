#!/bin/bash
sudo apt-get update -y

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

#Install Docker :

sudo apt-get install docker.io -y

#Step 1. Install containerd			Is a CRI 
#To install containerd, follow these steps on both VMs:

#Load the br_netfilter module required for networking.

sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

#To allow iptables to see bridged traffic, as required by Kubernetes, we need to set the values of certain fields to 1.

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

#Apply the new settings without restarting.

sudo sysctl --system

#Install curl.

sudo apt install curl -y	

#Get the apt-key and then add the repository from which we will install containerd.

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#Update and then install the containerd package.

sudo apt update -y 
sudo apt install -y containerd.io

#Set up the default configuration file.

sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

#Next up, we need to modify the containerd configuration file and ensure that the cgroupDriver is set to systemd. To do so, #edit the following file:

#sudo vi /etc/containerd/config.toml

#Scroll down to the following section:

#[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
#And ensure that value of SystemdCgroup is set to true Make sure the contents of your section match the following:

#[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
#    BinaryName = ""
#    CriuImagePath = ""
#    CriuPath = ""
#    CriuWorkPath = ""
#    IoGid = 0
#    IoUid = 0
#    NoNewKeyring = false
#    NoPivotRoot = false
#    Root = ""
#    ShimCgroup = ""
##    SystemdCgroup = true

FILE="/etc/containerd/config.toml"
BACKUP="/etc/containerd/config.toml.bak"

# Backup first
sudo cp "$FILE" "$BACKUP"

# Replace or insert SystemdCgroup = true inside the correct section
sudo awk '
BEGIN { in_section=0; done=0 }
/\[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options\]/ {
    print
    in_section=1
    next
}
in_section && /^\[/ {
    if (!done) {
        print "    SystemdCgroup = true"
        done=1
    }
    in_section=0
}
in_section && $1 == "SystemdCgroup" {
    print "    SystemdCgroup = true"
    done=1
    next
}
{ print }
END {
    if (in_section && !done) {
        print "    SystemdCgroup = true"
    }
}
' "$FILE" | sudo tee "$FILE" > /dev/null

echo "✅ Forced SystemdCgroup = true in the correct section"

 

#Finally, to apply these changes, we need to restart containerd.

sudo systemctl restart containerd
sudo systemctl status containerd


#Step 2. Install Kubernetes
#With our container runtime installed and configured, we are ready to install Kubernetes.

#Add the repository key and the repository.

sudo apt-get update -y

# apt-transport-https may be a dummy package; if so, you can skip that package

sudo apt-get install -y apt-transport-https ca-certificates curl gpg


# If the directory `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
#mkdir /etc/apt/keyrings

sudo mkdir -p -m 755 /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y

sudo apt-get install -y kubelet kubeadm kubectl

#Finally, enable the kubelet service on both systems so we can start it.

sudo systemctl enable kubelet