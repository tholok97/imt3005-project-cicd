class profile::base {

  # the base profile should include component modules that will be on all nodes

  file { '/root/basefile':
    ensure => 'present',
  }
}
