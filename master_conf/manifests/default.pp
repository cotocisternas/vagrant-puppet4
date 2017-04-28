#Quick Manifest to stand up a demo Puppet Master

node default {

  file { '/etc/puppetlabs/puppet/puppet.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    source  => '/vagrant/puppet/puppet.conf',
  }

  file { '/etc/puppetlabs/puppet/autosign.conf':
    ensure  => 'file',
    content => '*',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/puppetlabs/code/environments/production/hiera.yaml':
    ensure  => link,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => '/vagrant/puppet/hiera.yaml',
  }

  file { '/etc/puppetlabs/code/environments/production/environment.conf':
    ensure  => link,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => '/vagrant/puppet/environment.conf',
  }

  file { '/etc/puppetlabs/code/environments/production/site.pp':
    ensure  => link,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => '/vagrant/puppet/site.pp',
  }

  class { 'puppetdb':
    listen_address      => '0.0.0.0',
    ssl_set_cert_paths  => true,
  }

  class { 'puppetdb::master::config': }

}
