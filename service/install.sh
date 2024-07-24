#!/bin/bash
set -e
version=$1
binUrl="https://github.com/erfan-272758/eifa-gateway-deploy/releases/download/v$version/server"
serviceName="eifa-gateway.service"
repoUrl="https://raw.githubusercontent.com/erfan-272758/eifa-gateway-deploy/main"

# requirements
requirements(){
    sudo apt update -y
    sudo apt install -y wget
}

# download raw file
download(){
    wget -O /tmp/eifa-gateway $binUrl
}
# create service
create_service(){
    wget -O /tmp/$serviceName $repoUrl/service/$serviceName
    sudo mv /tmp/$serviceName /etc/systemd/system/$serviceName
}

#  copy config
copy_files(){
    # bin file
    sudo mv /tmp/eifa-gateway /usr/local/bin/eifa-gateway
   
    # config file
    sudo mkdir -p /etc/eifa-gateway
    if [ -e ./config.yml ] 
    then
        sudo cp ./config.yml /etc/eifa-gateway/
    else
        sudo wget -O /etc/eifa-gateway/config.yml $repoUrl/config.yml
    
    fi
    if [ -e ./server-list.yml ] 
    then
        sudo cp ./server-list.yml /etc/eifa-gateway/
    fi

    # set ownership
    sudo chown root:root /usr/local/bin/eifa-gateway
    sudo chmod 700 /usr/local/bin/eifa-gateway
    sudo chown -R  root:root /etc/eifa-gateway
    sudo chmod -R  600 /etc/eifa-gateway/*
    
}

# start service
start_service(){
    sudo systemctl daemon-reload
    sudo systemctl enable $serviceName
    sudo systemctl start $serviceName
}

requirements
download
copy_files
create_service
start_service