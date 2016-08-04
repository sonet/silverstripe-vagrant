#!/usr/bin/env bash

# Install the CenrOS Software Collection (SCL)
yum install -y centos-release-scl

# Add the Remi repository
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm
cp /vagrant/etc/pki/rpm-gpg/RPM-GPG-KEY-remi /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
#rpm --import http://rpms.remirepo.net/RPM-GPG-KEY-remi
cp /vagrant/etc/yum.repos.d/remi.repo /etc/yum.repos.d/

# Accept the EPEL gpg key
rpm --import http://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6
yum install -y epel-release

# Install the EPEL Node.js
yum install -y nodejs npm --enablerepo=epel

# Install the servers including PHP w/ modules
yum install -y httpd postgresql-server postgresql-contrib php php-pear php-devel php-snmp php-xml php-xmlrpc php-soap php-ldap php-pgsql php-mcrypt php-mbstring php-gd php-tidy php-pspell php-pecl-memcache php-tcpdf vim git --enablerepo=remi php-xcache xcache-admin
chkconfig httpd on

# use use a custom PHP configuration
cp /vagrant/etc/php.ini /etc

# make the php temporary writable to the web server user
mkdir -p /var/lib/php/session/
chown -R vagrant:vagrant /var/lib/php/session/

# Setup the Apache web server
cp /vagrant/etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf
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
service httpd start

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

# Download the latest composer.phar version
if [ ! -f /usr/local/bin/composer ]; then
curl -s https://getcomposer.org/installer | php
# Move to bin path
mv composer.phar /usr/local/bin/composer
else
/usr/local/bin/composer --quiet self-update
fi

# Custom environment variables, aliases & paths
cp /vagrant/home/.bashrc /home/vagrant
cp /vagrant/home/.bash_aliases /home/vagrant

# start the apache server on vagrant mounted
cp /vagrant/etc/init/vagrant-mounted.conf /etc/init
