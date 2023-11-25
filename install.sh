#!/bin/bash

LOCAL_REQUIREMENTS=("docker.io")

# Check/Install local host requirements.
function INSTALL_LOCAL_DEPENDENCIES(){
    deinstall=$(dpkg --get-selections | grep deinstall | cut -f1)
    sudo dpkg --purge "$deinstall" >/dev/null 2>&1
    for package_name in "${LOCAL_REQUIREMENTS[@]}"; do
        dpkg -s "$package_name" >/dev/null 2>&1 || 
        (echo -e "\n[*] installing $package_name..." &&
        sudo apt-get install "$package_name" -y)
    done
}

# Checks if the script is execut1ed with sudo privileges and exits if not.
function CHECK_SUDO(){
    if [ "$EUID" -ne 0 ]
        then echo "Please run with sudo."
        exit 1
    fi
}

# Create log dir and file.
function CREATE_LOG_FILE(){
    echo -e "\n[*] Creating Log file"
    SCRIPTHOME=$( cd "$(dirname "$0")" || exit 1 ; pwd -P )
    mkdir "$SCRIPTHOME/log" 2>/dev/null
    touch "$SCRIPTHOME/log/honey.log"
}


# Create symbolic link in bin folder for making 'netshark' a command on the system.
function CREATE_SYMBOLIC_LINKS(){
    echo -e "\n[*] Creating symbolic link."
    sudo rm /usr/local/bin/honeydock 2>/dev/null
    ln -s "$SCRIPTHOME"/honeydock.sh /usr/local/bin/honeydock
    sudo rm /var/log/honey.log 2>/dev/null
    ln -s "$SCRIPTHOME"/log/honey.log /var/log/honey.log
}

# Build the docker image.
function DOCKER_BUILD(){
    echo -e "\n[*] Building docker image"
    cd "$SCRIPTHOME" || exit
    sudo docker build -t honeydock .  
}

CHECK_SUDO
INSTALL_LOCAL_DEPENDENCIES
CREATE_LOG_FILE
CREATE_SYMBOLIC_LINKS
DOCKER_BUILD
echo "[*] Done!"
