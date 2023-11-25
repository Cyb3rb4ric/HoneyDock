# Honeydock - Dockerized Honeypot for Security Monitoring

## Description

Honeydock is a Dockerized honeypot designed for security monitoring. Operating within a Docker container, it logs and analyzes bad authentication attempts across services like SSH, SMB, and FTP, capturing crucial details such as log time, username, and source IP addresses. The program offers real-time prompts for immediate threat awareness and stores logs outside the container for in-depth analysis. Honeydock also passively collects IP geolocation and WHOIS information for each source IP connection, providing valuable context to potential security threats. The tool supports simultaneous deployment of multiple honeypot services through the use of multiple threads, ensuring comprehensive monitoring capabilities.

## Features

- Real-time logging and analysis of bad authentication attempts.
- Support for SSH, SMB, and FTP services.
- Passive collection of IP geolocation and WHOIS information.
- Dockerized for easy deployment and management.
- Simultaneous deployment of multiple honeypot services.

## Installation

To install Honeydock, follow these steps:

1. Download or clone the Honeydock repository.
2. Navigate to the Honeydock directory.
3. Run the following command as sudo to install the honeypot:
```bash
   sudo bash install.sh
```

## Usage

1. Run the Honeydock script with Docker privileges:
```bash
    sudo honeydock
```
2. After starting the program, a menu will prompt you to choose the honeypot services to run.
3. Follow the on-screen instructions to select the desired services and customize your honeypot deployment.

## Options

- Select from the interactive menu the honeypot services you want to run.

## Note

- Use Honeydock responsibly and in compliance with legal and ethical guidelines.
- Ensure that you have appropriate permissions before deploying honeypots on a network.
- Honeydock is a powerful tool that can have significant implications, so exercise caution.

## Author

Author: Cyb3rb4ric
Email - magencyber@proton.me
Network Security school project

---
