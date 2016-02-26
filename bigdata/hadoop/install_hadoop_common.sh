#!/bin/bash

pushd .
HADOOP_SCRIPT_FOLDER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source "$HADOOP_SCRIPT_FOLDER/../common.sh"
source "$HADOOP_SCRIPT_FOLDER/configure.sh"


yum list installed | grep $JDK_PACKAGE
if [ ! $? == 0 ]
then
	show_progress "java is not avaiable, start to install $JDK_PACKAGE"
	sudo yum -y install $JDK_PACKAGE
	show_progress "$JDK_PACKAGE is installed successfully"
else
	show_progress "$JDK_PACKAGE is installed. SKIP"	
fi

sudo sed -i "/export JAVA_HOME=/d" /etc/bashrc
append_to_file_once /etc/bashrc "export JAVA_HOME=$JAVA_HOME"
append_to_file_once /etc/bashrc	"export PATH=\$PATH:\$JAVA_HOME/bin"

source ~/.bashrc

# in case any of the bash startup file change the current folder
cd ${HADOOP_SCRIPT_FOLDER}

# in case there are some invalid setting in /etc/bashrc or /etc/profile (/etc/profile.d/x.sh)
# set these environment defined in ./configured.sh. re-run it to make sure the setting in
# configure.sh will always be used
source "${HADOOP_SCRIPT_FOLDER}/configure.sh"

id ${HADOOP_USER}
if [ ! $? == 0 ]
then
	show_progress "create user ${HADOOP_USER}"
	sudo useradd -m ${HADOOP_USER}
else
	show_progress "User ${HADOOP_USER} already exist. SKIP"
fi

if [[ "${ENABLE_HADOOP_USER_SUDO}" == "yes" ]]
then
	sudo -l -U ${HADOOP_USER} | grep "User ${HADOOP_USER} is not allowed to run sudo on" > /dev/null
	if [ $? == 0 ]
	then
		echo "${HADOOP_USER}  ALL=(ALL)       ALL" | sudo -i tee -a /etc/sudoers
	fi
fi

if [ ! -d ${HADOOP_ROOT} ]
then
	sudo mkdir ${HADOOP_ROOT}
fi

cd ${HADOOP_ROOT}
if [ -f hadoop-${HADOOP_VERSION}.tar.gz ]
then
	# todo: check the tar file is good
	#sudo tar -tzf hadoop-${HADOOP_VERSION}.tar.gz >/dev/null 
    echo ""
	if [ ! $? == 0 ]
	then
		sudo wget http://apache.arvixe.com/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz		
		sudo chown ${HADOOP_USER}:${HADOOP_USER} hadoop-${HADOOP_VERSION}.tar.gz
	else
		show_progress "hadoop-${HADOOP_VERSION}.tar.gz has been downloaded already. SKIP"
	fi
	
else
    show_progress "Local ${HADOOP_ROOT}/hadoop-${HADOOP_VERSION}.tar.gz does not exist. Download..."
	sudo wget http://apache.arvixe.com/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
fi

if [ -d ${HADOOP_HOME} ]
then
	get_install_option "REMOVE_EXISTING_HADOOP" "y|n" "Do you want to remove folder: ${HADOOP_HOME}? (y|[n]) (timeout 60s):" "n" 60
	if [ $REMOVE_EXISTING_HADOOP == "yes" ] || [ $REMOVE_EXISTING_HADOOP == "y" ]
	then
        show_progress "Remove folder ${HADOOP_HOME}"
		sudo rm -rf ${HADOOP_HOME}
		# The following should be done in node specific script
		#if [ -d ${DFS_NN_DIR} ]
		#then
		#	sudo rm -rf ${DFS_NN_DIR}
		#fi
		#
		#if [ -d ${DFS_DN_DIR} ]
		#then
		#	sudo rm -rf ${DFS_DN_DIR}
		#fi
		#sudo mkdir -p ${DFS_NN_DIR}
		#sudo mkdir -p ${DFS_DN_DIR}
		#sudo chown -R ${HADOOP_USER}:${HADOOP_USER} ${DFS_NN_DIR}
		#sudo chown -R ${HADOOP_USER}:${HADOOP_USER} ${DFS_DN_DIR}
	else
		show_error "${HADOOP_HOME} already exist, and you choose not to install a new one. EXIT."
		exit
	fi
fi

if [ ! -f /etc/profile.d/hadoop.sh ]
then
	sudo touch /etc/profile.d/hadoop.sh
fi
sudo sed -i "/export HADOOP_ROOT=/d" /etc/profile.d/hadoop.sh
sudo sed -i "/export HADOOP_USER=/d" /etc/profile.d/hadoop.sh
append_to_file_once /etc/profile.d/hadoop.sh "export JAVA_HOME=${JAVA_HOME}"
append_to_file_once /etc/profile.d/hadoop.sh "export HADOOP_HOME=${HADOOP_ROOT}/hadoop"
append_to_file_once /etc/profile.d/hadoop.sh "export HADOOP_USER=${HADOOP_USER}"
append_to_file_once /etc/profile.d/hadoop.sh "export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin"


show_progress "Untar hadoop-${HADOOP_VERSION}.tar.gz to ${HADOOP_HOME}"
cd ${HADOOP_ROOT}
sudo tar -xzvf hadoop-${HADOOP_VERSION}.tar.gz > /dev/null
sudo ln -sf "${HADOOP_HOME}" "hadoop"
sudo chown -R ${HADOOP_USER}:${HADOOP_USER} ${HADOOP_ROOT}

show_progress "Copy hadoop config files"
${HADOOP_SCRIPT_FOLDER}/copy_hadoop_config.sh

echo -e "\e[32m"
echo "-----------------------------------------------------------------------------------------------------"
echo "- Congratulations. Your hadoop common parts have been installed successfully.                       -" 
echo "-                                                                                                   -"
echo "- The next step(s):                                                                                 -"
echo "-     You may need to run 'source /etc/profile.d/hadoop.sh' to enable newly set environment variable-"
echo "-     You need run node type specific installation script to complete the installation              -"
echo "-     Login to name node as ${HADOOP_USER} and:                                                     -"
echo "-         1). Run "hdfs namenode -format" to format DFS                                             -"
echo "-         2). Run "start-dfs.sh" to start dfs                                                       -"
echo "-     Login to resource manager as ${HADOOP_USER} and run "start-yarn.sh" start yarn                -"
echo "-----------------------------------------------------------------------------------------------------"
echo -e "\e[0m"

popd
