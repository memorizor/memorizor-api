class { 'postgresql::globals':
  version  => '9.3',
}->
class { 'postgresql::server': }

postgresql::server::role {'memorizor':
  password_hash => '',
  login         => true,
  createdb      => true,
}

postgresql::server::pg_hba_rule { 'local trust all':
  description => 'trust all local connections',
  type        => 'local',
  database    => 'all',
  user        => 'all',
  auth_method => 'trust',
  order       => 000,
 }

postgresql::server::pg_hba_rule { 'IPv4 local trust all':
  description => 'trust all IPv4 local connections',
  type        => 'host',
  database    => 'all',
  user        => 'all',
  address     => '127.0.0.1/32',
  auth_method => 'trust',
  order       => 001,
}

postgresql::server::pg_hba_rule { 'IPv6 local trust all':
  description => 'trust all IPv6 local connections',
  type        => 'host',
  database    => 'all',
  user        => 'all',
  address     => '::1/128',
  auth_method => 'trust',
  order       => 002,
}

class { 'redis': }

class { 'rbenv':
  latest => true,
}

rbenv::plugin { 'sstephenson/ruby-build': }

rbenv::build { '2.1.2': 
  global => true 
} ->
exec { 'Installing Bundler...':
  command => 'gem install bundler --no-ri --no-rdoc',
  path    => ['/bin', '/usr/bin', '/usr/local/rbenv/shims'],
  cwd     => '/vagrant',
} ->
package { 'libpq-dev': 
  ensure => latest,
} ->
exec { 'Installing Dependencies...':
  command => 'bundle install',
  path    => ['/bin', '/usr/bin', '/usr/local/rbenv/shims'],
  cwd     => '/vagrant',
} ->
exec { 'Granting Write Acess to Gems Folder...':
  command => 'chown -R vagrant /usr/local/rbenv && chmod -R u+rX /usr/local/rbenv',
  path    => ['/bin'],
} 

