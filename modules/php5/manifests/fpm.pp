class php5::fpm {

  require 'php5'
  include 'php5::config_extension_change'

  file {'/etc/php5/fpm':
    ensure => directory,
    owner => '0',
    group => '0',
    mode => '0755',
  }

  file {['/etc/php5/fpm/pool.d', '/var/log/php5-fpm']:
    ensure => directory,
    owner => '0',
    group => '0',
    mode => '0755',
  }

  file {'/etc/php5/fpm/php-fpm.conf':
    ensure => file,
    content => template("${module_name}/fpm/php-fpm.conf"),
    owner => '0',
    group => '0',
    mode => '0644',
    before => Package['php5-fpm'],
    notify => Service['php5-fpm'],
  }

  file {'/var/log/php5-fpm/php5-fpm.log':
    ensure => file,
    owner => '0',
    group => '0',
    mode => '0644',
    before => Package['php5-fpm'],
    notify => Service['php5-fpm'],
  }

  file {'/etc/php5/fpm/pool.d/www.conf':
    ensure => file,
    content => template("${module_name}/fpm/www.conf"),
    owner => '0',
    group => '0',
    mode => '0644',
    before => Package['php5-fpm'],
    notify => Service['php5-fpm'],
  }

  php5::config {'/etc/php5/fpm/php.ini':
    before => Package['php5-fpm'],
    notify => Service['php5-fpm'],
  }

  logrotate::entry{'php5-fpm':
    content => template("${module_name}/logrotate-fpm"),
    before => Package['php5-fpm'],
  }

  package {'php5-fpm':
    ensure => present,
  }

  service {'php5-fpm':
    require => Package['php5-fpm'],
    subscribe => Class['php5::config_extension_change'],
  }

  @monit::entry {'php5-fpm':
    content => template("${module_name}/fpm/monit"),
    require => Service['php5-fpm'],
  }

  @bipbip::entry {'php5-fpm':
    plugin => 'fastcgi-php-fpm',
    options => {
      'host' => 'localhost',
      'port' => 9000,
      'path' => '/fpm-status',
    }
  }

  @php5::fpm::with_apc {'php5-fpm':
    host => 'localhost',
    port => 9000,
  }

  @php5::fpm::with_opcache {'php5-fpm':
    host => 'localhost',
    port => 9000,
  }

}
