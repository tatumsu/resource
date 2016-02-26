#!/bin/bash

MAVEN_ROOT=/opt/maven
MAVEN_VERSION=3.3.9
MAVEN_REPO_FOLDER=/opt/maven/repository

OOZIE_ROOT=/opt/oozie
OOZIE_VERSION=4.2.0

OOZIE_CONFIG_SCRIPT_FOLDER=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )

#-------------------- The following configuration probably does not need to be changed--------------------------#

DEBUG=yes

MAVEN_HOME=${MAVEN_ROOT}/apache-maven-${MAVEN_VERSION}
LEAST_MAVEN_VERSION=3.0.5
LEAST_MAVEN_VERSION_NUMBER=30005
MAVEN_TAR_FILE=apache-maven-${MAVEN_VERSION}-bin.tar.gz

OOZIE_BUILD_ROOT=/tmp/oozie
OOZIE_BUILD_HOME=${OOZIE_BUILD_ROOT}/oozie-${OOZIE_VERSION}
OOZIE_TAR_FILE=oozie-${OOZIE_VERSION}.tar.gz
OOZIE_HOME="${OOZIE_ROOT}/oozie-${OOZIE_VERSION}"
OOZIE_DIST_FOLDER=${OOZIE_BUILD_HOME}/distro/target
OOZIE_GENERATE_DOC=no

# get the hadoop configuration
source $OOZIE_CONFIG_SCRIPT_FOLDER/../hadoop/configure.sh

