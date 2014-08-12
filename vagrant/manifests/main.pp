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
  path    => ['/usr/local/rbenv/shims', '/bin', '/usr/bin'],
} ->
package { 'libpq-dev': 
  ensure => latest,
} ->
exec { 'Installing Dependencies...':
  command => 'bundle install',
  path    => ['/usr/local/rbenv/shims', '/bin', '/usr/bin'],
  cwd     => '/vagrant',
} ->
exec { 'Reloading Rbenv Shims...':
  command => 'rbenv rehash',
  path    => ['/usr/local/rbenv/bin', '/bin', '/usr/bin'],
} ->
exec { 'Granting Write Access to Gems Folder...':
  command => 'chown -R vagrant /usr/local/rbenv && chmod -R u+rX /usr/local/rbenv',
  path    => ['/bin'],
} 

exec { 'Set up databases...':
  command => 'rake db:setup',
  path    => ['/usr/local/rbenv/versions/2.1.2/bin', '/bin', '/usr/bin'],
  cwd     => '/vagrant',
  require => [Exec['Installing Dependencies...'], Class['postgresql::server']]
}

## 
#
# Uncomment to have memorizor automatically run on startup
#
#file { '/etc/init.d/memorizor':
#  ensure    => file,
#  source    => 'puppet:///modules/startup/memorizor',
#  owner     => root,
#  group     => root,
#  mode      => '0755',
#  require   => [Exec['Set up databases...'], Class['redis']]
#} ->
#service { 'memorizor' :
#  ensure    => running,
#  enable    => true,
#}

package { 'libsqlite3-dev': 
  ensure => latest,
}

exec { 'Installing Mailcatcher...':
  command => 'gem install mailcatcher --no-ri --no-rdoc',
  path    => ['/usr/local/rbenv/shims', '/bin', '/usr/bin'],
  require => [Exec['Installing Dependencies...'], Package['libsqlite3-dev']],
} ->
file { '/etc/init.d/mailcatcher':
  ensure    => file,
  source    => 'puppet:///modules/startup/mailcatcher',
  owner     => root,
  group     => root,
  mode      => '0755', 
} ->
service { 'mailcatcher' :
  ensure    => running,
  enable    => true,
  hasstatus => false,  
} 
