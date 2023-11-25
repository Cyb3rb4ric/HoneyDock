#!/bin/bash

###########################################################
# Honeydock - Dockerized Honeypot for Security Monitoring #
###########################################################

# Description:
# Honeydock is a Dockerized honeypot designed for security monitoring. Operating within a Docker container,
# it logs and analyzes bad authentication attempts across services like SSH, SMB, and FTP, capturing crucial
# details such as log time, username, and source IP addresses. The program offers real-time prompts for
# immediate threat awareness and stores logs outside the container for in-depth analysis. Honeydock also
# passively collects IP geolocation and WHOIS information for each source IP connection, providing valuable
# context to potential security threats. The tool supports simultaneous deployment of multiple honeypots
# services through the use of multiple threads, ensuring comprehensive monitoring capabilities.

# Prerequisites:
# - Ensure that the script is executed with root privileges (sudo) due to its nature.
# - Run the "install.sh" script as sudo to set up the program:
#   ```bash
#   sudo install.sh
#   ```

# Usage:
# 1. Run the script with root privileges and provide one of the available options.
#   ```bash
#    sudo honeydock
#   ```
# 2. After starting the program, a menu will prompt you to choose the honeypot services to run.
# 3. Follow the on-screen instructions to select the desired services and customize your honeypot deployment.

# Note:
# - Use this tool responsibly and in compliance with legal and ethical guidelines.
# - Ensure that you have appropriate permissions before scanning or probing any network.
# - Netvuln is a powerful tool that can have significant implications, so exercise caution.

# Author: Cyb3rb4ric
# Email - magencyber@proton.me
# Network Security school project

#######################################################################

SSH_PORT=22     # Change if necessary 
FTP_PORT=21     # Change if necessary
SMB1_PORT=139   # Change if necessary
SMB2_PORT=445   # Change if necessary


# Checks if the script is executed with sudo privileges and exits if not.
function CHECK_SUDO(){
    if [ "$EUID" -ne 0 ]
        then echo "Please run with sudo."
        exit 1
    fi
}

# GET the working directory of the script to the directory where the script is located.
function GET_SCRIPT_HOME(){
    script_path=$(readlink -f "$0") 
    SCRIPTHOME=$( cd -P "$(dirname "$script_path")" || exit 1 ; pwd -P )
}

# Prints ASCII art.
function WELCOME(){
    cat "$SCRIPTHOME"/welcome.txt
    echo " "
}

# let the user pick the honey pot services to run.
function MENU(){
    echo "[*] Please choose a honeypot service:"
    echo " " 
    echo "1 - SSH"
    echo "2 - SMB"
    echo "3 - FTP"
    echo "4 - All services"
    echo " "
    read -p "[?] Enter your choice: " choice
    echo " "
    case $choice in
    "1")
        trap cleanup SIGINT
        echo "[+] Starting SSH service."
        sudo docker run --rm -d -p $SSH_PORT:22 --name honeydock -v "$SCRIPTHOME/log:/log" honeydock 1> /dev/null &;;
    "2")
        trap cleanup SIGINT
        echo "[+] Starting SMB service."
        sudo docker run --rm -d -p $SMB1_PORT:139 -p $SMB2_PORT:445 --name honeydock -v "$SCRIPTHOME/log:/log" honeydock 1> /dev/null &;;
    "3")
        trap cleanup SIGINT
        echo "[+] Starting FTP service."
        sudo docker run --rm -d -p $FTP_PORT:21 --name honeydock -v "$SCRIPTHOME/log:/log" honeydock 1> /dev/null &;;
    "4")
        trap cleanup SIGINT
        echo "[+] Starting all services."
        sudo docker run --rm -d -p $SSH_PORT:22 -p $FTP_PORT:21 -p $SMB1_PORT:139 -p $SMB2_PORT:445 --name honeydock -v "$SCRIPTHOME/log:/log" honeydock 1> /dev/null &;;
    *)
        exit 1;;  
esac
}

# live view of new logs.
function MONITOR(){
    echo " "
    echo "--------------------------------------------------------------------"
    tail -f -n 0 "$SCRIPTHOME/log/honey.log"
}

# Closing Honeypot services.
function cleanup() {
    echo " "
    echo "--------------------------------------------------------------------"
    echo "[*] Closing container."
    sudo docker container stop "$(sudo docker container ps -qf "name=honeydock")" 1> /dev/null
    echo "[+] Done"
    exit 0
}


CHECK_SUDO
GET_SCRIPT_HOME
WELCOME
MENU
MONITOR