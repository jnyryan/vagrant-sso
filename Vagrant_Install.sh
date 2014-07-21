#!/bin/bash

####################
# Prerequisites

SRC=${APPSOURCE:-/vagrant/}

apt-get update
apt-get install -y git subversion curl htop

####################
# apache2 server
apt-get install -y apache2
apt-get install -y php5
apt-get install -y libapache2-mod-php5
/etc/init.d/apache2 restart

apt-get install -y php5-curl php5-mcrypt php5-gmp

echo "extension=mcrypt.so" >> /etc/php5/cli/php.ini
echo "extension=mcrypt.so" >>  /etc/php5/mods-available/mcrypt.ini

####################
# SimpleSaml
cd /var
git clone https://github.com/simplesamlphp/simplesamlphp.git
cd /var/simplesamlphp
mkdir -p  config && cp -r config-templates/* config/
mkdir -p metadata && cp -r metadata-templates/* metadata/
cp /vagrant/etc/simplesamlphp/config.php /var/simplesamlphp/config/config.php 
cp /vagrant/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf


curl -sS https://getcomposer.org/installer | php
sudo php composer.phar install
apachectl restart

exit
####################
# LDAP Server
apt-get install -y slapd ldap-utils
dpkg-reconfigure slapd

# LDAP PHP Admin 
sudo apt-get install -y phpldapadmin
sudo cp /vagrant/etc/phpldapadmin/config.php /etc/phpldapadmin/config.php 
