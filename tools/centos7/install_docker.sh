#!/bin/bash

source ./common.sh

vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2) # ver1 is an array such as (3 2 1)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})) # 10#${ver1[i]} represents the number's base is 10
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

show_progress 'Check OS version'
vercomp $(uname -r | cut -d '-' -f 1) 3.10.0
if [ $? == 2 ];then
	show_error 'Only CentOS 7 and above is supported'
	exit 1
fi

show_progress 'Update system to latest'
sudo yum -y update

show_progress 'Enable docker repository'
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

show_progress 'Install docker-engine'
sudo yum -y install docker-engine

show_progress 'Enable docker service when startup'
sudo chkconfig docker on

show_progress 'Startup docker'
sudo service docker start

show_progress 'Create docker group and add vagrant as member'
sudo usermod -aG docker vagrant

show_progress 'Verify docker installation by running hello-world'
sudo docker run hello-world


