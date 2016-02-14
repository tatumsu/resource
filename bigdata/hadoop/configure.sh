#!/bin/bash

JDK_PACKAGE=java-1.8.0-openjdk-devel
JAVA_HOME=/usr/lib/jvm/java-openjdk/

HADOOP_ROOT=/opt/hadoop
HADOOP_VERSION=2.7.1
HADOOP_HOME=${HADOOP_ROOT}/hadoop-${HADOOP_VERSION}

HADOOP_USER=hadoop
# A switch which determines whether ${HADOOP_USER} will has sudo privilege
ENABLE_HADOOP_USER_SUDO=no

DFS_NN_DIR=/hadoop/dfs/name
DFS_DN_DIR=/hadoop/dfs/data
DFS_REP_FACTOR=1

# A switch which determine whether to setup IP-->hostname mapping in /etc/hosts
# In a environment with DNS server setup, you probably better to set this to no
SETUP_HOST=yes

# Update this setting to use the correct host list.
# Make sure the host list file contains correct hostname and ip
HOST_LIST_FILE=host_list_local.sh

# A switch which determine whether to setup IP-->hostname mapping in /etc/hosts
# In a environment with DNS server setup, you probably better to set this to no
SETUP_HOST=yes

# host name and ip configuration
# ip is used in a local/dev environment where a central dns may not be avaialble
# and the ip--host name mapping is added to /etc/hosts
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )/${HOST_LIST_FILE}"
