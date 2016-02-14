#!/bin/bash

set -e

export NGINX_VERSION=1.8.0

show_progress()
{
  echo -e "\e[32m******************$1******************\e[0m"
}

if [ ! -d ~/software ]
then
    mkdir ~/software
fi

show_progress "Install required library pcre, zlib and openssl"
{
    sudo yum -y install pcre pcre-devel zlib zlib-devel openssl openssl-devel
}

show_progress "Download nginx tar file"
{
    cd ~/software
    if [ ! -f nginx-${NGINX_VERSION}.tar.gz ]
    then
        wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
    fi
    tar -xzvf nginx-${NGINX_VERSION}.tar.gz
}

show_progress "Confiugre, make and install nginx"
{
    cd nginx-${NGINX_VERSION}
    ./configure
    make
    sudo make install
}
show_progress "Nginx is installed successfully"

show_progress "Setup nginx as service"
sudo cp nginx /etc/init.d/
sudo chown root:root /etc/init.d/nginx
sudo chmod 0755 /etc/init.d/nginx
sudo chkconfig --add nginx
sudo chkconfig --level 2345 nginx on

show_progress "start up nginx service"
sudo service nginx start

show_progress "Add nginx to PATH"
{
    cat /etc/bashrc | grep "PATH=\$PATH:/usr/local/nginx/sbin"
    if [ $? == 0 ]
    then
        echo "/usr/local/nginx/sbin is already in path, SKIP"
    else
        echo 'export PATH=$PATH:/usr/local/nginx/sbin:/usr/local/nginx/bin' | sudo tee -a /etc/bashrc
    fi
}
source /etc/bashrc

show_progress "Your NGINX server has been installed successfully"



