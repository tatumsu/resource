#!/bin/bash

set -e

pushd .

OOZIE_INSTALL_SCRIPT_FOLDER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
cd ${OOZIE_INSTALL_SCRIPT_FOLDER}
source ${OOZIE_INSTALL_SCRIPT_FOLDER}/../common.sh
source ${OOZIE_INSTALL_SCRIPT_FOLDER}/configure.sh

source ~/.bashrc

show_progress "Oozie installation environment setting"
set | sort | grep -E "OOZIE|HADOOP"

mvn -version > /dev/null 2>&1
if [ $? == 0 ]
then
	EXISTING_MAVEN_VERSION=$(get_version "$(mvn -version | grep "Apache Maven")")
	debug "EXISTING_MAVEN_VERSION=$EXISTING_MAVEN_VERSION"
	EXISTING_MAVEN_VERSION_NUMBER=$(convert_version_to_number ${EXISTING_MAVEN_VERSION})
	debug "EXISTING_MAVEN_VERSION_NUMBER=$EXISTING_MAVEN_VERSION_NUMBER"

	if [ ${EXISTING_MAVEN_VERSION_NUMBER} -lt ${LEAST_MAVEN_VERSION_NUMBER} ]
	then
		show_error "Maven ${LEAST_MAVEN_VERSION} is required but the version ${EXISTING_MAVER_VERSION} is installed. Please uninstall first. EXIT." && exit 1
	else
		show_progress "Detect maven ${EXISTING_MAVEN_VERSION} is already installed. SKIP."
	fi
else
	if [ ! -d "${MAVEN_ROOT}" ]
	then
		show_progress "Create folder ${MAVEN_ROOT}."
		sudo mkdir "${MAVEN_ROOT}"
	fi
	
	cd "${MAVEN_ROOT}"
	if [ ! -f "${MAVEN_TAR_FILE}" ]
	then
		show_progress "Download maven tar file"
		sudo wget "http://mirror.symnds.com/software/Apache/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_TAR_FILE}"
	fi	

	if [ -d "apache-maven-${MAVEN_VERSION}" ]
	then
		get_install_option "REMOVE_EXISTING_MAVEN" "y|n" \
			"Maven folder apache-maven-${MAVEN_VERSION} already exist. Do you want to remove it and reinstall? (y|[n]) (timeout 60s)" "n" 60

		if [ "${REMOVE_EXISTING_MAVEN}" == "y" ]
		then
			show_progress "Remove folder apache-maven-${MAVEN_VERSION}"
			rm -rf apache-maven-${MAVEN_VERSION}
		else
			show_error "Maven folder apache-maven-${MAVEN_VERSION} but you select to keep it. EXIT. " && exit 1
		fi
	fi
	
	show_progress "Untar ${MAVEN_TAR_FILE} to ${pwd}"
	sudo tar xzvf "${MAVEN_TAR_FILE}" > /dev/null
	sudo sed -i "/export M2_HOME=/d" /etc/bashrc
	append_to_file_once /etc/bashrc "export M2_HOME=/opt/maven/apache-maven-${MAVEN_VERSION}"
	append_to_file_once /etc/bashrc "export PATH=\$PATH:\$M2_HOME/bin"
fi

# No matter how is maven installed, always use the specified repository folder
show_progress "Change ${MAVEN_HOME}/conf/settings.xml to set localRepository to ${MAVEN_REPO_FOLDER}"
sudo cp ${OOZIE_INSTALL_SCRIPT_FOLDER}/maven.settings.xml ${MAVEN_HOME}/conf/settings.xml
sudo sed -i "s#{MAVEN_REPO_FOLDER\}#${MAVEN_REPO_FOLDER}#g" "${MAVEN_HOME}/conf/settings.xml"
[ $? != 0 ] && show_error "Failed to chnage maven setting" && exit 1 

#------------------------------------------------------------- BEGIN OF OOZIE ---------------------------------------------------------------------------#
if [ ! -d "${OOZIE_BUILD_FOLDER}" ]
then
	sudo mkdir -p "${OOZIE_BUILD_ROOT}"
fi

cd "${OOZIE_BUILD_ROOT}"
if [ ! -f "${OOZIE_TAR_FILE}" ]
then    
	show_progress "Download oozie tar file to ${OOZIE_BUILD_ROOT}"
    sudo wget "http://apache.arvixe.com/oozie/${OOZIE_VERSION}/oozie-${OOZIE_VERSION}.tar.gz"
fi

# if [ -d "oozie-${OOZIE_VERSION}" ]
# then
#     show_progress "Remove existing folder oozie-${OOZIE_VERSION}"
#     sudo rm -rf oozie-${OOZIE_VERSION}
# else
# 	# The tar file is never untared here, and we have to re-build
# 	OOZIE_SKIP_BUILD=no
# fi

show_progress "Untar ${OOZIE_TAR_FILE} to ${OOZIE_BUILD_ROOT}"
sudo tar xzvf "${OOZIE_TAR_FILE}" > /dev/null

debug "OOZIE_BULD_ROOT=$OOZIE_BUILD_ROOT"
debug "OOZIE_BULD_HOME=$OOZIE_BUILD_HOME"
debug "OOZIE_DIST_FOLDER=$OOZIE_DIST_FOLDER"

OOZIE_SKIP_BUILD=no
if [ -f "${OOZIE_DIST_FOLDER}/oozie-${OOZIE_VERSION}-distro.tar.gz" ]
then
	get_install_option "OOZIE_SKIP_BUILD" "y|n" "${OOZIE_DIST_FOLDER}/oozie-${OOZIE_VERSION}-distro.tar.gz exist, do you want to skip build? ([y]|n)" "y" 30
fi

if [ $OOZIE_SKIP_BUILD == "yes" ] || [ $OOZIE_SKIP_BUILD == "y" ]
then
	# skip build since it take a long time and we know it has been bulid before
	show_progress "You skip oozie build, and keep using the existing build result."
else
	if [ "x${OOZIE_GENERATE_DOC}" == "xno" ] || [ "x${OOZIE_GENERATE_DOC}" == "xn" ]
    then
		show_progress "Update ${OOZIE_BUILD_HOME}/bin/mkdistro.sh to remove -DgenerateDocs from MVN_OPTS"
		sudo sed -i s/-DgenerateDocs//g "${OOZIE_BUILD_HOME}/bin/mkdistro.sh"
	fi

	show_progress "Override oozie pom.xml with customized version."
	sudo cp "${OOZIE_INSTALL_SCRIPT_FOLDER}/oozie.pom.xml" "${OOZIE_BUILD_HOME}/pom.xml"
	
	OOZIE_BUILD_CMD="${OOZIE_BUILD_HOME}/bin/mkdistro.sh -Puber -Phadoop-2 -Dhadoop.version=2.7.1 -DskipTests"
	show_progress "Build oozie: ${OOZIE_BUILD_CMD}"
	sudo -i ${OOZIE_BUILD_CMD}
	show_progress "Oozie is built successfully"
	
	if [ -d "${OOZIE_HOME}" ]
	then
		sudo rm -rf ${OOZIE_HOME}
	fi
fi

show_progress "Copy final build tar file ${OOZIE_DIST_FOLDER}/oozie-${OOZIE_VERSION}-distro.tar.gz to ${OOZIE_ROOT}"
sudo cp -r "${OOZIE_DIST_FOLDER}/oozie-${OOZIE_VERSION}-distro.tar.gz" "${OOZIE_ROOT}"
cd ${OOZIE_ROOT}

show_progress "Untar ${OOZIE_ROOT}/oozie-${OOZIE_VERSION}-distro.tar.gz" > /dev/null
sudo tar xzvf "oozie-${OOZIE_VERSION}-distro.tar.gz"

cd "${OOZIE_HOME}"

if [ ! -d libext ]
then
	show_progress "Create folder ${OOZIE_HOME}/libext"
	sudo mkdir libext
fi

# wget http://dev.sencha.com/deploy/ext-2.2.zip

if [ ! -f libext/ext-2.2.zip ]
then
	show_progress "Copy ${OOZIE_INSTALL_SCRIPT_FOLDER}/ext-2.2.zip to ${OOZIE_HOME}/libext/"
	sudo cp "${OOZIE_INSTALL_SCRIPT_FOLDER}/ext-2.2.zip" libext/
fi

show_progress "Copy customized oozie-site.xml to ${OOZIE_HOME}/conf"
sudo cp "${OOZIE_INSTALL_SCRIPT_FOLDER}/oozie-site.xml" "${OOZIE_HOME}/conf/"
sudo sed -i "s#{HADOOP_HOME}#${HADOOP_HOME}#g" "${OOZIE_HOME}/conf/oozie-site.xml"

show_progress "Prepare oozie war"
sudo -i "${OOZIE_HOME}/bin/oozie-setup.sh" prepare-war 

# The fllowing command should be run under the ${HADOOP_USER} 
# show_progress "Sharelib to hdfs"
# sudo -i "${OOZIE_HOME}/bin/oozie-setup.sh" sharelib -fs hdfs://${HADOOP_NN_HOST}:8020
#  
# show_progress "Create oozie DB"
# sudo -i "${OOZIE_HOME}/bin/ooziedb.sh" create -sqlfile oozie.sql -run
 
sudo ln -fs "${OOZIE_HOME}" "${OOZIE_ROOT}/oozie"
sudo chown -R ${HADOOP_USER}:${HADOOP_USER} "${OOZIE_ROOT}"

append_to_file_once "export OOZIE_HOME=${OOZIE_ROOT}/oozie" /etc/profile.d/hadoop.sh
popd

echo -e "\e[32m"
echo "-----------------------------------------------------------------------------------------------------------"
echo "- Congratulations. Your oozie have been installed successfully.                                           -" 
echo "-                                                                                                         -"
echo "- The next step(s):                                                                                       -"
echo "-     login as hadoop user, and then:                                                                     -"
echo "-         1) run '\${OOZIE_HOME}/bin/oozie-setup.sh sharelib create -fs hdfs://nn.hadoop.local:8020 to    -"
echo "-            upload shared lib to dfs. replace nn.hadoop.local according to your name node ip/hostname.   -"
echo "-         2) run '\${OOZIE_HOME}/bin/ooziedb.sh create -sqlfile oozie.sql -run' to create oozie DB        -"
echo "-         3) run '\${OOZIE_HOME}/bin/oozied.sh start to startup oozie server                              -"
echo "-                                                                                                         -"
echo "- Refers to README for more detail                                                                        -"
echo "-----------------------------------------------------------------------------------------------------------"
echo -e "\e[0m"
