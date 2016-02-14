#!/bin/bash

HADOOP_COPY_CONF_SCRIPT_FOLDER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
#echo "The script folder is: ${HADOOP_COPY_CONF_SCRIPT_FOLDER}"
cd ${HADOOP_COPY_CONF_SCRIPT_FOLDER} 

source ${HADOOP_COPY_CONF_SCRIPT_FOLDER}/../common.sh
source ${HADOOP_COPY_CONF_SCRIPT_FOLDER}/configure.sh

cd conf
show_progress "Update conf and copy it to ${HADOOP_HOME}/etc/hadoop/"

rm -f hdfs-site.xml mapred-site.xml core-site.xml yarn-site.xml

cp core-site.xml.template core-site.xml
sed -i s/{HADOOP_NN_HOST}/${HADOOP_NN_HOST}/g core-site.xml
sed -i s/{HADOOP_USER}/${HADOOP_USER}/g core-site.xml

cp mapred-site.xml.template mapred-site.xml
sed -i s/{HADOOP_JHS_HOST}/${HADOOP_JHS_HOST}/g mapred-site.xml

cp yarn-site.xml.template yarn-site.xml
sed -i s/{HADOOP_RM_HOST}/${HADOOP_RM_HOST}/g yarn-site.xml
sed -i s/{HADOOP_JHS_HOST}/${HADOOP_JHS_HOST}/g yarn-site.xml

cp hdfs-site.xml.template hdfs-site.xml
sed -i "s|{DFS_NN_DIR}|$DFS_NN_DIR|g" hdfs-site.xml
sed -i "s|{DFS_DN_DIR}|${DFS_DN_DIR}|g" hdfs-site.xml
sed -i s/{HADOOP_USER}/${HADOOP_USER}/g hdfs-site.xml
sed -i s/{DFS_REP_FACTOR}/${DFS_REP_FACTOR}/g hdfs-site.xml

sudo cp *.xml ${HADOOP_HOME}/etc/hadoop/
sudo cp slaves ${HADOOP_HOME}/etc/hadoop/
sudo chown -R ${HADOOP_USER}:${HADOOP_USER} ${HADOOP_HOME}/etc/hadoop/
