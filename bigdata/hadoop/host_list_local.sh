#!/bin/bash

HADOOP_NN_IP="192.168.241.241"
HADOOP_NN_HOST="nn.hadoop.local"

HADOOP_JHS_IP="192.168.241.241"
HADOOP_JHS_HOST="jh.hadoop.local"

HADOOP_RM_IP="192.168.241.242"
HADOOP_RM_HOST="rm.hadoop.local"

# There could be multiple data nodes 
HADOOP_DN1_IP="192.168.241.243"
HADOOP_DN1_HOST="dn1.hadoop.local"

HADOOP_OOZIE_IP="192.168.241.246"
HADOOP_OOZIE_HOST="oozie.hadoop.local"

# Add all data nodes to file "slaves"
HADOOP_HOST_LIST_SCRIPT_FOLDER=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )
> "${HADOOP_HOST_LIST_SCRIPT_FOLDER}/conf/slaves"
echo ${HADOOP_DN1_HOST} >> "${HADOOP_HOST_LIST_SCRIPT_FOLDER}/conf/slaves"

