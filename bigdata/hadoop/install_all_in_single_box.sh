#!/bin/bash


if [ -f /etc/profile.d/hadoop.sh ]
then
	sudo rm /etc/profile.d/hadoop.sh
fi

./install_hadoop_common.sh
./install_hadoop_namenode.sh
./install_hadoop_datanode.sh

source ../common.sh
set -e
show_progress "Format DFS"
sudo su hadoop -c "source /etc/profile.d/hadoop.sh && hdfs namenode -format"

show_progress "Start DFS"
sudo su hadoop -c "source /etc/profile.d/hadoop.sh && start-dfs.sh"

show_progress "Start yarn"
sudo su hadoop -c "source /etc/profile.d/hadoop.sh && start-yarn.sh"

show_progress "Start historyserver"
sudo su hadoop -c "source /etc/profile.d/hadoop.sh && mr-jobhistory-daemon.sh start historyserver"



