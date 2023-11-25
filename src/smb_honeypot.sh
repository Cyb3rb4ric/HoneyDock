#!/bin/bash

LOG_FILE=$1
RAW_LOG_FILE=/var/log/smbd.log

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
function RUN_SMB_SERVICE(){
    sudo smbd -s /src/smb.conf > /dev/null
}

# Parser new logs and write them to file.
function PARSER(){
    while IFS= read -r line; do
        workgroup=$(echo -e "$line" | grep -oP "user \[\K[^\]]+")
        user=$(echo -e "$line" | awk -F'at ' '{gsub(/\\/, ""); print $1}' | awk -F'user ' '{print $NF}' |grep -oP '\[[^]]+\]' | sed -n '2p' | sed 's/[][]//g')
        month=$(echo -e "$line" | grep -oP "at \[\K[^\]]+" | awk '{print $3}')
        day=$(echo -e "$line" | grep -oP "at \[\K[^\]]+" | awk '{print $2}')
        time=$(echo -e "$line" | grep -oP "at \[\K[^\]]+" | awk '{print $5}' | awk -F'.' '{print $1}')
        ip=$(echo -e "$line" | grep -oP "remote host \[\K[^\]]+" | awk -F':' '{print $2}')
        workstation=$(echo -e "$line" | grep -oP "workstation \[\K[^\]]+")
        SCAN_TARGET $ip
        echo -e "$month $day $time - SMB - Workgroup:\"$workgroup\", Username:\"$user\", Workstation:\"$workstation\", Address:$ip, GeoIP:\"$geoip\"" >> "$LOG_FILE"
    done
}

# Reads authentication logs and pass them to parser.
function SMB_LOGGER(){
    tail -f -n 0 $RAW_LOG_FILE |
    grep --line-buffered 'Auth:' |
    PARSER;
}

RUN_SMB_SERVICE
SMB_LOGGER