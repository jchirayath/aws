#!/bin/bash
# Update APT repository
apt-get -y update
# Install Software
apt-get -y install docker
apt-get -y install apache2
apt-get -y install php
apt-get -y install php-mysql
apt-get -y install mysql
apt-get -y install nginx
apt-get -y install privoxy
apt-get -y install sssd adcli realmd sssd-krb5-common krb5-user samba-common
#apt-get -y install sssd realmd adcli krb5-workstation samba-common
apt-get -y install expect unzip nmap nfs-utils rsync screen diffutils lsof 
apt-get -y install tcpdump telnet nc traceroute wget perl curl

# Create user jacobc and copy keys
sudo adduser jacobc -m  -d /home/jacobc -c "Jacob Chirayath" 
sudo cp -pr  /home/ec2-user/.ssh /home/jacobc/.ssh
sudo chown -R jacobc:jacobc /home/jacobc/.ssh
sudo usermod -aG wheel jacobc
sudo usermod -aG docker jacobc
sudo usermod -aG docker ec2-user
# Start Docker Service
sudo service docker start
# Guacamole Install
sudo docker run --name some-guacd -d guacamole/guacd
# Install Start Docker
docker run --name some-guacamole --link some-guacd:guacd \
    -e MYSQL_HOSTNAME=mysql.aws.aspl.net  \
    -e MYSQL_DATABASE=guacamole_db  \
    -e MYSQL_USER=guacamole_user    \
    -e MYSQL_PASSWORD=Guacam0le \
    -d -p 8080:8080 guacamole/guacamole
# Check if MySQL DB Exists
CheckDB=`mysqlshow  -h mysql.aws.aspl.net -uadmin -pMySQL264 | grep guacamole_d `
if [ $? == 1 ]; then
	# Create the DB
	echo “Creating the Guacamole MySQL DB Instance”
	sudo docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql
	aws s3 cp s3://jchirayath/config/mysqlCreateGuacUser.sql mysqlCreateGuacUser.sql
	# Get DataBase config file
	# Execute the DB Connections
	mysql -h mysql.aws.aspl.net -uadmin -pMySQL264 < mysqlCreateGuacUser.sql
	mysql -h mysql.aws.aspl.net -uadmin -pMySQL264 guacamole_db < initdb.sql
else
	echo “DB Exists”
fi
# Fix Guacamole Tomcat Configuration
aws s3 cp s3://jchirayath/config/tomcat-users.xml tomcat-users.xml
docker cp tomcat-users.xml some-guacamole:/usr/local/tomcat/conf/tomcat-users.xml 
docker restart some-guacamole 
# Copy all the configuration Files needed
sudo aws s3 cp s3://jchirayath/config/httpd.conf /etc/httpd/conf/httpd.conf
sudo aws s3 cp s3://jchirayath/config/nginx.conf /etc/nginx/nginx.conf
sudo aws s3 cp s3://jchirayath/config/usr-share-nginx-html-index.html  /usr/share/nginx/html/index.html
sudo aws s3 cp s3://jchirayath/config/var-www-html-index.html  /var/www/html/index.html
# Fix config Files
sudo groupadd www
sudo usermod -a -G www ec2-user
sudo chown -R root:www /var/www
sudo chmod 2775 /var/www
sudo find /var/www -type d -exec chmod 2775 {} +
sudo find /var/www -type f -exec chmod 0664 {} +
sudo sh -c 'echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php'
# Starting Services
sudo service httpd start
sudo service nginx start
sudo service privoxy start
# Config service Startup
sudo chkconfig httpd on
sudo chkconfig nginx on
sudo chkconfig privoxy on
# Fix SSH Port 443
cat << EOF >> /etc/ssh/sshd_config
Port 22
Port 443
EOF
sudo sshd restart

## One Time to Create Guacamole DB and Configuration File
# Run the Guacamole scrip to generate the MySQL config file
sudo docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql
# Get DataBase config file
cat << EOF  > mysqlCreateDB.sql
CREATE DATABASE guacamole_db;
CREATE USER ‘guacamole_user’@‘%’ IDENTIFIED BY ‘Guacam0le’;
GRANT SELECT,INSERT,UPDATE,DELETE ON guacamole_db.* TO 'guacamole_user'@'%';
FLUSH PRIVILEGES;
quit;
EOF
# Execute the DB Connections
mysql -h mysql.aws.aspl.net -uadmin -pMySQL264 < mysqlCreateDB.sql
mysql -h mysql.aws.aspl.net -uadmin -pMySQL264 guacamole_db < initdb.sql.sql
