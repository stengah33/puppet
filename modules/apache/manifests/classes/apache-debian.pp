class apache::debian inherits apache::base {

  include apache::params

  # BEGIN inheritance from apache::base
  Exec["apache-graceful"] {
    command => "apache2ctl graceful",
    onlyif => "apache2ctl configtest",
  }

  File["logrotate configuration"] {
    path => "/etc/logrotate.d/apache2",
    source => "puppet:///apache/etc/logrotate.d/apache2",
  }

  File["default status module configuration"] {
    path => "${apache::params::conf}/mods-available/status.conf",
    source => "puppet:///apache/etc/apache2/mods-available/status.conf",
  }

  File["default virtualhost"] {
    path => "${apache::params::conf}/sites-available/default",
    content => template("apache/default-vhost.debian"),
  }
  # END inheritance from apache::base

  package {["apache2-mpm-prefork", "libapache2-mod-proxy-html"]:
    ensure  => installed,
    require => Package["apache"],
  }

  # directory not present in lenny
  file { "${apache::params::root}/apache2-default":
    ensure => absent,
    force  => true,
  }

  file { "${apache::params::root}/index.html":
    ensure => absent,
  }

  file { "${apache::params::root}/html":
    ensure  => directory,
  }

  file { "${apache::params::root}/html/index.html":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 644,
    content => "<html><body><h1>It works!</h1></body></html>\n",
  }

  file { "${apache::params::conf}/conf.d/servername.conf":
    content => "ServerName ${hostname}\n",
    notify  => Service["apache"],
    require => Package["apache"],
  }

  file { "${apache::params::conf}/sites-available/default-ssl":
    ensure => absent,
    force => true,
  }

  package { ["libapache2-mod-php5","php5-cgi","php5-cli","php5-common","php5-curl","php5-gd","php5-mcrypt","php5-memcache","php5-mysql","php5-sqlite"]:
	ensure => installed,
  }

  #package { "memcached":
	#ensure => installed,
#  }
  

}
