#!/bin/bash

source ../common.sh

set -e

docker --version 2>/dev/null && show_error "Docker is already installed. Exit." && exit 0

show_progress "Check OS version, only ubuntu 14.04 is supported."
lsb_release -a 2>/dev/null | grep -E "Ubuntu 14.04" ||	(show_error "Only ubuntu 14.04 is supported" && exit 1)

show_progress "Update package information"
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates

show_progress "Add the new GPG key."
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

show_progress "Add dockerproject repo to apt-get source list"
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list

show_progress "Update the APT package index."
sudo apt-get update

show_progress "Purge the old repo lxc-docker if it exists."
sudo apt-get purge lxc-docker


show_progress "Verify that APT is pulling from the right repository."
sudo apt-cache policy docker-engine

show_progress "Install the recommended package: linux-image-extra"
sudo apt-get install linux-image-extra-$(uname -r)


show_progress "Install apparmor if it does not exist yet."
sudo apt-get install apparmor

show_progress "Install docker"
sudo apt-get update
sudo apt-get install -y docker-engine

# show_progress "Start docker service"
# sudo service docker start

show_progress "Verify docker is installed correctly."
sudo docker run hello-world

show_progress "Install docker-compose."
docker_compose_installed=yes
docker_compose --version || docker_compose_installed=no 
if [ $docker_compose_installed == "no" ]
then
	curl -L https://github.com/docker/compose/releases/download/1.7.0-rc1/docker-compose-`uname -s`-`uname -m` | tee /usr/local/bin/docker-compose > /dev/null
	sudo chmod +x /usr/local/bin/docker-compose
fi



