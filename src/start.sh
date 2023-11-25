#!/bin/bash

LOG_FILE=/log/honey.log

# Starts log service.
function START_LOG(){
    sudo service syslog-ng restart > /dev/null 2>&1
    touch /var/log/auth.log
}

# Start all honeypots.
function START_SERVICES(){
    source "/src/ssh_honeypot.sh" $LOG_FILE &
    source "/src/smb_honeypot.sh" $LOG_FILE &
    source "/src/ftp_honeypot.sh" $LOG_FILE &
    sleep infinity
}

START_LOG
START_SERVICES

