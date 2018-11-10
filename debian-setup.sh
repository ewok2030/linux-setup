#!/bin/sh

## bashrc
cp ./home/.bashrc ~/.bashrc

## setup apt
sudo add-apt-repository universe
sudo apt install -y apt-transport-https

## vscode
# https://code.visualstudio.com/docs/setup/linux
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

## git
# using git from the Ubuntu repos

## node.js
curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh

## docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

## python
# Use python from Ubuntu repos

## azure cli 2.0
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

## golang
# Just use the version from Ubuntu repo
#sudo add-apt-repository ppa:gophers/archive

## kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

## --------------------------------------------------------------------------- ##
## remove packages
sudo apt remove libre-office* rhythmbox evolution empathy
sudo apt autoremove

## golang
#wget -q https://storage.googleapis.com/golang/getgo/installer_linux
#chmod +x installer_linux 

## nodejs
# assuming script downloaded from above
sudo bash nodesource_setup.sh

## install packages
sudo apt update
sudo apt install -y \
    build-essential \
    wget \
    curl \
    docker-ce \
    code \
    git \
    azure-cli \
    golang-go \
    python3-pip \
    kubectl

## docker
# add the current user to the Docker group, so they dont have to use sudo
sudo usermod -aG docker ${USER}
