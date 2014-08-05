# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/trusty64"
  config.ssh.forward_agent = true

  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
  end  

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "vagrant/manifests"
    puppet.manifest_file  = "main.pp"
    puppet.module_path    = "vagrant/modules"
  end
end
