node default {
  include docker
  include nomad

  user {'vagrant':
    ensure     => present,
    groups     => ['docker'],
    membership => 'minimum',
  }
}
