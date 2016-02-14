#!/bin/bash 

INSTALL_POSTGIS=no
INSTALL_POSTMAN=no

source ./common.sh

cd /tmp

# Note:  this installation is for centOS6.x
yum -C repolist | grep -E "^epel" > /dev/null
if [ $? -ne 0 ]
then
	wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
	sudo rpm -ivh epel-release-6-8.noarch.rpm
fi

yum -C repolist | grep -E "^pgdg94" > /dev/null
if [ $? -ne 0 ]
then
	show_progress "Download & install pgdb94 yum repository" 
	wget http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-2.noarch.rpm
	sudo rpm -ivh pgdg-centos94-9.4-2.noarch.rpm
fi

show_progress "Install postgresql94"
sudo yum install postgresql94 postgresql94-server postgresql94-libs postgresql94-contrib postgresql94-devel
if [ ! $INSTALL_POSTGIS  == 'no' ]
then
	show_progress "Install postgis2_94"
	sudo yum install postgis2_94
fi

if [ ! $INSTALL_POSTMAN == 'no' ]
then
	show_progress "Install pg_partman94"
	sudo yum install pg_partman94
fi

sudo ls /var/lib/pgsql/9.4/data > /dev/null
if [ $? -ne 0 ]
then
	show_progress "Init db"
	sudo service postgresql-9.4 initdb
fi

# edit /var/lib/pgsql/9.4/data/postgresql.conf and /var/lib/pgsql/9.4/data/pg_hba.conf

show_progress "Change postgresql-9.4 to auto startup"
sudo chkconfig postgresql-9.4 on

show_progress "Shutdown iptables"
sudo service iptables stop
sudo service ip6tables stop

sudo chkconfig iptables off
sudo chkconfig ip6tables off


echo -e "\e[32m"
echo "-----------------------------------------------------------------------------------------------------"
echo "- Congratulations. Your postgresql9.4 have been installed successfully.                       	  -"
echo "-                                                                                                   -"
echo "- The next step(s):                                                                                 -"
echo "-     1) edit pg_hba.conf according to your environment                                             -"
echo "-     2) run 'service postgresql-9.4 start' to start up postgresql service                          -"
echo "-----------------------------------------------------------------------------------------------------"
echo -e "\e[0m"
#service postgresql-9.4 start

