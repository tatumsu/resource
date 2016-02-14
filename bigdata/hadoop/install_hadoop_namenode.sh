#!/bin/bash

source ../common.sh
source ./configure.sh

if [ -d ${DFS_NN_DIR} ]
then
	get_install_option "REMOVE_EXISTING_DFS" "y|n" "Do you want to remove existing DFS folder: ${DFS_NN_DIR}? ([n]|y) (timeout 30):" "n" 30
	if [ $REMOVE_EXISTING_DFS == "yes" ] || [ $REMOVE_EXISTING_DFS == "y" ]
	then
		rm -rf ${DFS_NN_DIR}
	else
		sudo chown -R ${HADOOP_USER}:${HADOOP_USER} ${DFS_NN_DIR
		show_error "You choose to keep existing DFS folder. EXIT." && exit 0
	fi
fi

sudo mkdir -p ${DFS_NN_DIR}
show_progress "${DFS_NN_DIR} is created successfully. SKIP"
sudo chown -R ${HADOOP_USER}:${HADOOP_USER} ${DFS_NN_DIR}


