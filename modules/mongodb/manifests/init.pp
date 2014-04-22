class mongodb ($version = '2.6.0') {

  apt::source {'mongodb':
    entries => [
      'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen',
    ],
    keys => {
      'mongodb' => {
        'key' => '7F0CEB10',
        'key_server' => 'keyserver.ubuntu.com',
      }
    },
  }

  user {'mongodb':
    ensure => present,
    system => true,
  }

  file {
    '/var/lib/mongodb':
      ensure  => directory,
      mode    => '0644',
      owner   => 'mongodb',
      group   => 'mongodb';

    '/etc/mongodb':
      ensure  => directory,
      mode    => '0644',
      owner   => 'mongodb',
      group   => 'mongodb';

    '/etc/init.d/mongod':
      ensure  => file,
      content => template('mongodb/init-replacement'),
      mode    => '0755',
      owner   => 0,
      group   => 0,
      notify  => Service['mongod'];

    '/etc/mongod.conf':
      ensure => absent;
  }
  ~>

  exec {'/etc/init.d/mongod stop && update-rc.d -f mongod remove':
    path => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    refreshonly => true,
  }

  package {'mongodb-org':
    ensure => $version,
    require => [ Apt::Source['mongodb'] ]
  }

  service {'mongod': }

}
