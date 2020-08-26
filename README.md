# k8s.cluster.vagrant
Cluster K8s Multi-Master com HAProxy no Vagrant

# Introdução
A ideia aqui é oferecer uma experiência rápida e prática de DevOps com a criação de um cluster multi-master K8s utilizando Vagrant. Através dele tentaremos simplificar a gerência de configuração de software das virtualizações para aumentar a produtividade do desenvolvimento.

# Pre-requisitos
Vagrant Instalado (https://www.vagrantup.com/downloads.html)
VirtualBox (para este exemplo utilizei ele, porém poderá utilizar além do VirtualBox outros providers como: KVM, Hyper-V, Docker containers, VMware, e AWS.
Máquina com pelo menos 8 GB e Processador com no mímimo 4 cores.

# Instalação
Crie um diretorio e copie os arquivos (master1, master2, master3 e o Vagrantfile)
