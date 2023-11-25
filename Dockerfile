# Use ubuntu for the base image
FROM ubuntu:latest

# Run update 
RUN apt-get update

# Run upgrade
RUN apt-get upgrade -y

# Install dependencies
RUN apt-get install sudo syslog-ng openssh-server vsftpd samba whois geoip-bin -y

# Add user "dev" and add to sudo for testing
# RUN useradd -rm -d /home/dev -s /bin/bash -G sudo dev 

# change user password for testing
# RUN echo 'dev:dev' | chpasswd

# createdirectory for samba share
RUN mkdir /Desktop

# copy script 
COPY ./src /src

# Run scrips
CMD ["/src/start.sh"]

# expose port 22
EXPOSE 22 21 445 139
