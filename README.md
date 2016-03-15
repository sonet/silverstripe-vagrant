# Vagrant Silverstripe Development Environment

A base Apache PostgreSQL server for SilverStripe development.

## Getting Started

Log on to the development server with:

`vagrant ssh`

The following commands will install SilverStripe inside the devs server's root directory:

```
composer create-project silverstripe/installer /var/www/html

composer require --no-update "silverstripe/postgresql:1.2.*"

composer update
```

Alternatively just checkout your project repository into the above directory.

After the above steps have been completed the SilverStripe installer or your site is going to be available at: http://localhost:4567

### PostgreSQL Database Access

To access the database use the following:

```
sudo -i -u postgres
psql
```

