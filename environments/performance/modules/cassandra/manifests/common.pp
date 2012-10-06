#
# = Class cassandra::common
#

class cassandra::common(
    $owner          = 'cassandra',
    $group          = 'cassandra',
    $hosts          = [ '127.0.0.1' ],
    $listen_address = 'null',
    $cluster_name   = 'Cassandra Cluster',
    $cassandra_home = '/usr/share/cassandra') {

	$release = $operatingsystem ? {
		/CentOS|RedHat/ => $lsbmajdistrelease,
		/Amazon|Linux/ => '6'
	}

	yumrepo { "datastax":
		name => "datastax",
		baseurl => "http://rpm.datastax.com/community",
		enabled => '1',
		gpgcheck => '0',
	}

	package { 'dsc1.1':
		ensure => installed,
		require => Yumrepo['datastax'],
	}

  file { 'cassandra.yaml': 
    path => '/etc/cassandra/conf/cassandra.yaml', 
    ensure => present,
    mode => 0640,
    owner => $owner,
    group => $group,
    content => template('cassandra/cassandra.yaml.erb'),
    require => Package['dsc1.1'],
  }

  file { 'cassandra-env.sh': 
    path => '/etc/cassandra/conf/cassandra-env.sh', 
    ensure => present,
    mode => 0755,
    owner => $owner,
    group => $group,
    content => template('cassandra/cassandra-env.sh.erb'),
    require => Package['dsc1.1'],
  }
  
  file { '/etc/security/limits.conf':
    ensure  =>  present,
    content =>  template('cassandra/limits.conf.erb'),
  }

  ## Further set system limits:
  exec { 'sysctl-max-map-count':
    command =>  '/sbin/sysctl -w vm.max_map_count=131072',
  }

}
