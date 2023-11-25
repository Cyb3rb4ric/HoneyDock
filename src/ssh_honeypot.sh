#!/bin/bash

LOG_FILE=$1
RAW_LOG_FILE=/var/log/auth.log

# Preform geoiplookup and whois on target IP address and save to file.
function SCAN_TARGET(){
    target_ip=$1
    if [ ! -d "/log/$target_ip" ]; then
        mkdir "/log/$target_ip"
        geoiplookup $target_ip >> /log/$target_ip/geoiplookup.txt
        whois $target_ip >> /log/$target_ip/whois.txt        
    fi
    geoip=$(cat /log/$target_ip/geoiplookup.txt | awk -F':' '{print $2}')
    if [ "$geoip" == " IP Address not found" ]; then
        geoip="Local"
    fi
}

# Run honeypot service.
function RUN_SSH_SERVICE(){
    sudo service ssh start > /dev/null
}

# Parser new logs and write them to file.
function PARSER(){
    while IFS= read -r line; do
        time=$(echo -e "$line" | awk '{print $1,$2,$3}' )
        ip=$(echo -e "$line" | awk '{print $(NF-3)}' )
        username=$(echo -e "$line" | awk '{print $(NF-5)}' )
        SCAN_TARGET $ip
        echo -e "$time - SSH - Username:\"$username\", Address:$ip, GeoIP:\"$geoip\"" >> "$LOG_FILE" 
    done
}

# Reads authentication logs and pass them to parser.
function SSH_LOGGER(){
    tail -f -n 0 $RAW_LOG_FILE |
    grep --line-buffered 'sshd' |
    grep --line-buffered -e 'Failed password' |
    PARSER;
}

RUN_SSH_SERVICE
SSH_LOGGER