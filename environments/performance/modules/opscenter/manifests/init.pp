class opscenter($listen_interface, $port = 8888) {

  package { 'opscenter-free':
    ensure  => installed,
  }
  
  file { '/etc/opscenter/opscenterd.conf':
    ensure  => present,
    content => template('opscenterd.conf.erb'),
    requires => Package['opscenter-free'],
    notify => Service['opscenterd'],
  }
  
  service { 'opscenterd':
    ensure  => 'running',
    enable  => 'true',
    require => Package['opscenter-free'],
  }
  
}