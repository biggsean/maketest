#!/bin/bash

echo "Installing Ansible"
sudo yum install -y epel-release
sudo yum install -y ansible
ansible-playbook -i /vagrant/ansible/vagrant-inventory /vagrant/ansible/cd.yml
