#!/bin/bash

source ./common.sh


wget http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-2.noarch.rpm
rpm -ivh pgdg-centos94-9.4-2.noarch.rpm

wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -ivh epel-release-6-8.noarch.rpm

yum install postgresql94 postgresql94-server postgresql94-libs postgresql94-contrib postgresql94-devel
yum install postgis2_94  pg_partman94
service postgresql-9.4 initdb

# edit /var/lib/pgsql/9.4/data/postgresql.conf and /var/lib/pgsql/9.4/data/pg_hba.conf

chkconfig --list
chkconfig postgresql-9.4 on
service iptables stop
service ip6tables stop

chkconfig iptables off
chkconfig ip6tables off

service postgresql-9.4 start

cat ~/.bashrc | grep '/usr/pgsql-9.4/bin/' || echo 'export PATH=$PATH:/usr/pgsql-9.4/bin/' >> ~/.bashrc
cat ~/.bashrc | grep 'export PGUSER' || echo 'export PGUSER=postgres' >> ~/.bashrc
cat ~/.bashrc | grep 'export PGHOST' || echo 'export PATH=localhost' >> ~/.bashrc

