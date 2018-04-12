#!/bin/bash
# touch File
touch /JacobWasHere
# Update APT repository
apt-get -y update
# Install Software
apt-get -y install docker docker.io
apt-get -y install apache2
apt-get -y install php
apt-get -y install php-mysql
apt-get -y install mysql-client
apt-get -y install nginx
apt-get -y install privoxy
apt-get -y install sssd adcli realmd  samba-common
#apt-get -y install sssd realmd adcli krb5-workstation samba-common
apt-get -y install expect unzip nmap nfs-client rsync screen diffutils lsof 
apt-get -y install tcpdump telnet netcat traceroute wget perl curl

# Define VARIABLES
myHOST=“yumaweb.westus.cloudapp.azure.com”
myMyuSQLHOST=“den1.mysql6.gear.host”
myUser=“guacamoledb”
myPassword=“Of022_E5KvL-”

# Guacamole Install
docker run --name some-guacd -d guacamole/guacd
# Install Start Docker
docker run --name some-guacamole --link some-guacd:guacd \
    -e MYSQL_HOSTNAME=den1.mysql6.gear.host \
    -e MYSQL_DATABASE=guacamoledb  \
    -e MYSQL_USER=guacamoledb    \
    -e MYSQL_PASSWORD=Of022_E5KvL- \
    -d -p 8080:8080 guacamole/guacamole

# Fix Guacamole Tomcat Configuration
# Get Tomcat Config and Update
wget https://raw.githubusercontent.com/jchirayath/aws/master/s3/config/tomcat-users.xml
docker cp tomcat-users.xml some-guacamole:/usr/local/tomcat/conf/tomcat-users.xml 
docker restart some-guacamole 

# Get Updated Index.htm
wget https://raw.githubusercontent.com/jchirayath/aws/master/s3/config/index.html
cp index.html /var/www/html/index.html
