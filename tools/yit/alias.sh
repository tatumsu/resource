alias editrc='vim ~/.bashrc'

alias dockers='docker ps -a'

export EXTERNAL_IP=$(ip address | grep eth1 | grep inet | tr -s ' ' | cut -d ' ' -f3 | cut -d '/' -f1)
GITLAB_ROOT=~/gitlab

SOURCE_FOLDER=$GITLAB_ROOT/backend/yit_magento_based
COMPOSE_FOLDER=$GITLAB_ROOT/operation/docker/docker_files/magento-compose
NGINX_FOLDER=$GITLAB_ROOT/operation/docker/docker_files/magento-nginx
PHP_FOLDER=$GITLAB_ROOT/operation/docker/docker_files/magento-php

alias cdsrc="cd $GITLAB_ROOT/backend/yit_magento_based"
alias cdnginx="cd $GITLAB_ROOT/operation/docker/docker_files/magento-nginx"
alias cdphp="cd $GITLAB_ROOT/operation/docker/docker_files/magento-php"
alias cdscript="cd $GITLAB_ROOT/operation/docker/scripts/ubuntu"
alias cdcompose-m2="cd $GITLAB_ROOT/operation/docker/docker_files/magento-compose/ci/m2"
alias cdcompose-t2="cd $GITLAB_ROOT/operation/docker/docker_files/magento-compose/ci/t2"
alias cdcompose-my="cd $GITLAB_ROOT/operation/docker/docker_files/magento-compose/my/dev"

alias sshsite="docker exec -it yit-magento-site-${EXTERNAL_IP} /bin/bash"
alias sshphp="docker exec -it yit-php-${EXTERNAL_IP} /bin/bash"
alias sshnginx="docker exec -it yit-nginx-${EXTERNAL_IP} /bin/bash"
alias sshredis="docker exec -it yit-redis-${EXTERNAL_IP} /bin/bash"
alias sshmysql="docker exec -it yit-mysql-${EXTERNAL_IP} /bin/bash"
alias logs="docker-compose logs -f $COMPOSE_FOLDER/my/dev/docker-compose.yml"

alias logs="docker-compose -f $COMPOSE_FOLDER/my/dev/docker-compose.yml logs -f --tail=100"

alias ll='ls -al'
alias start_dev_site="docker run -it --env-file /tmp/env.sh --name magento-site --rm registry.docker.yit.com/dev/magento-site:latest"
alias start_t2_site="docker run -it --env-file /tmp/env.sh --name magento-site --rm registry.docker.yit.com/ci/magento-site-t2:latest"
alias start_m2_site="docker run -it --env-file /tmp/env.sh --name magento-site --rm registry.docker.yit.com/ci/magento-site-m2:latest"

alias gdc='git diff --cached'
alias gs='git status'
alias gc='git commit'

function init_gitlab() {
    pushd .
    mkdir -p $GITLAB_ROOT/backend $GITLAB_ROOT/operation
    cd $GITLAB_ROOT/backend && git clone ssh://git@gitlab.yit.com:10022/backend/yit_magento_based.git
    cd $GITLAB_ROOT/operation && git clone ssh://git@gitlab.yit.com:10022/operation/docker.git
    popd
}

function check_git_status(){
    pushd .
    echo "------------------------------Project docker-----------------------------------"
    cd $GITLAB_ROOT/operation/docker && git status

    echo "------------------------------Project yit_magento_based-----------------------------------"
    cd $GITLAB_ROOT/backend/yit_magento_based && git status
    popd
}
