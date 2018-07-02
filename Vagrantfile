# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.synced_folder ".", "/vagrant", type: "nfs"
  config.vm.synced_folder File.expand_path("~/.aws"), "/home/vagrant/.aws", type: "nfs"
  config.vm.define "cd" do |d|
    d.vm.box = "ubuntu/trusty64"
    d.vm.hostname = "cd"
    d.vm.network "private_network", ip: "10.20.30.40"
    #d.vm.provision :shell, path: "bootstrap.sh"
    d.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]            
      v.memory = 2048
    end
  end
#  if Vagrant.has_plugin?("vagrant-cachier")
#    config.cache.scope = :box
#    config.cache.synced_folder_opts = {
#      type: :nfs
#    }
#  end
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
    config.vbguest.no_install = true
    config.vbguest.no_remote = true
  end
end
