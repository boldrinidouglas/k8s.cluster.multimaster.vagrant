# k8s.cluster.vagrant
Cluster K8s Multi-Master com HAProxy no Vagrant

## Introdução
A ideia aqui é oferecer uma experiência rápida e prática de DevOps com a criação de um cluster multi-master K8s utilizando Vagrant. Através dele tentaremos simplificar a gerência de configuração de software das virtualizações para aumentar a produtividade do desenvolvimento.

## Pre-requisitos
* [Vagrant](https://www.vagrantup.com/downloads.html) Instalado
* VirtualBox (para este exemplo utilizei ele, porém poderá utilizar além do VirtualBox outros providers como: KVM, Hyper-V, Docker containers, VMware, e AWS.
* Máquina com pelo menos 8 GB e Processador com no mímimo 4 cores.

## Instalação
1. Crie um diretorio e copie os arquivos lá para dentro (master1, master2, master3 e o Vagrantfile). 
2. Após isso entre com os comandos a seguir:
...
vagrant up
...

## Acessando o ambiente:
Para acessar cada master entre com o comando:

vagrant ssh-config
Resposta: 
root@SBS-COL-SUP-003:/home/douglas/k8s-cluster# vagrant ssh-config
Host balancer
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/douglas/k8s-cluster/.vagrant/machines/balancer/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL

Host master3
  HostName 127.0.0.1
  User vagrant
  Port 2202
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/douglas/k8s-cluster/.vagrant/machines/master3/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL

Host master2
  HostName 127.0.0.1
  User vagrant
  Port 2201
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/douglas/k8s-cluster/.vagrant/machines/master2/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL

Host master1
  HostName 127.0.0.1
  User vagrant
  Port 2200
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/douglas/k8s-cluster/.vagrant/machines/master1/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL

