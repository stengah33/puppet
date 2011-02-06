class apache::params {

  $pkg = $operatingsystem ? {
    /RedHat|CentOS/ => 'httpd',
    /Debian|Ubuntu/ => 'apache2',
    /debian|ubuntu/ => 'apache2',
  }

  $root = $operatingsystem ? {
    /RedHat|CentOS/ => '/var/www/vhosts',
    /Debian|Ubuntu/ => '/var/www',
    /debian|ubuntu/ => '/var/www',
  }

  $user = $operatingsystem ? {
    /RedHat|CentOS/ => 'apache',
    /Debian|Ubuntu/ => 'www-data',
    /debian|ubuntu/ => 'www-data',
  }

  $conf = $operatingsystem ? {
    /RedHat|CentOS/ => '/etc/httpd',
    /Debian|Ubuntu/ => '/etc/apache2',
    /debian|ubuntu/ => '/etc/apache2',
  }

  $cgi = $operatingsystem ? {
    /RedHat|CentOS/ => '/var/www/cgi-bin',
    /Debian|Ubuntu/ => '/usr/lib/cgi-bin',
    /debian|ubuntu/ => '/usr/lib/cgi-bin',
  }

  $log = $operatingsystem ? {
    /RedHat|CentOS/ => '/var/log/httpd',
    /Debian|Ubuntu/ => '/var/log/apache2',
    /debian|ubuntu/ => '/var/log/apache2',
  }

}
