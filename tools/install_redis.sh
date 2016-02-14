#!/bin/bash

set -e

DOWNLOAD_FOLDER=~/software
DEFAULT_VERSION=3.0.6

source ./common.sh
read  -p "Please select the redis version to be installed: [$DEFAULT_VERSION] " REDIS_VERSION
while ! echo $REDIS_VERSION | egrep -q '^[0-9]\.[0-9]\.[0-9]$' ; then
    echo "Selecting default: $_REDIS_PORT"
    REDIS_VERSION=$_REDIS_VERSION
fi

if [ ! -d "${DOWNLOAD_FOLDER}" ] 
then
    echo "folder ~/software does not exist, create it"
    mkdir -p ${DOWNLOAD_FOLDER}
fi

show_progress "Download redis tar file"
cd "$DOWNLOAD_FOLDER"
wget http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz

show_progress "Untar and make redis"
tar xzf redis-${REDIS_VERSION}.tar.gz
cd redis-${REDIS_VERSION}
make

cd src
show_progress "Copy redis executable to /usr/bin"
sudo find -type f -executable -exec cp {} /usr/bin/ \;

show_progress "Install redis server"
cd ../utils
sudo ./install_server.sh
