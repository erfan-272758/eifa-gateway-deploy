#!/bin/bash
set -e
version=$1
repoUrl="https://raw.githubusercontent.com/erfan-272758/eifa-gateway-deploy/main"
composeCmd=""
work_dir="/opt/eifa-gateway"

# requirements
requirements(){
    echo "### Check Requirements ###"
    if docker-compose 2>/dev/null 1>/dev/null
    then
        composeCmd="docker-compose"
    elif docker compose 2>/dev/null 1>/dev/null
    then
        composeCmd="docker compose"
    else
        echo "please install docker compose"
        exit 1
    fi

    echo "### Install Requirements ###"
    if ! envsubst --version 1>/dev/null 2>/dev/null
    then
        sudo apt update -y
        sudo apt install -y gettext
    fi
}



#  copy config
copy_files(){
    echo "### Download and Copy Config Files ###"
    # work dir
    sudo mkdir -p $work_dir

    # download compose file and config file
    sudo wget -O $work_dir/docker-compose.yml $repoUrl/docker/docker-compose.yml
    sudo wget -O $work_dir/config.yml $repoUrl/config.yml

    # create server-list file
    sudo touch $work_dir/server-list.yml

    # set ownership
    sudo chown -R  root:root $work_dir
    sudo chmod -R  775 $work_dir    
}

# compose up
compose_up(){
    echo "### Start ###"
    export VERSION=v$version
    envsubst < $work_dir/docker-compose.yml > /tmp/docker-compose.yml.tmp
    sudo mv /tmp/docker-compose.yml.tmp $work_dir/docker-compose.yml
    cd $work_dir
    sudo $composeCmd up -d
}

requirements
copy_files
compose_up