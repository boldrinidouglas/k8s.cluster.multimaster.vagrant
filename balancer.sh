#!/bin/bash
# Cluster Multi-Master com K8s usando Vagrant - BALANCER
# Script por Douglas Boldrini
# Fonte de estudos e pesquisas: 4Linux Blogs - https://blog.4linux.com.br/kubernetes-configurando-um-cluster-multi-master/
# Pre-Requisitos: VirtualBox Instalado com vboxguests configurado | Vagrant Instalado
#============================================================================================================
#====================================== Configurando o Load Balancer ========================================
#============================================================================================================
# Instalando os pacotes do HAProxy:
echo " Instalando os pacotes do HAProxy "
sudo apt-get update -yqq
sudo apt-get install -yqq haproxy

#Pronto! Vamos configurá-lo – para simplificar faremos em um único comando:
echo " Configurando o arquivo haproxy.cfg "
sudo cat > /etc/haproxy/haproxy.cfg <<EOF
global
    user haproxy
    group haproxy

defaults
    mode http
    log global
    retries 2
    timeout connect 3000ms
    timeout server 5000ms
    timeout client 5000ms

frontend kubernetes
    bind 172.27.11.200:6443
    option tcplog
    mode tcp
    default_backend kubernetes-master-nodes

backend kubernetes-master-nodes
    mode tcp
    balance roundrobin
    option tcp-check
    server k8s-master-0 172.27.11.10:6443 check fall 3 rise 2
    server k8s-master-1 172.27.11.20:6443 check fall 3 rise 2
    server k8s-master-2 172.27.11.30:6443 check fall 3 rise 2
EOF

echo " Reiniciando os Serviços do HAPROXY "
sudo systemctl restart haproxy 
sudo systemctl status haproxy 


echo " Verificando se a porta está exposta "
sudo ss -nltp | grep 6443