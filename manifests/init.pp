class puppet-percona ( $mysqlrootpassword  = undef, ) {
  
  if $mysqlrootpassword == undef {
    fail('$mysqlrootpassword is not set in declaration.')
  }

  case $operatingsystem {

    centos, redhat: {
      $client_package_name = ['Percona-Server-client-55','Percona-Server-shared-compat','Percona-Server-shared-55']
      $server_package_name = 'Percona-Server-server-55'
      $pidfile             = "/var/lib/mysql/${hostname}.pid"
      $perconarequires     = Package['percona-release']

      package {'percona-release':
        ensure   => installed,
        provider => rpm,
        source   => 'http://www.percona.com/redir/downloads/percona-release/percona-release-0.0-1.x86_64.rpm',
      }
    }

    ubuntu: {
      $client_package_name = ['percona-server-client-5.5','percona-server-common-5.5']
      $server_package_name = 'percona-server-server-5.5'
      $pidfile             = "/var/run/mysqld/mysqld.pid"
      $perconarequires     = Apt::Source['percona']
    
      apt::source { 'percona': 
        location    => 'http://repo.percona.com/apt',
        release     => $lsbdistcodename,
        repos       => 'main',
        key         => 'CD2EFD2A',
        key_server  => 'keyserver.ubuntu.com',
        include_src => true,
      }
    }

  }

  class {'mysql':
    client_package_name => $client_package_name,
    server_package_name => $server_package_name,
    pidfile             => $pidfile,
    service_name        => 'mysql',
    require             => $perconarequires,
  }

  class {'mysql::server':
    config_hash => { 'root_password' => $mysqlrootpassword },
    require     => Class['mysql'],
  }

  class {'mysql::server::account_security': 
    require => Service['mysqld'],
  }

  exec { "drop-emptyusers":
    command => "/usr/bin/mysql --defaults-extra-file=/root/.my.cnf -e \"drop user ''@'%'\"",
    onlyif  => "/usr/bin/mysql --defaults-extra-file=/root/.my.cnf -sNe \"SELECT Host FROM mysql.db where User=''\" |grep -q '.'",
    require => Service['mysqld'],
  }

}
