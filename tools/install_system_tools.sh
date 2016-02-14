export SOFTWARE_FOLDER='~/software'

if [[ -d $SOFTWARE_FOLDER ]]
then
    mkdir $SOFTWARE_FOLDER
fi

cd $SOFTWARE_FOLDER

yum -C repolist | grep "Extra Packages for Enterprise Linux"
if [ $? -eq 0 ]
then
    
    if [ is_centos7 = 0 ]
    then
        wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
        sudo rpm -ivh epel-release-6-8.noarch.rpm
    else
        sudo yum install epel-release
    fi
fi

sudo yum install man mlocate htop wget curl vim

sudo yum groupinstall "Development Tools"

# install basic vim setting
cat basic.vim >> ~/.vimrc
