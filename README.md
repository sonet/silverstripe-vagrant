# Vagrant PHP Silverstripe & Node.js w/ PostgreSQL Dev Environment

This is a base vagrant virtual RHEL 6 based system with Apache, PHP 5.4, PostgreSQL, and Node.js intended for SilverStripe development work or Node.js work.
The default ports are:

| Guest | Host | Function                         |
|-------|------|----------------------------------|
| 80    | 8080 | Apache HTTP                      |
| 3000  | 3000 | Node.js                          |
| 5432  | 8006 | PostgreSQL                       |

Development Only
===
This Vagrant set up is for development use only it is deliberately in-secure and designed to be easy to access and work on with no consideration given to the security implications of this. Do not put this environment on any public network or use it for configuring external web servers.

## Getting Started

Log on to the development server with:

`vagrant ssh`

The following will install SilverStripe inside the dev server's root directory:

```
composer create-project silverstripe/installer /var/www/html

composer require --no-update "silverstripe/postgresql:1.2.*"

composer update
```

Alternatively checkout your project repository into the above directory.

After the above steps have been completed the SilverStripe installer or your site is going to be available at: http://localhost:8080

### PostgreSQL Database Access

To access the database use the following:

```
sudo -i -u postgres
psql
```
