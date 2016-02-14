#!/bin/bash

echo "------------Init VM: isntall necessary packages and setup enviornment for vagrant user------------"

# Make sure this script can be run multiple times without side effect
sudo yum -y install vim htop man mlocate python-devel 
sudo pip install fabric

git --version
if [ $? -ne 0 ]
then
	yum -y install git
fi

if [ ! -d /home/vagrant/github  ]
then
	mkdir -p /home/vagrant/github
fi

cd /home/vagrant/github/
if [ ! -d /home/vagrant/github/study ]
then
	git clone https://github.com/tatumsu/study.git
fi

sudo chown -R vagrant:vagrant /home/vagrant/

cat /etc/vimrc | grep "color desert" || echo "color desert" | sudo tee -a /etc/vimrc
cat /etc/vimrc | grep "set tabstop=4" || echo "set tabstop-4" | sudo tee -a /etc/vimrc
cat /home/vagrant/.bashrc | grep "export VM_SETUP=" || echo "export VM_SETUP=/home/vagrant/github/study/resource/vm-setup" >> /home/vagrant/.bashrc
