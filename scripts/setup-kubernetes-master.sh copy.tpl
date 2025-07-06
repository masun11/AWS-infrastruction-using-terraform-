#Run the following command on the master node to allow Kubernetes to fetch the required images before cluster initialization:

sudo kubeadm config images pull

#Initialize the cluster

#sudo kubeadm init --pod-network-cidr=10.244.0.0/16

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem

#The initialization may take a few moments to finish. Expect an output similar to the following:

#Your Kubernetes control-plane has initialized successfully!
#To start using your cluster, you need to run the following as a regular user:

#root : visudo 

#su - devopsadmin 
USERNAME="devopsadmin"

useradd $USERNAME -s /bin/bash -m -d /home/$USERNAME

# Set password 
echo "$USERNAME:${devopsuser_pass}" | chpasswd

# Add to sudo group
usermod -aG sudo $USERNAME

# Add to sudo group
usermod -aG docker $USERNAME

# Enable passwordless sudo
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME
chmod 440 /etc/sudoers.d/$USERNAME


mkdir -p /home/$USERNAME/.kube
cp -i /etc/kubernetes/admin.conf /home/$USERNAME/.kube/config
chown $USERNAME:$USERNAME /home/$USERNAME/.kube/config

#Deploy a pod network to our cluster. This is required to interconnect the different Kubernetes components.

# kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
# Run as $USERNAME
sudo -u $USERNAME kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml


