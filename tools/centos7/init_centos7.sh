#!/bin/bash

set -e

source ../common.sh
show_progress "Copy alias to /etc/profile.d"
cp ../alias.sh /etc/profile.d/alias.sh

show_progress "Install tools"
bash ../install_system_tools.sh

bash ./install_python3.sh


