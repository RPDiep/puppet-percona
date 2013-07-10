puppet-percona
==============

A puppet module for installing Percona Server 5.5. 

Requires puppetlabs-mysql.

Just declare as follows:

```class {'puppet-percona':
  mysqlrootpassword => 'CHANGEME',
}```
