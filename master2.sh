#!/bin/bash
# Cluster Multi-Master com K8s usando Vagrant - MASTER2
# Script por Douglas Boldrini
# Fonte de estudos e pesquisas: 4Linux Blogs - https://blog.4linux.com.br/kubernetes-configurando-um-cluster-multi-master/
# Pre-Requisitos: VirtualBox Instalado com vboxguests configurado | Vagrant Instalado
#============================================================================================================
#================================ Instalando e Pre-configurando o Master2 ===================================
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
#sudo echo "KUBELET_EXTRA_ARGS='--node-ip=172.27.11.10'" > /etc/default/kubelet
# No Master2
echo " Informando ao Kubelet o ip da interface do MASTER2 "
echo "KUBELET_EXTRA_ARGS='--node-ip=172.27.11.20'" > /etc/default/kubelet
# No Master3
#echo "KUBELET_EXTRA_ARGS='--node-ip=172.27.11.30'" > /etc/default/kubelet

echo " Configurando MASTER3 (Copie o token de acesso informado na intalacao do MASTER1) "
#kubeadm join 172.27.11.200:6443 --token 6o9xp8.88ad2pstfd3h77fj \
#    --discovery-token-ca-cert-hash sha256:eafa5758a4b8e230739e05b04ec7043205ace1a5038ae6e48e9d8c6f23f4c99f \
#    --control-plane --certificate-key 6cfd7416e3cb9bf4227132d9c65ed347e79dd56b2391f960dec4b667dcf793d1  --apiserver-advertise-address=172.27.11.20
