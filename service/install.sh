#!/bin/bash

binUrl=""
serviceName="eifa-gateway.service"
# requirements
requirements(){
    apt update -y
    apt install -y wget
}

# download raw file
download(){
    wget -o /tmp/eifa-gateway $binUrl
}
# create service
create_service(){
    sudo cat > "/etc/systemd/system/$serviceName" <<EOF
[Unit]
Description=Eifa Gateway - A lightweight proxy service
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
WorkingDirectory=/etc/eifa-gateway
ExecStart=/usr/local/bin/eifa-gateway

[Install]
WantedBy=multi-user.target
EOF
}

#  copy config
copy_files(){
    # bin file
    sudo cp /tmp/eifa-gateway /usr/local/bin/eifa-gateway
   
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
    sudo chmod -R  400 /etc/eifa-gateway/*
    
}

# start service
start_service(){
    sudo systemctl daemon-reload
    sudo systemctl enable --now $serviceName
}

requirements
download
copy_files
create_service
start_service