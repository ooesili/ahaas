class docker (String $package = 'docker.io') {
  package {$package:
    ensure => present,
  }
  service {'docker':
    ensure    => running,
    enable    => true,
    require   => Package[$package],
  }
}
