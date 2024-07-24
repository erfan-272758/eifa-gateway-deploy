#!/bin/bash
set -e
version=$1
binUrl="https://github.com/erfan-272758/eifa-gateway-deploy/releases/download/v$version/server"
serviceName="eifa-gateway.service"
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
    sudo cat > "/tmp/$serviceName" <<EOF
[Unit]
Description=Eifa Gateway - A lightweight proxy service
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=3
StartLimitIntervalSec=0
StartLimitBurst=0
User=root
WorkingDirectory=/etc/eifa-gateway
ExecStart=/usr/local/bin/eifa-gateway

[Install]
WantedBy=multi-user.target
EOF
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
    fi
    if [ -e ./config.yml ] 
    then
        sudo cp ./config.yml /etc/eifa-gateway/
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