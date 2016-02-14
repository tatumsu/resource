#!/bin/bash
pushd .
GIT_VERSION=2.6.0
# If a GIT version equal to greater than this is installed ,skip
LEAST_GIT_VERSION_NUMBER=10900
GIT_USER=tatum.su
GIT_EMAIL=tatum.su@163.com
psudh .

source ~/.bashrc
source ./common.sh
EXISTING_GIT_VERSION=$(git --version 2>/dev/null | egrep -o "[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}" 2>/dev/null)
if [ $? == 0 ]
then
    EXISTING_GIT_VERSION_NUMBER=$(git --version | egrep -o "[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}" | tr '\.' '0')
    echo "Existing GIT version: $EXISTING_GIT_VERSION"
    echo "To be installed GIT version: $GIT_VERSION"
    sleep 3
    if [ $EXISTING_GIT_VERSION_NUMBER -gt $LEAST_GIT_VERSION_NUMBER ]
    then
	    show_error "GIT ${EXISTING_GIT_VERSION} is already installed on this box, SKIP..." && exit 0
    fi
fi

git --version > /dev/null 2>&1
if [ $? == 0 ]
then
	get_install_option "REMOVE_EXISTING_GIT" "yes|y|no|n" "Would you like to uninstall the existing git? (yes(y)|no(n))"
 	if [ $REMOVE_EXISTING_GIT == "yes" ] || [ $REMOVE_EXISTING_GIT == "y" ]
    then
        sudo yum -y remove git
    else
        "Keep existing GIT and exit..." && exit 0
    fi
fi

show_progress 'Install required dependency'
sudo yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker

show_progress 'Download GIT source'
if [ ! -d ~/software ]
then
	mkdir ~/software
fi

cd ~/software
if [ ! -f git-$GIT_VERSION.tar.gz ]
then
    wget https://www.kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.gz
fi

tar xzf git-$GIT_VERSION.tar.gz

show_progress 'Make and install'
cd git-$GIT_VERSION
make prefix=/usr/local/git all
sudo make prefix=/usr/local/git install

append_to_file_once ~/.bashrc "export PATH=\$PATH:/usr/local/git/bin"
source ~/.bashrc

show_progress 'Check git version'
git --version

show_progress 'Configure git'
git config --global user.name ${GIT_USER}
git config --global user.email ${GIT_EMAIL}

sudo yum install -y unzip

popd

pushd .
cp git.zip /tmp/
cd /tmp
unzip git.zip
cd vm_keys
eval "$(ssh-agent -s)"
ssh-add id_rsa_git
popd

git remote set-url origin git@github.com:tatumsu/study.git

show_progress 'Your git has been installed successfully under /usrlocal/git'
