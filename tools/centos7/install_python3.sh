#!/bin/bash
set -e

# cat /etc/redhat-release  | grep 7.* 

sudo yum -y install python34
sudo python3.4 get-pip.py
sudo pip3 install ipython

echo "Python 3.4 and IPython for python 3 is installed sccessfully. You can use python3.4 and ipython3 to launch them"
