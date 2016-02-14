#!/bin/bash

SETUP_HOST_SCRIPT_FOLDER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source "${SETUP_HOST_SCRIPT_FOLDER}/../common.sh"
source "${SETUP_HOST_SCRIPT_FOLDER}/configure.sh"


setup_host ${HADOOP_NN_IP} ${HADOOP_NN_HOST} ${HADOOP_JHS_HOST}
setup_host ${HADOOP_RM_IP} ${HADOOP_RM_HOST}
setup_host ${HADOOP_DN1_IP} ${HADOOP_DN1_HOST}
setup_host ${HADOOP_OOZIE_IP} ${HADOOP_OOZIE_HOST}

