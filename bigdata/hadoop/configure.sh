#!/bin/bash

JDK_PACKAGE=java-1.8.0-openjdk-devel
JAVA_HOME=/usr/lib/jvm/java-openjdk/

HADOOP_ROOT=/opt/hadoop
HADOOP_VERSION=2.7.1
HADOOP_HOME=${HADOOP_ROOT}/hadoop-${HADOOP_VERSION}

HADOOP_USER=hadoop

# A switch which determines whether ${HADOOP_USER} will has sudo privilege
ENABLE_HADOOP_USER_SUDO=no

# HDFS name node data folder
DFS_NN_DIR=/hadoop/dfs/name

# HDFS data node data folder
DFS_DN_DIR=/hadoop/dfs/data

# HDFS replicate factor, for single box installation, this should be 1
DFS_REP_FACTOR=1

# Host name of the single hadoop box
HOST_NAME="vm.hadoop.local"

# IP of the single hadoop box
HOST_IP="192.168.241.245"

# A flag which indicates whether HOST_SETTING is append to /etc/hosts
# Set this to false if the Hadoop box is already configured in DNS
SETUP_HOST='y'



#-------Items below this probably does not need to be changed if all hadoop components are installed in a single box------#

# Hostname of Name Node
HADOOP_NN_HOST=$HOST_NAME

# Hostname of Job History Server
HADOOP_JHS_HOST=$HOST_NAME

# Hostname of Resource Manager
HADOOP_RM_HOST=$HOST_NAME

# Hostname of Date Node1 (note: there could be multiple data nodes)
HADOOP_DN1_HOST=$HOST_NAME

# Hostname of Oozie
HADOOP_OOZIE_HOST=$HOST_NAME

# Host setting append to /etc/hosts. This is mainly used in a dev environment
# This host setting needs to be changed accordingly if the installation is not a single box
HOST_SETTING='''
$HOST_IP $HOST_NAME
'''

CONFIUGRE_SCRIPT_FOLDER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
# Add all data nodes to file "slaves"
> "${CONFIGURE_SCRIPT_FOLDER}/conf/slaves"

echo ${HADOOP_DN1_HOST} >> "${HOST_ALL_IN_SINGLE_BOX_SCRIPT_FOLDER}/conf/slaves"

if [ $SETUP_HOST == 'y' ] || [ $SETUP_HOST == 'yes' ]
then
	setup_host $HOST_SETTING
fi
