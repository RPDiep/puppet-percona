puppet-percona
==============

A puppet module for installing [Percona Server](http://www.percona.com/software/percona-server) 5.5.

Requires [puppetlabs-mysql](https://github.com/puppetlabs/puppetlabs-mysql).

Just declare as follows:

```ruby
class {'puppet-percona':
  mysqlrootpassword => 'CHANGEME',
}
```
