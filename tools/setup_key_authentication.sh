#!/bin/bash

KEY_FILE_NAME=id_rsa_hadoop
SSH_USER=hadoop
#SSH_SERVER_LIST="192.168.0.141 192.168.0.142 192.168.0.143 192.168.0.146"
SSH_SERVER_LIST="192.168.0.146"

set -e

cd /tmp
if [ ! -d .ssh ]
then
	mkdir .ssh
fi

cd .ssh
ssh-keygen -t rsa -N "" -f "${KEY_FILE_NAME}"

cd ..
for SSH_SERVER in ${SSH_SERVER_LIST}
do
	scp -r .ssh "${SSH_USER}@${SSH_SERVER}:~/"
 	#ssh ${SSH_USER}@${SSH_SERVER} 'cat >> .ssh/authorized_keys'
	#ssh ${SSH_USER}@${SSH_SERVER} "chmod 700 .ssh; chmod 640 .ssh/authorized_keys"
done
