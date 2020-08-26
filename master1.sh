#!/bin/bash
# Cluster Multi-Master com K8s usando Vagrant - MASTER1
# Script por Douglas Boldrini
# Fonte de estudos e pesquisas: 4Linux Blogs - https://blog.4linux.com.br/kubernetes-configurando-um-cluster-multi-master/
# Pre-Requisitos: VirtualBox Instalado com vboxguests configurado | Vagrant Instalado
#============================================================================================================
#================================ Instalando e Pre-configurando o Master1 ===================================
#============================================================================================================
echo " Instalando Docker, K8s e Binarios "
sudo apt-get update -yqq
sudo apt-get install -yqq apt-transport-https ca-certificates curl gnupg2 software-properties-common vim
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -yqq
sudo apt-get install -yqq docker-ce docker-ce-cli containerd.io kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Desabilitando o swap
echo " Desabilitando o Swap "
sudo sed -Ei 's/(.*swap.*)/#\1/g' /etc/fstab
sudo swapoff -a

# Alterando o cgroupdriver de cgroupfs para systemd (Recomendado)
echo " Alterando o cfroupdrive para systemd "
sudo cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "journald"
}
EOF

echo " Reiniciando o Daemon e o Docker "
sudo systemctl daemon-reload
sudo systemctl restart docker

# Ajuste no serviço do kubelet (responsável por levantar os containers base do cluster 
# pois estamos utilizando o Vagrant e existe mais de uma interface de rede em nossa máquina.
# No Master1
echo " Informando ao Kubelet o ip da interface do MASTER1 "
sudo echo "KUBELET_EXTRA_ARGS='--node-ip=172.27.11.10'" > /etc/default/kubelet
# No Master2
#echo "KUBELET_EXTRA_ARGS='--node-ip=172.27.11.20'" > /etc/default/kubelet
# No Master3
#echo "KUBELET_EXTRA_ARGS='--node-ip=172.27.11.30'" > /etc/default/kubelet


#============================================================================================================
#=================================== Configurando e Subindo MASTER1 =========================================
#============================================================================================================
# populando o primeiro etcd que será a base para os demais, criar um arquivo que indicará onde está o load 
# balancer bem como qual o endereço de rede utilizaremos tanto para a máquina como para os containers.
# Criando o arquivo em /root/kubeadm-config.yml:
echo " Populando o ETCD e informando quem é o LoadBalancer "
sudo cat > /root/kubeadm-config.yml <<EOF
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: stable
controlPlaneEndpoint: "172.27.11.200:6443"
networking:
  podSubnet: "10.244.0.0/16"
---
apiVersion: kubeadm.k8s.io/v1beta2
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: "172.27.11.10"
  bindPort: 6443
EOF

# iniciando o primeiro master do cluster:
echo " Iniciando o primeiro master do cluster "
sudo kubeadm init --config '/root/kubeadm-config.yml' --upload-certs

# Copiando o arquivo de conexão para o usuário root:
echo " Copiando o arquivo de conexão para o user root "
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Configurarmos a rede do master
#echo " Configurando rede do MASTER1 "
#cd /root
#sudo wget https://docs.projectcalico.org/v3.9/manifests/calico.yaml
#sudo sed -i 's?192.168.0.0/16?10.244.0.0/16?g' /root/calico.yaml
#sudo kubectl apply -f /root/calico.yaml
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"