#!/bin/bash

sudo yum -y install epel-release
sudo yum -y install nginx

# configure firewall to enable http/https access
sudo firewall-cmd --permanent --zone=public --add-service=http 
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload
sudo systemctl enable nginx
sudo service nginx start


#----------------------Begin install mariadb (opensource mysql branch)------------------------#
sudo yum install mariadb-server
sudo systemctl start mariadb
sudo /usr/bin/mysql_secure_installation
sudo systemctl enable mariadb

#-------------------------------------Begin install PHP---------------------------------------#
sudo yum install php-fpm php-mysql
sudo systemctl start php-fpm
sudo systemctl enable php-fpm

sudo mkdir /var/lib/php/session/
sudo chown -R apache:apache /var/lib/php/session/

cat "
server {
    listen 8000;
    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \.php$ {
        root           /usr/share/php;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}" | sudo tee /etc/nginx/conf.d/php.conf

# disable selinux. this need to be tuned
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sudo setenforce 0

