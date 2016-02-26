#!/bin/bash

source ../common.sh
source ./configure.sh

if [ -d ${DFS_DN_DIR} ]
then
	get_install_option "REMOVE_EXISTING_DFS" "y|n" "Do you want to remove existing DFS folder: ${DFS_DN_DIR}? ([n]|y) (timeout 30):" "n" 30
	if [ $REMOVE_EXISTING_DFS == "yes" ] || [ $REMOVE_EXISTING_DFS == "y" ]
	then
		sudo rm -rf ${DFS_DN_DIR}
	else
		sudo chown -R ${HADOOP_USER}:${HADOOP_USER} ${DFS_DN_DIR}
		show_error "You choose to keep existing DFS folder. EXIT." && exit 0
	fi
fi

sudo mkdir -p ${DFS_DN_DIR}
show_progress "${DFS_DN_DIR} is created successfully."
sudo chown -R ${HADOOP_USER}:${HADOOP_USER} ${DFS_DN_DIR}


