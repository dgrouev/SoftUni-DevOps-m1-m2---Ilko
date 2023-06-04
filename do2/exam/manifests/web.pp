$packages = [ 'httpd', 'php', 'php-mysqlnd', 'git' ]

package { $packages: }

vcsrepo { '/code':
  ensure => present,
  provider => git,
  source => 'https://github.com/shekeriev/do2-app-pack.git',
}

file_line { 'hosts-web':
  ensure => present,
  path => '/etc/hosts',
  line => '192.168.99.101  web.do2.lab  web',
  match => '^192.168.99.101',
}

file_line { 'hosts-db':
  ensure => present,
  path => '/etc/hosts',
  line => '192.168.99.102  db.do2.lab  db',
  match => '^192.168.99.102',
}

file { '/etc/httpd/conf.d/vhost-app3.conf':
  ensure => present,
  content => 'Listen 8081
<VirtualHost *:8081>
    DocumentRoot "/var/www/app3"
</VirtualHost>',
}

file { '/etc/httpd/conf.d/vhost-app4.conf':
  ensure => present,
  content => 'Listen 8082
<VirtualHost *:8082>
    DocumentRoot "/var/www/app4"
</VirtualHost>',
}

file { '/var/www/app3':
  ensure => 'directory',
  recurse => true,
  source => '/code/app3/web',
}

file { '/var/www/app4':
  ensure => 'directory',
  recurse => true,
  source => '/code/app4/web',
}

class {'firewall':}

firewall { '000 accept 8081/tcp':
  action => 'accept',
  dport => 8081,
  proto => 'tcp',
}

firewall { '001 accept 8082/tcp':
  action => 'accept',
  dport => 8082,
  proto => 'tcp',
}

class { selinux: 
  mode => 'permissive',
}

service { httpd:
  ensure => running,
  enable => true,
}
