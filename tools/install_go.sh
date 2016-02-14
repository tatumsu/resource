set -e

show_progress()
{
  echo -e "\e[32m******************$1******************\e[0m"
}

show_error()
{
  echo -e "\e[31m$1\e[0m"
}

show_progress "Download go for linux 64 version"
if [ -f ~/software ]
then
    mkdir ~/software
fi


go version > /dev/nul
if [ $? -eq 0 ]; then
    show_progress "Go is already installed"
else
    cd ~/software
    show_progress "Download go tar file"
    wget https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz
    sha1sum go1.5.1.linux-amd64.tar.gz | grep '46eecd290d8803887dec718c691cc243f2175fe0'
    show_progress "Install go"
    sudo -s -- <<EOF
      tar -C /usr/local -xzf ~/software/go1.5.1.linux-amd64.tar.gz
      cat /etc/profile | grep "PATH:/usr/local/go/bin" || echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
EOF
fi

show_progress "Install and enable pathogen"
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cat ~/.vimrc | grep 'execute pathogen#infect()' || echo 'execute pathogen#infect()' >>  ~/.vimrc

show_progress "Install vim-go development plugin"
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go