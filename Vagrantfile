# -*- mode: ruby -*-
# vi: set ft=ruby :

vms = {
  'balancer' => {'memory' => '256', 'cpus' => 1, 'ip' => '200'},
  'master3' => {'memory' => '2048', 'cpus' => 2, 'ip' => '30'},
  'master2' => {'memory' => '2048', 'cpus' => 2, 'ip' => '20'},
  'master1' => {'memory' => '2048', 'cpus' => 2, 'ip' => '10'}
}

Vagrant.configure("2") do |config|
# config.vm.box = "bento/ubuntu-16.04"
# config.vm.box = "centos/7"
  config.vm.box = "debian/stretch64"
  config.vm.box_version = "9.12.0"
  config.vm.box_check_update = false
  
  vms.each do |name, conf,i|
    config.vm.define "#{name}" do |k|
      k.vm.hostname = "#{name}.k8s.cluster"
      k.vm.network 'private_network', ip: "172.27.11.#{conf['ip']}"
      k.vm.provider 'virtualbox' do |vb|
        vb.memory = conf['memory']
        vb.cpus = conf['cpus']
      end
      k.vm.provision "shell", path: "./PuppetServer/#{name}.sh"
      end   
    end
  end
