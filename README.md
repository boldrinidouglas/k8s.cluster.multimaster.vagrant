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
```#vagrant up```

## Acessando o ambiente:
Para acessar cada master entre com o comando: 
```#vagrant ssh-config```

### Resultado:
``` 
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
```

### Para acessar o balancer
```ssh -i IdentityFile /home/douglas/k8s-cluster/.vagrant/machines/balancer/virtualbox/private_key vagrant@127.0.0.1 -p2222```
### Para acessar o master1
```ssh -i IdentityFile /home/douglas/k8s-cluster/.vagrant/machines/balancer/virtualbox/private_key vagrant@127.0.0.1 -p2220```
### Para acessar o master2
```ssh -i IdentityFile /home/douglas/k8s-cluster/.vagrant/machines/balancer/virtualbox/private_key vagrant@127.0.0.1 -p2201```
### Para acessar o master3
```ssh -i IdentityFile /home/douglas/k8s-cluster/.vagrant/machines/balancer/virtualbox/private_key vagrant@127.0.0.1 -p2202```

# Pós Instalação
No meio do provisionamento, o K8s foi instalado, geradondo um token de acesso. Procure algo parecido com isso:
```
kubeadm join 172.27.11.200:6443 --token 6o9xp8.88ad2pstfd3h77fj \
    --discovery-token-ca-cert-hash sha256:eafa5758a4b8e230739e05b04ec7043205ace1a5038ae6e48e9d8c6f23f4c99f \
    --control-plane --certificate-key 6cfd7416e3cb9bf4227132d9c65ed347e79dd56b2391f960dec4b667dcf793d1  
```
Copie e cole, acrescentando no final do comando (--apiserver-advertise-address=172.27.11.20 no master2) no master2 e (--apiserver-advertise-address=172.27.11.30) master3. No exemplo a baixo foi feito no master2:

``` 
kubeadm join 172.27.11.200:6443 --token 6o9xp8.88ad2pstfd3h77fj \
    --discovery-token-ca-cert-hash sha256:eafa5758a4b8e230739e05b04ec7043205ace1a5038ae6e48e9d8c6f23f4c99f \
    --control-plane --certificate-key 6cfd7416e3cb9bf4227132d9c65ed347e79dd56b2391f960dec4b667dcf793d1  --apiserver-advertise-address=172.27.11.20
```
Acesse o seu master1 e entre com o comando:
``` kubctl get node
#Deverá aparecer algo semelhante:
NAME     STATUS    ROLES   AGE    VERSION
master1  Ready     master  4m51s  v1.16.1
master2  Ready     master  4m51s  v1.16.1
master3  Ready     master  4m51s  v1.16.1
```
