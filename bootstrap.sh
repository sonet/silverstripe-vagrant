#!/usr/bin/env bash

# Update the system and install the servers
yum install -y httpd postgresql94-server
chkconfig httpd on

#install PHP including modules
yum install -y httpd php-devel php-snmp php-xml php-xmlrpc php-soap php-ldap php-pgsql php-mcrypt php-mbstring php-gd php-tidy php-pspell php-pecl-memcache

# use use a custom PHP configuration
cp /vagrant/etc/php.ini /etc

# isntall the PostgeSQL database
PGDIR="/var/lib/pgsql/data"
if ! [ "$(ls -A $PGDIR)" ]; then
	echo $PGSIR "Initializing postgres db"
	service postgresql initdb --locale en_US.UTF-8 --pwfile=/vagrant/etc/pgsql/pg_pw
	chkconfig postgresql on
	cp /vagrant/etc/pgsql/pg_hba.conf /var/lib/pgsql/data/
fi
service postgresql start

# Setup the web server's root directory
if ! [ -L /var/www ]; then
	rm -rf /var/www
	ln -fs /vagrant /var/www
fi
if ! [ -d /vagrant/html ]; then
	mkdir /vagrant/html
fi

# Prevent the Apache warning "Could not reliably determine the server's fully qualified domain name"
cp /vagrant/etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf

service httpd start

if [ ! -f /usr/local/bin/composer ]; then
	# download the latest composer.phar version
	curl -s https://getcomposer.org/installer | php

	# Move to bin path
	mv composer.phar /usr/local/bin/composer
else
	/usr/local/bin/composer self-update
fi
