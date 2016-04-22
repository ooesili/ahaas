class nomad {
  $version = "0.3.1"
  $nomad_directory = '/var/lib/nomad'
  $server_conf = "$nomad_directory/server.hcl"
  $client_conf = "$nomad_directory/client.hcl"
  $server_init = '/etc/init/nomad-server.conf'
  $client_init = '/etc/init/nomad-client.conf'

  # download and extract nomad
  package {'unzip':
    ensure => present,
  }
  archive {'nomad':
    ensure        => present,
    url           => "https://releases.hashicorp.com/nomad/${version}/nomad_${version}_linux_amd64.zip",
    extension     => 'zip',
    root_dir      => 'nomad',
    digest_string => '467fcebe9f0a349063a4f16c97cb71d9c57451fc1f10cdb2292761cf56542671',
    digest_type   => 'sha256',
    target        => '/usr/local/bin',
    require       => Package['unzip'],
  }

  file {$nomad_directory:
    ensure => directory,
    mode   => '0600',
  }

  # server
  file {$server_conf:
    ensure => file,
    source => 'puppet:///modules/nomad/server.hcl',
    mode   => '0644',
  }
  file {$server_init:
    ensure  => file,
    source  => 'puppet:///modules/nomad/nomad-server.conf',
    mode    => '0644',
    require => File[$server_conf],
  }
  service {'nomad-server':
    ensure    => running,
    enable    => true,
    subscribe => [
      Archive['nomad'],
      File[$server_init],
      File[$server_conf],
    ],
  }

  # client
  file {$client_conf:
    ensure => file,
    source => 'puppet:///modules/nomad/client.hcl',
    mode   => '0644',
  }
  file {$client_init:
    ensure  => file,
    source  => 'puppet:///modules/nomad/nomad-client.conf',
    mode    => '0644',
    require => File[$client_conf],
  }
  service {'nomad-client':
    ensure    => running,
    enable    => true,
    subscribe => [
      Archive['nomad'],
      File[$client_init],
      File[$client_conf],
    ],
  }
}
