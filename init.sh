#!/usr/bin/env bash

# Accept the EPEL gpg key
rpm --import http://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6

# Update the system and install the main servers
yum install -y httpd postgresql-server postgresql-contrib
chkconfig httpd on

# Install the EPEL repository and Node.js
yum -y install epel-release
yum -y install nodejs npm --enablerepo=epel

#install PHP including modules
yum install -y httpd php-devel php-snmp php-xml php-xmlrpc php-soap php-ldap php-pgsql php-mcrypt php-mbstring php-gd php-tidy php-pspell php-pecl-memcache

# Install some useful development tools
yum install -y vim git

# use use a custom PHP configuration
cp /vagrant/etc/php.ini /etc

# make the php temporary writable to the web server user
chown -R vagrant:vagrant /var/lib/php/session/

# Setup the PostgeSQL database
PGDIR="/var/lib/pgsql/data"
USER="postgres"
if ! [ -d $PGDIR ] || ! [ "$(ls -A $PGDIR)" ]; then
echo "Setting up postgresql in $PGDIR"
mkdir -p $PGDIR
chown -R postgres:postgres /var/lib/pgsql/
service postgresql initdb --locale en_US.UTF-8 -U postgres
cp /vagrant/etc/pgsql/pg_hba.conf $PGDIR
chown -R postgres:postgres /var/lib/pgsql/

chkconfig postgresql on
fi
service postgresql start
# Post install PostgreSQL setup steps
sudo -i -u postgres psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'vagrant12345';"
cp /vagrant/etc/pgsql/pg_hba_md5.conf /var/lib/pgsql/data/pg_hba.conf
cp /vagrant/etc/pgsql/postgresql.conf /var/lib/pgsql/data/postgresql.conf
chown -R postgres:postgres /var/lib/pgsql/
service postgresql restart

# Setup the web servers root directory
if ! [ -L /var/www ]; then
rm -rf /var/www
ln -fs /vagrant /var/www
fi
if ! [ -d /vagrant/html ]; then
mkdir /vagrant/html
fi
if ! [ -d /vagrant/node ]; then
mkdir /vagrant/node
fi

# Prevent the Apache warning "Could not reliably determine the server's fully qualified domain name"
cp /vagrant/etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf

service httpd start

if [ ! -f /usr/local/bin/composer ]; then
# Download the latest composer.phar version
curl -s https://getcomposer.org/installer | php

# Move to bin path
mv composer.phar /usr/local/bin/composer
else
/usr/local/bin/composer --quiet self-update
fi

# Custom environment variables, aliases & paths
cp /vagrant/home/.bashrc /home/vagrant
cp /vagrant/home/.bash_aliases /home/vagrant
